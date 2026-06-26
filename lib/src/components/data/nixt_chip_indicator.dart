import 'package:flutter/widgets.dart';

import '../../foundations/color_util.dart';
import '../../theme/nixt_theme.dart';
import '../../tokens/color_roles.dart';
import '../../tokens/typography_tokens.dart';

/// Corner an indicator [NixtChipIndicator] anchors to.
enum NixtChipPosition {
  /// Top-right (default).
  topRight,

  /// Top-left.
  topLeft,

  /// Bottom-right.
  bottomRight,

  /// Bottom-left.
  bottomLeft,
}

/// Indicator size — controls the dot diameter and count text.
enum NixtChipIndicatorSize {
  /// Smallest — 10px dot.
  sm,

  /// Default — 14px dot.
  md,

  /// Largest — 18px dot.
  lg,
}

class _IndicatorMetrics {
  const _IndicatorMetrics(this.diameter, this.fontSize, this.padX);
  final double diameter;
  final double fontSize;
  final double padX;

  static _IndicatorMetrics of(NixtChipIndicatorSize s) => switch (s) {
        NixtChipIndicatorSize.sm => const _IndicatorMetrics(10, NixtTypography.text2xs, 4),
        NixtChipIndicatorSize.md => const _IndicatorMetrics(14, NixtTypography.text2xs, 5),
        NixtChipIndicatorSize.lg => const _IndicatorMetrics(18, NixtTypography.textXs, 6),
      };
}

/// A small indicator of a numeric value or a state, overlaid on a child — the
/// mobile port of Nuxt UI's `Chip`. Use it for unread counts, online dots, and
/// other status overlays on avatars, icons, or buttons.
///
/// With no [text] it renders a plain status dot; with [text] it grows into a
/// count pill (numbers over [max] show as `max+`). A hairline ring in the page
/// background keeps it legible over busy content. Set [inset] for circular
/// children (avatars) so the dot hugs the edge instead of floating off the
/// corner, [show] to toggle visibility, and [standalone] to render the
/// indicator on its own (no wrapped child).
///
/// ```dart
/// NixtChipIndicator(child: NixtAvatar(...));                       // online dot
/// NixtChipIndicator(text: '3', color: NixtColorRole.error, child: bellIcon);
/// NixtChipIndicator(text: '128', max: 99, inset: true, child: avatar);
/// NixtChipIndicator(standalone: true, color: NixtColorRole.success);
/// ```
class NixtChipIndicator extends StatelessWidget {
  /// Creates an indicator chip.
  const NixtChipIndicator({
    this.child,
    this.text,
    this.color = NixtColorRole.primary,
    this.size = NixtChipIndicatorSize.md,
    this.position = NixtChipPosition.topRight,
    this.max,
    this.inset = false,
    this.standalone = false,
    this.show = true,
    super.key,
  });

  /// The element receiving the indicator. Required unless [standalone].
  final Widget? child;

  /// Count or status text. Null renders a plain dot.
  final String? text;

  /// Color role. Defaults to `primary`.
  final NixtColorRole color;

  /// Size. Defaults to `md`.
  final NixtChipIndicatorSize size;

  /// Anchor corner. Defaults to `top-right`.
  final NixtChipPosition position;

  /// Clamp numeric [text]: values above [max] render as `max+` (e.g. `99+`).
  final int? max;

  /// Pull the indicator inward to hug a rounded/circular child. Defaults false.
  final bool inset;

  /// Render the indicator alone, without a wrapped child. Defaults false.
  final bool standalone;

  /// Whether the indicator is visible. Defaults true.
  final bool show;

  String? get _displayText {
    final raw = text;
    if (raw == null) return null;
    final n = max != null ? int.tryParse(raw) : null;
    if (n != null && max != null && n > max!) return '$max+';
    return raw;
  }

  @override
  Widget build(BuildContext context) {
    final t = NixtTheme.of(context);
    final c = t.colors;
    final m = _IndicatorMetrics.of(size);
    final accent = color == NixtColorRole.neutral ? c.textHighlighted : c.role(color);
    final fg = nixtOnColor(accent);
    final label = _displayText;

    final dot = AnimatedScale(
      scale: show ? 1 : 0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOutBack,
      child: Container(
        constraints: BoxConstraints(minWidth: m.diameter, minHeight: m.diameter),
        padding: label != null ? EdgeInsets.symmetric(horizontal: m.padX) : EdgeInsets.zero,
        decoration: BoxDecoration(
          color: accent,
          borderRadius: BorderRadius.circular(m.diameter),
          // Hairline ring in the page background to separate from busy content.
          border: Border.all(color: c.bg, width: 1.5),
        ),
        alignment: Alignment.center,
        child: label == null
            ? null
            : Text(
                label,
                style: TextStyle(
                  fontFamily: NixtTypography.fontSans,
                  fontSize: m.fontSize,
                  fontWeight: FontWeight.w700,
                  height: 1,
                  color: fg,
                ),
              ),
      ),
    );

    if (standalone || child == null) return dot;

    // Negative edge floats the dot half-outside the child's corner; inset pulls
    // it back in so it sits on the rim of a circular child.
    final edge = inset ? m.diameter * 0.15 : -m.diameter / 2;
    final isTop = position == NixtChipPosition.topRight || position == NixtChipPosition.topLeft;
    final isLeft = position == NixtChipPosition.topLeft || position == NixtChipPosition.bottomLeft;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child!,
        Positioned(
          top: isTop ? edge : null,
          bottom: isTop ? null : edge,
          left: isLeft ? edge : null,
          right: isLeft ? null : edge,
          child: dot,
        ),
      ],
    );
  }
}
