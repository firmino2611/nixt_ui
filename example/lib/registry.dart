import 'package:flutter/widgets.dart';
import 'package:nixt_ui/nixt_ui.dart';

import 'screens/buttons_screen.dart';
import 'screens/cards_screen.dart';
import 'screens/feedback_screen.dart';
import 'screens/icons_screen.dart';
import 'screens/inputs_screen.dart';
import 'screens/navigation_screen.dart';
import 'screens/overlays_screen.dart';
import 'screens/toggles_screen.dart';

/// A single entry in the component catalog shown on the home grid.
class ComponentEntry {
  /// Creates a catalog entry.
  const ComponentEntry({
    required this.name,
    required this.icon,
    required this.builder,
    this.ready = true,
  });

  /// Display name.
  final String name;

  /// Representative icon.
  final IconData icon;

  /// Builds the component's detail screen.
  final WidgetBuilder builder;

  /// Whether the screen is implemented (greyed out + disabled when false).
  final bool ready;
}

/// The component catalog. Add an entry here as each component lands.
const List<ComponentEntry> kComponents = [
  ComponentEntry(name: 'Buttons', icon: NixtIcons.target, builder: _buttons),
  ComponentEntry(name: 'Icons', icon: NixtIcons.star, builder: _icons),
  ComponentEntry(name: 'Inputs', icon: NixtIcons.pencil, builder: _inputs),
  ComponentEntry(name: 'Toggles', icon: NixtIcons.check, builder: _toggles),
  ComponentEntry(name: 'Cards', icon: NixtIcons.grid, builder: _cards),
  ComponentEntry(name: 'Feedback', icon: NixtIcons.bell, builder: _feedback),
  ComponentEntry(
      name: 'Navigation', icon: NixtIcons.menu, builder: _navigation),
  ComponentEntry(
      name: 'Overlays', icon: NixtIcons.moreHorizontal, builder: _overlays),
];

Widget _buttons(BuildContext _) => const ButtonsScreen();
Widget _cards(BuildContext _) => const CardsScreen();
Widget _feedback(BuildContext _) => const FeedbackScreen();
Widget _icons(BuildContext _) => const IconsScreen();
Widget _inputs(BuildContext _) => const InputsScreen();
Widget _navigation(BuildContext _) => const NavigationScreen();
Widget _overlays(BuildContext _) => const OverlaysScreen();
Widget _toggles(BuildContext _) => const TogglesScreen();
