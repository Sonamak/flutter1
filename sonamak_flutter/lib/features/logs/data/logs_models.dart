
class LogRow {
  final int id;
  final String description;
  final String userName;
  final String time;
  final String action;

  const LogRow({required this.id, required this.description, required this.userName, required this.time, required this.action});

  factory LogRow.fromJson(Map<String, dynamic> json) {
    int toInt(v) => v is int ? v : int.tryParse('$v') ?? 0;
    return LogRow(
      id: toInt(json['id']),
      description: json['description']?.toString() ?? '',
      userName: json['user']?.toString() ?? json['userName']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      action: json['action']?.toString() ?? '',
    );
  }
}
