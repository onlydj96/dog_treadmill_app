import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/common.dart';
import '../../data/exercise_session.dart';

/// 운동 경과 시간을 1초마다 갱신해 보여주는 위젯
class LiveTicker extends StatefulWidget {
  const LiveTicker({super.key, required this.builder});

  final Widget Function(BuildContext context, DateTime now) builder;

  @override
  State<LiveTicker> createState() => _LiveTickerState();
}

class _LiveTickerState extends State<LiveTicker> {
  late Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _now);
}

class SessionStatusBadge extends StatelessWidget {
  const SessionStatusBadge({super.key, required this.status, this.dense = false});

  final SessionStatus status;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (tone, icon) = switch (status) {
      SessionStatus.ready => (scheme.cautionTone, Icons.hourglass_top_rounded),
      SessionStatus.running => (scheme.activeTone, Icons.directions_run_rounded),
      SessionStatus.paused => (scheme.cautionTone, Icons.pause_circle_rounded),
      SessionStatus.completed => (scheme.calmTone, Icons.check_circle_rounded),
      SessionStatus.stopped => (scheme.alertTone, Icons.do_not_disturb_on_rounded),
    };
    return StatusBadge(label: status.label, tone: tone, icon: icon, dense: dense);
  }
}

/// 목표 시간 대비 진행률 링
class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.progress,
    required this.child,
    this.size = 200,
    this.strokeWidth = 14,
    this.trackColor,
    this.colors = const [AppColors.teal, AppColors.mint],
  });

  final double? progress;
  final Widget child;
  final double size;
  final double strokeWidth;
  final Color? trackColor;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _RingPainter(
          progress: progress ?? 0,
          strokeWidth: strokeWidth,
          trackColor: trackColor ?? Colors.white.withValues(alpha: 0.14),
          colors: colors,
        ),
        child: Center(child: child),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.trackColor,
    required this.colors,
  });

  final double progress;
  final double strokeWidth;
  final Color trackColor;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final arcRect = rect.deflate(strokeWidth / 2);
    canvas.drawArc(
      arcRect,
      0,
      math.pi * 2,
      false,
      Paint()
        ..color = trackColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );
    if (progress <= 0) return;
    final sweep = math.pi * 2 * progress.clamp(0.0, 1.0);
    // 둥근 끝(cap)이 시작점 뒤로 튀어나온 부분까지 첫 색이 칠해지도록 그라데이션을 cap 각도만큼 앞당긴다.
    final capAngle = strokeWidth / 2 / (arcRect.width / 2);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        endAngle: sweep + capAngle * 2,
        colors: colors,
        transform: GradientRotation(-math.pi / 2 - capAngle),
      ).createShader(rect);
    canvas.drawArc(arcRect, -math.pi / 2, sweep, false, paint);
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.trackColor != trackColor;
}

/// 운동 기록 한 줄
class ExerciseRecordTile extends StatelessWidget {
  const ExerciseRecordTile({super.key, required this.session, this.onReportTap});

  final ExerciseSession session;
  final ValueChanged<String>? onReportTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final report = session.latestReport;

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(Fmt.date(session.date), style: theme.textTheme.titleSmall),
                    Text(
                      [
                        Fmt.time(session.date),
                        if (session.treadmillName != null) '트레드밀 ${session.treadmillName}',
                      ].join(' · '),
                      style: TextStyle(fontSize: 12.5, color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              if (session.status == SessionStatus.stopped) SessionStatusBadge(status: session.status, dense: true),
              if (report != null) ...[
                const SizedBox(width: 6),
                _ReportChip(report: report, onTap: onReportTap),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatValue(
                  label: '운동 시간',
                  value: Fmt.timer(session.durationSeconds),
                  valueSize: 19,
                ),
              ),
              Expanded(
                child: StatValue(
                  label: '이동 거리',
                  value: (session.distanceMeters / 1000).toStringAsFixed(2),
                  unit: 'km',
                  valueSize: 19,
                ),
              ),
              Expanded(
                child: StatValue(
                  label: '평균 / 최고',
                  value: '${session.averageSpeed?.toStringAsFixed(1) ?? '-'}'
                      '/${session.maxSpeed?.toStringAsFixed(1) ?? '-'}',
                  unit: 'km/h',
                  valueSize: 19,
                ),
              ),
            ],
          ),
          if (session.status == SessionStatus.stopped && session.stopReason != null) ...[
            const SizedBox(height: 10),
            Text(
              '중단 사유: ${session.stopReason}',
              style: TextStyle(fontSize: 13, color: scheme.onSurfaceVariant),
            ),
          ],
        ],
      ),
    );
  }
}

class _ReportChip extends StatelessWidget {
  const _ReportChip({required this.report, this.onTap});

  final SessionReportRef report;
  final ValueChanged<String>? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final tone = scheme.calmTone;
    final label = switch (report.status) {
      'completed' => 'AI 리포트',
      'failed' => '분석 실패',
      _ => '분석 중',
    };
    final tappable = report.isCompleted && onTap != null;
    return Semantics(
      container: true,
      button: tappable,
      child: Material(
        color: tone.background,
        shape: const StadiumBorder(),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: tappable ? () => onTap!(report.id) : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.auto_awesome_rounded, size: 14, color: tone.foreground),
                const SizedBox(width: 4),
                Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: tone.foreground)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 월별 운동 요약 수치
class ExerciseTotals {
  const ExerciseTotals({required this.count, required this.seconds, required this.meters});

  factory ExerciseTotals.of(Iterable<ExerciseSession> sessions) {
    var seconds = 0;
    var meters = 0.0;
    var count = 0;
    for (final session in sessions) {
      count++;
      seconds += session.durationSeconds;
      meters += session.distanceMeters;
    }
    return ExerciseTotals(count: count, seconds: seconds, meters: meters);
  }

  final int count;
  final int seconds;
  final double meters;
}

/// 숫자 강조 텍스트 (히어로 영역용)
class HeroNumber extends StatelessWidget {
  const HeroNumber({super.key, required this.label, required this.value, this.unit});

  final String label;
  final String value;
  final String? unit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: AppColors.mintLight, fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: value, style: AppText.numeric(20, color: Colors.white)),
              if (unit != null)
                TextSpan(
                  text: ' $unit',
                  style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.75)),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
