import 'package:flutter/material.dart';
class SemanticButton extends StatelessWidget {
  const SemanticButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.semanticLabel,
    this.semanticHint,
  });
  final VoidCallback? onPressed;
  final Widget child;
  final String? semanticLabel;
  final String? semanticHint;
  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      hint: semanticHint,
      child: ElevatedButton(onPressed: onPressed, child: child),
    );
  }
}
