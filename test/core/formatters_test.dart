import 'package:dog_treadmill_app/core/utils/formatters.dart';
import 'package:dog_treadmill_app/core/utils/json.dart';
import 'package:dog_treadmill_app/core/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() => initializeDateFormatting('ko_KR'));

  group('Fmt', () {
    test('duration은 시/분/초 단위로 줄여 표시한다', () {
      expect(Fmt.duration(3725), '1시간 2분');
      expect(Fmt.duration(3600), '1시간');
      expect(Fmt.duration(1930), '32분 10초');
      expect(Fmt.duration(45), '45초');
      expect(Fmt.duration(0), '0분');
    });

    test('timer는 mm:ss 또는 h:mm:ss', () {
      expect(Fmt.timer(754), '12:34');
      expect(Fmt.timer(3723), '1:02:03');
      expect(Fmt.timer(-5), '00:00');
    });

    test('distance는 1km 이상이면 km로 표시', () {
      expect(Fmt.distance(850), '850 m');
      expect(Fmt.distance(1250), '1.25 km');
    });

    test('won은 천 단위 구분 기호를 붙인다', () {
      expect(Fmt.won(220000), '220,000원');
    });

    test('weight는 정수면 소수점을 생략한다', () {
      expect(Fmt.weight(4), '4kg');
      expect(Fmt.weight(3.25), '3.3kg');
      expect(Fmt.weight(null), '-');
    });

    test('dogAge는 1살 미만이면 개월, 이상이면 만 나이', () {
      final now = DateTime(2026, 11, 9);
      expect(Fmt.dogAge(DateTime(2023, 1, 15), now: now), '3살');
      expect(Fmt.dogAge(DateTime(2026, 3, 10), now: now), '7개월');
      expect(Fmt.dogAge(DateTime(2026, 11, 1), now: now), '1개월 미만');
    });

    test('relative는 경과 시간을 한국어로 표시', () {
      final now = DateTime(2026, 11, 9, 12);
      expect(Fmt.relative(now.subtract(const Duration(seconds: 20)), now: now), '방금 전');
      expect(Fmt.relative(now.subtract(const Duration(minutes: 5)), now: now), '5분 전');
      expect(Fmt.relative(now.subtract(const Duration(hours: 3)), now: now), '3시간 전');
      expect(Fmt.relative(now.subtract(const Duration(days: 2)), now: now), '2일 전');
    });

    test('date/time은 한국어 요일과 오전·오후를 사용한다', () {
      final value = DateTime(2026, 11, 10, 15, 30);
      expect(Fmt.date(value), '11월 10일 (화)');
      expect(Fmt.time(value), '오후 3:30');
    });
  });

  group('josa', () {
    test('받침 유무에 따라 조사를 고른다', () {
      expect(josa('코코', '와', '과'), '코코와');
      expect(josa('콩', '와', '과'), '콩과');
      expect(josa('보리', '가', '이'), '보리가');
      expect(josa('두부콩', '가', '이'), '두부콩이');
    });

    test('한글이 아니면 받침 없는 형태를 사용한다', () {
      expect(josa('Max', '와', '과'), 'Max와');
      expect(josa('', '와', '과'), '');
    });
  });

  group('Validators', () {
    test('email', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email('wrong@'), isNotNull);
      expect(Validators.email('owner@example.com'), isNull);
    });

    test('password는 8자 이상, 영문+숫자', () {
      expect(Validators.password('abc123'), isNotNull);
      expect(Validators.password('abcdefgh'), isNotNull);
      expect(Validators.password('abcd1234'), isNull);
    });

    test('phone은 01X로 시작하는 10~11자리', () {
      expect(Validators.phone('010-1234-5678'), isNull);
      expect(Validators.phone('01012345678'), isNull);
      expect(Validators.phone('02-123-4567'), isNotNull);
      expect(Validators.phone(''), isNotNull);
    });

    test('formatPhone은 하이픈을 넣는다', () {
      expect(formatPhone('01012345678'), '010-1234-5678');
      expect(formatPhone('0161234567'), '016-123-4567');
    });
  });

  group('json helpers', () {
    test('Realtime이 문자열로 보낸 숫자도 파싱한다', () {
      final Json json = {'speed': '4.5', 'count': '3', 'none': null};
      expect(json.dblOr('speed'), 4.5);
      expect(json.intOr('count'), 3);
      expect(json.dblOrNull('none'), isNull);
    });

    test('objOrNull은 배열로 온 1:1 임베드도 처리한다', () {
      final Json json = {
        'single': {'id': 'a'},
        'list': [
          {'id': 'b'},
        ],
        'empty': <dynamic>[],
      };
      expect(json.objOrNull('single')?['id'], 'a');
      expect(json.objOrNull('list')?['id'], 'b');
      expect(json.objOrNull('empty'), isNull);
    });

    test('toDateString은 YYYY-MM-DD', () {
      expect(toDateString(DateTime(2026, 3, 7)), '2026-03-07');
    });
  });
}
