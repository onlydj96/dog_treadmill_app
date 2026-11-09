import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/supabase/supabase_providers.dart';
import '../booking/data/booking_models.dart';
import '../dogs/providers.dart';
import 'data/exercise_repository.dart';
import 'data/exercise_session.dart';

final exerciseRepositoryProvider = Provider<ExerciseRepository>(
  (ref) => ExerciseRepository(ref.watch(supabaseClientProvider)),
);

/// 선택된 반려견의 최신 세션 (Realtime)
final latestSessionProvider = StreamProvider.autoDispose<ExerciseSession?>((ref) {
  final dogId = ref.watch(activeDogIdProvider);
  if (dogId == null) return Stream.value(null);
  return ref.watch(exerciseRepositoryProvider).watchLatestSession(dogId);
});

/// 진행 중인 세션만 (없으면 null)
final liveSessionProvider = Provider.autoDispose<AsyncValue<ExerciseSession?>>((ref) {
  return ref.watch(latestSessionProvider).whenData(
        (session) => session != null && session.status.isActive ? session : null,
      );
});

final sessionsProvider = FutureProvider.autoDispose.family<List<ExerciseSession>, String>(
  (ref, dogId) => ref.watch(exerciseRepositoryProvider).fetchSessions(dogId),
);

/// 종료된 운동 기록 (최신순)
final finishedSessionsProvider = Provider.autoDispose.family<AsyncValue<List<ExerciseSession>>, String>(
  (ref, dogId) => ref.watch(sessionsProvider(dogId)).whenData(
        (sessions) => sessions.where((s) => !s.status.isActive).toList(),
      ),
);

final treadmillProvider = FutureProvider.autoDispose.family<Treadmill, String>(
  (ref, treadmillId) => ref.watch(exerciseRepositoryProvider).fetchTreadmill(treadmillId),
);
