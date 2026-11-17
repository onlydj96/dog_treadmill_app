import 'package:dog_treadmill_app/features/health/data/analysis_models.dart';
import 'package:dog_treadmill_app/features/membership/data/membership_models.dart';
import 'package:dog_treadmill_app/features/membership/presentation/payment_history_screen.dart';
import 'package:dog_treadmill_app/features/membership/providers.dart';
import 'package:dog_treadmill_app/l10n/l10n.dart';
import 'package:dog_treadmill_app/l10n/server_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/l10n.dart';

/// 운동 계획·결제의 영어 값(`_en`)과 결제 수단 표시
void main() {
  setUpAll(initTestLocales);

  const planJson = {
    'id': 'e1',
    'program_name': '관절 케어 걷기',
    'program_name_en': 'Joint Care Walk',
    'restrictions': [
      {'name': '점프 금지', 'name_en': 'No jumping'},
      {'name': '평지로'},
    ],
    'notes': '천천히',
    'notes_en': 'Slowly',
  };
  const paymentJson = {
    'id': 'pay1',
    'amount': 25000,
    'status': 'paid',
    'order_name': '1회 이용권',
    'order_name_en': 'Single-session pass',
    'method': '카드',
    'created_at': '2026-11-01T00:00:00Z',
  };

  test('한국어: 기본 값 그대로', () {
    final plan = ExercisePlan.fromJson(planJson);
    expect(plan.programName, '관절 케어 걷기');
    expect(plan.restrictions, ['점프 금지', '평지로']);
    expect(plan.notes, '천천히');
    expect(Payment.fromJson(paymentJson).orderName, '1회 이용권');
  });

  group('English', () {
    setUp(() => useLanguage(AppLanguage.en));

    test('운동 계획은 _en을 쓰고, 항목·필드마다 없으면 한국어로 되돌아간다', () {
      final plan = ExercisePlan.fromJson(planJson);
      expect(plan.programName, 'Joint Care Walk');
      expect(plan.restrictions, ['No jumping', '평지로']);
      expect(plan.notes, 'Slowly');
      final bare = ExercisePlan.fromJson({'id': 'e2', 'program_name': '걷기'});
      expect(bare.programName, '걷기');
      expect(bare.restrictions, isEmpty);
      expect(bare.notes, isNull);
    });

    test('주문명은 order_name_en, 없으면 한국어', () {
      expect(Payment.fromJson(paymentJson).orderName, 'Single-session pass');
      expect(Payment.fromJson({...paymentJson}..remove('order_name_en')).orderName, '1회 이용권');
      expect(Payment.fromJson({...paymentJson}..remove('order_name')..remove('order_name_en')).orderName, isNull);
    });

    test('결제 수단: 한국어 값·영어 코드는 영어로, 모르는 값은 그대로', () {
      expect(localizedPaymentMethod('카드'), 'Card');
      expect(localizedPaymentMethod('현장결제'), 'Pay at store');
      expect(localizedPaymentMethod('카카오페이'), 'Kakao Pay');
      expect(localizedPaymentMethod('KakaoPay'), 'Kakao Pay');
      expect(localizedPaymentMethod('virtual_account'), 'Virtual account');
      expect(localizedPaymentMethod('Some PG'), 'Some PG');
    });

    testWidgets('결제 내역 화면', (tester) async {
      final payments = [Payment.fromJson(paymentJson)];
      await tester.pumpWidget(ProviderScope(
        overrides: [languageOverride(AppLanguage.en), paymentsProvider.overrideWith((ref) async => payments)],
        child: localizedApp(const PaymentHistoryScreen(), language: AppLanguage.en),
      ));
      await tester.pumpAndSettle();
      expect(find.text('Single-session pass'), findsOneWidget);
      expect(find.textContaining('· Card'), findsOneWidget);
    });
  });

  test('결제 수단: 한국어 화면에서는 저장된 글자 그대로', () {
    for (final v in ['카드', '신용카드', '체크카드', '간편결제', '카카오페이', '네이버페이', '토스페이', '페이코', '삼성페이', '애플페이', '계좌이체', '가상계좌', '휴대폰', '현장 결제', '현장결제', '이용권', 'Some PG']) {
      expect(localizedPaymentMethod(v), v);
    }
    expect(localizedPaymentMethod('kakaopay'), '카카오페이');
    expect(localizedPaymentMethod('onsite'), '현장 결제');
  });
}
