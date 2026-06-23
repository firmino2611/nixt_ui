import 'package:flutter/material.dart';

import '../../theme/component_themes/nixt_button_theme.dart';
import '../../theme/variant_resolver.dart';
import '../../tokens/color_roles.dart';
import 'nixt_button.dart';

/// A square, icon-only button for app bars, list rows, and toolbars.
///
/// A thin specialization of [NixtButton] (`square: true`) with toolbar-friendly
/// defaults (neutral / ghost). Always pass [label] — it is exposed to assistive
/// tech and as a tooltip, never rendered as text.
///
/// ```dart
/// NixtIconButton(
///   icon: NixtIcons.moreVertical,
///   label: 'More options',
///   onPressed: () {},
/// );
/// ```
class NixtIconButton extends StatelessWidget {
  /// Creates an icon button.
  const NixtIconButton({
    required this.icon,
    required this.label,
    this.onPressed,
    this.color = NixtColorRole.neutral,
    this.variant = NixtVariant.ghost,
    this.size = NixtButtonSize.md,
    this.loading = false,
    this.disabled = false,
    this.theme,
    super.key,
  });

  /// The glyph to render.
  final IconData icon;

  /// Accessible label — used as semantics label and tooltip, not shown.
  final String label;

  /// Tap callback. A `null` callback renders the button disabled.
  final VoidCallback? onPressed;

  /// Semantic color. Defaults to `neutral`.
  final NixtColorRole color;

  /// Visual style. Defaults to `ghost`.
  final NixtVariant variant;

  /// Size. Defaults to `md`.
  final NixtButtonSize size;

  /// Show a spinner and disable.
  final bool loading;

  /// Force the disabled state.
  final bool disabled;

  /// Per-instance theme overrides.
  final NixtButtonTheme? theme;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Tooltip(
        message: label,
        child: NixtButton(
          icon: icon,
          square: true,
          color: color,
          variant: variant,
          size: size,
          loading: loading,
          disabled: disabled,
          theme: theme,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
