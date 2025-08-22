import 'package:flutter/material.dart';

class KvRow extends StatelessWidget {
  const KvRow({super.key, required this.label, required this.value, this.mono = false});
  final String label;
  final String value;
  final bool mono;

  @override
  Widget build(BuildContext context) {
    final style = mono ? const TextStyle(fontFamily: 'monospace') : const TextStyle();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 160, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
          const SizedBox(width: 12),
          Expanded(child: SelectableText(value, style: style)),
        ],
      ),
    );
  }
}
