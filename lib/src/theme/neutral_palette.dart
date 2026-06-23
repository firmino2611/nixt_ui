import '../tokens/palette.dart';

/// The switchable neutral palette — Nuxt's `[data-neutral]` mechanism.
///
/// Surfaces, text, and borders are derived from the selected neutral scale.
enum NixtNeutral {
  /// Cool gray (the default).
  slate,

  /// Neutral-cool gray.
  zinc,

  /// True gray.
  neutral,

  /// Warm gray.
  stone;

  /// The raw scale backing this choice.
  NixtColorScale get scale => switch (this) {
        NixtNeutral.slate => NixtPalette.slate,
        NixtNeutral.zinc => NixtPalette.zinc,
        NixtNeutral.neutral => NixtPalette.neutral,
        NixtNeutral.stone => NixtPalette.stone,
      };
}
