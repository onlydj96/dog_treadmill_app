import 'package:dog_treadmill_app/features/booking/data/booking_models.dart';
import 'package:dog_treadmill_app/features/booking/presentation/booking_detail_screen.dart';
import 'package:dog_treadmill_app/features/booking/presentation/widgets/booking_widgets.dart';
import 'package:dog_treadmill_app/features/booking/providers.dart';
import 'package:dog_treadmill_app/features/membership/data/membership_models.dart';
import 'package:dog_treadmill_app/features/membership/presentation/membership_screen.dart';
import 'package:dog_treadmill_app/features/membership/presentation/payment_history_screen.dart';
import 'package:dog_treadmill_app/features/membership/providers.dart';
import 'package:dog_treadmill_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/l10n.dart';

/// 예약·이용권 영역의 영어 화면: 서버 `_en` 값 선택, 라벨, 화면 문구
void main() {
  setUpAll(initTestLocales);

  const branchJson = {
    'id': 'br1',
    'name': '용산 아이파크몰점',
    'address': '서울 용산구 한강대로23길 55',
    'name_en': "Yongsan I'Park Mall",
    'address_en': "55 Hangang-daero 23-gil, Yongsan-gu, Seoul (Yongsan I'Park Mall)",
    'opens_at': '10:00:00',
    'closes_at': '22:00:00',
    'is_24_hours': false,
  };
  const programJson = {
    'id': 'p1',
    'name': '데일리 산책',
    'description': '편안한 속도로 하루치 운동을 해요.',
    'name_en': 'Daily Walk',
    'description_en': 'A day of exercise at a comfortable pace.',
    'duration_minutes': 30,
    'intensity': 'medium',
  };

  group('모델: 한국어 (기본)', () {
    test('_en 값이 있어도 한국어 화면에서는 한국어를 쓴다', () {
      final branch = Branch.fromJson(branchJson);
      expect(branch.name, '용산 아이파크몰점');
      expect(branch.address, '서울 용산구 한강대로23길 55');
      final program = ExerciseProgram.fromJson(programJson);
      expect(program.name, '데일리 산책');
      expect(program.description, '편안한 속도로 하루치 운동을 해요.');
      expect(program.intensity.label, '중강도');
      expect(BookingStatus.noShow.label, '미방문');
      expect(PaymentStatus.partialRefunded.label, '부분 환불');
    });
  });

  group('모델: English', () {
    setUp(() => useLanguage(AppLanguage.en));

    test('지점·프로그램은 _en 값을 쓰고, 없으면 한국어로 되돌아간다', () {
      final branch = Branch.fromJson(branchJson);
      expect(branch.name, "Yongsan I'Park Mall");
      expect(branch.address, startsWith('55 Hangang-daero'));
      expect(branch.hoursLabel, '10:00 ~ 22:00');
      expect(Branch.fromJson({...branchJson, 'is_24_hours': true}).hoursLabel, '24 hours');
      expect(Branch.fromJson({...branchJson}..remove('name_en')).name, '용산 아이파크몰점');
      expect(Branch.fromJson({...branchJson, 'name_en': '  '}).name, '용산 아이파크몰점');

      final program = ExerciseProgram.fromJson(programJson);
      expect(program.name, 'Daily Walk');
      expect(program.description, 'A day of exercise at a comfortable pace.');
      final bare = ExerciseProgram.fromJson({'id': 'p2', 'name': '체중 관리', 'duration_minutes': 20});
      expect(bare.name, '체중 관리');
      expect(bare.description, isNull);
    });

    test('강도·예약 상태·결제 상태 라벨', () {
      expect(ProgramIntensity.values.map((e) => e.label), ['Low intensity', 'Moderate intensity', 'High intensity']);
      expect(BookingStatus.values.map((e) => e.label),
          ['Pending', 'Confirmed', 'Checked in', 'Completed', 'Cancelled', 'No-show']);
      expect(PaymentStatus.values.map((e) => e.label),
          ['Payment pending', 'Paid', 'Cancelled', 'Refunded', 'Partially refunded', 'Failed']);
    });

    test('이용권 상품명은 plan.name_en을 쓰고 상태 라벨은 영어다', () {
      final json = {
        'id': 'm1',
        'plan_name': '10회권',
        'total_sessions': 10,
        'remaining_sessions': 4,
        'starts_at': '2026-11-01T00:00:00Z',
        'expires_at': '2099-12-31T00:00:00Z',
        'status': 'active',
      };
      final withPlan = Membership.fromJson({
        ...json,
        'plan': {'name_en': '10-session pass'},
      });
      expect(withPlan.planName, '10-session pass');
      expect(withPlan.statusLabel, 'Available');
      expect(Membership.fromJson(json).planName, '10회권', reason: '상품이 없으면 구매 시점 이름');
      expect(Membership.fromJson({...json, 'plan': null}).planName, '10회권');
      expect(Membership.fromJson({...json, 'remaining_sessions': 0}).statusLabel, 'Used up');
      expect(Membership.fromJson({...json, 'status': 'refunded'}).statusLabel, 'Refunded');
      expect(Membership.fromJson({...json, 'expires_at': '2020-01-01T00:00:00Z'}).statusLabel, 'Expired');

      final plan = MembershipPlan.fromJson({
        'id': 'pl1',
        'name': '10회권',
        'description': '열 번 이용',
        'name_en': '10-session pass',
        'description_en': 'Ten visits',
        'total_sessions': 10,
        'validity_days': 90,
        'price': 100000,
      });
      expect(plan.name, '10-session pass');
      expect(plan.description, 'Ten visits');
    });
  });

  group('화면: English', () {
    Booking booking(Duration startsIn, {BookingStatus status = BookingStatus.confirmed}) {
      final start = DateTime.now().add(startsIn);
      return Booking.fromJson({
        'id': 'b1',
        'dog_id': 'd1',
        'branch_id': 'br1',
        'treadmill_id': 't1',
        'membership_id': 'm1',
        'start_at': start.toUtc().toIso8601String(),
        'end_at': start.add(const Duration(minutes: 30)).toUtc().toIso8601String(),
        'status': status.dbValue,
        'created_at': '2026-11-01T00:00:00Z',
        'branch': branchJson,
        'program': programJson,
        'treadmill': {'id': 't1', 'device_name': 'T-03'},
        'dog': {'id': 'd1', 'name': 'Kongi', 'breed': '말티푸'},
      });
    }

    Future<void> pump(WidgetTester tester, Widget home, {List<Override> overrides = const []}) async {
      tester.view
        ..physicalSize = const Size(1080, 2600)
        ..devicePixelRatio = 2;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(ProviderScope(
        overrides: [languageOverride(AppLanguage.en), ...overrides],
        child: localizedApp(home, language: AppLanguage.en),
      ));
      await tester.pump();
      await tester.pump();
    }

    testWidgets('예약 카드', (tester) async {
      await pump(tester, Scaffold(body: BookingCard(booking: booking(const Duration(days: 2)))));
      expect(find.text('Daily Walk'), findsOneWidget);
      expect(find.text('Confirmed'), findsOneWidget);
      expect(find.textContaining("Kongi · Yongsan I'Park Mall · T-03"), findsOneWidget);
    });

    testWidgets('예약 상세: 변경 가능 구간', (tester) async {
      final value = booking(const Duration(hours: 3));
      await pump(tester, const BookingDetailScreen(bookingId: 'b1'),
          overrides: [bookingDetailProvider.overrideWith((ref, id) async => value)]);
      expect(find.text('Booking details'), findsOneWidget);
      expect(find.text('Cancel booking'), findsOneWidget);
      expect(find.text('Change time'), findsOneWidget);
      expect(find.textContaining('Cancelling restores your pass session.'), findsOneWidget);
      expect(find.text('Uses 1 pass session'), findsOneWidget);
      expect(find.textContaining('Daily Walk · 30 min · Moderate intensity'), findsOneWidget);
      expect(find.textContaining("Yongsan I'Park Mall\n55 Hangang-daero"), findsOneWidget);
    });

    testWidgets('예약 상세: 체크인 시간에는 배정 트레드밀을 영어로 안내한다', (tester) async {
      final value = booking(const Duration(minutes: 10));
      await pump(tester, const BookingDetailScreen(bookingId: 'b1'),
          overrides: [bookingDetailProvider.overrideWith((ref, id) async => value)]);
      expect(find.byType(CheckInButton), findsOneWidget);
      expect(find.text('Check in'), findsWidgets);
      expect(
        find.textContaining('check in and start your workout on treadmill T-03.'),
        findsOneWidget,
      );
    });

    testWidgets('이용권 화면', (tester) async {
      final memberships = [
        Membership.fromJson({
          'id': 'm1',
          'plan_name': '10회권',
          'plan': {'name_en': '10-session pass'},
          'total_sessions': 10,
          'remaining_sessions': 4,
          'starts_at': '2026-11-01T00:00:00Z',
          'expires_at': '2099-12-31T00:00:00Z',
          'status': 'active',
        }),
      ];
      final plans = [
        MembershipPlan.fromJson({
          'id': 'pl1',
          'name': '10회권',
          'name_en': '10-session pass',
          'description_en': 'Ten visits',
          'total_sessions': 10,
          'validity_days': 90,
          'price': 100000,
        }),
        MembershipPlan.fromJson({
          'id': 'pl2',
          'name': '1회권',
          'name_en': 'Single pass',
          'total_sessions': 1,
          'validity_days': 1,
          'price': 15000,
        }),
      ];
      await pump(tester, const MembershipScreen(), overrides: [
        membershipsProvider.overrideWith((ref) async => memberships),
        membershipPlansProvider.overrideWith((ref) async => plans),
      ]);
      expect(find.text('Passes'), findsOneWidget);
      expect(find.text('Your passes'), findsOneWidget);
      expect(find.text('Pass options'), findsOneWidget);
      expect(find.text('10-session pass'), findsNWidgets(2), reason: '보유 이용권과 상품 목록');
      expect(find.text('/ 10 sessions left'), findsOneWidget);
      expect(find.text('Valid for 90 days'), findsOneWidget);
      expect(find.text('Valid for 1 day'), findsOneWidget);
      expect(find.text('₩10,000 per session'), findsOneWidget);
      expect(find.text('Payment history'), findsOneWidget);
    });

    testWidgets('결제 내역: 비어 있을 때', (tester) async {
      await pump(tester, const PaymentHistoryScreen(),
          overrides: [paymentsProvider.overrideWith((ref) async => <Payment>[])]);
      expect(find.text('Payments & refunds'), findsOneWidget);
      expect(find.text('No payments yet'), findsOneWidget);
    });

    testWidgets('결제 내역: 환불 문구', (tester) async {
      final payments = [
        Payment.fromJson({
          'id': 'pay1',
          'amount': 100000,
          'status': 'partial_refunded',
          'refunded_amount': 20000,
          'refunded_at': '2026-11-10T03:00:00Z',
          'created_at': '2026-11-01T00:00:00Z',
        }),
      ];
      await pump(tester, const PaymentHistoryScreen(),
          overrides: [paymentsProvider.overrideWith((ref) async => payments)]);
      expect(find.text('Pass purchase'), findsOneWidget);
      expect(find.text('Partially refunded'), findsOneWidget);
      expect(find.textContaining('Refunded ₩20,000 (Nov 10, 2026)'), findsOneWidget);
    });
  });
}
