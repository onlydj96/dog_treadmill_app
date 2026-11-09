import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_providers.dart';
import '../../consents/data/consent.dart';

class AuthRepository {
  AuthRepository(this._client);

  final SupabaseClient _client;

  String? get currentEmail => _client.auth.currentUser?.email;

  Future<void> signIn({required String email, required String password}) async {
    await _client.auth.signInWithPassword(email: email.trim(), password: password);
  }

  /// 회원가입. 프로필과 동의 이력은 DB 트리거(handle_new_user)가 메타데이터로 생성한다.
  /// 반환값: 바로 로그인되면 true, 이메일 인증이 필요하면 false.
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required Map<ConsentType, bool> consents,
  }) async {
    final response = await _client.auth.signUp(
      email: email.trim(),
      password: password,
      data: {
        'name': name.trim(),
        'phone': phone.trim(),
        'consents': [
          for (final entry in consents.entries)
            {
              'type': entry.key.dbValue,
              'version': entry.key.currentVersion,
              'granted': entry.value,
            },
        ],
      },
    );
    return response.session != null;
  }

  Future<void> signOut() => _client.auth.signOut();

  Future<void> updatePassword(String newPassword) async {
    await _client.auth.updateUser(UserAttributes(password: newPassword));
  }

  /// 회원 탈퇴 (Edge Function: delete-account)
  Future<void> deleteAccount() async {
    await _client.functions.invoke('delete-account');
    // 계정이 삭제되어 서버 로그아웃은 불가하므로 로컬 세션만 정리한다.
    await _client.auth.signOut(scope: SignOutScope.local);
  }
}

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(supabaseClientProvider)),
);
