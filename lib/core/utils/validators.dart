import '../../l10n/l10n.dart';

/// 입력 폼 검증 (현재 앱 언어의 오류 메시지 또는 null 반환)
abstract final class Validators {
  static final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');

  static String? required(String? value, String label) {
    if (value == null || value.trim().isEmpty) return L10n.current.validationRequired(label);
    return null;
  }

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return L10n.current.validationEmailRequired;
    if (!_emailPattern.hasMatch(text)) return L10n.current.validationEmailInvalid;
    return null;
  }

  /// 로그인 비밀번호: 비어 있지만 않으면 된다
  static String? passwordEntered(String? value) =>
      (value == null || value.isEmpty) ? L10n.current.validationPasswordRequired : null;

  /// 8자 이상, 영문과 숫자 포함
  static String? password(String? value) {
    final text = value ?? '';
    if (text.length < 8) return L10n.current.validationPasswordTooShort;
    if (!RegExp('[A-Za-z]').hasMatch(text) || !RegExp(r'\d').hasMatch(text)) {
      return L10n.current.validationPasswordLettersAndDigits;
    }
    return null;
  }

  /// 휴대전화 번호 (01X로 시작하는 10~11자리)
  static String? phone(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return L10n.current.validationPhoneRequired;
    if (!RegExp(r'^01[016789]\d{7,8}$').hasMatch(digits)) return L10n.current.validationPhoneInvalid;
    return null;
  }

  static String? name(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return L10n.current.validationNameRequired;
    if (text.length > 20) return L10n.current.validationNameTooLong;
    return null;
  }

  static final _nicknamePattern = RegExp(r'^[가-힣A-Za-z0-9_]+$');

  /// 랭킹 닉네임: 2~12자, 한글(완성형)·영문·숫자·밑줄. DB 제약(users_nickname_format)과 같다.
  static String? nickname(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return L10n.current.validationNicknameRequired;
    if (text.length < 2 || text.length > 12) return L10n.current.validationNicknameLength;
    if (!_nicknamePattern.hasMatch(text)) return L10n.current.validationNicknameCharacters;
    return null;
  }
}

/// 01012345678 → 010-1234-5678
String formatPhone(String input) {
  final digits = input.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.length == 11) {
    return '${digits.substring(0, 3)}-${digits.substring(3, 7)}-${digits.substring(7)}';
  }
  if (digits.length == 10) {
    return '${digits.substring(0, 3)}-${digits.substring(3, 6)}-${digits.substring(6)}';
  }
  return input.trim();
}
