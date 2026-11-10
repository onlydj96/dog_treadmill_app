import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// PawFit 심볼 — 글자 없는 로고(assets/logo/PawFit_without_letter.png) 타일. 런처 아이콘과 같은 그림이다.
/// 이름은 [BrandWordmark]가 텍스트로 그린다.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 40});

  static const asset = 'assets/images/pawfit_mark.png';

  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size * 0.26),
      child: Image.asset(
        asset,
        width: size,
        height: size,
        fit: BoxFit.cover,
        filterQuality: FilterQuality.medium,
        excludeFromSemantics: true,
      ),
    );
  }
}

/// 히어로 카드 배경 — 트레드밀 같은 차콜 면에, 로고 뒤 민트 덩어리를 닮은 두 원이 겹친다.
class IntersectionBackdrop extends StatelessWidget {
  const IntersectionBackdrop({
    super.key,
    required this.child,
    this.background = AppColors.charcoal,
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
    final mintGlow = Path()
      ..addOval(Rect.fromCircle(center: Offset(size.width - s * 0.05, s * 0.08), radius: s * 0.62));
    final tealGlow = Path()
      ..addOval(Rect.fromCircle(center: Offset(size.width + s * 0.22, s * 0.62), radius: s * 0.55));
    canvas.drawPath(mintGlow, Paint()..color = AppColors.mint.withValues(alpha: 0.2));
    canvas.drawPath(tealGlow, Paint()..color = AppColors.teal.withValues(alpha: 0.28));
    canvas.drawPath(
      Path.combine(PathOperation.intersect, mintGlow, tealGlow),
      Paint()..color = AppColors.mintLight.withValues(alpha: 0.18),
    );
  }

  @override
  bool shouldRepaint(_BackdropPainter oldDelegate) => oldDelegate.background != background;
}

/// "PawFit" 텍스트 워드마크. 로고처럼 "Paw"는 차콜, "Fit"은 민트로 칠한다.
class BrandWordmark extends StatelessWidget {
  const BrandWordmark({super.key, this.color});

  /// "Paw" 색. 지정하지 않으면 라이트는 로고 차콜, 다크는 onSurface를 쓴다.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final pawColor = color ?? (scheme.brightness == Brightness.dark ? scheme.onSurface : AppColors.charcoal);
    final style = AppText.numeric(22, weight: FontWeight.w800, height: 1);
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: 'Paw', style: style.copyWith(color: pawColor)),
          TextSpan(text: 'Fit', style: style.copyWith(color: AppColors.mint)),
        ],
      ),
    );
  }
}
