import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const double kFloatingNavigationClearance = 132;

enum AppAccentTheme { mint, ocean, violet, coral, graphite }

@immutable
class LighterAccentPalette extends ThemeExtension<LighterAccentPalette> {
  const LighterAccentPalette({
    required this.primary,
    required this.pressed,
    required this.tint,
    required this.soft,
    required this.backgroundStart,
    required this.backgroundMiddle,
    required this.backgroundEnd,
  });

  final Color primary;
  final Color pressed;
  final Color tint;
  final Color soft;
  final Color backgroundStart;
  final Color backgroundMiddle;
  final Color backgroundEnd;

  static LighterAccentPalette of(BuildContext context) =>
      Theme.of(context).extension<LighterAccentPalette>()!;

  @override
  LighterAccentPalette copyWith({
    Color? primary,
    Color? pressed,
    Color? tint,
    Color? soft,
    Color? backgroundStart,
    Color? backgroundMiddle,
    Color? backgroundEnd,
  }) => LighterAccentPalette(
    primary: primary ?? this.primary,
    pressed: pressed ?? this.pressed,
    tint: tint ?? this.tint,
    soft: soft ?? this.soft,
    backgroundStart: backgroundStart ?? this.backgroundStart,
    backgroundMiddle: backgroundMiddle ?? this.backgroundMiddle,
    backgroundEnd: backgroundEnd ?? this.backgroundEnd,
  );

  @override
  LighterAccentPalette lerp(covariant LighterAccentPalette? other, double t) {
    if (other == null) return this;
    return LighterAccentPalette(
      primary: Color.lerp(primary, other.primary, t)!,
      pressed: Color.lerp(pressed, other.pressed, t)!,
      tint: Color.lerp(tint, other.tint, t)!,
      soft: Color.lerp(soft, other.soft, t)!,
      backgroundStart: Color.lerp(backgroundStart, other.backgroundStart, t)!,
      backgroundMiddle: Color.lerp(
        backgroundMiddle,
        other.backgroundMiddle,
        t,
      )!,
      backgroundEnd: Color.lerp(backgroundEnd, other.backgroundEnd, t)!,
    );
  }
}

extension AppAccentThemePalette on AppAccentTheme {
  LighterAccentPalette get palette => switch (this) {
    AppAccentTheme.mint => const LighterAccentPalette(
      primary: Color(0xFF24B78B),
      pressed: Color(0xFF15946F),
      tint: Color(0xFFE8F8F2),
      soft: Color(0xFFC9F0E3),
      backgroundStart: Color(0xFFF8FBFF),
      backgroundMiddle: Color(0xFFF3FAF8),
      backgroundEnd: Color(0xFFF7F5FF),
    ),
    AppAccentTheme.ocean => const LighterAccentPalette(
      primary: Color(0xFF3B91E8),
      pressed: Color(0xFF246DB8),
      tint: Color(0xFFEAF4FF),
      soft: Color(0xFFCDE6FF),
      backgroundStart: Color(0xFFF7FBFF),
      backgroundMiddle: Color(0xFFF0F7FF),
      backgroundEnd: Color(0xFFF6F4FF),
    ),
    AppAccentTheme.violet => const LighterAccentPalette(
      primary: Color(0xFF7869DE),
      pressed: Color(0xFF5B4CBD),
      tint: Color(0xFFF0EEFF),
      soft: Color(0xFFDCD7FF),
      backgroundStart: Color(0xFFFBFAFF),
      backgroundMiddle: Color(0xFFF5F2FF),
      backgroundEnd: Color(0xFFFFF6FC),
    ),
    AppAccentTheme.coral => const LighterAccentPalette(
      primary: Color(0xFFF07164),
      pressed: Color(0xFFC95047),
      tint: Color(0xFFFFEFEC),
      soft: Color(0xFFFFD6D0),
      backgroundStart: Color(0xFFFFFBF8),
      backgroundMiddle: Color(0xFFFFF4F1),
      backgroundEnd: Color(0xFFFFF8EE),
    ),
    AppAccentTheme.graphite => const LighterAccentPalette(
      primary: Color(0xFF536A86),
      pressed: Color(0xFF374D68),
      tint: Color(0xFFEDF2F7),
      soft: Color(0xFFD7E0EA),
      backgroundStart: Color(0xFFF8FAFC),
      backgroundMiddle: Color(0xFFF2F5F8),
      backgroundEnd: Color(0xFFF7F8FB),
    ),
  };
}

class AppColors {
  static const background = Color(0xFFF5F8FC);
  static const surface = Color(0xFFFFFFFF);
  static const surface2 = Color(0xFFF0F4F8);
  static const foreground = Color(0xFF30445D);
  static const strong = Color(0xFF102B50);
  static const muted = Color(0xFF718198);
  static const faint = Color(0xFFA3AFBF);
  static const border = Color(0xFFE5EBF2);
  static const borderStrong = Color(0xFFD6DEE8);
  static const accent = Color(0xFF24B78B);
  static const accentPressed = Color(0xFF15946F);
  static const accentTint = Color(0xFFE8F8F2);
  static const accentSoft = Color(0xFFC9F0E3);
  static const water = Color(0xFF43A9F4);
  static const waterTint = Color(0xFFEAF6FF);
  static const weight = Color(0xFF22BFA1);
  static const weightTint = Color(0xFFE7FAF5);
  static const calories = Color(0xFF7DBE3C);
  static const caloriesTint = Color(0xFFF1F8E7);
  static const steps = Color(0xFFF2A31D);
  static const stepsTint = Color(0xFFFFF4DF);
  static const purple = Color(0xFF776BE3);
  static const purpleTint = Color(0xFFF0EEFF);
  static const coral = Color(0xFFF17668);
  static const coralTint = Color(0xFFFFEFEC);
  static const danger = Color(0xFFD15454);
  static const warning = Color(0xFFE59A24);
  static const plus = Color(0xFF6658C8);
}

ThemeData buildLighterTheme({
  AppAccentTheme accentTheme = AppAccentTheme.mint,
}) {
  final accent = accentTheme.palette;
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: accent.primary,
      brightness: Brightness.light,
      surface: AppColors.surface,
      error: AppColors.danger,
    ),
    fontFamily: CupertinoThemeData().textTheme.textStyle.fontFamily,
  );
  return base.copyWith(
    extensions: [accent],
    textTheme: base.textTheme.copyWith(
      displayLarge: const TextStyle(
        fontSize: 42,
        height: 1.05,
        fontWeight: FontWeight.w700,
        color: AppColors.strong,
        letterSpacing: -1.2,
      ),
      headlineLarge: const TextStyle(
        fontSize: 32,
        height: 1.15,
        fontWeight: FontWeight.w700,
        color: AppColors.strong,
        letterSpacing: -0.6,
      ),
      headlineMedium: const TextStyle(
        fontSize: 26,
        height: 1.2,
        fontWeight: FontWeight.w600,
        color: AppColors.strong,
        letterSpacing: -0.35,
      ),
      titleLarge: const TextStyle(
        fontSize: 20,
        height: 1.25,
        fontWeight: FontWeight.w600,
        color: AppColors.strong,
      ),
      titleMedium: const TextStyle(
        fontSize: 16,
        height: 1.3,
        fontWeight: FontWeight.w600,
        color: AppColors.foreground,
      ),
      bodyLarge: const TextStyle(
        fontSize: 16,
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: AppColors.foreground,
      ),
      bodyMedium: const TextStyle(
        fontSize: 14,
        height: 1.5,
        fontWeight: FontWeight.w400,
        color: AppColors.muted,
      ),
      labelLarge: const TextStyle(
        fontSize: 15,
        height: 1.1,
        fontWeight: FontWeight.w600,
      ),
    ),
    dividerColor: AppColors.border,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.strong,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: const CardThemeData(
      color: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: accent.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.foreground,
        minimumSize: const Size.fromHeight(52),
        side: const BorderSide(color: AppColors.borderStrong),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: accent.primary, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xF7F9FBF9),
      elevation: 0,
      height: 76,
      indicatorColor: accent.tint,
      labelTextStyle: const WidgetStatePropertyAll(
        TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
