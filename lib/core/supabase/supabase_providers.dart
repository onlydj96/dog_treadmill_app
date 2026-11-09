import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) => Supabase.instance.client);

/// main()에서 초기화한 인스턴스로 override 한다.
final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => throw UnimplementedError('sharedPreferencesProvider must be overridden in main()'),
);

final authStateChangesProvider = StreamProvider<AuthState>(
  (ref) => ref.watch(supabaseClientProvider).auth.onAuthStateChange,
);

/// 로그인한 사용자 ID. 로그아웃하면 null이 되어 사용자별 데이터 Provider가 초기화된다.
final currentUserIdProvider = Provider<String?>((ref) {
  final fromStream = ref.watch(
    authStateChangesProvider.select((state) => state.valueOrNull?.session?.user.id),
  );
  return fromStream ?? ref.watch(supabaseClientProvider).auth.currentUser?.id;
});
