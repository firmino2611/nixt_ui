import 'dart:ui';

import 'palette.dart';

/// Configures a color role from a single brand color.
///
/// The [seed] becomes shade `500` — the middle of the ruler — and the rest of
/// the scale (`50` lightest … `950` darkest) is generated around it. Pass
/// [shades] to override individual steps when the generated tone needs tuning;
/// only the listed keys change, everything else stays derived from [seed].
///
/// ```dart
/// // One brand color → full primary scale.
/// NixtRoleColor(Color(0xFF7C3AED));
/// // Same, but force a deeper 900.
/// NixtRoleColor(Color(0xFF7C3AED), shades: {NixtShade.s900: Color(0xFF2E1065)});
/// ```
class NixtRoleColor {
  /// Creates a role config from a [seed] (shade 500) and optional [shades]
  /// overrides.
  const NixtRoleColor(this.seed, {this.shades});

  /// The brand color — used as shade `500`.
  final Color seed;

  /// Optional per-shade overrides layered over the generated scale.
  final Map<NixtShade, Color>? shades;

  /// The resolved full scale (seed-generated, with [shades] applied).
  NixtColorScale get scale => NixtColorScale.fromSeed(seed, overrides: shades);
}

/// The seven semantic color roles of the design system.
///
/// Mirrors the `--ui-color-{role}` token families. Each role resolves to a
/// full [NixtColorScale]; `neutral` is special-cased (switchable palette).
enum NixtColorRole {
  /// Brand / primary actions (green).
  primary,

  /// Secondary actions (blue).
  secondary,

  /// Positive / success (green).
  success,

  /// Informational (sky).
  info,

  /// Caution (amber). Its solid foreground is dark, not white.
  warning,

  /// Destructive / error (red).
  error,

  /// Surfaces, text, borders (switchable neutral palette).
  neutral,
}

/// Maps the non-neutral [NixtColorRole]s to their fixed palette scales.
///
/// `neutral` is intentionally absent — it is resolved at theme time from the
/// active [NixtNeutral] choice, since it is runtime-switchable.
abstract final class NixtRoleScales {
  /// Fixed scale for a role. Throws for [NixtColorRole.neutral] — resolve that
  /// through the active neutral palette instead.
  static NixtColorScale of(NixtColorRole role) {
    switch (role) {
      case NixtColorRole.primary:
      case NixtColorRole.success:
        return NixtPalette.green;
      case NixtColorRole.secondary:
        return NixtPalette.blue;
      case NixtColorRole.info:
        return NixtPalette.sky;
      case NixtColorRole.warning:
        return NixtPalette.amber;
      case NixtColorRole.error:
        return NixtPalette.red;
      case NixtColorRole.neutral:
        throw ArgumentError(
          'neutral has no fixed scale — read it from NixtColors.neutral',
        );
    }
  }
}
