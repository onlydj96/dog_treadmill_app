import 'package:supabase_flutter/supabase_flutter.dart';

import '../../l10n/l10n.dart';

/// DB 함수가 반환하는 오류 코드 → 사용자 안내 문구 (현재 앱 언어)
String? _rpcMessage(String code, AppLocalizations l) => switch (code) {
      'AUTH_REQUIRED' => l.errorAuthRequired,
      'DOG_NOT_FOUND' => l.errorDogNotFound,
      'BRANCH_NOT_FOUND' => l.errorBranchNotFound,
      'PROGRAM_NOT_FOUND' => l.errorProgramNotFound,
      'SLOT_IN_PAST' => l.errorSlotInPast,
      'SLOT_NOT_AVAILABLE' => l.errorSlotNotAvailable,
      'SLOT_FULL' => l.errorSlotFull,
      'DOG_ALREADY_BOOKED' => l.errorDogAlreadyBooked,
      'MEMBERSHIP_NOT_FOUND' => l.errorMembershipNotFound,
      'MEMBERSHIP_NOT_USABLE' => l.errorMembershipNotUsable,
      'BOOKING_NOT_FOUND' => l.errorBookingNotFound,
      'BOOKING_NOT_CANCELLABLE' => l.errorBookingNotCancellable,
      'CHANGE_DEADLINE_PASSED' => l.errorChangeDeadlinePassed,
      'INVALID_BOOKING_STATUS' => l.errorInvalidBookingStatus,
      'CHECK_IN_TOO_EARLY' => l.errorCheckInTooEarly,
      'CHECK_IN_CLOSED' => l.errorCheckInClosed,
      'QR_INVALID' => l.errorQrInvalid,
      'QR_OTHER_BRANCH' => l.errorQrOtherBranch,
      'TREADMILL_UNAVAILABLE' => l.errorTreadmillUnavailable,
      'TREADMILL_BUSY' => l.errorTreadmillBusy,
      'NICKNAME_INVALID' => l.errorNicknameInvalid,
      'NICKNAME_FORBIDDEN' => l.errorNicknameForbidden,
      'NICKNAME_TAKEN' => l.errorNicknameTaken,
      'NICKNAME_COOLDOWN' => l.errorNicknameCooldown,
      'CANNOT_CHEER_OWN_DOG' => l.errorCannotCheerOwnDog,
      'INVALID_RANKING_SCOPE' => l.errorInvalidRankingScope,
      _ => null,
    };

/// GoTrue 오류 코드 → 안내 문구
String? _authMessage(String? code, AppLocalizations l) => switch (code) {
      'invalid_credentials' => l.errorInvalidCredentials,
      'email_not_confirmed' => l.errorEmailNotConfirmed,
      'user_already_exists' || 'email_exists' => l.errorUserAlreadyExists,
      'weak_password' => l.errorWeakPassword,
      'same_password' => l.errorSamePassword,
      'over_email_send_rate_limit' || 'over_request_rate_limit' => l.errorRateLimited,
      'signup_disabled' => l.errorSignupDisabled,
      _ => null,
    };

/// 예외를 사용자에게 보여줄 문구(현재 앱 언어)로 변환한다.
String friendlyError(Object error) {
  final l = L10n.current;

  if (error is PostgrestException) {
    final mapped = _rpcMessage(error.message, l);
    if (mapped != null) return mapped;
    if (error.code == '42501') return l.errorPermissionDenied;
    if (error.code == 'PGRST116') return l.errorNotFound;
    return l.errorGeneric;
  }

  if (error is AuthException) {
    final byCode = _authMessage(error.code, l);
    if (byCode != null) return byCode;
    final message = error.message.toLowerCase();
    if (message.contains('invalid login credentials')) return l.errorInvalidCredentials;
    if (message.contains('already registered')) return l.errorUserAlreadyExists;
    if (message.contains('email not confirmed')) return l.errorEmailNotConfirmed;
    if (message.contains('password')) return l.errorWeakPassword;
    return l.errorAuthGeneric;
  }

  if (error is StorageException) {
    return l.errorStorage;
  }

  if (error is FunctionException) {
    return l.errorFunction;
  }

  final text = error.toString();
  if (text.contains('SocketException') ||
      text.contains('ClientException') ||
      text.contains('Failed host lookup') ||
      text.contains('XMLHttpRequest') ||
      text.contains('TimeoutException')) {
    return l.errorNetwork;
  }

  return l.errorGeneric;
}
