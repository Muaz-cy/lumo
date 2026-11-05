import 'package:flutter/material.dart';

/// Lumo Design System — Shadow Tokens
/// Shadows communicate elevation, never decoration.
/// Warmed slightly to match the parchment palette.
abstract final class LumoShadows {
  static const soft = [
    BoxShadow(
      color: Color(0x0A1C1A17),
      blurRadius: 8.0,
      offset: Offset(0, 2),
    ),
  ];

  static const floating = [
    BoxShadow(
      color: Color(0x141C1A17),
      blurRadius: 16.0,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x081C1A17),
      blurRadius: 4.0,
      offset: Offset(0, 1),
    ),
  ];

  static const hero = [
    BoxShadow(
      color: Color(0x1F1C1A17),
      blurRadius: 32.0,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x0A1C1A17),
      blurRadius: 8.0,
      offset: Offset(0, 2),
    ),
  ];

  static const modal = [
    BoxShadow(
      color: Color(0x291C1A17),
      blurRadius: 48.0,
      offset: Offset(0, 16),
    ),
  ];

  // Gold glow — used on verified/featured badges
  static const gold = [
    BoxShadow(
      color: Color(0x33C9A84C),
      blurRadius: 12.0,
      offset: Offset(0, 4),
    ),
  ];
}
