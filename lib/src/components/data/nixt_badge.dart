import 'package:flutter/widgets.dart';

import '../../theme/nixt_theme.dart';
import '../../theme/variant_resolver.dart';
import '../../tokens/color_roles.dart';
import '../../tokens/typography_tokens.dart';
import '../icon/nixt_icon.dart';

/// Badge size — controls font, padding, and icon metrics.
enum NixtBadgeSize {
  /// Smallest — 11px text.
  sm,

  /// Default — 12px text.
  md,

  /// Largest — 14px text.
  lg,
}

class _BadgeMetrics {
  const _BadgeMetrics(this.fontSize, this.padY, this.padX, this.icon, this.gap);
  final double fontSize;
  final double padY;
  final double padX;
  final double icon;
  final double gap;

  static _BadgeMetrics of(NixtBadgeSize size) => switch (size) {
        NixtBadgeSize.sm =>
          const _BadgeMetrics(NixtTypography.text2xs, 2, 7, 12, 3),
        NixtBadgeSize.md =>
          const _BadgeMetrics(NixtTypography.textXs, 3, 9, 14, 4),
        NixtBadgeSize.lg =>
          const _BadgeMetrics(NixtTypography.textSm, 4, 11, 16, 5),
      };
}

/// Small status / label pill. Reuses the [NixtButton] variant matrix, so a
/// badge reads as a quiet, non-interactive sibling of a button.
///
/// Supports the four static variants — `solid`, `outline`, `soft`, `subtle`
/// (ghost/link are button-only). Add a leading [dot] for status pills or an
/// [icon] for labelled tags; [pill] makes it fully rounded.
///
/// ```dart
/// NixtBadge(label: 'New');                                   // solid primary
/// NixtBadge(label: 'Active', color: NixtColorRole.success, dot: true);
/// NixtBadge(label: 'Beta', variant: NixtVariant.soft, pill: true);
/// ```
class NixtBadge extends StatelessWidget {
  /// Creates a badge.
  const NixtBadge({
    this.label,
    this.child,
    this.color = NixtColorRole.primary,
    this.variant = NixtVariant.solid,
    this.size = NixtBadgeSize.md,
    this.icon,
    this.dot = false,
    this.pill = false,
    super.key,
  });

  /// Text label. Ignored when [child] is given.
  final String? label;

  /// Custom content (overrides [label]).
  final Widget? child;

  /// Color role. Defaults to `primary`.
  final NixtColorRole color;

  /// Visual variant — `solid` / `outline` / `soft` / `subtle`. Defaults to
  /// `solid`. Ghost and link fall back to `solid`.
  final NixtVariant variant;

  /// Size. Defaults to `md`.
  final NixtBadgeSize size;

  /// Optional leading icon.
  final IconData? icon;

  /// Show a leading status dot. Defaults to false.
  final bool dot;

  /// Fully rounded. Defaults to false.
  final bool pill;

  @override
  Widget build(BuildContext context) {
    final t = NixtTheme.of(context);
    final c = t.colors;
    final m = _BadgeMetrics.of(size);

    // Badge only supports the four static variants.
    final v = switch (variant) {
      NixtVariant.solid ||
      NixtVariant.outline ||
      NixtVariant.soft ||
      NixtVariant.subtle =>
        variant,
      NixtVariant.ghost || NixtVariant.link => NixtVariant.solid,
    };
    final paint = NixtVariantResolver.resolve(color, v, c);

    final dotColor = v == NixtVariant.solid
        ? paint.foreground
        : color == NixtColorRole.neutral
            ? c.textMuted
            : c.role(color);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: m.padX, vertical: m.padY),
      decoration: BoxDecoration(
        color: paint.background,
        borderRadius:
            pill ? BorderRadius.circular(t.radius.full) : t.radius.brSm,
        border: paint.border == null
            ? null
            : Border.all(color: paint.border!, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            Container(
              width: 6,
              height: 6,
              decoration:
                  BoxDecoration(color: dotColor, shape: BoxShape.circle),
            ),
            SizedBox(width: m.gap),
          ],
          if (icon != null) ...[
            NixtIcon(icon!, size: m.icon, color: paint.foreground),
            SizedBox(width: m.gap),
          ],
          DefaultTextStyle(
            style: TextStyle(
              fontFamily: NixtTypography.fontSans,
              fontSize: m.fontSize,
              fontWeight: FontWeight.w600,
              height: 1,
              color: paint.foreground,
            ),
            child: child ?? Text(label ?? ''),
          ),
        ],
      ),
    );
  }
}
