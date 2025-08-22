
import 'package:flutter/material.dart';

/// Standard empty state with accessible semantics.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    this.icon = Icons.inbox_outlined,
    this.title = 'No data',
    this.subtitle,
    this.action,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: 'Empty state: $title',
      readOnly: true,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: theme.colorScheme.primary.withValues(alpha: 0.60)),
              const SizedBox(height: 12),
              Text(title, style: theme.textTheme.titleMedium),
              if (subtitle != null) ...[
                const SizedBox(height: 6),
                Text(subtitle!, style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
              ],
              if (action != null) ...[
                const SizedBox(height: 12),
                action!,
              ]
            ],
          ),
        ),
      ),
    );
  }
}
