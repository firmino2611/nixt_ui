import 'package:flutter/widgets.dart';

import '../../foundations/nixt_icons.dart';
import '../../theme/nixt_theme.dart';
import '../../tokens/color_roles.dart';
import '../icon/nixt_icon.dart';
import 'control_common.dart';

/// A checkbox with an optional label and description. Controlled via [value]
/// and [onChanged].
///
/// ```dart
/// NixtCheckbox(
///   value: accepted,
///   label: 'I agree',
///   description: 'You accept the terms.',
///   onChanged: (v) => setState(() => accepted = v),
/// );
/// ```
class NixtCheckbox extends StatelessWidget {
  /// Creates a checkbox.
  const NixtCheckbox({
    required this.value,
    this.onChanged,
    this.label,
    this.description,
    this.color = NixtColorRole.primary,
    this.size = NixtControlSize.md,
    this.enabled = true,
    super.key,
  });

  /// Whether the box is checked.
  final bool value;

  /// Change callback. A `null` callback disables the control.
  final ValueChanged<bool>? onChanged;

  /// Optional label.
  final String? label;

  /// Optional description (rendered under the label).
  final String? description;

  /// Accent color role. Defaults to `primary`.
  final NixtColorRole color;

  /// Size. Defaults to `md`.
  final NixtControlSize size;

  /// Whether the control is interactive.
  final bool enabled;

  double get _box => switch (size) {
        NixtControlSize.sm => 18,
        NixtControlSize.md => 20,
        NixtControlSize.lg => 24,
      };

  @override
  Widget build(BuildContext context) {
    final t = NixtTheme.of(context);
    final c = t.colors;
    final accent =
        color == NixtColorRole.neutral ? c.textHighlighted : c.role(color);
    final interactive = enabled && onChanged != null;

    final box = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      width: _box,
      height: _box,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: value ? accent : c.bg,
        borderRadius: t.radius.brSm,
        border: Border.all(
          color: value ? accent : c.borderAccented,
          width: 1.5,
        ),
      ),
      child: value
          ? NixtIcon(NixtIcons.check, size: _box - 6, color: c.textInverted)
          : null,
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: interactive ? () => onChanged!(!value) : null,
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: description != null
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: description != null ? 2 : 0),
              child: box,
            ),
            if (label != null || description != null) ...[
              const SizedBox(width: 10),
              Flexible(
                child: NixtControlLabel(
                    colors: c, label: label, description: description),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
