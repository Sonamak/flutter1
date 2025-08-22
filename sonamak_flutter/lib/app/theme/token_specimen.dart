
import 'package:flutter/material.dart';
import 'tokens.dart';

/// Visual specimen to verify tokens/typography/spacing quickly.
class TokenSpecimen extends StatelessWidget {
  const TokenSpecimen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Token Specimen')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Headings', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('H1 — 48', style: theme.textTheme.displaySmall),
            Text('H2 — 32', style: theme.textTheme.headlineMedium),
            Text('Body — 21', style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),
            Text('Spacing & radii', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Wrap(spacing: 12, runSpacing: 12, children: [
              _chip('padXS=12'),
              _chip('pad29XL=48'),
              _chip('spaceXL=32'),
              _box(color: AppTokens.seed.withValues(alpha: 0.10), label: 'seed@10%'),
              _box(color: AppTokens.success.withValues(alpha: 0.25), label: 'success@25%'),
              _box(color: AppTokens.warning.withValues(alpha: 0.25), label: 'warning@25%'),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label) => Chip(label: Text(label));

  Widget _box({required Color color, required String label}) {
    return Container(
      width: 96, height: 56,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      alignment: Alignment.center,
      child: Text(label, textAlign: TextAlign.center),
    );
  }
}
