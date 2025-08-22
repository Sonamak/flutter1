
import 'package:flutter/material.dart';
import 'package:sonamak_flutter/app/theme/tokens.dart';

class AppSnackbar {
  static void showInfo(BuildContext context, String message) {
    _show(context, message, background: AppTokens.seed);
  }

  static void showSuccess(BuildContext context, String message) {
    _show(context, message, background: AppTokens.success);
  }

  static void showWarning(BuildContext context, String message) {
    _show(context, message, background: AppTokens.warning, textColor: Colors.black87);
  }

  static void showError(BuildContext context, String message) {
    _show(context, message, background: AppTokens.danger);
  }

  static void _show(BuildContext context, String message,
      {Color? background, Color? textColor}) {
    final theme = Theme.of(context);
    final snack = SnackBar(
      content: Text(message, style: theme.textTheme.bodyMedium?.copyWith(color: textColor ?? Colors.white)),
      backgroundColor: background ?? theme.colorScheme.primary,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(borderRadius: AppTokens.radiusM),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }
}
