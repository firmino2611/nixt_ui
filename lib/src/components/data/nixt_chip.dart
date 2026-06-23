import 'package:flutter/widgets.dart';

import '../../foundations/color_util.dart';
import '../../foundations/press_scale.dart';
import '../../theme/nixt_theme.dart';
import '../../tokens/color_roles.dart';
import '../../tokens/typography_tokens.dart';
import '../icon/nixt_icon.dart';

/// Chip size — controls height, padding, font, and icon metrics.
enum NixtChipSize {
  /// Smallest — 30px tall.
  sm,

  /// Default — 36px tall.
  md,

  /// Largest — 42px tall.
  lg,
}

class _ChipMetrics {
  const _ChipMetrics(this.height, this.padX, this.fontSize, this.icon);
  final double height;
  final double padX;
  final double fontSize;
  final double icon;

  static _ChipMetrics of(NixtChipSize size) => switch (size) {
        NixtChipSize.sm =>
          const _ChipMetrics(30, 12, NixtTypography.textXs, 14),
        NixtChipSize.md =>
          const _ChipMetrics(36, 14, NixtTypography.textSm, 16),
        NixtChipSize.lg =>
          const _ChipMetrics(42, 18, NixtTypography.textBase, 18),
      };
}

/// Selectable filter chip — the toggling pill used in filter bars and category
/// rails. Controlled via [selected] + [onTap]; the parent owns the state.
///
/// Selected paints a tinted fill + accented border in the role color; idle is a
/// neutral outline. Tapping gives the standard press feedback.
///
/// ```dart
/// NixtChip(label: 'All', selected: tab == 0, onTap: () => setState(() => tab = 0));
/// NixtChip(label: 'Design', icon: NixtIcons.palette, selected: on, onTap: toggle);
/// ```
class NixtChip extends StatelessWidget {
  /// Creates a chip.
  const NixtChip({
    this.label,
    this.child,
    this.selected = false,
    this.onTap,
    this.color = NixtColorRole.primary,
    this.size = NixtChipSize.md,
    this.icon,
    super.key,
  });

  /// Text label. Ignored when [child] is given.
  final String? label;

  /// Custom content (overrides [label]).
  final Widget? child;

  /// Selected (active) state. Defaults to false.
  final bool selected;

  /// Tap callback.
  final VoidCallback? onTap;

  /// Accent color role when selected. Defaults to `primary`.
  final NixtColorRole color;

  /// Size. Defaults to `md`.
  final NixtChipSize size;

  /// Optional leading icon.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final t = NixtTheme.of(context);
    final c = t.colors;
    final m = _ChipMetrics.of(size);
    final accent =
        color == NixtColorRole.neutral ? c.textHighlighted : c.role(color);

    final background = selected ? nixtOpacity(accent, 0.14) : c.bg;
    final foreground = selected ? accent : c.textToned;
    final border = selected ? nixtOpacity(accent, 0.40) : c.borderAccented;

    return NixtPressScale(
      scale: 0.96,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        height: m.height,
        padding: EdgeInsets.symmetric(horizontal: m.padX),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(t.radius.full),
          border: Border.all(color: border, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              NixtIcon(icon!, size: m.icon, color: foreground),
              const SizedBox(width: 6),
            ],
            DefaultTextStyle(
              style: TextStyle(
                fontFamily: NixtTypography.fontSans,
                fontSize: m.fontSize,
                fontWeight: FontWeight.w500,
                color: foreground,
              ),
              child: child ?? Text(label ?? ''),
            ),
          ],
        ),
      ),
    );
  }
}
