import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/utils/json.dart';
import 'booking_models.dart';

class BookingRepository {
  BookingRepository(this._client);

  final SupabaseClient _client;

  static const _bookingColumns = '*, '
      'branch:branches(*), '
      'treadmill:treadmills(id, device_name, status), '
      'program:exercise_programs(*), '
      'dog:dogs(id, name, breed, profile_image_path), '
      'session:exercise_sessions(id)';

  Future<List<Branch>> fetchBranches() async {
    final rows = await _client.from('branches').select().eq('is_active', true).order('name', ascending: true);
    return rows.map(Branch.fromJson).toList();
  }

  Future<List<ExerciseProgram>> fetchPrograms() async {
    final rows =
        await _client.from('exercise_programs').select().eq('is_active', true).order('sort_order', ascending: true);
    return rows.map(ExerciseProgram.fromJson).toList();
  }

  Future<List<TimeSlot>> fetchAvailableSlots(SlotQuery query) async {
    final rows = await _client.rpc<List<dynamic>>('get_available_slots', params: {
      'p_branch_id': query.branchId,
      'p_date': toDateString(query.date),
      'p_program_id': query.programId,
    });
    return rows.cast<Json>().map(TimeSlot.fromJson).toList();
  }

  /// 예약 생성. 서버가 빈 트레드밀을 배정하고 이용권을 차감한다.
  Future<String> createBooking({
    required String dogId,
    required String branchId,
    required String programId,
    required DateTime startAt,
    String? membershipId,
    String? note,
  }) async {
    final row = await _client.rpc<Json>('create_booking', params: {
      'p_dog_id': dogId,
      'p_branch_id': branchId,
      'p_program_id': programId,
      'p_start_at': startAt.toUtc().toIso8601String(),
      'p_membership_id': membershipId,
      'p_note': note,
    });
    return row.str('id');
  }

  Future<List<Booking>> fetchBookings(String userId) async {
    final rows = await _client
        .from('bookings')
        .select(_bookingColumns)
        .eq('user_id', userId)
        .order('start_at', ascending: false)
        .limit(100);
    return rows.map(Booking.fromJson).toList();
  }

  Future<Booking> fetchBooking(String bookingId) async {
    final row = await _client.from('bookings').select(_bookingColumns).eq('id', bookingId).single();
    return Booking.fromJson(row);
  }

  /// 반려견의 다음 예약 (진행 중 포함)
  Future<Booking?> fetchNextBooking(String dogId) async {
    final row = await _client
        .from('bookings')
        .select(_bookingColumns)
        .eq('dog_id', dogId)
        .inFilter('status', ['pending', 'confirmed', 'checked_in'])
        .gt('end_at', DateTime.now().toUtc().toIso8601String())
        .order('start_at', ascending: true)
        .limit(1)
        .maybeSingle();
    return row == null ? null : Booking.fromJson(row);
  }

  Future<void> cancelBooking(String bookingId, {String? reason}) async {
    await _client.rpc<Json>('cancel_booking', params: {
      'p_booking_id': bookingId,
      'p_reason': reason,
    });
  }

  Future<void> rescheduleBooking(String bookingId, DateTime newStartAt) async {
    await _client.rpc<Json>('reschedule_booking', params: {
      'p_booking_id': bookingId,
      'p_new_start_at': newStartAt.toUtc().toIso8601String(),
    });
  }
}
