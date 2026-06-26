import 'dart:ui';

/// Returns [color] with its alpha replaced by [opacity] (0.0–1.0).
///
/// Centralizes the one `withOpacity` call site so the rest of the package stays
/// lint-clean. `withOpacity` (rather than the newer `withValues`) is used
/// deliberately to keep the Flutter 3.19 minimum-SDK target — `withValues` only
/// exists on 3.27+.
Color nixtOpacity(Color color, double opacity) =>
    // ignore: deprecated_member_use
    color.withOpacity(opacity);

/// A contrast-safe foreground (near-black or white) for content painted on a
/// [background] fill, chosen by relative luminance.
///
/// Used wherever text or icons sit on a solid color — buttons, badges, app
/// bars — so a light fill (e.g. a bright cyan or amber) gets dark glyphs and a
/// dark fill gets white ones, instead of always assuming white.
Color nixtOnColor(Color background) =>
    background.computeLuminance() > 0.55
        ? const Color(0xFF18181B)
        : const Color(0xFFFFFFFF);
