import 'package:flutter/material.dart';

import '../../foundations/color_util.dart';
import '../../foundations/nixt_icons.dart';
import '../../theme/nixt_colors.dart';
import '../../theme/nixt_theme.dart';
import '../../tokens/color_roles.dart';
import '../../tokens/radius_tokens.dart';
import '../../tokens/typography_tokens.dart';
import '../icon/nixt_icon.dart';
import 'field_shell.dart';

/// One option in a [NixtSelect] or [NixtMultiSelect].
class NixtSelectItem {
  /// Creates a select item.
  const NixtSelectItem(
      {required this.label, required this.value, this.disabled = false});

  /// Visible text.
  final String label;

  /// Stored value.
  final String value;

  /// Whether the option is selectable.
  final bool disabled;
}

/// A single-choice dropdown styled to match [NixtInput]. Tapping opens a custom
/// themed menu anchored to the field — rounded, elevated, with a hairline
/// border, the selected row tinted and check-marked. No native picker chrome.
///
/// ```dart
/// NixtSelect(
///   placeholder: 'Priority',
///   value: selected,
///   items: const [
///     NixtSelectItem(label: 'Low', value: 'low'),
///     NixtSelectItem(label: 'High', value: 'high'),
///   ],
///   onChanged: (v) => setState(() => selected = v),
/// );
/// ```
class NixtSelect extends StatefulWidget {
  /// Creates a select.
  const NixtSelect({
    required this.items,
    this.value,
    this.onChanged,
    this.placeholder,
    this.size = NixtFieldSize.md,
    this.variant = NixtFieldVariant.outline,
    this.color = NixtColorRole.primary,
    this.icon,
    this.errorText,
    this.enabled = true,
    this.menuMaxHeight = 280,
    super.key,
  });

  /// Options.
  final List<NixtSelectItem> items;

  /// Selected value.
  final String? value;

  /// Change callback. A `null` callback disables the control.
  final ValueChanged<String?>? onChanged;

  /// Placeholder shown when nothing is selected.
  final String? placeholder;

  /// Field size. Defaults to `md`.
  final NixtFieldSize size;

  /// Visual variant. Defaults to `outline`.
  final NixtFieldVariant variant;

  /// Focus-ring color role. Defaults to `primary`.
  final NixtColorRole color;

  /// Leading icon.
  final IconData? icon;

  /// Error message — non-null paints the border red.
  final String? errorText;

  /// Whether the control is interactive.
  final bool enabled;

  /// Max height of the open menu before it scrolls.
  final double menuMaxHeight;

  @override
  State<NixtSelect> createState() => _NixtSelectState();
}

class _NixtSelectState extends State<NixtSelect> {
  final _MenuController _ctrl = _MenuController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _pick(String value) {
    widget.onChanged?.call(value);
    _ctrl.close();
  }

  @override
  Widget build(BuildContext context) {
    final interactive = widget.enabled && widget.onChanged != null;
    String? label;
    for (final i in widget.items) {
      if (i.value == widget.value) {
        label = i.label;
        break;
      }
    }
    return _SelectField(
      controller: _ctrl,
      enabled: widget.enabled,
      interactive: interactive,
      size: widget.size,
      variant: widget.variant,
      color: widget.color,
      icon: widget.icon,
      errored: widget.errorText != null,
      text: label ?? widget.placeholder ?? '',
      isPlaceholder: label == null,
      items: widget.items,
      selectedValues: widget.value == null ? const {} : {widget.value!},
      multiple: false,
      menuMaxHeight: widget.menuMaxHeight,
      onPick: _pick,
    );
  }
}

/// A multiple-choice dropdown — shares the chrome and menu of [NixtSelect] but
/// keeps the menu open across taps, toggling each row with a checkbox. The
/// field shows the chosen labels (comma-joined).
///
/// ```dart
/// NixtMultiSelect(
///   placeholder: 'Tags',
///   values: selected,
///   items: const [
///     NixtSelectItem(label: 'Bug', value: 'bug'),
///     NixtSelectItem(label: 'Feature', value: 'feature'),
///   ],
///   onChanged: (v) => setState(() => selected = v),
/// );
/// ```
class NixtMultiSelect extends StatefulWidget {
  /// Creates a multi-select.
  const NixtMultiSelect({
    required this.items,
    this.values = const [],
    this.onChanged,
    this.placeholder,
    this.size = NixtFieldSize.md,
    this.variant = NixtFieldVariant.outline,
    this.color = NixtColorRole.primary,
    this.icon,
    this.errorText,
    this.enabled = true,
    this.menuMaxHeight = 280,
    super.key,
  });

  /// Options.
  final List<NixtSelectItem> items;

  /// Currently selected values.
  final List<String> values;

  /// Change callback with the full new selection. A `null` callback disables.
  final ValueChanged<List<String>>? onChanged;

  /// Placeholder shown when nothing is selected.
  final String? placeholder;

  /// Field size. Defaults to `md`.
  final NixtFieldSize size;

  /// Visual variant. Defaults to `outline`.
  final NixtFieldVariant variant;

  /// Focus-ring color role. Defaults to `primary`.
  final NixtColorRole color;

  /// Leading icon.
  final IconData? icon;

  /// Error message — non-null paints the border red.
  final String? errorText;

  /// Whether the control is interactive.
  final bool enabled;

  /// Max height of the open menu before it scrolls.
  final double menuMaxHeight;

  @override
  State<NixtMultiSelect> createState() => _NixtMultiSelectState();
}

class _NixtMultiSelectState extends State<NixtMultiSelect> {
  final _MenuController _ctrl = _MenuController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(NixtMultiSelect old) {
    super.didUpdateWidget(old);
    // Refresh the open menu so toggled checkboxes reflect the new selection.
    // Deferred — markNeedsBuild can't run during the parent's build phase.
    WidgetsBinding.instance.addPostFrameCallback((_) => _ctrl.refresh());
  }

  void _toggle(String value) {
    final next = List<String>.from(widget.values);
    if (next.contains(value)) {
      next.remove(value);
    } else {
      next.add(value);
    }
    widget.onChanged?.call(next); // Menu stays open (controlled rebuild).
  }

  String _summary() {
    if (widget.values.isEmpty) return widget.placeholder ?? '';
    final labels = <String>[];
    for (final v in widget.values) {
      for (final i in widget.items) {
        if (i.value == v) {
          labels.add(i.label);
          break;
        }
      }
    }
    return labels.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final interactive = widget.enabled && widget.onChanged != null;
    return _SelectField(
      controller: _ctrl,
      enabled: widget.enabled,
      interactive: interactive,
      size: widget.size,
      variant: widget.variant,
      color: widget.color,
      icon: widget.icon,
      errored: widget.errorText != null,
      text: _summary(),
      isPlaceholder: widget.values.isEmpty,
      items: widget.items,
      selectedValues: widget.values.toSet(),
      multiple: true,
      menuMaxHeight: widget.menuMaxHeight,
      onPick: _toggle,
    );
  }
}

/// Drives an anchored menu overlay: open/close/refresh.
class _MenuController {
  OverlayEntry? entry;
  VoidCallback? onChange;

  bool get isOpen => entry != null;

  void refresh() => entry?.markNeedsBuild();

  void close() {
    entry?.remove();
    entry = null;
    onChange?.call();
  }

  void dispose() {
    entry?.remove();
    entry = null;
  }
}

/// The shared field shell + anchored menu, used by both selects.
class _SelectField extends StatefulWidget {
  const _SelectField({
    required this.controller,
    required this.enabled,
    required this.interactive,
    required this.size,
    required this.variant,
    required this.color,
    required this.icon,
    required this.errored,
    required this.text,
    required this.isPlaceholder,
    required this.items,
    required this.selectedValues,
    required this.multiple,
    required this.menuMaxHeight,
    required this.onPick,
  });

  final _MenuController controller;
  final bool enabled;
  final bool interactive;
  final NixtFieldSize size;
  final NixtFieldVariant variant;
  final NixtColorRole color;
  final IconData? icon;
  final bool errored;
  final String text;
  final bool isPlaceholder;
  final List<NixtSelectItem> items;
  final Set<String> selectedValues;
  final bool multiple;
  final double menuMaxHeight;
  final ValueChanged<String> onPick;

  @override
  State<_SelectField> createState() => _SelectFieldState();
}

class _SelectFieldState extends State<_SelectField> {
  final LayerLink _link = LayerLink();
  double _fieldWidth = 0;

  bool get _open => widget.controller.isOpen;

  @override
  void initState() {
    super.initState();
    widget.controller.onChange = _onMenuChange;
  }

  void _onMenuChange() {
    if (mounted) setState(() {});
  }

  void _toggleMenu() => _open ? widget.controller.close() : _showMenu();

  void _showMenu() {
    final t = NixtTheme.of(context);
    widget.controller.entry = OverlayEntry(
      builder: (_) => _SelectMenu(
        link: _link,
        width: _fieldWidth,
        theme: t,
        items: widget.items,
        selected: widget.selectedValues,
        multiple: widget.multiple,
        maxHeight: widget.menuMaxHeight,
        onPick: widget.onPick,
        onDismiss: widget.controller.close,
      ),
    );
    Overlay.of(context).insert(widget.controller.entry!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final t = NixtTheme.of(context);
    final c = t.colors;
    final accent = NixtFieldShell.accent(c, widget.color);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth.isFinite) _fieldWidth = constraints.maxWidth;
        return CompositedTransformTarget(
          link: _link,
          child: Opacity(
            opacity: widget.enabled ? 1 : 0.5,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: widget.interactive ? _toggleMenu : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeOut,
                height: widget.size.height,
                padding: EdgeInsets.symmetric(horizontal: widget.size.padX),
                decoration: NixtFieldShell.resolve(
                  colors: c,
                  radius: t.radius,
                  variant: widget.variant,
                  accentColor: accent,
                  focused: _open,
                  errored: widget.errored,
                ),
                child: Row(
                  children: [
                    if (widget.icon != null) ...[
                      NixtIcon(widget.icon!,
                          size: widget.size.iconSize, color: c.textDimmed),
                      SizedBox(width: widget.size.gap),
                    ],
                    Expanded(
                      child: Text(
                        widget.text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: NixtTypography.fontSans,
                          fontSize: widget.size.fontSize,
                          color: widget.isPlaceholder
                              ? c.textDimmed
                              : c.textHighlighted,
                        ),
                      ),
                    ),
                    SizedBox(width: widget.size.gap),
                    AnimatedRotation(
                      turns: _open ? 0.5 : 0,
                      duration: const Duration(milliseconds: 150),
                      child: NixtIcon(NixtIcons.chevronDown,
                          size: 18, color: c.textDimmed),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// The anchored, animated dropdown menu card.
class _SelectMenu extends StatefulWidget {
  const _SelectMenu({
    required this.link,
    required this.width,
    required this.theme,
    required this.items,
    required this.selected,
    required this.multiple,
    required this.maxHeight,
    required this.onPick,
    required this.onDismiss,
  });

  final LayerLink link;
  final double width;
  final NixtTheme theme;
  final List<NixtSelectItem> items;
  final Set<String> selected;
  final bool multiple;
  final double maxHeight;
  final ValueChanged<String> onPick;
  final VoidCallback onDismiss;

  @override
  State<_SelectMenu> createState() => _SelectMenuState();
}

class _SelectMenuState extends State<_SelectMenu>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 140),
  )..forward();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.theme.colors;
    final r = widget.theme.radius;

    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.onDismiss,
          ),
        ),
        CompositedTransformFollower(
          link: widget.link,
          showWhenUnlinked: false,
          targetAnchor: Alignment.bottomLeft,
          followerAnchor: Alignment.topLeft,
          offset: const Offset(0, 6),
          child: Align(
            alignment: Alignment.topLeft,
            child: FadeTransition(
              opacity: _ctrl,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.96, end: 1).animate(
                  CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
                ),
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: widget.width,
                  child: Container(
                    decoration: BoxDecoration(
                      color: c.bg,
                      borderRadius: r.brLg,
                      border: Border.all(color: c.border, width: 1),
                      boxShadow: widget.theme.shadows.lg,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: widget.maxHeight),
                      child: Material(
                        type: MaterialType.transparency,
                        child: ListView(
                          padding: const EdgeInsets.all(6),
                          shrinkWrap: true,
                          children: [
                            for (final it in widget.items)
                              _MenuRow(
                                item: it,
                                colors: c,
                                radius: r,
                                selected: widget.selected.contains(it.value),
                                multiple: widget.multiple,
                                onTap: it.disabled
                                    ? null
                                    : () => widget.onPick(it.value),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({
    required this.item,
    required this.colors,
    required this.radius,
    required this.selected,
    required this.multiple,
    required this.onTap,
  });

  final NixtSelectItem item;
  final NixtColors colors;
  final NixtRadius radius;
  final bool selected;
  final bool multiple;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = colors;
    return InkWell(
      onTap: onTap,
      borderRadius: radius.brMd,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? nixtOpacity(c.primary, 0.10) : null,
          borderRadius: radius.brMd,
        ),
        child: Row(
          children: [
            if (multiple) ...[
              _Checkbox(checked: selected, colors: c, radius: radius),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  fontFamily: NixtTypography.fontSans,
                  fontSize: NixtTypography.textBase,
                  fontWeight: selected
                      ? NixtTypography.weightMedium
                      : NixtTypography.weightNormal,
                  color: item.disabled
                      ? c.textDimmed
                      : selected
                          ? c.primary
                          : c.textHighlighted,
                ),
              ),
            ),
            if (!multiple && selected)
              NixtIcon(NixtIcons.check, size: 18, color: c.primary),
          ],
        ),
      ),
    );
  }
}

/// A small checkbox indicator used by multi-select rows.
class _Checkbox extends StatelessWidget {
  const _Checkbox(
      {required this.checked, required this.colors, required this.radius});

  final bool checked;
  final NixtColors colors;
  final NixtRadius radius;

  @override
  Widget build(BuildContext context) {
    final c = colors;
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: checked ? c.primary : const Color(0x00000000),
        borderRadius: radius.brSm,
        border: Border.all(
          color: checked ? c.primary : c.borderAccented,
          width: checked ? 0 : 1.5,
        ),
      ),
      child: checked
          ? Icon(NixtIcons.check, size: 14, color: c.textInverted)
          : null,
    );
  }
}
