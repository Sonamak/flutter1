
import 'package:flutter/material.dart';

/// ParityTabBar mimics MUI Tabs spacing & indicator thickness.
/// Use with DefaultTabController.
class ParityTabBar extends StatelessWidget implements PreferredSizeWidget {
  const ParityTabBar({
    super.key,
    required this.tabs,
    this.isScrollable = false,
  });

  final List<Widget> tabs;
  final bool isScrollable;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TabBar(
      isScrollable: isScrollable,
      indicatorWeight: 3,
      labelStyle: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      unselectedLabelStyle: theme.textTheme.titleSmall,
      tabs: tabs,
      indicatorPadding: const EdgeInsets.symmetric(horizontal: 8),
      labelPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);
}
