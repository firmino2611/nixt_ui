import 'package:flutter/material.dart';

import '../theme/component_themes/nixt_button_theme.dart';
import '../theme/neutral_palette.dart';
import '../theme/nixt_theme.dart';
import '../tokens/color_roles.dart';
import '../tokens/palette.dart';
import '../tokens/radius_tokens.dart';

/// A drop-in replacement for [MaterialApp] that wires the Nixt design system in
/// one place. Configure the theme (neutral palette, corner radius, brand
/// [roles], per-component overrides) here and every `Nixt*` component reads it
/// automatically — no manual `ThemeData.extensions` plumbing.
///
/// It accepts **every** [MaterialApp] property and forwards them unchanged, so
/// you can migrate by renaming `MaterialApp` to `NixtApp`.
///
/// ```dart
/// NixtApp(
///   neutral: NixtNeutral.zinc,
///   radius: NixtRadius(base: 12),
///   roles: {NixtColorRole.primary: NixtColorScale.fromSeed(Color(0xFF8B5CF6))},
///   home: HomeScreen(),
/// );
/// ```
///
/// ### How theming is applied
/// * When you **don't** pass [theme] / [darkTheme], `NixtApp` builds sensible
///   Material 3 [ThemeData]s seeded from the DS primary, with the DS surface as
///   the scaffold background and the [NixtTheme] registered as an extension.
/// * When you **do** pass them, they are respected as-is and the [NixtTheme]
///   extension is merged in (replacing any existing one).
///
/// For full control, pass [nixtLight] / [nixtDark] to override the resolved
/// themes entirely; otherwise they are derived from [neutral], [radius],
/// [roles], and [buttonTheme].
class NixtApp extends StatelessWidget {
  /// Creates a [NixtApp] backed by a [MaterialApp] (imperative routing).
  const NixtApp({
    super.key,
    // ---- Nixt design-system config ----
    this.neutral = NixtNeutral.slate,
    this.radius = const NixtRadius(),
    this.roles,
    this.buttonTheme = const NixtButtonTheme(),
    this.nixtLight,
    this.nixtDark,
    // ---- MaterialApp (navigator) ----
    this.navigatorKey,
    this.scaffoldMessengerKey,
    this.home,
    this.routes = const <String, WidgetBuilder>{},
    this.initialRoute,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    this.onNavigationNotification,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.builder,
    this.title = '',
    this.onGenerateTitle,
    this.color,
    this.theme,
    this.darkTheme,
    this.highContrastTheme,
    this.highContrastDarkTheme,
    this.themeMode = ThemeMode.system,
    this.themeAnimationDuration = kThemeAnimationDuration,
    this.themeAnimationCurve = Curves.linear,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.debugShowMaterialGrid = false,
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    this.scrollBehavior,
  })  : _router = false,
        routerConfig = null,
        routeInformationProvider = null,
        routeInformationParser = null,
        routerDelegate = null,
        backButtonDispatcher = null;

  /// Creates a [NixtApp] backed by [MaterialApp.router] (declarative routing,
  /// e.g. `go_router`). Mirrors the same DS config.
  const NixtApp.router({
    super.key,
    // ---- Nixt design-system config ----
    this.neutral = NixtNeutral.slate,
    this.radius = const NixtRadius(),
    this.roles,
    this.buttonTheme = const NixtButtonTheme(),
    this.nixtLight,
    this.nixtDark,
    // ---- MaterialApp.router ----
    this.scaffoldMessengerKey,
    this.routerConfig,
    this.routeInformationProvider,
    this.routeInformationParser,
    this.routerDelegate,
    this.backButtonDispatcher,
    this.onNavigationNotification,
    this.builder,
    this.title = '',
    this.onGenerateTitle,
    this.color,
    this.theme,
    this.darkTheme,
    this.highContrastTheme,
    this.highContrastDarkTheme,
    this.themeMode = ThemeMode.system,
    this.themeAnimationDuration = kThemeAnimationDuration,
    this.themeAnimationCurve = Curves.linear,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.debugShowMaterialGrid = false,
    this.showPerformanceOverlay = false,
    this.checkerboardRasterCacheImages = false,
    this.checkerboardOffscreenLayers = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = true,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    this.scrollBehavior,
  })  : _router = true,
        navigatorKey = null,
        home = null,
        routes = const <String, WidgetBuilder>{},
        initialRoute = null,
        onGenerateRoute = null,
        onGenerateInitialRoutes = null,
        onUnknownRoute = null,
        navigatorObservers = const <NavigatorObserver>[];

  // ---- Nixt design-system config ----

  /// Switchable neutral palette (slate / zinc / neutral / stone).
  final NixtNeutral neutral;

  /// Corner-radius scale (driven by a single [NixtRadius.base]).
  final NixtRadius radius;

  /// Brand/status color overrides — the DS-level color config (e.g. a custom
  /// primary). Keyed by role; unset roles keep their defaults.
  final Map<NixtColorRole, NixtColorScale>? roles;

  /// Global `NixtButton` overrides.
  final NixtButtonTheme buttonTheme;

  /// Full override for the light [NixtTheme] (ignores [neutral]/[radius]/etc.).
  final NixtTheme? nixtLight;

  /// Full override for the dark [NixtTheme].
  final NixtTheme? nixtDark;

  final bool _router;

  // ---- MaterialApp / MaterialApp.router pass-through ----

  /// See [MaterialApp.navigatorKey].
  final GlobalKey<NavigatorState>? navigatorKey;

  /// See [MaterialApp.scaffoldMessengerKey].
  final GlobalKey<ScaffoldMessengerState>? scaffoldMessengerKey;

  /// See [MaterialApp.home].
  final Widget? home;

  /// See [MaterialApp.routes].
  final Map<String, WidgetBuilder> routes;

  /// See [MaterialApp.initialRoute].
  final String? initialRoute;

  /// See [MaterialApp.onGenerateRoute].
  final RouteFactory? onGenerateRoute;

  /// See [MaterialApp.onGenerateInitialRoutes].
  final InitialRouteListFactory? onGenerateInitialRoutes;

  /// See [MaterialApp.onUnknownRoute].
  final RouteFactory? onUnknownRoute;

  /// See [MaterialApp.onNavigationNotification].
  final NotificationListenerCallback<NavigationNotification>?
      onNavigationNotification;

  /// See [MaterialApp.navigatorObservers].
  final List<NavigatorObserver> navigatorObservers;

  /// See [MaterialApp.routerConfig].
  final RouterConfig<Object>? routerConfig;

  /// See [MaterialApp.router].
  final RouteInformationProvider? routeInformationProvider;

  /// See [MaterialApp.router].
  final RouteInformationParser<Object>? routeInformationParser;

  /// See [MaterialApp.router].
  final RouterDelegate<Object>? routerDelegate;

  /// See [MaterialApp.router].
  final BackButtonDispatcher? backButtonDispatcher;

  /// See [MaterialApp.builder].
  final TransitionBuilder? builder;

  /// See [MaterialApp.title].
  final String title;

  /// See [MaterialApp.onGenerateTitle].
  final GenerateAppTitle? onGenerateTitle;

  /// See [MaterialApp.color].
  final Color? color;

  /// See [MaterialApp.theme]. When set it is respected and the [NixtTheme]
  /// extension is merged in; otherwise a DS-seeded theme is built.
  final ThemeData? theme;

  /// See [MaterialApp.darkTheme].
  final ThemeData? darkTheme;

  /// See [MaterialApp.highContrastTheme].
  final ThemeData? highContrastTheme;

  /// See [MaterialApp.highContrastDarkTheme].
  final ThemeData? highContrastDarkTheme;

  /// See [MaterialApp.themeMode].
  final ThemeMode themeMode;

  /// See [MaterialApp.themeAnimationDuration].
  final Duration themeAnimationDuration;

  /// See [MaterialApp.themeAnimationCurve].
  final Curve themeAnimationCurve;

  /// See [MaterialApp.locale].
  final Locale? locale;

  /// See [MaterialApp.localizationsDelegates].
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  /// See [MaterialApp.localeListResolutionCallback].
  final LocaleListResolutionCallback? localeListResolutionCallback;

  /// See [MaterialApp.localeResolutionCallback].
  final LocaleResolutionCallback? localeResolutionCallback;

  /// See [MaterialApp.supportedLocales].
  final Iterable<Locale> supportedLocales;

  /// See [MaterialApp.debugShowMaterialGrid].
  final bool debugShowMaterialGrid;

  /// See [MaterialApp.showPerformanceOverlay].
  final bool showPerformanceOverlay;

  /// See [MaterialApp.checkerboardRasterCacheImages].
  final bool checkerboardRasterCacheImages;

  /// See [MaterialApp.checkerboardOffscreenLayers].
  final bool checkerboardOffscreenLayers;

  /// See [MaterialApp.showSemanticsDebugger].
  final bool showSemanticsDebugger;

  /// See [MaterialApp.debugShowCheckedModeBanner].
  final bool debugShowCheckedModeBanner;

  /// See [MaterialApp.shortcuts].
  final Map<ShortcutActivator, Intent>? shortcuts;

  /// See [MaterialApp.actions].
  final Map<Type, Action<Intent>>? actions;

  /// See [MaterialApp.restorationScopeId].
  final String? restorationScopeId;

  /// See [MaterialApp.scrollBehavior].
  final ScrollBehavior? scrollBehavior;

  /// Builds a [ThemeData] carrying [nixt]. A user-supplied [base] is respected
  /// (the extension is merged in); otherwise a DS-seeded Material 3 theme.
  ThemeData _themeData(ThemeData? base, NixtTheme nixt, Brightness brightness) {
    if (base != null) {
      final exts = base.extensions.values.where((e) => e is! NixtTheme).toList()
        ..add(nixt);
      return base.copyWith(extensions: exts);
    }
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: nixt.colors.primary,
        brightness: brightness,
      ),
      scaffoldBackgroundColor: nixt.colors.bg,
      extensions: <ThemeExtension<dynamic>>[nixt],
    );
  }

  @override
  Widget build(BuildContext context) {
    final light = nixtLight ??
        NixtTheme.light(
          neutral: neutral,
          radius: radius,
          roles: roles,
          button: buttonTheme,
        );
    final dark = nixtDark ??
        NixtTheme.dark(
          neutral: neutral,
          radius: radius,
          roles: roles,
          button: buttonTheme,
        );

    final lightData = _themeData(theme, light, Brightness.light);
    final darkData = _themeData(darkTheme, dark, Brightness.dark);
    final hcLight = highContrastTheme == null
        ? null
        : _themeData(highContrastTheme, light, Brightness.light);
    final hcDark = highContrastDarkTheme == null
        ? null
        : _themeData(highContrastDarkTheme, dark, Brightness.dark);

    if (_router) {
      return MaterialApp.router(
        scaffoldMessengerKey: scaffoldMessengerKey,
        routerConfig: routerConfig,
        routeInformationProvider: routeInformationProvider,
        routeInformationParser: routeInformationParser,
        routerDelegate: routerDelegate,
        backButtonDispatcher: backButtonDispatcher,
        onNavigationNotification: onNavigationNotification,
        builder: builder,
        title: title,
        onGenerateTitle: onGenerateTitle,
        color: color,
        theme: lightData,
        darkTheme: darkData,
        highContrastTheme: hcLight,
        highContrastDarkTheme: hcDark,
        themeMode: themeMode,
        themeAnimationDuration: themeAnimationDuration,
        themeAnimationCurve: themeAnimationCurve,
        locale: locale,
        localizationsDelegates: localizationsDelegates,
        localeListResolutionCallback: localeListResolutionCallback,
        localeResolutionCallback: localeResolutionCallback,
        supportedLocales: supportedLocales,
        debugShowMaterialGrid: debugShowMaterialGrid,
        showPerformanceOverlay: showPerformanceOverlay,
        checkerboardRasterCacheImages: checkerboardRasterCacheImages,
        checkerboardOffscreenLayers: checkerboardOffscreenLayers,
        showSemanticsDebugger: showSemanticsDebugger,
        debugShowCheckedModeBanner: debugShowCheckedModeBanner,
        shortcuts: shortcuts,
        actions: actions,
        restorationScopeId: restorationScopeId,
        scrollBehavior: scrollBehavior,
      );
    }

    return MaterialApp(
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: home,
      routes: routes,
      initialRoute: initialRoute,
      onGenerateRoute: onGenerateRoute,
      onGenerateInitialRoutes: onGenerateInitialRoutes,
      onUnknownRoute: onUnknownRoute,
      onNavigationNotification: onNavigationNotification,
      navigatorObservers: navigatorObservers,
      builder: builder,
      title: title,
      onGenerateTitle: onGenerateTitle,
      color: color,
      theme: lightData,
      darkTheme: darkData,
      highContrastTheme: hcLight,
      highContrastDarkTheme: hcDark,
      themeMode: themeMode,
      themeAnimationDuration: themeAnimationDuration,
      themeAnimationCurve: themeAnimationCurve,
      locale: locale,
      localizationsDelegates: localizationsDelegates,
      localeListResolutionCallback: localeListResolutionCallback,
      localeResolutionCallback: localeResolutionCallback,
      supportedLocales: supportedLocales,
      debugShowMaterialGrid: debugShowMaterialGrid,
      showPerformanceOverlay: showPerformanceOverlay,
      checkerboardRasterCacheImages: checkerboardRasterCacheImages,
      checkerboardOffscreenLayers: checkerboardOffscreenLayers,
      showSemanticsDebugger: showSemanticsDebugger,
      debugShowCheckedModeBanner: debugShowCheckedModeBanner,
      shortcuts: shortcuts,
      actions: actions,
      restorationScopeId: restorationScopeId,
      scrollBehavior: scrollBehavior,
    );
  }
}
