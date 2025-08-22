
import 'package:flutter/material.dart';
import 'package:sonamak_flutter/app/localization/rtl_builder.dart';
import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/core/widgets/app_snackbar.dart';
import 'package:sonamak_flutter/features/notifications/controllers/notifications_controller.dart';
import 'package:sonamak_flutter/features/notifications/data/notifications_repository.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late final NotificationsController controller;

  @override
  void initState() {
    super.initState();
    controller = NotificationsController(NotificationsRepository())..load();
  }

  @override
  Widget build(BuildContext context) {
    return RtlBuilder(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications'),
          actions: [
            AnimatedBuilder(
              animation: controller,
              builder: (_, __) => Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('Unread: ${controller.state.unreadCount}'),
                ),
              ),
            ),
            IconButton(
              onPressed: () async {
                final ok = await controller.markAllRead();
                if (!mounted) return;
                ok ? AppSnackbar.showSuccess(context, 'Marked as read') : AppSnackbar.showError(context, 'Failed');
              },
              icon: const Icon(Icons.mark_email_read_outlined),
              tooltip: 'Mark all as read',
            ),
          ],
        ),
        body: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final st = controller.state;
            if (st.loading) return const Center(child: CircularProgressIndicator());
            if (st.items.isEmpty) {
              return const Center(child: Text('No notifications'));
            }
            return ListView.separated(
              itemCount: st.items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final n = st.items[i];
                final subtitle = [
                  if (n.userName != null && n.userName!.isNotEmpty) 'By: ${n.userName}',
                  if (n.branchName != null && n.branchName!.isNotEmpty) 'Branch: ${n.branchName}',
                  if (n.name != null && n.name!.isNotEmpty) 'Name: ${n.name}',
                ].join(' • ');
                return ListTile(
                  leading: Icon(n.read ? Icons.notifications_none : Icons.notifications_active_outlined),
                  title: Text(n.message),
                  subtitle: subtitle.isEmpty ? null : Text(subtitle),
                  onTap: () {
                    final id = n.calendarEventId;
                    if (id != null) {
                      RouteHub.go('/admin/reports/invoice', args: {'eventId': id}); // adjust target if a calendar page exists
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
