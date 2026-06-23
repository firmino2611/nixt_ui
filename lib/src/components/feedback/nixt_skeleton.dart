import 'package:flutter/widgets.dart';

import '../../foundations/color_util.dart';
import '../../theme/nixt_theme.dart';

/// Shape of a [NixtSkeleton] placeholder.
enum NixtSkeletonVariant {
  /// Stacked lines (a paragraph); the last line is shortened.
  text,

  /// A rounded rectangle (default).
  rect,

  /// A circle (e.g. an avatar).
  circle,
}

/// Loading placeholder with a left-to-right shimmer. Use [NixtSkeletonVariant]
/// to pick a paragraph of lines, a block, or a circle. The shimmer pauses when
/// the platform requests reduced motion.
///
/// ```dart
/// NixtSkeleton(variant: NixtSkeletonVariant.circle, width: 44);
/// NixtSkeleton(variant: NixtSkeletonVariant.text, lines: 3);
/// NixtSkeleton(height: 120); // rect block
/// ```
class NixtSkeleton extends StatefulWidget {
  /// Creates a skeleton.
  const NixtSkeleton({
    this.variant = NixtSkeletonVariant.rect,
    this.width,
    this.height,
    this.lines = 3,
    this.radius,
    super.key,
  });

  /// Placeholder shape. Defaults to `rect`.
  final NixtSkeletonVariant variant;

  /// Width in logical px. Defaults: rect = full width, circle = 44.
  final double? width;

  /// Height in logical px. Defaults: rect = 80, circle = 44, text line = 12.
  final double? height;

  /// Line count for the `text` variant. Defaults to 3.
  final int lines;

  /// Corner radius for `text` / `rect`. Defaults to the theme's small / large
  /// radius respectively.
  final double? radius;

  @override
  State<NixtSkeleton> createState() => _NixtSkeletonState();
}

class _NixtSkeletonState extends State<NixtSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = NixtTheme.of(context);
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;

    if (widget.variant == NixtSkeletonVariant.text) {
      final r = widget.radius ?? t.radius.sm;
      final h = widget.height ?? 12;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < widget.lines; i++)
            Padding(
              padding: EdgeInsets.only(bottom: i == widget.lines - 1 ? 0 : 8),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: i == widget.lines - 1 ? 0.65 : 1,
                child: _Bar(
                  controller: _ctrl,
                  reduceMotion: reduceMotion,
                  height: h,
                  borderRadius: BorderRadius.circular(r),
                ),
              ),
            ),
        ],
      );
    }

    final isCircle = widget.variant == NixtSkeletonVariant.circle;
    final w = widget.width ?? (isCircle ? 44 : double.infinity);
    final h = widget.height ?? (isCircle ? 44 : 80);
    final br = isCircle
        ? BorderRadius.circular(h)
        : BorderRadius.circular(widget.radius ?? t.radius.lg);

    return _Bar(
      controller: _ctrl,
      reduceMotion: reduceMotion,
      width: w,
      height: h,
      borderRadius: br,
    );
  }
}

/// A single shimmering bar clipped to [borderRadius].
class _Bar extends StatelessWidget {
  const _Bar({
    required this.controller,
    required this.reduceMotion,
    required this.height,
    required this.borderRadius,
    this.width,
  });

  final AnimationController controller;
  final bool reduceMotion;
  final double? width;
  final double height;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final c = NixtTheme.of(context).colors;
    final base = ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        width: width,
        height: height,
        child: ColoredBox(color: c.bgElevated),
      ),
    );

    if (reduceMotion) return base;

    final band = nixtOpacity(c.bgAccented, 0.6);
    return ClipRRect(
      borderRadius: borderRadius,
      child: SizedBox(
        width: width,
        height: height,
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            return ShaderMask(
              blendMode: BlendMode.srcATop,
              shaderCallback: (rect) {
                final dx = (controller.value * 2 - 1) * rect.width;
                return LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    const Color(0x00000000),
                    band,
                    const Color(0x00000000),
                  ],
                ).createShader(
                  Rect.fromLTWH(dx, 0, rect.width, rect.height),
                );
              },
              child: ColoredBox(color: c.bgElevated),
            );
          },
        ),
      ),
    );
  }
}
