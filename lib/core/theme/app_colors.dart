import 'package:flutter/material.dart';

/// 브랜드 팔레트 — huemint brand-intersection
/// `#bf78ff` 라벤더 · `#890121` 버건디 · `#d64025` 버밀리언 · `#ffd3bf` 피치
///
/// 원색 4가지는 그대로 쓰고, 텍스트 대비가 부족한 곳에만 파생 톤을 사용한다.
/// - 버밀리언: 주요 행동(CTA)
/// - 버건디: 브랜드 히어로 영역, 강조 텍스트
/// - 피치: 강조 컨테이너, 선택 상태
/// - 라벤더: AI·건강 분석 영역
abstract final class AppColors {
  static const lavender = Color(0xFFBF78FF);
  static const burgundy = Color(0xFF890121);
  static const vermilion = Color(0xFFD64025);
  static const peach = Color(0xFFFFD3BF);

  /// 버건디 계열 진한 톤 (피치 위 텍스트)
  static const burgundyDeep = Color(0xFF5C0016);

  /// 라벤더를 밝은 배경 위 텍스트로 쓸 때의 진한 톤 (대비 6.4:1)
  static const violet = Color(0xFF7A3FC0);
  static const violetDeep = Color(0xFF3D0B70);
  static const lavenderMist = Color(0xFFF1E3FF);

  static const cream = Color(0xFFFFF8F4);
  static const ink = Color(0xFF2B1316);
}

/// 의미 기반 상태 색. 팔레트 안에서 단계적으로 강해지도록 구성한다.
/// (정상: 라벤더 → 주의: 피치/버밀리언 → 경고: 버건디)
@immutable
class StatusTone {
  const StatusTone({required this.foreground, required this.background});

  final Color foreground;
  final Color background;
}

extension StatusTones on ColorScheme {
  bool get _isDark => brightness == Brightness.dark;

  StatusTone get calmTone => StatusTone(
        foreground: _isDark ? AppColors.lavender : AppColors.violet,
        background: _isDark ? const Color(0xFF3A2056) : AppColors.lavenderMist,
      );

  StatusTone get cautionTone => StatusTone(
        foreground: _isDark ? AppColors.peach : AppColors.burgundyDeep,
        background: _isDark ? const Color(0xFF5A2A1C) : AppColors.peach,
      );

  StatusTone get alertTone => const StatusTone(
        foreground: Colors.white,
        background: AppColors.burgundy,
      );

  StatusTone get activeTone => StatusTone(
        foreground: _isDark ? const Color(0xFFFFB4A1) : AppColors.vermilion,
        background: _isDark ? const Color(0xFF4E1A10) : const Color(0xFFFFE6DC),
      );

  StatusTone get neutralTone => StatusTone(
        foreground: onSurfaceVariant,
        background: surfaceContainerHigh,
      );
}
