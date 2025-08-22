
import 'package:flutter/material.dart';

class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    super.key,
    required this.anchor,
    required this.onPrev,
    required this.onNext,
    required this.onToday,
    this.trailing,
  });

  final DateTime anchor;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onToday;
  final Widget? trailing;

  String _monthLabel(DateTime d) {
    const months = [
      'January','February','March','April','May','June','July','August','September','October','November','December'
    ];
    return '${months[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(_monthLabel(anchor), style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(width: 16),
        IconButton(onPressed: onPrev, icon: const Icon(Icons.chevron_left)),
        IconButton(onPressed: onNext, icon: const Icon(Icons.chevron_right)),
        const SizedBox(width: 8),
        OutlinedButton(onPressed: onToday, child: const Text('Today')),
        const Spacer(),
        if (trailing != null) trailing!,
      ],
    );
  }
}
