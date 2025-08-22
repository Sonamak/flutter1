
import 'package:flutter/material.dart';
import 'package:sonamak_flutter/core/navigation/route_hub.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) => RouteHub.resolve(settings);
}
