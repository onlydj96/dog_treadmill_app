import 'package:flutter/material.dart';

/// PawFit 브랜드 팔레트 — 로고(assets/logo)에서 뽑은 원색과, OKLCH 명도만 조절한 파생 톤.
///
/// | 원색 | 로고 속 위치 | 역할 |
/// |---|---|---|
/// | 민트 `#39AD8E` | "Fit" 글자 | 주요 행동(CTA)·선택 상태 |
/// | 차콜 `#232630` | "Paw" 글자·트레드밀 | 본문 글자, 히어로 카드 배경 |
/// | 청록 `#22BBB0` | 하트 | AI·건강 분석, 정상 상태 |
/// | 허니 `#FDC678` | 강아지 털 | 관찰 필요 상태, 반려견 아바타 |
/// | 코랄 `#B6374B` | 혀(`#FD9199`)를 진하게 | 주의 필요 상태, 삭제·취소 같은 파괴적 행동 |
/// | 크림 `#FDFAF4` | 배경 | 기본 표면 |
///
/// 원색은 밝아서 크림 위 글자로 쓰면 대비가 부족하다(민트 2.7:1).
/// 밝은 배경 위 글자·아이콘에는 `*Deep`, 연한 컨테이너 위 글자에는 `*Ink` 톤을 쓴다.
abstract final class AppColors {
  static const mint = Color(0xFF39AD8E);
  static const charcoal = Color(0xFF232630);
  static const teal = Color(0xFF22BBB0);
  static const honey = Color(0xFFFDC678);
  static const cream = Color(0xFFFDFAF4);

  /// 흰 글자를 올리는 버튼·액션 면, 밝은 배경 위 강조 글자 (흰색 5.7:1 · 크림 5.5:1 · [mintMist] 4.9:1)
  static const mintDeep = Color(0xFF02755C);

  /// [mintMist] 위 글자 (10:1)
  static const mintInk = Color(0xFF033F31);

  /// 강조 컨테이너·선택 상태 배경
  static const mintMist = Color(0xFFD3F6E9);

  /// 차콜 히어로 위 보조 글자·아이콘 (11:1)
  static const mintLight = Color(0xFFB3EAD7);

  /// AI·건강 영역 글자, 정상 상태 그래픽 (크림 5.5:1)
  static const tealDeep = Color(0xFF00736C);

  /// [tealMist] 위 글자 (9.8:1)
  static const tealInk = Color(0xFF023F3A);

  /// AI·건강 컨테이너. [mintMist]와 구분되도록 하늘색 쪽으로 옮긴 톤 (tealDeep 글자 4.7:1)
  static const tealMist = Color(0xFFC2F2F8);

  /// 관찰 필요 상태 그래픽 (크림 3:1 · 다크 표면 5.8:1)
  static const honeyDeep = Color(0xFFBD862F);

  /// [honey] 위 글자 (6:1)
  static const honeyInk = Color(0xFF614005);

  /// 주의 필요 상태, 파괴적 행동 (흰 글자 5.8:1)
  static const coral = Color(0xFFB6374B);
}

/// 의미 기반 상태 색. 로고 색이 신호등처럼 단계적으로 강해진다.
/// (정상: 청록 → 관찰 필요: 허니 → 주의 필요: 코랄, 진행 중: 민트)
@immutable
class StatusTone {
  const StatusTone({required this.foreground, required this.background});

  final Color foreground;
  final Color background;
}

extension StatusTones on ColorScheme {
  bool get _isDark => brightness == Brightness.dark;

  StatusTone get calmTone => StatusTone(
        foreground: _isDark ? const Color(0xFF5BE4D8) : AppColors.tealDeep,
        background: _isDark ? const Color(0xFF003D45) : AppColors.tealMist,
      );

  StatusTone get cautionTone => StatusTone(
        foreground: _isDark ? AppColors.honey : AppColors.honeyInk,
        background: _isDark ? const Color(0xFF4D3201) : AppColors.honey,
      );

  StatusTone get alertTone => const StatusTone(
        foreground: Colors.white,
        background: AppColors.coral,
      );

  StatusTone get activeTone => StatusTone(
        foreground: _isDark ? const Color(0xFF74E3C1) : AppColors.mintDeep,
        background: _isDark ? const Color(0xFF004031) : AppColors.mintMist,
      );

  StatusTone get neutralTone => StatusTone(
        foreground: onSurfaceVariant,
        background: surfaceContainerHigh,
      );
}
