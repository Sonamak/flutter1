import 'package:flutter/material.dart';
import 'package:sonamak_flutter/app/shell/landing_shell.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LandingShell(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Contact us'),
      ),
    );
  }
}
