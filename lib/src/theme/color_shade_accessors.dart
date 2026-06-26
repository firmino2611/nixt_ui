import 'dart:ui';

import '../tokens/color_roles.dart';
import '../tokens/palette.dart';
import 'nixt_colors.dart';

/// Terse, named accessors for every role × shade — sugar over
/// [NixtColors.shade] so you can write `colors.primary600` instead of
/// `colors.shade(NixtColorRole.primary, NixtShade.s600)`.
///
/// All values are theme-resolved (respect the active brightness and any
/// palette overrides). Read them off the current theme:
///
/// ```dart
/// final c = context.nixt.colors;
/// Container(color: c.primary50, child: Text('Hi', style: TextStyle(color: c.primary700)));
/// ```
extension NixtColorShades on NixtColors {
  // ---- primary ----
  /// Primary shade 50.
  Color get primary50 => shade(NixtColorRole.primary, NixtShade.s50);

  /// Primary shade 100.
  Color get primary100 => shade(NixtColorRole.primary, NixtShade.s100);

  /// Primary shade 200.
  Color get primary200 => shade(NixtColorRole.primary, NixtShade.s200);

  /// Primary shade 300.
  Color get primary300 => shade(NixtColorRole.primary, NixtShade.s300);

  /// Primary shade 400.
  Color get primary400 => shade(NixtColorRole.primary, NixtShade.s400);

  /// Primary shade 500.
  Color get primary500 => shade(NixtColorRole.primary, NixtShade.s500);

  /// Primary shade 600.
  Color get primary600 => shade(NixtColorRole.primary, NixtShade.s600);

  /// Primary shade 700.
  Color get primary700 => shade(NixtColorRole.primary, NixtShade.s700);

  /// Primary shade 800.
  Color get primary800 => shade(NixtColorRole.primary, NixtShade.s800);

  /// Primary shade 900.
  Color get primary900 => shade(NixtColorRole.primary, NixtShade.s900);

  /// Primary shade 950.
  Color get primary950 => shade(NixtColorRole.primary, NixtShade.s950);

  // ---- secondary ----
  /// Secondary shade 50.
  Color get secondary50 => shade(NixtColorRole.secondary, NixtShade.s50);

  /// Secondary shade 100.
  Color get secondary100 => shade(NixtColorRole.secondary, NixtShade.s100);

  /// Secondary shade 200.
  Color get secondary200 => shade(NixtColorRole.secondary, NixtShade.s200);

  /// Secondary shade 300.
  Color get secondary300 => shade(NixtColorRole.secondary, NixtShade.s300);

  /// Secondary shade 400.
  Color get secondary400 => shade(NixtColorRole.secondary, NixtShade.s400);

  /// Secondary shade 500.
  Color get secondary500 => shade(NixtColorRole.secondary, NixtShade.s500);

  /// Secondary shade 600.
  Color get secondary600 => shade(NixtColorRole.secondary, NixtShade.s600);

  /// Secondary shade 700.
  Color get secondary700 => shade(NixtColorRole.secondary, NixtShade.s700);

  /// Secondary shade 800.
  Color get secondary800 => shade(NixtColorRole.secondary, NixtShade.s800);

  /// Secondary shade 900.
  Color get secondary900 => shade(NixtColorRole.secondary, NixtShade.s900);

  /// Secondary shade 950.
  Color get secondary950 => shade(NixtColorRole.secondary, NixtShade.s950);

  // ---- success ----
  /// Success shade 50.
  Color get success50 => shade(NixtColorRole.success, NixtShade.s50);

  /// Success shade 100.
  Color get success100 => shade(NixtColorRole.success, NixtShade.s100);

  /// Success shade 200.
  Color get success200 => shade(NixtColorRole.success, NixtShade.s200);

  /// Success shade 300.
  Color get success300 => shade(NixtColorRole.success, NixtShade.s300);

  /// Success shade 400.
  Color get success400 => shade(NixtColorRole.success, NixtShade.s400);

  /// Success shade 500.
  Color get success500 => shade(NixtColorRole.success, NixtShade.s500);

  /// Success shade 600.
  Color get success600 => shade(NixtColorRole.success, NixtShade.s600);

  /// Success shade 700.
  Color get success700 => shade(NixtColorRole.success, NixtShade.s700);

  /// Success shade 800.
  Color get success800 => shade(NixtColorRole.success, NixtShade.s800);

  /// Success shade 900.
  Color get success900 => shade(NixtColorRole.success, NixtShade.s900);

  /// Success shade 950.
  Color get success950 => shade(NixtColorRole.success, NixtShade.s950);

  // ---- info ----
  /// Info shade 50.
  Color get info50 => shade(NixtColorRole.info, NixtShade.s50);

  /// Info shade 100.
  Color get info100 => shade(NixtColorRole.info, NixtShade.s100);

  /// Info shade 200.
  Color get info200 => shade(NixtColorRole.info, NixtShade.s200);

  /// Info shade 300.
  Color get info300 => shade(NixtColorRole.info, NixtShade.s300);

  /// Info shade 400.
  Color get info400 => shade(NixtColorRole.info, NixtShade.s400);

  /// Info shade 500.
  Color get info500 => shade(NixtColorRole.info, NixtShade.s500);

  /// Info shade 600.
  Color get info600 => shade(NixtColorRole.info, NixtShade.s600);

  /// Info shade 700.
  Color get info700 => shade(NixtColorRole.info, NixtShade.s700);

  /// Info shade 800.
  Color get info800 => shade(NixtColorRole.info, NixtShade.s800);

  /// Info shade 900.
  Color get info900 => shade(NixtColorRole.info, NixtShade.s900);

  /// Info shade 950.
  Color get info950 => shade(NixtColorRole.info, NixtShade.s950);

  // ---- warning ----
  /// Warning shade 50.
  Color get warning50 => shade(NixtColorRole.warning, NixtShade.s50);

  /// Warning shade 100.
  Color get warning100 => shade(NixtColorRole.warning, NixtShade.s100);

  /// Warning shade 200.
  Color get warning200 => shade(NixtColorRole.warning, NixtShade.s200);

  /// Warning shade 300.
  Color get warning300 => shade(NixtColorRole.warning, NixtShade.s300);

  /// Warning shade 400.
  Color get warning400 => shade(NixtColorRole.warning, NixtShade.s400);

  /// Warning shade 500.
  Color get warning500 => shade(NixtColorRole.warning, NixtShade.s500);

  /// Warning shade 600.
  Color get warning600 => shade(NixtColorRole.warning, NixtShade.s600);

  /// Warning shade 700.
  Color get warning700 => shade(NixtColorRole.warning, NixtShade.s700);

  /// Warning shade 800.
  Color get warning800 => shade(NixtColorRole.warning, NixtShade.s800);

  /// Warning shade 900.
  Color get warning900 => shade(NixtColorRole.warning, NixtShade.s900);

  /// Warning shade 950.
  Color get warning950 => shade(NixtColorRole.warning, NixtShade.s950);

  // ---- error ----
  /// Error shade 50.
  Color get error50 => shade(NixtColorRole.error, NixtShade.s50);

  /// Error shade 100.
  Color get error100 => shade(NixtColorRole.error, NixtShade.s100);

  /// Error shade 200.
  Color get error200 => shade(NixtColorRole.error, NixtShade.s200);

  /// Error shade 300.
  Color get error300 => shade(NixtColorRole.error, NixtShade.s300);

  /// Error shade 400.
  Color get error400 => shade(NixtColorRole.error, NixtShade.s400);

  /// Error shade 500.
  Color get error500 => shade(NixtColorRole.error, NixtShade.s500);

  /// Error shade 600.
  Color get error600 => shade(NixtColorRole.error, NixtShade.s600);

  /// Error shade 700.
  Color get error700 => shade(NixtColorRole.error, NixtShade.s700);

  /// Error shade 800.
  Color get error800 => shade(NixtColorRole.error, NixtShade.s800);

  /// Error shade 900.
  Color get error900 => shade(NixtColorRole.error, NixtShade.s900);

  /// Error shade 950.
  Color get error950 => shade(NixtColorRole.error, NixtShade.s950);

  // ---- neutral ----
  /// Neutral shade 50.
  Color get neutral50 => shade(NixtColorRole.neutral, NixtShade.s50);

  /// Neutral shade 100.
  Color get neutral100 => shade(NixtColorRole.neutral, NixtShade.s100);

  /// Neutral shade 200.
  Color get neutral200 => shade(NixtColorRole.neutral, NixtShade.s200);

  /// Neutral shade 300.
  Color get neutral300 => shade(NixtColorRole.neutral, NixtShade.s300);

  /// Neutral shade 400.
  Color get neutral400 => shade(NixtColorRole.neutral, NixtShade.s400);

  /// Neutral shade 500.
  Color get neutral500 => shade(NixtColorRole.neutral, NixtShade.s500);

  /// Neutral shade 600.
  Color get neutral600 => shade(NixtColorRole.neutral, NixtShade.s600);

  /// Neutral shade 700.
  Color get neutral700 => shade(NixtColorRole.neutral, NixtShade.s700);

  /// Neutral shade 800.
  Color get neutral800 => shade(NixtColorRole.neutral, NixtShade.s800);

  /// Neutral shade 900.
  Color get neutral900 => shade(NixtColorRole.neutral, NixtShade.s900);

  /// Neutral shade 950.
  Color get neutral950 => shade(NixtColorRole.neutral, NixtShade.s950);
}
