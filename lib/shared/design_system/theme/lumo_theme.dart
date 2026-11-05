import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../tokens/lumo_colors.dart';
import '../tokens/lumo_typography.dart';
import '../tokens/lumo_radius.dart';
import '../tokens/lumo_spacing.dart';

/// Lumo Design System — Theme
/// Wires all design tokens into Flutter's ThemeData.
/// Warm palette — Ethiopian golden light meets premium minimalism.
abstract final class LumoTheme {
  static ThemeData get light => _buildTheme(brightness: Brightness.light);
  static ThemeData get dark => _buildTheme(brightness: Brightness.dark);

  static ThemeData _buildTheme({required Brightness brightness}) {
    final isDark = brightness == Brightness.dark;

    final background       = isDark ? LumoColors.darkBackground       : LumoColors.lightBackground;
    final surface          = isDark ? LumoColors.darkSurface          : LumoColors.lightSurface;
    final primary          = isDark ? LumoColors.darkPrimary          : LumoColors.lightPrimary;
    final secondary        = isDark ? LumoColors.darkSecondary        : LumoColors.lightSecondary;
    final textPrimary      = isDark ? LumoColors.darkTextPrimary      : LumoColors.lightTextPrimary;
    final textSecondary    = isDark ? LumoColors.darkTextSecondary    : LumoColors.lightTextSecondary;
    final divider          = isDark ? LumoColors.darkDivider          : LumoColors.lightDivider;
    final error            = isDark ? LumoColors.darkError            : LumoColors.lightError;
    final surfaceSecondary = isDark ? LumoColors.darkSurfaceSecondary : LumoColors.lightSurfaceSecondary;
    final primaryContainer = isDark ? LumoColors.darkPrimaryContainer : LumoColors.lightPrimaryContainer;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      dividerColor: divider,

      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primary,
        onPrimary: isDark ? LumoColors.darkBackground : LumoColors.lightBackground,
        primaryContainer: primaryContainer,
        onPrimaryContainer: textPrimary,
        secondary: secondary,
        onSecondary: surface,
        secondaryContainer: surfaceSecondary,
        onSecondaryContainer: textSecondary,
        surface: surface,
        onSurface: textPrimary,
        error: error,
        onError: LumoColors.white,
        outline: divider,
        outlineVariant: divider,
        // Tertiary slot carries the gold accent throughout the app
        tertiary: isDark ? LumoColors.darkGold : LumoColors.lightGold,
        onTertiary: isDark ? LumoColors.darkBackground : LumoColors.lightBackground,
        tertiaryContainer: isDark ? LumoColors.darkGoldContainer : LumoColors.lightGoldContainer,
        onTertiaryContainer: isDark ? LumoColors.darkGold : LumoColors.lightGold,
      ),

      textTheme: TextTheme(
        displayLarge:   LumoTypography.displayLarge.copyWith(color: textPrimary),
        displayMedium:  LumoTypography.displayMedium.copyWith(color: textPrimary),
        headlineLarge:  LumoTypography.headlineLarge.copyWith(color: textPrimary),
        headlineMedium: LumoTypography.headlineMedium.copyWith(color: textPrimary),
        headlineSmall:  LumoTypography.headlineSmall.copyWith(color: textPrimary),
        titleLarge:     LumoTypography.titleLarge.copyWith(color: textPrimary),
        titleMedium:    LumoTypography.titleMedium.copyWith(color: textPrimary),
        bodyLarge:      LumoTypography.bodyLarge.copyWith(color: textPrimary),
        bodyMedium:     LumoTypography.bodyMedium.copyWith(color: textSecondary),
        bodySmall:      LumoTypography.bodySmall.copyWith(color: textSecondary),
        labelLarge:     LumoTypography.labelLarge.copyWith(color: textPrimary),
        labelMedium:    LumoTypography.labelMedium.copyWith(color: textSecondary),
        labelSmall:     LumoTypography.labelSmall.copyWith(color: textSecondary),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light.copyWith(statusBarColor: LumoColors.transparent)
            : SystemUiOverlayStyle.dark.copyWith(statusBarColor: LumoColors.transparent),
        titleTextStyle: LumoTypography.titleMedium.copyWith(color: textPrimary),
      ),

      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: LumoRadius.borderLarge),
        margin: EdgeInsets.zero,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: isDark ? LumoColors.darkBackground : LumoColors.lightBackground,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: LumoSpacing.space24,
            vertical: LumoSpacing.space16,
          ),
          shape: const RoundedRectangleBorder(borderRadius: LumoRadius.borderMedium),
          textStyle: LumoTypography.labelLarge,
          minimumSize: const Size(double.infinity, 52),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide(color: divider),
          padding: const EdgeInsets.symmetric(
            horizontal: LumoSpacing.space24,
            vertical: LumoSpacing.space16,
          ),
          shape: const RoundedRectangleBorder(borderRadius: LumoRadius.borderMedium),
          textStyle: LumoTypography.labelLarge,
          minimumSize: const Size(double.infinity, 52),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          padding: const EdgeInsets.symmetric(
            horizontal: LumoSpacing.space16,
            vertical: LumoSpacing.space8,
          ),
          textStyle: LumoTypography.labelLarge,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceSecondary,
        border: OutlineInputBorder(
          borderRadius: LumoRadius.borderMedium,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: LumoRadius.borderMedium,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: LumoRadius.borderMedium,
          borderSide: BorderSide(color: primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: LumoRadius.borderMedium,
          borderSide: BorderSide(color: error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: LumoSpacing.space16,
          vertical: LumoSpacing.space16,
        ),
        hintStyle: LumoTypography.bodyMedium.copyWith(color: textSecondary),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: primary,
        unselectedItemColor: secondary,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
      ),

      dividerTheme: DividerThemeData(
        color: divider,
        thickness: 1,
        space: 1,
      ),

      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
