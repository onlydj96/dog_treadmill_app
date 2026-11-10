import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common.dart';
import '../../data/analysis_models.dart';
import '../../data/dog_keypoints.dart';

class AnomalyLevelBadge extends StatelessWidget {
  const AnomalyLevelBadge({super.key, required this.level, this.dense = false});

  final AnomalyLevel level;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (tone, icon) = switch (level) {
      AnomalyLevel.normal => (scheme.calmTone, Icons.check_circle_rounded),
      AnomalyLevel.caution => (scheme.cautionTone, Icons.visibility_rounded),
      AnomalyLevel.warning => (scheme.alertTone, Icons.warning_amber_rounded),
    };
    return StatusBadge(label: level.label, tone: tone, icon: icon, dense: dense);
  }
}

class AnalysisStatusBadge extends StatelessWidget {
  const AnalysisStatusBadge({super.key, required this.status, this.dense = false});

  final AnalysisStatus status;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (tone, icon) = switch (status) {
      AnalysisStatus.queued => (scheme.neutralTone, Icons.schedule_rounded),
      AnalysisStatus.processing => (scheme.calmTone, Icons.auto_awesome_rounded),
      AnalysisStatus.completed => (scheme.calmTone, Icons.check_circle_rounded),
      AnalysisStatus.failed => (scheme.alertTone, Icons.error_outline_rounded),
    };
    return StatusBadge(label: status.label, tone: tone, icon: icon, dense: dense);
  }
}

/// 이전/기준 대비 변화량 표시. [higherIsBetter]에 따라 색을 정하고,
/// 방향에 좋고 나쁨이 없는 지표(예: 분당 걸음 수)는 [neutral]로 중립색을 쓴다.
class DeltaText extends StatelessWidget {
  const DeltaText({
    super.key,
    required this.delta,
    required this.format,
    this.higherIsBetter = true,
    this.neutral = false,
    this.neutralThreshold = 0,
    this.fontSize = 12.5,
  });

  final double delta;
  final String Function(double absDelta) format;
  final bool higherIsBetter;
  final bool neutral;
  final double neutralThreshold;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (delta.abs() <= neutralThreshold) {
      return Text('변화 없음', style: TextStyle(fontSize: fontSize, color: scheme.onSurfaceVariant));
    }
    final improved = higherIsBetter ? delta > 0 : delta < 0;
    final color = neutral
        ? scheme.onSurfaceVariant
        : improved
            ? scheme.calmTone.foreground
            : scheme.activeTone.foreground;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(delta > 0 ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded, size: fontSize + 2, color: color),
        Text(format(delta.abs()), style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w700, color: color)),
      ],
    );
  }
}

/// 지표 타일 (값 + 기준선/이전 대비)
class MetricTile extends StatelessWidget {
  const MetricTile({
    super.key,
    required this.label,
    required this.value,
    this.unit,
    this.caption,
    this.delta,
  });

  final String label;
  final String value;
  final String? unit;
  final String? caption;
  final Widget? delta;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: scheme.onSurfaceVariant)),
          const SizedBox(height: 6),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(text: value, style: AppText.numeric(22, color: scheme.onSurface)),
                if (unit != null)
                  TextSpan(
                    text: ' $unit',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: scheme.onSurfaceVariant),
                  ),
              ],
            ),
          ),
          if (delta != null) ...[const SizedBox(height: 4), delta!],
          if (caption != null) ...[
            const SizedBox(height: 4),
            Text(caption!, style: TextStyle(fontSize: 11.5, color: scheme.onSurfaceVariant)),
          ],
        ],
      ),
    );
  }
}

/// 15개 관절 Keypoint 측면 스켈레톤 도식. 이상 소견 관절을 강조한다.
class SkeletonDiagram extends StatelessWidget {
  const SkeletonDiagram({super.key, this.highlights = const {}});

  /// keypoint key → 소견 수준
  final Map<String, AnomalyLevel> highlights;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = scheme.brightness == Brightness.dark;
    return AspectRatio(
      aspectRatio: 1.7,
      child: CustomPaint(
        painter: _SkeletonPainter(
          highlights: highlights,
          boneColor: dark ? AppColors.mintLight : AppColors.charcoal,
          jointColor: AppColors.teal,
          floorColor: scheme.outlineVariant,
          bodyColor: dark ? Colors.white.withValues(alpha: 0.08) : AppColors.honey.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}

class _SkeletonPainter extends CustomPainter {
  _SkeletonPainter({
    required this.highlights,
    required this.boneColor,
    required this.jointColor,
    required this.floorColor,
    required this.bodyColor,
  });

  final Map<String, AnomalyLevel> highlights;
  final Color boneColor;
  final Color jointColor;
  final Color floorColor;
  final Color bodyColor;

  /// 관절만으로는 개로 읽히지 않아 몸통·머리·귀·꼬리 실루엣을 옅게 깐다.
  void _paintSilhouette(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final torso = Path()
      ..addRRect(RRect.fromLTRBR(w * 0.13, h * 0.21, w * 0.75, h * 0.52, Radius.elliptical(w * 0.1, h * 0.16)));
    final neck = Path()
      ..moveTo(w * 0.58, h * 0.23)
      ..quadraticBezierTo(w * 0.70, h * 0.20, w * 0.81, h * 0.11)
      ..lineTo(w * 0.87, h * 0.27)
      ..quadraticBezierTo(w * 0.78, h * 0.38, w * 0.74, h * 0.50)
      ..lineTo(w * 0.58, h * 0.50)
      ..close();
    final head = Path()..addOval(Rect.fromLTRB(w * 0.79, h * 0.09, w * 0.975, h * 0.34));
    final ear = Path()
      ..moveTo(w * 0.815, h * 0.15)
      ..quadraticBezierTo(w * 0.83, h * 0.0, w * 0.875, h * 0.13)
      ..close();
    // 반투명 색이 겹쳐 진해지지 않도록 하나의 경로로 합쳐서 한 번만 칠한다.
    var silhouette = Path.combine(PathOperation.union, torso, neck);
    silhouette = Path.combine(PathOperation.union, silhouette, head);
    silhouette = Path.combine(PathOperation.union, silhouette, ear);
    canvas.drawPath(silhouette, Paint()..color = bodyColor);

    // 꼬리는 몸통 바깥에서 시작해 겹침을 피한다.
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.135, h * 0.29)
        ..quadraticBezierTo(w * 0.07, h * 0.25, w * 0.05, h * 0.08),
      Paint()
        ..color = bodyColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.035
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    Offset at(DogKeypoint point) => Offset(point.position.dx * size.width, point.position.dy * size.height);

    _paintSilhouette(canvas, size);

    // 트레드밀 벨트
    final floorY = size.height * 0.965;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.04, floorY, size.width * 0.92, size.height * 0.03),
        const Radius.circular(8),
      ),
      Paint()..color = floorColor,
    );

    for (final (a, b) in DogKeypoint.bones) {
      final far = a.isFarSide || b.isFarSide;
      canvas.drawLine(
        at(a),
        at(b),
        Paint()
          ..color = boneColor.withValues(alpha: far ? 0.3 : 0.9)
          ..strokeWidth = far ? 3 : 4.5
          ..strokeCap = StrokeCap.round,
      );
    }

    for (final point in DogKeypoint.values) {
      final center = at(point);
      final level = highlights[point.key];
      if (level != null && level != AnomalyLevel.normal) {
        final haloColor = level == AnomalyLevel.warning ? AppColors.coral : AppColors.honeyDeep;
        canvas.drawCircle(center, 13, Paint()..color = haloColor.withValues(alpha: 0.22));
        canvas.drawCircle(center, 7, Paint()..color = haloColor);
        canvas.drawCircle(
          center,
          7,
          Paint()
            ..color = Colors.white
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2,
        );
      } else {
        canvas.drawCircle(center, point.isFarSide ? 4 : 5.5,
            Paint()..color = jointColor.withValues(alpha: point.isFarSide ? 0.5 : 1));
      }
    }
  }

  @override
  bool shouldRepaint(_SkeletonPainter oldDelegate) =>
      oldDelegate.highlights != highlights || oldDelegate.boneColor != boneColor;
}

class TrendPoint {
  const TrendPoint({required this.label, required this.value});

  final String label;
  final double value;
}

/// 리포트별 지표 추이 라인 차트
class TrendChart extends StatelessWidget {
  const TrendChart({
    super.key,
    required this.points,
    required this.valueFormatter,
    this.baseline,
    this.color = AppColors.mintDeep,
    this.height = 190,
  });

  final List<TrendPoint> points;
  final String Function(double value) valueFormatter;
  final double? baseline;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final values = [for (final p in points) p.value, if (baseline != null) baseline!];
    final minValue = values.reduce(math.min);
    final maxValue = values.reduce(math.max);
    final padding = math.max((maxValue - minValue) * 0.25, maxValue.abs() * 0.05 + 0.01);
    final minY = minValue - padding;
    final maxY = maxValue + padding;
    final labelStyle = TextStyle(fontSize: 11, color: scheme.onSurfaceVariant);

    return SizedBox(
      height: height,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (points.length - 1).toDouble(),
          minY: minY,
          maxY: maxY,
          clipData: const FlClipData.all(),
          gridData: FlGridData(
            drawVerticalLine: false,
            horizontalInterval: (maxY - minY) / 3,
            getDrawingHorizontalLine: (_) => FlLine(color: scheme.outlineVariant, strokeWidth: 1, dashArray: [4, 4]),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 44,
                interval: (maxY - minY) / 3,
                getTitlesWidget: (value, meta) {
                  if (value == meta.min || value == meta.max) return const SizedBox.shrink();
                  return SideTitleWidget(meta: meta, child: Text(valueFormatter(value), style: labelStyle));
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 26,
                getTitlesWidget: (value, meta) {
                  final index = value.round();
                  if (index < 0 || index >= points.length || value != index.toDouble()) {
                    return const SizedBox.shrink();
                  }
                  return SideTitleWidget(meta: meta, child: Text(points[index].label, style: labelStyle));
                },
              ),
            ),
          ),
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              if (baseline != null)
                HorizontalLine(
                  y: baseline!,
                  color: scheme.secondary.withValues(alpha: 0.55),
                  strokeWidth: 1.5,
                  dashArray: [6, 4],
                  label: HorizontalLineLabel(
                    show: true,
                    alignment: Alignment.topRight,
                    labelResolver: (_) => '기준선',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: scheme.secondary),
                  ),
                ),
            ],
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => scheme.inverseSurface,
              getTooltipItems: (spots) => [
                for (final spot in spots)
                  LineTooltipItem(
                    '${points[spot.x.round()].label}\n${valueFormatter(spot.y)}',
                    TextStyle(color: scheme.onInverseSurface, fontWeight: FontWeight.w700, fontSize: 12),
                  ),
              ],
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [for (var i = 0; i < points.length; i++) FlSpot(i.toDouble(), points[i].value)],
              isCurved: true,
              preventCurveOverShooting: true,
              color: color,
              barWidth: 3,
              dotData: FlDotData(
                getDotPainter: (spot, percent, bar, index) => FlDotCirclePainter(
                  radius: 4,
                  color: color,
                  strokeWidth: 2,
                  strokeColor: scheme.surfaceContainerLowest,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [color.withValues(alpha: 0.22), color.withValues(alpha: 0)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
