
import 'package:flutter/material.dart';

class CalendarWeekHeader extends StatelessWidget {
  const CalendarWeekHeader({super.key, required this.anchor});

  final DateTime anchor;

  @override
  Widget build(BuildContext context) {
    final start = _startOfWeek(anchor);
    final days = List<DateTime>.generate(7, (i) => start.add(Duration(days: i)));
    final fmtWeekday = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days.map((d) {
        final isToday = _isSameDay(d, DateTime.now());
        final label = '${fmtWeekday[d.weekday-1]} ${d.day}/${d.month}';
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Text(label, style: TextStyle(fontWeight: isToday ? FontWeight.w600 : FontWeight.w400)),
        );
      }).toList(growable: false),
    );
  }

  static DateTime _startOfWeek(DateTime d) {
    final wd = d.weekday; // Mon=1..Sun=7
    return DateTime(d.year, d.month, d.day).subtract(Duration(days: wd - 1));
  }

  static bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
