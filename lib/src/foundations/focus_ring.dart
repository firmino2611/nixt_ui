import 'package:flutter/widgets.dart';

/// Builds the design system's two-layer focus ring decoration:
/// a 2px gap in the background color, then a 4px ring in the accent color
/// (the DS's `box-shadow: 0 0 0 2px bg, 0 0 0 4px primary`).
///
/// Apply the returned [BoxShadow] list on the focused surface's [BoxDecoration].
abstract final class NixtFocusRing {
  /// Returns the focus-ring shadows for the given [background] and [accent].
  ///
  /// Implemented as spread-only shadows (no blur) to mimic stacked CSS rings.
  static List<BoxShadow> shadows({
    required Color background,
    required Color accent,
    double gap = 2,
    double ring = 4,
  }) =>
      [
        BoxShadow(color: background, spreadRadius: gap),
        BoxShadow(color: accent, spreadRadius: ring),
      ];
}
