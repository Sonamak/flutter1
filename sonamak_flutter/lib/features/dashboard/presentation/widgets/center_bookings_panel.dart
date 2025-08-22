
import 'package:flutter/material.dart';
import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/features/dashboard/presentation/widgets/small_month_calendar.dart';
import 'package:sonamak_flutter/features/dashboard/presentation/widgets/gradient_button.dart';

class CenterBookingsPanel extends StatelessWidget {
  const CenterBookingsPanel({super.key, required this.anchor});
  final DateTime anchor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Center Bookings', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: const Color(0xFF0F172A))),
              GradientButton(onPressed: () => RouteHub.navKey.currentState?.pushNamed('/admin/calendar'), label: 'Add New Appointment'),
            ]),
            const SizedBox(height: 12),
            SmallMonthCalendar(anchor: anchor),
            const SizedBox(height: 12),
            // toolbar row
            Row(children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search by Name',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.tune), label: const Text('Filter')),
            ]),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: const [_NoData(), _NoData()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoData extends StatelessWidget {
  const _NoData();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.insert_drive_file_outlined, size: 48, color: theme.disabledColor),
          const SizedBox(height: 8),
          Text('No Data', style: theme.textTheme.bodySmall?.copyWith(color: theme.disabledColor)),
        ],
      ),
    );
  }
}
