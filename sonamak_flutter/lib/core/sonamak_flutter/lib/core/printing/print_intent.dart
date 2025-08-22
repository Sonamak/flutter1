import 'package:sonamak_flutter/core/desktop/open_in_default.dart';

/// Minimal print intent: open the saved file in the OS default app, from where user can print.
/// For direct spooling, consider adding a printing plugin in a later phase.
class PrintIntent {
  static Future<bool> openForPrint(String filePath) => OpenInDefault.open(filePath);
}
