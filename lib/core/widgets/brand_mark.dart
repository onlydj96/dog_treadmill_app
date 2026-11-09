import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// 브랜드 심볼 — 라벤더(AI)와 버밀리언(반려견)이 겹치는 교집합을 버건디로 표현한
/// "brand intersection" 마크.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 40, this.withBackground = true});

  final double size;
  final bool withBackground;

  @override
  Widget build(BuildContext context) {
    final mark = CustomPaint(
      size: Size.square(size),
      painter: const _IntersectionPainter(
        left: AppColors.lavender,
        right: AppColors.vermilion,
        overlap: AppColors.burgundy,
      ),
    );
    if (!withBackground) return mark;
    return Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.16),
      decoration: BoxDecoration(
        color: AppColors.peach,
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
      child: mark,
    );
  }
}

class _IntersectionPainter extends CustomPainter {
  const _IntersectionPainter({
    required this.left,
    required this.right,
    required this.overlap,
  });

  final Color left;
  final Color right;
  final Color overlap;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width * 0.32;
    final cy = size.height / 2;
    final leftCircle = Path()..addOval(Rect.fromCircle(center: Offset(size.width * 0.35, cy), radius: radius));
    final rightCircle = Path()..addOval(Rect.fromCircle(center: Offset(size.width * 0.65, cy), radius: radius));

    canvas.drawPath(leftCircle, Paint()..color = left);
    canvas.drawPath(rightCircle, Paint()..color = right);
    canvas.drawPath(
      Path.combine(PathOperation.intersect, leftCircle, rightCircle),
      Paint()..color = overlap,
    );
  }

  @override
  bool shouldRepaint(_IntersectionPainter oldDelegate) =>
      oldDelegate.left != left || oldDelegate.right != right || oldDelegate.overlap != overlap;
}

/// 히어로 카드 배경의 장식 원 (브랜드 교집합 모티프)
class IntersectionBackdrop extends StatelessWidget {
  const IntersectionBackdrop({
    super.key,
    required this.child,
    this.background = AppColors.burgundy,
    this.borderRadius = 28,
  });

  final Widget child;
  final Color background;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CustomPaint(
        painter: _BackdropPainter(background),
        child: child,
      ),
    );
  }
}

class _BackdropPainter extends CustomPainter {
  const _BackdropPainter(this.background);

  final Color background;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = background);
    // 카드 크기와 무관하게 오른쪽 위 모서리에만 모티프를 둔다 (본문 텍스트 대비 유지)
    final s = math.min(size.shortestSide, 260.0);
    final lavender = Path()
      ..addOval(Rect.fromCircle(center: Offset(size.width - s * 0.05, s * 0.08), radius: s * 0.62));
    final vermilion = Path()
      ..addOval(Rect.fromCircle(center: Offset(size.width + s * 0.22, s * 0.62), radius: s * 0.55));
    canvas.drawPath(lavender, Paint()..color = AppColors.lavender.withValues(alpha: 0.24));
    canvas.drawPath(vermilion, Paint()..color = AppColors.vermilion.withValues(alpha: 0.42));
    canvas.drawPath(
      Path.combine(PathOperation.intersect, lavender, vermilion),
      Paint()..color = AppColors.peach.withValues(alpha: 0.22),
    );
  }

  @override
  bool shouldRepaint(_BackdropPainter oldDelegate) => oldDelegate.background != background;
}

class BrandWordmark extends StatelessWidget {
  const BrandWordmark({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textColor = color ?? scheme.onSurface;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const BrandMark(size: 30),
        const SizedBox(width: 8),
        Text(
          'AI 헬스장',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800, color: textColor, letterSpacing: -0.4),
        ),
        const SizedBox(width: 4),
        Text('for dogs', style: AppText.numeric(13, weight: FontWeight.w600, color: textColor.withValues(alpha: 0.55))),
      ],
    );
  }
}
