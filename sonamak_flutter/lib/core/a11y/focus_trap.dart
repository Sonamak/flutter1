import 'package:flutter/material.dart';

class FocusTrap extends StatelessWidget {
  const FocusTrap({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(policy: OrderedTraversalPolicy(), child: child);
  }
}
