import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTheme {
  static const _lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.vermilion,
    onPrimary: Colors.white,
    primaryContainer: AppColors.peach,
    onPrimaryContainer: AppColors.burgundyDeep,
    secondary: AppColors.burgundy,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFFFDDE3),
    onSecondaryContainer: AppColors.burgundyDeep,
    tertiary: AppColors.violet,
    onTertiary: Colors.white,
    tertiaryContainer: AppColors.lavenderMist,
    onTertiaryContainer: AppColors.violetDeep,
    error: Color(0xFFB3261E),
    onError: Colors.white,
    errorContainer: Color(0xFFF9DEDC),
    onErrorContainer: Color(0xFF410E0B),
    surface: AppColors.cream,
    onSurface: AppColors.ink,
    onSurfaceVariant: Color(0xFF6E5450),
    surfaceDim: Color(0xFFEED8CF),
    surfaceBright: AppColors.cream,
    surfaceContainerLowest: Colors.white,
    surfaceContainerLow: Color(0xFFFFF1EA),
    surfaceContainer: Color(0xFFFFEAE0),
    surfaceContainerHigh: Color(0xFFFCE3D8),
    surfaceContainerHighest: Color(0xFFF7DCD0),
    outline: Color(0xFFA1857F),
    outlineVariant: Color(0xFFF0DAD1),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFF3F2427),
    onInverseSurface: Color(0xFFFFEDE7),
    inversePrimary: Color(0xFFFFB4A1),
  );

  static const _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFFFF8A6B),
    onPrimary: Color(0xFF4A0D02),
    primaryContainer: Color(0xFF8E2410),
    onPrimaryContainer: AppColors.peach,
    secondary: Color(0xFFFFB2BE),
    onSecondary: AppColors.burgundyDeep,
    secondaryContainer: AppColors.burgundy,
    onSecondaryContainer: Color(0xFFFFD9DF),
    tertiary: AppColors.lavender,
    onTertiary: Color(0xFF2E0057),
    tertiaryContainer: Color(0xFF5A2696),
    onTertiaryContainer: AppColors.lavenderMist,
    error: Color(0xFFF2B8B5),
    onError: Color(0xFF601410),
    errorContainer: Color(0xFF8C1D18),
    onErrorContainer: Color(0xFFF9DEDC),
    surface: Color(0xFF1C1012),
    onSurface: Color(0xFFF7E6E2),
    onSurfaceVariant: Color(0xFFD8C0BA),
    surfaceDim: Color(0xFF1C1012),
    surfaceBright: Color(0xFF45302F),
    surfaceContainerLowest: Color(0xFF160B0D),
    surfaceContainerLow: Color(0xFF241517),
    surfaceContainer: Color(0xFF2A191C),
    surfaceContainerHigh: Color(0xFF352225),
    surfaceContainerHighest: Color(0xFF412C2F),
    outline: Color(0xFFA08C88),
    outlineVariant: Color(0xFF52403D),
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: Color(0xFFF7E6E2),
    onInverseSurface: Color(0xFF3F2427),
    inversePrimary: AppColors.vermilion,
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
