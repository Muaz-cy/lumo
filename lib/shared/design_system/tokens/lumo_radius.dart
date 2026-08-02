import 'package:flutter/material.dart';

/// Lumo Design System — Radius Tokens
/// Every border radius must reference these tokens.
abstract final class LumoRadius {
  static const double small = 6.0;
  static const double medium = 12.0;
  static const double large = 16.0;
  static const double xl = 24.0;
  static const double pill = 999.0;

  static const borderSmall = BorderRadius.all(Radius.circular(small));
  static const borderMedium = BorderRadius.all(Radius.circular(medium));
  static const borderLarge = BorderRadius.all(Radius.circular(large));
  static const borderXL = BorderRadius.all(Radius.circular(xl));
  static const borderPill = BorderRadius.all(Radius.circular(pill));
}
