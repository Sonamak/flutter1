import 'package:flutter/foundation.dart';
import 'package:sonamak_flutter/features/booking/data/booking_repository.dart';

class BookingState {
  final bool loading;
  final List<Speciality> specialities;
  final List<DoctorLite> doctors;
  final List<AppointmentSlot> slots;
  final Object? error;

  const BookingState({
    required this.loading,
    this.specialities = const [],
    this.doctors = const [],
    this.slots = const [],
    this.error,
  });

  BookingState copyWith({
    bool? loading,
    List<Speciality>? specialities,
    List<DoctorLite>? doctors,
    List<AppointmentSlot>? slots,
    Object? error,
  }) {
    return BookingState(
      loading: loading ?? this.loading,
      specialities: specialities ?? this.specialities,
      doctors: doctors ?? this.doctors,
      slots: slots ?? this.slots,
      error: error,
    );
  }

  factory BookingState.initial() => const BookingState(loading: false);
}

class BookingController extends ChangeNotifier {
  BookingController(this._repo);

  final BookingRepository _repo;
  BookingState _state = BookingState.initial();
  BookingState get state => _state;

  // selections
  int? selectedClinicId;
  int? selectedBranchId;
  int? selectedSpecialityId;
  int? selectedDoctorId;
  DateTime selectedDate = DateTime.now();

  Future<void> loadSpecialities(int clinicId) async {
    _state = _state.copyWith(loading: true, error: null);
    notifyListeners();
    try {
      selectedClinicId = clinicId;
      final specs = await _repo.fetchSpecialities(clinicId);
      _state = _state.copyWith(loading: false, specialities: specs);
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(loading: false, error: e);
      notifyListeners();
    }
  }

  Future<void> loadDoctorsAndSlots() async {
    if (selectedClinicId == null || selectedSpecialityId == null) return;
    _state = _state.copyWith(loading: true, error: null);
    notifyListeners();
    try {
      final raw = await _repo.fetchDoctorsRaw(
        dateNow: selectedDate.toIso8601String(),
        branchId: selectedBranchId,
        clinicId: selectedClinicId,
        specialityId: selectedSpecialityId,
        doctorId: selectedDoctorId,
      );

      final doctors = <DoctorLite>[];
      final slots = <AppointmentSlot>[];

      for (final d in raw) {
        if (d is Map<String, dynamic>) {
          if (d['id'] != null && d['name'] != null) {
            doctors.add(DoctorLite(id: int.tryParse('${d['id']}') ?? 0, name: '${d['name']}'));
          }
          final wh = (d['workingHours'] as List?) ?? const [];
          for (final item in wh) {
            if (item is Map<String, dynamic>) {
              final w = WorkingHour.fromJson(item);
              // Build slots using a 30-min duration (aligns the React selectDuration)
              final dayId = w.dayId == 7 ? 0 : w.dayId; // Sunday remap
              final target = _mapDayIdToDate(dayId, selectedDate);
              final fromParts = (w.from).split(':');
              final toParts = (w.to).split(':');
              if (fromParts.length >= 2 && toParts.length >= 2) {
                DateTime start = DateTime(target.year, target.month, target.day, int.parse(fromParts[0]), int.parse(fromParts[1]));
                DateTime end = DateTime(target.year, target.month, target.day, int.parse(toParts[0]), int.parse(toParts[1]));
                while (start.isBefore(end)) {
                  final next = start.add(const Duration(minutes: 30));
                  if (next.isAfter(end)) break;
                  slots.add(AppointmentSlot(start: start, end: next, doctorId: int.tryParse('${d['id']}') ?? 0));
                  start = next;
                }
              }
            }
          }
        }
      }

      _state = _state.copyWith(loading: false, doctors: doctors, slots: slots);
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(loading: false, error: e);
      notifyListeners();
    }
  }

  DateTime _mapDayIdToDate(int dayId, DateTime anchor) {
    final currentWeekday = anchor.weekday % 7; // Monday=1..Sunday=7 -> 0..6
    final targetWeekday = dayId % 7;
    final diff = (targetWeekday - currentWeekday);
    return anchor.add(Duration(days: diff));
  }
}