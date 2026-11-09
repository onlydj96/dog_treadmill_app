import '../../../core/utils/json.dart';

enum SessionStatus {
  ready('ready', '준비 중'),
  running('running', '운동 중'),
  paused('paused', '일시정지'),
  completed('completed', '운동 완료'),
  stopped('stopped', '운동 중단');

  const SessionStatus(this.dbValue, this.label);

  final String dbValue;
  final String label;

  static SessionStatus fromDb(String value) =>
      values.firstWhere((e) => e.dbValue == value, orElse: () => SessionStatus.ready);

  bool get isActive => this == ready || this == running || this == paused;
}

class SessionReportRef {
  const SessionReportRef({required this.id, required this.status});

  final String id;
  final String status;

  bool get isCompleted => status == 'completed';
}

class ExerciseSession {
  const ExerciseSession({
    required this.id,
    required this.dogId,
    required this.status,
    required this.durationSeconds,
    required this.distanceMeters,
    required this.currentSpeed,
    required this.createdAt,
    this.bookingId,
    this.treadmillId,
    this.treadmillName,
    this.startedAt,
    this.endedAt,
    this.averageSpeed,
    this.maxSpeed,
    this.targetDurationSeconds,
    this.stopReason,
    this.updatedAt,
    this.reports = const [],
  });

  factory ExerciseSession.fromJson(Json json) {
    final treadmill = json.objOrNull('treadmill');
    final reports = json
        .objList('reports')
        .map((r) => SessionReportRef(id: r.str('id'), status: r.str('analysis_status')))
        .toList();
    return ExerciseSession(
      id: json.str('id'),
      dogId: json.str('dog_id'),
      bookingId: json.strOrNull('booking_id'),
      treadmillId: json.strOrNull('treadmill_id'),
      treadmillName: treadmill?.strOrNull('device_name'),
      status: SessionStatus.fromDb(json.str('status')),
      startedAt: json.dateTimeOrNull('started_at'),
      endedAt: json.dateTimeOrNull('ended_at'),
      durationSeconds: json.intOr('duration_seconds'),
      distanceMeters: json.dblOr('distance_meters'),
      currentSpeed: json.dblOr('current_speed'),
      averageSpeed: json.dblOrNull('average_speed'),
      maxSpeed: json.dblOrNull('max_speed'),
      targetDurationSeconds: json.intOrNull('target_duration_seconds'),
      stopReason: json.strOrNull('stop_reason'),
      createdAt: json.dateTime('created_at'),
      updatedAt: json.dateTimeOrNull('updated_at'),
      reports: reports,
    );
  }

  final String id;
  final String dogId;
  final String? bookingId;
  final String? treadmillId;
  final String? treadmillName;
  final SessionStatus status;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final int durationSeconds;
  final double distanceMeters;
  final double currentSpeed;
  final double? averageSpeed;
  final double? maxSpeed;
  final int? targetDurationSeconds;
  final String? stopReason;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<SessionReportRef> reports;

  /// 운동 기준일 (시작 전이면 생성 시각)
  DateTime get date => startedAt ?? createdAt;

  /// 실시간 경과 시간. 운동 중이면 마지막 갱신 이후 시간을 더해 매초 자연스럽게 증가시킨다.
  int elapsedSeconds(DateTime now) {
    if (status == SessionStatus.running) {
      final since = updatedAt ?? startedAt;
      if (durationSeconds == 0 && startedAt != null) {
        return now.difference(startedAt!).inSeconds.clamp(0, 24 * 3600);
      }
      if (since != null) {
        return durationSeconds + now.difference(since).inSeconds.clamp(0, 600);
      }
    }
    return durationSeconds;
  }

  double? progress(DateTime now) {
    final target = targetDurationSeconds;
    if (target == null || target <= 0) return null;
    return (elapsedSeconds(now) / target).clamp(0.0, 1.0);
  }

  SessionReportRef? get latestReport => reports.isEmpty ? null : reports.first;
}
