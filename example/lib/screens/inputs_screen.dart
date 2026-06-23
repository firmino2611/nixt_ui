import 'package:flutter/material.dart';
import 'package:nixt_ui/nixt_ui.dart';

import '../widgets/gallery_scaffold.dart';

/// Showcase for the text-field family — Input, Textarea, Select.
class InputsScreen extends StatefulWidget {
  /// Creates the inputs screen.
  const InputsScreen({super.key});

  @override
  State<InputsScreen> createState() => _InputsScreenState();
}

class _InputsScreenState extends State<InputsScreen> {
  String? _priority;
  List<String> _tags = [];
  final bool _obscure = true;
  double _volume = 60;
  int _qty = 2;
  int _stars = 3;
  String _pin = '';
  final TextEditingController _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GalleryScaffold(
      title: 'Inputs',
      showBack: true,
      showNeutralSwitcher: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GallerySection(
            title: 'Variants',
            child: Column(
              children: [
                for (final v in NixtFieldVariant.values)
                  Padding(
                    padding: const EdgeInsets.only(bottom: NixtSpacing.s3),
                    child: NixtInput(
                      hintText: v.name,
                      icon: NixtIcons.search,
                      variant: v,
                    ),
                  ),
              ],
            ),
          ),
          GallerySection(
            title: 'Sizes',
            child: Column(
              children: [
                for (final s in NixtFieldSize.values)
                  Padding(
                    padding: const EdgeInsets.only(bottom: NixtSpacing.s3),
                    child: NixtInput(hintText: s.name, size: s),
                  ),
              ],
            ),
          ),
          GallerySection(
            title: 'With icons, password & error',
            child: Column(
              children: [
                const NixtInput(
                  hintText: 'you@example.com',
                  icon: NixtIcons.mail,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: NixtSpacing.s3),
                NixtInput(
                  hintText: 'Password',
                  icon: NixtIcons.lock,
                  obscureText: _obscure,
                  trailingIcon: _obscure ? NixtIcons.eye : NixtIcons.eyeOff,
                  key: const ValueKey('password'),
                ),
                const SizedBox(height: NixtSpacing.s3),
                const NixtInput(
                  hintText: 'Invalid field',
                  icon: NixtIcons.user,
                  errorText: 'This field is required',
                ),
                const SizedBox(height: NixtSpacing.s3),
                const NixtInput(hintText: 'Disabled', enabled: false),
              ],
            ),
          ),
          GallerySection(
            title: 'Select',
            child: NixtSelect(
              placeholder: 'Choose priority',
              icon: NixtIcons.filter,
              value: _priority,
              items: const [
                NixtSelectItem(label: 'Low', value: 'low'),
                NixtSelectItem(label: 'Medium', value: 'medium'),
                NixtSelectItem(label: 'High', value: 'high'),
                NixtSelectItem(
                    label: 'Urgent (disabled)',
                    value: 'urgent',
                    disabled: true),
              ],
              onChanged: (v) => setState(() => _priority = v),
            ),
          ),
          GallerySection(
            title: 'Multi-select',
            child: NixtMultiSelect(
              placeholder: 'Pick tags',
              icon: NixtIcons.target,
              values: _tags,
              items: const [
                NixtSelectItem(label: 'Bug', value: 'bug'),
                NixtSelectItem(label: 'Feature', value: 'feature'),
                NixtSelectItem(label: 'Docs', value: 'docs'),
                NixtSelectItem(label: 'Design', value: 'design'),
                NixtSelectItem(
                    label: 'Chore (disabled)', value: 'chore', disabled: true),
              ],
              onChanged: (v) => setState(() => _tags = v),
            ),
          ),
          GallerySection(
            title: 'Search bar',
            child: Column(
              children: [
                // Default — identical shell to the inputs above.
                NixtSearchBar(controller: _search, onChanged: (_) {}),
                const SizedBox(height: NixtSpacing.s3),
                // Pill — adjustable border radius.
                NixtSearchBar(
                  hintText: 'Pill, with cancel',
                  borderRadius: BorderRadius.circular(999),
                  showCancel: true,
                ),
                const SizedBox(height: NixtSpacing.s3),
                const NixtSearchBar(
                    hintText: 'Soft', variant: NixtFieldVariant.soft),
              ],
            ),
          ),
          GallerySection(
            title: 'Slider',
            child: NixtSlider(
              value: _volume,
              label: 'Volume',
              showValue: true,
              onChanged: (v) => setState(() => _volume = v),
            ),
          ),
          GallerySection(
            title: 'Stepper',
            child: Row(
              children: [
                NixtStepper(
                  value: _qty,
                  min: 0,
                  max: 10,
                  onChanged: (v) => setState(() => _qty = v),
                ),
                const SizedBox(width: NixtSpacing.s6),
                NixtStepper(
                  value: _qty,
                  suffix: 'kg',
                  color: NixtColorRole.primary,
                  onChanged: (v) => setState(() => _qty = v),
                ),
              ],
            ),
          ),
          GallerySection(
            title: 'Rating',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NixtRating(
                  value: _stars.toDouble(),
                  showValue: true,
                  onChanged: (v) => setState(() => _stars = v),
                ),
                const SizedBox(height: NixtSpacing.s3),
                const NixtRating(value: 4.5, readOnly: true),
              ],
            ),
          ),
          GallerySection(
            title: 'PIN input',
            child: NixtPinInput(
              length: 4,
              value: _pin,
              onChanged: (v) => setState(() => _pin = v),
            ),
          ),
          const GallerySection(
            title: 'Textarea',
            child: NixtTextarea(
              hintText: 'Write a note…',
              rows: 4,
            ),
          ),
        ],
      ),
    );
  }
}
