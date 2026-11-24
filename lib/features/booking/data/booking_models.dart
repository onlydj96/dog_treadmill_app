import '../../../core/utils/json.dart';
import '../../../l10n/l10n.dart';
import '../../dogs/data/dog.dart';

class Branch {
  const Branch({
    required this.id,
    required String name,
    required String address,
    required this.opensAt,
    required this.closesAt,
    required this.slotMinutes,
    this.phone,
    this.is24Hours = false,
    this.nameEn,
    this.addressEn,
  })  : _name = name,
        _address = address;

  factory Branch.fromJson(Json json) => Branch(
        id: json.str('id'),
        name: json.str('name'),
        address: json.strOrNull('address') ?? '',
        phone: json.strOrNull('phone'),
        opensAt: _hhmm(json.strOrNull('opens_at')),
        closesAt: _hhmm(json.strOrNull('closes_at')),
        slotMinutes: json.intOr('slot_minutes', 30),
        is24Hours: json.boolOr('is_24_hours'),
        nameEn: json.strOrNull('name_en'),
        addressEn: json.strOrNull('address_en'),
      );

  final String id;
  final String _name;
  final String _address;

  /// 영어 값 (DB: branches.name_en / address_en). 없으면 한국어 값을 쓴다.
  final String? nameEn;
  final String? addressEn;
  final String? phone;

  /// 현재 언어의 지점명
  String get name => L10n.pick(_name, nameEn);

  /// 현재 언어의 주소
  String get address => L10n.pick(_address, addressEn);

  /// "10:00"
  final String opensAt;
  final String closesAt;
  final int slotMinutes;

  /// 24시간 운영 (DB: branches.is_24_hours). 자정을 넘기는 예약도 받는다.
  final bool is24Hours;

  String get hoursLabel => is24Hours ? L10n.current.bookingHours24 : '$opensAt ~ $closesAt';

  static String _hhmm(String? time) {
    if (time == null || time.length < 5) return '-';
    return time.substring(0, 5);
  }
}

class Treadmill {
  const Treadmill({required this.id, required this.deviceName, this.status});

  factory Treadmill.fromJson(Json json) => Treadmill(
        id: json.str('id'),
        deviceName: json.str('device_name'),
        status: json.strOrNull('status'),
      );

  final String id;
  final String deviceName;
  final String? status;
}

enum ProgramIntensity {
  low('low'),
  medium('medium'),
  high('high');

  const ProgramIntensity(this.dbValue);

  final String dbValue;

  String get label => switch (this) {
        ProgramIntensity.low => L10n.current.bookingIntensityLow,
        ProgramIntensity.medium => L10n.current.bookingIntensityMedium,
        ProgramIntensity.high => L10n.current.bookingIntensityHigh,
      };

  static ProgramIntensity fromDb(String? value) =>
      values.firstWhere((e) => e.dbValue == value, orElse: () => ProgramIntensity.medium);
}

class ExerciseProgram {
  const ExerciseProgram({
    required this.id,
    required String name,
    required this.durationMinutes,
    required this.intensity,
    String? description,
    this.targetSpeedKmh,
    this.nameEn,
    this.descriptionEn,
  })  : _name = name,
        _description = description;

  factory ExerciseProgram.fromJson(Json json) => ExerciseProgram(
        id: json.str('id'),
        name: json.str('name'),
        description: json.strOrNull('description'),
        durationMinutes: json.intOr('duration_minutes'),
        targetSpeedKmh: json.dblOrNull('target_speed_kmh'),
        intensity: ProgramIntensity.fromDb(json.strOrNull('intensity')),
        nameEn: json.strOrNull('name_en'),
        descriptionEn: json.strOrNull('description_en'),
      );

  final String id;
  final String _name;
  final String? _description;

  /// 영어 값 (DB: exercise_programs.name_en / description_en). 없으면 한국어 값을 쓴다.
  final String? nameEn;
  final String? descriptionEn;

  /// 현재 언어의 프로그램명
  String get name => L10n.pick(_name, nameEn);

  /// 현재 언어의 설명
  String? get description => L10n.pickOrNull(_description, descriptionEn);
  final int durationMinutes;
  final double? targetSpeedKmh;
  final ProgramIntensity intensity;
}

class TimeSlot {
  const TimeSlot({
    required this.start,
    required this.end,
    required this.availableCount,
    required this.totalCount,
  });

  factory TimeSlot.fromJson(Json json) => TimeSlot(
        start: json.dateTime('slot_start'),
        end: json.dateTime('slot_end'),
        availableCount: json.intOr('available_count'),
        totalCount: json.intOr('total_count'),
      );

  final DateTime start;
  final DateTime end;
  final int availableCount;
  final int totalCount;

  bool get isAvailable => availableCount > 0;
}

/// 예약 가능 시간 조회 키
typedef SlotQuery = ({String branchId, String programId, DateTime date});

enum BookingStatus {
  pending('pending'),
  confirmed('confirmed'),
  checkedIn('checked_in'),
  completed('completed'),
  cancelled('cancelled'),
  noShow('no_show');

  const BookingStatus(this.dbValue);

  final String dbValue;

  String get label => switch (this) {
        BookingStatus.pending => L10n.current.bookingStatusPending,
        BookingStatus.confirmed => L10n.current.bookingStatusConfirmed,
        BookingStatus.checkedIn => L10n.current.bookingStatusCheckedIn,
        BookingStatus.completed => L10n.current.bookingStatusCompleted,
        BookingStatus.cancelled => L10n.current.bookingStatusCancelled,
        BookingStatus.noShow => L10n.current.bookingStatusNoShow,
      };

  static BookingStatus fromDb(String value) =>
      values.firstWhere((e) => e.dbValue == value, orElse: () => BookingStatus.pending);

  bool get isActive => this == pending || this == confirmed || this == checkedIn;
}

class Booking {
  const Booking({
    required this.id,
    required this.dogId,
    required this.branchId,
    required this.treadmillId,
    required this.startAt,
    required this.endAt,
    required this.status,
    required this.createdAt,
    this.programId,
    this.membershipId,
    this.note,
    this.cancelReason,
    this.cancelledAt,
    this.branch,
    this.treadmill,
    this.program,
    this.dog,
    this.sessionId,
  });

  factory Booking.fromJson(Json json) {
    final branch = json.objOrNull('branch');
    final treadmill = json.objOrNull('treadmill');
    final program = json.objOrNull('program');
    final dog = json.objOrNull('dog');
    final session = json.objOrNull('session');
    return Booking(
      id: json.str('id'),
      dogId: json.str('dog_id'),
      branchId: json.str('branch_id'),
      treadmillId: json.str('treadmill_id'),
      programId: json.strOrNull('program_id'),
      membershipId: json.strOrNull('membership_id'),
      startAt: json.dateTime('start_at'),
      endAt: json.dateTime('end_at'),
      status: BookingStatus.fromDb(json.str('status')),
      note: json.strOrNull('note'),
      cancelReason: json.strOrNull('cancel_reason'),
      cancelledAt: json.dateTimeOrNull('cancelled_at'),
      createdAt: json.dateTime('created_at'),
      branch: branch == null ? null : Branch.fromJson(branch),
      treadmill: treadmill == null ? null : Treadmill.fromJson(treadmill),
      program: program == null ? null : ExerciseProgram.fromJson(program),
      dog: dog == null ? null : Dog.fromJson(dog),
      sessionId: session?.strOrNull('id'),
    );
  }

  /// 보호자가 앱에서 변경·취소할 수 있는 마감 (DB: private.booking_change_deadline)
  static const changeDeadline = Duration(hours: 1);

  /// 무인 매장 QR 체크인이 열리는 시점: 예약 시작 15분 전 (DB: private.check_in_opens_before)
  static const checkInOpensBefore = Duration(minutes: 15);

  final String id;
  final String dogId;
  final String branchId;
  final String treadmillId;
  final String? programId;
  final String? membershipId;
  final DateTime startAt;
  final DateTime endAt;
  final BookingStatus status;
  final String? note;
  final String? cancelReason;
  final DateTime? cancelledAt;
  final DateTime createdAt;
  final Branch? branch;
  final Treadmill? treadmill;
  final ExerciseProgram? program;
  final Dog? dog;
  final String? sessionId;

  bool get usesMembership => membershipId != null;

  bool canModify([DateTime? now]) {
    final current = now ?? DateTime.now();
    return (status == BookingStatus.pending || status == BookingStatus.confirmed) &&
        startAt.subtract(changeDeadline).isAfter(current);
  }

  bool isUpcoming([DateTime? now]) => status.isActive && endAt.isAfter(now ?? DateTime.now());

  DateTime get checkInOpensAt => startAt.subtract(checkInOpensBefore);

  /// QR 체크인 가능 여부: 결제 진행 중·확정 상태에서 시작 15분 전부터 종료 전까지
  bool canCheckIn([DateTime? now]) {
    final current = now ?? DateTime.now();
    return (status == BookingStatus.pending || status == BookingStatus.confirmed) &&
        !current.isBefore(checkInOpensAt) &&
        current.isBefore(endAt);
  }
}
