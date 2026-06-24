import 'package:flutter/widgets.dart';

import '../../tokens/color_roles.dart';
import '../navigation/nixt_page_indicator.dart';

/// A swipeable, full-width horizontal carousel with synced page dots.
///
/// Each entry in [slides] is one page. The active dot tracks the swipe and,
/// when tapped, animates to that page.
///
/// ```dart
/// NixtCarousel(
///   height: 180,
///   slides: [for (final img in images) Image.network(img, fit: BoxFit.cover)],
/// );
/// ```
class NixtCarousel extends StatefulWidget {
  /// Creates a carousel.
  const NixtCarousel({
    required this.slides,
    this.showDots = true,
    this.color = NixtColorRole.primary,
    this.height,
    super.key,
  });

  /// The pages, each shown full-width.
  final List<Widget> slides;

  /// Whether to show synced page dots below the track. Defaults to `true`.
  final bool showDots;

  /// Dot color role. Defaults to `primary`.
  final NixtColorRole color;

  /// Fixed track height. When null the track sizes to the tallest slide via its
  /// parent constraints (wrap it in a sized box if unbounded).
  final double? height;

  @override
  State<NixtCarousel> createState() => _NixtCarouselState();
}

class _NixtCarouselState extends State<NixtCarousel> {
  final PageController _controller = PageController();
  int _active = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goto(int i) => _controller.animateToPage(
        i,
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );

  @override
  Widget build(BuildContext context) {
    final track = SizedBox(
      height: widget.height,
      child: PageView(
        controller: _controller,
        onPageChanged: (i) => setState(() => _active = i),
        children: widget.slides,
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        widget.height != null ? track : Expanded(child: track),
        if (widget.showDots && widget.slides.length > 1)
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: NixtPageIndicator(
              count: widget.slides.length,
              active: _active,
              color: widget.color,
              onDotClick: _goto,
            ),
          ),
      ],
    );
  }
}
