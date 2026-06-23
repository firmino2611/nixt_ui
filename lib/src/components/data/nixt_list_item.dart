import 'package:flutter/material.dart';

import '../../foundations/color_util.dart';
import '../../foundations/nixt_icons.dart';
import '../../theme/nixt_theme.dart';
import '../../tokens/color_roles.dart';
import '../../tokens/typography_tokens.dart';
import '../icon/nixt_icon.dart';

/// List row — the atomic unit of settings screens, feeds, and transaction
/// lists. A leading icon-tile (or custom [leading] node), a title/subtitle
/// column, then an optional muted [value], custom [trailing] node, and/or a
/// [chevron]. Pass [onTap] to make it pressable (adds a ripple-free highlight).
///
/// ```dart
/// NixtListItem(title: 'Wi-Fi', leadingIcon: NixtIcons.settings, chevron: true, onTap: ...);
/// NixtListItem(title: 'Storage', value: '64 GB', leading: NixtAvatar(name: 'A'));
/// NixtListItem(title: 'Airplane mode', trailing: NixtSwitch(...));
/// ```
class NixtListItem extends StatelessWidget {
  /// Creates a list row.
  const NixtListItem({
    required this.title,
    this.subtitle,
    this.leading,
    this.leadingIcon,
    this.leadingColor = NixtColorRole.primary,
    this.trailing,
    this.value,
    this.chevron = false,
    this.onTap,
    super.key,
  });

  /// Primary text.
  final String title;

  /// Secondary text under the title.
  final String? subtitle;

  /// Custom leading node (e.g. an avatar). Overrides [leadingIcon].
  final Widget? leading;

  /// Leading icon rendered in a tinted rounded tile.
  final IconData? leadingIcon;

  /// Tile tint color for [leadingIcon]. Defaults to `primary`.
  final NixtColorRole leadingColor;

  /// Custom trailing node (e.g. a switch or badge).
  final Widget? trailing;

  /// Muted trailing value text.
  final String? value;

  /// Show a trailing chevron. Defaults to false.
  final bool chevron;

  /// Tap callback. When set, the row highlights on press.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = NixtTheme.of(context);
    final c = t.colors;
    final accent = leadingColor == NixtColorRole.neutral
        ? c.textHighlighted
        : c.role(leadingColor);

    final lead = leading ??
        (leadingIcon != null
            ? Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: nixtOpacity(accent, 0.14),
                  borderRadius: BorderRadius.circular(t.radius.lg),
                ),
                child: NixtIcon(leadingIcon!, size: 19, color: accent),
              )
            : null);

    final row = Container(
      constraints: const BoxConstraints(minHeight: 60),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (lead != null) ...[lead, const SizedBox(width: 12)],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: NixtTypography.fontSans,
                    fontSize: NixtTypography.textSm,
                    fontWeight: FontWeight.w600,
                    color: c.textHighlighted,
                  ),
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: NixtTypography.fontSans,
                        fontSize: NixtTypography.textXs,
                        color: c.textMuted,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (value != null) ...[
            const SizedBox(width: 12),
            Text(
              value!,
              style: TextStyle(
                fontFamily: NixtTypography.fontSans,
                fontSize: NixtTypography.textSm,
                fontWeight: FontWeight.w500,
                color: c.textToned,
              ),
            ),
          ],
          if (trailing != null) ...[const SizedBox(width: 12), trailing!],
          if (chevron) ...[
            const SizedBox(width: 4),
            NixtIcon(NixtIcons.chevronRight, size: 18, color: c.textDimmed),
          ],
        ],
      ),
    );

    if (onTap == null) return row;
    return Material(
      color: const Color(0x00000000),
      child: InkWell(
        onTap: onTap,
        highlightColor: c.bgElevated,
        splashColor: nixtOpacity(c.bgElevated, 0.5),
        child: row,
      ),
    );
  }
}
