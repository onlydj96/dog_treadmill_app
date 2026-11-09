import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/supabase/supabase_providers.dart';
import 'data/dog.dart';
import 'data/dog_repository.dart';

final dogRepositoryProvider = Provider<DogRepository>(
  (ref) => DogRepository(ref.watch(supabaseClientProvider)),
);

/// 로그인 사용자의 반려견 목록 (삭제된 반려견 제외)
final dogsProvider = FutureProvider<List<Dog>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const [];
  return ref.watch(dogRepositoryProvider).fetchDogs(userId);
});

/// 홈에서 선택한 반려견 ID. 기기에 저장해 앱을 다시 열어도 유지한다.
class SelectedDogIdNotifier extends Notifier<String?> {
  static String _key(String userId) => 'selected_dog_id.$userId';

  @override
  String? build() {
    final userId = ref.watch(currentUserIdProvider);
    if (userId == null) return null;
    return ref.watch(sharedPreferencesProvider).getString(_key(userId));
  }

  void select(String dogId) {
    state = dogId;
    final userId = ref.read(currentUserIdProvider);
    if (userId != null) {
      unawaited(ref.read(sharedPreferencesProvider).setString(_key(userId), dogId));
    }
  }
}

final selectedDogIdProvider = NotifierProvider<SelectedDogIdNotifier, String?>(
  SelectedDogIdNotifier.new,
);

/// 현재 선택된 반려견. 저장된 선택이 없거나 삭제되었으면 첫 번째 반려견.
final selectedDogProvider = Provider<AsyncValue<Dog?>>((ref) {
  final selectedId = ref.watch(selectedDogIdProvider);
  return ref.watch(dogsProvider).whenData((dogs) {
    if (dogs.isEmpty) return null;
    for (final dog in dogs) {
      if (dog.id == selectedId) return dog;
    }
    return dogs.first;
  });
});

/// 선택된 반려견 ID (데이터 Provider의 키로 사용)
final activeDogIdProvider = Provider<String?>(
  (ref) => ref.watch(selectedDogProvider).valueOrNull?.id,
);

final dogDetailProvider = FutureProvider.autoDispose.family<Dog, String>(
  (ref, dogId) => ref.watch(dogRepositoryProvider).fetchDog(dogId),
);

final dogHealthProfileProvider = FutureProvider.autoDispose.family<DogHealthProfile?, String>(
  (ref, dogId) => ref.watch(dogRepositoryProvider).fetchHealthProfile(dogId),
);

/// 비공개 버킷 이미지의 서명 URL (만료 전까지 캐시)
final dogImageUrlProvider = FutureProvider.autoDispose.family<String, String>((ref, path) async {
  final link = ref.keepAlive();
  final timer = Timer(const Duration(minutes: 50), link.close);
  ref.onDispose(timer.cancel);
  return ref.watch(dogRepositoryProvider).createSignedImageUrl(path);
});
