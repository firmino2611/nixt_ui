import 'package:flutter/material.dart';

import '../../foundations/color_util.dart';
import '../../theme/nixt_theme.dart';
import '../../tokens/color_roles.dart';
import '../../tokens/typography_tokens.dart';
import '../icon/nixt_icon.dart';
import 'nixt_sheet.dart';

/// Centered modal dialog surface — confirmations, alerts, short prompts. An
/// optional tinted [icon] circle, a [title], a [description], optional [child],
/// and a stacked column of [actions].
///
/// Usually shown via [showNixtDialog].
class NixtDialog extends StatelessWidget {
  /// Creates a dialog surface.
  const NixtDialog({
    this.title,
    this.description,
    this.icon,
    this.color = NixtColorRole.primary,
    this.actions,
    this.child,
    super.key,
  });

  /// Headline.
  final String? title;

  /// Supporting text.
  final String? description;

  /// Optional icon in a tinted circle above the title.
  final IconData? icon;

  /// Icon-circle color role. Defaults to `primary`.
  final NixtColorRole color;

  /// Action buttons (stacked vertically).
  final List<Widget>? actions;

  /// Extra content below the description.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final t = NixtTheme.of(context);
    final c = t.colors;
    final accent =
        color == NixtColorRole.neutral ? c.textHighlighted : c.role(color);

    // Self-contained Material — showGeneralDialog provides no Material/
    // DefaultTextStyle ancestor, so without this the text would inherit
    // Flutter's debug yellow-underline style.
    return Material(
      type: MaterialType.transparency,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 340),
        child: Container(
          decoration: BoxDecoration(
            color: c.bg,
            borderRadius: BorderRadius.circular(t.radius.xxl),
            boxShadow: t.shadows.xl,
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (icon != null)
                Container(
                  width: 52,
                  height: 52,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: nixtOpacity(accent, 0.14),
                    shape: BoxShape.circle,
                  ),
                  child: NixtIcon(icon!, size: 26, color: accent),
                ),
              if (title != null)
                Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: NixtTypography.fontSans,
                    fontSize: NixtTypography.textLg,
                    fontWeight: FontWeight.w700,
                    color: c.textHighlighted,
                  ),
                ),
              if (description != null)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    description!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: NixtTypography.fontSans,
                      fontSize: NixtTypography.textSm,
                      height: 1.5,
                      color: c.textMuted,
                    ),
                  ),
                ),
              if (child != null) child!,
              if (actions != null && actions!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < actions!.length; i++)
                        Padding(
                          padding: EdgeInsets.only(top: i == 0 ? 0 : 8),
                          child: actions![i],
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shows a [NixtDialog] centered over a scrim with a scale + fade entrance.
/// Returns whatever the dialog is popped with.
Future<T?> showNixtDialog<T>({
  required BuildContext context,
  String? title,
  String? description,
  IconData? icon,
  NixtColorRole color = NixtColorRole.primary,
  List<Widget>? actions,
  Widget? child,
  bool barrierDismissible = true,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: 'Dismiss',
    barrierColor: kNixtScrim,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (ctx, _, __) => Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: NixtDialog(
          title: title,
          description: description,
          icon: icon,
          color: color,
          actions: actions,
          child: child,
        ),
      ),
    ),
    transitionBuilder: (_, anim, __, dialogChild) {
      final curved = CurvedAnimation(
        parent: anim,
        curve: const Cubic(0.34, 1.56, 0.64, 1),
        reverseCurve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: anim,
        child: ScaleTransition(
          scale: Tween(begin: 0.92, end: 1.0).animate(curved),
          child: dialogChild,
        ),
      );
    },
  );
}
