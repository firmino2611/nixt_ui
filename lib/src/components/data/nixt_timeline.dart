import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../foundations/color_util.dart';
import '../../foundations/nixt_icons.dart';
import '../../theme/nixt_theme.dart';
import '../../tokens/color_roles.dart';
import '../../tokens/typography_tokens.dart';
import '../icon/nixt_icon.dart';

/// One entry in a [NixtTimeline].
@immutable
class NixtTimelineItem {
  /// Creates a timeline entry.
  const NixtTimelineItem({
    required this.title,
    this.time,
    this.description,
    this.icon,
    this.color = NixtColorRole.primary,
    this.done = true,
  });

  /// The entry headline.
  final String title;

  /// Optional trailing timestamp (e.g. `"2h ago"`).
  final String? time;

  /// Optional secondary line.
  final String? description;

  /// Optional marker icon. Defaults to a check when [done], a circle otherwise.
  final IconData? icon;

  /// Accent color role for the marker. Defaults to `primary`.
  final NixtColorRole color;

  /// Completed (filled marker) vs pending (dashed ring). Defaults to `true`.
  final bool done;
}

/// A vertical timeline — order tracking, activity history, status feeds.
///
/// Each [NixtTimelineItem] renders a marker connected by a rail; completed
/// items get a filled tint, pending ones a dashed ring.
///
/// ```dart
/// NixtTimeline(items: [
///   NixtTimelineItem(title: 'Order placed', time: '9:41', done: true),
///   NixtTimelineItem(title: 'Out for delivery', done: false),
/// ]);
/// ```
class NixtTimeline extends StatelessWidget {
  /// Creates a timeline.
  const NixtTimeline({required this.items, super.key});

  /// The entries, top to bottom.
  final List<NixtTimelineItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < items.length; i++)
          _Row(item: items[i], last: i == items.length - 1),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.item, required this.last});

  final NixtTimelineItem item;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final t = NixtTheme.of(context);
    final c = t.colors;
    final done = item.done;
    final accent = c.role(item.color);
    final markerFg = done ? accent : c.textDimmed;
    final markerIcon = item.icon ?? (done ? NixtIcons.check : NixtIcons.circle);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- Marker + rail ----
          Column(
            children: [
              SizedBox(
                width: 30,
                height: 30,
                child: CustomPaint(
                  painter: done
                      ? null
                      : _DashedRingPainter(color: c.borderAccented),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: done ? nixtOpacity(accent, 0.16) : c.bgElevated,
                    ),
                    child: NixtIcon(markerIcon, size: 16, color: markerFg),
                  ),
                ),
              ),
              if (!last)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.only(top: 4),
                    color: c.border,
                    constraints: const BoxConstraints(minHeight: 22),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          // ---- Content ----
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: last ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontFamily: NixtTypography.fontSans,
                            fontSize: NixtTypography.textSm,
                            fontWeight: NixtTypography.weightSemibold,
                            color:
                                done ? c.textHighlighted : c.textMuted,
                          ),
                        ),
                      ),
                      if (item.time != null) ...[
                        const SizedBox(width: 8),
                        Text(
                          item.time!,
                          style: TextStyle(
                            fontFamily: NixtTypography.fontSans,
                            fontSize: NixtTypography.textXs,
                            color: c.textDimmed,
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (item.description != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(
                        item.description!,
                        style: TextStyle(
                          fontFamily: NixtTypography.fontSans,
                          fontSize: NixtTypography.textXs,
                          height: 1.5,
                          color: c.textMuted,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Paints a 1.5px dashed circle ring just inside the box edge.
class _DashedRingPainter extends CustomPainter {
  const _DashedRingPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final radius = size.width / 2 - 0.75;
    final center = Offset(size.width / 2, size.height / 2);
    const dashCount = 14;
    const sweep = (2 * math.pi) / dashCount;
    const gapRatio = 0.45;
    for (var i = 0; i < dashCount; i++) {
      final start = i * sweep;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep * (1 - gapRatio),
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_DashedRingPainter old) => old.color != color;
}
