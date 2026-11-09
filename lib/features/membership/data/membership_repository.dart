import 'package:supabase_flutter/supabase_flutter.dart';

import 'membership_models.dart';

class MembershipRepository {
  MembershipRepository(this._client);

  final SupabaseClient _client;

  Future<List<Membership>> fetchMemberships(String userId) async {
    final rows = await _client.from('memberships').select().eq('user_id', userId).order('expires_at', ascending: false);
    return rows.map(Membership.fromJson).toList();
  }

  Future<List<MembershipPlan>> fetchPlans() async {
    final rows =
        await _client.from('membership_plans').select().eq('is_active', true).order('sort_order', ascending: true);
    return rows.map(MembershipPlan.fromJson).toList();
  }

  Future<List<Payment>> fetchPayments(String userId) async {
    final rows =
        await _client.from('payments').select().eq('user_id', userId).order('created_at', ascending: false).limit(100);
    return rows.map(Payment.fromJson).toList();
  }
}
