import 'package:intl/intl.dart';

import '../../l10n/l10n.dart';

/// 화면 표시용 포맷터. 현재 앱 언어([L10n])를 따른다 (한국어 / English).
///
/// 날짜 패턴·단위 문구는 ARB(fmt*)에 있다. 예) date: "11월 16일 (월)" / "Mon, Nov 16"
abstract final class Fmt {
  static final _dateFormats = <String, DateFormat>{};
  static final _numberFormats = <String, NumberFormat>{};

  static DateFormat _pattern(String pattern) =>
      _dateFormats.putIfAbsent('${L10n.intlLocale}|$pattern', () => DateFormat(pattern, L10n.intlLocale));

  static NumberFormat get _number =>
      _numberFormats.putIfAbsent(L10n.intlLocale, () => NumberFormat('#,###', L10n.intlLocale));

  static AppLocalizations get _l => L10n.current;

  static String date(DateTime value) => _pattern(_l.fmtPatternDate).format(value.toLocal());

  static String dateFull(DateTime value) => _pattern(_l.fmtPatternDateFull).format(value.toLocal());

  static String dateShort(DateTime value) => _pattern(_l.fmtPatternDateShort).format(value.toLocal());

  static String monthDay(DateTime value) => _pattern(_l.fmtPatternMonthDay).format(value.toLocal());

  static String yearMonth(DateTime value) => _pattern(_l.fmtPatternYearMonth).format(value.toLocal());

  static String weekday(DateTime value) => _pattern(_l.fmtPatternWeekday).format(value.toLocal());

  /// "오후 3:30" / "3:30 PM" — intl 0.19의 ko 로케일은 오전/오후 대신 AM/PM을 쓰므로 직접 포맷한다.
  static String time(DateTime value) {
    final local = value.toLocal();
    final hour12 = local.hour % 12 == 0 ? 12 : local.hour % 12;
    return _l.fmtTime(local.hour < 12 ? _l.fmtAm : _l.fmtPm, '$hour12:${local.minute.toString().padLeft(2, '0')}');
  }

  static String dateTime(DateTime value) => _l.fmtDateTime(date(value), time(value));

  static String timeRange(DateTime start, DateTime end) => _l.fmtTimeRange(time(start), time(end));

  /// 45000 → "45,000원" / "₩45,000"
  static String won(num value) => _l.fmtWon(_number.format(value));

  static String number(num value) => _number.format(value);

  /// 랭킹 점수: 1234 → "1,234점" / "1,234 pts"
  static String points(num value) => _l.fmtPoints(value, _number.format(value));

  /// 랭킹 기간 등 월만 표시: "11월" / "Nov"
  static String month(DateTime value) => _pattern(_l.fmtPatternMonth).format(value);

  /// 누적 거리 요약: 12430 → "12.4km"
  static String km(num meters) => '${(meters / 1000).toStringAsFixed(1)}km';

  /// 3725 → "1시간 2분", 1930 → "32분 10초", 45 → "45초" (English: "1 hr 2 min", "32 min 10 sec", "45 sec")
  static String duration(int seconds) {
    if (seconds <= 0) return _l.fmtDurationMinute(0);
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    if (h > 0) return m > 0 ? _l.fmtDurationHourMinute(h, m) : _l.fmtDurationHour(h);
    if (m > 0) return s > 0 ? _l.fmtDurationMinuteSecond(m, s) : _l.fmtDurationMinute(m);
    return _l.fmtDurationSecond(s);
  }

  /// 분 단위 요약: 1930 → "32분", 3725 → "1시간 2분"
  static String durationMinutes(int seconds) {
    final totalMinutes = (seconds / 60).round();
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    if (h > 0) return m > 0 ? _l.fmtDurationHourMinute(h, m) : _l.fmtDurationHour(h);
    return _l.fmtDurationMinute(m);
  }

  /// 타이머 표기: 754 → "12:34", 3723 → "1:02:03"
  static String timer(int seconds) {
    final safe = seconds < 0 ? 0 : seconds;
    final h = safe ~/ 3600;
    final m = (safe % 3600) ~/ 60;
    final s = safe % 60;
    String two(int v) => v.toString().padLeft(2, '0');
    return h > 0 ? '$h:${two(m)}:${two(s)}' : '${two(m)}:${two(s)}';
  }

  /// 850 → "850 m", 1250 → "1.25 km"
  static String distance(num meters) {
    if (meters >= 1000) return '${(meters / 1000).toStringAsFixed(2)} km';
    return '${meters.round()} m';
  }

  static String speed(num? kmh) => kmh == null ? '-' : '${kmh.toStringAsFixed(1)} km/h';

  static String weight(num? kg) {
    if (kg == null) return '-';
    final text = kg % 1 == 0 ? kg.toInt().toString() : kg.toStringAsFixed(1);
    return '${text}kg';
  }

  static String percent(double ratio, {int digits = 0}) => '${(ratio * 100).toStringAsFixed(digits)}%';

  /// 알림 등에서 쓰는 상대 시간
  static String relative(DateTime value, {DateTime? now}) {
    final current = now ?? DateTime.now();
    final diff = current.difference(value);
    if (diff.inMinutes < 1) return _l.fmtJustNow;
    if (diff.inMinutes < 60) return _l.fmtMinutesAgo(diff.inMinutes);
    if (diff.inHours < 24) return _l.fmtHoursAgo(diff.inHours);
    if (diff.inDays < 7) return _l.fmtDaysAgo(diff.inDays);
    return dateShort(value);
  }

  /// 반려견 나이: 1살 미만은 개월 수, 이상은 만 나이
  static String dogAge(DateTime birthDate, {DateTime? now}) {
    final months = dogAgeMonths(birthDate, now: now);
    if (months < 1) return _l.fmtDogAgeUnderOneMonth;
    if (months < 12) return _l.fmtDogAgeMonths(months);
    return _l.fmtDogAgeYears(months ~/ 12);
  }

  /// 만 개월 수 (DB private.dog_age_months와 같은 계산)
  static int dogAgeMonths(DateTime birthDate, {DateTime? now}) {
    final today = now ?? DateTime.now();
    var months = (today.year - birthDate.year) * 12 + today.month - birthDate.month;
    if (today.day < birthDate.day) months -= 1;
    return months;
  }
}

/// 받침 유무에 따라 조사를 붙인다. 예) josa('코코', '와', '과') → "코코와"
/// 한글이 아니면 받침이 없는 형태를 사용한다.
String josa(String word, String withoutBatchim, String withBatchim) {
  if (word.isEmpty) return word;
  final code = word.runes.last;
  final isHangul = code >= 0xAC00 && code <= 0xD7A3;
  final hasBatchim = isHangul && (code - 0xAC00) % 28 != 0;
  return '$word${hasBatchim ? withBatchim : withoutBatchim}';
}

/// ARB 문구에 이름을 넣을 때 쓴다: 한국어 화면이면 [josa]처럼 조사를 붙이고, 다른 언어에서는 이름만 돌려준다.
///
/// ```dart
/// // app_ko.arb: "homeGreeting": "오늘도 {dog} 건강하게 걸어요"   app_en.arb: "Let's take a healthy walk with {dog} today"
/// context.l10n.homeGreeting(particle(dog.name, '와', '과'))   // "콩이와" / "Kongi"
/// ```
String particle(String word, String withoutBatchim, String withBatchim) =>
    L10n.isKorean ? josa(word, withoutBatchim, withBatchim) : word;
