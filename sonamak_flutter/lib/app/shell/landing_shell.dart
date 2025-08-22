
import 'package:flutter/material.dart';
import 'package:sonamak_flutter/app/localization/app_localizations.dart';
import 'package:sonamak_flutter/core/navigation/route_hub.dart';

class LandingShell extends StatelessWidget {
  const LandingShell({super.key, required this.child});
  final Widget child;

  static const _links = <_NavLink>[
    _NavLink(label: 'Home', path: '/'),
    _NavLink(label: 'About', path: '/about'),
    _NavLink(label: 'Pricing', path: '/pricing'),
    _NavLink(label: 'Contact', path: '/contact'),
    _NavLink(label: 'Policy', path: '/policy'),
    _NavLink(label: 'Compliance', path: '/compliance'),
    _NavLink(label: 'Terms', path: '/terms'),
    _NavLink(label: 'Patient Info', path: '/patient-information'),
    _NavLink(label: 'Login', path: '/login'), // added
  ];

  @override
  Widget build(BuildContext context) {
    final i18n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final narrow = width < 840;
    final current = ModalRoute.of(context)?.settings.name;

    return Scaffold(
      appBar: AppBar(
        title: Text(i18n.t('app_title')),
        actions: [
          if (narrow)
            PopupMenuButton<String>(
              icon: const Icon(Icons.menu),
              onSelected: _go,
              itemBuilder: (_) => _links.map((l) {
                final active = current == l.path;
                return PopupMenuItem<String>(
                  value: l.path,
                  child: Row(
                    children: [
                      if (active) const Icon(Icons.check, size: 16) else const SizedBox(width: 16),
                      const SizedBox(width: 8),
                      Text(l.label),
                    ],
                  ),
                );
              }).toList(),
            )
          else
            Row(
              mainAxisSize: MainAxisSize.min,
              children: _links.map((l) {
                final active = current == l.path;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: TextButton(
                    onPressed: () => _go(l.path),
                    child: Text(
                      l.label,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                        decoration: active ? TextDecoration.underline : TextDecoration.none,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: child),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              children: [
                Text('© ${DateTime.now().year} Sonamak', style: theme.textTheme.bodySmall),
                Wrap(spacing: 12, children: _links.take(4).map((l) {
                  return InkWell(onTap: () => _go(l.path), child: Text(l.label, style: theme.textTheme.bodySmall));
                }).toList()),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _go(String path) {
    final nav = RouteHub.navKey.currentState;
    if (nav == null) return;
    nav.pushNamed(path);
  }
}

class _NavLink {
  final String label;
  final String path;
  const _NavLink({required this.label, required this.path});
}
