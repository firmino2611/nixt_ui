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
