import 'package:flutter/widgets.dart';

import '../../theme/nixt_colors.dart';
import '../../theme/nixt_theme.dart';
import '../../tokens/color_roles.dart';
import '../../tokens/typography_tokens.dart';
import '../icon/nixt_icon.dart';

/// One tab in a [NixtTabs] set.
@immutable
class NixtTabItem<T> {
  /// Creates a tab item.
  const NixtTabItem({required this.label, required this.value, this.icon});

  /// Display label.
  final String label;

  /// Value reported through [NixtTabs.onChanged] when selected.
  final T value;

  /// Optional leading icon.
  final IconData? icon;
}

/// Visual style for [NixtTabs].
enum NixtTabsVariant {
  /// iOS-style segmented control (sliding pill on an elevated track).
  pill,

  /// Underlined links (Material-style).
  link,
}

/// Tab size for [NixtTabs].
enum NixtTabsSize {
  /// 32px tall, 12px text.
  sm,

  /// 38px tall, 14px text (default).
  md,
}

/// Tabs — a `pill` segmented control or `link` underline row. Controlled via
/// [value] + [onChanged]. [block] stretches tabs to fill the width.
///
/// ```dart
/// NixtTabs<String>(
///   value: tab,
///   onChanged: (v) => setState(() => tab = v),
///   items: const [
///     NixtTabItem(label: 'All', value: 'all'),
///     NixtTabItem(label: 'Unread', value: 'unread'),
///   ],
/// );
/// ```
class NixtTabs<T> extends StatelessWidget {
  /// Creates a tab set.
  const NixtTabs({
    required this.items,
    required this.value,
    this.onChanged,
    this.variant = NixtTabsVariant.pill,
    this.color = NixtColorRole.primary,
    this.block = true,
    this.size = NixtTabsSize.md,
    super.key,
  });

  /// The tabs.
  final List<NixtTabItem<T>> items;

  /// Selected value.
  final T value;

  /// Selection callback.
  final ValueChanged<T>? onChanged;

  /// Visual style. Defaults to `pill`.
  final NixtTabsVariant variant;

  /// Accent color role. Defaults to `primary`.
  final NixtColorRole color;

  /// Stretch tabs to fill the width. Defaults to true.
  final bool block;

  /// Tab size. Defaults to `md`.
  final NixtTabsSize size;

  double get _fontSize =>
      size == NixtTabsSize.sm ? NixtTypography.textXs : NixtTypography.textSm;
  double get _height => size == NixtTabsSize.sm ? 32 : 38;

  static const _duration = Duration(milliseconds: 220);
  static const _curve = Curves.easeOutCubic;

  /// Horizontal alignment (-1..1) for the indicator over (fractional) slot [i]
  /// of [n]. Fractional [i] gives a smooth slide between slots.
  static double _alignX(double i, int n) => n <= 1 ? 0 : -1 + 2 * i / (n - 1);

  @override
  Widget build(BuildContext context) {
    final t = NixtTheme.of(context);
    final c = t.colors;
    final accent =
        color == NixtColorRole.neutral ? c.textHighlighted : c.role(color);
    final n = items.length;
    final activeIndex = items.indexWhere((it) => it.value == value);
    final hasActive = activeIndex >= 0;
    final widthFactor = n == 0 ? 1.0 : 1 / n;

    final isLink = variant == NixtTabsVariant.link;
    final cellHeight = isLink ? _height + 6 : _height;

    final cells = Row(
      children: [
        for (var i = 0; i < n; i++)
          _flex(
            child: _TabCell(
              item: items[i],
              active: i == activeIndex,
              activeText: isLink ? accent : c.textHighlighted,
              accent: accent,
              inactive: c.textMuted,
              isLink: isLink,
              height: cellHeight,
              fontSize: _fontSize,
              duration: _duration,
              onTap:
                  onChanged == null ? null : () => onChanged!(items[i].value),
            ),
          ),
      ],
    );

    // A single sliding indicator (white pill / underline) animates between
    // slots via a TweenAnimationBuilder on the fractional active index — so
    // switching tabs never cross-fades a fill (the old gray-flash bug).
    final stack = SizedBox(
      height: cellHeight,
      child: Stack(
        children: [
          if (hasActive)
            Positioned.fill(
              child: TweenAnimationBuilder<double>(
                tween: Tween(end: activeIndex.toDouble()),
                duration: _duration,
                curve: _curve,
                builder: (_, idx, __) => Align(
                  alignment: Alignment(_alignX(idx, n), isLink ? 1 : 0),
                  child: FractionallySizedBox(
                    widthFactor: widthFactor,
                    child: _indicatorBody(c, t, isLink, accent),
                  ),
                ),
              ),
            ),
          cells,
        ],
      ),
    );

    if (isLink) {
      return DecoratedBox(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: c.border)),
        ),
        child: stack,
      );
    }

    final track = Container(
      decoration: BoxDecoration(
        color: c.bgElevated,
        borderRadius: BorderRadius.circular(t.radius.lg),
      ),
      child: stack,
    );
    return block ? track : IntrinsicWidth(child: track);
  }

  Widget _flex({required Widget child}) =>
      block ? Expanded(child: child) : child;
}

/// The visual body of the sliding indicator (white pill / underline bar).
Widget _indicatorBody(NixtColors c, NixtTheme t, bool isLink, Color accent) {
  if (isLink) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(height: 2, color: accent),
    );
  }
  return Container(
    margin: const EdgeInsets.all(3),
    decoration: BoxDecoration(
      color: c.bg,
      borderRadius: BorderRadius.circular(t.radius.lg - 3),
      boxShadow: t.shadows.sm,
    ),
  );
}

class _TabCell extends StatelessWidget {
  const _TabCell({
    required this.item,
    required this.active,
    required this.activeText,
    required this.accent,
    required this.inactive,
    required this.isLink,
    required this.height,
    required this.fontSize,
    required this.duration,
    required this.onTap,
  });

  final NixtTabItem<Object?> item;
  final bool active;
  final Color activeText;
  final Color accent;
  final Color inactive;
  final bool isLink;
  final double height;
  final double fontSize;
  final Duration duration;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final fg = active ? activeText : inactive;
    final iconColor = active ? accent : inactive;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: height,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.icon != null) ...[
                TweenAnimationBuilder<Color?>(
                  tween: ColorTween(end: iconColor),
                  duration: duration,
                  builder: (_, col, __) =>
                      NixtIcon(item.icon!, size: 16, color: col ?? iconColor),
                ),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: AnimatedDefaultTextStyle(
                  duration: duration,
                  style: TextStyle(
                    fontFamily: NixtTypography.fontSans,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                    color: fg,
                  ),
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
