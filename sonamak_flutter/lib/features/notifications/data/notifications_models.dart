
class NotificationItem {
  final Map<String, dynamic> raw;
  const NotificationItem(this.raw);

  String get message => raw['message']?.toString() ?? '';
  String? get userName => raw['user_name']?.toString();
  String? get branchName => raw['branch_name']?.toString();
  String? get name => raw['name']?.toString();
  bool get read {
    final v = raw['read'];
    if (v is bool) return v;
    final s = v?.toString().toLowerCase();
    return s == 'true' || s == '1';
  }
  int? get calendarEventId {
    final id = raw['calendar_event_id'] ?? raw['event_id'] ?? raw['id'];
    if (id is int) return id;
    return int.tryParse('$id');
  }
}
