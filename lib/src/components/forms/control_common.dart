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

/// Renders an optional field [label] above [child] — the shared implementation
/// behind the `label` parameter on the form-field components (Input, Textarea,
/// Select, Stepper, …). Returns [child] unchanged when [label] is null, so
/// components can wrap unconditionally.
///
/// [fontSize]/[gap] let field-family components scale the label with their size
/// (see `NixtFieldSize.labelSize`/`labelGap`); the defaults suit fixed-size
/// controls. When [errored] is true the label paints in the error color to
/// match the field's error border.
class NixtFieldLabel extends StatelessWidget {
  /// Wraps [child] with an optional top label.
  const NixtFieldLabel({
    required this.colors,
    required this.child,
    this.label,
    this.fontSize = NixtTypography.textSm,
    this.gap = 6,
    this.errored = false,
    super.key,
  });

  /// Resolved colors.
  final NixtColors colors;

  /// The field this label describes.
  final Widget child;

  /// Label text. Null renders just [child].
  final String? label;

  /// Label font size (scale with the field size where one exists).
  final double fontSize;

  /// Gap between the label and [child].
  final double gap;

  /// Paint the label in the error color.
  final bool errored;

  @override
  Widget build(BuildContext context) {
    if (label == null) return child;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Text(
            label!,
            style: TextStyle(
              fontFamily: NixtTypography.fontSans,
              fontSize: fontSize,
              fontWeight: NixtTypography.weightMedium,
              color: errored ? colors.error : colors.text,
            ),
          ),
        ),
        SizedBox(height: gap),
        child,
      ],
    );
  }
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
