import 'package:flutter/material.dart';
class EmptyState extends StatelessWidget {
  const EmptyState({super.key, this.message = 'Nothing here', this.icon = Icons.inbox_outlined});
  final String message;
  final IconData icon;
  @override
  Widget build(BuildContext context) => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, size: 48, color: Colors.grey),
      const SizedBox(height: 8),
      Text(message, style: const TextStyle(color: Colors.grey)),
    ]),
  );
}
