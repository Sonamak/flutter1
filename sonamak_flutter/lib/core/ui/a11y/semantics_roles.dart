
import 'package:flutter/material.dart';

/// Helpers to annotate common widgets with roles useful for screen readers.
class SemanticsRoles {
  static Widget button({required String label, required Widget child, VoidCallback? onTap}) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(onTap: onTap, child: child),
    );
  }

  static Widget dataRow({required int index, required int total, required Widget child, bool selected = false}) {
    return Semantics(
      label: 'Row ${index + 1} of $total',
      selected: selected,
      child: child,
    );
  }

  static Widget tableHeader({required Widget child}) {
    return Semantics(container: true, label: 'Table header', child: child);
  }
}
