import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
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

/// 관절 소견 마커 색. 도식·범례·관절 표가 같은 색을 쓴다.
Color jointMarkerColor(AnomalyLevel level) => level == AnomalyLevel.warning ? AppColors.coral : AppColors.honeyDeep;

/// 마커 위 순번 글자색. 허니 위 흰 글자는 대비가 낮아(2.9:1) 차콜을 쓴다.
Color _jointMarkerInk(AnomalyLevel level) => level == AnomalyLevel.warning ? Colors.white : AppColors.charcoal;

/// 스켈레톤 도식의 마커와 관절 목록을 잇는 순번 배지
class JointMarkerBadge extends StatelessWidget {
  const JointMarkerBadge({super.key, required this.number, required this.level, this.size = 20});

  final int number;
  final AnomalyLevel level;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: jointMarkerColor(level), shape: BoxShape.circle),
      child: Text(
        '$number',
        style: AppText.numeric(size * 0.6, weight: FontWeight.w800, color: _jointMarkerInk(level), height: 1),
      ),
    );
  }
}

/// 측면 카메라로 본 반려견 일러스트 위에 15개 관절 Keypoint 스켈레톤을 겹친 도식.
/// [markers]의 관절은 소견 수준 색과 순번(맵 순서대로 1부터)으로 표시한다.
class SkeletonDiagram extends StatelessWidget {
  const SkeletonDiagram({super.key, this.markers = const {}});

  /// keypoint key → 소견 수준. [AnomalyLevel.normal]은 표시하지 않는다.
  final Map<String, AnomalyLevel> markers;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = scheme.brightness == Brightness.dark;
    final stage = scheme.surfaceContainerLow;
    // 반투명 색이 겹쳐 얼룩지지 않도록 무대 색과 미리 섞은 불투명 색만 쓴다.
    Color tint(Color color, double alpha) => Color.alphaBlend(color.withValues(alpha: alpha), stage);
    final palette = _DiagramPalette(
      stage: stage,
      grid: scheme.outlineVariant.withValues(alpha: dark ? 0.55 : 0.9),
      fur: tint(AppColors.honey, dark ? 0.4 : 0.7),
      farFur: dark ? tint(AppColors.honey, 0.2) : tint(AppColors.honeyDeep, 0.4),
      ear: dark ? tint(AppColors.honey, 0.62) : tint(AppColors.honeyDeep, 0.72),
      feature: dark ? scheme.surfaceContainerLowest : AppColors.charcoal,
      collar: dark ? scheme.primary : AppColors.mintDeep,
      bone: dark ? AppColors.mintLight : AppColors.charcoal,
      joint: AppColors.teal,
      ring: dark ? stage : Colors.white,
      belt: dark ? scheme.surfaceContainerHighest : AppColors.charcoal,
      shadow: Colors.black.withValues(alpha: dark ? 0.4 : 0.14),
    );
    final flagged = [
      for (final MapEntry(:key, :value) in markers.entries)
        if (value != AnomalyLevel.normal) '${DogKeypoint.fromKey(key)?.label ?? key} ${value.label}',
    ];

    return Semantics(
      image: true,
      label: '측면에서 본 반려견 관절 도식${flagged.isEmpty ? '' : ', ${flagged.join(', ')}'}',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: AspectRatio(
          aspectRatio: _DogDiagramPainter.width / _DogDiagramPainter.height,
          child: CustomPaint(painter: _DogDiagramPainter(markers: markers, palette: palette)),
        ),
      ),
    );
  }
}

@immutable
class _DiagramPalette {
  const _DiagramPalette({
    required this.stage,
    required this.grid,
    required this.fur,
    required this.farFur,
    required this.ear,
    required this.feature,
    required this.collar,
    required this.bone,
    required this.joint,
    required this.ring,
    required this.belt,
    required this.shadow,
  });

  final Color stage;
  final Color grid;

  /// 몸통·카메라 쪽(왼쪽) 다리
  final Color fur;

  /// 카메라 반대편(오른쪽) 다리. 몸 뒤에 있어 그늘진 톤.
  final Color farFur;
  final Color ear;

  /// 눈·코·입
  final Color feature;
  final Color collar;
  final Color bone;
  final Color joint;

  /// 관절 점을 몸에서 떼어 보이게 하는 테두리
  final Color ring;
  final Color belt;
  final Color shadow;

  List<Color> get _all => [stage, grid, fur, farFur, ear, feature, collar, bone, joint, ring, belt, shadow];

  @override
  bool operator ==(Object other) => other is _DiagramPalette && listEquals(other._all, _all);

  @override
  int get hashCode => Object.hashAll(_all);
}

class _DogDiagramPainter extends CustomPainter {
  _DogDiagramPainter({required this.markers, required this.palette});

  final Map<String, AnomalyLevel> markers;
  final _DiagramPalette palette;

  /// 설계 좌표계(가로 340 × 세로 200). 그릴 때 실제 크기에 맞춰 늘린다.
  static const width = 340.0;
  static const height = 200.0;
  static const _beltTop = 182.0;

  /// 트레드밀 위에서 한 걸음 내딛는 순간. 왼쪽 앞다리와 오른쪽 뒷다리가 앞으로 나간다.
  static const _pose = <DogKeypoint, Offset>{
    DogKeypoint.nose: Offset(321, 54),
    DogKeypoint.withers: Offset(226, 71),
    DogKeypoint.tailBase: Offset(101, 76),
    DogKeypoint.leftElbow: Offset(236, 118),
    DogKeypoint.leftCarpus: Offset(246, 154),
    DogKeypoint.leftFrontPaw: Offset(254, 176),
    DogKeypoint.rightElbow: Offset(220, 116),
    DogKeypoint.rightCarpus: Offset(210, 152),
    DogKeypoint.rightFrontPaw: Offset(201, 176),
    DogKeypoint.leftStifle: Offset(122, 124),
    DogKeypoint.leftHock: Offset(95, 150),
    DogKeypoint.leftHindPaw: Offset(85, 176),
    DogKeypoint.rightStifle: Offset(134, 120),
    DogKeypoint.rightHock: Offset(116, 150),
    DogKeypoint.rightHindPaw: Offset(124, 176),
  };

  // 어깨·허벅지 근육의 중심. Keypoint가 아니라 실루엣을 만들 때만 쓴다.
  static const _nearShoulder = Offset(232, 94);
  static const _farShoulder = Offset(222, 92);
  static const _nearHip = Offset(110, 92);
  static const _farHip = Offset(118, 90);

  static final _torso = Path()
    ..moveTo(226, 63)
    ..cubicTo(190, 68, 140, 64, 100, 68) // 등선
    ..cubicTo(84, 69, 76, 82, 78, 96) // 엉덩이
    ..cubicTo(80, 108, 92, 116, 106, 116)
    ..cubicTo(124, 116, 140, 110, 156, 108) // 허리 쪽으로 올라간 배
    ..cubicTo(186, 106, 204, 124, 226, 125) // 깊은 가슴
    ..cubicTo(246, 126, 258, 112, 260, 98) // 앞가슴
    ..cubicTo(262, 84, 252, 70, 226, 63)
    ..close();

  static final _neck = Path()
    ..moveTo(214, 70)
    ..cubicTo(236, 64, 252, 48, 264, 34)
    ..lineTo(292, 58)
    ..cubicTo(282, 70, 266, 88, 257, 106) // 목 앞선이 앞가슴 안쪽에서 끝나야 경계가 매끈하다
    ..lineTo(226, 106)
    ..close();

  static const _cranium = Rect.fromLTRB(262, 27, 302, 63);

  static final _muzzle = Path()
    ..moveTo(288, 35)
    ..cubicTo(300, 35, 312, 41, 320, 48)
    ..cubicTo(327, 53, 327, 62, 318, 65)
    ..cubicTo(308, 68, 296, 70, 284, 63)
    ..close();

  static final _ear = Path()
    ..moveTo(272, 30)
    ..cubicTo(260, 32, 253, 50, 257, 66)
    ..cubicTo(259, 73, 268, 74, 272, 67)
    ..cubicTo(279, 56, 284, 44, 283, 33)
    ..close();

  static final _tail = _taperedCurve(const Offset(103, 72), const Offset(74, 63), const Offset(57, 41), 5.5, 2);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / width, size.height / height);
    _paintStage(canvas);
    _paintTreadmill(canvas);
    _paintDog(canvas);
    _paintSkeleton(canvas);
    canvas.restore();
  }

  void _paintStage(Canvas canvas) {
    canvas.drawRect(const Rect.fromLTWH(0, 0, width, height), Paint()..color = palette.stage);
    // 분석 화면 느낌의 옅은 점 격자
    final dot = Paint()..color = palette.grid;
    for (var x = 10.0; x < width; x += 20) {
      for (var y = 10.0; y < _beltTop - 6; y += 20) {
        canvas.drawCircle(Offset(x, y), 1, dot);
      }
    }
  }

  void _paintTreadmill(Canvas canvas) {
    canvas.drawRRect(
      RRect.fromLTRBR(14, _beltTop, width - 14, _beltTop + 11, const Radius.circular(5.5)),
      Paint()..color = palette.belt,
    );
    final slat = Paint()
      ..color = Colors.white.withValues(alpha: 0.13)
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round;
    for (var x = 32.0; x < width - 28; x += 12) {
      canvas.drawLine(Offset(x, _beltTop + 3.5), Offset(x, _beltTop + 7.5), slat);
    }
    final roller = Paint()..color = Colors.white.withValues(alpha: 0.28);
    canvas
      ..drawCircle(const Offset(21, _beltTop + 5.5), 2.6, roller)
      ..drawCircle(const Offset(width - 21, _beltTop + 5.5), 2.6, roller)
      // 발밑 그림자
      ..drawOval(
        Rect.fromCenter(center: const Offset(168, _beltTop + 0.5), width: 236, height: 6),
        Paint()
          ..color = palette.shadow
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.5),
      );
  }

  void _paintDog(Canvas canvas) {
    Offset at(DogKeypoint point) => _pose[point]!;
    final farFur = Paint()..color = palette.farFur;
    final fur = Paint()..color = palette.fur;

    // 카메라 반대편 다리는 몸 뒤에 그늘진 톤으로
    _frontLeg(canvas, farFur, _farShoulder, at(DogKeypoint.rightElbow), at(DogKeypoint.rightCarpus),
        at(DogKeypoint.rightFrontPaw), 0.9);
    _hindLeg(canvas, farFur, _farHip, at(DogKeypoint.rightStifle), at(DogKeypoint.rightHock),
        at(DogKeypoint.rightHindPaw), 0.9);

    canvas
      ..drawPath(_tail, fur)
      ..drawPath(_torso, fur)
      ..drawPath(_neck, fur)
      ..drawOval(_cranium, fur)
      ..drawPath(_muzzle, fur);

    _hindLeg(canvas, fur, _nearHip, at(DogKeypoint.leftStifle), at(DogKeypoint.leftHock), at(DogKeypoint.leftHindPaw), 1);
    _frontLeg(canvas, fur, _nearShoulder, at(DogKeypoint.leftElbow), at(DogKeypoint.leftCarpus),
        at(DogKeypoint.leftFrontPaw), 1);

    // 목줄과 이름표
    canvas
      ..save()
      ..clipPath(_neck)
      ..drawLine(
        const Offset(238, 46),
        const Offset(282, 90),
        Paint()
          ..color = palette.collar
          ..strokeWidth = 7,
      )
      ..restore()
      ..drawCircle(const Offset(273.5, 85.5), 3.4, Paint()..color = AppColors.honeyDeep);

    final feature = Paint()..color = palette.feature;
    canvas
      ..drawPath(_ear, Paint()..color = palette.ear)
      ..drawCircle(const Offset(295, 43), 3, feature)
      ..drawCircle(const Offset(296, 42), 0.9, Paint()..color = Colors.white.withValues(alpha: 0.9))
      // 코 Keypoint 점이 코 위에 얹히므로 점 테두리 밖으로 코끝이 살짝 보이게 한다.
      ..drawOval(Rect.fromCenter(center: const Offset(321.5, 54), width: 13, height: 10), feature)
      ..drawPath(
        Path()
          ..moveTo(320, 63)
          ..quadraticBezierTo(313, 67, 305, 64),
        Paint()
          ..color = palette.feature.withValues(alpha: 0.55)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6
          ..strokeCap = StrokeCap.round,
      );
  }

  /// 어깨 → 팔꿈치 → 앞발목 → 앞발. [scale]로 반대편 다리를 조금 가늘게 그린다.
  static void _frontLeg(Canvas canvas, Paint paint, Offset shoulder, Offset elbow, Offset carpus, Offset paw, double scale) {
    _limb(canvas, paint, shoulder, elbow, 17 * scale, 10 * scale);
    _limb(canvas, paint, elbow, carpus, 9 * scale, 6.5 * scale);
    _limb(canvas, paint, carpus, paw, 6.5 * scale, 6 * scale);
    _paw(canvas, paint, paw, scale);
  }

  /// 엉덩이 → 무릎 → 뒷발목(비절) → 뒷발. 허벅지는 넓고 비절 아래는 가늘다.
  static void _hindLeg(Canvas canvas, Paint paint, Offset hip, Offset stifle, Offset hock, Offset paw, double scale) {
    _limb(canvas, paint, hip, stifle, 25 * scale, 11 * scale);
    _limb(canvas, paint, stifle, hock, 10 * scale, 6.5 * scale);
    _limb(canvas, paint, hock, paw, 6 * scale, 5.5 * scale);
    _paw(canvas, paint, paw, scale);
  }

  /// 발끝이 머리 쪽을 향하고 바닥이 벨트에 닿는 발
  static void _paw(Canvas canvas, Paint paint, Offset paw, double scale) {
    final h = 9 * scale;
    canvas.drawOval(Rect.fromCenter(center: Offset(paw.dx + 3, _beltTop - h / 2), width: 17 * scale, height: h), paint);
  }

  /// 두 원(반지름 [ra], [rb])을 잇는, 끝으로 갈수록 가늘어지는 다리 마디
  static void _limb(Canvas canvas, Paint paint, Offset a, Offset b, double ra, double rb) {
    final d = b - a;
    final length = d.distance;
    if (length == 0) return;
    final n = Offset(-d.dy, d.dx) / length;
    canvas
      ..drawPath(
        Path()
          ..moveTo(a.dx + n.dx * ra, a.dy + n.dy * ra)
          ..lineTo(b.dx + n.dx * rb, b.dy + n.dy * rb)
          ..lineTo(b.dx - n.dx * rb, b.dy - n.dy * rb)
          ..lineTo(a.dx - n.dx * ra, a.dy - n.dy * ra)
          ..close(),
        paint,
      )
      ..drawCircle(a, ra, paint)
      ..drawCircle(b, rb, paint);
  }

  /// 2차 베지어를 따라 반폭이 [w0]에서 [w1]로 줄어드는, 끝이 둥근 꼬리
  static Path _taperedCurve(Offset p0, Offset c, Offset p1, double w0, double w1) {
    const steps = 20;
    final left = <Offset>[];
    final right = <Offset>[];
    for (var i = 0; i <= steps; i++) {
      final t = i / steps;
      final point = p0 * ((1 - t) * (1 - t)) + c * (2 * (1 - t) * t) + p1 * (t * t);
      final tangent = (c - p0) * (2 * (1 - t)) + (p1 - c) * (2 * t);
      final normal = Offset(-tangent.dy, tangent.dx) / tangent.distance;
      final w = w0 + (w1 - w0) * t;
      left.add(point + normal * w);
      right.add(point - normal * w);
    }
    final path = Path()..moveTo(left.first.dx, left.first.dy);
    for (final point in left.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    path.arcToPoint(right.last, radius: Radius.circular(w1), clockwise: false);
    for (final point in right.reversed.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    return path..close();
  }

  void _paintSkeleton(Canvas canvas) {
    // 반대편 다리를 먼저 그려 카메라 쪽 뼈대가 위에 오게 한다.
    for (final farPass in const [true, false]) {
      for (final (a, b) in DogKeypoint.bones) {
        final far = a.isFarSide || b.isFarSide;
        if (far != farPass) continue;
        canvas.drawLine(
          _pose[a]!,
          _pose[b]!,
          Paint()
            ..color = palette.bone.withValues(alpha: far ? 0.32 : 0.82)
            ..strokeWidth = far ? 2 : 3
            ..strokeCap = StrokeCap.round,
        );
      }
      for (final point in DogKeypoint.values) {
        if (point.isFarSide != farPass || _isMarked(point)) continue;
        final center = _pose[point]!;
        if (point.isFarSide) {
          canvas.drawCircle(center, 3.2, Paint()..color = palette.joint.withValues(alpha: 0.6));
        } else {
          canvas
            ..drawCircle(center, 5.4, Paint()..color = palette.ring)
            ..drawCircle(center, 3.8, Paint()..color = palette.joint);
        }
      }
    }

    var number = 0;
    for (final MapEntry(:key, :value) in markers.entries) {
      final point = DogKeypoint.fromKey(key);
      if (point == null || value == AnomalyLevel.normal) continue;
      number++;
      final center = _pose[point]!;
      final color = jointMarkerColor(value);
      canvas
        ..drawCircle(center, 17, Paint()..color = color.withValues(alpha: 0.24))
        ..drawCircle(center, 11, Paint()..color = palette.ring)
        ..drawCircle(center, 9.5, Paint()..color = color);
      final label = TextPainter(
        text: TextSpan(
          text: '$number',
          style: AppText.numeric(12.5, weight: FontWeight.w800, color: _jointMarkerInk(value), height: 1),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      label.paint(canvas, center - Offset(label.width / 2, label.height / 2));
      label.dispose();
    }
  }

  bool _isMarked(DogKeypoint point) {
    final level = markers[point.key];
    return level != null && level != AnomalyLevel.normal;
  }

  @override
  bool shouldRepaint(_DogDiagramPainter oldDelegate) =>
      oldDelegate.palette != palette || !mapEquals(oldDelegate.markers, markers);
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
