import 'package:flutter/widgets.dart';
import 'package:nixt_ui/nixt_ui.dart';

/// App-wide theme controls (brightness + neutral palette), exposed to every
/// screen via [InheritedWidget] so any screen can toggle them.
class GalleryControls extends InheritedWidget {
  /// Creates the controls scope.
  const GalleryControls({
    required this.isDark,
    required this.neutral,
    required this.roles,
    required this.radiusBase,
    required this.toggleBrightness,
    required this.setNeutral,
    required this.setRole,
    required this.setRadius,
    required this.resetTheme,
    required super.child,
    super.key,
  });

  /// Whether dark mode is active.
  final bool isDark;

  /// The active neutral palette.
  final NixtNeutral neutral;

  /// Global brand/status color overrides (the DS color config).
  final Map<NixtColorRole, NixtColorScale> roles;

  /// The active radius base (drives the whole rounding scale).
  final double radiusBase;

  /// Flips light/dark.
  final VoidCallback toggleBrightness;

  /// Switches the neutral palette.
  final ValueChanged<NixtNeutral> setNeutral;

  /// Sets (or clears, when [seed] is null) a global role color from a seed.
  final void Function(NixtColorRole role, Color? seed) setRole;

  /// Sets the radius base.
  final ValueChanged<double> setRadius;

  /// Clears all overrides back to the design-system defaults.
  final VoidCallback resetTheme;

  /// Reads the nearest controls scope.
  static GalleryControls of(BuildContext context) {
    final c = context.dependOnInheritedWidgetOfExactType<GalleryControls>();
    assert(c != null, 'No GalleryControls in scope.');
    return c!;
  }

  @override
  bool updateShouldNotify(GalleryControls old) =>
      old.isDark != isDark ||
      old.neutral != neutral ||
      old.roles != roles ||
      old.radiusBase != radiusBase;
}
