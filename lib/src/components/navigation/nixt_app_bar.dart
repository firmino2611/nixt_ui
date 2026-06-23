import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

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

  @override
  Widget build(BuildContext context) {
    final t = NixtTheme.of(context);
    final c = t.colors;
    final isIOS = variant == NixtAppBarVariant.ios;
    final height = isIOS ? 44.0 : 56.0;

    final Widget? lead = leading ??
        (onBack != null
            ? (isIOS
                ? _IOSBack(color: c.primary, onTap: onBack!)
                : NixtIconButton(
                    icon: NixtIcons.arrowLeft,
                    label: 'Back',
                    onPressed: onBack,
                  ))
            : null);

    final titleBlock = (!large && (title != null || subtitle != null))
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              if (title != null)
                Text(
                  title!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: isIOS ? TextAlign.center : TextAlign.start,
                  style: TextStyle(
                    fontFamily: NixtTypography.fontSans,
                    fontSize:
                        isIOS ? NixtTypography.textBase : NixtTypography.textLg,
                    fontWeight: FontWeight.w600,
                    color: c.textHighlighted,
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
                    color: c.textMuted,
                  ),
                ),
            ],
          )
        : null;

    // iOS centers the title with equal-flex side slots; Material left-aligns it.
    final Widget bar = SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 8),
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
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
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
                    color: c.textHighlighted,
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
                        color: c.textMuted,
                      ),
                    ),
                  ),
              ],
            ),
          )
        : null;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [bar, if (largeTitle != null) largeTitle],
    );

    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: nixtOpacity(c.bg, 0.88),
            border: border ? Border(bottom: BorderSide(color: c.border)) : null,
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
      children: [
        for (var i = 0; i < actions!.length; i++) ...[
          if (i != 0) const SizedBox(width: 2),
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
