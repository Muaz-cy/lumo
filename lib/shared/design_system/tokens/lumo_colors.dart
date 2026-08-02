import 'package:flutter/material.dart';

/// Lumo Design System — Color Tokens
/// Every color in the application must reference these tokens.
/// Never use raw hex values outside this file.
abstract final class LumoColors {
  // --- Light Theme ---
  static const lightBackground = Color(0xFFF9F9F7);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceSecondary = Color(0xFFF2F2F0);
  static const lightCard = Color(0xFFFFFFFF);
  static const lightPrimary = Color(0xFF1A1A1A);
  static const lightPrimaryContainer = Color(0xFFEEEEEC);
  static const lightSecondary = Color(0xFF6B6B6B);
  static const lightTextPrimary = Color(0xFF1A1A1A);
  static const lightTextSecondary = Color(0xFF6B6B6B);
  static const lightTextTertiary = Color(0xFFAAAAAA);
  static const lightDivider = Color(0xFFEEEEEC);
  static const lightBorder = Color(0xFFE0E0DE);
  static const lightSkeleton = Color(0xFFEEEEEC);
  static const lightOverlay = Color(0x80000000);
  static const lightHero = Color(0xFF1A1A1A);
  static const lightSuccess = Color(0xFF2D7A4F);
  static const lightWarning = Color(0xFFB45309);
  static const lightError = Color(0xFFB91C1C);
  static const lightRating = Color(0xFFD97706);
  static const lightDiscount = Color(0xFFB91C1C);

  // --- Dark Theme ---
  static const darkBackground = Color(0xFF111110);
  static const darkSurface = Color(0xFF1C1C1A);
  static const darkSurfaceSecondary = Color(0xFF242422);
  static const darkCard = Color(0xFF1C1C1A);
  static const darkPrimary = Color(0xFFF5F5F3);
  static const darkPrimaryContainer = Color(0xFF2A2A28);
  static const darkSecondary = Color(0xFF999997);
  static const darkTextPrimary = Color(0xFFF5F5F3);
  static const darkTextSecondary = Color(0xFF999997);
  static const darkTextTertiary = Color(0xFF666664);
  static const darkDivider = Color(0xFF2A2A28);
  static const darkBorder = Color(0xFF333331);
  static const darkSkeleton = Color(0xFF2A2A28);
  static const darkOverlay = Color(0x99000000);
  static const darkHero = Color(0xFFF5F5F3);
  static const darkSuccess = Color(0xFF4ADE80);
  static const darkWarning = Color(0xFFFBBF24);
  static const darkError = Color(0xFFF87171);
  static const darkRating = Color(0xFFFBBF24);
  static const darkDiscount = Color(0xFFF87171);

  // --- Shared ---
  static const transparent = Colors.transparent;
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
}
