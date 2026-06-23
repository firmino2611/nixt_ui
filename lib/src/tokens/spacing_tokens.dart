/// Spacing primitives from `spacing.css` — a 4px base grid plus mobile-layout
/// tokens (tap target, safe areas, gutters).
abstract final class NixtSpacing {
  /// 0.
  static const double s0 = 0;

  /// 1px.
  static const double px = 1;

  /// 2px.
  static const double s0_5 = 2;

  /// 4px.
  static const double s1 = 4;

  /// 6px.
  static const double s1_5 = 6;

  /// 8px.
  static const double s2 = 8;

  /// 10px.
  static const double s2_5 = 10;

  /// 12px.
  static const double s3 = 12;

  /// 16px.
  static const double s4 = 16;

  /// 20px.
  static const double s5 = 20;

  /// 24px.
  static const double s6 = 24;

  /// 32px.
  static const double s8 = 32;

  /// 40px.
  static const double s10 = 40;

  /// 48px.
  static const double s12 = 48;

  /// 64px.
  static const double s16 = 64;

  /// 80px.
  static const double s20 = 80;

  // ---- Mobile layout tokens ----
  /// Minimum interactive size (iOS HIG / Material).
  static const double tapTarget = 44;

  /// Default horizontal page padding.
  static const double screenGutter = 16;

  /// Status-bar safe inset (fallback; prefer MediaQuery at runtime).
  static const double safeTop = 44;

  /// Home-indicator / gesture-bar safe inset (fallback).
  static const double safeBottom = 34;

  /// Phone content max width.
  static const double containerSm = 384;
}
