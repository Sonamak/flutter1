import 'package:flutter/material.dart';
import 'package:sonamak_flutter/core/security/secure_storage.dart';
import 'package:sonamak_flutter/core/network/interceptors.dart' show NetKeys;
import 'package:sonamak_flutter/core/navigation/route_hub.dart';

class RequireAuth extends StatefulWidget {
  const RequireAuth({super.key, required this.child, this.redirectPath = '/login'});
  final Widget child;
  final String redirectPath;

  @override
  State<RequireAuth> createState() => _RequireAuthState();
}

class _RequireAuthState extends State<RequireAuth> {
  bool _checking = true;
  bool _hasToken = false;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    final token = await SecureStorage.read(NetKeys.authTokenStorageKey);
    setState(() { _hasToken = token != null && token.isNotEmpty; _checking = false; });
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_hasToken) return widget.child;
    Future.microtask(() => RouteHub.navKey.currentState?.pushNamedAndRemoveUntil(widget.redirectPath, (r) => false));
    return Scaffold(
      appBar: AppBar(title: const Text('Login required')),
      body: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('You need to log in to continue.'),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: () => RouteHub.navKey.currentState?.pushNamedAndRemoveUntil(widget.redirectPath, (r) => false), child: const Text('Go to login')),
        ]),
      ),
    );
  }
}
