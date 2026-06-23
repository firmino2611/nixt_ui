import 'package:flutter/widgets.dart';

import '../foundations/color_util.dart';

/// Elevation shadows from `shadows.css` — soft, neutral-tinted. Nuxt leans on
/// hairline borders plus restrained shadows. Dark mode deepens opacity for the
/// same perceived elevation.
@immutable
class NixtShadows {
  /// Creates a shadow set for the given [brightness].
  const NixtShadows._(this.xs, this.sm, this.md, this.lg, this.xl, this.sheet);

  /// Extra-small elevation.
  final List<BoxShadow> xs;

  /// Small elevation.
  final List<BoxShadow> sm;

  /// Medium elevation.
  final List<BoxShadow> md;

  /// Large elevation.
  final List<BoxShadow> lg;

  /// Extra-large elevation.
  final List<BoxShadow> xl;

  /// Upward-casting shadow for bottom sheets / floating mobile surfaces.
  final List<BoxShadow> sheet;

  /// Light-mode shadow set.
  factory NixtShadows.light() {
    const k = Color(0xFF000000);
    return NixtShadows._(
      [
        BoxShadow(
            color: nixtOpacity(k, 0.05),
            offset: const Offset(0, 1),
            blurRadius: 2)
      ],
      [
        BoxShadow(
            color: nixtOpacity(k, 0.08),
            offset: const Offset(0, 1),
            blurRadius: 3),
        BoxShadow(
            color: nixtOpacity(k, 0.08),
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: -1),
      ],
      [
        BoxShadow(
            color: nixtOpacity(k, 0.08),
            offset: const Offset(0, 4),
            blurRadius: 6,
            spreadRadius: -1),
        BoxShadow(
            color: nixtOpacity(k, 0.06),
            offset: const Offset(0, 2),
            blurRadius: 4,
            spreadRadius: -2),
      ],
      [
        BoxShadow(
            color: nixtOpacity(k, 0.10),
            offset: const Offset(0, 10),
            blurRadius: 15,
            spreadRadius: -3),
        BoxShadow(
            color: nixtOpacity(k, 0.08),
            offset: const Offset(0, 4),
            blurRadius: 6,
            spreadRadius: -4),
      ],
      [
        BoxShadow(
            color: nixtOpacity(k, 0.12),
            offset: const Offset(0, 20),
            blurRadius: 25,
            spreadRadius: -5),
        BoxShadow(
            color: nixtOpacity(k, 0.08),
            offset: const Offset(0, 8),
            blurRadius: 10,
            spreadRadius: -6),
      ],
      [
        BoxShadow(
            color: nixtOpacity(k, 0.12),
            offset: const Offset(0, -8),
            blurRadius: 24,
            spreadRadius: -8)
      ],
    );
  }

  /// Dark-mode shadow set (deeper opacity).
  factory NixtShadows.dark() {
    const k = Color(0xFF000000);
    return NixtShadows._(
      [
        BoxShadow(
            color: nixtOpacity(k, 0.30),
            offset: const Offset(0, 1),
            blurRadius: 2)
      ],
      [
        BoxShadow(
            color: nixtOpacity(k, 0.40),
            offset: const Offset(0, 1),
            blurRadius: 3),
        BoxShadow(
            color: nixtOpacity(k, 0.40),
            offset: const Offset(0, 1),
            blurRadius: 2,
            spreadRadius: -1),
      ],
      [
        BoxShadow(
            color: nixtOpacity(k, 0.45),
            offset: const Offset(0, 4),
            blurRadius: 6,
            spreadRadius: -1),
        BoxShadow(
            color: nixtOpacity(k, 0.40),
            offset: const Offset(0, 2),
            blurRadius: 4,
            spreadRadius: -2),
      ],
      [
        BoxShadow(
            color: nixtOpacity(k, 0.50),
            offset: const Offset(0, 10),
            blurRadius: 15,
            spreadRadius: -3),
        BoxShadow(
            color: nixtOpacity(k, 0.45),
            offset: const Offset(0, 4),
            blurRadius: 6,
            spreadRadius: -4),
      ],
      [
        BoxShadow(
            color: nixtOpacity(k, 0.55),
            offset: const Offset(0, 20),
            blurRadius: 25,
            spreadRadius: -5),
        BoxShadow(
            color: nixtOpacity(k, 0.50),
            offset: const Offset(0, 8),
            blurRadius: 10,
            spreadRadius: -6),
      ],
      [
        BoxShadow(
            color: nixtOpacity(k, 0.55),
            offset: const Offset(0, -8),
            blurRadius: 24,
            spreadRadius: -8)
      ],
    );
  }
}
