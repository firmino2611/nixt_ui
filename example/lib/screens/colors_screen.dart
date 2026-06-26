import 'package:flutter/material.dart';
import 'package:nixt_ui/nixt_ui.dart';

import '../gallery_controls.dart';
import '../widgets/gallery_scaffold.dart';

/// Playground for the DS palette engine: pick a seed color for a role, watch
/// the full 50→950 scale generate around it (seed = shade 500), optionally
/// override a single shade, then apply it to the whole gallery live.
class ColorsScreen extends StatefulWidget {
  /// Creates the colors screen.
  const ColorsScreen({super.key});

  @override
  State<ColorsScreen> createState() => _ColorsScreenState();
}

class _ColorsScreenState extends State<ColorsScreen> {
  static const _steps = NixtShade.values;

  // Roles a user would realistically retheme from a brand color.
  static const _roles = [
    ('Primary', NixtColorRole.primary),
    ('Secondary', NixtColorRole.secondary),
    ('Success', NixtColorRole.success),
    ('Info', NixtColorRole.info),
    ('Warning', NixtColorRole.warning),
    ('Error', NixtColorRole.error),
  ];

  NixtColorRole _role = NixtColorRole.primary;
  double _hue = 265; // violet by default
  bool _override = false;

  /// Seed (shade 500) derived from the hue slider.
  Color get _seed => HSVColor.fromAHSV(1, _hue, 0.72, 0.88).toColor();

  /// A deep, punchy override for shade 900 (demonstrates per-shade overrides).
  Color get _override900 => HSVColor.fromAHSV(1, _hue, 0.85, 0.30).toColor();

  /// The role config under test — seed + optional shade override.
  NixtRoleColor get _config => NixtRoleColor(
        _seed,
        shades: _override ? {NixtShade.s900: _override900} : null,
      );

  String _hex(Color c) =>
      '#${c.toARGB32().toRadixString(16).substring(2).toUpperCase()}';

  Color _on(Color bg) =>
      bg.computeLuminance() > 0.5 ? const Color(0xFF18181B) : const Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    final controls = GalleryControls.of(context);
    final c = context.nixt.colors;
    final scale = _config.scale;

    return GalleryScaffold(
      title: 'Colors',
      showBack: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GallerySection(
            title: 'Role',
            child: NixtTabs<NixtColorRole>(
              value: _role,
              onChanged: (v) => setState(() => _role = v),
              items: [
                for (final (label, role) in _roles)
                  NixtTabItem(label: label, value: role),
              ],
            ),
          ),
          GallerySection(
            title: 'Seed color — becomes shade 500',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: _seed,
                        borderRadius: context.nixt.radius.brMd,
                        border: Border.all(color: c.border),
                      ),
                    ),
                    const SizedBox(width: NixtSpacing.s3),
                    Text(
                      _hex(_seed),
                      style: const TextStyle(
                        fontFamily: NixtTypography.fontMono,
                        fontSize: NixtTypography.textSm,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: NixtSpacing.s3),
                NixtSlider(
                  value: _hue,
                  min: 0,
                  max: 360,
                  label: 'Hue',
                  onChanged: (v) => setState(() => _hue = v),
                ),
                NixtSwitch(
                  value: _override,
                  label: 'Override shade 900',
                  onChanged: (v) => setState(() => _override = v),
                ),
              ],
            ),
          ),
          GallerySection(
            title: 'Generated scale',
            child: Column(
              children: [
                for (final step in _steps)
                  _ScaleRow(
                    step: step.value,
                    color: scale.shade(step),
                    hex: _hex(scale.shade(step)),
                    on: _on(scale.shade(step)),
                    isSeed: step == NixtShade.s500,
                    isOverride: _override && step == NixtShade.s900,
                  ),
              ],
            ),
          ),
          GallerySection(
            title: 'Apply to the whole gallery',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                NixtButton(
                  label: 'Apply to ${_role.name}',
                  color: _role,
                  onPressed: () => controls.setRoleScale(_role, scale),
                ),
                const SizedBox(height: NixtSpacing.s2),
                NixtButton(
                  label: 'Reset ${_role.name}',
                  variant: NixtVariant.soft,
                  color: NixtColorRole.neutral,
                  onPressed: () => controls.setRoleScale(_role, null),
                ),
              ],
            ),
          ),
          GallerySection(
            title: 'Live components (read the applied theme)',
            child: Wrap(
              spacing: NixtSpacing.s2,
              runSpacing: NixtSpacing.s2,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                NixtButton(label: 'Solid', color: _role, onPressed: () {}),
                NixtButton(
                  label: 'Soft',
                  color: _role,
                  variant: NixtVariant.soft,
                  onPressed: () {},
                ),
                NixtBadge(label: 'Badge', color: _role),
                NixtBadge(label: 'Soft', color: _role, variant: NixtVariant.soft),
                NixtChipIndicator(
                  text: '5',
                  color: _role,
                  child: const NixtIcon(NixtIcons.bell, size: 26),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One row of the scale preview: the swatch, its step label, and hex.
class _ScaleRow extends StatelessWidget {
  const _ScaleRow({
    required this.step,
    required this.color,
    required this.hex,
    required this.on,
    required this.isSeed,
    required this.isOverride,
  });

  final int step;
  final Color color;
  final String hex;
  final Color on;
  final bool isSeed;
  final bool isOverride;

  @override
  Widget build(BuildContext context) {
    final t = context.nixt;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: NixtSpacing.s3),
        decoration: BoxDecoration(color: color, borderRadius: t.radius.brSm),
        child: Row(
          children: [
            Text(
              '$step',
              style: TextStyle(
                fontFamily: NixtTypography.fontMono,
                fontWeight: NixtTypography.weightBold,
                fontSize: NixtTypography.textSm,
                color: on,
              ),
            ),
            if (isSeed) ...[
              const SizedBox(width: NixtSpacing.s2),
              _Tag('seed', on),
            ],
            if (isOverride) ...[
              const SizedBox(width: NixtSpacing.s2),
              _Tag('override', on),
            ],
            const Spacer(),
            Text(
              hex,
              style: TextStyle(
                fontFamily: NixtTypography.fontMono,
                fontSize: NixtTypography.textXs,
                color: on,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag(this.label, this.on);
  final String label;
  final Color on;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        border: Border.all(color: on),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: NixtTypography.fontMono,
          fontSize: NixtTypography.text2xs,
          color: on,
        ),
      ),
    );
  }
}
