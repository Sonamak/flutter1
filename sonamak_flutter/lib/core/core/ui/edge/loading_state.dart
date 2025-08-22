
import 'package:flutter/material.dart';

/// Standard loading state with progress semantics.
class LoadingState extends StatelessWidget {
  const LoadingState({super.key, this.label = 'Loading'});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      liveRegion: true,
      child: const Center(child: SizedBox(width: 32, height: 32, child: CircularProgressIndicator(strokeWidth: 3))),
    );
  }
}
