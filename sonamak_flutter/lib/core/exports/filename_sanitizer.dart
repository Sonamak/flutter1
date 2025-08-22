library filename_sanitizer;

/// Sanitize filenames across platforms (especially Windows).
/// - strips control chars
/// - replaces reserved characters <>:"/\|?* with '-'
/// - trims trailing dots/spaces
String sanitizeFileName(String suggested, {String fallback = 'export'}) {
  var s = suggested.trim();
  if (s.isEmpty) s = fallback;
  // Remove path separators and reserved chars
  const reserved = r'<>:"/\|?*';
  final buf = StringBuffer();
  for (final ch in s.runes) {
    final c = String.fromCharCode(ch);
    if (reserved.contains(c)) {
      buf.write('-');
    } else if (c.codeUnitAt(0) < 32) {
      // control char
      continue;
    } else {
      buf.write(c);
    }
  }
  var out = buf.toString();
  // Avoid illegal trailing characters on Windows
  while (out.endsWith(' ') || out.endsWith('.')) {
    out = out.substring(0, out.length - 1);
  }
  if (out.isEmpty) out = fallback;
  return out;
}
