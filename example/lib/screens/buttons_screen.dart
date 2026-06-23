import 'package:flutter/material.dart';
import 'package:nixt_ui/nixt_ui.dart';

import '../widgets/gallery_scaffold.dart';

/// Showcase for [NixtButton] — variants, sizes, and states. Use the theme
/// configurator (sliders icon, top-right) to recolor everything live.
class ButtonsScreen extends StatelessWidget {
  /// Creates the buttons screen.
  const ButtonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.nixt.colors;
    return GalleryScaffold(
      title: 'Buttons',
      showBack: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GallerySection(
            title: 'Variants × colors',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final v in NixtVariant.values) ...[
                  Padding(
                    padding: const EdgeInsets.only(
                      top: NixtSpacing.s2,
                      bottom: NixtSpacing.s1,
                    ),
                    child: Text(
                      v.name,
                      style: TextStyle(
                        fontFamily: NixtTypography.fontMono,
                        fontSize: NixtTypography.textXs,
                        color: c.textMuted,
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: NixtSpacing.s2,
                    runSpacing: NixtSpacing.s2,
                    children: [
                      for (final role in NixtColorRole.values)
                        NixtButton(
                          label: role.name,
                          color: role,
                          variant: v,
                          size: NixtButtonSize.sm,
                          onPressed: () {},
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          GallerySection(
            title: 'Sizes',
            child: Wrap(
              spacing: NixtSpacing.s2,
              runSpacing: NixtSpacing.s2,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                for (final s in NixtButtonSize.values)
                  NixtButton(
                    label: s.name,
                    size: s,
                    icon: NixtIcons.star,
                    onPressed: () {},
                  ),
              ],
            ),
          ),
          GallerySection(
            title: 'Icon buttons',
            child: Wrap(
              spacing: NixtSpacing.s2,
              runSpacing: NixtSpacing.s2,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                NixtIconButton(
                    icon: NixtIcons.heart, label: 'Like', onPressed: () {}),
                NixtIconButton(
                  icon: NixtIcons.share,
                  label: 'Share',
                  variant: NixtVariant.soft,
                  onPressed: () {},
                ),
                NixtIconButton(
                  icon: NixtIcons.trash,
                  label: 'Delete',
                  color: NixtColorRole.error,
                  variant: NixtVariant.soft,
                  onPressed: () {},
                ),
                NixtIconButton(
                  icon: NixtIcons.settings,
                  label: 'Settings',
                  variant: NixtVariant.outline,
                  onPressed: () {},
                ),
                const NixtIconButton(
                  icon: NixtIcons.lock,
                  label: 'Locked',
                ),
              ],
            ),
          ),
          GallerySection(
            title: 'Floating action buttons',
            child: Wrap(
              spacing: NixtSpacing.s4,
              runSpacing: NixtSpacing.s4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                NixtFab(
                    icon: NixtIcons.plus,
                    size: NixtFabSize.sm,
                    onPressed: () {}),
                NixtFab(icon: NixtIcons.plus, onPressed: () {}),
                NixtFab(
                    icon: NixtIcons.plus,
                    size: NixtFabSize.lg,
                    onPressed: () {}),
                NixtFab(
                  icon: NixtIcons.pencil,
                  label: 'Compose',
                  color: NixtColorRole.secondary,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          GallerySection(
            title: 'States',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NixtButton(
                  label: 'Block CTA',
                  icon: NixtIcons.send,
                  block: true,
                  onPressed: () {},
                ),
                const SizedBox(height: NixtSpacing.s2),
                Wrap(
                  spacing: NixtSpacing.s2,
                  runSpacing: NixtSpacing.s2,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    NixtButton(
                        label: 'Loading', loading: true, onPressed: () {}),
                    const NixtButton(label: 'Disabled'),
                    NixtButton(
                      label: 'Trailing',
                      trailingIcon: NixtIcons.chevronRight,
                      variant: NixtVariant.soft,
                      onPressed: () {},
                    ),
                    NixtButton(
                      label: 'Link',
                      variant: NixtVariant.link,
                      onPressed: () {},
                    ),
                    NixtButton(
                      icon: NixtIcons.heart,
                      color: NixtColorRole.error,
                      variant: NixtVariant.soft,
                      square: true,
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
