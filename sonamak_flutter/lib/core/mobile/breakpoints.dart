/// Mobile/Tablet/Desktop breakpoints tailored for Sonamak.
class AppBreakpoints {
  // Based on common material adaptive sizes; can be adjusted if design requires.
  static const double mobile = 600;   // <600 => mobile
  static const double tablet = 900;   // 600-900 => small tablet; 900-1200 => large tablet
  static const double desktop = 1200; // >=1200 => desktop
}

extension MediaWidth on double {
  bool get isMobile => this < AppBreakpoints.mobile;
  bool get isTablet => this >= AppBreakpoints.mobile && this < AppBreakpoints.desktop;
  bool get isDesktop => this >= AppBreakpoints.desktop;
}
