import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/features/i18n_a11y_qa/presentation/pages/i18n_a11y_qa_page.dart';

class I18nA11yInstaller {
  static void register() {
    RouteHub.register('/i18n-a11y/qa', RouteEntry(builder: (_) => const I18nA11yQaPage()));
  }
}
