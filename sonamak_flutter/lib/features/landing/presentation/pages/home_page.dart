import 'package:flutter/material.dart';
import 'package:sonamak_flutter/app/shell/landing_shell.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return LandingShell(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text('Welcome to Sonamak'),
              SizedBox(height: 12),
              Text('This is the home page.'),
            ],
          ),
        ),
      ),
    );
  }
}
