import 'package:flutter/material.dart';
import 'package:nixt_ui/nixt_ui.dart';

import '../widgets/gallery_scaffold.dart';

/// Showcase for the data-surface family — Card, Badge, Chip.
class CardsScreen extends StatefulWidget {
  /// Creates the cards screen.
  const CardsScreen({super.key});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  final Set<String> _filters = {'all'};
  int _taps = 0;
  bool _wifi = true;

  static const _roles = [
    ('Primary', NixtColorRole.primary),
    ('Secondary', NixtColorRole.secondary),
    ('Success', NixtColorRole.success),
    ('Info', NixtColorRole.info),
    ('Warning', NixtColorRole.warning),
    ('Error', NixtColorRole.error),
    ('Neutral', NixtColorRole.neutral),
  ];

  void _toggle(String key) => setState(() {
        if (key == 'all') {
          _filters
            ..clear()
            ..add('all');
          return;
        }
        _filters.remove('all');
        if (!_filters.add(key)) _filters.remove(key);
        if (_filters.isEmpty) _filters.add('all');
      });

  @override
  Widget build(BuildContext context) {
    return GalleryScaffold(
      title: 'Cards',
      showBack: true,
      showNeutralSwitcher: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const GallerySection(
            title: 'Card variants',
            child: Column(
              children: [
                NixtCard(
                  title: 'Outline',
                  subtitle: 'Hairline border, no shadow',
                  child: Text('Default surface for grouped content.'),
                ),
                SizedBox(height: NixtSpacing.s4),
                NixtCard(
                  variant: NixtCardVariant.elevated,
                  title: 'Elevated',
                  subtitle: 'Raised with a soft shadow',
                  child: Text('Use sparingly for floating surfaces.'),
                ),
                SizedBox(height: NixtSpacing.s4),
                NixtCard(
                  variant: NixtCardVariant.soft,
                  title: 'Soft',
                  subtitle: 'Tinted fill, borderless',
                  child: Text('Quiet grouping inside a page.'),
                ),
              ],
            ),
          ),
          GallerySection(
            title: 'Tappable & footer',
            child: NixtCard(
              variant: NixtCardVariant.elevated,
              title: 'Project Apollo',
              subtitle: 'Tap count: $_taps',
              onTap: () => setState(() => _taps++),
              footer: Row(
                children: [
                  const NixtBadge(
                    label: 'Active',
                    color: NixtColorRole.success,
                    variant: NixtVariant.soft,
                    dot: true,
                  ),
                  const Spacer(),
                  NixtBadge(label: '$_taps taps', variant: NixtVariant.subtle),
                ],
              ),
              child: const Text('Whole surface is tappable with press feedback.'),
            ),
          ),
          GallerySection(
            title: 'Badge colors',
            child: Wrap(
              spacing: NixtSpacing.s2,
              runSpacing: NixtSpacing.s2,
              children: [
                for (final (label, role) in _roles) NixtBadge(label: label, color: role),
              ],
            ),
          ),
          const GallerySection(
            title: 'Badge variants',
            child: Wrap(
              spacing: NixtSpacing.s2,
              runSpacing: NixtSpacing.s2,
              children: [
                NixtBadge(label: 'Solid', variant: NixtVariant.solid),
                NixtBadge(label: 'Outline', variant: NixtVariant.outline),
                NixtBadge(label: 'Soft', variant: NixtVariant.soft),
                NixtBadge(label: 'Subtle', variant: NixtVariant.subtle),
                NixtBadge(label: 'Pill', pill: true),
                NixtBadge(label: 'Dot', dot: true, variant: NixtVariant.soft),
                NixtBadge(label: 'Icon', icon: NixtIcons.star),
              ],
            ),
          ),
          const GallerySection(
            title: 'Badge sizes',
            child: Wrap(
              spacing: NixtSpacing.s2,
              runSpacing: NixtSpacing.s2,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                NixtBadge(label: 'sm', size: NixtBadgeSize.sm),
                NixtBadge(label: 'md', size: NixtBadgeSize.md),
                NixtBadge(label: 'lg', size: NixtBadgeSize.lg),
              ],
            ),
          ),
          GallerySection(
            title: 'Filter chips',
            child: Wrap(
              spacing: NixtSpacing.s2,
              runSpacing: NixtSpacing.s2,
              children: [
                NixtChip(
                  label: 'All',
                  selected: _filters.contains('all'),
                  onTap: () => _toggle('all'),
                ),
                NixtChip(
                  label: 'Design',
                  icon: NixtIcons.byName('palette'),
                  selected: _filters.contains('design'),
                  onTap: () => _toggle('design'),
                ),
                NixtChip(
                  label: 'Code',
                  icon: NixtIcons.byName('code'),
                  selected: _filters.contains('code'),
                  onTap: () => _toggle('code'),
                ),
                NixtChip(
                  label: 'Docs',
                  selected: _filters.contains('docs'),
                  onTap: () => _toggle('docs'),
                ),
              ],
            ),
          ),
          const GallerySection(
            title: 'Chip sizes',
            child: Wrap(
              spacing: NixtSpacing.s2,
              runSpacing: NixtSpacing.s2,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                NixtChip(label: 'sm', selected: true, size: NixtChipSize.sm),
                NixtChip(label: 'md', selected: true, size: NixtChipSize.md),
                NixtChip(label: 'lg', selected: true, size: NixtChipSize.lg),
              ],
            ),
          ),
          const GallerySection(
            title: 'Chip indicator',
            child: Wrap(
              spacing: NixtSpacing.s6,
              runSpacing: NixtSpacing.s4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                // Status dot hugging a circular avatar.
                NixtChipIndicator(
                  inset: true,
                  position: NixtChipPosition.bottomRight,
                  color: NixtColorRole.success,
                  child: NixtAvatar(name: 'Ada Lovelace'),
                ),
                // Unread count, clamped with max.
                NixtChipIndicator(
                  text: '128',
                  max: 99,
                  color: NixtColorRole.error,
                  inset: true,
                  child: NixtAvatar(name: 'Grace Hopper'),
                ),
                // Count overlaid on an icon.
                NixtChipIndicator(
                  text: '3',
                  color: NixtColorRole.error,
                  child: NixtIcon(NixtIcons.bell, size: 28),
                ),
                // Standalone dots — status colors.
                NixtChipIndicator(standalone: true, color: NixtColorRole.success),
                NixtChipIndicator(standalone: true, color: NixtColorRole.warning),
                NixtChipIndicator(standalone: true, color: NixtColorRole.neutral),
              ],
            ),
          ),
          const GallerySection(
            title: 'Divider',
            child: Column(
              children: [
                Text('Above the line'),
                SizedBox(height: NixtSpacing.s3),
                NixtDivider(),
                SizedBox(height: NixtSpacing.s3),
                NixtDivider(label: 'or'),
                SizedBox(height: NixtSpacing.s3),
                Text('Below the line'),
              ],
            ),
          ),
          const GallerySection(
            title: 'Progress',
            child: Column(
              children: [
                NixtProgress(value: 64, label: 'Uploading', showValue: true),
                SizedBox(height: NixtSpacing.s4),
                NixtProgress(value: 32, color: NixtColorRole.warning, size: NixtProgressSize.sm),
                SizedBox(height: NixtSpacing.s4),
                NixtProgress(value: 90, color: NixtColorRole.success, size: NixtProgressSize.lg),
              ],
            ),
          ),
          const GallerySection(
            title: 'Avatar',
            child: Wrap(
              spacing: NixtSpacing.s3,
              runSpacing: NixtSpacing.s3,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                NixtAvatar(name: 'Ada Lovelace', status: NixtAvatarStatus.online),
                NixtAvatar(size: NixtAvatarSize.lg),
                NixtAvatar(name: 'Grace Hopper', square: true, status: NixtAvatarStatus.busy),
                NixtAvatar(size: NixtAvatarSize.sm, status: NixtAvatarStatus.away),
              ],
            ),
          ),
          const GallerySection(
            title: 'Avatar group',
            child: NixtAvatarGroup(
              max: 3,
              avatars: [
                NixtAvatar(name: 'Ada Lovelace'),
                NixtAvatar(name: 'Grace Hopper'),
                NixtAvatar(name: 'Alan Turing'),
                NixtAvatar(name: 'Edsger Dijkstra'),
                NixtAvatar(name: 'Linus Torvalds'),
              ],
            ),
          ),
          GallerySection(
            title: 'List items',
            child: NixtCard(
              padding: NixtCardPadding.none,
              child: Column(
                children: [
                  NixtListItem(
                    title: 'Wi-Fi',
                    subtitle: 'HomeNetwork_5G',
                    leadingIcon: NixtIcons.byName('wifi'),
                    trailing: NixtSwitch(
                      value: _wifi,
                      onChanged: (v) => setState(() => _wifi = v),
                    ),
                  ),
                  const NixtDivider(),
                  NixtListItem(
                    title: 'Storage',
                    subtitle: '64 GB of 128 GB used',
                    leadingIcon: NixtIcons.byName('hard-drive'),
                    leadingColor: NixtColorRole.info,
                    value: '50%',
                    chevron: true,
                    onTap: () {},
                  ),
                  const NixtDivider(),
                  NixtListItem(
                    title: 'Notifications',
                    leadingIcon: NixtIcons.bell,
                    leadingColor: NixtColorRole.warning,
                    chevron: true,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          const GallerySection(
            title: 'Stat',
            child: NixtCard(
              child: Row(
                children: [
                  Expanded(
                    child: NixtStat(
                      icon: NixtIcons.trendingUp,
                      value: '\$12.4k',
                      label: 'Revenue',
                      delta: '+12%',
                    ),
                  ),
                  Expanded(
                    child: NixtStat(
                      icon: NixtIcons.star,
                      color: NixtColorRole.info,
                      value: '2,318',
                      label: 'Users',
                      delta: '-3%',
                    ),
                  ),
                  Expanded(
                    child: NixtStat(
                      value: '98.2%',
                      label: 'Uptime',
                      align: NixtStatAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const GallerySection(
            title: 'Timeline',
            child: NixtCard(
              child: NixtTimeline(
                items: [
                  NixtTimelineItem(
                    title: 'Order placed',
                    time: '9:41 AM',
                    description: 'Payment confirmed via Apple Pay.',
                    icon: NixtIcons.check,
                  ),
                  NixtTimelineItem(
                    title: 'Packed',
                    time: '11:20 AM',
                    color: NixtColorRole.info,
                  ),
                  NixtTimelineItem(
                    title: 'Out for delivery',
                    description: 'Arrives by 6 PM today.',
                    done: false,
                  ),
                  NixtTimelineItem(title: 'Delivered', done: false),
                ],
              ),
            ),
          ),
          GallerySection(
            title: 'Carousel',
            child: NixtCarousel(
              height: 160,
              slides: [
                for (final (label, role) in _roles.take(4))
                  Container(
                    color: context.nixt.colors.role(role),
                    alignment: Alignment.center,
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: NixtPalette.white,
                        fontSize: NixtTypography.textXl,
                        fontWeight: NixtTypography.weightBold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const GallerySection(
            title: 'Accordion',
            child: NixtCard(
              child: NixtAccordion(
                defaultOpen: [0],
                items: [
                  NixtAccordionItem(
                    label: 'Shipping',
                    icon: NixtIcons.target,
                    content: Text('Orders ship within 2 business days via tracked post.'),
                  ),
                  NixtAccordionItem(
                    label: 'Returns',
                    content: Text('Free returns within 30 days of delivery, no questions asked.'),
                  ),
                  NixtAccordionItem(
                    label: 'Warranty',
                    content: Text('Every product carries a two-year limited warranty.'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
