import 'package:flutter/widgets.dart';

import '../../theme/nixt_theme.dart';
import '../../tokens/color_roles.dart';
import 'control_common.dart';

/// An on/off switch — the standard toggle for settings rows. Controlled via
/// [value] and [onChanged]. When a [label] is given the control fills its width
/// with the label on the left and the track on the right.
///
/// ```dart
/// NixtSwitch(
///   value: notifications,
///   label: 'Notifications',
///   description: 'Push alerts on this device.',
///   onChanged: (v) => setState(() => notifications = v),
/// );
/// ```
class NixtSwitch extends StatelessWidget {
  /// Creates a switch.
  const NixtSwitch({
    required this.value,
    this.onChanged,
    this.label,
    this.description,
    this.color = NixtColorRole.primary,
    this.size = NixtControlSize.md,
    this.enabled = true,
    super.key,
  });

  /// Whether the switch is on.
  final bool value;

  /// Change callback. A `null` callback disables the control.
  final ValueChanged<bool>? onChanged;

  /// Optional label (rendered left, fills width for settings rows).
  final String? label;

  /// Optional description.
  final String? description;

  /// Accent color role. Defaults to `primary`.
  final NixtColorRole color;

  /// Size. Defaults to `md`.
  final NixtControlSize size;

  /// Whether the control is interactive.
  final bool enabled;

  ({double w, double h, double knob}) get _metrics => switch (size) {
        NixtControlSize.sm => (w: 36, h: 20, knob: 16),
        NixtControlSize.md => (w: 44, h: 24, knob: 20),
        NixtControlSize.lg => (w: 52, h: 30, knob: 25),
      };

  @override
  Widget build(BuildContext context) {
    final t = NixtTheme.of(context);
    final c = t.colors;
    final accent =
        color == NixtColorRole.neutral ? c.textHighlighted : c.role(color);
    final m = _metrics;
    final pad = (m.h - m.knob) / 2;
    final interactive = enabled && onChanged != null;

    final track = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      width: m.w,
      height: m.h,
      padding: EdgeInsets.all(pad),
      decoration: BoxDecoration(
        color: value ? accent : c.bgAccented,
        borderRadius: BorderRadius.circular(t.radius.full),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: m.knob,
          height: m.knob,
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            shape: BoxShape.circle,
            boxShadow: t.shadows.sm,
          ),
        ),
      ),
    );

    final hasText = label != null || description != null;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: interactive ? () => onChanged!(!value) : null,
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: hasText
            ? Row(
                children: [
                  Expanded(
                    child: NixtControlLabel(
                        colors: c, label: label, description: description),
                  ),
                  const SizedBox(width: 12),
                  track,
                ],
              )
            : track,
      ),
    );
  }
}
