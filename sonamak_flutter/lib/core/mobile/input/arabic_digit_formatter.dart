import 'package:flutter/services.dart';

/// Converts ASCII digits to Arabic-Indic on-the-fly for 'ar' UI when desired.
class ArabicIndicDigitInputFormatter extends TextInputFormatter {
  static const _arabic = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final s = newValue.text;
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      final code = s.codeUnitAt(i);
      if (code >= 48 && code <= 57) {
        buf.write(_arabic[code - 48]);
      } else {
        buf.write(String.fromCharCode(code));
      }
    }
    final out = buf.toString();
    return newValue.copyWith(text: out, selection: TextSelection.collapsed(offset: out.length));
  }
}
