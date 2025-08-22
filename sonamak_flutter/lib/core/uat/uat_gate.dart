import 'package:flutter/material.dart';
import 'package:sonamak_flutter/core/uat/uat_banner.dart';

/// Backward-compat alias: some code calls UATBanner/UATGate with different casing.
class UATBanner extends UatBanner {
  const UATBanner({super.key});
}

class UATGate extends StatelessWidget {
  const UATGate({super.key});
  @override
  Widget build(BuildContext context) => const UATBanner();
}
