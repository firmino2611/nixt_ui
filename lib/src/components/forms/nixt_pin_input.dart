import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/nixt_theme.dart';
import '../../tokens/color_roles.dart';
import '../../tokens/typography_tokens.dart';
import 'control_common.dart';

/// An OTP / PIN entry — [length] single-character boxes with auto-advance and
/// backspace-to-previous. Controlled via [value] and [onChanged].
///
/// ```dart
/// NixtPinInput(
///   length: 6,
///   value: code,
///   onChanged: (v) => setState(() => code = v),
///   onCompleted: submit,
/// );
/// ```
class NixtPinInput extends StatefulWidget {
  /// Creates a pin input.
  const NixtPinInput({
    required this.value,
    this.onChanged,
    this.onCompleted,
    this.label,
    this.length = 4,
    this.obscure = false,
    this.color = NixtColorRole.primary,
    this.autofocus = false,
    this.keyboardType = TextInputType.number,
    this.enabled = true,
    super.key,
  });

  /// Current value (its characters fill the boxes left to right).
  final String value;

  /// Change callback.
  final ValueChanged<String>? onChanged;

  /// Called once when all boxes are filled.
  final ValueChanged<String>? onCompleted;

  /// Optional label rendered above the boxes.
  final String? label;

  /// Number of boxes.
  final int length;

  /// Mask the entered characters.
  final bool obscure;

  /// Accent color role (active box border). Defaults to `primary`.
  final NixtColorRole color;

  /// Autofocus the first box on mount.
  final bool autofocus;

  /// Keyboard type. Defaults to numeric.
  final TextInputType keyboardType;

  /// Whether the control is interactive.
  final bool enabled;

  @override
  State<NixtPinInput> createState() => _NixtPinInputState();
}

class _NixtPinInputState extends State<NixtPinInput> {
  late List<TextEditingController> _ctrls;
  late List<FocusNode> _nodes;

  @override
  void initState() {
    super.initState();
    _ctrls = List.generate(
        widget.length, (i) => TextEditingController(text: _charAt(i)));
    _nodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void didUpdateWidget(NixtPinInput old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      for (var i = 0; i < widget.length; i++) {
        final ch = _charAt(i);
        if (_ctrls[i].text != ch) _ctrls[i].text = ch;
      }
    }
  }

  String _charAt(int i) => i < widget.value.length ? widget.value[i] : '';

  @override
  void dispose() {
    for (final c in _ctrls) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _emit() {
    final s = _ctrls.map((c) => c.text).join();
    widget.onChanged?.call(s);
    if (s.length == widget.length && !s.contains('')) {
      widget.onCompleted?.call(s);
    }
  }

  void _onChanged(int i, String raw) {
    final cleaned = raw.replaceAll(RegExp(r'\s'), '');
    if (cleaned.isEmpty) {
      _ctrls[i].text = '';
      _emit();
      return;
    }
    final ch = cleaned.characters.last;
    _ctrls[i].value = TextEditingValue(
      text: ch,
      selection: const TextSelection.collapsed(offset: 1),
    );
    if (i < widget.length - 1) _nodes[i + 1].requestFocus();
    _emit();
    setState(() {});
  }

  void _onKey(int i, KeyEvent e) {
    if (e is KeyDownEvent &&
        e.logicalKey == LogicalKeyboardKey.backspace &&
        _ctrls[i].text.isEmpty &&
        i > 0) {
      _nodes[i - 1].requestFocus();
      _ctrls[i - 1].clear();
      _emit();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = NixtTheme.of(context);
    final c = t.colors;
    final accent = widget.color == NixtColorRole.neutral
        ? c.textHighlighted
        : c.role(widget.color);

    return NixtFieldLabel(
      colors: c,
      label: widget.label,
      child: Opacity(
        opacity: widget.enabled ? 1 : 0.5,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < widget.length; i++) ...[
              if (i > 0) const SizedBox(width: 10),
              SizedBox(
                width: 48,
                height: 56,
                child: Focus(
                  onKeyEvent: (_, e) {
                    _onKey(i, e);
                    return KeyEventResult.ignored;
                  },
                  child: TextField(
                    controller: _ctrls[i],
                    focusNode: _nodes[i],
                    enabled: widget.enabled,
                    autofocus: widget.autofocus && i == 0,
                    obscureText: widget.obscure,
                    keyboardType: widget.keyboardType,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    cursorColor: accent,
                    onChanged: (v) => _onChanged(i, v),
                    onTap: () => _ctrls[i].selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: _ctrls[i].text.length,
                    ),
                    style: TextStyle(
                      fontFamily: NixtTypography.fontMono,
                      fontSize: NixtTypography.text2xl,
                      fontWeight: NixtTypography.weightSemibold,
                      color: c.textHighlighted,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: c.bg,
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: t.radius.brLg,
                        borderSide: BorderSide(
                          color: _ctrls[i].text.isNotEmpty
                              ? accent
                              : c.borderAccented,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: t.radius.brLg,
                        borderSide: BorderSide(color: accent, width: 1.5),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: t.radius.brLg,
                        borderSide:
                            BorderSide(color: c.borderAccented, width: 1.5),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
