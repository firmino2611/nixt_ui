import 'dart:ui';

/// Typography primitives from `typography.css`.
///
/// Body uses Poppins (the brand choice); mono uses JetBrains Mono. Both are
/// bundled with the package, so no network/font dependency is required.
abstract final class NixtTypography {
  /// Sans family — bundled. Fallbacks handled by the platform.
  static const String fontSans = 'Poppins';

  /// Monospace family — bundled.
  static const String fontMono = 'JetBrainsMono';

  // ---- Weights ----
  /// 400.
  static const FontWeight weightNormal = FontWeight.w400;

  /// 500.
  static const FontWeight weightMedium = FontWeight.w500;

  /// 600.
  static const FontWeight weightSemibold = FontWeight.w600;

  /// 700.
  static const FontWeight weightBold = FontWeight.w700;

  // ---- Type scale (logical px; rem * 16) ----
  /// 11px.
  static const double text2xs = 11;

  /// 12px.
  static const double textXs = 12;

  /// 14px.
  static const double textSm = 14;

  /// 16px.
  static const double textBase = 16;

  /// 18px.
  static const double textLg = 18;

  /// 20px.
  static const double textXl = 20;

  /// 24px.
  static const double text2xl = 24;

  /// 30px.
  static const double text3xl = 30;

  /// 36px.
  static const double text4xl = 36;

  /// 48px.
  static const double text5xl = 48;

  // ---- Line heights (multipliers; map to TextStyle.height) ----
  /// 1.0.
  static const double leadingNone = 1;

  /// 1.25.
  static const double leadingTight = 1.25;

  /// 1.375.
  static const double leadingSnug = 1.375;

  /// 1.5.
  static const double leadingNormal = 1.5;

  /// 1.625.
  static const double leadingRelaxed = 1.625;

  // ---- Tracking (in `em`; multiply by font size for letterSpacing) ----
  /// -0.03em.
  static const double trackingTighter = -0.03;

  /// -0.015em.
  static const double trackingTight = -0.015;

  /// 0em.
  static const double trackingNormal = 0;

  /// 0.02em.
  static const double trackingWide = 0.02;

  /// 0.06em.
  static const double trackingWider = 0.06;

  /// Converts an `em` tracking value to a logical-pixel `letterSpacing` for the
  /// given [fontSize] (Flutter expresses letter spacing in pixels, not em).
  static double letterSpacing(double emTracking, double fontSize) => emTracking * fontSize;
}
