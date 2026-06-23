import 'package:flutter/material.dart';
import 'package:nixt_ui/nixt_ui.dart';

import '../gallery_controls.dart';
import 'role_color_picker.dart';

/// Opens the global theme configurator as a modal bottom sheet. Changes apply
/// live across every screen via [GalleryControls].
Future<void> showThemeConfig(BuildContext context) {
  final t = NixtTheme.of(context);
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: t.colors.bg,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(t.radius.xl)),
    ),
    builder: (_) => const _ThemeConfigSheet(),
  );
}

class _ThemeConfigSheet extends StatelessWidget {
  const _ThemeConfigSheet();

  static const List<({NixtColorRole role, String label})> _roles = [
    (role: NixtColorRole.primary, label: 'primary'),
    (role: NixtColorRole.secondary, label: 'secondary'),
    (role: NixtColorRole.success, label: 'success'),
    (role: NixtColorRole.info, label: 'info'),
    (role: NixtColorRole.warning, label: 'warning'),
    (role: NixtColorRole.error, label: 'error'),
  ];

  static const List<({String label, double base})> _radii = [
    (label: 'sharp', base: 0),
    (label: 'default', base: 8),
    (label: 'round', base: 14),
    (label: 'pill', base: 20),
  ];

  @override
  Widget build(BuildContext context) {
    final controls = GalleryControls.of(context);
    final c = context.nixt.colors;

    Widget heading(String s) => Padding(
          padding: const EdgeInsets.only(
              top: NixtSpacing.s5, bottom: NixtSpacing.s2),
          child: Text(
            s,
            style: TextStyle(
              fontFamily: NixtTypography.fontSans,
              fontWeight: NixtTypography.weightSemibold,
              fontSize: NixtTypography.textBase,
              color: c.textHighlighted,
            ),
          ),
        );

    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            NixtSpacing.screenGutter,
            NixtSpacing.s3,
            NixtSpacing.screenGutter,
            NixtSpacing.s6,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Grab handle.
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: c.borderAccented,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: NixtSpacing.s4),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Theme',
                      style: TextStyle(
                        fontFamily: NixtTypography.fontSans,
                        fontWeight: NixtTypography.weightBold,
                        fontSize: NixtTypography.textXl,
                        color: c.textHighlighted,
                      ),
                    ),
                  ),
                  NixtButton(
                    label: 'Reset',
                    icon: NixtIcons.x,
                    size: NixtButtonSize.sm,
                    color: NixtColorRole.neutral,
                    variant: NixtVariant.soft,
                    onPressed: () {
                      controls.resetTheme();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),

              heading('Appearance'),
              Wrap(
                spacing: NixtSpacing.s2,
                children: [
                  NixtButton(
                    label: 'light',
                    icon: NixtIcons.sun,
                    size: NixtButtonSize.sm,
                    color: NixtColorRole.neutral,
                    variant: controls.isDark
                        ? NixtVariant.outline
                        : NixtVariant.solid,
                    onPressed:
                        controls.isDark ? controls.toggleBrightness : null,
                  ),
                  NixtButton(
                    label: 'dark',
                    icon: NixtIcons.moon,
                    size: NixtButtonSize.sm,
                    color: NixtColorRole.neutral,
                    variant: controls.isDark
                        ? NixtVariant.solid
                        : NixtVariant.outline,
                    onPressed:
                        controls.isDark ? null : controls.toggleBrightness,
                  ),
                ],
              ),

              heading('Neutral palette'),
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

              heading('Radius'),
              Wrap(
                spacing: NixtSpacing.s2,
                children: [
                  for (final r in _radii)
                    NixtButton(
                      label: r.label,
                      size: NixtButtonSize.xs,
                      color: NixtColorRole.neutral,
                      variant: controls.radiusBase == r.base
                          ? NixtVariant.solid
                          : NixtVariant.outline,
                      onPressed: () => controls.setRadius(r.base),
                    ),
                ],
              ),

              heading('Brand & status colors'),
              for (final r in _roles)
                Padding(
                  padding: const EdgeInsets.only(bottom: NixtSpacing.s3),
                  child: RoleColorPicker(role: r.role, label: r.label),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
