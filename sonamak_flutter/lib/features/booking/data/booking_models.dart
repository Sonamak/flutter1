class Speciality {
  final int id;
  final String name;
  const Speciality({required this.id, required this.name});

  factory Speciality.fromJson(Map<String, dynamic> json) {
    int toInt(v) => v is int ? v : int.tryParse('$v') ?? 0;
    return Speciality(
      id: toInt(json['id'] ?? json['value']),
      name: (json['name'] ?? json['label'] ?? '').toString(),
    );
  }
}

class WorkingHour {
  final String day;
  final String from;
  final String to;
  final int? _dayId;
  const WorkingHour({
    required this.day,
    required this.from,
    required this.to,
    int? dayId,
  }) : _dayId = dayId;

  /// Many controllers expect `dayId` 1..7 (Mon..Sun). We compute a sensible default.
  int get dayId {
    if (_dayId != null) return _dayId;
    final d = day.toLowerCase();
    const map = {
      'mon': 1, 'monday': 1,
      'tue': 2, 'tuesday': 2,
      'wed': 3, 'wednesday': 3,
      'thu': 4, 'thursday': 4,
      'fri': 5, 'friday': 5,
      'sat': 6, 'saturday': 6,
      'sun': 7, 'sunday': 7,
    };
    return map[d] ?? 1;
  }

  factory WorkingHour.fromJson(Map<String, dynamic> json) {
    int? toIntOrNull(v) => v == null ? null : (v is int ? v : int.tryParse('$v'));
    return WorkingHour(
      day: (json['day'] ?? json['weekday'] ?? '').toString(),
      from: (json['from'] ?? json['start'] ?? '').toString(),
      to: (json['to'] ?? json['end'] ?? '').toString(),
      dayId: toIntOrNull(json['day_id'] ?? json['dayId']),
    );
  }
}

/// Doctor with map-like access for legacy controllers that do `doctor['id']`.
class DoctorLite {
  final int id;
  final String name;
  final Map<String, dynamic> _raw;
  const DoctorLite({required this.id, required this.name, Map<String, dynamic> raw = const {}}) : _raw = raw;

  factory DoctorLite.fromJson(Map<String, dynamic> json) {
    int toInt(v) => v is int ? v : int.tryParse('$v') ?? 0;
    return DoctorLite(
      id: toInt(json['id'] ?? json['doctor_id'] ?? json['value']),
      name: (json['name'] ?? json['doctor'] ?? json['label'] ?? '').toString(),
      raw: json,
    );
  }

  dynamic operator [](String key) {
    if (key == 'id') return id;
    if (key == 'name') return name;
    return _raw[key];
  }
}

/// Appointment slot model used by booking controllers.
class AppointmentSlot {
  final int doctorId;
  final DateTime start;
  final DateTime end;
  final bool available;
  const AppointmentSlot({
    required this.doctorId,
    required this.start,
    required this.end,
    this.available = true,
  });

  AppointmentSlot copyWith({
    int? doctorId,
    DateTime? start,
    DateTime? end,
    bool? available,
  }) =>
      AppointmentSlot(
        doctorId: doctorId ?? this.doctorId,
        start: start ?? this.start,
        end: end ?? this.end,
        available: available ?? this.available,
      );

  factory AppointmentSlot.fromJson(Map<String, dynamic> json) {
    int toInt(v) => v is int ? v : int.tryParse('$v') ?? 0;
    DateTime toDt(v) => v is DateTime ? v : DateTime.tryParse('$v') ?? DateTime.now();
    return AppointmentSlot(
      doctorId: toInt(json['doctor_id'] ?? json['doctor'] ?? json['id']),
      start: toDt(json['start'] ?? json['from']),
      end: toDt(json['end'] ?? json['to']),
      available: json['available'] == true || json['status'] == 'available',
    );
  }
}
