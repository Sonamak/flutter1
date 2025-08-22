
import 'package:flutter/material.dart';
import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/data/services/auth_api.dart';
import 'package:sonamak_flutter/core/security/secure_storage.dart';
import 'package:sonamak_flutter/features/notifications/presentation/notifications_badge.dart';
import 'package:sonamak_flutter/features/setup/branches/branch_selector.dart';
import 'package:sonamak_flutter/features/setup/branches/server_branch_source.dart';

/// Admin app shell: standardizes header with branch selector, notifications, and user menu.
/// Pages can embed their content via [child].
class AdminShell extends StatelessWidget {
  const AdminShell({super.key, required this.title, required this.child, this.actions});

  final String title;
  final Widget child;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          NotificationsBadge(count: 0, onTap: () => _navigate('/admin/notifications')),
          const SizedBox(width: 8),
          BranchSelector(
            dataSource: ServerBranchSource(),
            onChanged: (br) {
              // No-op here; pages can listen to BranchPersistence if needed.
            },
          ),
          const SizedBox(width: 8),
          PopupMenuButton<String>(
            onSelected: (v) {
              switch (v) {
                case 'dashboard': _navigate('/admin/dashboard'); break;
                case 'profile': _navigate('/admin/settings/profile'); break;
                case 'logout': _logout(); break;
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'dashboard', child: Text('Dashboard')),
              PopupMenuItem(value: 'profile', child: Text('Profile settings')),
              PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
            icon: const Icon(Icons.account_circle_outlined),
          ),
          const SizedBox(width: 8),
          if (actions != null) ...actions!,
        ],
      ),
      body: child,
    );
  }

  void _navigate(String path) {
    try {
      RouteHub.navKey.currentState?.pushNamed(path);
    } catch (_) {
      // swallow navigation errors to avoid crashing header
    }
  }

  Future<void> _logout() async {
    try { await AuthApi.logout(); } catch (_) {}
    await SecureStorage.delete('auth_token');
    RouteHub.navKey.currentState?.pushNamedAndRemoveUntil('/login', (r) => false);
  }
}
