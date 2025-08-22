import 'package:flutter/services.dart';
import 'package:sonamak_flutter/core/utils/number_parser.dart';

/// Filters and normalizes amount input inline:
/// - Maps Arabic-Indic/Eastern Arabic digits to ASCII
/// - Converts ',' and '٫' to '.' as decimal
/// - Keeps a single leading '-' and a single '.'
class ArabicIndicAmountInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final normalized = NumberParser.normalizeForInput(newValue.text);
    // Heuristic caret adjustment: keep cursor near end
    final cursor = normalized.length.clamp(0, normalized.length);
    return TextEditingValue(
      text: normalized,
      selection: TextSelection.collapsed(offset: cursor),
      composing: TextRange.empty,
    );
  }
}
