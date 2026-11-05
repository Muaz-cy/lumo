import 'package:flutter/material.dart';

/// Lumo Design System — Color Tokens
/// Warm palette inspired by Ethiopian golden light and terracotta earth.
/// Every color in the application must reference these tokens.
/// Never use raw hex values outside this file.
abstract final class LumoColors {
  // --- Light Theme ---
  // Warm parchment background — not cold white, feels like premium paper
  static const lightBackground = Color(0xFFFAF8F5);
  static const lightSurface = Color(0xFFFFFFFF);
  static const lightSurfaceSecondary = Color(0xFFF5F1EC);
  static const lightCard = Color(0xFFFFFFFF);
  // Warm charcoal — not cold black
  static const lightPrimary = Color(0xFF1C1A17);
  static const lightPrimaryContainer = Color(0xFFEEE9E2);
  // Warm mid-gray
  static const lightSecondary = Color(0xFF6B6560);
  static const lightTextPrimary = Color(0xFF1C1A17);
  static const lightTextSecondary = Color(0xFF6B6560);
  static const lightTextTertiary = Color(0xFFADA8A2);
  static const lightDivider = Color(0xFFEDE9E4);
  static const lightBorder = Color(0xFFE2DDD7);
  static const lightSkeleton = Color(0xFFEDE9E4);
  static const lightOverlay = Color(0x80000000);
  static const lightHero = Color(0xFF1C1A17);
  static const lightSuccess = Color(0xFF2D6A4F);
  static const lightWarning = Color(0xFFB45309);
  static const lightError = Color(0xFFB91C1C);
  // Investment gold — prosperity signal, used sparingly
  static const lightGold = Color(0xFFC9A84C);
  static const lightGoldContainer = Color(0xFFF7F0DC);
  // Verified — quiet authority, warm slate. Not clinical, not loud.
  // Reads as: "this has been checked by someone who knows what they're doing."
  static const lightVerified = Color(0xFF3D3530);
  static const lightVerifiedContainer = Color(0xFFF0EDE8);
  // Legacy aliases — kept for backward compatibility with existing screens
  static const lightRating = Color(0xFFC9A84C);    // gold doubles as rating star
  static const lightDiscount = Color(0xFFB91C1C);  // same as error — price reduction

  // --- Dark Theme ---
  // Deep warm dark — not cold black
  static const darkBackground = Color(0xFF131210);
  static const darkSurface = Color(0xFF1E1C19);
  static const darkSurfaceSecondary = Color(0xFF272420);
  static const darkCard = Color(0xFF1E1C19);
  static const darkPrimary = Color(0xFFF5F0E8);
  static const darkPrimaryContainer = Color(0xFF2E2B26);
  static const darkSecondary = Color(0xFF9E9890);
  static const darkTextPrimary = Color(0xFFF5F0E8);
  static const darkTextSecondary = Color(0xFF9E9890);
  static const darkTextTertiary = Color(0xFF6B6560);
  static const darkDivider = Color(0xFF2E2B26);
  static const darkBorder = Color(0xFF3A3630);
  static const darkSkeleton = Color(0xFF2E2B26);
  static const darkOverlay = Color(0x99000000);
  static const darkHero = Color(0xFFF5F0E8);
  static const darkSuccess = Color(0xFF4ADE80);
  static const darkWarning = Color(0xFFFBBF24);
  static const darkError = Color(0xFFF87171);
  // Gold stays warm in dark mode
  static const darkGold = Color(0xFFD4AF5A);
  static const darkGoldContainer = Color(0xFF2E2710);
  static const darkVerified = Color(0xFFD4C5B0);
  static const darkVerifiedContainer = Color(0xFF2A2520);

  // --- Shared ---
  static const transparent = Colors.transparent;
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
}
