import 'package:flutter/material.dart';

/// Lumo Design System — Shadow Tokens
/// Shadows communicate elevation, never decoration.
abstract final class LumoShadows {
  static const soft = [
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 8.0,
      offset: Offset(0, 2),
    ),
  ];

  static const floating = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 16.0,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 4.0,
      offset: Offset(0, 1),
    ),
  ];

  static const hero = [
    BoxShadow(
      color: Color(0x1F000000),
      blurRadius: 32.0,
      offset: Offset(0, 8),
    ),
    BoxShadow(
      color: Color(0x0A000000),
      blurRadius: 8.0,
      offset: Offset(0, 2),
    ),
  ];

  static const modal = [
    BoxShadow(
      color: Color(0x29000000),
      blurRadius: 48.0,
      offset: Offset(0, 16),
    ),
  ];
}
