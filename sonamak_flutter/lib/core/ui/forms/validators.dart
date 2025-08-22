library validators;
import 'package:sonamak_flutter/core/utils/number_parser.dart';

typedef Validator = String? Function(String? value);

String? requiredField(String? v, {String message = 'This field is required'}) {
  if (v == null || v.trim().isEmpty) return message;
  return null;
}

String? minLength(String? v, int min, {String? message}) {
  if (v == null || v.length < min) return message ?? 'Minimum $min characters';
  return null;
}

String? phoneEgypt(String? v, {String? message}) {
  if (v == null || v.trim().isEmpty) return null;
  final digits = v.replaceAll(RegExp(r'[^0-9]'), '');
  if (!RegExp(r'^(010|011|012|015)\d{8}$').hasMatch(digits)) {
    return message ?? 'Invalid Egyptian phone';
  }
  return null;
}

String? amountValid(String? v, {bool allowNegative = false, int maxDecimals = 2, String? message}) {
  if (v == null || v.trim().isEmpty) return null;
  final s = NumberParser.sanitizeAmountString(v);
  if (s == null) return message ?? 'Invalid amount';
  if (!allowNegative && s.startsWith('-')) return 'Negative not allowed';
  final dot = s.indexOf('.');
  if (dot >= 0 && s.length - dot - 1 > maxDecimals) return 'Too many decimals';
  return null;
}
