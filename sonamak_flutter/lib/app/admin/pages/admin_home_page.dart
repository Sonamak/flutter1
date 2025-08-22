import 'package:flutter/material.dart';
import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/data/services/auth_api.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});
  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  bool _redirected = false;
  bool _loading = true;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    setState(() { _loading = true; _error = null; });
    try {
      await AuthApi.me(); // confirms session, but we don't block UI on it
      if (!_redirected && mounted) {
        _redirected = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          RouteHub.navKey.currentState?.pushReplacementNamed('/admin/dashboard');
        });
      }
      setState(() { _loading = false; });
    } catch (e) {
      setState(() { _error = e; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin')),
      body: Center(
        child: _loading ? const CircularProgressIndicator() :
          (_error != null ? Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.error_outline, size: 40),
            const SizedBox(height: 8),
            Text('Error loading /me: $_error'),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _bootstrap, child: const Text('Retry')),
            const SizedBox(height: 20),
            Wrap(spacing: 8, runSpacing: 8, children: [
              OutlinedButton(onPressed: () => RouteHub.navKey.currentState?.pushReplacementNamed('/admin/dashboard'), child: const Text('Open Dashboard')),
              OutlinedButton(onPressed: () => RouteHub.navKey.currentState?.pushReplacementNamed('/admin/settings/profile'), child: const Text('Profile Settings')),
              OutlinedButton(onPressed: () => RouteHub.navKey.currentState?.pushReplacementNamed('/admin/calendar'), child: const Text('Calendar')),
            ])
          ]) : const Text('Redirecting…')),
      ),
    );
  }
}
