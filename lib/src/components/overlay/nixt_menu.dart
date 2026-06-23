import 'package:flutter/material.dart';

import '../../theme/nixt_theme.dart';
import '../../tokens/typography_tokens.dart';
import '../icon/nixt_icon.dart';

/// One row in a [NixtMenu].
@immutable
class NixtMenuItem {
  /// Creates a menu item.
  const NixtMenuItem(
      {this.label, this.icon, this.destructive = false, this.onPressed})
      : separator = false;

  /// A divider row. All other fields are ignored.
  const NixtMenuItem.separator()
      : label = null,
        icon = null,
        destructive = false,
        onPressed = null,
        separator = true;

  /// Row label.
  final String? label;

  /// Optional leading icon.
  final IconData? icon;

  /// Render red (delete / sign-out etc.).
  final bool destructive;

  /// Whether this row is a divider.
  final bool separator;

  /// Tap callback (fired before the menu closes).
  final VoidCallback? onPressed;
}

/// Which edge the popover aligns to.
enum NixtMenuAlign {
  /// Align to the trigger's leading edge.
  start,

  /// Align to the trigger's trailing edge (default).
  end,
}

/// Anchored dropdown menu (kebab / overflow actions). Wrap the [trigger]; the
/// popover opens just beneath it and closes on selection or tap-outside.
///
/// ```dart
/// NixtMenu(
///   trigger: NixtIconButton(icon: NixtIcons.moreVertical, label: 'More'),
///   items: [
///     NixtMenuItem(label: 'Edit', icon: NixtIcons.pencil, onPressed: edit),
///     NixtMenuItem.separator(),
///     NixtMenuItem(label: 'Delete', icon: NixtIcons.trash, destructive: true, onPressed: del),
///   ],
/// );
/// ```
class NixtMenu extends StatefulWidget {
  /// Creates a menu.
  const NixtMenu({
    required this.trigger,
    required this.items,
    this.align = NixtMenuAlign.end,
    this.minWidth = 0,
    super.key,
  });

  /// The element that opens the menu.
  final Widget trigger;

  /// The rows.
  final List<NixtMenuItem> items;

  /// Which edge the popover aligns to. Defaults to `end`.
  final NixtMenuAlign align;

  /// Minimum popover width. Defaults to 0 (sized to the widest row).
  final double minWidth;

  @override
  State<NixtMenu> createState() => _NixtMenuState();
}

class _NixtMenuState extends State<NixtMenu> {
  final LayerLink _link = LayerLink();
  OverlayEntry? _entry;

  bool get _open => _entry != null;

  @override
  void dispose() {
    // Remove without setState — the element is being torn down.
    _entry?.remove();
    _entry = null;
    super.dispose();
  }

  void _toggle() => _open ? _close() : _show();

  void _close() {
    _entry?.remove();
    _entry = null;
    if (mounted) setState(() {});
  }

  void _show() {
    final t = NixtTheme.of(context);
    _entry = OverlayEntry(
      builder: (_) => _MenuPopover(
        link: _link,
        theme: t,
        items: widget.items,
        align: widget.align,
        minWidth: widget.minWidth,
        onPick: (item) {
          item.onPressed?.call();
          _close();
        },
        onDismiss: _close,
      ),
    );
    Overlay.of(context).insert(_entry!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _toggle,
        child: widget.trigger,
      ),
    );
  }
}

class _MenuPopover extends StatefulWidget {
  const _MenuPopover({
    required this.link,
    required this.theme,
    required this.items,
    required this.align,
    required this.minWidth,
    required this.onPick,
    required this.onDismiss,
  });

  final LayerLink link;
  final NixtTheme theme;
  final List<NixtMenuItem> items;
  final NixtMenuAlign align;
  final double minWidth;
  final ValueChanged<NixtMenuItem> onPick;
  final VoidCallback onDismiss;

  @override
  State<_MenuPopover> createState() => _MenuPopoverState();
}

class _MenuPopoverState extends State<_MenuPopover>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 140),
  )..forward();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.theme.colors;
    final r = widget.theme.radius;
    final isEnd = widget.align == NixtMenuAlign.end;
    final anchor = isEnd ? Alignment.bottomRight : Alignment.bottomLeft;
    final follower = isEnd ? Alignment.topRight : Alignment.topLeft;

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onDismiss,
          ),
        ),
        CompositedTransformFollower(
          link: widget.link,
          showWhenUnlinked: false,
          targetAnchor: anchor,
          followerAnchor: follower,
          offset: const Offset(0, 6),
          child: Align(
            alignment: follower,
            child: FadeTransition(
              opacity: _ctrl,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.96, end: 1).animate(
                  CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
                ),
                alignment: isEnd ? Alignment.topRight : Alignment.topLeft,
                child: Container(
                  constraints: BoxConstraints(
                    minWidth: widget.minWidth,
                    maxWidth: 280,
                  ),
                  decoration: BoxDecoration(
                    color: c.bg,
                    borderRadius: r.brLg,
                    border: Border.all(color: c.border, width: 1),
                    boxShadow: widget.theme.shadows.lg,
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Material(
                    type: MaterialType.transparency,
                    // Size the popover to its content (the widest row), not a
                    // fixed width — only minWidth bounds it.
                    child: IntrinsicWidth(
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            for (final it in widget.items)
                              if (it.separator)
                                Container(
                                  height: 1,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  color: c.border,
                                )
                              else
                                _MenuRow(
                                  item: it,
                                  radius: r.brMd,
                                  fg: it.destructive
                                      ? c.error
                                      : c.textHighlighted,
                                  hover: c.bgElevated,
                                  onTap: () => widget.onPick(it),
                                ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.item,
    required this.radius,
    required this.fg,
    required this.hover,
    required this.onTap,
  });

  final NixtMenuItem item;
  final BorderRadius radius;
  final Color fg;
  final Color hover;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: radius,
      hoverColor: hover,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (item.icon != null) ...[
              NixtIcon(item.icon!, size: 16, color: fg),
              const SizedBox(width: 10),
            ],
            Text(
              item.label ?? '',
              style: TextStyle(
                fontFamily: NixtTypography.fontSans,
                fontSize: NixtTypography.textSm,
                fontWeight: FontWeight.w500,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
