import 'package:supabase_flutter/supabase_flutter.dart';

/// DB 함수가 반환하는 오류 코드 → 사용자 안내 문구
const _rpcMessages = <String, String>{
  'AUTH_REQUIRED': '로그인이 필요해요. 다시 로그인해 주세요.',
  'DOG_NOT_FOUND': '반려견 정보를 찾을 수 없어요.',
  'BRANCH_NOT_FOUND': '지점 정보를 찾을 수 없어요.',
  'PROGRAM_NOT_FOUND': '운동 프로그램 정보를 찾을 수 없어요.',
  'SLOT_IN_PAST': '이미 지난 시간이에요. 다른 시간을 선택해 주세요.',
  'SLOT_NOT_AVAILABLE': '예약할 수 없는 시간이에요. 다른 시간을 선택해 주세요.',
  'SLOT_FULL': '선택한 시간의 트레드밀이 모두 예약되었어요. 다른 시간을 선택해 주세요.',
  'DOG_ALREADY_BOOKED': '같은 시간에 이미 이 반려견의 예약이 있어요.',
  'MEMBERSHIP_NOT_FOUND': '이용권을 찾을 수 없어요.',
  'MEMBERSHIP_NOT_USABLE': '선택한 이용권은 이 시간에 사용할 수 없어요. 잔여 횟수와 유효기간을 확인해 주세요.',
  'BOOKING_NOT_FOUND': '예약 정보를 찾을 수 없어요.',
  'BOOKING_NOT_CANCELLABLE': '이미 진행되었거나 취소된 예약이에요.',
  'CHANGE_DEADLINE_PASSED': '예약 시작 1시간 전부터는 앱에서 변경·취소할 수 없어요. 지점으로 문의해 주세요.',
};

const _authMessages = <String, String>{
  'invalid_credentials': '이메일 또는 비밀번호가 올바르지 않아요.',
  'email_not_confirmed': '이메일 인증을 완료한 뒤 로그인해 주세요.',
  'user_already_exists': '이미 가입된 이메일이에요.',
  'email_exists': '이미 가입된 이메일이에요.',
  'weak_password': '비밀번호가 너무 단순해요. 영문과 숫자를 섞어 8자 이상 입력해 주세요.',
  'same_password': '기존 비밀번호와 다른 비밀번호를 입력해 주세요.',
  'over_email_send_rate_limit': '요청이 많아요. 잠시 후 다시 시도해 주세요.',
  'over_request_rate_limit': '요청이 많아요. 잠시 후 다시 시도해 주세요.',
  'signup_disabled': '현재 회원가입을 받을 수 없어요.',
};

const _fallbackMessage = '문제가 발생했어요. 잠시 후 다시 시도해 주세요.';
const _networkMessage = '네트워크 연결을 확인한 뒤 다시 시도해 주세요.';

/// 예외를 사용자에게 보여줄 한국어 문구로 변환한다.
String friendlyError(Object error) {
  if (error is PostgrestException) {
    final mapped = _rpcMessages[error.message];
    if (mapped != null) return mapped;
    if (error.code == '42501') return '이 작업을 수행할 권한이 없어요.';
    if (error.code == 'PGRST116') return '요청한 정보를 찾을 수 없어요.';
    return _fallbackMessage;
  }

  if (error is AuthException) {
    final byCode = _authMessages[error.code];
    if (byCode != null) return byCode;
    final message = error.message.toLowerCase();
    if (message.contains('invalid login credentials')) return _authMessages['invalid_credentials']!;
    if (message.contains('already registered')) return _authMessages['user_already_exists']!;
    if (message.contains('email not confirmed')) return _authMessages['email_not_confirmed']!;
    if (message.contains('password')) return _authMessages['weak_password']!;
    return '인증 처리 중 문제가 발생했어요. 다시 시도해 주세요.';
  }

  if (error is StorageException) {
    return '파일을 처리하지 못했어요. 사진 크기(5MB 이하)와 형식을 확인해 주세요.';
  }

  if (error is FunctionException) {
    return '요청을 처리하지 못했어요. 잠시 후 다시 시도해 주세요.';
  }

  final text = error.toString();
  if (text.contains('SocketException') ||
      text.contains('ClientException') ||
      text.contains('Failed host lookup') ||
      text.contains('XMLHttpRequest') ||
      text.contains('TimeoutException')) {
    return _networkMessage;
  }

  return _fallbackMessage;
}
