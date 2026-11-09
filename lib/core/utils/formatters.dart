import 'package:intl/intl.dart';

/// 화면 표시용 포맷터 (한국어)
abstract final class Fmt {
  static final _date = DateFormat('M월 d일 (E)', 'ko_KR');
  static final _dateFull = DateFormat('yyyy년 M월 d일 (E)', 'ko_KR');
  static final _dateShort = DateFormat('yyyy.MM.dd', 'ko_KR');
  static final _monthDay = DateFormat('M.d', 'ko_KR');
  static final _yearMonth = DateFormat('yyyy년 M월', 'ko_KR');
  static final _weekday = DateFormat('E', 'ko_KR');
  static final _number = NumberFormat('#,###', 'ko_KR');

  static String date(DateTime value) => _date.format(value.toLocal());

  static String dateFull(DateTime value) => _dateFull.format(value.toLocal());

  static String dateShort(DateTime value) => _dateShort.format(value.toLocal());

  static String monthDay(DateTime value) => _monthDay.format(value.toLocal());

  static String yearMonth(DateTime value) => _yearMonth.format(value.toLocal());

  static String weekday(DateTime value) => _weekday.format(value.toLocal());

  /// "오후 3:30" — intl 0.19의 ko 로케일은 오전/오후 대신 AM/PM을 쓰므로 직접 포맷한다.
  static String time(DateTime value) {
    final local = value.toLocal();
    final period = local.hour < 12 ? '오전' : '오후';
    final hour12 = local.hour % 12 == 0 ? 12 : local.hour % 12;
    return '$period $hour12:${local.minute.toString().padLeft(2, '0')}';
  }

  static String dateTime(DateTime value) => '${date(value)} ${time(value)}';

  static String timeRange(DateTime start, DateTime end) => '${time(start)} ~ ${time(end)}';

  static String won(num value) => '${_number.format(value)}원';

  static String number(num value) => _number.format(value);

  /// 3725 → "1시간 2분", 1930 → "32분 10초", 45 → "45초"
  static String duration(int seconds) {
    if (seconds <= 0) return '0분';
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    if (h > 0) return m > 0 ? '$h시간 $m분' : '$h시간';
    if (m > 0) return s > 0 ? '$m분 $s초' : '$m분';
    return '$s초';
  }

  /// 분 단위 요약: 1930 → "32분", 3725 → "1시간 2분"
  static String durationMinutes(int seconds) {
    final totalMinutes = (seconds / 60).round();
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    if (h > 0) return m > 0 ? '$h시간 $m분' : '$h시간';
    return '$m분';
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
    if (diff.inMinutes < 1) return '방금 전';
    if (diff.inMinutes < 60) return '${diff.inMinutes}분 전';
    if (diff.inHours < 24) return '${diff.inHours}시간 전';
    if (diff.inDays < 7) return '${diff.inDays}일 전';
    return dateShort(value);
  }

  /// 반려견 나이: 1살 미만은 개월 수, 이상은 만 나이
  static String dogAge(DateTime birthDate, {DateTime? now}) {
    final today = now ?? DateTime.now();
    var months = (today.year - birthDate.year) * 12 + today.month - birthDate.month;
    if (today.day < birthDate.day) months -= 1;
    if (months < 1) return '1개월 미만';
    if (months < 12) return '$months개월';
    return '${months ~/ 12}살';
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
