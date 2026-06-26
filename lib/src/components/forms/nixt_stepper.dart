import 'package:flutter/widgets.dart';

import '../../foundations/nixt_icons.dart';
import '../../foundations/press_scale.dart';
import '../../theme/nixt_theme.dart';
import '../../tokens/color_roles.dart';
import '../../tokens/typography_tokens.dart';
import 'control_common.dart';
import '../icon/nixt_icon.dart';

/// A quantity stepper — `−` / `＋` buttons around a value. Controlled via [value]
/// and [onChanged].
///
/// ```dart
/// NixtStepper(value: qty, min: 0, max: 10, onChanged: (v) => setState(() => qty = v));
/// ```
class NixtStepper extends StatelessWidget {
  /// Creates a stepper.
  const NixtStepper({
    required this.value,
    this.onChanged,
    this.label,
    this.min = -9007199254740991,
    this.max = 9007199254740991,
    this.step = 1,
    this.size = NixtControlSize.md,
    this.color = NixtColorRole.neutral,
    this.suffix,
    this.enabled = true,
    super.key,
  });

  /// Current value.
  final int value;

  /// Optional label rendered above the control. Scales with [size].
  final String? label;

  /// Change callback. A `null` callback disables the control.
  final ValueChanged<int>? onChanged;

  /// Lower bound (inclusive).
  final int min;

  /// Upper bound (inclusive).
  final int max;

  /// Increment.
  final int step;

  /// Size. Defaults to `md`.
  final NixtControlSize size;

  /// Accent color role for the icons. Defaults to `neutral`.
  final NixtColorRole color;

  /// Optional unit suffix shown after the value.
  final String? suffix;

  /// Whether the control is interactive.
  final bool enabled;

  ({double btn, double fs, double w}) get _m => switch (size) {
        NixtControlSize.sm => (btn: 30, fs: NixtTypography.textSm, w: 36),
        NixtControlSize.md => (btn: 36, fs: NixtTypography.textBase, w: 44),
        NixtControlSize.lg => (btn: 44, fs: NixtTypography.textLg, w: 52),
      };

  @override
  Widget build(BuildContext context) {
    final t = NixtTheme.of(context);
    final c = t.colors;
    final accent =
        color == NixtColorRole.neutral ? c.textHighlighted : c.role(color);
    final m = _m;

    void set(int v) {
      final n = v.clamp(min, max);
      if (n != value) onChanged?.call(n);
    }

    Widget btn(IconData icon, bool atLimit, VoidCallback onTap) {
      final off = atLimit || !enabled || onChanged == null;
      return NixtPressScale(
        enabled: !off,
        onTap: off ? null : onTap,
        child: Container(
          width: m.btn,
          height: m.btn,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: c.bg,
            borderRadius: t.radius.brMd,
            border: Border.all(color: c.borderAccented, width: 1),
          ),
          child:
              NixtIcon(icon, size: 18, color: atLimit ? c.textDimmed : accent),
        ),
      );
    }

    final labelSize = switch (size) {
      NixtControlSize.sm => NixtTypography.textXs,
      NixtControlSize.md => NixtTypography.textSm,
      NixtControlSize.lg => NixtTypography.textBase,
    };

    return NixtFieldLabel(
      colors: c,
      label: label,
      fontSize: labelSize,
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            btn(NixtIcons.minus, value <= min, () => set(value - step)),
            const SizedBox(width: 4),
            SizedBox(
              width: m.w,
              child: Text.rich(
                TextSpan(
                  text: '$value',
                  children: [
                    if (suffix != null)
                      TextSpan(
                        text: ' $suffix',
                        style: TextStyle(
                          fontSize: m.fs * 0.75,
                          color: c.textMuted,
                        ),
                      ),
                  ],
                ),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: NixtTypography.fontMono,
                  fontSize: m.fs,
                  fontWeight: NixtTypography.weightSemibold,
                  color: c.textHighlighted,
                ),
              ),
            ),
            const SizedBox(width: 4),
            btn(NixtIcons.plus, value >= max, () => set(value + step)),
          ],
        ),
      ),
    );
  }
}
