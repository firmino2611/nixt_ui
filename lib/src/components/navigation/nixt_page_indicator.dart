import 'package:flutter/widgets.dart';

import '../../theme/nixt_theme.dart';
import '../../tokens/color_roles.dart';

/// Page / carousel dots — the onboarding and gallery position indicator. The
/// active dot stretches into a pill. Pass [onDotClick] to make dots tappable.
///
/// ```dart
/// NixtPageIndicator(count: 4, active: page);
/// NixtPageIndicator(count: 4, active: page, onDotClick: (i) => controller.jumpTo(i));
/// ```
class NixtPageIndicator extends StatelessWidget {
  /// Creates a page indicator.
  const NixtPageIndicator({
    this.count = 3,
    this.active = 0,
    this.color = NixtColorRole.primary,
    this.onDotClick,
    super.key,
  });

  /// Total dots.
  final int count;

  /// Active index.
  final int active;

  /// Active-dot color role. Defaults to `primary`.
  final NixtColorRole color;

  /// Tap callback with the dot index.
  final ValueChanged<int>? onDotClick;

  @override
  Widget build(BuildContext context) {
    final c = NixtTheme.of(context).colors;
    final accent =
        color == NixtColorRole.neutral ? c.textHighlighted : c.role(color);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < count; i++)
          Padding(
            padding: EdgeInsets.only(right: i == count - 1 ? 0 : 7),
            child: GestureDetector(
              onTap: onDotClick == null ? null : () => onDotClick!(i),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOut,
                height: 7,
                width: i == active ? 22 : 7,
                decoration: BoxDecoration(
                  color: i == active ? accent : c.bgAccented,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
