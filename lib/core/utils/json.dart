typedef Json = Map<String, dynamic>;

num? _asNum(Object? value) {
  if (value is num) return value;
  if (value is String) return num.tryParse(value);
  return null;
}

/// Supabase(PostgREST/Realtime) 응답 파싱 헬퍼.
/// Realtime은 numeric을 문자열로 보내는 경우가 있어 숫자는 문자열도 허용한다.
extension JsonRead on Json {
  String str(String key) => this[key] as String;

  String? strOrNull(String key) => this[key] as String?;

  int intOr(String key, [int fallback = 0]) => _asNum(this[key])?.toInt() ?? fallback;

  int? intOrNull(String key) => _asNum(this[key])?.toInt();

  double dblOr(String key, [double fallback = 0]) => _asNum(this[key])?.toDouble() ?? fallback;

  double? dblOrNull(String key) => _asNum(this[key])?.toDouble();

  bool boolOr(String key, [bool fallback = false]) => (this[key] as bool?) ?? fallback;

  DateTime dateTime(String key) => DateTime.parse(this[key] as String);

  DateTime? dateTimeOrNull(String key) {
    final value = this[key] as String?;
    return value == null ? null : DateTime.parse(value);
  }

  /// 임베드된 단일 관계. PostgREST가 1:1 관계를 배열로 줄 때도 처리한다.
  Json? objOrNull(String key) {
    final value = this[key];
    if (value is Map<String, dynamic>) return value;
    if (value is List<dynamic> && value.isNotEmpty) return value.first as Json;
    return null;
  }

  List<Json> objList(String key) {
    final value = this[key];
    if (value is! List<dynamic>) return const [];
    return value.whereType<Map<String, dynamic>>().toList();
  }

  List<String> strList(String key) {
    final value = this[key];
    if (value is! List<dynamic>) return const [];
    return value.whereType<String>().toList();
  }
}

/// `YYYY-MM-DD` (Postgres date)
String toDateString(DateTime date) {
  final y = date.year.toString().padLeft(4, '0');
  final m = date.month.toString().padLeft(2, '0');
  final d = date.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}
