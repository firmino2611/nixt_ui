import 'package:flutter/widgets.dart';

import '../../foundations/color_util.dart';
import '../../theme/nixt_colors.dart';
import '../../tokens/color_roles.dart';
import '../../tokens/radius_tokens.dart';
import '../../tokens/typography_tokens.dart';

/// Visual variant shared by the text-field family (Input, Textarea, Select) —
/// a direct port of the design system's `fieldShell` resolver.
enum NixtFieldVariant {
  /// Transparent fill with an accented border.
  outline,

  /// Elevated fill, borderless until focused.
  soft,

  /// Elevated fill with a hairline border.
  subtle,
}

/// Field size — `md` (44px) is the default and avoids iOS focus-zoom at 16px.
enum NixtFieldSize {
  /// 36px tall.
  sm,

  /// 44px tall (default).
  md,

  /// 52px tall.
  lg,
}

/// Resolved per-size metrics for the field family.
extension NixtFieldSizeMetrics on NixtFieldSize {
  /// Field height.
  double get height => switch (this) {
        NixtFieldSize.sm => 36,
        NixtFieldSize.md => 44,
        NixtFieldSize.lg => 52,
      };

  /// Text size.
  double get fontSize => switch (this) {
        NixtFieldSize.sm => NixtTypography.textSm,
        NixtFieldSize.md => NixtTypography.textBase,
        NixtFieldSize.lg => NixtTypography.textBase,
      };

  /// Horizontal padding.
  double get padX => switch (this) {
        NixtFieldSize.sm => 10,
        NixtFieldSize.md => 12,
        NixtFieldSize.lg => 14,
      };

  /// Leading/trailing icon size.
  double get iconSize => switch (this) {
        NixtFieldSize.sm => 16,
        NixtFieldSize.md => 18,
        NixtFieldSize.lg => 20,
      };

  /// Gap between icon and text.
  double get gap => switch (this) {
        NixtFieldSize.sm => 8,
        NixtFieldSize.md => 10,
        NixtFieldSize.lg => 10,
      };
}

/// Builds the shared field-shell decoration (background, border, focus ring).
abstract final class NixtFieldShell {
  /// The accent (focus-ring) color for a [role] against [colors].
  static Color accent(NixtColors colors, NixtColorRole role) =>
      role == NixtColorRole.neutral
          ? colors.textHighlighted
          : colors.role(role);

  /// Resolves the [BoxDecoration] for the field shell.
  ///
  /// [accentColor] is the focus-ring color (see [accent]); [errored] forces the
  /// error color; [focused] applies the accented border + 3px ring.
  static BoxDecoration resolve({
    required NixtColors colors,
    required NixtRadius radius,
    required NixtFieldVariant variant,
    required Color accentColor,
    bool focused = false,
    bool errored = false,
    BorderRadius? borderRadius,
  }) {
    final ring = errored ? colors.error : accentColor;

    Color background;
    Color borderColor;
    switch (variant) {
      case NixtFieldVariant.outline:
        background = colors.bg;
        borderColor = errored
            ? colors.error
            : focused
                ? ring
                : colors.borderAccented;
      case NixtFieldVariant.soft:
        // Solid, borderless — darker fill (one step up from elevated) so it
        // separates clearly from the page background.
        background = colors.bgAccented;
        borderColor = focused
            ? ring
            : errored
                ? colors.error
                : const Color(0x00000000);
      case NixtFieldVariant.subtle:
        // Lighter fill but always carries a visible border — this is what
        // distinguishes it from `soft` (whose fill is darker and borderless).
        background = colors.bgElevated;
        borderColor = errored
            ? colors.error
            : focused
                ? ring
                : colors.borderAccented;
    }

    return BoxDecoration(
      color: background,
      borderRadius: borderRadius ?? radius.brMd,
      border: Border.all(color: borderColor, width: 1),
      boxShadow: focused
          ? [BoxShadow(color: nixtOpacity(ring, 0.18), spreadRadius: 3)]
          : null,
    );
  }
}
