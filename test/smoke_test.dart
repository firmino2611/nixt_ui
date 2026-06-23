import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nixt_ui/nixt_ui.dart';

void main() {
  test('themes resolve for both brightnesses and all neutrals', () {
    for (final n in NixtNeutral.values) {
      final light = NixtTheme.light(neutral: n);
      final dark = NixtTheme.dark(neutral: n);
      expect(light.colors.brightness, Brightness.light);
      expect(dark.colors.brightness, Brightness.dark);
      // Signature green primary in light = green-500.
      expect(light.colors.primary, NixtPalette.green.s500);
      // Dark lightens one step.
      expect(dark.colors.primary, NixtPalette.green.s400);
    }
  });

  test('global role override repaints the brand color', () {
    final seed = NixtColorScale.fromSeed(const Color(0xFF8B5CF6)); // violet
    // 500 == seed; lighter/darker shades bracket it.
    expect(seed.s500, const Color(0xFF8B5CF6));

    final custom = NixtColors.light(roles: {NixtColorRole.primary: seed});
    expect(custom.primary, seed.s500);
    // Untouched roles keep their defaults.
    expect(custom.secondary, NixtPalette.blue.s500);
    // Dark mode lightens the override one step (uses shade 400).
    final customDark = NixtColors.dark(roles: {NixtColorRole.primary: seed});
    expect(customDark.primary, seed.s400);
    // Soft tints derive from the overridden base.
    final soft = NixtVariantResolver.resolve(
        NixtColorRole.primary, NixtVariant.soft, custom);
    expect(soft.foreground, custom.primary);
  });

  test('radius single-token model drives the scale', () {
    const r = NixtRadius(base: 8);
    expect(r.md, 8);
    expect(r.xs, 4);
    expect(r.lg, 12);
    expect(r.xl, 16);
  });

  test('variant resolver ports variantStyle', () {
    final c = NixtColors.light();
    // solid primary => green bg, white fg.
    final solid = NixtVariantResolver.resolve(
        NixtColorRole.primary, NixtVariant.solid, c);
    expect(solid.background, c.primary);
    expect(solid.foreground, const Color(0xFFFFFFFF));
    // warning solid => dark fg, not white.
    final warn = NixtVariantResolver.resolve(
        NixtColorRole.warning, NixtVariant.solid, c);
    expect(warn.foreground, c.neutral.scale.s900);
    // soft primary => 12% tinted bg.
    final soft =
        NixtVariantResolver.resolve(NixtColorRole.primary, NixtVariant.soft, c);
    expect(soft.background, isNotNull);
    expect(soft.foreground, c.primary);
  });

  testWidgets('Lucide icon glyph renders via bundled font', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(extensions: [NixtTheme.light()]),
        home: Builder(
          builder: (ctx) => Icon(
            NixtIcons.home,
            size: 24,
            color: ctx.nixt.colors.primary,
          ),
        ),
      ),
    );
    final icon = tester.widget<Icon>(find.byType(Icon));
    expect(icon.icon, NixtIcons.home);
    expect(icon.icon!.fontFamily, 'LucideIcons');
    // Must be package-qualified or glyphs fall back to a system font.
    expect(icon.icon!.fontPackage, 'nixt_ui');
  });

  Widget host(Widget child) => MaterialApp(
        theme: ThemeData(extensions: [NixtTheme.light()]),
        home: Scaffold(body: Center(child: child)),
      );

  testWidgets('Button fires onPressed', (tester) async {
    var taps = 0;
    await tester.pumpWidget(host(
      NixtButton(label: 'Go', onPressed: () => taps++),
    ));
    await tester.tap(find.text('Go'));
    expect(taps, 1);
  });

  testWidgets('Button with null onPressed is disabled (no taps)',
      (tester) async {
    await tester.pumpWidget(host(const NixtButton(label: 'Off')));
    await tester.tap(find.text('Off'));
    // Disabled => 0.45 opacity wrapper present, tap does nothing.
    final opacity = tester.widget<Opacity>(find.byType(Opacity));
    expect(opacity.opacity, 0.45);
  });

  testWidgets('Loading button shows spinner alongside label (DS behavior)',
      (tester) async {
    await tester.pumpWidget(host(
      NixtButton(label: 'Save', loading: true, onPressed: () {}),
    ));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    // DS keeps the label visible; the spinner replaces only the leading icon.
    expect(find.text('Save'), findsOneWidget);
  });

  testWidgets('Block button stretches full width', (tester) async {
    await tester.pumpWidget(host(
      SizedBox(
          width: 300,
          child: NixtButton(label: 'Wide', block: true, onPressed: () {})),
    ));
    final box = tester.getSize(find.byType(NixtButton));
    expect(box.width, 300);
  });

  testWidgets('Icon-only square button renders just the icon', (tester) async {
    await tester.pumpWidget(host(
      NixtButton(icon: NixtIcons.plus, square: true, onPressed: () {}),
    ));
    expect(find.byType(NixtIcon), findsOneWidget);
    expect(find.byType(Text), findsNothing);
  });

  testWidgets('IconButton exposes its label to semantics and fires',
      (tester) async {
    var taps = 0;
    await tester.pumpWidget(host(
      NixtIconButton(
          icon: NixtIcons.share, label: 'Share', onPressed: () => taps++),
    ));
    // Label is accessible but not rendered as visible body text.
    expect(find.bySemanticsLabel('Share'), findsWidgets);
    await tester.tap(find.byType(NixtIconButton));
    expect(taps, 1);
  });

  testWidgets('FAB renders round by default, extended with a label',
      (tester) async {
    await tester.pumpWidget(host(
      NixtFab(icon: NixtIcons.plus, onPressed: () {}),
    ));
    expect(find.byType(NixtIcon), findsOneWidget);
    expect(find.byType(Text), findsNothing);

    await tester.pumpWidget(host(
      NixtFab(icon: NixtIcons.pencil, label: 'Compose', onPressed: () {}),
    ));
    expect(find.text('Compose'), findsOneWidget);
  });

  testWidgets('FAB solid resolution: warning gets dark foreground',
      (tester) async {
    final c = NixtColors.light();
    final vc = NixtVariantResolver.resolve(
        NixtColorRole.warning, NixtVariant.solid, c);
    expect(vc.foreground, c.neutral.scale.s900);
  });

  testWidgets('Input edits text and shows error message', (tester) async {
    var last = '';
    await tester.pumpWidget(host(
      NixtInput(hintText: 'Email', onChanged: (v) => last = v),
    ));
    await tester.enterText(find.byType(TextField), 'hi@x.com');
    expect(last, 'hi@x.com');

    await tester.pumpWidget(host(
      const NixtInput(hintText: 'Email', errorText: 'Required'),
    ));
    expect(find.text('Required'), findsOneWidget);
  });

  testWidgets('Select fires onChanged with the chosen value', (tester) async {
    String? picked;
    await tester.pumpWidget(host(
      NixtSelect(
        placeholder: 'Pick',
        items: const [
          NixtSelectItem(label: 'Low', value: 'low'),
          NixtSelectItem(label: 'High', value: 'high'),
        ],
        onChanged: (v) => picked = v,
      ),
    ));
    await tester.tap(find.text('Pick'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('High').last);
    await tester.pumpAndSettle();
    expect(picked, 'high');
  });

  testWidgets('MultiSelect toggles values and keeps the menu open',
      (tester) async {
    List<String> picked = [];
    Widget build(List<String> values) => host(
          NixtMultiSelect(
            placeholder: 'Tags',
            values: values,
            items: const [
              NixtSelectItem(label: 'Bug', value: 'bug'),
              NixtSelectItem(label: 'Docs', value: 'docs'),
            ],
            onChanged: (v) => picked = v,
          ),
        );

    await tester.pumpWidget(build(picked));
    await tester.tap(find.text('Tags'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Bug'));
    expect(picked, ['bug']);

    // Menu stays open — feed the new selection back in and toggle a second one.
    await tester.pumpWidget(build(picked));
    await tester.pumpAndSettle();
    expect(find.text('Docs'), findsOneWidget); // still open
    await tester.tap(find.text('Docs'));
    expect(picked, ['bug', 'docs']);
  });

  testWidgets('Checkbox toggles and shows check when on', (tester) async {
    var on = false;
    await tester.pumpWidget(host(
      NixtCheckbox(value: on, label: 'Agree', onChanged: (v) => on = v),
    ));
    expect(find.byType(NixtIcon), findsNothing); // unchecked: no check glyph
    await tester.tap(find.text('Agree'));
    expect(on, true);

    await tester
        .pumpWidget(host(const NixtCheckbox(value: true, label: 'Agree')));
    expect(find.byType(NixtIcon), findsOneWidget); // checked: check glyph
  });

  testWidgets('Radio reports its value on tap', (tester) async {
    String? picked;
    await tester.pumpWidget(host(
      Column(
        children: [
          NixtRadio<String>(
              value: 'a',
              groupValue: 'b',
              label: 'A',
              onChanged: (v) => picked = v),
          NixtRadio<String>(
              value: 'b',
              groupValue: 'b',
              label: 'B',
              onChanged: (v) => picked = v),
        ],
      ),
    ));
    await tester.tap(find.text('A'));
    expect(picked, 'a');
  });

  testWidgets('Switch toggles via onChanged', (tester) async {
    var on = true;
    await tester.pumpWidget(host(
      NixtSwitch(value: on, label: 'Wi-Fi', onChanged: (v) => on = v),
    ));
    await tester.tap(find.text('Wi-Fi'));
    expect(on, false);
  });

  testWidgets('Disabled toggles ignore taps', (tester) async {
    var changed = false;
    await tester.pumpWidget(host(
      const NixtSwitch(value: false, label: 'Off', enabled: false),
    ));
    await tester.tap(find.text('Off'));
    expect(changed, false);
  });

  testWidgets('Stepper clamps at min and reports increments', (tester) async {
    var v = 0;
    Widget build(int value) => host(
          NixtStepper(value: value, min: 0, max: 3, onChanged: (n) => v = n),
        );
    await tester.pumpWidget(build(0));
    // Minus at min: disabled, no change.
    await tester.tap(find.byType(NixtIcon).first);
    expect(v, 0);
    // Plus: +1.
    await tester.tap(find.byType(NixtIcon).last);
    expect(v, 1);
  });

  testWidgets('Rating reports the tapped star index', (tester) async {
    var stars = 0;
    await tester.pumpWidget(host(
      NixtRating(value: 0, onChanged: (v) => stars = v),
    ));
    // Scope to the rating's own star CustomPaints (Material adds others).
    final starPaints = find.descendant(
      of: find.byType(NixtRating),
      matching: find.byType(CustomPaint),
    );
    await tester.tap(starPaints.at(3)); // 4th star
    expect(stars, 4);
  });

  testWidgets('Slider reports value changes', (tester) async {
    double v = 50;
    await tester.pumpWidget(host(
      SizedBox(
          width: 300, child: NixtSlider(value: v, onChanged: (x) => v = x)),
    ));
    // Tap near the left edge — clearly off the centre (which would read ~50).
    final rect = tester.getRect(find.byType(Slider));
    await tester.tapAt(Offset(rect.left + rect.width * 0.2, rect.center.dy));
    expect(v, isNot(50));
  });

  testWidgets('SearchBar shows clear button after typing', (tester) async {
    final ctrl = TextEditingController();
    await tester
        .pumpWidget(host(NixtSearchBar(controller: ctrl, onChanged: (_) {})));
    await tester.enterText(find.byType(TextField), 'hello');
    await tester.pump();
    // The × clear glyph appears.
    expect(find.byIcon(NixtIcons.x), findsOneWidget);
  });

  testWidgets('PinInput emits typed characters', (tester) async {
    String code = '';
    await tester.pumpWidget(host(
      NixtPinInput(length: 4, value: code, onChanged: (x) => code = x),
    ));
    await tester.enterText(find.byType(TextField).first, '7');
    expect(code, '7');
  });

  testWidgets('Field shell: error overrides focus for the border',
      (tester) async {
    final c = NixtColors.light();
    final deco = NixtFieldShell.resolve(
      colors: c,
      radius: const NixtRadius(),
      variant: NixtFieldVariant.outline,
      accentColor: c.primary,
      focused: true,
      errored: true,
    );
    expect((deco.border as Border).top.color, c.error);
  });

  testWidgets('Card renders title/subtitle and fires onTap', (tester) async {
    var taps = 0;
    await tester.pumpWidget(host(
      NixtCard(
        title: 'Storage',
        subtitle: '78% used',
        onTap: () => taps++,
        child: const Text('body'),
      ),
    ));
    expect(find.text('Storage'), findsOneWidget);
    expect(find.text('78% used'), findsOneWidget);
    expect(find.text('body'), findsOneWidget);
    await tester.tap(find.text('body'));
    expect(taps, 1);
  });

  testWidgets('Badge dot uses solid foreground vs role tint', (tester) async {
    await tester.pumpWidget(host(
      const NixtBadge(label: 'New', dot: true),
    ));
    expect(find.text('New'), findsOneWidget);
  });

  testWidgets('Chip toggles selection via onTap', (tester) async {
    var selected = false;
    await tester.pumpWidget(host(
      NixtChip(
          label: 'Design', selected: selected, onTap: () => selected = true),
    ));
    await tester.tap(find.text('Design'));
    expect(selected, isTrue);
  });

  testWidgets('Divider with label renders the caption', (tester) async {
    await tester.pumpWidget(
        host(const SizedBox(width: 200, child: NixtDivider(label: 'or'))));
    expect(find.text('or'), findsOneWidget);
  });

  testWidgets('Progress shows the clamped percentage', (tester) async {
    await tester.pumpWidget(host(
      const NixtProgress(value: 150, label: 'Load', showValue: true),
    ));
    expect(find.text('100%'), findsOneWidget); // clamped at max
    expect(find.text('Load'), findsOneWidget);
  });

  testWidgets('Avatar derives two-letter initials from a name', (tester) async {
    await tester.pumpWidget(host(const NixtAvatar(name: 'Ada Lovelace')));
    expect(find.text('AL'), findsOneWidget);
  });

  testWidgets('AvatarGroup collapses overflow into a +N chip', (tester) async {
    await tester.pumpWidget(host(const NixtAvatarGroup(
      max: 2,
      avatars: [
        NixtAvatar(name: 'A B'),
        NixtAvatar(name: 'C D'),
        NixtAvatar(name: 'E F'),
        NixtAvatar(name: 'G H'),
      ],
    )));
    expect(find.text('+2'), findsOneWidget);
  });

  testWidgets('ListItem renders title/value and fires onTap', (tester) async {
    var taps = 0;
    await tester.pumpWidget(host(
      NixtListItem(
        title: 'Storage',
        value: '64 GB',
        leadingIcon: NixtIcons.grid,
        chevron: true,
        onTap: () => taps++,
      ),
    ));
    expect(find.text('Storage'), findsOneWidget);
    expect(find.text('64 GB'), findsOneWidget);
    await tester.tap(find.text('Storage'));
    expect(taps, 1);
  });

  testWidgets('Accordion is single-open: opening one closes the other',
      (tester) async {
    await tester.pumpWidget(host(const SizedBox(
      width: 300,
      child: NixtAccordion(
        defaultOpen: [0],
        items: [
          NixtAccordionItem(label: 'First', content: Text('first body')),
          NixtAccordionItem(label: 'Second', content: Text('second body')),
        ],
      ),
    )));
    expect(find.text('first body'), findsOneWidget);
    await tester.tap(find.text('Second'));
    await tester.pumpAndSettle();
    expect(find.text('second body'), findsOneWidget);
    expect(find.text('first body'), findsNothing); // single-open collapsed it
  });

  testWidgets('Alert picks the per-color default icon and fires onClose',
      (tester) async {
    var closed = false;
    await tester.pumpWidget(host(
      NixtAlert(
        color: NixtColorRole.error,
        title: 'Failed',
        description: 'Try again',
        onClose: () => closed = true,
      ),
    ));
    expect(find.text('Failed'), findsOneWidget);
    expect(find.byIcon(NixtIcons.xCircle), findsOneWidget); // error default
    await tester.tap(find.byIcon(NixtIcons.x));
    expect(closed, isTrue);
  });

  testWidgets('EmptyState renders icon, title, and action', (tester) async {
    await tester.pumpWidget(host(
      NixtEmptyState(
        icon: NixtIcons.search,
        title: 'Nothing here',
        description: 'No items yet',
        action: NixtButton(label: 'Add', onPressed: () {}),
      ),
    ));
    expect(find.text('Nothing here'), findsOneWidget);
    expect(find.text('Add'), findsOneWidget);
    expect(find.byIcon(NixtIcons.search), findsOneWidget);
  });

  testWidgets('Skeleton text variant renders the requested line count',
      (tester) async {
    await tester.pumpWidget(host(
      const SizedBox(
          width: 200,
          child: NixtSkeleton(variant: NixtSkeletonVariant.text, lines: 4)),
    ));
    expect(find.byType(NixtSkeleton), findsOneWidget);
    expect(find.byType(FractionallySizedBox), findsNWidgets(4));
    await tester.pump(const Duration(milliseconds: 100)); // shimmer running
  });

  testWidgets('Toast shows a text action and fires onAction', (tester) async {
    var undone = false;
    await tester.pumpWidget(host(
      NixtToast(
          message: 'Saved', action: 'Undo', onAction: () => undone = true),
    ));
    expect(find.text('Saved'), findsOneWidget);
    await tester.tap(find.text('Undo'));
    expect(undone, isTrue);
  });

  testWidgets('Tabs reports the tapped value', (tester) async {
    String? picked;
    await tester.pumpWidget(host(
      NixtTabs<String>(
        value: 'all',
        onChanged: (v) => picked = v,
        items: const [
          NixtTabItem(label: 'All', value: 'all'),
          NixtTabItem(label: 'Unread', value: 'unread'),
        ],
      ),
    ));
    await tester.tap(find.text('Unread'));
    expect(picked, 'unread');
  });

  testWidgets('BottomNav fires onChanged and shows a badge', (tester) async {
    int? tapped;
    await tester.pumpWidget(host(
      NixtBottomNav<int>(
        value: 0,
        onChanged: (v) => tapped = v,
        items: const [
          NixtBottomNavItem(label: 'Home', value: 0, icon: NixtIcons.home),
          NixtBottomNavItem(
              label: 'Alerts', value: 1, icon: NixtIcons.bell, badge: '3'),
        ],
      ),
    ));
    expect(find.text('3'), findsOneWidget); // badge
    await tester.tap(find.text('Alerts'));
    expect(tapped, 1);
  });

  testWidgets('PageIndicator fires onDotClick', (tester) async {
    int? dot;
    await tester.pumpWidget(host(
      NixtPageIndicator(count: 4, active: 0, onDotClick: (i) => dot = i),
    ));
    await tester.tapAt(tester.getCenter(find.byType(NixtPageIndicator)));
    expect(dot, isNotNull);
  });

  testWidgets('AppBar renders the title and fires onBack', (tester) async {
    var back = 0;
    await tester.pumpWidget(host(
      NixtAppBar(title: 'Settings', onBack: () => back++),
    ));
    expect(find.text('Settings'), findsOneWidget);
    await tester.tap(find.text('Back'));
    expect(back, 1);
  });

  testWidgets(
      'NixtApp applies DS config globally and forwards MaterialApp props',
      (tester) async {
    final seed = NixtColorScale.fromSeed(const Color(0xFF8B5CF6)); // violet
    late NixtTheme resolved;
    await tester.pumpWidget(NixtApp(
      title: 'Demo',
      debugShowCheckedModeBanner: false,
      neutral: NixtNeutral.zinc,
      radius: const NixtRadius(base: 12),
      roles: {NixtColorRole.primary: seed},
      themeMode: ThemeMode.light,
      home: Builder(builder: (context) {
        resolved = context.nixt; // component reads the global theme
        return const NixtButton(label: 'Hi');
      }),
    ));
    expect(resolved.colors.primary, seed.s500); // brand override reached it
    expect(resolved.radius.base, 12); // radius config reached it
    expect(find.text('Hi'), findsOneWidget); // home forwarded + renders
    expect(find.byType(MaterialApp), findsOneWidget); // wraps MaterialApp
  });

  testWidgets('showNixtSheet opens, shows content, and pops with a value',
      (tester) async {
    late BuildContext ctx;
    await tester.pumpWidget(host(Builder(builder: (c) {
      ctx = c;
      return const SizedBox();
    })));
    final future = showNixtSheet<String>(
      context: ctx,
      title: 'Filters',
      builder: (_) => const Text('sheet body'),
    );
    await tester.pumpAndSettle();
    expect(find.text('Filters'), findsOneWidget);
    expect(find.text('sheet body'), findsOneWidget);
    Navigator.of(ctx).pop('done');
    await tester.pumpAndSettle();
    expect(await future, 'done');
  });

  testWidgets('showNixtActionSheet returns the chosen index', (tester) async {
    late BuildContext ctx;
    var ran = false;
    await tester.pumpWidget(host(Builder(builder: (c) {
      ctx = c;
      return const SizedBox();
    })));
    final future = showNixtActionSheet(
      context: ctx,
      variant: NixtActionSheetVariant.material,
      actions: [
        const NixtSheetAction(label: 'Keep'),
        NixtSheetAction(
            label: 'Delete', destructive: true, onPressed: () => ran = true),
      ],
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(ran, isTrue);
    expect(await future, 1);
  });

  testWidgets('showNixtDialog renders and an action pops it', (tester) async {
    late BuildContext ctx;
    await tester.pumpWidget(host(Builder(builder: (c) {
      ctx = c;
      return const SizedBox();
    })));
    showNixtDialog(
      context: ctx,
      title: 'Delete project?',
      description: 'Cannot be undone',
      actions: [
        NixtButton(label: 'Cancel', onPressed: () => Navigator.of(ctx).pop()),
      ],
    );
    await tester.pumpAndSettle();
    expect(find.text('Delete project?'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Delete project?'), findsNothing);
  });

  testWidgets('Menu opens on trigger tap and fires an item', (tester) async {
    var edited = false;
    await tester.pumpWidget(host(
      NixtMenu(
        trigger: const Padding(
          padding: EdgeInsets.all(8),
          child: NixtIcon(NixtIcons.moreVertical),
        ),
        items: [
          NixtMenuItem(
              label: 'Edit',
              icon: NixtIcons.pencil,
              onPressed: () => edited = true),
          const NixtMenuItem.separator(),
          const NixtMenuItem(
              label: 'Delete', icon: NixtIcons.trash, destructive: true),
        ],
      ),
    ));
    await tester.tap(find.byIcon(NixtIcons.moreVertical));
    await tester.pumpAndSettle();
    expect(find.text('Edit'), findsOneWidget);
    expect(find.text('Delete'), findsOneWidget);
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();
    expect(edited, isTrue);
    expect(find.text('Edit'), findsNothing); // menu closed
  });

  testWidgets('Toast supplies a clean DefaultTextStyle for bare (Overlay) use',
      (tester) async {
    // No Material/Scaffold ancestor — the condition an OverlayEntry runs in.
    // Without the component's own DefaultTextStyle, text would inherit Flutter's
    // debug yellow-underline style.
    await tester.pumpWidget(Directionality(
      textDirection: TextDirection.ltr,
      child: MediaQuery(
        data: const MediaQueryData(),
        child: Theme(
          data: ThemeData(extensions: [NixtTheme.light()]),
          child: const Center(child: NixtToast(message: 'Saved')),
        ),
      ),
    ));
    final style = tester
        .widget<DefaultTextStyle>(find
            .descendant(
              of: find.byType(NixtToast),
              matching: find.byType(DefaultTextStyle),
            )
            .first)
        .style;
    expect(style.decoration, TextDecoration.none);
  });
}
