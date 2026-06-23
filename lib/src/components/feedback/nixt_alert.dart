import 'package:flutter/widgets.dart';

import '../../foundations/color_util.dart';
import '../../foundations/nixt_icons.dart';
import '../../theme/nixt_theme.dart';
import '../../theme/variant_resolver.dart';
import '../../tokens/color_roles.dart';
import '../../tokens/spacing_tokens.dart';
import '../../tokens/typography_tokens.dart';
import '../icon/nixt_icon.dart';

/// Inline banner for status messages, tips, and errors. Pairs a leading status
/// icon with a title/description and optional [actions] row and [onClose]
/// button. [variant] reuses the shared paint matrix; `soft` is the default.
///
/// Pass [icon] to override the per-color default, or `showIcon: false` to drop
/// it entirely.
///
/// ```dart
/// NixtAlert(title: 'Saved', color: NixtColorRole.success, description: 'All set.');
/// NixtAlert(title: 'Heads up', variant: NixtVariant.subtle, onClose: dismiss);
/// ```
class NixtAlert extends StatelessWidget {
  /// Creates an alert.
  const NixtAlert({
    this.title,
    this.description,
    this.color = NixtColorRole.primary,
    this.variant = NixtVariant.soft,
    this.icon,
    this.showIcon = true,
    this.actions,
    this.onClose,
    super.key,
  });

  /// Bold leading line.
  final String? title;

  /// Supporting body text.
  final String? description;

  /// Color role. Defaults to `primary`.
  final NixtColorRole color;

  /// Visual variant. Defaults to `soft`.
  final NixtVariant variant;

  /// Leading icon override. Null uses the per-color default.
  final IconData? icon;

  /// Show the leading icon. Defaults to true.
  final bool showIcon;

  /// Trailing action buttons (e.g. a row of [NixtButton]s).
  final Widget? actions;

  /// Dismiss callback — renders a trailing × button when set.
  final VoidCallback? onClose;

  IconData _defaultIcon() => switch (color) {
        NixtColorRole.success => NixtIcons.checkCircle,
        NixtColorRole.warning => NixtIcons.alertTriangle,
        NixtColorRole.error => NixtIcons.xCircle,
        _ => NixtIcons.info,
      };

  @override
  Widget build(BuildContext context) {
    final t = NixtTheme.of(context);
    final c = t.colors;
    final paint = NixtVariantResolver.resolve(color, variant, c);
    final fg = paint.foreground;

    final iconColor = variant == NixtVariant.solid
        ? fg
        : color == NixtColorRole.neutral
            ? c.textHighlighted
            : c.role(color);

    return Container(
      padding: const EdgeInsets.all(NixtSpacing.s4),
      decoration: BoxDecoration(
        color: paint.background,
        borderRadius: BorderRadius.circular(t.radius.lg),
        border: paint.border == null
            ? null
            : Border.all(color: paint.border!, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showIcon) ...[
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child:
                  NixtIcon(icon ?? _defaultIcon(), size: 20, color: iconColor),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: TextStyle(
                      fontFamily: NixtTypography.fontSans,
                      fontSize: NixtTypography.textSm,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                      color: fg,
                    ),
                  ),
                if (description != null)
                  Padding(
                    padding: EdgeInsets.only(top: title != null ? 2 : 0),
                    child: Text(
                      description!,
                      style: TextStyle(
                        fontFamily: NixtTypography.fontSans,
                        fontSize: NixtTypography.textSm,
                        height: 1.45,
                        color: nixtOpacity(fg, 0.9),
                      ),
                    ),
                  ),
                if (actions != null)
                  Padding(
                      padding: const EdgeInsets.only(top: 12), child: actions),
              ],
            ),
          ),
          if (onClose != null)
            GestureDetector(
              onTap: onClose,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.only(left: 8, top: 2),
                child: NixtIcon(NixtIcons.x,
                    size: 18, color: nixtOpacity(fg, 0.7)),
              ),
            ),
        ],
      ),
    );
  }
}
