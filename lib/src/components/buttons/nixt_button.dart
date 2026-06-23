import 'package:flutter/material.dart';

import '../../foundations/focus_ring.dart';
import '../../foundations/press_scale.dart';
import '../../theme/component_themes/nixt_button_theme.dart';
import '../../theme/nixt_theme.dart';
import '../../tokens/color_roles.dart';
import '../../tokens/radius_tokens.dart';
import '../../tokens/typography_tokens.dart';
import '../../theme/variant_resolver.dart';
import '../icon/nixt_icon.dart';

/// Button size — `md` and up meet the 44px touch target.
enum NixtButtonSize {
  /// 28px min height.
  xs,

  /// 34px min height.
  sm,

  /// 42px min height (default).
  md,

  /// 48px min height.
  lg,

  /// 56px min height.
  xl,
}

/// Resolved per-size metrics, mirroring the DS `SIZES` table in `Button.jsx`.
@immutable
class _SizeSpec {
  const _SizeSpec({
    required this.fontSize,
    required this.padY,
    required this.padX,
    required this.gap,
    required this.icon,
    required this.minH,
    required this.radius,
  });

  final double fontSize;
  final double padY;
  final double padX;
  final double gap;
  final double icon;
  final double minH;
  final double Function(NixtRadius) radius;

  static _SizeSpec of(NixtButtonSize s) {
    switch (s) {
      case NixtButtonSize.xs:
        return _SizeSpec(
            fontSize: NixtTypography.textXs,
            padY: 4,
            padX: 8,
            gap: 4,
            icon: 14,
            minH: 28,
            radius: (r) => r.sm);
      case NixtButtonSize.sm:
        return _SizeSpec(
            fontSize: NixtTypography.textSm,
            padY: 6,
            padX: 12,
            gap: 6,
            icon: 16,
            minH: 34,
            radius: (r) => r.md);
      case NixtButtonSize.md:
        return _SizeSpec(
            fontSize: NixtTypography.textSm,
            padY: 9,
            padX: 16,
            gap: 8,
            icon: 18,
            minH: 42,
            radius: (r) => r.md);
      case NixtButtonSize.lg:
        return _SizeSpec(
            fontSize: NixtTypography.textBase,
            padY: 11,
            padX: 20,
            gap: 8,
            icon: 20,
            minH: 48,
            radius: (r) => r.lg);
      case NixtButtonSize.xl:
        return _SizeSpec(
            fontSize: NixtTypography.textBase,
            padY: 14,
            padX: 24,
            gap: 10,
            icon: 22,
            minH: 56,
            radius: (r) => r.lg);
    }
  }
}

/// The primary action control — 7 colors × 6 variants × 5 sizes, light/dark
/// aware, a faithful port of the design system's `Button`.
///
/// Purely visual: it owns no navigation or app state. Customize globally via
/// `NixtTheme(button: NixtButtonTheme(...))`, or per-instance via [theme].
///
/// ```dart
/// NixtButton(
///   label: 'Continue',
///   icon: NixtIcons.arrowRight,
///   block: true,
///   onPressed: () {},
/// );
/// ```
class NixtButton extends StatefulWidget {
  /// Creates a button. Provide [label] or [child].
  const NixtButton({
    this.label,
    this.child,
    this.onPressed,
    this.color = NixtColorRole.primary,
    this.variant = NixtVariant.solid,
    this.size = NixtButtonSize.md,
    this.icon,
    this.trailingIcon,
    this.block = false,
    this.square = false,
    this.loading = false,
    this.disabled = false,
    this.theme,
    super.key,
  });

  /// Button text. Alternatively pass [child].
  final String? label;

  /// Custom content (overrides [label]).
  final Widget? child;

  /// Tap callback. A `null` callback renders the button disabled.
  final VoidCallback? onPressed;

  /// Semantic color. Defaults to `primary`.
  final NixtColorRole color;

  /// Visual style. Defaults to `solid`.
  final NixtVariant variant;

  /// Size — `md`+ meets the 44px touch target. Defaults to `md`.
  final NixtButtonSize size;

  /// Leading icon.
  final IconData? icon;

  /// Trailing icon (ignored while loading or icon-only).
  final IconData? trailingIcon;

  /// Stretch to full container width — the default for primary mobile CTAs.
  final bool block;

  /// Square icon-only button.
  final bool square;

  /// Show a spinner and disable.
  final bool loading;

  /// Force the disabled state regardless of [onPressed].
  final bool disabled;

  /// Per-instance overrides, merged over the global `NixtButtonTheme`.
  final NixtButtonTheme? theme;

  @override
  State<NixtButton> createState() => _NixtButtonState();
}

class _NixtButtonState extends State<NixtButton> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final t = NixtTheme.of(context);
    final btnTheme = t.button.merge(widget.theme);

    final color = widget.theme?.defaultColor ?? widget.color;
    final variant = widget.theme?.defaultVariant ?? widget.variant;
    final isLink = variant == NixtVariant.link;
    final isDisabled =
        widget.disabled || widget.loading || widget.onPressed == null;

    final spec = _SizeSpec.of(widget.size);
    final vc = NixtVariantResolver.resolve(color, variant, t.colors);
    final content =
        widget.child ?? (widget.label != null ? Text(widget.label!) : null);
    final iconOnly = widget.square ||
        (content == null && (widget.icon != null || widget.loading));

    final minH =
        (widget.size == NixtButtonSize.md && btnTheme.minHeightMd != null)
            ? btnTheme.minHeightMd!
            : spec.minH;
    final weight = btnTheme.fontWeight ?? NixtTypography.weightSemibold;

    final labelStyle = TextStyle(
      fontFamily: NixtTypography.fontSans,
      fontWeight: weight,
      fontSize: spec.fontSize,
      height: 1,
      color: vc.foreground,
      decoration: isLink ? TextDecoration.underline : TextDecoration.none,
    );

    // ---- inner row ----
    final children = <Widget>[];
    if (widget.loading) {
      children.add(SizedBox(
        width: spec.icon,
        height: spec.icon,
        child: CircularProgressIndicator(strokeWidth: 2, color: vc.foreground),
      ));
    } else if (widget.icon != null) {
      children
          .add(NixtIcon(widget.icon!, size: spec.icon, color: vc.foreground));
    }
    if (!iconOnly && content != null) {
      children.add(Flexible(
          child: DefaultTextStyle.merge(style: labelStyle, child: content)));
    }
    if (!iconOnly && widget.trailingIcon != null && !widget.loading) {
      children.add(NixtIcon(widget.trailingIcon!,
          size: spec.icon, color: vc.foreground));
    }

    final row = Row(
      mainAxisSize: widget.block ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) SizedBox(width: spec.gap),
          children[i],
        ],
      ],
    );

    final radius = isLink ? 0.0 : spec.radius(t.radius);
    final padding = isLink
        ? EdgeInsets.zero
        : iconOnly
            ? EdgeInsets.all(spec.padY)
            : EdgeInsets.symmetric(vertical: spec.padY, horizontal: spec.padX);

    Widget surface = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      constraints: BoxConstraints(
        minHeight: isLink ? 0 : minH,
        minWidth: iconOnly ? minH : 0,
      ),
      width: widget.block ? double.infinity : (iconOnly ? minH : null),
      padding: padding,
      decoration: BoxDecoration(
        color: vc.background,
        borderRadius: BorderRadius.circular(radius),
        border:
            vc.border != null ? Border.all(color: vc.border!, width: 1) : null,
        boxShadow: _focused && !isLink
            ? NixtFocusRing.shadows(
                background: t.colors.bg, accent: t.colors.primary)
            : null,
      ),
      child: row,
    );

    surface = Opacity(opacity: isDisabled ? 0.45 : 1, child: surface);

    return Focus(
      canRequestFocus: !isDisabled,
      onFocusChange: (f) => setState(() => _focused = f),
      child: NixtPressScale(
        enabled: !isDisabled,
        onTap: isDisabled ? null : widget.onPressed,
        child: surface,
      ),
    );
  }
}
