import 'package:flutter/material.dart';

import '../../theme/nixt_theme.dart';
import '../../tokens/typography_tokens.dart';

/// The dark scrim painted behind overlay surfaces (slate-950 @ 45%).
const Color kNixtScrim = Color(0x73020617);

/// Bottom sheet surface — the core mobile modal. A rounded top card with an
/// optional grab [handle], a centered [title], a scrollable body, and a pinned
/// [footer] (divided, safe-area padded).
///
/// Usually shown via [showNixtSheet], but can be embedded directly.
///
/// ```dart
/// showNixtSheet(
///   context: context,
///   title: 'Filters',
///   builder: (_) => const FiltersForm(),
///   footer: NixtButton(label: 'Apply', block: true, onPressed: ...),
/// );
/// ```
class NixtSheet extends StatelessWidget {
  /// Creates a sheet surface.
  const NixtSheet({
    required this.child,
    this.title,
    this.footer,
    this.showHandle = true,
    this.onHandleTap,
    this.maxHeightFraction = 0.88,
    super.key,
  });

  /// Body content.
  final Widget child;

  /// Centered title.
  final String? title;

  /// Pinned footer (e.g. a primary button).
  final Widget? footer;

  /// Show the grab handle. Defaults to true.
  final bool showHandle;

  /// Tapping the handle calls this (usually pops the sheet).
  final VoidCallback? onHandleTap;

  /// Max height as a fraction of the screen. Defaults to 0.88.
  final double maxHeightFraction;

  @override
  Widget build(BuildContext context) {
    final t = NixtTheme.of(context);
    final c = t.colors;
    final media = MediaQuery.of(context);
    final radius = Radius.circular(t.radius.xxl);

    return Container(
      constraints: BoxConstraints(
        maxHeight: media.size.height * maxHeightFraction,
      ),
      decoration: BoxDecoration(
        color: c.bg,
        borderRadius: BorderRadius.only(topLeft: radius, topRight: radius),
        boxShadow: t.shadows.sheet,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showHandle)
            GestureDetector(
              onTap: onHandleTap,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 36,
                height: 5,
                margin: const EdgeInsets.only(top: 8, bottom: 2),
                decoration: BoxDecoration(
                  color: c.bgAccented,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Text(
                title!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: NixtTypography.fontSans,
                  fontSize: NixtTypography.textLg,
                  fontWeight: FontWeight.w700,
                  color: c.textHighlighted,
                ),
              ),
            ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              child: child,
            ),
          ),
          if (footer != null)
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(
                  20, 12, 20, 16 + media.viewPadding.bottom * 0.3),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: c.border)),
              ),
              child: footer,
            ),
        ],
      ),
    );
  }
}

/// Shows a [NixtSheet] as a modal bottom sheet that slides up over a scrim.
/// Returns whatever the sheet is popped with.
Future<T?> showNixtSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  String? title,
  Widget? footer,
  bool showHandle = true,
  bool isDismissible = true,
  double maxHeightFraction = 0.88,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    isDismissible: isDismissible,
    enableDrag: showHandle,
    backgroundColor: const Color(0x00000000),
    barrierColor: kNixtScrim,
    elevation: 0,
    builder: (ctx) => NixtSheet(
      title: title,
      footer: footer,
      showHandle: showHandle,
      onHandleTap: () => Navigator.of(ctx).maybePop(),
      maxHeightFraction: maxHeightFraction,
      child: Builder(builder: builder),
    ),
  );
}
