import 'package:flutter/material.dart';
import 'package:nixt_ui/nixt_ui.dart';

import '../gallery_controls.dart';
import 'theme_config_sheet.dart';

/// Shared screen chrome for the gallery: a top bar with an optional back
/// button, the title, a light/dark toggle, and (optionally) the neutral-palette
/// switcher. The body scrolls.
class GalleryScaffold extends StatelessWidget {
  /// Creates a gallery screen.
  const GalleryScaffold({
    required this.title,
    required this.body,
    this.showBack = false,
    this.showNeutralSwitcher = false,
    this.scrollable = true,
    super.key,
  });

  /// Screen title.
  final String title;

  /// Screen content.
  final Widget body;

  /// Whether to show a back button.
  final bool showBack;

  /// Whether to show the neutral-palette switcher row.
  final bool showNeutralSwitcher;

  /// Whether to wrap [body] in a scroll view (off for screens that scroll
  /// internally, e.g. a lazy grid).
  final bool scrollable;

  @override
  Widget build(BuildContext context) {
    final controls = GalleryControls.of(context);
    final c = context.nixt.colors;

    return Scaffold(
      backgroundColor: c.bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: NixtSpacing.screenGutter,
                vertical: NixtSpacing.s3,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (showBack)
                        Padding(
                          padding: const EdgeInsets.only(right: NixtSpacing.s2),
                          child: NixtButton(
                            icon: NixtIcons.arrowLeft,
                            color: NixtColorRole.neutral,
                            variant: NixtVariant.ghost,
                            square: true,
                            size: NixtButtonSize.sm,
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontFamily: NixtTypography.fontSans,
                            fontWeight: NixtTypography.weightBold,
                            fontSize: NixtTypography.textXl,
                            color: c.textHighlighted,
                          ),
                        ),
                      ),
                      NixtButton(
                        icon: controls.isDark ? NixtIcons.sun : NixtIcons.moon,
                        color: NixtColorRole.neutral,
                        variant: NixtVariant.soft,
                        square: true,
                        size: NixtButtonSize.sm,
                        onPressed: controls.toggleBrightness,
                      ),
                      const SizedBox(width: NixtSpacing.s2),
                      NixtButton(
                        icon: NixtIcons.slidersHorizontal,
                        color: NixtColorRole.neutral,
                        variant: NixtVariant.soft,
                        square: true,
                        size: NixtButtonSize.sm,
                        onPressed: () => showThemeConfig(context),
                      ),
                    ],
                  ),
                  if (showNeutralSwitcher) ...[
                    const SizedBox(height: NixtSpacing.s3),
                    Wrap(
                      spacing: NixtSpacing.s2,
                      children: [
                        for (final n in NixtNeutral.values)
                          NixtButton(
                            label: n.name,
                            size: NixtButtonSize.xs,
                            color: NixtColorRole.neutral,
                            variant: n == controls.neutral
                                ? NixtVariant.solid
                                : NixtVariant.outline,
                            onPressed: () => controls.setNeutral(n),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Divider(height: 1, color: c.border),
            Expanded(
              child: scrollable
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.all(NixtSpacing.screenGutter),
                      child: body,
                    )
                  : body,
            ),
          ],
        ),
      ),
    );
  }
}

/// A titled block within a screen.
class GallerySection extends StatelessWidget {
  /// Creates a section.
  const GallerySection({required this.title, required this.child, super.key});

  /// Section heading.
  final String title;

  /// Section content.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.nixt.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: NixtSpacing.s8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: NixtTypography.fontSans,
              fontWeight: NixtTypography.weightSemibold,
              fontSize: NixtTypography.textLg,
              color: c.textHighlighted,
            ),
          ),
          const SizedBox(height: NixtSpacing.s3),
          child,
        ],
      ),
    );
  }
}
