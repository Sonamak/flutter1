
import 'package:flutter/material.dart';
import 'models.dart';

class QuickInfoHeader extends StatelessWidget {
  const QuickInfoHeader({super.key, required this.event});
  final CalendarEvent event;

  @override
  Widget build(BuildContext context) {
    final t = TimeOfDay.fromDateTime(event.start).format(context);
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: event.color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(event.title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(width: 12),
        Text(t, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
