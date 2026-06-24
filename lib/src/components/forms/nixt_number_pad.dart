import 'package:flutter/widgets.dart';

import '../../foundations/nixt_icons.dart';
import '../../theme/nixt_theme.dart';
import '../../tokens/typography_tokens.dart';
import '../icon/nixt_icon.dart';

/// A 3-column numeric keypad for PINs, passcodes, and amount entry.
///
/// Purely visual: it emits key presses through [onPress] (digits and the
/// optional decimal point) and [onBackspace]. It holds no value of its own —
/// wire it to your own field state.
///
/// ```dart
/// NixtNumberPad(
///   decimal: true,
///   onPress: (k) => setState(() => amount += k),
///   onBackspace: () => setState(() => amount = amount.dropLast()),
/// );
/// ```
class NixtNumberPad extends StatelessWidget {
  /// Creates a number pad.
  const NixtNumberPad({
    this.onPress,
    this.onBackspace,
    this.decimal = false,
    super.key,
  });

  /// Fired with the pressed digit (or `.`).
  final ValueChanged<String>? onPress;

  /// Fired when the backspace key is pressed.
  final VoidCallback? onBackspace;

  /// Whether to show a decimal-point key in the bottom-left slot. Defaults to
  /// `false` (an empty slot).
  final bool decimal;

  @override
  Widget build(BuildContext context) {
    final keys = <String>[
      '1', '2', '3', //
      '4', '5', '6', //
      '7', '8', '9', //
      decimal ? '.' : '', '0', 'back', //
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        const gap = 8.0;
        final cellWidth = (constraints.maxWidth - gap * 2) / 3;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final k in keys)
              SizedBox(
                width: cellWidth,
                height: 60,
                child: k.isEmpty
                    ? const SizedBox()
                    : _Key(
                        label: k,
                        onTap: k == 'back'
                            ? onBackspace
                            : (onPress == null ? null : () => onPress!(k)),
                      ),
              ),
          ],
        );
      },
    );
  }
}

class _Key extends StatefulWidget {
  const _Key({required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  State<_Key> createState() => _KeyState();
}

class _KeyState extends State<_Key> {
  bool _down = false;

  void _set(bool v) {
    if (widget.onTap == null) return;
    setState(() => _down = v);
  }

  @override
  Widget build(BuildContext context) {
    final t = NixtTheme.of(context);
    final c = t.colors;
    final isBack = widget.label == 'back';

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _set(true),
      onTapUp: (_) => _set(false),
      onTapCancel: () => _set(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _down ? 0.96 : 1,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _down ? c.bgElevated : null,
            borderRadius: t.radius.brXl,
          ),
          child: isBack
              ? NixtIcon(NixtIcons.byName('delete'),
                  size: 24, color: c.textHighlighted)
              : Text(
                  widget.label,
                  style: TextStyle(
                    fontFamily: NixtTypography.fontMono,
                    fontSize: NixtTypography.text2xl,
                    fontWeight: NixtTypography.weightSemibold,
                    color: c.textHighlighted,
                  ),
                ),
        ),
      ),
    );
  }
}
