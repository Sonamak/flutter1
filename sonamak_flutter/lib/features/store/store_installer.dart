
import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/features/store/presentation/pages/store_page.dart';
import 'package:sonamak_flutter/features/store/presentation/pages/orders_page.dart';

class StoreInstaller {
  static void register() {
    RouteHub.register('/admin/store', RouteEntry(builder: (_) => const StorePage()));
    RouteHub.register('/admin/store/orders', RouteEntry(builder: (_) => const OrdersPage()));
  }
}
