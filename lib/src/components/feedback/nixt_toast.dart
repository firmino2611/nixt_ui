import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import '../../foundations/color_util.dart';
import '../../foundations/nixt_icons.dart';
import '../../theme/nixt_theme.dart';
import '../../tokens/color_roles.dart';
import '../../tokens/typography_tokens.dart';
import '../icon/nixt_icon.dart';

/// Visual style for [NixtToast].
enum NixtToastVariant {
  /// Inverted dark pill with an optional text action (Material snackbar).
  material,

  /// Frosted light capsule (iOS-style).
  ios,
}

/// Toast / snackbar — transient feedback. Presentational only: you control
/// when it mounts and any auto-dismiss timer (e.g. via an [OverlayEntry]).
///
/// `material` is an inverted dark pill that can carry a text [action]; `ios`
/// is a frosted blurred capsule. A trailing × (from [onClose]) shows only when
/// there is no [action].
///
/// ```dart
/// NixtToast(message: 'Link copied');
/// NixtToast(title: 'Saved', message: 'Draft stored', action: 'Undo', onAction: undo);
/// NixtToast(variant: NixtToastVariant.ios, icon: NixtIcons.checkCircle, message: 'Done');
/// ```
class NixtToast extends StatelessWidget {
  /// Creates a toast.
  const NixtToast({
    this.message,
    this.title,
    this.icon,
    this.color = NixtColorRole.neutral,
    this.variant = NixtToastVariant.material,
    this.action,
    this.onAction,
    this.onClose,
    super.key,
  });

  /// Body line.
  final String? message;

  /// Optional bold title above the message.
  final String? title;

  /// Optional leading icon.
  final IconData? icon;

  /// Accent for the icon/action. `neutral` uses the surface's own text color.
  final NixtColorRole color;

  /// Visual style. Defaults to `material`.
  final NixtToastVariant variant;

  /// Text action label (material). Hides the close button when set.
  final String? action;

  /// Action callback.
  final VoidCallback? onAction;

  /// Dismiss callback — renders a trailing × when there is no [action].
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    final t = NixtTheme.of(context);
    final c = t.colors;
    final isMat = variant == NixtToastVariant.material;
    final accent = color == NixtColorRole.neutral ? null : c.role(color);

    final fg = isMat ? c.textInverted : c.textHighlighted;
    final iconColor = accent ?? (isMat ? c.textInverted : c.text);
    final actionColor = accent ?? c.primary;

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          NixtIcon(icon!, size: 20, color: iconColor),
          const SizedBox(width: 12),
        ],
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (title != null)
                Text(
                  title!,
                  style: TextStyle(
                    fontFamily: NixtTypography.fontSans,
                    fontSize: NixtTypography.textSm,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                    color: fg,
                  ),
                ),
              if (message != null)
                Text(
                  message!,
                  style: TextStyle(
                    fontFamily: NixtTypography.fontSans,
                    fontSize: NixtTypography.textSm,
                    height: 1.35,
                    color: nixtOpacity(fg, 0.92),
                  ),
                ),
            ],
          ),
        ),
        if (action != null) ...[
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onAction,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Text(
                action!,
                style: TextStyle(
                  fontFamily: NixtTypography.fontSans,
                  fontSize: NixtTypography.textSm,
                  fontWeight: FontWeight.w700,
                  color: actionColor,
                ),
              ),
            ),
          ),
        ] else if (onClose != null) ...[
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onClose,
            behavior: HitTestBehavior.opaque,
            child: NixtIcon(NixtIcons.x, size: 16, color: nixtOpacity(fg, 0.7)),
          ),
        ],
      ],
    );

    const padding = EdgeInsets.fromLTRB(16, 12, 14, 12);
    final radius = BorderRadius.circular(t.radius.xl);

    final Widget surface = isMat
        ? Container(
            padding: padding,
            decoration: BoxDecoration(
              color: c.bgInverted,
              borderRadius: radius,
              boxShadow: t.shadows.lg,
            ),
            child: content,
          )
        : ClipRRect(
            // iOS frosted capsule.
            borderRadius: radius,
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: padding,
                decoration: BoxDecoration(
                  color: nixtOpacity(c.bg, 0.82),
                  borderRadius: radius,
                  border: Border.all(color: c.border, width: 1),
                  boxShadow: t.shadows.lg,
                ),
                child: content,
              ),
            ),
          );

    // The toast is commonly mounted in an [Overlay], which has no Material /
    // DefaultTextStyle ancestor — without this, text inherits Flutter's debug
    // yellow-underlined style. Provide a clean base so it renders anywhere.
    return DefaultTextStyle(
      style: TextStyle(
        fontFamily: NixtTypography.fontSans,
        color: fg,
        decoration: TextDecoration.none,
      ),
      child: surface,
    );
  }
}
