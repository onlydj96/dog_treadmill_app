import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthException;

import '../core/utils/json.dart';
import '../features/consents/data/consent.dart';
import 'mock_server/mock_server.dart';

/// 데모 로그인 상태 (Supabase Auth 세션 대신). 바뀌면 라우터가 로그인 화면 ↔ 홈으로 이동한다.
///
/// 오류는 실제 GoTrue와 같은 [AuthException] 코드로 던져, 로그인·가입 화면이 같은 안내 문구를 보여 준다.
class DemoAuth extends ChangeNotifier {
  DemoAuth(this.server);

  final MockServer server;

  String? get userId => server.db.currentUserId;

  bool get isLoggedIn => userId != null;

  String? get email => server.db.byId('auth_users', userId)?['email'] as String?;

  void signIn(String email, String password) {
    final account = server.accountByEmail(email);
    if (account == null || account['password'] != password) {
      throw const AuthException('Invalid login credentials', statusCode: '400', code: 'invalid_credentials');
    }
    _setUser(account.str('id'));
  }

  void signInDemo() => signIn(DemoAccount.email, DemoAccount.password);

  void signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required Map<ConsentType, bool> consents,
  }) {
    if (server.accountByEmail(email) != null) {
      throw const AuthException('User already registered', statusCode: '422', code: 'user_already_exists');
    }
    final id = server.createAccount(
      email: email,
      password: password,
      name: name,
      phone: phone,
      consents: [for (final e in consents.entries) (e.key.dbValue, e.key.currentVersion, e.value)],
    );
    _setUser(id);
  }

  void signOut() => _setUser(null);

  void updatePassword(String newPassword) {
    final account = server.db.byId('auth_users', userId) ??
        (throw const AuthException('Auth session missing!', statusCode: '400', code: 'session_not_found'));
    if (account['password'] == newPassword) {
      throw const AuthException(
        'New password should be different from the old password.',
        statusCode: '422',
        code: 'same_password',
      );
    }
    server.db.update('auth_users', account, {'password': newPassword});
  }

  void deleteAccount() {
    final id = userId;
    if (id == null) return;
    server.deleteAccount(id);
    _setUser(null);
  }

  /// 목업 서버를 처음 상태로 되돌린 뒤 로그인 상태를 다시 알린다.
  void resetServer({bool signInDemo = true}) {
    server.reset();
    if (signInDemo) {
      this.signInDemo();
    } else {
      notifyListeners();
    }
  }

  void _setUser(String? id) {
    if (server.db.currentUserId == id) return;
    server.db.currentUserId = id;
    notifyListeners();
  }
}
