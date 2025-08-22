
import 'package:flutter/material.dart';
import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/app/admin/widgets/logged_in_badge.dart';

class AdminTopNav extends StatelessWidget {
  const AdminTopNav({super.key, this.active = 'Dashboard'});
  final String active;

  TextStyle? _style(BuildContext context, String label) {
    final isActive = label.toLowerCase() == active.toLowerCase();
    return Theme.of(context).textTheme.titleSmall?.copyWith(
      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Row(
        children: [
          TextButton(
            onPressed: () => RouteHub.navKey.currentState?.pushNamed('/admin/dashboard'),
            child: Text('Dashboard', style: _style(context, 'Dashboard')),
          ),
          const SizedBox(width: 18),
          _Drop(label: 'Centers', active: active == 'Centers', items: const [
            _DropItem('Center Branches', '/admin/branches'),
            _DropItem('Center Members', '/admin/members'),
            _DropItem('Center Pricing', '/pricing'),
            _DropItem('Medical Data', '/admin/reports'),
            _DropItem('Center Rooms', '/admin/branches'),
            _DropItem('Laboratory', '/admin/lab'),
            _DropItem('Store', '/admin/store'),
          ]),
          const SizedBox(width: 18),
          _Drop(label: 'Bookings', active: active == 'Bookings', items: const [
            _DropItem('Booking Calendar', '/booking/calendar'),
            _DropItem('Booking Requests', '/admin/notifications'),
          ]),
          const SizedBox(width: 18),
          _Drop(label: 'Patients', active: active == 'Patients', items: const [
            _DropItem('Patient List', '/admin/patients'),
            _DropItem('Examinations', '/admin/patients'),
            _DropItem('Insurance', '/admin/insurance'),
            _DropItem('Social List', '/admin/patients'),
            _DropItem('Referrals List', '/admin/patients'),
          ]),
          const SizedBox(width: 18),
          _Drop(label: 'Transactions', active: active == 'Transactions', items: const [
            _DropItem('Transactions', '/admin/finance'),
            _DropItem('Purchase Transactions', '/admin/reports/invoice'),
          ]),
          const Spacer(),
          const LoggedInBadge(),
        ],
      ),
    );
  }
}

class _DropItem {
  final String label;
  final String route;
  const _DropItem(this.label, this.route);
}

class _Drop extends StatelessWidget {
  const _Drop({required this.label, required this.items, this.active = false});
  final String label;
  final List<_DropItem> items;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final txt = Text(
      label,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: active ? FontWeight.w700 : FontWeight.w500),
    );
    return PopupMenuButton<_DropItem>(
      onSelected: (i) => RouteHub.navKey.currentState?.pushNamed(i.route),
      itemBuilder: (_) => items.map((i) => PopupMenuItem<_DropItem>(value: i, child: Text(i.label))).toList(growable: false),
      child: Row(children: [txt, const SizedBox(width: 4), const Icon(Icons.expand_more, size: 18)]),
    );
  }
}
