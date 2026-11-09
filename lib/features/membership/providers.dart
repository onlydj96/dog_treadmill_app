import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/supabase/supabase_providers.dart';
import 'data/membership_models.dart';
import 'data/membership_repository.dart';

final membershipRepositoryProvider = Provider<MembershipRepository>(
  (ref) => MembershipRepository(ref.watch(supabaseClientProvider)),
);

final membershipsProvider = FutureProvider.autoDispose<List<Membership>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const [];
  return ref.watch(membershipRepositoryProvider).fetchMemberships(userId);
});

final membershipPlansProvider = FutureProvider.autoDispose<List<MembershipPlan>>(
  (ref) => ref.watch(membershipRepositoryProvider).fetchPlans(),
);

final paymentsProvider = FutureProvider.autoDispose<List<Payment>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return const [];
  return ref.watch(membershipRepositoryProvider).fetchPayments(userId);
});
