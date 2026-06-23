import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../foundations/color_util.dart';
import '../../theme/nixt_theme.dart';
import '../../tokens/typography_tokens.dart';
import '../icon/nixt_icon.dart';
import 'nixt_sheet.dart';

/// One choice in a [showNixtActionSheet].
@immutable
class NixtSheetAction {
  /// Creates an action.
  const NixtSheetAction({
    required this.label,
    this.icon,
    this.destructive = false,
    this.bold = false,
    this.onPressed,
  });

  /// Action label.
  final String label;

  /// Optional leading icon.
  final IconData? icon;

  /// Render red (delete / sign-out etc.).
  final bool destructive;

  /// iOS only — render bold (the recommended/default action).
  final bool bold;

  /// Tap callback (fired before the sheet dismisses).
  final VoidCallback? onPressed;
}

/// Visual style for [showNixtActionSheet].
enum NixtActionSheetVariant {
  /// Grouped translucent card + a separate Cancel button (Cupertino).
  ios,

  /// A single sheet with a left-aligned icon list (Material).
  material,
}

/// Shows a contextual action sheet anchored to the bottom. Returns the index
/// of the chosen action, or null if dismissed.
Future<int?> showNixtActionSheet({
  required BuildContext context,
  required List<NixtSheetAction> actions,
  String? title,
  String? message,
  String cancelLabel = 'Cancel',
  NixtActionSheetVariant variant = NixtActionSheetVariant.ios,
}) {
  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    backgroundColor: const Color(0x00000000),
    barrierColor: kNixtScrim,
    elevation: 0,
    builder: (ctx) => variant == NixtActionSheetVariant.ios
        ? _IOSActionSheet(
            title: title,
            message: message,
            actions: actions,
            cancelLabel: cancelLabel,
          )
        : _MaterialActionSheet(
            title: title,
            message: message,
            actions: actions,
          ),
  );
}

void _pick(BuildContext ctx, List<NixtSheetAction> actions, int i) {
  actions[i].onPressed?.call();
  Navigator.of(ctx).pop(i);
}

class _IOSActionSheet extends StatelessWidget {
  const _IOSActionSheet({
    required this.actions,
    required this.cancelLabel,
    this.title,
    this.message,
  });

  final List<NixtSheetAction> actions;
  final String cancelLabel;
  final String? title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final c = NixtTheme.of(context).colors;
    final safeBottom = MediaQuery.of(context).viewPadding.bottom;
    final radius = BorderRadius.circular(16);

    Widget blurred(Widget child) => ClipRRect(
          borderRadius: radius,
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: child,
          ),
        );

    return Padding(
      padding: EdgeInsets.fromLTRB(8, 8, 8, 8 + safeBottom * 0.3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          blurred(
            ColoredBox(
              color: nixtOpacity(c.bg, 0.80),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null || message != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: c.border)),
                      ),
                      child: Column(
                        children: [
                          if (title != null)
                            Text(
                              title!,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: NixtTypography.fontSans,
                                fontSize: NixtTypography.textXs,
                                fontWeight: FontWeight.w600,
                                color: c.textMuted,
                              ),
                            ),
                          if (message != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                message!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: NixtTypography.fontSans,
                                  fontSize: NixtTypography.textXs,
                                  color: c.textDimmed,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  for (var i = 0; i < actions.length; i++)
                    _IOSRow(
                      action: actions[i],
                      topBorder: i != 0 || title != null || message != null,
                      accent: c.primary,
                      error: c.error,
                      border: c.border,
                      onTap: () => _pick(context, actions, i),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          blurred(
            Material(
              color: nixtOpacity(c.bg, 0.92),
              child: InkWell(
                onTap: () => Navigator.of(context).maybePop(),
                child: SizedBox(
                  height: 56,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      cancelLabel,
                      style: TextStyle(
                        fontFamily: NixtTypography.fontSans,
                        fontSize: NixtTypography.textLg,
                        fontWeight: FontWeight.w700,
                        color: c.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IOSRow extends StatelessWidget {
  const _IOSRow({
    required this.action,
    required this.topBorder,
    required this.accent,
    required this.error,
    required this.border,
    required this.onTap,
  });

  final NixtSheetAction action;
  final bool topBorder;
  final Color accent;
  final Color error;
  final Color border;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = action.destructive ? error : accent;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: topBorder ? Border(top: BorderSide(color: border)) : null,
      ),
      child: Material(
        color: const Color(0x00000000),
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (action.icon != null) ...[
                  NixtIcon(action.icon!, size: 20, color: fg),
                  const SizedBox(width: 8),
                ],
                Text(
                  action.label,
                  style: TextStyle(
                    fontFamily: NixtTypography.fontSans,
                    fontSize: NixtTypography.textLg,
                    fontWeight: action.bold ? FontWeight.w700 : FontWeight.w400,
                    color: fg,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MaterialActionSheet extends StatelessWidget {
  const _MaterialActionSheet({required this.actions, this.title, this.message});

  final List<NixtSheetAction> actions;
  final String? title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final t = NixtTheme.of(context);
    final c = t.colors;
    final safeBottom = MediaQuery.of(context).viewPadding.bottom;
    final radius = Radius.circular(t.radius.xxl);

    return Container(
      decoration: BoxDecoration(
        color: c.bg,
        borderRadius: BorderRadius.only(topLeft: radius, topRight: radius),
        boxShadow: t.shadows.sheet,
      ),
      clipBehavior: Clip.antiAlias,
      padding: EdgeInsets.only(bottom: 8 + safeBottom * 0.3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 5,
              margin: const EdgeInsets.only(top: 8, bottom: 6),
              decoration: BoxDecoration(
                color: c.bgAccented,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Text(
                title!,
                style: TextStyle(
                  fontFamily: NixtTypography.fontSans,
                  fontSize: NixtTypography.textBase,
                  fontWeight: FontWeight.w600,
                  color: c.textHighlighted,
                ),
              ),
            ),
          if (message != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text(
                message!,
                style: TextStyle(
                  fontFamily: NixtTypography.fontSans,
                  fontSize: NixtTypography.textSm,
                  color: c.textMuted,
                ),
              ),
            ),
          const SizedBox(height: 4),
          for (var i = 0; i < actions.length; i++)
            Material(
              color: const Color(0x00000000),
              child: InkWell(
                onTap: () => _pick(context, actions, i),
                child: Container(
                  constraints: const BoxConstraints(minHeight: 52),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Row(
                    children: [
                      if (actions[i].icon != null) ...[
                        NixtIcon(
                          actions[i].icon!,
                          size: 20,
                          color: actions[i].destructive
                              ? c.error
                              : c.textHighlighted,
                        ),
                        const SizedBox(width: 14),
                      ],
                      Expanded(
                        child: Text(
                          actions[i].label,
                          style: TextStyle(
                            fontFamily: NixtTypography.fontSans,
                            fontSize: NixtTypography.textBase,
                            fontWeight: FontWeight.w500,
                            color: actions[i].destructive
                                ? c.error
                                : c.textHighlighted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
