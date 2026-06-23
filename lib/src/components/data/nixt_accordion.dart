import 'package:flutter/widgets.dart';

import '../../foundations/nixt_icons.dart';
import '../../theme/nixt_theme.dart';
import '../../tokens/typography_tokens.dart';
import '../icon/nixt_icon.dart';

/// One row of a [NixtAccordion].
@immutable
class NixtAccordionItem {
  /// Creates an accordion item.
  const NixtAccordionItem(
      {required this.label, required this.content, this.icon});

  /// Header label.
  final String label;

  /// Body revealed when the row is open.
  final Widget content;

  /// Optional leading icon in the header.
  final IconData? icon;
}

/// Collapsible disclosure list (FAQ / grouped settings). Single-open by
/// default; set [allowMultiple] to keep several panels expanded. [defaultOpen]
/// lists indices open on mount.
///
/// ```dart
/// NixtAccordion(items: [
///   NixtAccordionItem(label: 'Shipping', content: Text('…')),
///   NixtAccordionItem(label: 'Returns', content: Text('…'), icon: NixtIcons.info),
/// ]);
/// ```
class NixtAccordion extends StatefulWidget {
  /// Creates an accordion.
  const NixtAccordion({
    required this.items,
    this.allowMultiple = false,
    this.defaultOpen = const [],
    super.key,
  });

  /// The rows.
  final List<NixtAccordionItem> items;

  /// Allow several panels open at once. Defaults to false (single-open).
  final bool allowMultiple;

  /// Indices open on mount.
  final List<int> defaultOpen;

  @override
  State<NixtAccordion> createState() => _NixtAccordionState();
}

class _NixtAccordionState extends State<NixtAccordion> {
  late final Set<int> _open = {...widget.defaultOpen};

  void _toggle(int i) => setState(() {
        final wasOpen = _open.contains(i);
        if (!widget.allowMultiple) _open.clear();
        if (wasOpen) {
          _open.remove(i);
        } else {
          _open.add(i);
        }
      });

  @override
  Widget build(BuildContext context) {
    final c = NixtTheme.of(context).colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < widget.items.length; i++)
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: c.border)),
            ),
            child: _Row(
              item: widget.items[i],
              open: _open.contains(i),
              onTap: () => _toggle(i),
            ),
          ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.item, required this.open, required this.onTap});
  final NixtAccordionItem item;
  final bool open;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = NixtTheme.of(context).colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
            child: Row(
              children: [
                if (item.icon != null) ...[
                  NixtIcon(item.icon!, size: 18, color: c.textMuted),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      fontFamily: NixtTypography.fontSans,
                      fontSize: NixtTypography.textSm,
                      fontWeight: FontWeight.w600,
                      color: c.textHighlighted,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: open ? 0.5 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: NixtIcon(NixtIcons.chevronDown,
                      size: 18, color: c.textDimmed),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeInOutCubic,
          alignment: Alignment.topCenter,
          child: open
              ? Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4, bottom: 16),
                  child: DefaultTextStyle(
                    style: TextStyle(
                      fontFamily: NixtTypography.fontSans,
                      fontSize: NixtTypography.textSm,
                      height: 1.5,
                      color: c.textToned,
                    ),
                    child: Align(
                        alignment: Alignment.centerLeft, child: item.content),
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}
