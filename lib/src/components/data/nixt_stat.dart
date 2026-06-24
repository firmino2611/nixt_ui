import 'package:flutter/widgets.dart';

import '../../foundations/color_util.dart';
import '../../foundations/nixt_icons.dart';
import '../../theme/nixt_theme.dart';
import '../../tokens/color_roles.dart';
import '../../tokens/typography_tokens.dart';
import '../icon/nixt_icon.dart';

/// Trend direction for a [NixtStat] delta.
enum NixtStatTrend {
  /// Positive — green with an upward arrow.
  up,

  /// Negative — red with a downward arrow.
  down,
}

/// Alignment for a [NixtStat]'s contents.
enum NixtStatAlign {
  /// Left-aligned (default).
  left,

  /// Centered.
  center,
}

/// A compact metric display — value, label, and an optional delta with a trend
/// arrow and tinted icon tile.
///
/// When [trend] is omitted it is inferred from a leading `+` / `-` in [delta].
///
/// ```dart
/// NixtStat(
///   icon: NixtIcons.dollarSign,
///   value: '\$12.4k',
///   label: 'Revenue',
///   delta: '+12%',
/// );
/// ```
class NixtStat extends StatelessWidget {
  /// Creates a stat.
  const NixtStat({
    required this.value,
    required this.label,
    this.delta,
    this.trend,
    this.icon,
    this.color = NixtColorRole.primary,
    this.align = NixtStatAlign.left,
    super.key,
  });

  /// The headline metric (e.g. `"$12.4k"`).
  final String value;

  /// The metric label (e.g. `"Revenue"`).
  final String label;

  /// Optional delta text (e.g. `"+12%"`). A leading sign infers [trend].
  final String? delta;

  /// Forces the delta color and arrow. Inferred from [delta]'s sign when null.
  final NixtStatTrend? trend;

  /// Optional icon shown in a tinted tile above the value.
  final IconData? icon;

  /// Accent color role for the icon tile. Defaults to `primary`.
  final NixtColorRole color;

  /// Content alignment. Defaults to `left`.
  final NixtStatAlign align;

  NixtStatTrend? get _dir {
    if (trend != null) return trend;
    final d = delta?.trimLeft();
    if (d == null || d.isEmpty) return null;
    if (d.startsWith('-')) return NixtStatTrend.down;
    if (d.startsWith('+')) return NixtStatTrend.up;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final t = NixtTheme.of(context);
    final c = t.colors;
    final accent = c.role(color);
    final dir = _dir;
    final deltaColor = switch (dir) {
      NixtStatTrend.up => c.success,
      NixtStatTrend.down => c.error,
      null => c.textMuted,
    };
    final centered = align == NixtStatAlign.center;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: nixtOpacity(accent, 0.14),
              borderRadius: t.radius.brLg,
            ),
            child: NixtIcon(icon!, size: 18, color: accent),
          ),
          const SizedBox(height: 6),
        ],
        Text(
          value,
          style: TextStyle(
            fontFamily: NixtTypography.fontMono,
            fontSize: NixtTypography.text2xl,
            fontWeight: NixtTypography.weightBold,
            height: NixtTypography.leadingNone,
            color: c.textHighlighted,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontFamily: NixtTypography.fontSans,
                fontSize: NixtTypography.textXs,
                color: c.textMuted,
              ),
            ),
            if (delta != null) ...[
              const SizedBox(width: 6),
              if (dir != null)
                Padding(
                  padding: const EdgeInsets.only(right: 1),
                  child: NixtIcon(
                    dir == NixtStatTrend.up
                        ? NixtIcons.trendingUp
                        : NixtIcons.arrowDownLeft,
                    size: 12,
                    color: deltaColor,
                  ),
                ),
              Text(
                delta!,
                style: TextStyle(
                  fontFamily: NixtTypography.fontSans,
                  fontSize: NixtTypography.textXs,
                  fontWeight: NixtTypography.weightSemibold,
                  color: deltaColor,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
