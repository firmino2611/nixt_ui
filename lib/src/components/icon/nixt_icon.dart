import 'package:flutter/widgets.dart';

import '../../theme/nixt_theme.dart';

/// A themeable inline icon from the bundled Lucide set.
///
/// Thin wrapper over [Icon] that applies the design system's defaults: 20px
/// size and the current body-text color when none is given. Pass any
/// [IconData] from `NixtIcons`.
///
/// ```dart
/// NixtIcon(NixtIcons.home);
/// NixtIcon(NixtIcons.heart, size: 24, color: context.nixt.colors.error);
/// ```
class NixtIcon extends StatelessWidget {
  /// Creates an icon.
  const NixtIcon(
    this.icon, {
    this.size = 20,
    this.color,
    this.semanticLabel,
    super.key,
  });

  /// The glyph to render (e.g. `NixtIcons.home`).
  final IconData icon;

  /// Pixel size applied to width and height. Defaults to 20.
  final double size;

  /// Stroke/fill color. Defaults to the theme's body text color.
  final Color? color;

  /// Optional semantic label for accessibility.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final resolved = color ?? NixtTheme.maybeOf(context)?.colors.text;
    return Icon(
      icon,
      size: size,
      color: resolved,
      semanticLabel: semanticLabel,
    );
  }
}
