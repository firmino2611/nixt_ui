import 'package:flutter/widgets.dart';

import '../../theme/nixt_theme.dart';
import '../../tokens/typography_tokens.dart';
import 'nixt_avatar.dart';

/// Overlapping stack of [NixtAvatar]s with a `+N` overflow chip. Pass avatars
/// already sized to [size] for a clean stack; only the first [max] are shown
/// and the rest collapse into a trailing count.
///
/// ```dart
/// NixtAvatarGroup(
///   avatars: [NixtAvatar(name: 'A B'), NixtAvatar(name: 'C D'), ...],
///   max: 3,
/// );
/// ```
class NixtAvatarGroup extends StatelessWidget {
  /// Creates an avatar group.
  const NixtAvatarGroup({
    required this.avatars,
    this.max = 4,
    this.size = NixtAvatarSize.md,
    super.key,
  });

  /// The avatars to stack. Give them the same [size] for an even row.
  final List<NixtAvatar> avatars;

  /// Maximum shown before a `+N` chip. Defaults to 4.
  final int max;

  /// Diameter used for overlap, ring, and the `+N` chip. Defaults to `md`.
  final NixtAvatarSize size;

  @override
  Widget build(BuildContext context) {
    final c = NixtTheme.of(context).colors;
    final px = _px(size);
    final overlap = (px * 0.32).roundToDouble();
    final step = px - overlap;

    final shown = avatars.take(max).toList();
    final extra = avatars.length - shown.length;

    Widget ringed(Widget child) => Container(
          width: px,
          height: px,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: c.bg, spreadRadius: 2)],
          ),
          child: child,
        );

    final tiles = <Widget>[
      ...shown,
      if (extra > 0)
        Container(
          width: px,
          height: px,
          alignment: Alignment.center,
          decoration:
              BoxDecoration(color: c.bgAccented, shape: BoxShape.circle),
          child: Text(
            '+$extra',
            style: TextStyle(
              fontFamily: NixtTypography.fontSans,
              fontWeight: FontWeight.w600,
              fontSize: px * 0.36,
              color: c.textToned,
            ),
          ),
        ),
    ];

    if (tiles.isEmpty) return const SizedBox.shrink();

    final totalWidth = px + step * (tiles.length - 1);
    return SizedBox(
      width: totalWidth,
      height: px,
      child: Stack(
        children: [
          for (var i = 0; i < tiles.length; i++)
            Positioned(left: step * i, child: ringed(tiles[i])),
        ],
      ),
    );
  }

  static double _px(NixtAvatarSize s) => switch (s) {
        NixtAvatarSize.xs => 24,
        NixtAvatarSize.sm => 32,
        NixtAvatarSize.md => 40,
        NixtAvatarSize.lg => 48,
        NixtAvatarSize.xl => 64,
      };
}
