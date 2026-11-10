import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/supabase/supabase_providers.dart';
import 'consent.dart';

class ConsentRepository {
  ConsentRepository(this._client);

  final SupabaseClient _client;

  /// 유형별 최신 동의 상태
  Future<Map<ConsentType, DataConsent>> fetchLatest(String userId) async {
    final rows =
        await _client.from('data_consents').select().eq('user_id', userId).order('responded_at', ascending: false);

    final latest = <ConsentType, DataConsent>{};
    for (final row in rows) {
      final consent = DataConsent.fromJson(row);
      if (consent != null) latest.putIfAbsent(consent.type, () => consent);
    }
    return latest;
  }

  Future<void> record(String userId, ConsentType type, {required bool granted}) async {
    await _client.from('data_consents').insert({
      'user_id': userId,
      'consent_type': type.dbValue,
      'consent_version': type.currentVersion,
      'granted': granted,
    });
  }
}

final consentRepositoryProvider = Provider<ConsentRepository>(
  (ref) => ConsentRepository(ref.watch(supabaseClientProvider)),
);

final consentsProvider = FutureProvider.autoDispose<Map<ConsentType, DataConsent>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const {};
  return ref.watch(consentRepositoryProvider).fetchLatest(userId);
});

/// 운동 영상 촬영(AI 분석) 동의 여부. 동의 기록이 없으면 false, 아직 불러오지 못했으면 null.
final videoConsentGrantedProvider = Provider.autoDispose<bool?>((ref) {
  final consents = ref.watch(consentsProvider).valueOrNull;
  if (consents == null) return null;
  return consents[ConsentType.videoRecording]?.granted ?? false;
});
