/// 입력 폼 검증 (오류 메시지 또는 null 반환)
abstract final class Validators {
  static final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]{2,}$');

  static String? required(String? value, String label) {
    if (value == null || value.trim().isEmpty) return '$label을(를) 입력해 주세요.';
    return null;
  }

  static String? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return '이메일을 입력해 주세요.';
    if (!_emailPattern.hasMatch(text)) return '올바른 이메일 형식이 아니에요.';
    return null;
  }

  /// 8자 이상, 영문과 숫자 포함
  static String? password(String? value) {
    final text = value ?? '';
    if (text.length < 8) return '8자 이상 입력해 주세요.';
    if (!RegExp('[A-Za-z]').hasMatch(text) || !RegExp(r'\d').hasMatch(text)) {
      return '영문과 숫자를 함께 사용해 주세요.';
    }
    return null;
  }

  /// 휴대전화 번호 (01X로 시작하는 10~11자리)
  static String? phone(String? value) {
    final digits = (value ?? '').replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return '휴대전화 번호를 입력해 주세요.';
    if (!RegExp(r'^01[016789]\d{7,8}$').hasMatch(digits)) return '올바른 휴대전화 번호가 아니에요.';
    return null;
  }

  static String? name(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return '이름을 입력해 주세요.';
    if (text.length > 20) return '20자 이내로 입력해 주세요.';
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
