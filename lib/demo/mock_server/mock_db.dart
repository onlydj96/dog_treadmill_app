import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

import '../../core/utils/json.dart';

/// `2026-11-16T05:00:00.000Z` (UTC, 밀리초까지). 길이가 같아 문자열 비교로 시간순 정렬이 된다.
String iso(DateTime instant) =>
    DateTime.fromMillisecondsSinceEpoch(instant.millisecondsSinceEpoch, isUtc: true).toIso8601String();

/// 한국 시간(UTC+9, 서머타임 없음) 계산. 지점 timezone은 모두 Asia/Seoul이다.
///
/// 날짜는 `DateTime.utc(연, 월, 일)`로 표현한다 (DB의 date 타입에 해당).
abstract final class Kst {
  static const offset = Duration(hours: 9);

  /// 한국 벽시계 값을 담은 UTC [DateTime]. 연·월·일·시·분만 읽는다.
  static DateTime wall(DateTime instant) => instant.toUtc().add(offset);

  /// 한국 날짜 (DB: private.kst_date)
  static DateTime date(DateTime instant) {
    final w = wall(instant);
    return DateTime.utc(w.year, w.month, w.day);
  }

  /// 한국 날짜 + 시각(분) → 실제 시각
  static DateTime at(DateTime date, int minuteOfDay) =>
      DateTime.utc(date.year, date.month, date.day, 0, minuteOfDay).subtract(offset);

  /// 그 달 1일 (DB: private.month_start)
  static DateTime monthStart(DateTime date) => DateTime.utc(date.year, date.month);

  /// 그 주 월요일 (DB: private.week_start)
  static DateTime weekStart(DateTime date) => DateTime.utc(date.year, date.month, date.day - (date.weekday - 1));

  static DateTime parseDate(String value) {
    final d = DateTime.parse(value);
    return DateTime.utc(d.year, d.month, d.day);
  }

  /// "10:30" / "10:30:00" → 630
  static int minutesOf(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  /// 0시부터 지난 초 (한국 시간)
  static int secondOfDay(DateTime instant) {
    final w = wall(instant);
    return w.hour * 3600 + w.minute * 60 + w.second;
  }
}

/// DB 함수가 `raise exception`으로 돌려주는 오류와 같은 모양. 앱의 friendlyError가 그대로 안내 문구로 바꾼다.
Never rpcError(String message, [String code = 'P0001']) => throw PostgrestException(message: message, code: code);

/// `.single()`에 행이 없을 때 PostgREST가 돌려주는 오류
Never rowNotFound() =>
    throw const PostgrestException(message: 'JSON object requested, multiple (or no) rows returned', code: 'PGRST116');

/// 목업 서버의 인메모리 DB.
///
/// 테이블은 실제 Supabase 테이블과 같은 이름·컬럼의 JSON 행 목록이라, 데모 저장소는 실제 저장소처럼
/// 모델의 `fromJson`으로 읽는다. 행이 바뀌면 [watch] 구독자에게 다시 보내 Realtime을 흉내 낸다.
class MockDb {
  MockDb({required this.clock, required this.random});

  final DateTime Function() clock;
  final Random random;

  final Map<String, List<Json>> _tables = {};

  /// Storage 흉내: `버킷/경로` → 파일
  final Map<String, Uint8List> storage = {};

  /// auth.uid() — 로그인한 사용자
  String? currentUserId;

  /// true면 [notify]가 알림을 만들지 않는다 (샘플 데이터를 쌓는 동안)
  bool muteNotifications = false;

  final _changes = StreamController<String>.broadcast();

  DateTime now() => clock();

  List<Json> table(String name) => _tables.putIfAbsent(name, () => <Json>[]);

  Iterable<Json> where(String name, bool Function(Json row) test) => table(name).where(test);

  Json? find(String name, bool Function(Json row) test) => table(name).where(test).firstOrNull;

  Json? byId(String name, String? id) => id == null ? null : find(name, (r) => r['id'] == id);

  String newId() {
    String hex(int length) => List.generate(length, (_) => random.nextInt(16).toRadixString(16)).join();
    final variant = (8 + random.nextInt(4)).toRadixString(16);
    return '${hex(8)}-${hex(4)}-4${hex(3)}-$variant${hex(3)}-${hex(12)}';
  }

  /// 행 추가. id·created_at이 없으면 채운다.
  Json insert(String name, Json row) {
    final inserted = <String, dynamic>{'id': newId(), 'created_at': iso(now()), ...row};
    table(name).add(inserted);
    changed(name);
    return inserted;
  }

  void update(String name, Json row, Json values) {
    row.addAll(values);
    changed(name);
  }

  int delete(String name, bool Function(Json row) test) {
    final rows = table(name);
    final before = rows.length;
    rows.removeWhere(test);
    final removed = before - rows.length;
    if (removed > 0) changed(name);
    return removed;
  }

  void changed(String name) {
    if (!_changes.isClosed) _changes.add(name);
  }

  /// Realtime 구독 흉내: 지금 값을 보내고, 테이블이 바뀔 때마다 다시 읽어 보낸다.
  Stream<T> watch<T>(String name, T Function() read) async* {
    yield read();
    await for (final _ in _changes.stream.where((t) => t == name)) {
      yield read();
    }
  }

  String requireUser() => currentUserId ?? rpcError('AUTH_REQUIRED', '42501');

  /// private.notify_user: 알림 설정에서 끈 종류는 만들지 않는다.
  ///
  /// [msg]·[args]는 DB 트리거가 data에 함께 저장하는 문구 종류와 값이다 (docs/i18n.md "알림"). 앱은 아는 msg면
  /// 현재 언어로 문구를 만들고, title/body는 이전 알림·모르는 msg용 한국어 문구다.
  void notify(
    String? userId,
    String type,
    String title,
    String body, {
    Json data = const {},
    required String msg,
    Json args = const {},
  }) {
    if (muteNotifications || userId == null) return;
    final user = byId('users', userId);
    if (user == null) return;
    final prefs = user.objOrNull('notification_prefs');
    const muteable = {'booking', 'exercise', 'analysis', 'ranking', 'marketing'};
    if (muteable.contains(type) && prefs?[type] == false) return;
    insert('notifications', {
      'user_id': userId,
      'type': type,
      'title': title,
      'body': body,
      'data': {
        ...data,
        'msg': msg,
        'args': {...args}
      },
      'is_read': false,
    });
  }

  /// 알림 args의 반려견 이름 (`dog_name` + 영어 값 `dog_name__en`)
  static Json dogNameArgs(Json dog) => {'dog_name': dog['name'], 'dog_name__en': dog['name__en']};

  /// `dogs` 행에 카탈로그 견종의 영어 이름(`breed_catalog: {name_en}`)을 붙인다.
  /// 카탈로그 견종이 아니면 null (실제 저장소의 `breed_catalog:breeds(name_en)` 임베드).
  Json dogWithBreedCatalog(Json dog) {
    final breed = byId('breeds', dog['breed_id'] as String?);
    return {
      ...dog,
      'breed_catalog': breed == null ? null : {'name_en': breed['name_en']}
    };
  }

  /// 최신 동의 기록 기준 (DB: private.has_consent)
  bool hasConsent(String? userId, String type) {
    if (userId == null) return false;
    Json? latest;
    for (final row in where('data_consents', (c) => c['user_id'] == userId && c['consent_type'] == type)) {
      if (latest == null || row.dateTime('responded_at').isAfter(latest.dateTime('responded_at'))) latest = row;
    }
    return latest?.boolOr('granted') ?? false;
  }

  void clear() {
    _tables.clear();
    storage.clear();
    currentUserId = null;
    muteNotifications = false;
  }

  Future<void> dispose() => _changes.close();
}
