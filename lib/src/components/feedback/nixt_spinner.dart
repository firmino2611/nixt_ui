import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../foundations/color_util.dart';
import '../../theme/nixt_theme.dart';
import '../../tokens/color_roles.dart';

/// A standalone, continuously-rotating loading spinner.
///
/// A faint full ring with a bright leading arc. Respects the platform
/// reduced-motion setting by slowing down rather than stopping.
///
/// ```dart
/// NixtSpinner(size: 28, color: NixtColorRole.primary);
/// ```
class NixtSpinner extends StatefulWidget {
  /// Creates a spinner.
  const NixtSpinner({
    this.size = 24,
    this.color = NixtColorRole.primary,
    this.thickness,
    this.label = 'Loading',
    super.key,
  });

  /// Diameter in logical pixels. Defaults to 24.
  final double size;

  /// Accent color role for the leading arc. Defaults to `primary`.
  final NixtColorRole color;

  /// Ring thickness. Defaults to roughly `size / 9` (min 2).
  final double? thickness;

  /// Accessible label exposed to assistive tech. Defaults to `"Loading"`.
  final String label;

  @override
  State<NixtSpinner> createState() => _NixtSpinnerState();
}

class _NixtSpinnerState extends State<NixtSpinner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..repeat();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final slow = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    _controller.duration =
        Duration(milliseconds: slow ? 1600 : 700);
    if (!_controller.isAnimating) _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = NixtTheme.of(context).colors;
    final accent =
        widget.color == NixtColorRole.neutral ? c.textMuted : c.role(widget.color);
    final thickness =
        widget.thickness ?? math.max(2.0, (widget.size / 9).roundToDouble());

    return Semantics(
      label: widget.label,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: RotationTransition(
          turns: _controller,
          child: CustomPaint(
            painter: _SpinnerPainter(
              accent: accent,
              track: nixtOpacity(accent, 0.2),
              thickness: thickness,
            ),
          ),
        ),
      ),
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  const _SpinnerPainter({
    required this.accent,
    required this.track,
    required this.thickness,
  });

  final Color accent;
  final Color track;
  final double thickness;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = (size.width - thickness) / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness;
    canvas.drawCircle(center, radius, trackPaint);

    final arcPaint = Paint()
      ..color = accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round;
    // Leading quarter arc, starting at the top.
    canvas.drawArc(rect, -math.pi / 2, math.pi / 2, false, arcPaint);
  }

  @override
  bool shouldRepaint(_SpinnerPainter old) =>
      old.accent != accent ||
      old.track != track ||
      old.thickness != thickness;
}
