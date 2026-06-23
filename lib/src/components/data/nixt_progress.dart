import 'package:flutter/widgets.dart';

import '../../theme/nixt_theme.dart';
import '../../tokens/color_roles.dart';
import '../../tokens/typography_tokens.dart';

/// Track height for [NixtProgress].
enum NixtProgressSize {
  /// 4px.
  xs,

  /// 6px.
  sm,

  /// 8px (default).
  md,

  /// 12px.
  lg,

  /// 16px.
  xl,
}

extension _ProgressHeight on NixtProgressSize {
  double get height => switch (this) {
        NixtProgressSize.xs => 4,
        NixtProgressSize.sm => 6,
        NixtProgressSize.md => 8,
        NixtProgressSize.lg => 12,
        NixtProgressSize.xl => 16,
      };
}

/// Linear progress / meter bar. [value] runs from 0 to [max]; the fill
/// animates on change. Add a [label] caption and/or [showValue] percentage.
///
/// ```dart
/// NixtProgress(value: 64);
/// NixtProgress(value: 3, max: 5, label: 'Steps', showValue: true);
/// ```
class NixtProgress extends StatelessWidget {
  /// Creates a progress bar.
  const NixtProgress({
    this.value = 0,
    this.max = 100,
    this.color = NixtColorRole.primary,
    this.size = NixtProgressSize.md,
    this.label,
    this.showValue = false,
    super.key,
  });

  /// Current value (0–[max]).
  final double value;

  /// Maximum value. Defaults to 100.
  final double max;

  /// Fill color role. Defaults to `primary`.
  final NixtColorRole color;

  /// Track height. Defaults to `md`.
  final NixtProgressSize size;

  /// Optional caption above the bar.
  final String? label;

  /// Show the percentage on the right. Defaults to false.
  final bool showValue;

  @override
  Widget build(BuildContext context) {
    final t = NixtTheme.of(context);
    final c = t.colors;
    final accent =
        color == NixtColorRole.neutral ? c.textHighlighted : c.role(color);
    final pct = (max <= 0 ? 0.0 : (value / max)).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null || showValue)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (label != null)
                  Text(
                    label!,
                    style: TextStyle(
                      fontFamily: NixtTypography.fontSans,
                      fontSize: NixtTypography.textSm,
                      color: c.textToned,
                    ),
                  )
                else
                  const SizedBox.shrink(),
                if (showValue)
                  Text(
                    '${(pct * 100).round()}%',
                    style: TextStyle(
                      fontFamily: NixtTypography.fontSans,
                      fontSize: NixtTypography.textSm,
                      fontWeight: FontWeight.w600,
                      color: c.textHighlighted,
                    ),
                  ),
              ],
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(t.radius.full),
          child: Container(
            height: size.height,
            color: c.bgAccented,
            alignment: Alignment.centerLeft,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: pct),
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOutCubic,
              builder: (_, v, __) => FractionallySizedBox(
                widthFactor: v == 0 ? 0.0001 : v,
                child: Container(
                  decoration: BoxDecoration(
                    color: accent,
                    borderRadius: BorderRadius.circular(t.radius.full),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
