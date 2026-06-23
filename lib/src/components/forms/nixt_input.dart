import 'package:flutter/material.dart';

import '../../theme/nixt_theme.dart';
import '../../tokens/color_roles.dart';
import '../../tokens/typography_tokens.dart';
import '../icon/nixt_icon.dart';
import 'field_shell.dart';

/// A single-line text field, styled to the design system. Built on a native
/// [EditableText] (via [TextField]) for full IME, selection, and a11y support.
///
/// Optionally renders an [errorText] message below the field; any non-null
/// [errorText] also paints the border in the error color.
///
/// ```dart
/// NixtInput(
///   hintText: 'you@example.com',
///   icon: NixtIcons.mail,
///   keyboardType: TextInputType.emailAddress,
///   onChanged: (v) {},
/// );
/// ```
class NixtInput extends StatefulWidget {
  /// Creates a text field.
  const NixtInput({
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.size = NixtFieldSize.md,
    this.variant = NixtFieldVariant.outline,
    this.color = NixtColorRole.primary,
    this.icon,
    this.trailingIcon,
    this.errorText,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
    super.key,
  });

  /// Optional external controller.
  final TextEditingController? controller;

  /// Change callback.
  final ValueChanged<String>? onChanged;

  /// Submit (keyboard action) callback.
  final ValueChanged<String>? onSubmitted;

  /// Placeholder text.
  final String? hintText;

  /// Hide input (passwords).
  final bool obscureText;

  /// Keyboard type.
  final TextInputType? keyboardType;

  /// Keyboard action button.
  final TextInputAction? textInputAction;

  /// Field size. Defaults to `md`.
  final NixtFieldSize size;

  /// Visual variant. Defaults to `outline`.
  final NixtFieldVariant variant;

  /// Focus-ring color role. Defaults to `primary`.
  final NixtColorRole color;

  /// Leading icon.
  final IconData? icon;

  /// Trailing icon.
  final IconData? trailingIcon;

  /// Error message — non-null paints the border red and renders below.
  final String? errorText;

  /// Whether the field accepts input.
  final bool enabled;

  /// Optional external focus node.
  final FocusNode? focusNode;

  /// Autofocus on mount.
  final bool autofocus;

  @override
  State<NixtInput> createState() => _NixtInputState();
}

class _NixtInputState extends State<NixtInput> {
  FocusNode? _internalNode;
  FocusNode get _node => widget.focusNode ?? (_internalNode ??= FocusNode());
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _node.addListener(_onFocus);
  }

  @override
  void dispose() {
    _node.removeListener(_onFocus);
    _internalNode?.dispose();
    super.dispose();
  }

  void _onFocus() {
    if (_focused != _node.hasFocus) setState(() => _focused = _node.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    final t = NixtTheme.of(context);
    final c = t.colors;
    final errored = widget.errorText != null;
    final accent = NixtFieldShell.accent(c, widget.color);

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
        errored: errored,
      ),
      child: Row(
        children: [
          if (widget.icon != null) ...[
            NixtIcon(widget.icon!,
                size: widget.size.iconSize, color: c.textDimmed),
            SizedBox(width: widget.size.gap),
          ],
          Expanded(
            child: TextField(
              controller: widget.controller,
              focusNode: _node,
              enabled: widget.enabled,
              autofocus: widget.autofocus,
              obscureText: widget.obscureText,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              onChanged: widget.onChanged,
              onSubmitted: widget.onSubmitted,
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
          if (widget.trailingIcon != null) ...[
            SizedBox(width: widget.size.gap),
            NixtIcon(widget.trailingIcon!,
                size: widget.size.iconSize, color: c.textDimmed),
          ],
        ],
      ),
    );

    final shell = Opacity(opacity: widget.enabled ? 1 : 0.5, child: field);

    if (!errored) return shell;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        shell,
        Padding(
          padding: const EdgeInsets.only(top: 6, left: 2),
          child: Text(
            widget.errorText!,
            style: TextStyle(
              fontFamily: NixtTypography.fontSans,
              fontSize: NixtTypography.textXs,
              color: c.error,
            ),
          ),
        ),
      ],
    );
  }
}
