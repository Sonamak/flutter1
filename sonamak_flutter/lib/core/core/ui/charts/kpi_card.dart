import 'package:flutter/material.dart';

class KpiCard extends StatelessWidget {
  const KpiCard({super.key, required this.title, required this.value, this.delta, this.deltaPositiveColor, this.deltaNegativeColor});
  final String title;
  final String value;
  final double? delta;
  final Color? deltaPositiveColor;
  final Color? deltaNegativeColor;

  @override
  Widget build(BuildContext context) {
    final pos = delta != null && delta! >= 0;
    final col = pos ? (deltaPositiveColor ?? Colors.green) : (deltaNegativeColor ?? Colors.red);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(width: 12),
              if (delta != null)
                Row(children: [
                  Icon(pos ? Icons.arrow_upward : Icons.arrow_downward, size: 18, color: col),
                  Text('${delta!.abs().toStringAsFixed(1)}%', style: TextStyle(color: col)),
                ]),
            ],
          ),
        ],
      ),
    );
  }
}
