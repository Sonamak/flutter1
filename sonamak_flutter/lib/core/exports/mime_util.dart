class MimeDisposition {
  final String? fileName;
  final String? contentType;
  const MimeDisposition({this.fileName, this.contentType});
}

/// Very small parser for Content-Disposition/Type.
class MimeUtil {
  static MimeDisposition parseHeaders(Map<String, List<String>> headers) {
    String? name;
    String? type;
    final ct = headers['content-type']?.first ?? headers['Content-Type']?.first;
    if (ct != null) type = ct.split(';').first.trim();
    final cd = headers['content-disposition']?.first ?? headers['Content-Disposition']?.first;
    if (cd != null) {
      final parts = cd.split(';');
      for (final p in parts) {
        final kv = p.trim().split('=');
        if (kv.length == 2 && kv[0].toLowerCase() == 'filename') {
          name = kv[1].trim().replaceAll('"', '');
        }
      }
    }
    return MimeDisposition(fileName: name, contentType: type);
  }
}
