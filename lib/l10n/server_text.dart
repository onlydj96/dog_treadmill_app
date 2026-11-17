import 'l10n.dart';

/// 서버(DB 함수)가 기본값으로 저장하는 한국어 문구를 현재 언어로 바꾼다.
/// 운영자·기기가 직접 입력한 문구는 그대로 둔다.
///
/// 예) 사유 없이 중단된 운동의 stop_reason '운영자 판단에 의한 중단'
///     (supabase/migrations/20261109000400_exercise_rpc_and_notifications.sql)
String localizedStopReason(String reason) => switch (reason.trim()) {
      '운영자 판단에 의한 중단' => L10n.current.serverStopReasonByStaff,
      _ => reason,
    };

/// 예약 취소 사유 선택지. 운영자가 한 언어로 모아 볼 수 있게 서버(bookings.cancel_reason)에는 한국어로 저장한다.
List<String> cancelReasonPresets(AppLocalizations l) => [
      l.bookingCancelReasonSchedule,
      l.bookingCancelReasonCondition,
      l.bookingCancelReasonRebook,
      l.bookingCancelReasonOther,
    ];

/// 서버에 저장할 취소 사유 (선택지 순서 [index]의 한국어 문구)
String cancelReasonForServer(int index) =>
    cancelReasonPresets(lookupAppLocalizations(AppLanguage.ko.locale))[index];

/// 저장된 취소 사유가 선택지 문구면 현재 언어로 바꾼다. 직접 적은 사유는 그대로.
String localizedCancelReason(String reason) {
  final index = cancelReasonPresets(lookupAppLocalizations(AppLanguage.ko.locale)).indexOf(reason.trim());
  return index < 0 ? reason : cancelReasonPresets(L10n.current)[index];
}

/// 결제 수단(payments.method)을 현재 언어로 바꾼다. 저장값은 한국어 표시값이나 PG 코드 그대로다.
/// 한국어 값은 한국어 화면에서 저장된 글자 그대로 보여 주고(예: '현장결제'), 모르는 값은 그대로 둔다.
String localizedPaymentMethod(String method) {
  final l = L10n.current;
  final key = method.trim();
  if (!L10n.isEnglish && _koreanPaymentMethods.containsKey(key)) return method;
  final label = switch (_koreanPaymentMethods[key] ?? _paymentMethodCodes[key.toLowerCase()]) {
    'Card' => l.serverPaymentMethodCard,
    'CreditCard' => l.serverPaymentMethodCreditCard,
    'DebitCard' => l.serverPaymentMethodDebitCard,
    'EasyPay' => l.serverPaymentMethodEasyPay,
    'KakaoPay' => l.serverPaymentMethodKakaoPay,
    'NaverPay' => l.serverPaymentMethodNaverPay,
    'TossPay' => l.serverPaymentMethodTossPay,
    'Payco' => l.serverPaymentMethodPayco,
    'SamsungPay' => l.serverPaymentMethodSamsungPay,
    'ApplePay' => l.serverPaymentMethodApplePay,
    'Transfer' => l.serverPaymentMethodTransfer,
    'VirtualAccount' => l.serverPaymentMethodVirtualAccount,
    'Mobile' => l.serverPaymentMethodMobile,
    'Onsite' => l.serverPaymentMethodOnsite,
    'Pass' => l.serverPaymentMethodPass,
    _ => null,
  };
  return label ?? method;
}

const _koreanPaymentMethods = <String, String>{
  '카드': 'Card',
  '신용카드': 'CreditCard',
  '체크카드': 'DebitCard',
  '간편결제': 'EasyPay',
  '카카오페이': 'KakaoPay',
  '네이버페이': 'NaverPay',
  '토스페이': 'TossPay',
  '페이코': 'Payco',
  '삼성페이': 'SamsungPay',
  '애플페이': 'ApplePay',
  '계좌이체': 'Transfer',
  '가상계좌': 'VirtualAccount',
  '휴대폰': 'Mobile',
  '현장 결제': 'Onsite',
  '현장결제': 'Onsite',
  '이용권': 'Pass',
};

const _paymentMethodCodes = <String, String>{
  'card': 'Card',
  'kakaopay': 'KakaoPay',
  'naverpay': 'NaverPay',
  'tosspay': 'TossPay',
  'payco': 'Payco',
  'samsungpay': 'SamsungPay',
  'applepay': 'ApplePay',
  'transfer': 'Transfer',
  'virtual_account': 'VirtualAccount',
  'mobile': 'Mobile',
  'onsite': 'Onsite',
};
