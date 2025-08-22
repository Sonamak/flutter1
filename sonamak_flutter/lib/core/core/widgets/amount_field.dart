import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../input/arabic_indic_text_input_formatter.dart';
import '../utils/number_parser.dart';

typedef AmountChanged = void Function(double? amount, String raw);

/// A ready-to-use numeric TextFormField that accepts Arabic-Indic digits
/// and normalizes them to a server-safe '.' decimal representation.
class AmountField extends StatelessWidget {
  const AmountField({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.onChanged,
    this.initialValue,
    this.allowNegative = false,
    this.decimalPlaces = 2,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final AmountChanged? onChanged;
  final String? initialValue;
  final bool allowNegative;
  final int decimalPlaces;

  @override
  Widget build(BuildContext context) {
    final ctl = controller ?? TextEditingController(text: initialValue ?? '');
    return TextFormField(
      controller: ctl,
      keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
      inputFormatters: <TextInputFormatter>[ArabicIndicAmountInputFormatter()],
      decoration: InputDecoration(
        labelText: label ?? 'Amount',
        hintText: hintText ?? 'e.g. ١٢٣٫٤٥',
        border: const OutlineInputBorder(),
      ),
      onChanged: (raw) {
        final parsed = NumberParser.tryParseAmount(raw);
        onChanged?.call(parsed, raw);
      },
      validator: (raw) {
        if (raw == null || raw.trim().isEmpty) return null;
        final s = NumberParser.sanitizeAmountString(raw);
        if (s == null) return 'Invalid number';
        if (!allowNegative && s.startsWith('-')) return 'Negative not allowed';
        // Decimal places check
        final dot = s.indexOf('.');
        if (dot >= 0 && s.length - dot - 1 > decimalPlaces) {
          return 'Too many decimal places (max $decimalPlaces)';
        }
        return null;
      },
    );
  }
}
