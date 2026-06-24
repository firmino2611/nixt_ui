import 'package:flutter/widgets.dart';

import '../../foundations/nixt_icons.dart';
import '../../theme/nixt_theme.dart';
import '../../tokens/color_roles.dart';
import '../../tokens/palette.dart';
import '../../tokens/typography_tokens.dart';
import '../icon/nixt_icon.dart';

/// A horizontal step indicator for multi-step flows (checkout, onboarding, KYC).
///
/// Steps before [current] show a check, the [current] step is highlighted, and
/// later steps are dimmed with a numbered ring.
///
/// ```dart
/// NixtSteps(steps: ['Cart', 'Address', 'Payment'], current: 1);
/// ```
class NixtSteps extends StatelessWidget {
  /// Creates a step indicator.
  const NixtSteps({
    required this.steps,
    this.current = 0,
    this.color = NixtColorRole.primary,
    super.key,
  });

  /// The step labels, left to right.
  final List<String> steps;

  /// The active step index (0-based). Steps before it render as completed.
  /// Defaults to 0.
  final int current;

  /// Accent color role. Defaults to `primary`.
  final NixtColorRole color;

  @override
  Widget build(BuildContext context) {
    final c = NixtTheme.of(context).colors;
    final accent =
        color == NixtColorRole.neutral ? c.textHighlighted : c.role(color);
    final last = steps.length - 1;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < steps.length; i++)
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 2,
                        color: i == 0
                            ? const Color(0x00000000)
                            : (i <= current ? accent : c.borderAccented),
                      ),
                    ),
                    _Marker(
                      index: i,
                      current: current,
                      accent: accent,
                      bg: c.bg,
                      border: c.borderAccented,
                      mutedText: c.textMuted,
                    ),
                    Expanded(
                      child: Container(
                        height: 2,
                        color: i == last
                            ? const Color(0x00000000)
                            : (i < current ? accent : c.borderAccented),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Text(
                  steps[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: NixtTypography.fontSans,
                    fontSize: NixtTypography.textXs,
                    fontWeight: i == current
                        ? NixtTypography.weightSemibold
                        : NixtTypography.weightMedium,
                    color: i <= current ? c.textHighlighted : c.textMuted,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Marker extends StatelessWidget {
  const _Marker({
    required this.index,
    required this.current,
    required this.accent,
    required this.bg,
    required this.border,
    required this.mutedText,
  });

  final int index;
  final int current;
  final Color accent;
  final Color bg;
  final Color border;
  final Color mutedText;

  @override
  Widget build(BuildContext context) {
    final done = index < current;
    final on = index <= current;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: on ? accent : bg,
        border: on ? null : Border.all(color: border, width: 1.5),
      ),
      child: done
          ? const NixtIcon(NixtIcons.check, size: 15, color: NixtPalette.white)
          : Text(
              '${index + 1}',
              style: TextStyle(
                fontFamily: NixtTypography.fontMono,
                fontSize: NixtTypography.textXs,
                fontWeight: NixtTypography.weightBold,
                color: on ? NixtPalette.white : mutedText,
              ),
            ),
    );
  }
}
