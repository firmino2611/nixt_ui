import 'package:flutter/material.dart';
import 'package:nixt_ui/nixt_ui.dart';

import '../gallery_controls.dart';

/// Named color presets offered by the brand-color pickers.
const List<({String name, Color? seed})> kColorPresets = [
  (name: 'default', seed: null),
  (name: 'violet', seed: Color(0xFF8B5CF6)),
  (name: 'orange', seed: Color(0xFFF97316)),
  (name: 'pink', seed: Color(0xFFEC4899)),
  (name: 'sky', seed: Color(0xFF0EA5E9)),
  (name: 'rose', seed: Color(0xFFF43F5E)),
  (name: 'teal', seed: Color(0xFF14B8A6)),
  (name: 'amber', seed: Color(0xFFF59E0B)),
];

/// A labelled row of color swatches that overrides one brand [role] globally.
class RoleColorPicker extends StatelessWidget {
  /// Creates a role color picker.
  const RoleColorPicker({required this.role, required this.label, super.key});

  /// The role to override.
  final NixtColorRole role;

  /// Display label.
  final String label;

  @override
  Widget build(BuildContext context) {
    final controls = GalleryControls.of(context);
    final c = context.nixt.colors;
    final current = controls.roles[role]?.s500;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: NixtTypography.fontMono,
            fontSize: NixtTypography.textXs,
            color: c.textMuted,
          ),
        ),
        const SizedBox(height: NixtSpacing.s2),
        Wrap(
          spacing: NixtSpacing.s2,
          runSpacing: NixtSpacing.s2,
          children: [
            for (final p in kColorPresets)
              _Swatch(
                color: p.seed ?? NixtRoleScales.of(role).s500,
                selected: p.seed == null ? current == null : current == p.seed,
                onTap: () => controls.setRole(role, p.seed),
              ),
          ],
        ),
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch(
      {required this.color, required this.selected, required this.onTap});

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.nixt.colors;
    return NixtPressScale(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? c.textHighlighted : c.border,
            width: selected ? 3 : 1,
          ),
        ),
        child: selected
            ? const Icon(NixtIcons.check, size: 18, color: Color(0xFFFFFFFF))
            : null,
      ),
    );
  }
}
