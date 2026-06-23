import 'package:flutter/widgets.dart';

import '../../foundations/press_scale.dart';
import '../../theme/nixt_theme.dart';
import '../../tokens/spacing_tokens.dart';
import '../../tokens/typography_tokens.dart';

/// Surface elevation for [NixtCard].
enum NixtCardVariant {
  /// Flat fill with a hairline border. No shadow.
  outline,

  /// Raised — muted border + medium shadow.
  elevated,

  /// Tinted (muted) fill, borderless.
  soft,
}

/// Inner padding for [NixtCard].
enum NixtCardPadding {
  /// No padding — for edge-to-edge media.
  none,

  /// 12px.
  sm,

  /// 16px (default).
  md,

  /// 24px.
  lg,
}

extension _CardPadValue on NixtCardPadding {
  double get value => switch (this) {
        NixtCardPadding.none => 0,
        NixtCardPadding.sm => NixtSpacing.s3,
        NixtCardPadding.md => NixtSpacing.s4,
        NixtCardPadding.lg => NixtSpacing.s6,
      };
}

/// Surface container with an optional header (title / subtitle or custom
/// [header] slot), body ([child]), and [footer]. [variant] controls elevation;
/// pass [onTap] to make the whole surface tappable (adds press feedback).
///
/// ```dart
/// NixtCard(title: 'Storage', subtitle: '78% used', child: ProgressBar());
/// NixtCard(variant: NixtCardVariant.elevated, onTap: open, child: Text('Tap me'));
/// ```
class NixtCard extends StatelessWidget {
  /// Creates a card.
  const NixtCard({
    this.title,
    this.subtitle,
    this.header,
    this.footer,
    this.child,
    this.variant = NixtCardVariant.outline,
    this.padding = NixtCardPadding.md,
    this.onTap,
    super.key,
  });

  /// Title text in the header. Ignored when [header] is given.
  final String? title;

  /// Subtitle text under the title. Ignored when [header] is given.
  final String? subtitle;

  /// Custom header content (overrides [title] / [subtitle]).
  final Widget? header;

  /// Footer content, rendered below the body.
  final Widget? footer;

  /// Body content.
  final Widget? child;

  /// Surface elevation. Defaults to `outline`.
  final NixtCardVariant variant;

  /// Inner padding. Defaults to `md`.
  final NixtCardPadding padding;

  /// Tap callback. When set, the surface gains press feedback.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = NixtTheme.of(context);
    final c = t.colors;
    final pad = padding.value;

    final (Color bg, Border? border, List<BoxShadow>? shadow) =
        switch (variant) {
      NixtCardVariant.outline => (
          c.bg,
          Border.all(color: c.border, width: 1),
          null
        ),
      NixtCardVariant.elevated => (
          c.bg,
          Border.all(color: c.borderMuted, width: 1),
          t.shadows.md
        ),
      NixtCardVariant.soft => (c.bgMuted, null, null),
    };

    final hasHeader = header != null || title != null || subtitle != null;
    final children = <Widget>[
      if (hasHeader)
        Padding(
          padding: EdgeInsets.fromLTRB(
            pad,
            pad,
            pad,
            child != null || footer != null ? 0 : pad,
          ),
          child: header ?? _DefaultHeader(title: title, subtitle: subtitle),
        ),
      if (child != null) Padding(padding: EdgeInsets.all(pad), child: child),
      if (footer != null)
        Padding(padding: EdgeInsets.fromLTRB(pad, 0, pad, pad), child: footer),
    ];

    final surface = DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(t.radius.xl),
        border: border,
        boxShadow: shadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(t.radius.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );

    if (onTap == null) return surface;
    return NixtPressScale(scale: 0.99, onTap: onTap, child: surface);
  }
}

class _DefaultHeader extends StatelessWidget {
  const _DefaultHeader({this.title, this.subtitle});
  final String? title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final c = NixtTheme.of(context).colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null)
          Text(
            title!,
            style: TextStyle(
              fontFamily: NixtTypography.fontSans,
              fontSize: NixtTypography.textBase,
              fontWeight: FontWeight.w600,
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
    );
  }
}
