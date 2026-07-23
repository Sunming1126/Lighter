import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFFF9FBF9);
  static const surface = Color(0xFFFFFFFF);
  static const surface2 = Color(0xFFF3F6F4);
  static const foreground = Color(0xFF343936);
  static const strong = Color(0xFF202421);
  static const muted = Color(0xFF737B76);
  static const faint = Color(0xFFA5ADA8);
  static const border = Color(0xFFE7ECE9);
  static const borderStrong = Color(0xFFD5DDD8);
  static const accent = Color(0xFF5C8D7B);
  static const accentPressed = Color(0xFF4B7869);
  static const accentTint = Color(0xFFEDF5F1);
  static const accentSoft = Color(0xFFD6E6DE);
  static const danger = Color(0xFFB54C45);
  static const warning = Color(0xFFC69743);
  static const plus = Color(0xFF4F5E93);
}

ThemeData buildLighterTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      brightness: Brightness.light,
      surface: AppColors.surface,
      error: AppColors.danger,
    ),
    fontFamily: CupertinoThemeData().textTheme.textStyle.fontFamily,
  );
  return base.copyWith(
    textTheme: base.textTheme.copyWith(
      displayLarge: const TextStyle(
        fontSize: 42,
        height: 1.05,
        fontWeight: FontWeight.w700,
        color: AppColors.strong,
        letterSpacing: -1.2,
      ),
      headlineLarge: const TextStyle(
        fontSize: 30,
        height: 1.15,
        fontWeight: FontWeight.w700,
        color: AppColors.strong,
        letterSpacing: -0.6,
      ),
      headlineMedium: const TextStyle(
        fontSize: 24,
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
        borderRadius: BorderRadius.all(Radius.circular(20)),
        side: BorderSide(color: AppColors.border, width: .7),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(54),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.foreground,
        minimumSize: const Size.fromHeight(52),
        side: const BorderSide(color: AppColors.borderStrong),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
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
        borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
    ),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Color(0xF7F9FBF9),
      elevation: 0,
      height: 76,
      indicatorColor: AppColors.accentTint,
      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
