import 'package:flutter/widgets.dart';

import '../../foundations/press_scale.dart';
import '../../theme/nixt_theme.dart';
import '../../theme/variant_resolver.dart';
import '../../tokens/color_roles.dart';
import '../../tokens/typography_tokens.dart';
import '../icon/nixt_icon.dart';

/// Floating action button size — diameters 44 / 56 / 64.
enum NixtFabSize {
  /// 44px (mini).
  sm,

  /// 56px (default).
  md,

  /// 64px.
  lg,
}

/// A Material-style floating action button — round by default, or an extended
/// (pill) FAB when [label] is set. Always solid-filled with a resting shadow.
///
/// Position it yourself (e.g. inside a [Stack], bottom-right). It owns no
/// navigation or state.
///
/// ```dart
/// NixtFab(icon: NixtIcons.plus, onPressed: () {});
/// NixtFab(icon: NixtIcons.pencil, label: 'Compose', onPressed: () {});
/// ```
class NixtFab extends StatelessWidget {
  /// Creates a floating action button.
  const NixtFab({
    required this.icon,
    this.onPressed,
    this.label,
    this.color = NixtColorRole.primary,
    this.size = NixtFabSize.md,
    super.key,
  });

  /// The glyph to render.
  final IconData icon;

  /// Tap callback.
  final VoidCallback? onPressed;

  /// When set, renders an extended pill FAB with this text after the icon.
  final String? label;

  /// Semantic color. Defaults to `primary`.
  final NixtColorRole color;

  /// Diameter preset. Defaults to `md`.
  final NixtFabSize size;

  ({double d, double icon}) get _metrics => switch (size) {
        NixtFabSize.sm => (d: 44, icon: 20),
        NixtFabSize.md => (d: 56, icon: 24),
        NixtFabSize.lg => (d: 64, icon: 28),
      };

  @override
  Widget build(BuildContext context) {
    final t = NixtTheme.of(context);
    final m = _metrics;
    final extended = label != null;
    // Solid resolution matches the DS FAB rules exactly (neutral -> inverted
    // surface, warning -> dark foreground, otherwise role color on white).
    final vc = NixtVariantResolver.resolve(color, NixtVariant.solid, t.colors);

    return NixtPressScale(
      scale: 0.94,
      onTap: onPressed,
      child: Container(
        height: m.d,
        width: extended ? null : m.d,
        padding: extended
            ? const EdgeInsets.symmetric(horizontal: 20)
            : EdgeInsets.zero,
        decoration: BoxDecoration(
          color: vc.background,
          borderRadius:
              BorderRadius.circular(extended ? t.radius.full : t.radius.xl),
          boxShadow: t.shadows.lg,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NixtIcon(icon, size: m.icon, color: vc.foreground),
            if (extended) ...[
              const SizedBox(width: 8),
              Text(
                label!,
                style: TextStyle(
                  fontFamily: NixtTypography.fontSans,
                  fontWeight: NixtTypography.weightSemibold,
                  fontSize: NixtTypography.textBase,
                  height: 1,
                  color: vc.foreground,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
