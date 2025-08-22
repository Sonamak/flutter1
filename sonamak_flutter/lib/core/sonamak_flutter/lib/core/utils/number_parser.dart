library number_parser;

class NumberParser {
  static const Map<String, String> _digitMap = {
    '٠':'0','١':'1','٢':'2','٣':'3','٤':'4','٥':'5','٦':'6','٧':'7','٨':'8','٩':'9',
    '۰':'0','۱':'1','۲':'2','۳':'3','۴':'4','۵':'5','۶':'6','۷':'7','۸':'8','۹':'9',
  };
  static const String _arabicDecimal = '٫';
  static const List<String> _thousandCandidates = [',', '.', '٬', ' ', '\u00A0', '\u202F'];

  static String normalizeDigits(String input) {
    final sb = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      final ch = input[i];
      sb.write(_digitMap[ch] ?? (ch == '−' ? '-' : ch));
    }
    return sb.toString();
  }

  static String normalizeForInput(String raw) {
    var s = normalizeDigits(raw).replaceAll(_arabicDecimal, '.').replaceAll(',', '.');
    final sb = StringBuffer();
    bool seenDot = false;
    for (int i = 0; i < s.length; i++) {
      final ch = s[i];
      if (i == 0 && ch == '-') { sb.write(ch); continue; }
      if (RegExp(r'\d').hasMatch(ch)) { sb.write(ch); continue; }
      if (ch == '.' && !seenDot) { sb.write(ch); seenDot = true; }
    }
    return sb.toString();
  }

  static String? sanitizeAmountString(String raw) {
    if (raw.isEmpty) return null;
    var s = normalizeDigits(raw);
    // strip spaces/nbspaces
    s = s.replaceAll(RegExp(r'[\u00A0\u202F\s]'), '');
    // remember last decimal
    final lastDot = s.lastIndexOf('.');
    final lastComma = s.lastIndexOf(',');
    final lastArabic = s.lastIndexOf(_arabicDecimal);
    int last = [lastDot, lastComma, lastArabic].reduce((a,b)=>a>b?a:b);
    // remove thousands
    for (final t in _thousandCandidates) { s = s.replaceAll(t, ''); }
    // re-insert '.' if any
    if (last >= 0) {
      final rightDigits = _countTrailingDigits(normalizeDigits(raw), last);
      if (rightDigits > 0 && s.length > rightDigits) {
        final cut = s.length - rightDigits;
        s = s.substring(0, cut) + '.' + s.substring(cut);
      }
    }
    if (!RegExp(r'^-?\d+(\.\d+)?$').hasMatch(s)) return null;
    return s;
  }

  static double? tryParseAmount(String raw) {
    final s = sanitizeAmountString(raw);
    return s == null ? null : double.tryParse(s);
  }

  static String toServerString(num value, {int fractionDigits = 2}) =>
      value.toStringAsFixed(fractionDigits).replaceAll(',', '.');

  static int _countTrailingDigits(String original, int lastIdx) {
    int count = 0;
    for (int i = lastIdx + 1; i < original.length; i++) {
      if (RegExp(r'\d').hasMatch(original[i])) count++; else break;
    }
    return count;
  }
}
