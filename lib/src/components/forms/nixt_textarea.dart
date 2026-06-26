import 'package:flutter/material.dart';

import '../../theme/nixt_theme.dart';
import '../../tokens/color_roles.dart';
import '../../tokens/typography_tokens.dart';
import 'control_common.dart';
import 'field_shell.dart';

/// A multi-line text field, sharing the field shell with [NixtInput].
///
/// ```dart
/// NixtTextarea(hintText: 'Write a note…', rows: 4, onChanged: (v) {});
/// ```
class NixtTextarea extends StatefulWidget {
  /// Creates a textarea.
  const NixtTextarea({
    this.controller,
    this.onChanged,
    this.label,
    this.hintText,
    this.rows = 4,
    this.variant = NixtFieldVariant.outline,
    this.color = NixtColorRole.primary,
    this.errorText,
    this.enabled = true,
    this.focusNode,
    super.key,
  });

  /// Optional external controller.
  final TextEditingController? controller;

  /// Change callback.
  final ValueChanged<String>? onChanged;

  /// Optional label rendered above the field.
  final String? label;

  /// Placeholder text.
  final String? hintText;

  /// Visible line count (min height). Defaults to 4.
  final int rows;

  /// Visual variant. Defaults to `outline`.
  final NixtFieldVariant variant;

  /// Focus-ring color role. Defaults to `primary`.
  final NixtColorRole color;

  /// Error message — non-null paints the border red.
  final String? errorText;

  /// Whether the field accepts input.
  final bool enabled;

  /// Optional external focus node.
  final FocusNode? focusNode;

  @override
  State<NixtTextarea> createState() => _NixtTextareaState();
}

class _NixtTextareaState extends State<NixtTextarea> {
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

    return NixtFieldLabel(
      colors: c,
      label: widget.label,
      errored: errored,
      child: Opacity(
        opacity: widget.enabled ? 1 : 0.5,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: NixtFieldShell.resolve(
            colors: c,
            radius: t.radius,
            variant: widget.variant,
            accentColor: accent,
            focused: _focused,
            errored: errored,
          ),
          child: TextField(
            controller: widget.controller,
            focusNode: _node,
            enabled: widget.enabled,
            onChanged: widget.onChanged,
            minLines: widget.rows,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            cursorColor: accent,
            style: TextStyle(
              fontFamily: NixtTypography.fontSans,
              fontSize: NixtTypography.textBase,
              height: NixtTypography.leadingNormal,
              color: c.textHighlighted,
            ),
            decoration: InputDecoration.collapsed(
              hintText: widget.hintText,
              hintStyle: TextStyle(
                fontFamily: NixtTypography.fontSans,
                fontSize: NixtTypography.textBase,
                color: c.textDimmed,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
