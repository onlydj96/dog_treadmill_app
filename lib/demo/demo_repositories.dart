import 'dart:convert';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart' show StorageException;

import '../core/utils/json.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/booking/data/booking_models.dart';
import '../features/booking/data/booking_repository.dart';
import '../features/consents/data/consent.dart';
import '../features/consents/data/consent_repository.dart';
import '../features/dogs/data/dog.dart';
import '../features/dogs/data/dog_repository.dart';
import '../features/exercise/data/exercise_repository.dart';
import '../features/exercise/data/exercise_session.dart';
import '../features/health/data/analysis_models.dart';
import '../features/health/data/analysis_repository.dart';
import '../features/membership/data/membership_models.dart';
import '../features/membership/data/membership_repository.dart';
import '../features/notifications/data/notification_repository.dart';
import '../features/profile/data/app_user.dart';
import '../features/profile/data/user_repository.dart';
import '../features/ranking/data/ranking_models.dart';
import '../features/ranking/data/ranking_repository.dart';
import '../features/support/data/support_repository.dart';
import 'demo_auth.dart';
import 'mock_server/mock_server.dart';

// 실제 저장소(lib/features/*/data/*_repository.dart)와 같은 인터페이스를 목업 서버로 구현한다.
// 행은 실제 Supabase 응답과 같은 JSON이라 모델의 fromJson을 그대로 쓴다.

DateTime _monthOf(DateTime month) => DateTime.utc(month.year, month.month);

int _byText(Json a, Json b, String key) => a.str(key).compareTo(b.str(key));

abstract class _DemoRepository {
  _DemoRepository(this.server);

  final MockServer server;

  MockDb get db => server.db;

  Future<void> wait() => server.simulateLatency();
}

class DemoAuthRepository extends _DemoRepository implements AuthRepository {
  DemoAuthRepository(super.server, this.auth);

  final DemoAuth auth;

  @override
  String? get currentEmail => auth.email;

  @override
  Future<void> signIn({required String email, required String password}) async {
    await wait();
    auth.signIn(email, password);
  }

  @override
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required Map<ConsentType, bool> consents,
  }) async {
    await wait();
    auth.signUp(email: email, password: password, name: name, phone: phone, consents: consents);
    return true;
  }

  @override
  Future<void> signOut() async => auth.signOut();

  @override
  Future<void> updatePassword(String newPassword) async {
    await wait();
    auth.updatePassword(newPassword);
  }

  @override
  Future<void> deleteAccount() async {
    await wait();
    auth.deleteAccount();
  }
}

class DemoDogRepository extends _DemoRepository implements DogRepository {
  DemoDogRepository(super.server);

  @override
  Future<List<Dog>> fetchDogs(String ownerId) async {
    await wait();
    final rows = db.where('dogs', (d) => d['owner_id'] == ownerId && d['deleted_at'] == null).toList()
      ..sort((a, b) => _byText(a, b, 'created_at'));
    return rows.map(Dog.fromJson).toList();
  }

  @override
  Future<Dog> fetchDog(String dogId) async {
    await wait();
    return Dog.fromJson(db.byId('dogs', dogId) ?? rowNotFound());
  }

  @override
  Future<Dog> createDog(String ownerId, DogDraft draft) async {
    await wait();
    final row = <String, dynamic>{
      ...draft.toJson(),
      'owner_id': ownerId,
      'profile_image_path': null,
      'deleted_at': null,
    };
    server.applyBreedCatalog(row);
    return Dog.fromJson(db.insert('dogs', row));
  }

  @override
  Future<Dog> updateDog(String dogId, DogDraft draft) async {
    await wait();
    final row = db.byId('dogs', dogId) ?? rowNotFound();
    final values = draft.toJson();
    server.applyBreedCatalog(values);
    db.update('dogs', row, values);
    return Dog.fromJson(row);
  }

  @override
  Future<void> deleteDog(String dogId) async {
    await wait();
    final row = db.byId('dogs', dogId);
    if (row != null) db.update('dogs', row, {'deleted_at': iso(db.now())});
  }

  @override
  Future<List<Breed>> fetchBreeds() async {
    await wait();
    final rows = db.where('breeds', (b) => b['is_active'] == true).toList()
      ..sort((a, b) => a.intOr('sort_order').compareTo(b.intOr('sort_order')));
    return rows.map(Breed.fromJson).toList();
  }

  @override
  Future<List<HealthCondition>> fetchHealthConditions() async {
    await wait();
    final rows = db.where('health_conditions', (c) => c['is_active'] == true).toList()
      ..sort((a, b) => a.intOr('sort_order').compareTo(b.intOr('sort_order')));
    return rows.map(HealthCondition.fromJson).toList();
  }

  @override
  Future<DogHealthProfile?> fetchHealthProfile(String dogId) async {
    await wait();
    final row = db.find('dog_health_profiles', (p) => p['dog_id'] == dogId);
    return row == null ? null : DogHealthProfile.fromJson(row);
  }

  @override
  Future<void> saveHealthProfile(DogHealthProfile profile) async {
    await wait();
    final values = <String, dynamic>{
      ...profile.toJson(),
      'condition_codes': server.normalizeConditionCodes(profile.conditionCodes),
      'updated_at': iso(db.now()),
    };
    final existing = db.find('dog_health_profiles', (p) => p['dog_id'] == profile.dogId);
    existing == null ? db.insert('dog_health_profiles', values) : db.update('dog_health_profiles', existing, values);
  }

  @override
  Future<String> uploadProfileImage({required Dog dog, required Uint8List bytes, required String extension}) async {
    await wait();
    final ext = extension.toLowerCase().replaceAll('.', '');
    final path = '${dog.ownerId}/${dog.id}/${db.now().millisecondsSinceEpoch}.${ext.isEmpty ? 'jpg' : ext}';
    db.storage['${DogRepository.profileBucket}/$path'] = bytes;
    final row = db.byId('dogs', dog.id) ?? rowNotFound();
    db.update('dogs', row, {'profile_image_path': path});
    final previous = dog.profileImagePath;
    if (previous != null && previous != path) db.storage.remove('${DogRepository.profileBucket}/$previous');
    return path;
  }

  /// 서명 URL 대신 data URL을 돌려준다 (DogAvatar가 메모리 이미지로 그린다).
  @override
  Future<String> createSignedImageUrl(String path) async {
    await wait();
    final bytes = db.storage['${DogRepository.profileBucket}/$path'] ??
        (throw const StorageException('Object not found', statusCode: '404'));
    final ext = path.split('.').last;
    final type = switch (ext) {
      'png' => 'image/png',
      'webp' => 'image/webp',
      'heic' => 'image/heic',
      _ => 'image/jpeg',
    };
    return 'data:$type;base64,${base64Encode(bytes)}';
  }
}

class DemoBookingRepository extends _DemoRepository implements BookingRepository {
  DemoBookingRepository(super.server);

  @override
  Future<List<Branch>> fetchBranches() async {
    await wait();
    final rows = db.where('branches', (b) => b['is_active'] == true).toList()..sort((a, b) => _byText(a, b, 'name'));
    return rows.map(Branch.fromJson).toList();
  }

  @override
  Future<List<ExerciseProgram>> fetchPrograms() async {
    await wait();
    final rows = db.where('exercise_programs', (p) => p['is_active'] == true).toList()
      ..sort((a, b) => a.intOr('sort_order').compareTo(b.intOr('sort_order')));
    return rows.map(ExerciseProgram.fromJson).toList();
  }

  @override
  Future<List<TimeSlot>> fetchAvailableSlots(SlotQuery query) async {
    await wait();
    return server.booking
        .availableSlots(branchId: query.branchId, date: query.date, programId: query.programId)
        .map(TimeSlot.fromJson)
        .toList();
  }

  @override
  Future<String> createBooking({
    required String dogId,
    required String branchId,
    required String programId,
    required DateTime startAt,
    String? membershipId,
    String? note,
  }) async {
    await wait();
    return server.booking
        .createBooking(
          dogId: dogId,
          branchId: branchId,
          programId: programId,
          startAt: startAt,
          membershipId: membershipId,
          note: note,
        )
        .str('id');
  }

  @override
  Future<List<Booking>> fetchBookings(String userId) async {
    await wait();
    return server.booking.bookingsOf(userId).map(Booking.fromJson).toList();
  }

  @override
  Future<Booking> fetchBooking(String bookingId) async {
    await wait();
    return Booking.fromJson(server.booking.booking(bookingId));
  }

  @override
  Future<Booking?> fetchNextBooking(String dogId) async {
    await wait();
    final row = server.booking.nextBooking(dogId);
    return row == null ? null : Booking.fromJson(row);
  }

  @override
  Future<void> cancelBooking(String bookingId, {String? reason}) async {
    await wait();
    server.booking.cancelBooking(bookingId, reason: reason);
  }

  @override
  Future<void> checkIn(String bookingId) async {
    await wait();
    server.booking.selfCheckIn(bookingId);
  }

  @override
  Future<void> rescheduleBooking(String bookingId, DateTime newStartAt) async {
    await wait();
    server.booking.rescheduleBooking(bookingId, newStartAt);
  }
}

class DemoExerciseRepository extends _DemoRepository implements ExerciseRepository {
  DemoExerciseRepository(super.server);

  /// Realtime 구독 흉내: 세션 행이 바뀔 때마다 최신 세션을 보낸다 (트레드밀 시뮬레이터가 매초 갱신).
  @override
  Stream<ExerciseSession?> watchLatestSession(String dogId) {
    return db.watch('exercise_sessions', () {
      final rows = db.where('exercise_sessions', (s) => s['dog_id'] == dogId).toList()
        ..sort((a, b) => _byText(b, a, 'created_at'));
      return rows.isEmpty ? null : ExerciseSession.fromJson({...rows.first});
    });
  }

  @override
  Future<List<ExerciseSession>> fetchSessions(String dogId, {int limit = 100}) async {
    await wait();
    final rows = db.where('exercise_sessions', (s) => s['dog_id'] == dogId).toList()
      ..sort((a, b) => _byText(b, a, 'created_at'));
    return rows.take(limit).map((s) => ExerciseSession.fromJson(_embed(s))).toList();
  }

  /// `*, treadmill:treadmills(id, device_name), reports:analysis_reports(...), points:exercise_points(...)`
  Json _embed(Json session) {
    final treadmill = db.byId('treadmills', session['treadmill_id'] as String?);
    final reports = db.where('analysis_reports', (r) => r['session_id'] == session['id']).toList()
      ..sort((a, b) => _byText(b, a, 'created_at'));
    return {
      ...session,
      'treadmill': treadmill == null ? null : {'id': treadmill['id'], 'device_name': treadmill['device_name']},
      'reports': [
        for (final r in reports)
          {'id': r['id'], 'analysis_status': r['analysis_status'], 'created_at': r['created_at']},
      ],
      'points': [
        for (final p in db.where('exercise_points', (p) => p['session_id'] == session['id']))
          {
            'kind': p['kind'],
            'attendance_points': p['attendance_points'],
            'achievement_points': p['achievement_points'],
            'distance_points': p['distance_points'],
            'bonus_points': p['bonus_points'],
            'points': p['points'],
            'note': p['note'],
            'voided_at': p['voided_at'],
          },
      ],
    };
  }

  @override
  Future<Treadmill> fetchTreadmill(String treadmillId) async {
    await wait();
    final row = db.byId('treadmills', treadmillId) ?? rowNotFound();
    return Treadmill.fromJson({'id': row['id'], 'device_name': row['device_name'], 'status': row['status']});
  }
}

class DemoAnalysisRepository extends _DemoRepository implements AnalysisRepository {
  DemoAnalysisRepository(super.server);

  /// `*, session:exercise_sessions(id, status, ..., treadmill:treadmills(id, device_name))`
  Json _embed(Json report) {
    final session = db.byId('exercise_sessions', report['session_id'] as String?);
    final treadmill = db.byId('treadmills', session?['treadmill_id'] as String?);
    return {
      ...report,
      'session': session == null
          ? null
          : {
              for (final key in const [
                'id',
                'status',
                'started_at',
                'ended_at',
                'duration_seconds',
                'distance_meters',
                'current_speed',
                'average_speed',
                'max_speed',
              ])
                key: session[key],
              'treadmill': treadmill == null ? null : {'id': treadmill['id'], 'device_name': treadmill['device_name']},
            },
    };
  }

  List<Json> _reportsOf(String dogId) =>
      db.where('analysis_reports', (r) => r['dog_id'] == dogId).toList()..sort((a, b) => _byText(b, a, 'created_at'));

  @override
  Future<List<AnalysisReport>> fetchReports(String dogId, {int limit = 30}) async {
    await wait();
    return _reportsOf(dogId).take(limit).map((r) => AnalysisReport.fromJson(_embed(r))).toList();
  }

  @override
  Future<AnalysisReport> fetchReport(String reportId) async {
    await wait();
    return AnalysisReport.fromJson(_embed(db.byId('analysis_reports', reportId) ?? rowNotFound()));
  }

  @override
  Future<AnalysisReport?> fetchPreviousCompleted({required String dogId, required DateTime before}) async {
    await wait();
    final row = _reportsOf(dogId)
        .where((r) => r['analysis_status'] == 'completed' && r.dateTime('created_at').isBefore(before))
        .firstOrNull;
    return row == null ? null : AnalysisReport.fromJson(_embed(row));
  }

  /// 데모에는 촬영 영상이 없다 (원본·스켈레톤 영상 목록을 비워 재생 버튼이 나오지 않는다).
  @override
  Future<List<PoseRecord>> fetchPoseRecords(String sessionId) async {
    await wait();
    return const [];
  }

  @override
  Future<String> createVideoUrl(String path) async {
    await wait();
    throw const StorageException('데모에는 운동 영상이 없어요', statusCode: '404');
  }

  @override
  Future<ExercisePlan?> fetchActivePlan(String dogId) async {
    await wait();
    final rows = db.where('exercise_plans', (p) => p['dog_id'] == dogId && p['is_active'] == true).toList()
      ..sort((a, b) => _byText(b, a, 'created_at'));
    return rows.isEmpty ? null : ExercisePlan.fromJson(rows.first);
  }
}

class DemoMembershipRepository extends _DemoRepository implements MembershipRepository {
  DemoMembershipRepository(super.server);

  @override
  Future<List<Membership>> fetchMemberships(String userId) async {
    await wait();
    final rows = db.where('memberships', (m) => m['user_id'] == userId).toList()
      ..sort((a, b) => _byText(b, a, 'expires_at'));
    return rows.map(Membership.fromJson).toList();
  }

  @override
  Future<List<MembershipPlan>> fetchPlans() async {
    await wait();
    final rows = db.where('membership_plans', (p) => p['is_active'] == true).toList()
      ..sort((a, b) => a.intOr('sort_order').compareTo(b.intOr('sort_order')));
    return rows.map(MembershipPlan.fromJson).toList();
  }

  @override
  Future<List<Payment>> fetchPayments(String userId) async {
    await wait();
    final rows = db.where('payments', (p) => p['user_id'] == userId).toList()
      ..sort((a, b) => _byText(b, a, 'created_at'));
    return rows.take(100).map(Payment.fromJson).toList();
  }
}

class DemoNotificationRepository extends _DemoRepository implements NotificationRepository {
  DemoNotificationRepository(super.server);

  /// Realtime 구독 흉내: 새 알림이 생기면 바로 목록을 다시 보낸다.
  @override
  Stream<List<AppNotification>> watchNotifications(String userId) {
    return db.watch('notifications', () {
      final rows = db.where('notifications', (n) => n['user_id'] == userId).toList()
        ..sort((a, b) => _byText(b, a, 'created_at'));
      return rows.take(50).map((n) => AppNotification.fromJson({...n})).toList();
    });
  }

  @override
  Future<void> markRead(String notificationId) async {
    await wait();
    final row = db.byId('notifications', notificationId);
    if (row != null) db.update('notifications', row, {'is_read': true});
  }

  @override
  Future<void> markAllRead(String userId) async {
    await wait();
    for (final row in db.where('notifications', (n) => n['user_id'] == userId && n['is_read'] != true).toList()) {
      row['is_read'] = true;
    }
    db.changed('notifications');
  }

  @override
  Future<void> delete(String notificationId) async {
    await wait();
    db.delete('notifications', (n) => n['id'] == notificationId);
  }
}

class DemoUserRepository extends _DemoRepository implements UserRepository {
  DemoUserRepository(super.server);

  Json _user(String userId) => db.byId('users', userId) ?? rowNotFound();

  @override
  Future<AppUser> fetchUser(String userId) async {
    await wait();
    return AppUser.fromJson(_user(userId));
  }

  @override
  Future<void> updateProfile(String userId, {required String name, String? phone}) async {
    await wait();
    db.update('users', _user(userId), {
      'name': name.trim(),
      'phone': (phone == null || phone.trim().isEmpty) ? null : phone.trim(),
    });
  }

  @override
  Future<void> updateNotificationPrefs(String userId, NotificationPrefs prefs) async {
    await wait();
    db.update('users', _user(userId), {'notification_prefs': prefs.toJson()});
  }

  @override
  Future<String> setNickname(String nickname) async {
    await wait();
    return server.ranking.setNickname(nickname);
  }

  @override
  Future<void> updateRankingShowPhoto(String userId, {required bool show}) async {
    await wait();
    db.update('users', _user(userId), {'ranking_show_photo': show});
  }
}

class DemoConsentRepository extends _DemoRepository implements ConsentRepository {
  DemoConsentRepository(super.server);

  @override
  Future<Map<ConsentType, DataConsent>> fetchLatest(String userId) async {
    await wait();
    final rows = db.where('data_consents', (c) => c['user_id'] == userId).toList()
      ..sort((a, b) => _byText(b, a, 'responded_at'));
    final latest = <ConsentType, DataConsent>{};
    for (final row in rows) {
      final consent = DataConsent.fromJson(row);
      if (consent != null) latest.putIfAbsent(consent.type, () => consent);
    }
    return latest;
  }

  @override
  Future<void> record(String userId, ConsentType type, {required bool granted}) async {
    await wait();
    db.insert('data_consents', {
      'user_id': userId,
      'consent_type': type.dbValue,
      'consent_version': type.currentVersion,
      'granted': granted,
      'responded_at': iso(db.now()),
    });
  }
}

class DemoRankingRepository extends _DemoRepository implements RankingRepository {
  DemoRankingRepository(super.server);

  @override
  Future<List<LeaderboardEntry>> fetchLeaderboard(RankingQuery query) async {
    await wait();
    return server.ranking
        .leaderboard(
          month: _monthOf(query.month),
          scope: query.scope.dbValue,
          scopeKey: query.scopeKey,
          limit: query.limit,
        )
        .map(LeaderboardEntry.fromJson)
        .toList();
  }

  @override
  Future<MyRanking> fetchMyRanking(String dogId, DateTime month) async {
    await wait();
    return MyRanking.fromJson(server.ranking.myRanking(dogId, _monthOf(month)));
  }

  @override
  Future<List<BranchBattleEntry>> fetchBranchBattle(DateTime month) async {
    await wait();
    return server.ranking.branchBattle(_monthOf(month)).map(BranchBattleEntry.fromJson).toList();
  }

  @override
  Future<List<HallOfFameEntry>> fetchHallOfFame({int months = 6}) async {
    await wait();
    return server.ranking.hallOfFame(months: months).map(HallOfFameEntry.fromJson).toList();
  }

  @override
  Future<RankingDogProfile> fetchDogProfile(String dogId, DateTime month) async {
    await wait();
    return RankingDogProfile.fromJson(server.ranking.dogProfile(dogId, _monthOf(month)));
  }

  @override
  Future<DogAchievements> fetchAchievements(String dogId) async {
    await wait();
    return DogAchievements.fromJson(server.ranking.achievements(dogId));
  }

  @override
  Future<List<BadgeDef>> fetchBadgeCatalog() async {
    await wait();
    final rows = db.where('badges', (b) => b['is_active'] == true).toList()
      ..sort((a, b) => a.intOr('sort_order').compareTo(b.intOr('sort_order')));
    return rows.map(BadgeDef.fromJson).toList();
  }

  @override
  Future<int> cheer(String dogId) async {
    await wait();
    return server.ranking.cheer(dogId);
  }
}

class DemoSupportRepository extends _DemoRepository implements SupportRepository {
  DemoSupportRepository(super.server);

  @override
  Future<List<Notice>> fetchNotices({int limit = 50}) async {
    await wait();
    final rows = db.table('notices').toList()
      ..sort((a, b) {
        final pinned = (b['is_pinned'] == true ? 1 : 0) - (a['is_pinned'] == true ? 1 : 0);
        return pinned != 0 ? pinned : _byText(b, a, 'published_at');
      });
    return rows.take(limit).map(Notice.fromJson).toList();
  }

  @override
  Future<List<Faq>> fetchFaqs() async {
    await wait();
    final rows = db.where('faqs', (f) => f['is_active'] == true).toList()
      ..sort((a, b) => a.intOr('sort_order').compareTo(b.intOr('sort_order')));
    return rows.map(Faq.fromJson).toList();
  }

  @override
  Future<List<Inquiry>> fetchInquiries(String userId) async {
    await wait();
    final rows = db.where('inquiries', (i) => i['user_id'] == userId).toList()
      ..sort((a, b) => _byText(b, a, 'created_at'));
    return rows.map(Inquiry.fromJson).toList();
  }

  @override
  Future<void> createInquiry({
    required String userId,
    required InquiryCategory category,
    required String title,
    required String body,
  }) async {
    await wait();
    db.insert('inquiries', {
      'user_id': userId,
      'category': category.dbValue,
      'title': title.trim(),
      'body': body.trim(),
      'status': 'open',
      'answer': null,
      'answered_at': null,
    });
  }
}
