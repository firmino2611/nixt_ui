import 'package:flutter/material.dart';

import '../../theme/nixt_theme.dart';
import '../../tokens/color_roles.dart';
import '../../tokens/typography_tokens.dart';

/// A range slider — a custom-themed [Slider] with an optional label/value row.
///
/// ```dart
/// NixtSlider(
///   value: volume,
///   label: 'Volume',
///   showValue: true,
///   onChanged: (v) => setState(() => volume = v),
/// );
/// ```
class NixtSlider extends StatelessWidget {
  /// Creates a slider.
  const NixtSlider({
    required this.value,
    this.onChanged,
    this.min = 0,
    this.max = 100,
    this.divisions,
    this.color = NixtColorRole.primary,
    this.label,
    this.showValue = false,
    this.valueFormatter,
    this.enabled = true,
    super.key,
  });

  /// Current value.
  final double value;

  /// Change callback. A `null` callback disables the control.
  final ValueChanged<double>? onChanged;

  /// Minimum.
  final double min;

  /// Maximum.
  final double max;

  /// Optional discrete divisions (snaps the thumb).
  final int? divisions;

  /// Accent color role. Defaults to `primary`.
  final NixtColorRole color;

  /// Optional label shown above-left.
  final String? label;

  /// Show the current value above-right.
  final bool showValue;

  /// Formats the displayed value (defaults to a rounded integer).
  final String Function(double)? valueFormatter;

  /// Whether the control is interactive.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final t = NixtTheme.of(context);
    final c = t.colors;
    final accent =
        color == NixtColorRole.neutral ? c.textHighlighted : c.role(color);
    final display = valueFormatter?.call(value) ?? value.round().toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null || showValue)
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
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
                    display,
                    style: TextStyle(
                      fontFamily: NixtTypography.fontMono,
                      fontSize: NixtTypography.textSm,
                      fontWeight: NixtTypography.weightSemibold,
                      color: c.textHighlighted,
                    ),
                  ),
              ],
            ),
          ),
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 6,
            activeTrackColor: accent,
            inactiveTrackColor: c.bgAccented,
            trackShape: const RoundedRectSliderTrackShape(),
            overlayShape: SliderComponentShape.noOverlay,
            thumbShape: _NixtThumbShape(border: c.border, shadow: t.shadows.md),
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: divisions,
            onChanged: enabled ? onChanged : null,
          ),
        ),
      ],
    );
  }
}

/// A white 24px thumb with a hairline border and a soft drop shadow.
class _NixtThumbShape extends SliderComponentShape {
  const _NixtThumbShape({required this.border, required this.shadow});

  final Color border;
  final List<BoxShadow> shadow;

  static const double _radius = 12;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      const Size.fromRadius(_radius);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;
    final s = shadow.isNotEmpty ? shadow.first : null;
    if (s != null) {
      canvas.drawCircle(
        center + s.offset,
        _radius,
        Paint()
          ..color = s.color
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, s.blurRadius),
      );
    }
    canvas.drawCircle(
        center, _radius, Paint()..color = const Color(0xFFFFFFFF));
    canvas.drawCircle(
      center,
      _radius,
      Paint()
        ..color = border
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }
}
