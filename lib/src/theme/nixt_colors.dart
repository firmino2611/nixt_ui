import 'package:flutter/widgets.dart';

import '../tokens/color_roles.dart';
import '../tokens/palette.dart';
import 'neutral_palette.dart';

/// Resolved semantic colors for one brightness + neutral palette.
///
/// This is the Dart equivalent of the `--ui-*` semantic shortcuts in
/// `colors.css`. Widgets consume these; they never touch raw palette shades.
@immutable
class NixtColors {
  /// Creates a fully-resolved color set. Prefer [NixtColors.light] /
  /// [NixtColors.dark].
  const NixtColors({
    required this.brightness,
    required this.neutral,
    required this.roleScales,
    required this.primary,
    required this.secondary,
    required this.success,
    required this.info,
    required this.warning,
    required this.error,
    required this.textDimmed,
    required this.textMuted,
    required this.textToned,
    required this.text,
    required this.textHighlighted,
    required this.textInverted,
    required this.bg,
    required this.bgMuted,
    required this.bgElevated,
    required this.bgAccented,
    required this.bgInverted,
    required this.border,
    required this.borderMuted,
    required this.borderAccented,
    required this.borderInverted,
  });

  /// Light or dark.
  final Brightness brightness;

  /// The active neutral palette.
  final NixtNeutral neutral;

  /// The resolved palette scale for each non-neutral role (after any global
  /// overrides). Drives [scaleFor] and the per-shade tints.
  final Map<NixtColorRole, NixtColorScale> roleScales;

  /// Brand / primary (green).
  final Color primary;

  /// Secondary (blue).
  final Color secondary;

  /// Success (green).
  final Color success;

  /// Info (sky).
  final Color info;

  /// Warning (amber).
  final Color warning;

  /// Error (red).
  final Color error;

  /// Dimmed text.
  final Color textDimmed;

  /// Muted text.
  final Color textMuted;

  /// Toned text.
  final Color textToned;

  /// Default body text.
  final Color text;

  /// Highlighted / heading text.
  final Color textHighlighted;

  /// Text on inverted surfaces.
  final Color textInverted;

  /// Base background.
  final Color bg;

  /// Muted background.
  final Color bgMuted;

  /// Elevated background.
  final Color bgElevated;

  /// Accented background.
  final Color bgAccented;

  /// Inverted background.
  final Color bgInverted;

  /// Default border.
  final Color border;

  /// Muted border.
  final Color borderMuted;

  /// Accented border.
  final Color borderAccented;

  /// Inverted border.
  final Color borderInverted;

  /// The resolved mid-shade color for a [role] (used as the tint base).
  Color role(NixtColorRole role) => switch (role) {
        NixtColorRole.primary => primary,
        NixtColorRole.secondary => secondary,
        NixtColorRole.success => success,
        NixtColorRole.info => info,
        NixtColorRole.warning => warning,
        NixtColorRole.error => error,
        NixtColorRole.neutral => textHighlighted,
      };

  /// The full scale for a role (respecting global overrides); neutral returns
  /// the active neutral scale.
  NixtColorScale scaleFor(NixtColorRole r) =>
      r == NixtColorRole.neutral ? neutral.scale : roleScales[r]!;

  /// Light-mode resolution for [neutral].
  ///
  /// [roles] optionally overrides the palette scale for one or more brand/status
  /// roles — the design-system-level color config. Light uses shade `500`.
  factory NixtColors.light({
    NixtNeutral neutral = NixtNeutral.slate,
    Map<NixtColorRole, NixtColorScale>? roles,
  }) {
    final n = neutral.scale;
    final scales = _resolveRoleScales(roles);
    return NixtColors(
      brightness: Brightness.light,
      neutral: neutral,
      roleScales: scales,
      // Brand/status — mid shade (500) in light.
      primary: scales[NixtColorRole.primary]!.s500,
      secondary: scales[NixtColorRole.secondary]!.s500,
      success: scales[NixtColorRole.success]!.s500,
      info: scales[NixtColorRole.info]!.s500,
      warning: scales[NixtColorRole.warning]!.s500,
      error: scales[NixtColorRole.error]!.s500,
      textDimmed: n.s400,
      textMuted: n.s500,
      textToned: n.s600,
      text: n.s700,
      textHighlighted: n.s900,
      textInverted: NixtPalette.white,
      bg: NixtPalette.white,
      bgMuted: n.s50,
      bgElevated: n.s100,
      bgAccented: n.s200,
      bgInverted: n.s900,
      border: n.s200,
      borderMuted: n.s200,
      borderAccented: n.s300,
      borderInverted: n.s900,
    );
  }

  /// Dark-mode resolution for [neutral]. Brand colors lighten one step (400);
  /// surfaces/text invert. [roles] overrides role scales (DS color config).
  factory NixtColors.dark({
    NixtNeutral neutral = NixtNeutral.slate,
    Map<NixtColorRole, NixtColorScale>? roles,
  }) {
    final n = neutral.scale;
    final scales = _resolveRoleScales(roles);
    return NixtColors(
      brightness: Brightness.dark,
      neutral: neutral,
      roleScales: scales,
      primary: scales[NixtColorRole.primary]!.s400,
      secondary: scales[NixtColorRole.secondary]!.s400,
      success: scales[NixtColorRole.success]!.s400,
      info: scales[NixtColorRole.info]!.s400,
      warning: scales[NixtColorRole.warning]!.s400,
      error: scales[NixtColorRole.error]!.s400,
      textDimmed: n.s500,
      textMuted: n.s400,
      textToned: n.s300,
      text: n.s200,
      textHighlighted: NixtPalette.white,
      textInverted: n.s900,
      bg: n.s900,
      bgMuted: n.s800,
      bgElevated: n.s800,
      bgAccented: n.s700,
      bgInverted: NixtPalette.white,
      border: n.s800,
      borderMuted: n.s700,
      borderAccented: n.s700,
      borderInverted: NixtPalette.white,
    );
  }

  /// Fills in default scales for any role not overridden in [roles].
  static Map<NixtColorRole, NixtColorScale> _resolveRoleScales(
    Map<NixtColorRole, NixtColorScale>? roles,
  ) =>
      {
        for (final r in NixtColorRole.values)
          if (r != NixtColorRole.neutral) r: roles?[r] ?? NixtRoleScales.of(r),
      };

  /// Linearly interpolates every channel (drives smooth theme transitions).
  static NixtColors lerp(NixtColors a, NixtColors b, double t) {
    Color c(Color x, Color y) => Color.lerp(x, y, t)!;
    return NixtColors(
      brightness: t < 0.5 ? a.brightness : b.brightness,
      neutral: t < 0.5 ? a.neutral : b.neutral,
      roleScales: t < 0.5 ? a.roleScales : b.roleScales,
      primary: c(a.primary, b.primary),
      secondary: c(a.secondary, b.secondary),
      success: c(a.success, b.success),
      info: c(a.info, b.info),
      warning: c(a.warning, b.warning),
      error: c(a.error, b.error),
      textDimmed: c(a.textDimmed, b.textDimmed),
      textMuted: c(a.textMuted, b.textMuted),
      textToned: c(a.textToned, b.textToned),
      text: c(a.text, b.text),
      textHighlighted: c(a.textHighlighted, b.textHighlighted),
      textInverted: c(a.textInverted, b.textInverted),
      bg: c(a.bg, b.bg),
      bgMuted: c(a.bgMuted, b.bgMuted),
      bgElevated: c(a.bgElevated, b.bgElevated),
      bgAccented: c(a.bgAccented, b.bgAccented),
      bgInverted: c(a.bgInverted, b.bgInverted),
      border: c(a.border, b.border),
      borderMuted: c(a.borderMuted, b.borderMuted),
      borderAccented: c(a.borderAccented, b.borderAccented),
      borderInverted: c(a.borderInverted, b.borderInverted),
    );
  }
}
