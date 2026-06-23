import 'package:flutter/widgets.dart';

import '../../foundations/color_util.dart';
import '../../foundations/nixt_icons.dart';
import '../../theme/nixt_theme.dart';
import '../../tokens/color_roles.dart';
import '../../tokens/spacing_tokens.dart';
import '../../tokens/typography_tokens.dart';
import '../icon/nixt_icon.dart';

/// Empty / zero / error state — a centered column with a tinted icon tile,
/// title, supporting text, and an optional [action]. Use it for empty lists,
/// no-results screens, and recoverable errors.
///
/// ```dart
/// NixtEmptyState(
///   icon: NixtIcons.search,
///   title: 'No results',
///   description: 'Try a different search term.',
///   action: NixtButton(label: 'Clear filters', onPressed: reset),
/// );
/// ```
class NixtEmptyState extends StatelessWidget {
  /// Creates an empty state.
  const NixtEmptyState({
    this.icon = NixtIcons.search,
    this.title,
    this.description,
    this.action,
    this.color = NixtColorRole.neutral,
    super.key,
  });

  /// Tile icon. Defaults to a search glyph.
  final IconData icon;

  /// Headline.
  final String? title;

  /// Supporting text under the title.
  final String? description;

  /// Optional action below the text (e.g. a [NixtButton]).
  final Widget? action;

  /// Accent color for the tile. Defaults to `neutral`.
  final NixtColorRole color;

  @override
  Widget build(BuildContext context) {
    final t = NixtTheme.of(context);
    final c = t.colors;
    final isNeutral = color == NixtColorRole.neutral;
    final accent = isNeutral ? c.textMuted : c.role(color);
    final tint = isNeutral ? c.bgElevated : nixtOpacity(accent, 0.14);

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: NixtSpacing.s8,
        horizontal: NixtSpacing.s6,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: tint,
              borderRadius: BorderRadius.circular(t.radius.xxl),
            ),
            child: NixtIcon(icon, size: 30, color: accent),
          ),
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                title!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: NixtTypography.fontSans,
                  fontSize: NixtTypography.textLg,
                  fontWeight: FontWeight.w600,
                  color: c.textHighlighted,
                ),
              ),
            ),
          if (description != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 280),
                child: Text(
                  description!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: NixtTypography.fontSans,
                    fontSize: NixtTypography.textSm,
                    height: 1.5,
                    color: c.textMuted,
                  ),
                ),
              ),
            ),
          if (action != null)
            Padding(padding: const EdgeInsets.only(top: 20), child: action),
        ],
      ),
    );
  }
}
