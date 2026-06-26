import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../foundations/color_util.dart';
import '../../foundations/nixt_icons.dart';
import '../../theme/nixt_theme.dart';
import '../../tokens/typography_tokens.dart';
import '../buttons/nixt_icon_button.dart';
import '../icon/nixt_icon.dart';

/// Visual style for [NixtAppBar].
enum NixtAppBarVariant {
  /// Centered title, compact 44px, hairline border (Cupertino).
  ios,

  /// Left-aligned title, 56px (Material).
  material,
}

/// Top app bar / navigation header. `ios` centers the title in a compact bar
/// with a "‹ Back" text button; `material` left-aligns it with an arrow icon
/// button. Set [large] for a big left-aligned title below the bar (iOS large
/// title). Frosted translucent surface with an optional bottom [border].
///
/// Provide [onBack] for a back button or a custom [leading] node, and
/// [actions] for trailing controls.
///
/// ```dart
/// NixtAppBar(title: 'Settings', onBack: () => Navigator.pop(context));
/// NixtAppBar(title: 'Inbox', variant: NixtAppBarVariant.material, actions: [...]);
/// NixtAppBar(title: 'Library', large: true);
/// ```
class NixtAppBar extends StatelessWidget {
  /// Creates an app bar.
  const NixtAppBar({
    this.title,
    this.subtitle,
    this.variant = NixtAppBarVariant.ios,
    this.onBack,
    this.leading,
    this.actions,
    this.large = false,
    this.border = true,
    this.backgroundColor,
    super.key,
  });

  /// Title text.
  final String? title;

  /// Subtitle under the title (compact bar only).
  final String? subtitle;

  /// Visual style. Defaults to `ios`.
  final NixtAppBarVariant variant;

  /// Back callback — renders the default back control when [leading] is null.
  final VoidCallback? onBack;

  /// Custom leading node (overrides the default back control).
  final Widget? leading;

  /// Trailing action widgets.
  final List<Widget>? actions;

  /// Render a large left-aligned title below the bar. Defaults to false.
  final bool large;

  /// Show the hairline bottom border. Defaults to true.
  final bool border;

  /// Surface color. Defaults to a frosted translucent [NixtColors.bg]. Pass an
  /// opaque color for a solid bar, or a semi-transparent one to keep the blur.
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final t = NixtTheme.of(context);
    final c = t.colors;
    final isIOS = variant == NixtAppBarVariant.ios;
    final height = isIOS ? 54.0 : 66.0;

    // When a custom [backgroundColor] is set, derive a contrast-safe foreground
    // so text and icons stay legible on any fill.
    final Color? fg = backgroundColor != null ? nixtOnColor(backgroundColor!) : null;
    final titleColor = fg ?? c.textHighlighted;
    final subtitleColor = fg != null ? nixtOpacity(fg, 0.72) : c.textMuted;
    final backColor = fg ?? c.primary;
    final borderColor = fg != null ? nixtOpacity(fg, 0.2) : c.border;

    final Widget? lead = leading ??
        (onBack != null
            ? (isIOS
                ? _IOSBack(color: backColor, onTap: onBack!)
                : NixtIconButton(
                    icon: NixtIcons.arrowLeft,
                    label: 'Back',
                    onPressed: onBack,
                  ))
            : null);

    final titleBlock = (!large && (title != null || subtitle != null))
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              if (title != null)
                Text(
                  title!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: isIOS ? TextAlign.center : TextAlign.start,
                  style: TextStyle(
                    fontFamily: NixtTypography.fontSans,
                    fontSize: isIOS ? NixtTypography.textBase : NixtTypography.textLg,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: NixtTypography.fontSans,
                    fontSize: NixtTypography.textXs,
                    color: subtitleColor,
                  ),
                ),
            ],
          )
        : null;

    // iOS centers the title with equal-flex side slots; Material left-aligns it.
    final Widget bar = SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 8, top: 10, bottom: 10),
        child: isIOS
            ? Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: lead ?? const SizedBox.shrink(),
                    ),
                  ),
                  if (titleBlock != null) titleBlock,
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: _Actions(actions),
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  if (lead != null) ...[lead, const SizedBox(width: 4)],
                  Expanded(child: titleBlock ?? const SizedBox.shrink()),
                  _Actions(actions),
                ],
              ),
      ),
    );

    final largeTitle = (large && title != null)
        ? Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title!,
                  style: TextStyle(
                    fontFamily: NixtTypography.fontSans,
                    fontSize: NixtTypography.text3xl,
                    fontWeight: FontWeight.w700,
                    letterSpacing: NixtTypography.letterSpacing(
                      NixtTypography.trackingTight,
                      NixtTypography.text3xl,
                    ),
                    color: titleColor,
                  ),
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      subtitle!,
                      style: TextStyle(
                        fontFamily: NixtTypography.fontSans,
                        fontSize: NixtTypography.textSm,
                        color: subtitleColor,
                      ),
                    ),
                  ),
              ],
            ),
          )
        : null;

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [bar, if (largeTitle != null) largeTitle],
    );

    // Recolor icon/text descendants (actions, default back) to the contrast
    // foreground by overriding the theme's text roles for this subtree only.
    if (fg != null) {
      final overridden = t.copyWith(
        colors: c.copyWith(
          text: fg,
          textHighlighted: fg,
          textToned: fg,
          textMuted: subtitleColor,
          textDimmed: nixtOpacity(fg, 0.6),
        ),
      );
      content = Theme(
        data: Theme.of(context).copyWith(extensions: [overridden]),
        child: IconTheme.merge(data: IconThemeData(color: fg), child: content),
      );
    }

    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: backgroundColor ?? nixtOpacity(c.bg, 0.88),
            border: border ? Border(bottom: BorderSide(color: borderColor)) : null,
          ),
          child: content,
        ),
      ),
    );
  }
}

class _Actions extends StatelessWidget {
  const _Actions(this.actions);
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    if (actions == null || actions!.isEmpty) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 2,
      children: [
        for (var i = 0; i < actions!.length; i++) ...[
          // if (i != 0) const SizedBox(width: 2),
          actions![i],
        ],
      ],
    );
  }
}

class _IOSBack extends StatelessWidget {
  const _IOSBack({required this.color, required this.onTap});
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          NixtIcon(NixtIcons.chevronLeft, size: 26, color: color),
          Transform.translate(
            offset: const Offset(-2, 0),
            child: Text(
              'Back',
              style: TextStyle(
                fontFamily: NixtTypography.fontSans,
                fontSize: NixtTypography.textBase,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
