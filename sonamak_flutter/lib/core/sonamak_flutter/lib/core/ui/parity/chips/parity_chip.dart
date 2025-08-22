
import 'package:flutter/material.dart';

class ParityChip extends StatelessWidget {
  const ParityChip({
    super.key,
    required this.label,
    required this.selected,
    this.onSelected,
    this.leading,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = selected
        ? theme.colorScheme.primary.withValues(alpha: 0.15)
        : theme.colorScheme.surface;
    final border = selected
        ? theme.colorScheme.primary.withValues(alpha: 0.60)
        : theme.dividerColor;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onSelected == null ? null : () => onSelected!(!selected),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (leading != null) ...[leading!, const SizedBox(width: 6)],
          Text(label, style: theme.textTheme.bodyMedium),
          if (selected) ...[const SizedBox(width: 6), const Icon(Icons.check, size: 16)],
        ]),
      ),
    );
  }
}
