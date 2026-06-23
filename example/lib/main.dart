import 'package:flutter/material.dart';
import 'package:nixt_ui/nixt_ui.dart';

import 'gallery_controls.dart';
import 'screens/home_screen.dart';

void main() => runApp(const GalleryApp());

/// Root of the component gallery. Owns the brightness + neutral selection and
/// rebuilds the [NixtTheme] accordingly, exposing both via [GalleryControls].
class GalleryApp extends StatefulWidget {
  /// Creates the gallery app.
  const GalleryApp({super.key});

  @override
  State<GalleryApp> createState() => _GalleryAppState();
}

class _GalleryAppState extends State<GalleryApp> {
  Brightness _brightness = Brightness.light;
  NixtNeutral _neutral = NixtNeutral.slate;
  final Map<NixtColorRole, NixtColorScale> _roles = {};
  double _radiusBase = 8;

  bool get _isDark => _brightness == Brightness.dark;

  void _setRole(NixtColorRole role, Color? seed) => setState(() {
        if (seed == null) {
          _roles.remove(role);
        } else {
          _roles[role] = NixtColorScale.fromSeed(seed);
        }
      });

  void _reset() => setState(() {
        _roles.clear();
        _neutral = NixtNeutral.slate;
        _radiusBase = 8;
      });

  @override
  Widget build(BuildContext context) {
    final roles = Map<NixtColorRole, NixtColorScale>.from(_roles);

    return GalleryControls(
      isDark: _isDark,
      neutral: _neutral,
      roles: roles,
      radiusBase: _radiusBase,
      toggleBrightness: () => setState(
        () => _brightness = _isDark ? Brightness.light : Brightness.dark,
      ),
      setNeutral: (n) => setState(() => _neutral = n),
      setRole: _setRole,
      setRadius: (r) => setState(() => _radiusBase = r),
      resetTheme: _reset,
      // The whole DS is configured here — every component reads it.
      child: NixtApp(
        title: 'Nixt UI Gallery',
        debugShowCheckedModeBanner: false,
        neutral: _neutral,
        radius: NixtRadius(base: _radiusBase),
        roles: roles,
        themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
        home: const HomeScreen(),
      ),
    );
  }
}
