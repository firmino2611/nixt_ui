import 'package:flutter/material.dart';
import 'package:nixt_ui/nixt_ui.dart';

import '../widgets/gallery_scaffold.dart';

/// Showcase for the navigation family — AppBar, Tabs, BottomNav, PageIndicator.
class NavigationScreen extends StatefulWidget {
  /// Creates the navigation screen.
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  String _tab = 'all';
  String _linkTab = 'overview';
  int _navIos = 0;
  int _navMat = 0;
  int _page = 0;
  int _step = 1;

  static const _navItems = [
    NixtBottomNavItem(label: 'Home', value: 0, icon: NixtIcons.home),
    NixtBottomNavItem(label: 'Search', value: 1, icon: NixtIcons.search),
    NixtBottomNavItem(
        label: 'Alerts', value: 2, icon: NixtIcons.bell, badge: '3'),
    NixtBottomNavItem(label: 'Profile', value: 3, icon: NixtIcons.user),
  ];

  Widget _barCard(Widget child) => NixtCard(
        padding: NixtCardPadding.none,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(context.nixt.radius.xl),
          child: child,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return GalleryScaffold(
      title: 'Navigation',
      showBack: true,
      showNeutralSwitcher: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GallerySection(
            title: 'App bar — iOS',
            child: _barCard(
              NixtAppBar(
                title: 'Settings',
                onBack: () {},
                actions: [
                  NixtIconButton(
                      icon: NixtIcons.search,
                      label: 'Search',
                      onPressed: () {}),
                ],
              ),
            ),
          ),
          GallerySection(
            title: 'App bar — Material',
            child: _barCard(
              NixtAppBar(
                variant: NixtAppBarVariant.material,
                title: 'Inbox',
                subtitle: '12 unread',
                onBack: () {},
                actions: [
                  NixtIconButton(
                      icon: NixtIcons.settings,
                      label: 'Settings',
                      onPressed: () {}),
                ],
              ),
            ),
          ),
          GallerySection(
            title: 'App bar — large title',
            child: _barCard(
              const NixtAppBar(
                  title: 'Library', subtitle: 'Your saved items', large: true),
            ),
          ),
          GallerySection(
            title: 'Tabs — pill',
            child: NixtTabs<String>(
              value: _tab,
              onChanged: (v) => setState(() => _tab = v),
              items: const [
                NixtTabItem(label: 'All', value: 'all'),
                NixtTabItem(label: 'Unread', value: 'unread'),
                NixtTabItem(label: 'Flagged', value: 'flagged'),
              ],
            ),
          ),
          GallerySection(
            title: 'Tabs — link',
            child: NixtTabs<String>(
              variant: NixtTabsVariant.link,
              value: _linkTab,
              onChanged: (v) => setState(() => _linkTab = v),
              items: const [
                NixtTabItem(
                    label: 'Overview', value: 'overview', icon: NixtIcons.grid),
                NixtTabItem(
                    label: 'Activity',
                    value: 'activity',
                    icon: NixtIcons.barChart),
                NixtTabItem(
                    label: 'Settings',
                    value: 'settings',
                    icon: NixtIcons.settings),
              ],
            ),
          ),
          GallerySection(
            title: 'Bottom nav — iOS',
            child: _barCard(
              NixtBottomNav<int>(
                value: _navIos,
                onChanged: (v) => setState(() => _navIos = v),
                items: _navItems,
              ),
            ),
          ),
          GallerySection(
            title: 'Bottom nav — Material',
            child: _barCard(
              NixtBottomNav<int>(
                variant: NixtBottomNavVariant.material,
                value: _navMat,
                onChanged: (v) => setState(() => _navMat = v),
                items: _navItems,
              ),
            ),
          ),
          GallerySection(
            title: 'Page indicator',
            child: Column(
              children: [
                NixtPageIndicator(
                  count: 5,
                  active: _page,
                  onDotClick: (i) => setState(() => _page = i),
                ),
                const SizedBox(height: NixtSpacing.s4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NixtButton(
                      label: 'Prev',
                      variant: NixtVariant.soft,
                      size: NixtButtonSize.sm,
                      onPressed:
                          _page == 0 ? null : () => setState(() => _page--),
                    ),
                    const SizedBox(width: NixtSpacing.s3),
                    NixtButton(
                      label: 'Next',
                      variant: NixtVariant.soft,
                      size: NixtButtonSize.sm,
                      onPressed:
                          _page == 4 ? null : () => setState(() => _page++),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GallerySection(
            title: 'Steps',
            child: NixtCard(
              child: Column(
                children: [
                  NixtSteps(
                    steps: const ['Cart', 'Address', 'Payment', 'Done'],
                    current: _step,
                  ),
                  const SizedBox(height: NixtSpacing.s5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NixtButton(
                        label: 'Back',
                        variant: NixtVariant.soft,
                        size: NixtButtonSize.sm,
                        onPressed:
                            _step == 0 ? null : () => setState(() => _step--),
                      ),
                      const SizedBox(width: NixtSpacing.s3),
                      NixtButton(
                        label: 'Continue',
                        variant: NixtVariant.soft,
                        size: NixtButtonSize.sm,
                        onPressed:
                            _step == 3 ? null : () => setState(() => _step++),
                      ),
                    ],
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
