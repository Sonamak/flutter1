
import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/features/finance/presentation/pages/payment_slip_page.dart';

class FinanceInstaller {
  static void register() {
    RouteHub.register('/admin/finance/payment-slip', RouteEntry(
      builder: (ctx) {
        final args = RouteHub.argsOf<Map<String, dynamic>>(ctx) ?? const {};
        return PaymentSlipPage(args: args);
      },
    ));
  }
}
