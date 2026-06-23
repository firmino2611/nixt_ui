import 'package:flutter/material.dart';
import 'package:nixt_ui/nixt_ui.dart';

import '../widgets/gallery_scaffold.dart';

/// Showcase for the overlay family — Sheet, ActionSheet, Dialog, Menu.
class OverlaysScreen extends StatelessWidget {
  /// Creates the overlays screen.
  const OverlaysScreen({super.key});

  void _openSheet(BuildContext context) {
    showNixtSheet(
      context: context,
      title: 'Filters',
      footer: NixtButton(
        label: 'Apply',
        block: true,
        onPressed: () => Navigator.of(context).pop(),
      ),
      builder: (_) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final s in [
            'Newest',
            'Price: low to high',
            'Price: high to low',
            'Top rated'
          ])
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Text(s, style: const TextStyle(fontSize: 16)),
            ),
          const SizedBox(height: 8),
          const Text(
            'A bottom sheet slides up over a scrim. Drag the handle or tap '
            'outside to dismiss.',
            style: TextStyle(fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  Future<void> _openActionSheet(
      BuildContext context, NixtActionSheetVariant variant) async {
    final messenger = ScaffoldMessenger.of(context);
    final i = await showNixtActionSheet(
      context: context,
      variant: variant,
      title: 'Photo',
      message: 'Choose how to add a photo',
      actions: [
        const NixtSheetAction(
            label: 'Take Photo', icon: NixtIcons.camera, bold: true),
        const NixtSheetAction(
            label: 'Choose from Library', icon: NixtIcons.image),
        const NixtSheetAction(
            label: 'Delete', icon: NixtIcons.trash, destructive: true),
      ],
    );
    if (i != null) {
      messenger.showSnackBar(SnackBar(content: Text('Action $i')));
    }
  }

  void _openDialog(BuildContext context) {
    showNixtDialog(
      context: context,
      icon: NixtIcons.trash,
      color: NixtColorRole.error,
      title: 'Delete project?',
      description: 'This permanently removes the project and all of its files. '
          'This action cannot be undone.',
      actions: [
        NixtButton(
          label: 'Delete',
          color: NixtColorRole.error,
          block: true,
          onPressed: () => Navigator.of(context).pop(),
        ),
        NixtButton(
          label: 'Cancel',
          variant: NixtVariant.ghost,
          color: NixtColorRole.neutral,
          block: true,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GalleryScaffold(
      title: 'Overlays',
      showBack: true,
      showNeutralSwitcher: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GallerySection(
            title: 'Bottom sheet',
            child: NixtButton(
              label: 'Open sheet',
              icon: NixtIcons.filter,
              onPressed: () => _openSheet(context),
            ),
          ),
          GallerySection(
            title: 'Action sheet',
            child: Row(
              children: [
                NixtButton(
                  label: 'iOS',
                  variant: NixtVariant.soft,
                  onPressed: () =>
                      _openActionSheet(context, NixtActionSheetVariant.ios),
                ),
                const SizedBox(width: NixtSpacing.s3),
                NixtButton(
                  label: 'Material',
                  variant: NixtVariant.soft,
                  color: NixtColorRole.neutral,
                  onPressed: () => _openActionSheet(
                      context, NixtActionSheetVariant.material),
                ),
              ],
            ),
          ),
          GallerySection(
            title: 'Dialog',
            child: NixtButton(
              label: 'Confirm delete',
              color: NixtColorRole.error,
              variant: NixtVariant.soft,
              onPressed: () => _openDialog(context),
            ),
          ),
          const GallerySection(
            title: 'Menu',
            child: Row(
              children: [
                Text('Overflow actions', style: TextStyle(fontSize: 16)),
                Spacer(),
                NixtMenu(
                  trigger: Padding(
                    padding: EdgeInsets.all(8),
                    child: NixtIcon(NixtIcons.moreVertical, size: 22),
                  ),
                  items: [
                    NixtMenuItem(label: 'Edit', icon: NixtIcons.pencil),
                    NixtMenuItem(label: 'Share', icon: NixtIcons.share),
                    NixtMenuItem.separator(),
                    NixtMenuItem(
                        label: 'Delete',
                        icon: NixtIcons.trash,
                        destructive: true),
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
