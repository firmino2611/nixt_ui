import 'package:flutter/material.dart';

import '../tokens/color_roles.dart';
import '../tokens/palette.dart';
import '../tokens/radius_tokens.dart';
import '../tokens/shadow_tokens.dart';
import 'component_themes/nixt_button_theme.dart';
import 'neutral_palette.dart';
import 'nixt_colors.dart';

/// The root design-system theme, exposed as a Flutter [ThemeExtension].
///
/// Attach it to a [MaterialApp] via `theme.extensions`, then read it anywhere
/// with [NixtTheme.of]. Carries resolved colors, radius, shadows, and per-
/// component override themes. No external dependencies are required.
///
/// ```dart
/// MaterialApp(
///   theme: ThemeData(extensions: [NixtTheme.light()]),
///   darkTheme: ThemeData(extensions: [NixtTheme.dark()]),
/// );
/// ```
@immutable
class NixtTheme extends ThemeExtension<NixtTheme> {
  /// Creates a theme from fully-resolved parts. Prefer [NixtTheme.light] /
  /// [NixtTheme.dark].
  const NixtTheme({
    required this.colors,
    required this.radius,
    required this.shadows,
    this.button = const NixtButtonTheme(),
  });

  /// Resolved semantic colors for the current brightness + neutral.
  final NixtColors colors;

  /// The active radius scale.
  final NixtRadius radius;

  /// The active elevation shadows.
  final NixtShadows shadows;

  /// Global overrides for `NixtButton`.
  final NixtButtonTheme button;

  /// Light theme. Customize the [neutral] palette, [radius] base, and brand
  /// roles. Set a role from one brand color via [palette] (its scale is
  /// auto-generated around shade `500` — see [NixtRoleColor]) and/or supply a
  /// fully hand-authored scale via [roles] ([roles] wins on conflict).
  ///
  /// ```dart
  /// NixtTheme.light(palette: {
  ///   NixtColorRole.primary: NixtRoleColor(Color(0xFF7C3AED)),
  /// });
  /// ```
  factory NixtTheme.light({
    NixtNeutral neutral = NixtNeutral.slate,
    NixtRadius radius = const NixtRadius(),
    NixtButtonTheme button = const NixtButtonTheme(),
    Map<NixtColorRole, NixtColorScale>? roles,
    Map<NixtColorRole, NixtRoleColor>? palette,
  }) =>
      NixtTheme(
        colors: NixtColors.light(neutral: neutral, roles: roles, palette: palette),
        radius: radius,
        shadows: NixtShadows.light(),
        button: button,
      );

  /// Dark theme. Customize the [neutral] palette, [radius] base, and brand
  /// roles via [palette] (seed colors, scales auto-generated) and/or [roles]
  /// (full scales); [roles] wins on conflict.
  factory NixtTheme.dark({
    NixtNeutral neutral = NixtNeutral.slate,
    NixtRadius radius = const NixtRadius(),
    NixtButtonTheme button = const NixtButtonTheme(),
    Map<NixtColorRole, NixtColorScale>? roles,
    Map<NixtColorRole, NixtRoleColor>? palette,
  }) =>
      NixtTheme(
        colors: NixtColors.dark(neutral: neutral, roles: roles, palette: palette),
        radius: radius,
        shadows: NixtShadows.dark(),
        button: button,
      );

  /// Reads the nearest [NixtTheme]. Throws if none is registered — register one
  /// in `ThemeData.extensions`.
  static NixtTheme of(BuildContext context) {
    final ext = Theme.of(context).extension<NixtTheme>();
    assert(ext != null, 'No NixtTheme found. Add it to ThemeData.extensions.');
    return ext!;
  }

  /// Reads the nearest [NixtTheme], or `null` if none is registered.
  static NixtTheme? maybeOf(BuildContext context) =>
      Theme.of(context).extension<NixtTheme>();

  @override
  NixtTheme copyWith({
    NixtColors? colors,
    NixtRadius? radius,
    NixtShadows? shadows,
    NixtButtonTheme? button,
  }) =>
      NixtTheme(
        colors: colors ?? this.colors,
        radius: radius ?? this.radius,
        shadows: shadows ?? this.shadows,
        button: button ?? this.button,
      );

  @override
  NixtTheme lerp(ThemeExtension<NixtTheme>? other, double t) {
    if (other is! NixtTheme) return this;
    return NixtTheme(
      colors: NixtColors.lerp(colors, other.colors, t),
      radius: NixtRadius.lerp(radius, other.radius, t),
      // Shadows snap at the midpoint (BoxShadow lists are not lerped here).
      shadows: t < 0.5 ? shadows : other.shadows,
      button: NixtButtonTheme.lerp(button, other.button, t),
    );
  }
}

/// Convenience accessor: `context.nixt` -> the current [NixtTheme].
extension NixtThemeContext on BuildContext {
  /// The nearest [NixtTheme].
  NixtTheme get nixt => NixtTheme.of(this);
}
