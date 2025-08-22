
import 'package:flutter/material.dart';

/// Helpers to create dialogs/drawers with consistent paddings, radius and max widths.
class ParityDialogs {
  static Future<T?> showParityDialog<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    String? title,
    List<Widget>? actions,
    EdgeInsets contentPadding = const EdgeInsets.all(16),
    double maxWidth = 720,
  }) {
    return showDialog<T>(
      context: context,
      builder: (ctx) {
        final dialog = AlertDialog(
          title: title == null ? null : Text(title),
          contentPadding: contentPadding,
          content: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: Builder(builder: builder),
          ),
          actions: actions,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        );
        return dialog;
      },
    );
  }

  static Future<T?> showParityDrawer<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    String? title,
    List<Widget>? actions,
    double width = 420,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        builder: (context, controller) => Padding(
          padding: const EdgeInsets.all(16),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null) ...[
                  Row(
                    children: [
                      Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium)),
                      IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
                    ],
                  ),
                  const Divider(),
                ],
                Expanded(child: Builder(builder: builder)),
                if (actions != null) ...[
                  const Divider(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Wrap(spacing: 8, children: actions),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
