import 'package:flutter/widgets.dart';

import '../../foundations/nixt_icons.dart';
import '../../foundations/press_scale.dart';
import '../../theme/nixt_colors.dart';
import '../../theme/nixt_theme.dart';
import '../../tokens/color_roles.dart';
import '../../tokens/palette.dart';
import '../../tokens/typography_tokens.dart';
import '../buttons/nixt_button.dart';
import '../buttons/nixt_icon_button.dart';

const List<String> _kMonths = <String>[
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

const List<String> _kWeekdays = <String>['S', 'M', 'T', 'W', 'T', 'F', 'S'];

/// A month-grid date picker with prev / next navigation.
///
/// Purely visual and controlled: pass the selected [value] and respond to
/// [onChanged] to move the selection. The visible month follows [value] (or the
/// current month when null) and can be paged independently with the header
/// arrows.
///
/// ```dart
/// NixtCalendar(
///   value: selected,
///   onChanged: (d) => setState(() => selected = d),
/// );
/// ```
class NixtCalendar extends StatefulWidget {
  /// Creates a calendar.
  const NixtCalendar({
    this.value,
    this.onChanged,
    this.color = NixtColorRole.primary,
    super.key,
  });

  /// The currently selected day. `null` selects nothing.
  final DateTime? value;

  /// Fired with the tapped day. A `null` callback makes days non-interactive.
  final ValueChanged<DateTime>? onChanged;

  /// Accent color role for the selected day and today's ring. Defaults to
  /// `primary`.
  final NixtColorRole color;

  @override
  State<NixtCalendar> createState() => _NixtCalendarState();
}

class _NixtCalendarState extends State<NixtCalendar> {
  late int _year;
  late int _month; // 0-based

  @override
  void initState() {
    super.initState();
    _syncView(widget.value);
  }

  @override
  void didUpdateWidget(NixtCalendar old) {
    super.didUpdateWidget(old);
    // Re-anchor the view when the selection jumps to another month.
    final v = widget.value;
    if (v != null && (v.year != _year || v.month - 1 != _month)) {
      _syncView(v);
    }
  }

  void _syncView(DateTime? v) {
    final base = v ?? DateTime.now();
    _year = base.year;
    _month = base.month - 1;
  }

  void _shift(int delta) {
    final nm = _month + delta;
    setState(() {
      _year += (nm / 12).floor();
      _month = ((nm % 12) + 12) % 12;
    });
  }

  bool _isSame(int day, DateTime? date) =>
      date != null &&
      date.year == _year &&
      date.month - 1 == _month &&
      date.day == day;

  @override
  Widget build(BuildContext context) {
    final t = NixtTheme.of(context);
    final c = t.colors;
    final accent = widget.color == NixtColorRole.neutral
        ? c.textHighlighted
        : c.role(widget.color);

    final today = DateTime.now();
    final firstWeekday = DateTime(_year, _month + 1, 1).weekday % 7; // Sun = 0
    final daysIn = DateTime(_year, _month + 2, 0).day;

    // Build a flat list of cells (leading nulls + day numbers).
    final cells = <int?>[
      for (var i = 0; i < firstWeekday; i++) null,
      for (var d = 1; d <= daysIn; d++) d,
    ];
    while (cells.length % 7 != 0) {
      cells.add(null);
    }

    return DefaultTextStyle(
      style: TextStyle(fontFamily: NixtTypography.fontSans, color: c.text),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ---- Header ----
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${_kMonths[_month]} $_year',
                    style: TextStyle(
                      fontSize: NixtTypography.textBase,
                      fontWeight: NixtTypography.weightBold,
                      color: c.textHighlighted,
                    ),
                  ),
                ),
                NixtIconButton(
                  icon: NixtIcons.chevronLeft,
                  label: 'Previous month',
                  size: NixtButtonSize.sm,
                  onPressed: () => _shift(-1),
                ),
                const SizedBox(width: 2),
                NixtIconButton(
                  icon: NixtIcons.chevronRight,
                  label: 'Next month',
                  size: NixtButtonSize.sm,
                  onPressed: () => _shift(1),
                ),
              ],
            ),
          ),
          // ---- Weekday labels ----
          Row(
            children: [
              for (final wd in _kWeekdays)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      wd,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: NixtTypography.text2xs,
                        fontWeight: NixtTypography.weightSemibold,
                        color: c.textDimmed,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          // ---- Day grid ----
          for (var row = 0; row < cells.length; row += 7)
            Row(
              children: [
                for (var col = 0; col < 7; col++)
                  Expanded(
                    child: _DayCell(
                      day: cells[row + col],
                      selected: _isSame(cells[row + col] ?? -1, widget.value),
                      isToday: _isSame(cells[row + col] ?? -1, today),
                      accent: accent,
                      colors: c,
                      onTap: widget.onChanged == null
                          ? null
                          : (d) => widget.onChanged!(DateTime(_year, _month + 1, d)),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.selected,
    required this.isToday,
    required this.accent,
    required this.colors,
    required this.onTap,
  });

  final int? day;
  final bool selected;
  final bool isToday;
  final Color accent;
  final NixtColors colors;
  final ValueChanged<int>? onTap;

  @override
  Widget build(BuildContext context) {
    final c = colors;
    if (day == null) return const AspectRatio(aspectRatio: 1, child: SizedBox());

    final fg = selected ? NixtPalette.white : c.text;
    final cell = AspectRatio(
      aspectRatio: 1,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected ? accent : null,
          border: isToday && !selected
              ? Border.all(color: accent, width: 1.5)
              : null,
        ),
        child: Text(
          '$day',
          style: TextStyle(
            fontFamily: NixtTypography.fontMono,
            fontSize: NixtTypography.textSm,
            fontWeight: selected || isToday
                ? NixtTypography.weightBold
                : NixtTypography.weightMedium,
            color: fg,
          ),
        ),
      ),
    );

    if (onTap == null) return cell;
    return NixtPressScale(onTap: () => onTap!(day!), child: cell);
  }
}
