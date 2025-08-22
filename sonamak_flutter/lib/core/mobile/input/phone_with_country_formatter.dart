import 'package:flutter/services.dart';

class PhoneWithCountryFormatter extends TextInputFormatter {
  PhoneWithCountryFormatter({this.defaultCountryCode = '+20', this.grouping = const [3,3,4]});
  final String defaultCountryCode;
  final List<int> grouping;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var raw = newValue.text.replaceAll(RegExp(r'[^0-9+]'), '');
    if (!raw.startsWith('+')) {
      raw = '$defaultCountryCode$raw';
    }
    raw = '+' + raw.replaceAll('+', '');

    final buf = StringBuffer();
    buf.write('+');
    var j = 1;
    while (j < raw.length && j <= 4 && RegExp(r'[0-9]').hasMatch(raw[j])) { buf.write(raw[j]); j++; }
    if (j < raw.length) buf.write(' ');

    var gIndex = 0, countInGroup = 0;
    while (j < raw.length) {
      final ch = raw[j];
      if (!RegExp(r'[0-9]').hasMatch(ch)) { j++; continue; }
      buf.write(ch); j++; countInGroup++;
      final target = (gIndex < grouping.length) ? grouping[gIndex] : 4;
      if (countInGroup == target && j < raw.length) { buf.write(' '); gIndex++; countInGroup = 0; }
    }
    final out = buf.toString().trimRight();
    return newValue.copyWith(text: out, selection: TextSelection.collapsed(offset: out.length));
  }
}
