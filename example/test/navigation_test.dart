import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nixt_ui/nixt_ui.dart';
import 'package:nixt_ui_example/gallery_controls.dart';
import 'package:nixt_ui_example/screens/home_screen.dart';

void main() {
  Widget app() => GalleryControls(
        isDark: false,
        neutral: NixtNeutral.slate,
        roles: const {},
        radiusBase: 8,
        toggleBrightness: () {},
        setNeutral: (_) {},
        setRole: (_, __) {},
        setRadius: (_) {},
        resetTheme: () {},
        child: MaterialApp(
          theme: ThemeData(extensions: [NixtTheme.light()]),
          home: const HomeScreen(),
        ),
      );

  testWidgets('home shows catalog grid', (tester) async {
    await tester.pumpWidget(app());
    expect(find.text('Nixt UI'), findsOneWidget);
    expect(find.text('Buttons'), findsOneWidget);
    expect(find.text('Icons'), findsOneWidget);
    expect(find.text('Navigation'), findsOneWidget);
  });

  testWidgets('tapping Buttons navigates to the Buttons screen',
      (tester) async {
    await tester.pumpWidget(app());
    await tester.tap(find.text('Buttons'));
    // Buttons screen has an always-spinning loading button, so pumpAndSettle
    // would hang — pump past the route transition instead.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Variants × colors'), findsOneWidget);
    expect(find.text('Sizes'), findsOneWidget);
  });

  testWidgets('tapping Icons opens the searchable browser', (tester) async {
    await tester.pumpWidget(app());
    await tester.tap(find.text('Icons'));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget);
    expect(find.textContaining('Filter'), findsOneWidget);
  });

  testWidgets('tapping Cards opens the data-surface screen', (tester) async {
    await tester.pumpWidget(app());
    await tester.tap(find.text('Cards'));
    await tester.pumpAndSettle();
    expect(find.text('Card variants'), findsOneWidget);
    expect(find.text('Filter chips'), findsOneWidget);
  });

  testWidgets('tapping Feedback opens the feedback screen', (tester) async {
    await tester.pumpWidget(app());
    await tester.tap(find.text('Feedback'));
    // Skeleton shimmer runs forever → pumpAndSettle would hang.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('Alert colors'), findsOneWidget);
    expect(find.text('Empty state'), findsOneWidget);
  });

  testWidgets('tapping Navigation opens the navigation screen', (tester) async {
    await tester.pumpWidget(app());
    await tester.tap(find.text('Navigation'));
    await tester.pumpAndSettle();
    expect(find.text('Tabs — pill'), findsOneWidget);
    expect(find.text('Page indicator'), findsOneWidget);
  });

  testWidgets('tapping Overlays opens the overlays screen and a dialog',
      (tester) async {
    await tester.pumpWidget(app());
    await tester.tap(find.text('Overlays'));
    await tester.pumpAndSettle();
    expect(find.text('Bottom sheet'), findsOneWidget);
    expect(find.text('Menu'), findsOneWidget);
    // Open the confirm dialog.
    await tester.tap(find.text('Confirm delete'));
    await tester.pumpAndSettle();
    expect(find.text('Delete project?'), findsOneWidget);
  });

  testWidgets('theme configurator opens from the top bar', (tester) async {
    await tester.pumpWidget(app());
    await tester.tap(find.byIcon(NixtIcons.slidersHorizontal));
    await tester.pumpAndSettle();
    expect(find.text('Theme'), findsOneWidget);
    expect(find.text('Brand & status colors'), findsOneWidget);
    expect(find.text('Radius'), findsOneWidget);
  });

  testWidgets('disabled placeholder card does not navigate', (tester) async {
    await tester.pumpWidget(app());
    await tester.tap(find.text('Inputs'));
    await tester.pumpAndSettle();
    // Still on home — no detail content pushed.
    expect(find.text('Inputs'), findsOneWidget);
    expect(find.text('Variants × colors'), findsNothing);
  });
}
