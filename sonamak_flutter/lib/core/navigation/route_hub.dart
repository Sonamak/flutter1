import 'package:flutter/material.dart';

typedef RouteWidgetBuilder = Widget Function(BuildContext context);

class RouteEntry { final RouteWidgetBuilder builder; const RouteEntry({required this.builder}); }

class RouteHub {
  static final GlobalKey<NavigatorState> navKey = GlobalKey<NavigatorState>();
  static final Map<String, RouteEntry> _routes = <String, RouteEntry>{};

  static void register(String path, RouteEntry entry) { _routes[path] = entry; }

  static Route<dynamic> resolve(RouteSettings settings) {
    final entry = _routes[settings.name];
    if (entry == null) {
      return MaterialPageRoute(builder: (_) => MissingRoutePage(settings.name ?? 'unknown'));
    }
    return MaterialPageRoute(builder: (ctx) => entry.builder(ctx), settings: settings);
  }

  static Future<T?>? go<T>(String path, {Object? args}) {
    final state = navKey.currentState;
    final entry = _routes[path];
    if (state == null || entry == null) return null;
    return state.push<T>(MaterialPageRoute<T>(
      builder: (ctx) => entry.builder(ctx),
      settings: RouteSettings(name: path, arguments: args),
    ));
  }

  static T? argsOf<T>([BuildContext? context]) {
    final ctx = context ?? navKey.currentContext;
    if (ctx == null) return null;
    final args = ModalRoute.of(ctx)?.settings.arguments;
    if (args is T) return args;
    return null;
  }
}

class MissingRoutePage extends StatelessWidget {
  const MissingRoutePage(this.path, {super.key});
  final String path;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Route not found')),
      body: Center(child: Text('No route registered for \"$path\"')),
    );
  }
}
