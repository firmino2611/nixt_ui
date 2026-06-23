import 'package:flutter/widgets.dart';

import '../../tokens/color_roles.dart';
import '../variant_resolver.dart';

/// Per-component style overrides for `NixtButton` — the typed override object
/// (ADR-3). Set globally on the theme, or pass a partial instance to a single
/// button. All fields are nullable; nulls fall back to the resolved defaults.
@immutable
class NixtButtonTheme {
  /// Creates a button theme. All fields optional.
  const NixtButtonTheme({
    this.defaultColor,
    this.defaultVariant,
    this.minHeightMd,
    this.fontWeight,
  });

  /// Default semantic color when a button omits `color`.
  final NixtColorRole? defaultColor;

  /// Default variant when a button omits `variant`.
  final NixtVariant? defaultVariant;

  /// Override the medium-size min height (defaults to 42).
  final double? minHeightMd;

  /// Override the label weight (defaults to semibold/600).
  final FontWeight? fontWeight;

  /// Returns a copy with the given fields replaced.
  NixtButtonTheme copyWith({
    NixtColorRole? defaultColor,
    NixtVariant? defaultVariant,
    double? minHeightMd,
    FontWeight? fontWeight,
  }) =>
      NixtButtonTheme(
        defaultColor: defaultColor ?? this.defaultColor,
        defaultVariant: defaultVariant ?? this.defaultVariant,
        minHeightMd: minHeightMd ?? this.minHeightMd,
        fontWeight: fontWeight ?? this.fontWeight,
      );

  /// Merges [other] over this, preferring [other]'s non-null fields.
  NixtButtonTheme merge(NixtButtonTheme? other) {
    if (other == null) return this;
    return copyWith(
      defaultColor: other.defaultColor,
      defaultVariant: other.defaultVariant,
      minHeightMd: other.minHeightMd,
      fontWeight: other.fontWeight,
    );
  }

  /// Interpolates the numeric fields; discrete fields snap at the midpoint.
  static NixtButtonTheme lerp(NixtButtonTheme a, NixtButtonTheme b, double t) =>
      NixtButtonTheme(
        defaultColor: t < 0.5 ? a.defaultColor : b.defaultColor,
        defaultVariant: t < 0.5 ? a.defaultVariant : b.defaultVariant,
        minHeightMd: _lerpD(a.minHeightMd, b.minHeightMd, t),
        fontWeight: t < 0.5 ? a.fontWeight : b.fontWeight,
      );

  static double? _lerpD(double? a, double? b, double t) {
    if (a == null && b == null) return null;
    return (a ?? b!) + ((b ?? a!) - (a ?? b!)) * t;
  }
}
