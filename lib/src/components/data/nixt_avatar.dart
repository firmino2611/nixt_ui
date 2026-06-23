import 'package:flutter/widgets.dart';

import '../../foundations/nixt_icons.dart';
import '../../theme/nixt_theme.dart';
import '../../tokens/typography_tokens.dart';
import '../icon/nixt_icon.dart';

/// Preset avatar diameters.
enum NixtAvatarSize {
  /// 24px.
  xs,

  /// 32px.
  sm,

  /// 40px (default).
  md,

  /// 48px.
  lg,

  /// 64px.
  xl,
}

extension _AvatarPx on NixtAvatarSize {
  double get px => switch (this) {
        NixtAvatarSize.xs => 24,
        NixtAvatarSize.sm => 32,
        NixtAvatarSize.md => 40,
        NixtAvatarSize.lg => 48,
        NixtAvatarSize.xl => 64,
      };
}

/// Presence status — maps to a colored corner dot.
enum NixtAvatarStatus {
  /// Success-colored dot.
  online,

  /// Warning-colored dot.
  away,

  /// Error-colored dot.
  busy,

  /// Dimmed dot.
  offline,
}

/// Avatar — shows an image, falling back to initials (from [name]), then an
/// [icon]. Optional presence [status] dot in the corner. Circle by default;
/// set [square] for a rounded square.
///
/// Use [pixelSize] for a custom diameter, otherwise [size] picks a preset.
///
/// ```dart
/// NixtAvatar(name: 'Ada Lovelace');                       // "AL" initials
/// NixtAvatar(src: url, status: NixtAvatarStatus.online);  // image + dot
/// NixtAvatar(size: NixtAvatarSize.xl, square: true);      // icon fallback
/// ```
class NixtAvatar extends StatelessWidget {
  /// Creates an avatar.
  const NixtAvatar({
    this.src,
    this.name,
    this.icon = NixtIcons.user,
    this.size = NixtAvatarSize.md,
    this.pixelSize,
    this.status,
    this.statusColor,
    this.square = false,
    super.key,
  });

  /// Image URL. Falls back to initials, then [icon].
  final String? src;

  /// Name → initials fallback when no [src].
  final String? name;

  /// Icon fallback when no [src] / [name]. Defaults to a user glyph.
  final IconData icon;

  /// Preset size. Ignored when [pixelSize] is set. Defaults to `md`.
  final NixtAvatarSize size;

  /// Custom diameter in logical px (overrides [size]).
  final double? pixelSize;

  /// Presence status dot.
  final NixtAvatarStatus? status;

  /// Custom status-dot color (overrides the [status] keyword color).
  final Color? statusColor;

  /// Rounded-square instead of a circle. Defaults to false.
  final bool square;

  String? get _initials {
    final n = name?.trim();
    if (n == null || n.isEmpty) return null;
    final parts = n.split(RegExp(r'\s+'));
    final letters = parts.take(2).map((w) => w[0]).join();
    return letters.toUpperCase();
  }

  Color _statusColor(BuildContext context) {
    if (statusColor != null) return statusColor!;
    final c = NixtTheme.of(context).colors;
    return switch (status!) {
      NixtAvatarStatus.online => c.success,
      NixtAvatarStatus.away => c.warning,
      NixtAvatarStatus.busy => c.error,
      NixtAvatarStatus.offline => c.textDimmed,
    };
  }

  @override
  Widget build(BuildContext context) {
    final t = NixtTheme.of(context);
    final c = t.colors;
    final px = pixelSize ?? size.px;
    final radius =
        square ? BorderRadius.circular(t.radius.lg) : BorderRadius.circular(px);

    final initials = _initials;
    final fallback = _AvatarFallback(icon: icon, initials: initials, px: px);
    final Widget content = src != null
        ? Image.network(
            src!,
            width: px,
            height: px,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => fallback,
          )
        : fallback;

    return SizedBox(
      width: px,
      height: px,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: px,
            height: px,
            decoration: BoxDecoration(
              color: c.bgElevated,
              borderRadius: radius,
              border: Border.all(color: c.border, width: 1),
            ),
            clipBehavior: Clip.antiAlias,
            child: content,
          ),
          if (status != null || statusColor != null)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: (px * 0.26).clamp(8, double.infinity),
                height: (px * 0.26).clamp(8, double.infinity),
                decoration: BoxDecoration(
                  color: _statusColor(context),
                  shape: BoxShape.circle,
                  border: Border.all(color: c.bg, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback(
      {required this.icon, required this.initials, required this.px});
  final IconData icon;
  final String? initials;
  final double px;

  @override
  Widget build(BuildContext context) {
    final c = NixtTheme.of(context).colors;
    if (initials != null) {
      return Center(
        child: Text(
          initials!,
          style: TextStyle(
            fontFamily: NixtTypography.fontSans,
            fontWeight: FontWeight.w600,
            fontSize: px * 0.4,
            color: c.textMuted,
          ),
        ),
      );
    }
    return Center(
      child: NixtIcon(icon, size: px * 0.55, color: c.textDimmed),
    );
  }
}
