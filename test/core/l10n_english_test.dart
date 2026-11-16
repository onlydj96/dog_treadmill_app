import 'package:dog_treadmill_app/core/utils/error_messages.dart';
import 'package:dog_treadmill_app/core/utils/formatters.dart';
import 'package:dog_treadmill_app/core/utils/validators.dart';
import 'package:dog_treadmill_app/l10n/l10n.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../helpers/l10n.dart';

/// 영어로 바꿨을 때 위젯 밖 문구(포맷터·검증·오류)가 모두 영어로 나오는지
void main() {
  setUpAll(initTestLocales);
  setUp(() => useLanguage(AppLanguage.en));

  group('Fmt (English)', () {
    final at = DateTime(2026, 11, 16, 15, 5); // 월요일

    test('날짜·시간', () {
      expect(Fmt.date(at), 'Mon, Nov 16');
      expect(Fmt.dateFull(at), 'Mon, Nov 16, 2026');
      expect(Fmt.dateShort(at), 'Nov 16, 2026');
      expect(Fmt.monthDay(at), '11/16');
      expect(Fmt.yearMonth(at), 'November 2026');
      expect(Fmt.weekday(at), 'Mon');
      expect(Fmt.month(at), 'Nov');
      expect(Fmt.time(at), '3:05 PM');
      expect(Fmt.time(DateTime(2026, 11, 16, 0, 30)), '12:30 AM');
      expect(Fmt.dateTime(at), 'Mon, Nov 16, 3:05 PM');
      expect(Fmt.timeRange(at, at.add(const Duration(minutes: 30))), '3:05 PM – 3:35 PM');
    });

    test('금액·점수는 영어 단위와 복수형', () {
      expect(Fmt.won(45000), '₩45,000');
      expect(Fmt.points(1), '1 pt');
      expect(Fmt.points(1234), '1,234 pts');
    });

    test('운동 시간', () {
      expect(Fmt.duration(3725), '1 hr 2 min');
      expect(Fmt.duration(3600), '1 hr');
      expect(Fmt.duration(1930), '32 min 10 sec');
      expect(Fmt.duration(45), '45 sec');
      expect(Fmt.duration(0), '0 min');
      expect(Fmt.durationMinutes(1930), '32 min');
    });

    test('상대 시간과 반려견 나이는 복수형을 맞춘다', () {
      final now = DateTime(2026, 11, 16, 12);
      expect(Fmt.relative(now.subtract(const Duration(seconds: 20)), now: now), 'Just now');
      expect(Fmt.relative(now.subtract(const Duration(minutes: 5)), now: now), '5 min ago');
      expect(Fmt.relative(now.subtract(const Duration(hours: 1)), now: now), '1 hour ago');
      expect(Fmt.relative(now.subtract(const Duration(hours: 3)), now: now), '3 hours ago');
      expect(Fmt.relative(now.subtract(const Duration(days: 1)), now: now), '1 day ago');
      expect(Fmt.dogAge(DateTime(2026, 11, 1), now: now), 'Under 1 month');
      expect(Fmt.dogAge(DateTime(2026, 10, 1), now: now), '1 month');
      expect(Fmt.dogAge(DateTime(2026, 5, 1), now: now), '6 months');
      expect(Fmt.dogAge(DateTime(2025, 11, 1), now: now), '1 year');
      expect(Fmt.dogAge(DateTime(2023, 1, 1), now: now), '3 years');
    });

    test('particle은 영어에서 조사를 붙이지 않는다', () {
      expect(particle('Kongi', '와', '과'), 'Kongi');
      expect(particle('콩이', '와', '과'), '콩이');
    });
  });

  test('Validators (English)', () {
    expect(Validators.email(''), 'Please enter your email.');
    expect(Validators.email('wrong@'), 'Please enter a valid email address.');
    expect(Validators.password('abc123'), 'Use at least 8 characters.');
    expect(Validators.password('abcdefgh'), 'Use both letters and numbers.');
    expect(Validators.passwordEntered(''), 'Please enter your password.');
    expect(Validators.required('', 'Name'), 'Name is required.');
    expect(Validators.nickname('a'), 'Use 2–12 characters.');
  });

  test('friendlyError (English)', () {
    expect(
      friendlyError(const PostgrestException(message: 'SLOT_FULL', code: '23P01')),
      'All treadmills are booked at that time. Please choose another time.',
    );
    expect(
      friendlyError(const AuthException('Invalid login credentials', code: 'invalid_credentials')),
      'Incorrect email or password.',
    );
    expect(friendlyError(Exception('SocketException: Failed host lookup')), contains('network'));
    expect(friendlyError(StateError('x')), 'Something went wrong. Please try again in a moment.');
  });

  test('한국어로 되돌리면 기존 문구', () {
    L10n.use(AppLanguage.ko);
    expect(Fmt.won(45000), '45,000원');
    expect(Validators.email(''), '이메일을 입력해 주세요.');
  });
}
