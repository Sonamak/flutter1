
import 'package:flutter/material.dart';
import 'models.dart';

class QuickInfoContent extends StatelessWidget {
  const QuickInfoContent({super.key, required this.event, this.onClose});
  final CalendarEvent event;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (event.subtitle != null) Text(event.subtitle!, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 12),
        Row(children: [
          ElevatedButton.icon(onPressed: onClose, icon: const Icon(Icons.check), label: const Text('Close')),
          const SizedBox(width: 8),
          OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.edit_outlined), label: const Text('Edit')),
          const SizedBox(width: 8),
          OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.delete_outline), label: const Text('Delete')),
        ]),
      ],
    );
  }
}
