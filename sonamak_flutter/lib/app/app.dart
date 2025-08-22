import 'package:flutter/material.dart';
import 'package:sonamak_flutter/app/localization/l10n.dart';
import 'package:sonamak_flutter/app/router/app_router.dart';
import 'package:sonamak_flutter/app/router/routes.dart';
import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/app/localization/rtl_builder.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: RouteHub.navKey,
      onGenerateRoute: AppRouter.onGenerateRoute,
      // ✅ Start the app on the real initial screen via the router
      initialRoute: Routes.landing,
      localizationsDelegates: L10n.delegates,
      supportedLocales: L10n.supportedLocales,
      localeResolutionCallback: L10n.localeResolution,
      // Wrap entire app content in a global LTR/RTL resolver to mirror React's body.dir behavior.
      builder: (context, child) => RtlBuilder(child: child ?? const SizedBox.shrink()),
    );
  }
}
