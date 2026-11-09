import 'package:dog_treadmill_app/core/utils/error_messages.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  test('예약 RPC 오류 코드를 한국어 안내로 바꾼다', () {
    expect(
      friendlyError(const PostgrestException(message: 'SLOT_FULL', code: '23P01')),
      contains('모두 예약'),
    );
    expect(
      friendlyError(const PostgrestException(message: 'CHANGE_DEADLINE_PASSED', code: '22023')),
      contains('1시간 전'),
    );
  });

  test('권한 오류', () {
    expect(
      friendlyError(const PostgrestException(message: 'permission denied for table users', code: '42501')),
      contains('권한'),
    );
  });

  test('로그인 실패 메시지', () {
    expect(
      friendlyError(const AuthException('Invalid login credentials', code: 'invalid_credentials')),
      '이메일 또는 비밀번호가 올바르지 않아요.',
    );
    expect(
      friendlyError(const AuthException('User already registered')),
      '이미 가입된 이메일이에요.',
    );
  });

  test('네트워크 오류', () {
    expect(friendlyError(Exception('SocketException: Failed host lookup')), contains('네트워크'));
  });

  test('알 수 없는 오류는 일반 안내', () {
    expect(friendlyError(StateError('x')), contains('문제가 발생했어요'));
  });
}
