import '../../core/utils/json.dart';
import 'mock_db.dart';

/// 예약 RPC (supabase/migrations: get_available_slots, create_booking, cancel_booking,
/// reschedule_booking, self_check_in_booking)를 같은 규칙·같은 오류 코드로 옮긴 것.
class BookingApi {
  BookingApi(this.db, {this.onCheckedIn});

  final MockDb db;

  /// 셀프 체크인 직후 호출 (트레드밀 시뮬레이터가 운동을 시작한다)
  void Function(Json booking)? onCheckedIn;

  /// private.booking_change_deadline
  static const changeDeadline = Duration(hours: 1);

  /// private.check_in_opens_before
  static const checkInOpensBefore = Duration(minutes: 15);

  static const activeStatuses = {'pending', 'confirmed', 'checked_in'};

  // ---------------------------------------------------------------------
  // 조회 (테이블 select + 관계 임베드)
  // ---------------------------------------------------------------------

  /// `*, branch:branches(*), treadmill:treadmills(id, device_name, status), program:exercise_programs(*),
  /// dog:dogs(id, name, breed, profile_image_path), session:exercise_sessions(id)`
  Json embed(Json booking) {
    final treadmill = db.byId('treadmills', booking['treadmill_id'] as String?);
    final program = db.byId('exercise_programs', booking['program_id'] as String?);
    final dog = db.byId('dogs', booking['dog_id'] as String?);
    final branch = db.byId('branches', booking['branch_id'] as String?);
    final dogWithCatalog = dog == null ? null : db.dogWithBreedCatalog(dog);
    return {
      ...booking,
      'branch': branch == null ? null : {...branch},
      'treadmill': treadmill == null
          ? null
          : {'id': treadmill['id'], 'device_name': treadmill['device_name'], 'status': treadmill['status']},
      'program': program == null ? null : {...program},
      'dog': dog == null
          ? null
          : {
              'id': dog['id'],
              'name': dog['name'],
              'name__en': dog['name__en'],
              'breed': dog['breed'],
              'breed_catalog': dogWithCatalog!['breed_catalog'],
              'profile_image_path': dog['profile_image_path'],
            },
      'session': [
        for (final s in db.where('exercise_sessions', (s) => s['booking_id'] == booking['id'])) {'id': s['id']},
      ],
    };
  }

  List<Json> bookingsOf(String userId) {
    final rows = db.where('bookings', (b) => b['user_id'] == userId).toList()
      ..sort((a, b) => b.str('start_at').compareTo(a.str('start_at')));
    return rows.take(100).map(embed).toList();
  }

  Json booking(String bookingId) => embed(db.byId('bookings', bookingId) ?? rowNotFound());

  /// 반려견의 다음 예약 (진행 중 포함)
  Json? nextBooking(String dogId) {
    final now = db.now();
    final rows = db
        .where(
          'bookings',
          (b) => b['dog_id'] == dogId && activeStatuses.contains(b['status']) && b.dateTime('end_at').isAfter(now),
        )
        .toList()
      ..sort((a, b) => a.str('start_at').compareTo(b.str('start_at')));
    return rows.isEmpty ? null : embed(rows.first);
  }

  // ---------------------------------------------------------------------
  // RPC
  // ---------------------------------------------------------------------

  /// public.get_available_slots
  List<Json> availableSlots({required String branchId, required DateTime date, required String programId}) {
    db.requireUser();
    final branch = _activeBranch(branchId);
    final duration = _activeProgram(programId).intOr('duration_minutes');
    final slot = branch.intOr('slot_minutes', 30);
    final opens = Kst.minutesOf(branch.str('opens_at'));
    var closes = Kst.minutesOf(branch.str('closes_at'));
    final is24Hours = branch.boolOr('is_24_hours');
    if (is24Hours && closes <= opens) closes += 24 * 60;
    final lastStart = is24Hours ? closes - slot : closes - duration;

    final day = DateTime.utc(date.year, date.month, date.day);
    final treadmills = machines(branchId);
    final now = db.now();
    return [
      for (var minute = opens; minute <= lastStart; minute += slot)
        if (Kst.at(day, minute).isAfter(now)) _slotRow(Kst.at(day, minute), Duration(minutes: duration), treadmills),
    ];
  }

  Json _slotRow(DateTime start, Duration duration, List<Json> treadmills) {
    final end = start.add(duration);
    return {
      'slot_start': iso(start),
      'slot_end': iso(end),
      'available_count': treadmills.where((t) => !treadmillBusy(t.str('id'), start, end)).length,
      'total_count': treadmills.length,
    };
  }

  /// public.create_booking: 빈 트레드밀을 배정하고, 이용권을 쓰면 1회 차감하고 바로 확정한다.
  Json createBooking({
    required String dogId,
    required String branchId,
    required String programId,
    required DateTime startAt,
    String? membershipId,
    String? note,
  }) {
    final uid = db.requireUser();
    db.find('dogs', (d) => d['id'] == dogId && d['owner_id'] == uid && d['deleted_at'] == null) ??
        rpcError('DOG_NOT_FOUND', 'P0002');
    final branch = _activeBranch(branchId);
    final duration = _activeProgram(programId).intOr('duration_minutes');

    _assertBookableSlot(branch, startAt, duration);
    final endAt = startAt.add(Duration(minutes: duration));
    if (_dogBusy(dogId, startAt, endAt)) rpcError('DOG_ALREADY_BOOKED', '23P01');

    Json? membership;
    if (membershipId != null) {
      membership = db.find('memberships', (m) => m['id'] == membershipId && m['user_id'] == uid) ??
          rpcError('MEMBERSHIP_NOT_FOUND', 'P0002');
      if (!_membershipUsable(membership, startAt, endAt)) rpcError('MEMBERSHIP_NOT_USABLE', '22023');
    }

    final treadmill = machines(branchId).where((t) => !treadmillBusy(t.str('id'), startAt, endAt)).firstOrNull ??
        rpcError('SLOT_FULL', '23P01');

    final trimmedNote = note?.trim();
    final booking = db.insert('bookings', {
      'user_id': uid,
      'dog_id': dogId,
      'branch_id': branchId,
      'treadmill_id': treadmill['id'],
      'program_id': programId,
      'membership_id': membershipId,
      'start_at': iso(startAt),
      'end_at': iso(endAt),
      'status': membershipId != null ? 'confirmed' : 'pending',
      'note': (trimmedNote == null || trimmedNote.isEmpty) ? null : trimmedNote,
      'cancel_reason': null,
      'cancelled_at': null,
    });
    if (membership != null) {
      db.update('memberships', membership, {'remaining_sessions': membership.intOr('remaining_sessions') - 1});
    }
    return booking;
  }

  /// public.cancel_booking: 시작 1시간 전까지. 사용한 이용권 회차를 복구한다.
  void cancelBooking(String bookingId, {String? reason}) {
    final booking = _ownBooking(bookingId);
    if (booking['status'] != 'pending' && booking['status'] != 'confirmed') {
      rpcError('BOOKING_NOT_CANCELLABLE', '22023');
    }
    _assertBeforeDeadline(booking);

    final trimmed = reason?.trim();
    db.update('bookings', booking, {
      'status': 'cancelled',
      'cancelled_at': iso(db.now()),
      'cancel_reason': (trimmed == null || trimmed.isEmpty) ? null : trimmed,
    });
    final membership = db.byId('memberships', booking['membership_id'] as String?);
    if (membership != null) {
      final restored = membership.intOr('remaining_sessions') + 1;
      final total = membership.intOr('total_sessions');
      db.update('memberships', membership, {'remaining_sessions': restored > total ? total : restored});
    }
  }

  /// public.reschedule_booking: 같은 지점·같은 길이로 시간만 옮긴다.
  void rescheduleBooking(String bookingId, DateTime newStartAt) {
    final booking = _ownBooking(bookingId);
    if (booking['status'] != 'pending' && booking['status'] != 'confirmed') {
      rpcError('BOOKING_NOT_CANCELLABLE', '22023');
    }
    _assertBeforeDeadline(booking);
    final branch = db.find('branches', (b) => b['id'] == booking['branch_id'] && b['is_active'] == true) ??
        rpcError('BRANCH_NOT_FOUND', 'P0002');

    final duration = booking.dateTime('end_at').difference(booking.dateTime('start_at')).inMinutes;
    _assertBookableSlot(branch, newStartAt, duration);
    final newEndAt = newStartAt.add(Duration(minutes: duration));

    final membership = db.byId('memberships', booking['membership_id'] as String?);
    if (membership != null &&
        (membership.dateTime('starts_at').isAfter(newStartAt) ||
            membership.dateTime('expires_at').isBefore(newEndAt))) {
      rpcError('MEMBERSHIP_NOT_USABLE', '22023');
    }
    if (_dogBusy(booking.str('dog_id'), newStartAt, newEndAt, excludeBookingId: bookingId)) {
      rpcError('DOG_ALREADY_BOOKED', '23P01');
    }
    final treadmill = machines(booking.str('branch_id'))
            .where((t) => !treadmillBusy(t.str('id'), newStartAt, newEndAt, excludeBookingId: bookingId))
            .firstOrNull ??
        rpcError('SLOT_FULL', '23P01');

    db.update('bookings', booking, {
      'start_at': iso(newStartAt),
      'end_at': iso(newEndAt),
      'treadmill_id': treadmill['id'],
    });
  }

  /// public.self_check_in_booking: 무인 매장 셀프 체크인 (시작 15분 전 ~ 종료 전)
  void selfCheckIn(String bookingId) {
    final booking = _ownBooking(bookingId);
    if (booking['status'] != 'pending' && booking['status'] != 'confirmed') {
      rpcError('INVALID_BOOKING_STATUS', '22023');
    }
    final now = db.now();
    if (now.isBefore(booking.dateTime('start_at').subtract(checkInOpensBefore))) {
      rpcError('CHECK_IN_TOO_EARLY', '22023');
    }
    if (!now.isBefore(booking.dateTime('end_at'))) rpcError('CHECK_IN_CLOSED', '22023');

    db.update('bookings', booking, {'status': 'checked_in'});
    onCheckedIn?.call(booking);
  }

  // ---------------------------------------------------------------------
  // 검증 (private.assert_bookable_slot 등)
  // ---------------------------------------------------------------------

  Json _ownBooking(String bookingId) {
    final uid = db.requireUser();
    return db.find('bookings', (b) => b['id'] == bookingId && b['user_id'] == uid) ??
        rpcError('BOOKING_NOT_FOUND', 'P0002');
  }

  void _assertBeforeDeadline(Json booking) {
    if (!booking.dateTime('start_at').subtract(changeDeadline).isAfter(db.now())) {
      rpcError('CHANGE_DEADLINE_PASSED', '22023');
    }
  }

  Json _activeBranch(String branchId) =>
      db.find('branches', (b) => b['id'] == branchId && b['is_active'] == true) ??
      rpcError('BRANCH_NOT_FOUND', 'P0002');

  Json _activeProgram(String programId) =>
      db.find('exercise_programs', (p) => p['id'] == programId && p['is_active'] == true) ??
      rpcError('PROGRAM_NOT_FOUND', 'P0002');

  /// 예약 가능한 트레드밀 (기기 이름순)
  List<Json> machines(String branchId) => db
      .where('treadmills', (t) => t['branch_id'] == branchId && (t['status'] == 'available' || t['status'] == 'in_use'))
      .toList()
    ..sort((a, b) => a.str('device_name').compareTo(b.str('device_name')));

  bool _overlaps(Json booking, DateTime start, DateTime end) =>
      booking.dateTime('start_at').isBefore(end) && start.isBefore(booking.dateTime('end_at'));

  bool treadmillBusy(String treadmillId, DateTime start, DateTime end, {String? excludeBookingId}) =>
      db.table('bookings').any((b) =>
          b['treadmill_id'] == treadmillId &&
          b['id'] != excludeBookingId &&
          activeStatuses.contains(b['status']) &&
          _overlaps(b, start, end));

  bool _dogBusy(String dogId, DateTime start, DateTime end, {String? excludeBookingId}) =>
      db.table('bookings').any((b) =>
          b['dog_id'] == dogId &&
          b['id'] != excludeBookingId &&
          activeStatuses.contains(b['status']) &&
          _overlaps(b, start, end));

  bool _membershipUsable(Json m, DateTime start, DateTime end) =>
      m['status'] == 'active' &&
      m.intOr('remaining_sessions') > 0 &&
      !m.dateTime('starts_at').isAfter(start) &&
      !m.dateTime('expires_at').isBefore(end);

  void _assertBookableSlot(Json branch, DateTime startAt, int durationMinutes) {
    if (!startAt.isAfter(db.now())) rpcError('SLOT_IN_PAST', '22023');

    final wall = Kst.wall(startAt);
    final startMinute = wall.hour * 60 + wall.minute;
    final opens = Kst.minutesOf(branch.str('opens_at'));
    final slot = branch.intOr('slot_minutes', 30);
    if ((startMinute - opens) % slot != 0 || wall.second != 0 || wall.millisecond != 0) {
      rpcError('SLOT_NOT_AVAILABLE', '22023');
    }
    if (branch.boolOr('is_24_hours')) return;

    final closes = Kst.minutesOf(branch.str('closes_at'));
    if (startMinute < opens || startMinute + durationMinutes > closes) rpcError('SLOT_NOT_AVAILABLE', '22023');
  }
}
