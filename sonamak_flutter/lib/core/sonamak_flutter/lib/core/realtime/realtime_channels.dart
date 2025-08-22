/// Logical channel names used across the app.
class RealtimeChannels {
  static String calendarForClinic(int clinicId) => 'private-calendar-$clinicId';
  static String appointmentRequests(int clinicId) => 'private-requests-$clinicId';
  // Add others as needed...
}
