import 'package:flutter/material.dart';

/// Lumo Design System — Motion Tokens
/// Every animation must belong to this language.
/// Never invent random durations or curves.
abstract final class LumoMotion {
  // --- Durations ---
  static const Duration instant = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration deliberate = Duration(milliseconds: 450);
  static const Duration slow = Duration(milliseconds: 600);
  static const Duration hero = Duration(milliseconds: 500);

  // --- Curves ---
  static const Curve standard = Curves.easeInOut;
  static const Curve enter = Curves.easeOut;
  static const Curve exit = Curves.easeIn;
  static const Curve spring = Curves.elasticOut;
  static const Curve silk = Curves.fastLinearToSlowEaseIn;
  static const Curve snap = Curves.easeOutExpo;

  // --- Named Transitions ---

  /// LumoFade — opacity transition for appearing/disappearing elements
  static const lumoFade = (duration: fast, curve: enter);

  /// LumoReveal — content revealing from below
  static const lumoReveal = (duration: normal, curve: enter);

  /// LumoLift — card lifting on interaction
  static const lumoLift = (duration: fast, curve: snap);

  /// LumoDrop — element settling into place
  static const lumoDrop = (duration: deliberate, curve: silk);

  /// LumoExpand — expanding containers
  static const lumoExpand = (duration: normal, curve: snap);

  /// LumoCollapse — collapsing containers
  static const lumoCollapse = (duration: fast, curve: exit);

  /// LumoHero — shared element transitions
  static const lumoHero = (duration: hero, curve: silk);

  /// LumoSlide — horizontal/vertical slides
  static const lumoSlide = (duration: normal, curve: snap);

  /// LumoSnap — immediate snapping interactions
  static const lumoSnap = (duration: instant, curve: snap);

  /// LumoFloat — floating element entrance
  static const lumoFloat = (duration: deliberate, curve: enter);

  /// LumoSilk — ultra-smooth premium transitions
  static const lumoSilk = (duration: slow, curve: silk);

  /// LumoMorph — shape/size morphing
  static const lumoMorph = (duration: deliberate, curve: standard);
}
