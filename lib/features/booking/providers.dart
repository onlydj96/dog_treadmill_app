import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/supabase/supabase_providers.dart';
import '../dogs/providers.dart';
import '../membership/providers.dart';
import 'data/booking_models.dart';
import 'data/booking_repository.dart';

final bookingRepositoryProvider = Provider<BookingRepository>(
  (ref) => BookingRepository(ref.watch(supabaseClientProvider)),
);

final branchesProvider = FutureProvider<List<Branch>>(
  (ref) => ref.watch(bookingRepositoryProvider).fetchBranches(),
);

final programsProvider = FutureProvider<List<ExerciseProgram>>(
  (ref) => ref.watch(bookingRepositoryProvider).fetchPrograms(),
);

final availableSlotsProvider = FutureProvider.autoDispose.family<List<TimeSlot>, SlotQuery>(
  (ref, query) => ref.watch(bookingRepositoryProvider).fetchAvailableSlots(query),
);

final myBookingsProvider = FutureProvider.autoDispose<List<Booking>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const [];
  return ref.watch(bookingRepositoryProvider).fetchBookings(userId);
});

final bookingDetailProvider = FutureProvider.autoDispose.family<Booking, String>(
  (ref, bookingId) => ref.watch(bookingRepositoryProvider).fetchBooking(bookingId),
);

/// 선택된 반려견의 다음 예약
final nextBookingProvider = FutureProvider.autoDispose<Booking?>((ref) async {
  final dogId = ref.watch(activeDogIdProvider);
  if (dogId == null) return null;
  return ref.watch(bookingRepositoryProvider).fetchNextBooking(dogId);
});

/// 예약 생성·변경·취소 후 관련 화면 데이터를 갱신한다.
void refreshBookingData(WidgetRef ref, {String? bookingId}) {
  ref
    ..invalidate(myBookingsProvider)
    ..invalidate(nextBookingProvider)
    ..invalidate(availableSlotsProvider)
    ..invalidate(membershipsProvider);
  if (bookingId != null) ref.invalidate(bookingDetailProvider(bookingId));
}
