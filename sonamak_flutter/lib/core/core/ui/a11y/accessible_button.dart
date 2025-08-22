
import 'package:flutter/material.dart';
import 'tooltip_prefs.dart';

/// A button that standardizes tooltip timings and semantics.
class AccessibleButton extends StatelessWidget {
  const AccessibleButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.icon,
    this.tooltip,
    this.style,
  });

  final VoidCallback? onPressed;
  final String label;
  final IconData? icon;
  final String? tooltip;
  final ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    final btn = icon == null
        ? ElevatedButton(onPressed: onPressed, style: style, child: Text(label))
        : ElevatedButton.icon(onPressed: onPressed, style: style, icon: Icon(icon), label: Text(label));
    if (tooltip == null) return btn;
    return TooltipPrefs.wrap(message: tooltip!, child: btn);
  }
}
