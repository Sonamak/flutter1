/// Central registry of feature flag keys used across the app.
/// Keep keys stable — they may be persisted or referenced by CI.
class FF {
  // Major modules
  static const calendar      = 'feature.calendar';
  static const patients      = 'feature.patients';
  static const finance       = 'feature.finance';
  static const store         = 'feature.store';
  static const insurance     = 'feature.insurance';
  static const lab           = 'feature.lab';
  static const dashboard     = 'feature.dashboard';
  static const settings      = 'feature.settings';
  static const tumors        = 'feature.tumors';
  static const tumorsAdv     = 'feature.tumorsAdv';

  // Cross-cutting
  static const realtime      = 'feature.realtime';
  static const exports       = 'feature.exports';
  static const offline       = 'feature.offline';

  // Utilities
  static const developerMenu = 'feature.developerMenu';
}
