
import 'package:flutter/material.dart';
import 'package:sonamak_flutter/features/notifications/controllers/notifications_controller.dart';
import 'package:sonamak_flutter/features/notifications/data/notifications_repository.dart';
import 'package:sonamak_flutter/core/navigation/route_hub.dart';

class NotificationBell extends StatefulWidget {
  const NotificationBell({super.key});
  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell> {
  late final NotificationsController controller;

  @override
  void initState() {
    super.initState();
    controller = NotificationsController(NotificationsRepository())..load();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final count = controller.state.unreadCount;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(icon: const Icon(Icons.notifications_none), onPressed: () => RouteHub.go('/admin/notifications')),
            if (count > 0) Positioned(
              right: 6, top: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                child: Text('$count', style: const TextStyle(color: Colors.white, fontSize: 10)),
              ),
            ),
          ],
        );
      },
    );
  }
}
