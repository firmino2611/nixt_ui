import 'package:flutter/material.dart';
import 'package:nixt_ui/nixt_ui.dart';

import '../widgets/gallery_scaffold.dart';

/// Showcase for the toggle controls — Checkbox, Radio, Switch.
class TogglesScreen extends StatefulWidget {
  /// Creates the toggles screen.
  const TogglesScreen({super.key});

  @override
  State<TogglesScreen> createState() => _TogglesScreenState();
}

class _TogglesScreenState extends State<TogglesScreen> {
  bool _terms = true;
  bool _newsletter = false;
  String _plan = 'pro';
  bool _notifications = true;
  bool _wifi = false;

  @override
  Widget build(BuildContext context) {
    return GalleryScaffold(
      title: 'Toggles',
      showBack: true,
      showNeutralSwitcher: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GallerySection(
            title: 'Checkbox',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NixtCheckbox(
                  value: _terms,
                  label: 'I accept the terms',
                  description: 'You agree to the service agreement.',
                  onChanged: (v) => setState(() => _terms = v),
                ),
                const SizedBox(height: NixtSpacing.s4),
                NixtCheckbox(
                  value: _newsletter,
                  label: 'Subscribe to newsletter',
                  color: NixtColorRole.secondary,
                  onChanged: (v) => setState(() => _newsletter = v),
                ),
                const SizedBox(height: NixtSpacing.s4),
                const NixtCheckbox(
                    value: true, label: 'Disabled checked', enabled: false),
              ],
            ),
          ),
          GallerySection(
            title: 'Checkbox sizes',
            child: Row(
              children: [
                for (final s in NixtControlSize.values) ...[
                  NixtCheckbox(value: true, size: s, onChanged: (_) {}),
                  const SizedBox(width: NixtSpacing.s4),
                ],
              ],
            ),
          ),
          GallerySection(
            title: 'Radio group',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final p in const [
                  ('free', 'Free', 'Up to 3 projects.'),
                  ('pro', 'Pro', 'Unlimited projects.'),
                  ('team', 'Team', 'Shared workspaces.'),
                ]) ...[
                  NixtRadio<String>(
                    value: p.$1,
                    groupValue: _plan,
                    label: p.$2,
                    description: p.$3,
                    onChanged: (v) => setState(() => _plan = v),
                  ),
                  const SizedBox(height: NixtSpacing.s4),
                ],
              ],
            ),
          ),
          GallerySection(
            title: 'Switch — settings rows',
            child: Column(
              children: [
                NixtSwitch(
                  value: _notifications,
                  label: 'Notifications',
                  description: 'Push alerts on this device.',
                  onChanged: (v) => setState(() => _notifications = v),
                ),
                const SizedBox(height: NixtSpacing.s4),
                NixtSwitch(
                  value: _wifi,
                  label: 'Wi-Fi only downloads',
                  color: NixtColorRole.success,
                  onChanged: (v) => setState(() => _wifi = v),
                ),
                const SizedBox(height: NixtSpacing.s4),
                const NixtSwitch(
                    value: true, label: 'Disabled', enabled: false),
              ],
            ),
          ),
          GallerySection(
            title: 'Switch sizes',
            child: Row(
              children: [
                for (final s in NixtControlSize.values) ...[
                  NixtSwitch(value: true, size: s, onChanged: (_) {}),
                  const SizedBox(width: NixtSpacing.s4),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
