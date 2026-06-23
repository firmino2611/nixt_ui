import 'package:flutter/material.dart';

import '../../foundations/nixt_icons.dart';
import '../../theme/nixt_theme.dart';
import '../../tokens/color_roles.dart';
import '../../tokens/typography_tokens.dart';
import '../icon/nixt_icon.dart';
import 'field_shell.dart';

/// A search field tuned for mobile. By default it looks exactly like
/// [NixtInput] (same shell, [NixtFieldVariant.outline], focus ring) with a
/// leading search icon and an inline clear (×) button.
///
/// Customize the edges with [variant] (outline / soft / subtle) or override
/// [borderRadius] (e.g. a full pill). Set [showCancel] for the iOS pattern
/// where a "Cancel" button slides in while the field is focused or filled.
///
/// ```dart
/// NixtSearchBar(controller: ctrl, onChanged: (_) {});                  // = Input
/// NixtSearchBar(controller: ctrl, borderRadius: BorderRadius.circular(999)); // pill
/// NixtSearchBar(controller: ctrl, variant: NixtFieldVariant.soft, showCancel: true);
/// ```
class NixtSearchBar extends StatefulWidget {
  /// Creates a search bar.
  const NixtSearchBar({
    this.controller,
    this.onChanged,
    this.onClear,
    this.onCancel,
    this.hintText = 'Search',
    this.size = NixtFieldSize.md,
    this.variant = NixtFieldVariant.outline,
    this.color = NixtColorRole.primary,
    this.borderRadius,
    this.showCancel = false,
    this.autofocus = false,
    this.enabled = true,
    super.key,
  });

  /// Optional external controller (needed for the clear button to work).
  final TextEditingController? controller;

  /// Change callback.
  final ValueChanged<String>? onChanged;

  /// Called when the inline clear (×) button is tapped.
  final VoidCallback? onClear;

  /// Called when the iOS "Cancel" button is tapped.
  final VoidCallback? onCancel;

  /// Placeholder text.
  final String hintText;

  /// Field size — matches [NixtInput]. Defaults to `md`.
  final NixtFieldSize size;

  /// Visual variant — matches [NixtInput]. Defaults to `outline`.
  final NixtFieldVariant variant;

  /// Focus-ring color role. Defaults to `primary`.
  final NixtColorRole color;

  /// Override the corner radius (e.g. a full pill). Null uses the field
  /// default (same rounding as [NixtInput]).
  final BorderRadius? borderRadius;

  /// Show the iOS-style "Cancel" button while focused or filled.
  final bool showCancel;

  /// Autofocus on mount.
  final bool autofocus;

  /// Whether the field accepts input.
  final bool enabled;

  @override
  State<NixtSearchBar> createState() => _NixtSearchBarState();
}

class _NixtSearchBarState extends State<NixtSearchBar> {
  late final TextEditingController _ctrl =
      widget.controller ?? TextEditingController();
  final FocusNode _node = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _node.addListener(() {
      if (_focused != _node.hasFocus) setState(() => _focused = _node.hasFocus);
    });
    _ctrl.addListener(_onText);
  }

  void _onText() => setState(() {});

  @override
  void dispose() {
    _ctrl.removeListener(_onText);
    if (widget.controller == null) _ctrl.dispose();
    _node.dispose();
    super.dispose();
  }

  void _clear() {
    _ctrl.clear();
    widget.onClear?.call();
    widget.onChanged?.call('');
  }

  void _cancel() {
    _ctrl.clear();
    _node.unfocus();
    widget.onCancel?.call();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    final t = NixtTheme.of(context);
    final c = t.colors;
    final accent = NixtFieldShell.accent(c, widget.color);
    final hasText = _ctrl.text.isNotEmpty;
    final showCancel = widget.showCancel && (_focused || hasText);

    final field = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      height: widget.size.height,
      padding: EdgeInsets.symmetric(horizontal: widget.size.padX),
      decoration: NixtFieldShell.resolve(
        colors: c,
        radius: t.radius,
        variant: widget.variant,
        accentColor: accent,
        focused: _focused,
        borderRadius: widget.borderRadius,
      ),
      child: Row(
        children: [
          NixtIcon(NixtIcons.search,
              size: widget.size.iconSize, color: c.textDimmed),
          SizedBox(width: widget.size.gap),
          Expanded(
            child: TextField(
              controller: _ctrl,
              focusNode: _node,
              enabled: widget.enabled,
              autofocus: widget.autofocus,
              onChanged: widget.onChanged,
              textInputAction: TextInputAction.search,
              cursorColor: accent,
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(
                fontFamily: NixtTypography.fontSans,
                fontSize: widget.size.fontSize,
                color: c.textHighlighted,
              ),
              decoration: InputDecoration.collapsed(
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  fontFamily: NixtTypography.fontSans,
                  fontSize: widget.size.fontSize,
                  color: c.textDimmed,
                ),
              ).copyWith(isCollapsed: true),
            ),
          ),
          if (hasText) ...[
            SizedBox(width: widget.size.gap),
            GestureDetector(
              onTap: _clear,
              child: Container(
                width: 18,
                height: 18,
                alignment: Alignment.center,
                decoration:
                    BoxDecoration(color: c.bgAccented, shape: BoxShape.circle),
                child: NixtIcon(NixtIcons.x, size: 12, color: c.textMuted),
              ),
            ),
          ],
        ],
      ),
    );

    return Opacity(
      opacity: widget.enabled ? 1 : 0.5,
      child: Row(
        children: [
          Expanded(child: field),
          if (showCancel)
            GestureDetector(
              onTap: _cancel,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontFamily: NixtTypography.fontSans,
                    fontSize: NixtTypography.textBase,
                    color: accent,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
