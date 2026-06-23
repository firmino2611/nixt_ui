import 'dart:ui';

/// A single color scale (shades `50` through `950`), mirroring the raw
/// Tailwind/Nuxt palette steps from the design system's `palette.css`.
///
/// These are immutable design primitives. Product code should never reference
/// them directly — consume the semantic roles in [NixtColors] instead.
class NixtColorScale {
  /// Creates a scale from an explicit shade map (keys 50..950).
  const NixtColorScale(this._shades);

  final Map<int, Color> _shades;

  /// Builds a full 50→950 scale from a single [seed] color, used as shade
  /// `500`. Lighter shades blend toward white, darker shades toward black —
  /// enough fidelity to retheme a role (e.g. a custom brand color) while
  /// preserving the design system's "lighten one step in dark mode" behavior.
  factory NixtColorScale.fromSeed(Color seed) {
    const white = Color(0xFFFFFFFF);
    const black = Color(0xFF000000);
    Color toWhite(double f) => Color.lerp(seed, white, f)!;
    Color toBlack(double f) => Color.lerp(seed, black, f)!;
    return NixtColorScale({
      50: toWhite(0.95),
      100: toWhite(0.88),
      200: toWhite(0.72),
      300: toWhite(0.50),
      400: toWhite(0.24),
      500: seed,
      600: toBlack(0.12),
      700: toBlack(0.26),
      800: toBlack(0.40),
      900: toBlack(0.53),
      950: toBlack(0.70),
    });
  }

  /// Returns the color for [step] (one of 50, 100, 200 … 950).
  Color shade(int step) => _shades[step]!;

  /// Lightest shade.
  Color get s50 => _shades[50]!;

  /// Shade 100.
  Color get s100 => _shades[100]!;

  /// Shade 200.
  Color get s200 => _shades[200]!;

  /// Shade 300.
  Color get s300 => _shades[300]!;

  /// Shade 400.
  Color get s400 => _shades[400]!;

  /// Shade 500.
  Color get s500 => _shades[500]!;

  /// Shade 600.
  Color get s600 => _shades[600]!;

  /// Shade 700.
  Color get s700 => _shades[700]!;

  /// Shade 800.
  Color get s800 => _shades[800]!;

  /// Shade 900.
  Color get s900 => _shades[900]!;

  /// Darkest shade.
  Color get s950 => _shades[950]!;
}

/// Raw color primitives — the immutable design tokens from `palette.css`.
///
/// Includes the brand/status hues and the four switchable neutral candidates.
abstract final class NixtPalette {
  /// Absolute white.
  static const Color white = Color(0xFFFFFFFF);

  /// Absolute black.
  static const Color black = Color(0xFF000000);

  /// Nuxt signature green (primary + success). `400` is `#00DC82`.
  static const NixtColorScale green = NixtColorScale({
    50: Color(0xFFEFFDF5),
    100: Color(0xFFD9FBE8),
    200: Color(0xFFB3F5D1),
    300: Color(0xFF75EDAE),
    400: Color(0xFF00DC82),
    500: Color(0xFF00C16A),
    600: Color(0xFF00A155),
    700: Color(0xFF007F45),
    800: Color(0xFF016538),
    900: Color(0xFF0A5331),
    950: Color(0xFF052E16),
  });

  /// Secondary — blue.
  static const NixtColorScale blue = NixtColorScale({
    50: Color(0xFFEFF6FF),
    100: Color(0xFFDBEAFE),
    200: Color(0xFFBFDBFE),
    300: Color(0xFF93C5FD),
    400: Color(0xFF60A5FA),
    500: Color(0xFF3B82F6),
    600: Color(0xFF2563EB),
    700: Color(0xFF1D4ED8),
    800: Color(0xFF1E40AF),
    900: Color(0xFF1E3A8A),
    950: Color(0xFF172554),
  });

  /// Info — sky.
  static const NixtColorScale sky = NixtColorScale({
    50: Color(0xFFF0F9FF),
    100: Color(0xFFE0F2FE),
    200: Color(0xFFBAE6FD),
    300: Color(0xFF7DD3FC),
    400: Color(0xFF38BDF8),
    500: Color(0xFF0EA5E9),
    600: Color(0xFF0284C7),
    700: Color(0xFF0369A1),
    800: Color(0xFF075985),
    900: Color(0xFF0C4A6E),
    950: Color(0xFF082F49),
  });

  /// Warning — amber.
  static const NixtColorScale amber = NixtColorScale({
    50: Color(0xFFFFFBEB),
    100: Color(0xFFFEF3C7),
    200: Color(0xFFFDE68A),
    300: Color(0xFFFCD34D),
    400: Color(0xFFFBBF24),
    500: Color(0xFFF59E0B),
    600: Color(0xFFD97706),
    700: Color(0xFFB45309),
    800: Color(0xFF92400E),
    900: Color(0xFF78350F),
    950: Color(0xFF451A03),
  });

  /// Error — red.
  static const NixtColorScale red = NixtColorScale({
    50: Color(0xFFFEF2F2),
    100: Color(0xFFFEE2E2),
    200: Color(0xFFFECACA),
    300: Color(0xFFFCA5A5),
    400: Color(0xFFF87171),
    500: Color(0xFFEF4444),
    600: Color(0xFFDC2626),
    700: Color(0xFFB91C1C),
    800: Color(0xFF991B1B),
    900: Color(0xFF7F1D1D),
    950: Color(0xFF450A0A),
  });

  /// Neutral candidate — slate (cool, the default).
  static const NixtColorScale slate = NixtColorScale({
    50: Color(0xFFF8FAFC),
    100: Color(0xFFF1F5F9),
    200: Color(0xFFE2E8F0),
    300: Color(0xFFCBD5E1),
    400: Color(0xFF94A3B8),
    500: Color(0xFF64748B),
    600: Color(0xFF475569),
    700: Color(0xFF334155),
    800: Color(0xFF1E293B),
    900: Color(0xFF0F172A),
    950: Color(0xFF020617),
  });

  /// Neutral candidate — zinc (neutral-cool).
  static const NixtColorScale zinc = NixtColorScale({
    50: Color(0xFFFAFAFA),
    100: Color(0xFFF4F4F5),
    200: Color(0xFFE4E4E7),
    300: Color(0xFFD4D4D8),
    400: Color(0xFFA1A1AA),
    500: Color(0xFF71717A),
    600: Color(0xFF52525B),
    700: Color(0xFF3F3F46),
    800: Color(0xFF27272A),
    900: Color(0xFF18181B),
    950: Color(0xFF09090B),
  });

  /// Neutral candidate — neutral (true gray).
  static const NixtColorScale neutral = NixtColorScale({
    50: Color(0xFFFAFAFA),
    100: Color(0xFFF5F5F5),
    200: Color(0xFFE5E5E5),
    300: Color(0xFFD4D4D4),
    400: Color(0xFFA3A3A3),
    500: Color(0xFF737373),
    600: Color(0xFF525252),
    700: Color(0xFF404040),
    800: Color(0xFF262626),
    900: Color(0xFF171717),
    950: Color(0xFF0A0A0A),
  });

  /// Neutral candidate — stone (warm).
  static const NixtColorScale stone = NixtColorScale({
    50: Color(0xFFFAFAF9),
    100: Color(0xFFF5F5F4),
    200: Color(0xFFE7E5E4),
    300: Color(0xFFD6D3D1),
    400: Color(0xFFA8A29E),
    500: Color(0xFF78716C),
    600: Color(0xFF57534E),
    700: Color(0xFF44403C),
    800: Color(0xFF292524),
    900: Color(0xFF1C1917),
    950: Color(0xFF0C0A09),
  });
}
