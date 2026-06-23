import 'package:flutter/widgets.dart';

/// Radius scale from `radius.css` — Nuxt's single-token model: one [base]
/// value drives the whole scale via multipliers. Changing [base] re-rounds the
/// entire system at once.
@immutable
class NixtRadius {
  /// Creates a radius scale from a single [base] value (logical px).
  const NixtRadius({this.base = 8});

  /// The mobile-comfortable default (8px). Set 0 for sharp, 16 for very soft.
  final double base;

  /// 0.5 × base.
  double get xs => base * 0.5;

  /// 0.75 × base.
  double get sm => base * 0.75;

  /// 1 × base.
  double get md => base;

  /// 1.5 × base.
  double get lg => base * 1.5;

  /// 2 × base.
  double get xl => base * 2;

  /// 3 × base.
  double get xxl => base * 3;

  /// 4 × base.
  double get xxxl => base * 4;

  /// Pill / fully rounded.
  double get full => 9999;

  /// [xs] as a [BorderRadius].
  BorderRadius get brXs => BorderRadius.circular(xs);

  /// [sm] as a [BorderRadius].
  BorderRadius get brSm => BorderRadius.circular(sm);

  /// [md] as a [BorderRadius].
  BorderRadius get brMd => BorderRadius.circular(md);

  /// [lg] as a [BorderRadius].
  BorderRadius get brLg => BorderRadius.circular(lg);

  /// [xl] as a [BorderRadius].
  BorderRadius get brXl => BorderRadius.circular(xl);

  /// Linearly interpolates between two scales (drives theme animation).
  static NixtRadius lerp(NixtRadius a, NixtRadius b, double t) =>
      NixtRadius(base: a.base + (b.base - a.base) * t);

  @override
  bool operator ==(Object other) => other is NixtRadius && other.base == base;

  @override
  int get hashCode => base.hashCode;
}
