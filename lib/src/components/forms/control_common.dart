import 'package:flutter/widgets.dart';

import '../../theme/nixt_colors.dart';
import '../../tokens/typography_tokens.dart';

/// Size preset shared by the toggle controls (Checkbox, Radio, Switch).
enum NixtControlSize {
  /// Small.
  sm,

  /// Medium (default).
  md,

  /// Large.
  lg,
}

/// The optional `label` + `description` text column rendered beside a toggle
/// control. Returns an empty widget when both are null.
class NixtControlLabel extends StatelessWidget {
  /// Creates a control label.
  const NixtControlLabel({
    required this.colors,
    this.label,
    this.description,
    super.key,
  });

  /// Resolved colors.
  final NixtColors colors;

  /// Primary label.
  final String? label;

  /// Secondary description.
  final String? description;

  @override
  Widget build(BuildContext context) {
    if (label == null && description == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null)
          Text(
            label!,
            style: TextStyle(
              fontFamily: NixtTypography.fontSans,
              fontSize: NixtTypography.textSm,
              fontWeight: NixtTypography.weightMedium,
              height: 1.35,
              color: colors.textHighlighted,
            ),
          ),
        if (description != null)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              description!,
              style: TextStyle(
                fontFamily: NixtTypography.fontSans,
                fontSize: NixtTypography.textXs,
                height: 1.4,
                color: colors.textMuted,
              ),
            ),
          ),
      ],
    );
  }
}
