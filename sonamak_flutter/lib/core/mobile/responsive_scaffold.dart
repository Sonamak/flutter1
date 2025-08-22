import 'package:flutter/material.dart';
import 'breakpoints.dart';

/// A thin wrapper that adjusts padding and scroll behaviors by width only.
class ResponsiveScaffold extends StatelessWidget {
  const ResponsiveScaffold({super.key, required this.title, required this.body, this.actions});
  final String title;
  final Widget body;
  final List<Widget>? actions;

  EdgeInsets _padFor(double w) {
    if (w < AppBreakpoints.mobile) return const EdgeInsets.all(12);
    if (w < AppBreakpoints.tablet) return const EdgeInsets.symmetric(horizontal: 16, vertical: 14);
    if (w < AppBreakpoints.desktop) return const EdgeInsets.symmetric(horizontal: 20, vertical: 16);
    return const EdgeInsets.symmetric(horizontal: 24, vertical: 18);
    }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions),
      body: Padding(padding: _padFor(w), child: body),
    );
  }
}
