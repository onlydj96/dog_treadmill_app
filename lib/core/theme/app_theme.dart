import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  // 라이트: 크림 표면 + 차콜 글자 + 진한 민트 행동색. 표면 톤은 크림 hue, 보조 글자는 차콜 hue에서 뽑았다.
  static const _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.mintDeep,
    onPrimary: Colors.white,
    primaryContainer: AppColors.mintMist,
    onPrimaryContainer: AppColors.mintInk,
    secondary: AppColors.mintDeep,
    onSecondary: Colors.white,
    secondaryContainer: AppColors.mintMist,
    onSecondaryContainer: AppColors.mintInk,
    tertiary: AppColors.tealDeep,
    onTertiary: Colors.white,
    tertiaryContainer: AppColors.tealMist,
    onTertiaryContainer: AppColors.tealInk,
    error: AppColors.coral,
    onError: Colors.white,
    errorContainer: Color(0xFFFFE4E4),
    onErrorContainer: Color(0xFF610A1E),
    surface: AppColors.cream,
    onSurface: AppColors.charcoal,
    onSurfaceVariant: Color(0xFF575A66),
    surfaceDim: Color(0xFFE3DFD7),
    surfaceBright: AppColors.cream,
    surfaceContainerLowest: Colors.white,
    surfaceContainerLow: Color(0xFFF8F5EE),
    surfaceContainer: Color(0xFFF4F0E8),
    surfaceContainerHigh: Color(0xFFEFEBE2),
    surfaceContainerHighest: Color(0xFFEAE6DD),
    outline: Color(0xFF838690),
    outlineVariant: Color(0xFFE4DFD5),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFF2A2D38),
    onInverseSurface: Color(0xFFF3F0E9),
    inversePrimary: Color(0xFF67D5B5),
  );

  // 다크: 차콜 hue의 짙은 표면 + 밝은 민트 행동색.
  static const _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF67D5B5),
    onPrimary: Color(0xFF012E23),
    primaryContainer: Color(0xFF054B3B),
    onPrimaryContainer: Color(0xFFC3F5E3),
    secondary: Color(0xFF67D5B5),
    onSecondary: Color(0xFF012E23),
    secondaryContainer: Color(0xFF054B3B),
    onSecondaryContainer: Color(0xFFC3F5E3),
    tertiary: Color(0xFF53DDD1),
    onTertiary: Color(0xFF012E2A),
    tertiaryContainer: Color(0xFF054852),
    onTertiaryContainer: Color(0xFFC0F4EE),
    error: Color(0xFFFFA9AE),
    onError: Color(0xFF5B0219),
    errorContainer: Color(0xFF7F1E2F),
    onErrorContainer: Color(0xFFFFDFE0),
    surface: Color(0xFF101219),
    onSurface: Color(0xFFF0ECE5),
    onSurfaceVariant: Color(0xFFC1C4CD),
    surfaceDim: Color(0xFF101219),
    surfaceBright: Color(0xFF353840),
    surfaceContainerLowest: Color(0xFF0A0C11),
    surfaceContainerLow: Color(0xFF16181F),
    surfaceContainer: Color(0xFF1A1D25),
    surfaceContainerHigh: Color(0xFF22252E),
    surfaceContainerHighest: Color(0xFF2A2D37),
    outline: Color(0xFF8C8F98),
    outlineVariant: Color(0xFF3D3F48),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFFF0ECE5),
    onInverseSurface: Color(0xFF2A2D38),
    inversePrimary: AppColors.mintDeep,
  );

  static ThemeData light() => _build(_lightScheme);

  static ThemeData dark() => _build(_darkScheme);

  static ThemeData _build(ColorScheme scheme) {
    final base = ThemeData(useMaterial3: true, colorScheme: scheme);
    final text = base.textTheme.apply(
      bodyColor: scheme.onSurface,
      displayColor: scheme.onSurface,
    );
    final textTheme = text.copyWith(
      headlineMedium: text.headlineMedium?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.6),
      headlineSmall: text.headlineSmall?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.5),
      titleLarge: text.titleLarge?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -0.4),
      titleMedium: text.titleMedium?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.2),
      titleSmall: text.titleSmall?.copyWith(fontWeight: FontWeight.w700),
      bodyLarge: text.bodyLarge?.copyWith(height: 1.5),
      bodyMedium: text.bodyMedium?.copyWith(height: 1.5),
      labelLarge: text.labelLarge?.copyWith(fontWeight: FontWeight.w700),
    );

    final rounded16 = RoundedRectangleBorder(borderRadius: BorderRadius.circular(16));
    // 버튼·칩 글자는 텍스트 테마를 상속해 플랫폼 폰트 패밀리를 유지한다.
    final label = textTheme.labelLarge ?? const TextStyle();
    final buttonText = label.copyWith(fontSize: 16, fontWeight: FontWeight.w700);
    // filled 입력창: 라벨이 상자 안쪽에 떠 있고 포커스 시 하단 강조선만 표시
    UnderlineInputBorder inputBorder([Color? color, double width = 2]) => UnderlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: color == null ? BorderSide.none : BorderSide(color: color, width: width),
        );

    return base.copyWith(
      scaffoldBackgroundColor: scheme.surface,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(color: scheme.onSurface, fontSize: 20),
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 54),
          shape: rounded16,
          textStyle: buttonText,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 54),
          shape: rounded16,
          foregroundColor: scheme.secondary,
          iconColor: scheme.secondary,
          side: BorderSide(color: scheme.outlineVariant, width: 1.4),
          textStyle: buttonText,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: scheme.secondary,
          iconColor: scheme.secondary,
          textStyle: label.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLow,
        contentPadding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
        border: inputBorder(),
        enabledBorder: inputBorder(),
        disabledBorder: inputBorder(),
        focusedBorder: inputBorder(scheme.primary),
        errorBorder: inputBorder(scheme.error, 1.5),
        focusedErrorBorder: inputBorder(scheme.error),
        labelStyle: TextStyle(color: scheme.onSurfaceVariant),
        floatingLabelStyle: WidgetStateTextStyle.resolveWith(
          (states) => TextStyle(
            color: states.contains(WidgetState.error)
                ? scheme.error
                : states.contains(WidgetState.focused)
                    ? scheme.primary
                    : scheme.onSurfaceVariant,
          ),
        ),
        hintStyle: TextStyle(color: scheme.onSurfaceVariant.withValues(alpha: 0.7)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 70,
        elevation: 0,
        backgroundColor: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        indicatorColor: scheme.primaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 12,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
            color: selected ? scheme.secondary : scheme.onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? scheme.onPrimaryContainer : scheme.onSurfaceVariant,
          );
        }),
      ),
      chipTheme: ChipThemeData(
        shape: const StadiumBorder(),
        side: BorderSide(color: scheme.outlineVariant),
        backgroundColor: scheme.surfaceContainerLowest,
        selectedColor: scheme.primaryContainer,
        labelStyle: label.copyWith(fontWeight: FontWeight.w600, color: scheme.onSurface),
        secondaryLabelStyle: label.copyWith(fontWeight: FontWeight.w700, color: scheme.onPrimaryContainer),
        checkmarkColor: scheme.onPrimaryContainer,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          foregroundColor: scheme.onSurfaceVariant,
          selectedBackgroundColor: scheme.primaryContainer,
          selectedForegroundColor: scheme.onPrimaryContainer,
          side: BorderSide(color: scheme.outlineVariant),
          textStyle: label.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: scheme.inverseSurface,
        contentTextStyle: TextStyle(color: scheme.onInverseSurface, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant, thickness: 1, space: 1),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.onSurfaceVariant,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.surfaceContainerHigh,
        circularTrackColor: scheme.surfaceContainerHigh,
      ),
    );
  }
}

/// 숫자·통계 표시용 타이포그래피 (Outfit, 고정폭 숫자)
abstract final class AppText {
  static const numericFamily = 'Outfit';

  static TextStyle numeric(
    double size, {
    FontWeight weight = FontWeight.w700,
    Color? color,
    double height = 1.1,
  }) {
    return TextStyle(
      fontFamily: numericFamily,
      fontSize: size,
      fontWeight: weight,
      color: color,
      height: height,
      letterSpacing: -0.3,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
  }
}
