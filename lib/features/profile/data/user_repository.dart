import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_providers.dart';
import 'app_user.dart';

class UserRepository {
  UserRepository(this._client);

  final SupabaseClient _client;

  Future<AppUser> fetchUser(String userId) async {
    final row = await _client.from('users').select().eq('id', userId).single();
    return AppUser.fromJson(row);
  }

  Future<void> updateProfile(String userId, {required String name, String? phone}) async {
    await _client.from('users').update({
      'name': name.trim(),
      'phone': (phone == null || phone.trim().isEmpty) ? null : phone.trim(),
    }).eq('id', userId);
  }

  Future<void> updateNotificationPrefs(String userId, NotificationPrefs prefs) async {
    await _client.from('users').update({'notification_prefs': prefs.toJson()}).eq('id', userId);
  }

  /// 닉네임 변경 (형식·금칙어·중복·30일 주기는 서버가 검증한다). 저장된 닉네임을 돌려준다.
  Future<String> setNickname(String nickname) async {
    return await _client.rpc<String>('set_nickname', params: {'p_nickname': nickname.trim()});
  }

  /// 랭킹에 반려견 프로필 사진을 보여줄지
  Future<void> updateRankingShowPhoto(String userId, {required bool show}) async {
    await _client.from('users').update({'ranking_show_photo': show}).eq('id', userId);
  }
}

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepository(ref.watch(supabaseClientProvider)),
);

final currentUserProfileProvider = FutureProvider<AppUser?>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return null;
  return ref.watch(userRepositoryProvider).fetchUser(userId);
});
