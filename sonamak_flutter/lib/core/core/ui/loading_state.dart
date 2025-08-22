import 'package:flutter/material.dart';
class LoadingState extends StatelessWidget {
  const LoadingState({super.key, this.message});
  final String? message;
  @override
  Widget build(BuildContext context) => Center(
    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const CircularProgressIndicator(),
      if (message != null) ...[const SizedBox(height: 8), Text(message!)],
    ]),
  );
}
