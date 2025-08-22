import 'package:flutter/material.dart';

/// Keeps primary actions visible at the bottom on small screens.
class StickyActionBar extends StatelessWidget {
  const StickyActionBar({super.key, required this.children, this.safe = true});
  final List<Widget> children;
  final bool safe;

  @override
  Widget build(BuildContext context) {
    final bar = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Spacer(),
          Wrap(spacing: 8, children: children),
        ],
      ),
    );
    return safe ? SafeArea(top: false, child: bar) : bar;
  }
}
