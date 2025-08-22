import 'package:flutter/material.dart';
import 'package:sonamak_flutter/app/shell/landing_shell.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LandingShell(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Terms and conditions.'),
      ),
    );
  }
}
