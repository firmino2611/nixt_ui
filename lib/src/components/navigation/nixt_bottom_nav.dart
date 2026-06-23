import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import '../../foundations/color_util.dart';
import '../../theme/nixt_theme.dart';
import '../../tokens/color_roles.dart';
import '../../tokens/typography_tokens.dart';
import '../icon/nixt_icon.dart';

/// One destination in a [NixtBottomNav].
@immutable
class NixtBottomNavItem<T> {
  /// Creates a bottom-nav item.
  const NixtBottomNavItem({
    required this.label,
    required this.value,
    required this.icon,
    this.activeIcon,
    this.badge,
  });

  /// Tab label.
  final String label;

  /// Value reported through [NixtBottomNav.onChanged] when tapped.
  final T value;

  /// Icon shown when inactive (and active, unless [activeIcon] is set).
  final IconData icon;

  /// Optional icon swapped in when active (e.g. a filled glyph).
  final IconData? activeIcon;

  /// Optional badge text (e.g. an unread count). Null hides the badge.
  final String? badge;
}

/// Visual style for [NixtBottomNav].
enum NixtBottomNavVariant {
  /// Icon over label, active tinted (Cupertino).
  ios,

  /// Active icon sits in a tinted pill (Material 3).
  material,
}

/// Bottom tab bar. Controlled via [value] + [onChanged]. Frosted translucent
/// surface with a hairline top border; includes bottom safe-area padding.
///
/// ```dart
/// NixtBottomNav<int>(
///   value: tab,
///   onChanged: (v) => setState(() => tab = v),
///   items: const [
///     NixtBottomNavItem(label: 'Home', value: 0, icon: NixtIcons.home),
///     NixtBottomNavItem(label: 'Alerts', value: 1, icon: NixtIcons.bell, badge: '3'),
///   ],
/// );
/// ```
class NixtBottomNav<T> extends StatelessWidget {
  /// Creates a bottom nav bar.
  const NixtBottomNav({
    required this.items,
    required this.value,
    this.onChanged,
    this.variant = NixtBottomNavVariant.ios,
    this.color = NixtColorRole.primary,
    super.key,
  });

  /// The destinations.
  final List<NixtBottomNavItem<T>> items;

  /// Selected value.
  final T value;

  /// Selection callback.
  final ValueChanged<T>? onChanged;

  /// Visual style. Defaults to `ios`.
  final NixtBottomNavVariant variant;

  /// Accent color role. Defaults to `primary`.
  final NixtColorRole color;

  @override
  Widget build(BuildContext context) {
    final c = NixtTheme.of(context).colors;
    final accent =
        color == NixtColorRole.neutral ? c.textHighlighted : c.role(color);
    final isMaterial = variant == NixtBottomNavVariant.material;
    final safeBottom = MediaQuery.maybeOf(context)?.viewPadding.bottom ?? 0;

    final bar = DecoratedBox(
      decoration: BoxDecoration(
        color: nixtOpacity(c.bg, 0.88),
        border: Border(top: BorderSide(color: c.border)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(8, 8, 8, 8 + safeBottom * 0.4),
        child: Row(
          children: [
            for (final it in items)
              Expanded(
                child: _NavButton(
                  item: it,
                  active: it.value == value,
                  accent: accent,
                  inactive: c.textDimmed,
                  badgeBorder: c.bg,
                  errorColor: c.error,
                  isMaterial: isMaterial,
                  onTap: onChanged == null ? null : () => onChanged!(it.value),
                ),
              ),
          ],
        ),
      ),
    );

    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: bar,
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.active,
    required this.accent,
    required this.inactive,
    required this.badgeBorder,
    required this.errorColor,
    required this.isMaterial,
    required this.onTap,
  });

  final NixtBottomNavItem<Object?> item;
  final bool active;
  final Color accent;
  final Color inactive;
  final Color badgeBorder;
  final Color errorColor;
  final bool isMaterial;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final fg = active ? accent : inactive;
    final glyph = active ? (item.activeIcon ?? item.icon) : item.icon;

    final iconWithBadge = Stack(
      clipBehavior: Clip.none,
      children: [
        NixtIcon(glyph, size: 24, color: fg),
        if (item.badge != null)
          Positioned(
            top: -2,
            right: isMaterial ? -10 : -8,
            child:
                _Badge(text: item.badge!, bg: errorColor, border: badgeBorder),
          ),
      ],
    );

    final pill = isMaterial
        ? AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 56,
            height: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color:
                  active ? nixtOpacity(accent, 0.16) : const Color(0x00000000),
              borderRadius: BorderRadius.circular(999),
            ),
            child: iconWithBadge,
          )
        : iconWithBadge;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            pill,
            const SizedBox(height: 3),
            Text(
              item.label,
              style: TextStyle(
                fontFamily: NixtTypography.fontSans,
                fontSize: 11,
                fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                letterSpacing: 0.1,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text, required this.bg, required this.border});
  final String text;
  final Color bg;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 16),
      height: 16,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: border, width: 2),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: NixtTypography.fontSans,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          height: 1,
          color: Color(0xFFFFFFFF),
        ),
      ),
    );
  }
}
