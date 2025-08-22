
import 'package:flutter/material.dart';

/// Simple week header displaying Mon..Sun and allowing date selection.
class WeekHeader extends StatelessWidget {
  const WeekHeader({super.key, required this.anchor, required this.onSelect});

  final DateTime anchor;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final startOfWeek = _startOfWeek(anchor);
    final days = List<DateTime>.generate(7, (i) => startOfWeek.add(Duration(days: i)));
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => onSelect(anchor.subtract(const Duration(days: 7))),
          tooltip: 'Previous week',
        ),
        Expanded(
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 8,
            children: days.map((d) {
              final isToday = _isSameDay(d, DateTime.now());
              final label = _fmt(d);
              return ChoiceChip(
                label: Text(label),
                selected: _isSameDay(d, anchor),
                onSelected: (_) => onSelect(d),
                labelStyle: isToday ? const TextStyle(fontWeight: FontWeight.w600) : null,
              );
            }).toList(growable: false),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          onPressed: () => onSelect(anchor.add(const Duration(days: 7))),
          tooltip: 'Next week',
        ),
      ],
    );
  }

  static DateTime _startOfWeek(DateTime d) {
    final wd = d.weekday; // Mon=1..Sun=7
    return DateTime(d.year, d.month, d.day).subtract(Duration(days: wd - 1));
  }

  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static String _fmt(DateTime d) {
    final w = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'][d.weekday - 1];
    return '$w ${d.day}/${d.month}';
  }
}
