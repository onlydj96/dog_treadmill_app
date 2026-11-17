import 'dart:async';
import 'dart:math';

import '../../core/utils/json.dart';
import 'booking_api.dart';
import 'catalog.dart';
import 'gait_report.dart';
import 'mock_db.dart';
import 'ranking_api.dart';

double _round1(double value) => (value * 10).round() / 10;

/// 운동 중인 세션의 시뮬레이션 상태
class _LiveRun {
  _LiveRun({required this.cruiseKmh, required this.intensity, required this.targetSeconds});

  final double cruiseKmh;
  final String intensity;
  final int targetSeconds;
  double elapsed = 0;
  double distance = 0;
  double maxSpeed = 0;
}

/// 트레드밀 기기 흉내. 실제로는 기기가 지점 관리자 계정으로 start_exercise_session →
/// update_exercise_session_metrics → finish_exercise_session을 호출한다 (README "무인 운영 흐름").
///
/// 지표는 [speedFactor]배 빠르게 흐른다 (15분 프로그램을 x10이면 1분 30초에 마친다).
class TreadmillSimulator {
  TreadmillSimulator(this.db, {required this.booking, required this.ranking, required this.analysis});

  final MockDb db;
  final BookingApi booking;
  final RankingApi ranking;
  final AiAnalysisSimulator analysis;

  /// 시뮬레이션 배속 (실제 1초에 운동 시간 몇 초가 지나는지)
  double speedFactor = 10;

  /// false면 타이머 없이 [tick]을 직접 불러 진행한다 (테스트용)
  bool autoTick = true;

  /// 셀프 체크인 후 보호자가 기기에서 시작 버튼을 누르기까지 걸리는 시간. null이면 자동으로 시작하지 않는다.
  Duration? autoStartAfterCheckIn = const Duration(seconds: 3);

  final Map<String, _LiveRun> _runs = {};
  final List<Timer> _pending = [];
  Timer? _ticker;

  bool get hasLiveSession => _runs.isNotEmpty;

  /// 셀프 체크인 직후 (BookingApi.onCheckedIn)
  void onCheckedIn(Json checkedIn) {
    final delay = autoStartAfterCheckIn;
    if (delay == null) return;
    final bookingId = checkedIn.str('id');
    void start() {
      final current = db.byId('bookings', bookingId);
      if (current?['status'] == 'checked_in' && !_hasSession(bookingId)) startSession(bookingId);
    }

    if (delay == Duration.zero) {
      start();
    } else {
      _pending.add(Timer(delay, start));
    }
  }

  bool _hasSession(String bookingId) => db.table('exercise_sessions').any((s) => s['booking_id'] == bookingId);

  /// 기기: 운동 시작 (public.start_exercise_session)
  Json startSession(String bookingId) {
    final row = db.byId('bookings', bookingId) ?? rpcError('BOOKING_NOT_FOUND', 'P0002');
    if (!BookingApi.activeStatuses.contains(row['status'])) rpcError('INVALID_BOOKING_STATUS', '22023');
    if (_hasSession(bookingId)) rpcError('SESSION_ALREADY_EXISTS', '23505');

    final program = db.byId('exercise_programs', row['program_id'] as String?);
    final target = program != null
        ? program.intOr('duration_minutes') * 60
        : row.dateTime('end_at').difference(row.dateTime('start_at')).inSeconds;
    final now = iso(db.now());
    final session = db.insert('exercise_sessions', {
      'dog_id': row['dog_id'],
      'booking_id': bookingId,
      'treadmill_id': row['treadmill_id'],
      'status': 'running',
      'started_at': now,
      'ended_at': null,
      'duration_seconds': 0,
      'distance_meters': 0.0,
      'current_speed': 0.0,
      'average_speed': null,
      'max_speed': null,
      'target_duration_seconds': target,
      'stop_reason': null,
      'updated_at': now,
    });
    if (row['status'] != 'checked_in') db.update('bookings', row, {'status': 'checked_in'});
    final treadmill = db.byId('treadmills', row['treadmill_id'] as String?);
    if (treadmill?['status'] == 'available') db.update('treadmills', treadmill!, {'status': 'in_use'});

    final dog = db.byId('dogs', row.str('dog_id'))!;
    db.notify(
      dog['owner_id'] as String?,
      'exercise',
      '운동을 시작했어요',
      '${dog['name']}의 트레드밀 운동이 시작되었습니다. 실시간 현황을 확인해 보세요.',
      data: {'session_id': session['id']},
      msg: 'exercise_started',
      args: MockDb.dogNameArgs(dog),
    );

    _runs[session.str('id')] = _LiveRun(
      cruiseKmh: cruiseSpeed(dog, program?['intensity'] as String? ?? 'medium', random: db.random),
      intensity: program?['intensity'] as String? ?? 'medium',
      targetSeconds: target,
    );
    if (autoTick) _ticker ??= Timer.periodic(const Duration(seconds: 1), (_) => tick());
    return session;
  }

  /// 데모 컨트롤 "운동 시작": 지금 쓸 수 있는 예약이 있으면 그 예약으로, 없으면 바로 이용하는 예약을 만들어 시작한다.
  Json startForDog(String dogId) {
    final now = db.now();
    final usable = db
        .where(
          'bookings',
          (b) =>
              b['dog_id'] == dogId &&
              BookingApi.activeStatuses.contains(b['status']) &&
              b.dateTime('end_at').isAfter(now) &&
              b.dateTime('start_at').isBefore(now.add(const Duration(minutes: 30))) &&
              !_hasSession(b.str('id')),
        )
        .toList()
      ..sort((a, b) => a.str('start_at').compareTo(b.str('start_at')));
    return startSession((usable.firstOrNull ?? _walkInBooking(dogId)).str('id'));
  }

  Json _walkInBooking(String dogId) {
    final dog = db.byId('dogs', dogId) ?? rpcError('DOG_NOT_FOUND', 'P0002');
    final branchId = _favoriteBranch(dogId) ?? MockCatalog.yongsan;
    final now = db.now();
    final start = DateTime.fromMillisecondsSinceEpoch(now.millisecondsSinceEpoch - now.millisecondsSinceEpoch % 60000);
    final end = start.add(const Duration(minutes: 15));
    final machines = booking.machines(branchId);
    final treadmill =
        machines.where((t) => !booking.treadmillBusy(t.str('id'), start, end)).firstOrNull ?? machines.first;
    return db.insert('bookings', {
      'user_id': dog['owner_id'],
      'dog_id': dogId,
      'branch_id': branchId,
      'treadmill_id': treadmill['id'],
      'program_id': MockCatalog.gaitCheck,
      'membership_id': null,
      'start_at': iso(start),
      'end_at': iso(end),
      'status': 'checked_in',
      'note': null,
      'cancel_reason': null,
      'cancelled_at': null,
    });
  }

  String? _favoriteBranch(String dogId) {
    final counts = <String, int>{};
    for (final b in db.where('bookings', (b) => b['dog_id'] == dogId && b['status'] == 'completed')) {
      counts[b.str('branch_id')] = (counts[b.str('branch_id')] ?? 0) + 1;
    }
    final sorted = counts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return sorted.firstOrNull?.key;
  }

  /// 체구·강도별 평균 걷는 속도(km/h). 반려견마다 조금씩 다르다.
  static double cruiseSpeed(Json dog, String intensity, {required Random random}) {
    final (low, medium, high) = switch (dog['size_class']) {
      'small' => (2.4, 2.9, 3.4),
      'large' => (3.8, 4.8, 5.6),
      _ => (3.2, 4.0, 4.6),
    };
    final base = switch (intensity) {
      'low' => low,
      'high' => high,
      _ => medium,
    };
    return base * (0.94 + random.nextDouble() * 0.12);
  }

  /// 준비 운동(처음 10%) → 본 운동 → 정리 운동(마지막 10%). 고강도는 2분 걷기·1분 가볍게 달리기를 반복한다.
  double _speedAt(_LiveRun run, double t) {
    final progress = t / run.targetSeconds;
    var factor = 1.0;
    if (progress < 0.1) {
      factor = 0.55 + 4.5 * progress;
    } else if (progress > 0.9) {
      factor = 1.0 - 4.0 * (progress - 0.9);
    } else if (run.intensity == 'high' && t % 180 >= 120) {
      factor = 1.45;
    }
    return run.cruiseKmh * factor * (0.97 + db.random.nextDouble() * 0.06);
  }

  /// 운동 중인 세션의 지표를 [seconds]초(기본: 배속) 진행하고 Realtime으로 보낸다.
  void tick([double? seconds]) {
    final step = seconds ?? speedFactor;
    for (final sessionId in _runs.keys.toList()) {
      _advance(sessionId, step);
    }
    _stopTickerIfIdle();
  }

  /// 데모 컨트롤 "바로 완료": 남은 운동 시간을 한 번에 진행해 목표를 채우고 끝낸다.
  void completeNow(String sessionId) {
    final session = _activeSession(sessionId);
    final run = _runs[sessionId];
    if (run == null) {
      finish(sessionId, completed: true);
      return;
    }
    if (session['status'] == 'paused') db.update('exercise_sessions', session, {'status': 'running'});
    _advance(sessionId, run.targetSeconds - run.elapsed);
    _stopTickerIfIdle();
  }

  void _advance(String sessionId, double step) {
    final run = _runs[sessionId];
    final session = db.byId('exercise_sessions', sessionId);
    if (run == null || session == null) {
      _runs.remove(sessionId);
      return;
    }
    if (session['status'] != 'running') return;

    var remaining = min(step, run.targetSeconds - run.elapsed);
    var speed = 0.0;
    while (remaining > 0) {
      final dt = min(1.0, remaining);
      speed = _speedAt(run, run.elapsed);
      run
        ..distance += speed / 3.6 * dt
        ..elapsed += dt
        ..maxSpeed = max(run.maxSpeed, speed);
      remaining -= dt;
    }
    db.update('exercise_sessions', session, {
      'current_speed': _round1(speed),
      'distance_meters': _round1(run.distance),
      'duration_seconds': run.elapsed.floor(),
      'max_speed': _round1(run.maxSpeed),
      'updated_at': iso(db.now()),
    });
    if (run.elapsed >= run.targetSeconds) finish(sessionId, completed: true);
  }

  Json _activeSession(String sessionId) {
    final session = db.byId('exercise_sessions', sessionId) ?? rpcError('SESSION_NOT_FOUND', 'P0002');
    if (!const {'ready', 'running', 'paused'}.contains(session['status'])) rpcError('SESSION_NOT_ACTIVE', '22023');
    return session;
  }

  /// 기기: 일시정지·재개 (update_exercise_session_metrics의 p_status)
  void setPaused(String sessionId, {required bool paused}) {
    final session = _activeSession(sessionId);
    db.update('exercise_sessions', session, {
      'status': paused ? 'paused' : 'running',
      if (paused) 'current_speed': 0.0,
      'updated_at': iso(db.now()),
    });
  }

  /// 기기: 운동 종료·중단 (public.finish_exercise_session)
  ///
  /// 점수 적립 트리거 → 완료 알림 → (영상 촬영 동의 시) AI 분석 대기열 순서는 실제 DB와 같다.
  Json finish(String sessionId, {required bool completed, String? stopReason, String? stopReasonEn}) {
    final session = _activeSession(sessionId);
    _runs.remove(sessionId);

    final duration = session.intOr('duration_seconds');
    final distance = session.dblOr('distance_meters');
    final startedAt = session.dateTimeOrNull('started_at') ?? db.now();
    final reason = stopReason?.trim();
    db.update('exercise_sessions', session, {
      'status': completed ? 'completed' : 'stopped',
      // 배속 시뮬레이션이어도 기록은 실제 운동 시간만큼 걸린 것으로 남긴다
      'ended_at': iso(startedAt.add(Duration(seconds: duration))),
      'current_speed': 0.0,
      'stop_reason': completed ? null : ((reason == null || reason.isEmpty) ? '운영자 판단에 의한 중단' : reason),
      'stop_reason__en': completed || reason == null || reason.isEmpty ? null : stopReasonEn,
      'average_speed': duration > 0 ? _round1(distance / duration * 3.6) : null,
      'updated_at': iso(db.now()),
    });

    final row = db.byId('bookings', session['booking_id'] as String?);
    if (row != null && BookingApi.activeStatuses.contains(row['status'])) {
      db.update('bookings', row, {'status': 'completed'});
    }
    final treadmill = db.byId('treadmills', session['treadmill_id'] as String?);
    if (treadmill?['status'] == 'in_use') db.update('treadmills', treadmill!, {'status': 'available'});

    ranking.awardSessionPoints(session);

    final dog = db.byId('dogs', session.str('dog_id'))!;
    final ownerId = dog['owner_id'] as String?;
    if (completed) {
      final points = db
          .where('exercise_points', (p) => p['session_id'] == sessionId && p['voided_at'] == null)
          .fold<int>(0, (sum, p) => sum + p.intOr('points'));
      db.notify(
        ownerId,
        'exercise',
        '운동을 완료했어요',
        points > 0
            ? '${dog['name']}의 운동이 끝났어요. $points점을 받았어요! 운동 기록을 확인해 보세요.'
            : '${dog['name']}의 운동이 끝났어요. 운동 기록을 확인해 보세요.',
        data: {'session_id': sessionId},
        msg: 'exercise_completed',
        args: {...MockDb.dogNameArgs(dog), 'points': points},
      );
    } else {
      db.notify(
        ownerId,
        'exercise',
        '운동이 중단되었어요',
        '${dog['name']}의 운동이 중단되었습니다. 사유: ${session['stop_reason'] ?? '-'}',
        data: {'session_id': sessionId},
        msg: 'exercise_stopped',
        args: {
          ...MockDb.dogNameArgs(dog),
          'reason': session['stop_reason'],
          'reason__en': session['stop_reason__en'],
        },
      );
    }

    if (db.hasConsent(ownerId, 'video_recording')) analysis.enqueue(session);
    _stopTickerIfIdle();
    return session;
  }

  void _stopTickerIfIdle() {
    if (_runs.isNotEmpty) return;
    _ticker?.cancel();
    _ticker = null;
  }

  void stopAll() {
    _ticker?.cancel();
    _ticker = null;
    for (final timer in _pending) {
      timer.cancel();
    }
    _pending.clear();
    _runs.clear();
  }
}

/// AI 서버 흉내: queued → processing → completed 로 바꾸고 결과를 저장한다 (docs/analysis-metrics.md 처리 흐름).
class AiAnalysisSimulator {
  AiAnalysisSimulator(this.db);

  final MockDb db;

  /// false면 [complete]/[completeAllPending]을 직접 불러야 끝난다 (테스트용)
  bool autoProcess = true;
  Duration processingAfter = const Duration(seconds: 3);
  Duration completedAfter = const Duration(seconds: 8);

  final List<Timer> _timers = [];

  /// finish_exercise_session: 영상 촬영 동의자의 운동만 분석 대기열에 등록한다.
  Json enqueue(Json session) {
    final report = db.insert('analysis_reports', {
      'session_id': session['id'],
      'dog_id': session['dog_id'],
      'analysis_status': 'queued',
      'joint_metrics': null,
      'gait_metrics': null,
      'anomaly_metrics': null,
      'summary': null,
      'care_notes': <String>[],
      'skeleton_video_path': null,
      'report_pdf_path': null,
      'model_version': null,
      'completed_at': null,
    });
    if (autoProcess) {
      final id = report.str('id');
      _timers
        ..add(Timer(processingAfter, () => _markProcessing(id)))
        ..add(Timer(completedAfter, () => complete(id)));
    }
    return report;
  }

  void _markProcessing(String reportId) {
    final report = db.byId('analysis_reports', reportId);
    if (report?['analysis_status'] == 'queued') {
      db.update('analysis_reports', report!, {'analysis_status': 'processing'});
    }
  }

  bool get hasPending =>
      db.table('analysis_reports').any((r) => r['analysis_status'] == 'queued' || r['analysis_status'] == 'processing');

  /// 분석 완료 저장 + "리포트가 도착했어요" 알림 (DB 트리거)
  void complete(String reportId) {
    final report = db.byId('analysis_reports', reportId);
    if (report == null || (report['analysis_status'] != 'queued' && report['analysis_status'] != 'processing')) return;
    final dog = db.byId('dogs', report.str('dog_id'));
    if (dog == null) return;

    final conditions = db.find('dog_health_profiles', (p) => p['dog_id'] == dog['id'])?.strList('condition_codes');
    final hasJointIssue = conditions?.contains('joint_disease') ?? false;
    db.update('analysis_reports', report, {
      ...generateGaitReport(
        dog: dog,
        random: db.random,
        issueLevel: hasJointIssue ? 0.15 + db.random.nextDouble() * 0.35 : 0,
      ),
      'analysis_status': 'completed',
      'completed_at': iso(db.now()),
    });
    db.notify(
      dog['owner_id'] as String?,
      'analysis',
      'AI 보행 분석 리포트가 도착했어요',
      '${dog['name']}의 운동 분석 결과를 확인해 보세요.',
      data: {'report_id': reportId},
      msg: 'analysis_completed',
      args: MockDb.dogNameArgs(dog),
    );
  }

  void completeAllPending() {
    final pending = db
        .where('analysis_reports', (r) => r['analysis_status'] == 'queued' || r['analysis_status'] == 'processing')
        .map((r) => r.str('id'))
        .toList();
    pending.forEach(complete);
  }

  void cancelTimers() {
    for (final timer in _timers) {
      timer.cancel();
    }
    _timers.clear();
  }
}
