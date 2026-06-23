import 'package:flutter/material.dart';
import 'package:nixt_ui/nixt_ui.dart';

import '../widgets/gallery_scaffold.dart';

/// Showcase for the feedback family — Alert, Toast, Skeleton, EmptyState.
class FeedbackScreen extends StatelessWidget {
  /// Creates the feedback screen.
  const FeedbackScreen({super.key});

  void _showToast(BuildContext context, NixtToastVariant variant) {
    final overlay = Overlay.of(context);
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => Positioned(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(ctx).viewPadding.bottom + 24,
        child: SafeArea(
          top: false,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: NixtToast(
              variant: variant,
              icon: NixtIcons.checkCircle,
              color: NixtColorRole.success,
              title: 'Saved',
              message: 'Your changes are stored.',
              action: variant == NixtToastVariant.material ? 'Undo' : null,
              onAction: () => entry.remove(),
              onClose: () => entry.remove(),
            ),
          ),
        ),
      ),
    );
    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 3), () {
      if (entry.mounted) entry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GalleryScaffold(
      title: 'Feedback',
      showBack: true,
      showNeutralSwitcher: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GallerySection(
            title: 'Alert colors',
            child: Column(
              children: [
                for (final (color, title, desc) in const [
                  (
                    NixtColorRole.info,
                    'Heads up',
                    'A new version is available.'
                  ),
                  (NixtColorRole.success, 'Saved', 'Your profile was updated.'),
                  (
                    NixtColorRole.warning,
                    'Storage low',
                    'Less than 1 GB remaining.'
                  ),
                  (
                    NixtColorRole.error,
                    'Upload failed',
                    'Check your connection and retry.'
                  ),
                ])
                  Padding(
                    padding: const EdgeInsets.only(bottom: NixtSpacing.s3),
                    child: NixtAlert(
                        color: color, title: title, description: desc),
                  ),
              ],
            ),
          ),
          GallerySection(
            title: 'Alert variants & dismiss',
            child: Column(
              children: [
                const NixtAlert(
                  color: NixtColorRole.primary,
                  variant: NixtVariant.solid,
                  title: 'Solid',
                  description: 'High-emphasis banner.',
                ),
                const SizedBox(height: NixtSpacing.s3),
                const NixtAlert(
                  color: NixtColorRole.info,
                  variant: NixtVariant.subtle,
                  title: 'Subtle',
                  description: 'Tinted fill with a hairline border.',
                ),
                const SizedBox(height: NixtSpacing.s3),
                NixtAlert(
                  color: NixtColorRole.neutral,
                  variant: NixtVariant.outline,
                  title: 'Dismissible',
                  description: 'Tap × to close.',
                  onClose: () {},
                ),
              ],
            ),
          ),
          GallerySection(
            title: 'Toast',
            child: Row(
              children: [
                NixtButton(
                  label: 'Material',
                  variant: NixtVariant.soft,
                  onPressed: () =>
                      _showToast(context, NixtToastVariant.material),
                ),
                const SizedBox(width: NixtSpacing.s3),
                NixtButton(
                  label: 'iOS',
                  variant: NixtVariant.soft,
                  color: NixtColorRole.neutral,
                  onPressed: () => _showToast(context, NixtToastVariant.ios),
                ),
              ],
            ),
          ),
          const GallerySection(
            title: 'Skeleton',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    NixtSkeleton(
                        variant: NixtSkeletonVariant.circle,
                        width: 48,
                        height: 48),
                    SizedBox(width: NixtSpacing.s3),
                    Expanded(
                        child: NixtSkeleton(
                            variant: NixtSkeletonVariant.text, lines: 2)),
                  ],
                ),
                SizedBox(height: NixtSpacing.s4),
                NixtSkeleton(height: 120),
              ],
            ),
          ),
          GallerySection(
            title: 'Empty state',
            child: NixtCard(
              child: NixtEmptyState(
                icon: NixtIcons.search,
                title: 'No results',
                description:
                    'Try a different search term or clear your filters.',
                action: NixtButton(
                  label: 'Clear filters',
                  variant: NixtVariant.soft,
                  size: NixtButtonSize.sm,
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
