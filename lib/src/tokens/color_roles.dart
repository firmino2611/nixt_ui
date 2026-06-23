import 'palette.dart';

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
