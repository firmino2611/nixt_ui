import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../theme/nixt_theme.dart';
import '../../tokens/color_roles.dart';
import '../../tokens/typography_tokens.dart';

/// A star rating — interactive (pass [onChanged]) or a read-only display.
///
/// Stars are drawn as a consistent 5-point shape (filled when active, stroked
/// otherwise) since the Lucide set has no filled-star glyph.
///
/// ```dart
/// NixtRating(value: 3, onChanged: (v) => setState(() => stars = v));
/// NixtRating(value: 4.5, readOnly: true, showValue: true);
/// ```
class NixtRating extends StatelessWidget {
  /// Creates a rating.
  const NixtRating({
    required this.value,
    this.onChanged,
    this.max = 5,
    this.starSize = 24,
    this.color = NixtColorRole.warning,
    this.readOnly = false,
    this.showValue = false,
    super.key,
  });

  /// Current rating (may be fractional for display).
  final double value;

  /// Called with the 1-based star index on tap. Implies interactive.
  final ValueChanged<int>? onChanged;

  /// Number of stars.
  final int max;

  /// Star size in pixels.
  final double starSize;

  /// Accent color role. Defaults to `warning`.
  final NixtColorRole color;

  /// Read-only display (no taps).
  final bool readOnly;

  /// Show the numeric value after the stars.
  final bool showValue;

  @override
  Widget build(BuildContext context) {
    final t = NixtTheme.of(context);
    final c = t.colors;
    final accent =
        color == NixtColorRole.neutral ? c.textHighlighted : c.role(color);
    final interactive = !readOnly && onChanged != null;
    final rounded = value.round();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 1; i <= max; i++) ...[
          if (i > 1) const SizedBox(width: 3),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: interactive ? () => onChanged!(i) : null,
            child: CustomPaint(
              size: Size.square(starSize),
              painter: _StarPainter(
                filled: i <= rounded,
                fill: accent,
                empty: c.bgAccented,
              ),
            ),
          ),
        ],
        if (showValue) ...[
          const SizedBox(width: 8),
          Text(
            value.toStringAsFixed(1),
            style: TextStyle(
              fontFamily: NixtTypography.fontMono,
              fontSize: NixtTypography.textSm,
              fontWeight: NixtTypography.weightSemibold,
              color: c.textToned,
            ),
          ),
        ],
      ],
    );
  }
}

class _StarPainter extends CustomPainter {
  _StarPainter({required this.filled, required this.fill, required this.empty});

  final bool filled;
  final Color fill;
  final Color empty;

  @override
  void paint(Canvas canvas, Size size) {
    final path = _starPath(size);
    if (filled) {
      canvas.drawPath(
          path,
          Paint()
            ..color = fill
            ..style = PaintingStyle.fill);
    } else {
      canvas.drawPath(
        path,
        Paint()
          ..color = empty
          ..style = PaintingStyle.stroke
          ..strokeWidth = size.width * 0.09
          ..strokeJoin = StrokeJoin.round,
      );
    }
  }

  Path _starPath(Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final outer = size.width / 2 * 0.92;
    final inner = outer * 0.40;
    final path = Path();
    for (var i = 0; i < 10; i++) {
      final r = i.isEven ? outer : inner;
      final angle = -math.pi / 2 + i * math.pi / 5;
      final x = cx + r * math.cos(angle);
      final y = cy + r * math.sin(angle);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    return path;
  }

  @override
  bool shouldRepaint(_StarPainter old) =>
      old.filled != filled || old.fill != fill || old.empty != empty;
}
