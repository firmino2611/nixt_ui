import 'package:flutter/widgets.dart';

import '../../theme/nixt_theme.dart';
import '../../tokens/typography_tokens.dart';

/// Orientation for [NixtDivider].
enum NixtDividerOrientation {
  /// Full-width horizontal rule (default).
  horizontal,

  /// 1px vertical rule for inline use — stretches to its parent's height.
  vertical,
}

/// Hairline separator. Horizontal by default, with an optional centered
/// [label] (e.g. "or"); set [orientation] to [NixtDividerOrientation.vertical]
/// for an inline rule inside a [Row].
///
/// ```dart
/// const NixtDivider();
/// const NixtDivider(label: 'or');
/// const NixtDivider(orientation: NixtDividerOrientation.vertical);
/// ```
class NixtDivider extends StatelessWidget {
  /// Creates a divider.
  const NixtDivider({
    this.label,
    this.orientation = NixtDividerOrientation.horizontal,
    super.key,
  });

  /// Centered label (horizontal only).
  final String? label;

  /// Orientation. Defaults to horizontal.
  final NixtDividerOrientation orientation;

  @override
  Widget build(BuildContext context) {
    final c = NixtTheme.of(context).colors;

    if (orientation == NixtDividerOrientation.vertical) {
      return SizedBox(
        width: 1,
        child: ColoredBox(color: c.border, child: const SizedBox.expand()),
      );
    }

    final line = Expanded(child: Container(height: 1, color: c.border));

    if (label == null) {
      return Container(height: 1, color: c.border);
    }

    return Row(
      children: [
        line,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label!,
            style: TextStyle(
              fontFamily: NixtTypography.fontSans,
              fontSize: NixtTypography.textXs,
              fontWeight: FontWeight.w500,
              color: c.textDimmed,
            ),
          ),
        ),
        line,
      ],
    );
  }
}
