
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SmallMonthCalendar extends StatelessWidget {
  const SmallMonthCalendar({super.key, required this.anchor});
  final DateTime anchor;

  @override
  Widget build(BuildContext context) {
    final first = DateTime(anchor.year, anchor.month, 1);
    final firstWeekday = first.weekday; // 1=Mon..7=Sun
    final daysInMonth = DateUtils.getDaysInMonth(anchor.year, anchor.month);
    final cells = <DateTime?>[];
    for (int i = 1; i < firstWeekday; i++) cells.add(null);
    for (int d = 1; d <= daysInMonth; d++) cells.add(DateTime(anchor.year, anchor.month, d));

    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          DateFormat('MMMM yyyy').format(anchor),
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: const Color(0xFF0F172A)),
        ),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cells.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7, mainAxisSpacing: 4, crossAxisSpacing: 4),
          itemBuilder: (_, i) {
            final d = cells[i];
            if (d == null) return const SizedBox.shrink();
            final isToday = DateUtils.isSameDay(d, DateTime.now());
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isToday ? const Color(0xFF00BBD5).withValues(alpha: 0.12) : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Text('${d.day}', style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFF0F172A))),
            );
          },
        ),
      ],
    );
  }
}
