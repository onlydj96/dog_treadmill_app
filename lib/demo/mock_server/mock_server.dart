import 'dart:math';

import '../../core/utils/json.dart';
import 'booking_api.dart';
import 'device_simulators.dart';
import 'mock_db.dart';
import 'ranking_api.dart';
import 'seed.dart';

export 'booking_api.dart';
export 'device_simulators.dart';
export 'mock_db.dart';
export 'ranking_api.dart';
export 'seed.dart' show DemoAccount;

/// 데모 앱의 목업 서버. 실제 Supabase(Postgres 함수·트리거·Realtime·Storage) 대신 앱 안에서 돈다.
///
/// - [db]: 테이블 (실제와 같은 이름·컬럼의 JSON 행)
/// - [booking], [ranking]: DB 함수를 같은 규칙·같은 오류 코드로 옮긴 것
/// - [treadmill], [analysis]: 아직 연동 전인 트레드밀 기기와 AI 서버를 흉내 낸다
///
/// 네트워크를 쓰지 않으므로 인터넷 없이도 동작하고, 실제 서버의 데이터를 건드리지 않는다.
class MockServer {
  MockServer({
    this.latency = const Duration(milliseconds: 250),
    DateTime Function()? clock,
    int? randomSeed,
  }) : db = MockDb(clock: clock ?? DateTime.now, random: Random(randomSeed)) {
    booking = BookingApi(db, onCheckedIn: (row) => treadmill.onCheckedIn(row));
    ranking = RankingApi(db);
    analysis = AiAnalysisSimulator(db);
    treadmill = TreadmillSimulator(db, booking: booking, ranking: ranking, analysis: analysis);
    reset();
  }

  /// 저장소 호출마다 기다리는 시간 (로딩 표시가 실제처럼 보이도록). 테스트에서는 0.
  final Duration latency;
  final MockDb db;
  late final BookingApi booking;
  late final RankingApi ranking;
  late final AiAnalysisSimulator analysis;
  late final TreadmillSimulator treadmill;

  Future<void> simulateLatency() => latency == Duration.zero ? Future<void>.value() : Future<void>.delayed(latency);

  /// 처음 상태(샘플 데이터)로 되돌린다. 로그인도 풀린다.
  void reset() {
    treadmill.stopAll();
    analysis.cancelTimers();
    db.clear();
    MockSeed(db, booking: booking, ranking: ranking).run();
  }

  void dispose() {
    treadmill.stopAll();
    analysis.cancelTimers();
  }

  // ---------------------------------------------------------------------
  // Auth (GoTrue) + 가입 트리거 (private.handle_new_user)
  // ---------------------------------------------------------------------

  Json? accountByEmail(String email) {
    final normalized = email.trim().toLowerCase();
    return db.find('auth_users', (a) => (a['email'] as String).toLowerCase() == normalized);
  }

  /// 가입: 프로필(닉네임 자동 생성)과 동의 이력을 만든다. 이메일 인증 없이 바로 로그인된다(로컬 Supabase와 같음).
  String createAccount({
    required String email,
    required String password,
    required String name,
    required String phone,
    required List<(String type, String version, bool granted)> consents,
  }) {
    final id = db.newId();
    final now = iso(db.now());
    db
      ..insert('auth_users', {'id': id, 'email': email.trim(), 'password': password})
      ..insert('users', {
        'id': id,
        'name': name.trim().isEmpty ? email.split('@').first : name.trim(),
        'phone': phone.trim().isEmpty ? null : phone.trim(),
        'role': 'user',
        'notification_prefs': {
          'booking': true,
          'exercise': true,
          'analysis': true,
          'ranking': true,
          'marketing': false
        },
        'nickname': ranking.generateNickname(),
        'nickname_updated_at': null,
        'ranking_show_photo': true,
        'managed_branch_id': null,
        'created_at': now,
      });
    for (final (type, version, granted) in consents) {
      db.insert('data_consents', {
        'user_id': id,
        'consent_type': type,
        'consent_version': version,
        'granted': granted,
        'responded_at': now,
      });
    }
    return id;
  }

  /// Edge Function delete-account: 계정과 개인 데이터를 지운다. 결제 기록은 user_id만 비우고 남긴다.
  void deleteAccount(String userId) {
    final dogIds = db.where('dogs', (d) => d['owner_id'] == userId).map((d) => d['id']).toSet();
    for (final table in ['notifications', 'data_consents', 'inquiries', 'memberships', 'ranking_cheers', 'bookings']) {
      db.delete(table, (r) => r['user_id'] == userId);
    }
    for (final table in [
      'exercise_sessions',
      'analysis_reports',
      'dog_health_profiles',
      'exercise_plans',
      'dog_badges'
    ]) {
      db.delete(table, (r) => dogIds.contains(r['dog_id']));
    }
    db
      ..delete('exercise_points', (r) => r['owner_id'] == userId)
      ..delete('monthly_awards', (r) => r['owner_id'] == userId)
      ..delete('ranking_cheers', (r) => dogIds.contains(r['dog_id']))
      ..delete('dogs', (r) => r['owner_id'] == userId)
      ..delete('users', (r) => r['id'] == userId)
      ..delete('auth_users', (r) => r['id'] == userId);
    for (final payment in db.where('payments', (p) => p['user_id'] == userId).toList()) {
      db.update('payments', payment, {'user_id': null});
    }
  }

  /// 데모 컨트롤 "응원 받기": 이번 달 아직 응원하지 않은 다른 참여 보호자 한 명이 응원한다.
  /// 응원한 보호자의 닉네임을 돌려주고, 응원할 사람이 없으면 null.
  String? cheerFromAnotherUser(String dogId) {
    final ownerId = db.byId('dogs', dogId)?['owner_id'];
    final month = toDateString(ranking.currentMonth());
    final candidates = db
        .where(
          'users',
          (u) =>
              u['id'] != ownerId &&
              db.hasConsent(u.str('id'), 'ranking') &&
              !db.table('ranking_cheers').any(
                    (c) => c['dog_id'] == dogId && c['user_id'] == u['id'] && c['period_month'] == month,
                  ),
        )
        .toList();
    if (candidates.isEmpty) return null;
    final user = candidates[db.random.nextInt(candidates.length)];
    ranking.cheer(dogId, asUserId: user.str('id'));
    return user['nickname'] as String?;
  }

  // ---------------------------------------------------------------------
  // 반려견 트리거
  // ---------------------------------------------------------------------

  /// private.apply_breed_catalog: 카탈로그 견종이면 견종명·체구·단두종을 카탈로그 값으로 맞춘다.
  void applyBreedCatalog(Json dog) {
    final breed = db.byId('breeds', dog['breed_id'] as String?);
    if (breed == null) return;
    dog
      ..['breed'] = breed['name']
      ..['size_class'] = breed['size_class']
      ..['is_brachycephalic'] = breed['is_brachycephalic']
      ..['is_mixed'] = false;
  }

  /// private.normalize_condition_codes: 카탈로그에 없는 코드는 거절하고, 중복 제거·정렬해 저장한다.
  List<String>? normalizeConditionCodes(List<String>? codes) {
    if (codes == null) return null;
    final known = db.table('health_conditions').map((c) => c['code']).toSet();
    if (codes.any((c) => !known.contains(c))) rpcError('UNKNOWN_CONDITION_CODE', '23503');
    return codes.toSet().toList()..sort();
  }
}
