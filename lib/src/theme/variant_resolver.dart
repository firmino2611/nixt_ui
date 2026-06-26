import 'package:flutter/widgets.dart';

import '../foundations/color_util.dart';
import '../tokens/color_roles.dart';
import 'nixt_colors.dart';

/// The shared visual variants used across interactive surfaces — a direct port
/// of the design system's `variantStyle` resolver.
enum NixtVariant {
  /// Filled with the role color.
  solid,

  /// Transparent with a tinted border.
  outline,

  /// Low-opacity tinted fill.
  soft,

  /// Tinted fill with a tinted border.
  subtle,

  /// Transparent, no border.
  ghost,

  /// Inline text style.
  link,
}

/// The resolved paint for a variant: background, foreground, and border color.
///
/// A `null` field means "paint nothing" (e.g. transparent background, no
/// border). Foreground is always present.
@immutable
class NixtResolvedColors {
  /// Creates a resolved color triple.
  const NixtResolvedColors({
    required this.foreground,
    this.background,
    this.border,
  });

  /// Text / icon color.
  final Color foreground;

  /// Fill color, or `null` for transparent.
  final Color? background;

  /// 1px border color, or `null` for none.
  final Color? border;
}

/// Resolves `(role, variant)` to concrete colors against a [NixtColors] set.
///
/// Tints use opacity over transparent — the Flutter equivalent of the DS's
/// `color-mix(in oklab, base X% transparent)`.
abstract final class NixtVariantResolver {
  /// Resolves the paint for [role] + [variant] under [colors].
  static NixtResolvedColors resolve(
    NixtColorRole role,
    NixtVariant variant,
    NixtColors colors,
  ) {
    final isNeutral = role == NixtColorRole.neutral;
    // Neutral uses highlighted text as its "base"; others use the role color.
    final base = isNeutral ? colors.textHighlighted : colors.role(role);
    // Solid foreground is contrast-picked from the fill — dark glyphs on light
    // fills (amber, bright cyan), white on dark ones. Same calc as the app bar.
    final onSolid = nixtOnColor(base);
    Color tint(double pct) => nixtOpacity(base, pct / 100);

    switch (variant) {
      case NixtVariant.outline:
        return isNeutral
            ? NixtResolvedColors(
                foreground: colors.text,
                border: colors.borderAccented,
              )
            : NixtResolvedColors(foreground: base, border: tint(50));
      case NixtVariant.soft:
        return isNeutral
            ? NixtResolvedColors(
                foreground: colors.textHighlighted,
                background: colors.bgElevated,
              )
            : NixtResolvedColors(foreground: base, background: tint(12));
      case NixtVariant.subtle:
        return isNeutral
            ? NixtResolvedColors(
                foreground: colors.textHighlighted,
                background: colors.bgElevated,
                border: colors.borderAccented,
              )
            : NixtResolvedColors(
                foreground: base,
                background: tint(12),
                border: tint(28),
              );
      case NixtVariant.ghost:
        return NixtResolvedColors(
          foreground: isNeutral ? colors.text : base,
        );
      case NixtVariant.link:
        return NixtResolvedColors(
          foreground: isNeutral ? colors.textMuted : base,
        );
      case NixtVariant.solid:
        return isNeutral
            ? NixtResolvedColors(
                foreground: colors.textInverted,
                background: colors.bgInverted,
              )
            : NixtResolvedColors(foreground: onSolid, background: base);
    }
  }
}
