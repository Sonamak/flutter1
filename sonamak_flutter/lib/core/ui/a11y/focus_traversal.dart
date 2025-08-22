
import 'package:flutter/widgets.dart';

/// Predictable focus traversal wrapper for forms/grids.
/// Uses the built-in ReadingOrderTraversalPolicy to avoid SDK name drift.
class FocusGrid extends StatelessWidget {
  const FocusGrid({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // ReadingOrderTraversalPolicy implements FocusTraversalPolicy in all stable SDKs.
    return FocusTraversalGroup(
      policy: ReadingOrderTraversalPolicy(),
      child: child,
    );
  }
}
