import 'package:flutter/widgets.dart';

import '../../theme/nixt_theme.dart';
import '../../tokens/color_roles.dart';
import 'control_common.dart';

/// A single radio control with an optional label and description. Group several
/// by giving each a distinct value and sharing one `onChanged` handler that
/// updates the selected value.
///
/// ```dart
/// NixtRadio<String>(
///   value: 'a',
///   groupValue: selected,
///   label: 'Option A',
///   onChanged: (v) => setState(() => selected = v),
/// );
/// ```
class NixtRadio<T> extends StatelessWidget {
  /// Creates a radio.
  const NixtRadio({
    required this.value,
    required this.groupValue,
    this.onChanged,
    this.label,
    this.description,
    this.color = NixtColorRole.primary,
    this.size = NixtControlSize.md,
    this.enabled = true,
    super.key,
  });

  /// This radio's value.
  final T value;

  /// The currently selected value of the group.
  final T? groupValue;

  /// Called with [value] when tapped. A `null` callback disables the control.
  final ValueChanged<T>? onChanged;

  /// Optional label.
  final String? label;

  /// Optional description.
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
    final on = value == groupValue;
    final interactive = enabled && onChanged != null;

    final ring = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      width: _box,
      height: _box,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: c.bg,
        shape: BoxShape.circle,
        border: Border.all(color: on ? accent : c.borderAccented, width: 1.5),
      ),
      child: AnimatedScale(
        scale: on ? 1 : 0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Container(
          width: _box * 0.5,
          height: _box * 0.5,
          decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
        ),
      ),
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: interactive ? () => onChanged!(value) : null,
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
              child: ring,
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
