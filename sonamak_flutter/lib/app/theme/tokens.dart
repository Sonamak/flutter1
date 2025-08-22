import 'package:flutter/material.dart';

/// Design tokens derived from the React `:root` variables in
/// `react/src/global.css` of klinikkilici.com-eslam-fix-merged-branches.
/// Only values that exist in that file are mapped here; nothing is invented.
class AppTokens {
  // === Brand / base colors (CSS: --color-*) ===
  static const Color white100 = Color(0xFFFFFFFF);
  static const Color gray100 = Color(0xFF808494); // --color-gray-100 / --color-lightslategray-100
  static const Color gray200 = Color(0xFF0B1126); // --color-gray-200
  static const Color darkBlue100 = Color(0xFF0052C4); // --color-darkblue-100
  static const Color darkBlue200 = Color(0xFF0052C4); // --color-darkblue-200 (same hex in CSS)
  static const Color darkTurquoise100 = Color(0xFF06D2DD); // --color-darkturquoise-100

  // Alpha variants coming from rgba() declarations in CSS
  static const Color lightSlateGrayA10 = Color(0x1A808494); // rgba(128,132,148,0.1)
  static const Color lightSlateGrayA25 = Color(0x40808494); // rgba(128,132,148,0.25)
  static const Color darkTurquoiseA10 = Color(0x1A06D2DD);  // rgba(6,210,221,0.1)

  static const Color ghostWhite100 = Color(0xFFF7F9FD); // --color-ghostwhite-100

  // === Semantic role seeds (for ColorScheme.fromSeed) ===
  /// Primary brand seed (kept from existing project).
  static const Color seed = Color(0xFF0066CC);

  /// Non-brand semantic helpers already present in project.
  static const Color danger = Color(0xFFDC3545);
  static const Color warning = Color(0xFFFFC107);
  static const Color success = Color(0xFF28A745);

  // === Spacing scale (CSS paddings & project scale) ===
  static const double spaceXS = 4;
  static const double spaceS  = 8;
  static const double spaceM  = 16;
  static const double spaceL  = 24;
  static const double spaceXL = 32;

  /// CSS `--padding-xs: 12px;`
  static const double padXS = 12;

  /// CSS `--padding-29xl: 48px;`
  static const double pad29XL = 48;

  // === Radii extracted from CSS (px)
  static const BorderRadius br5   = BorderRadius.all(Radius.circular(5));
  static const BorderRadius br10  = BorderRadius.all(Radius.circular(10));
  static const BorderRadius br15  = BorderRadius.all(Radius.circular(15));
  static const BorderRadius br25  = BorderRadius.all(Radius.circular(25));
  static const BorderRadius br30  = BorderRadius.all(Radius.circular(30));
  static const BorderRadius br50  = BorderRadius.all(Radius.circular(50));
  static const BorderRadius br70  = BorderRadius.all(Radius.circular(70));

  // Project legacy convenience radii (kept for compatibility).
  static final BorderRadius radiusM = BorderRadius.circular(12);
  static final BorderRadius radiusL = BorderRadius.circular(16);

  // === Typography ===
  /// Family from CSS `--font-inter: Inter;`
  static const String fontFamily = 'Inter';

  /// A small mapped subset of font-size tokens seen in CSS.
  /// We do NOT invent missing sizes; we only expose those present.
  static const double fs2XL  = 21; // --font-size-2xl
  static const double fs13XL = 32; // --font-size-13xl
  static const double fs29XL = 48; // --font-size-29xl
}

/// Theme extension to carry color roles that don't exist in Material ColorScheme.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color white100;
  final Color gray100;
  final Color gray200;
  final Color darkBlue100;
  final Color darkBlue200;
  final Color darkTurquoise100;
  final Color ghostWhite100;
  final Color lightSlateGrayA10;
  final Color lightSlateGrayA25;
  final Color darkTurquoiseA10;

  const AppColors({
    required this.white100,
    required this.gray100,
    required this.gray200,
    required this.darkBlue100,
    required this.darkBlue200,
    required this.darkTurquoise100,
    required this.ghostWhite100,
    required this.lightSlateGrayA10,
    required this.lightSlateGrayA25,
    required this.darkTurquoiseA10,
  });

  factory AppColors.light() => const AppColors(
    white100: AppTokens.white100,
    gray100: AppTokens.gray100,
    gray200: AppTokens.gray200,
    darkBlue100: AppTokens.darkBlue100,
    darkBlue200: AppTokens.darkBlue200,
    darkTurquoise100: AppTokens.darkTurquoise100,
    ghostWhite100: AppTokens.ghostWhite100,
    lightSlateGrayA10: AppTokens.lightSlateGrayA10,
    lightSlateGrayA25: AppTokens.lightSlateGrayA25,
    darkTurquoiseA10: AppTokens.darkTurquoiseA10,
  );

  @override
  AppColors copyWith({
    Color? white100,
    Color? gray100,
    Color? gray200,
    Color? darkBlue100,
    Color? darkBlue200,
    Color? darkTurquoise100,
    Color? ghostWhite100,
    Color? lightSlateGrayA10,
    Color? lightSlateGrayA25,
    Color? darkTurquoiseA10,
  }) {
    return AppColors(
      white100: white100 ?? this.white100,
      gray100: gray100 ?? this.gray100,
      gray200: gray200 ?? this.gray200,
      darkBlue100: darkBlue100 ?? this.darkBlue100,
      darkBlue200: darkBlue200 ?? this.darkBlue200,
      darkTurquoise100: darkTurquoise100 ?? this.darkTurquoise100,
      ghostWhite100: ghostWhite100 ?? this.ghostWhite100,
      lightSlateGrayA10: lightSlateGrayA10 ?? this.lightSlateGrayA10,
      lightSlateGrayA25: lightSlateGrayA25 ?? this.lightSlateGrayA25,
      darkTurquoiseA10: darkTurquoiseA10 ?? this.darkTurquoiseA10,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      white100: Color.lerp(white100, other.white100, t)!,
      gray100: Color.lerp(gray100, other.gray100, t)!,
      gray200: Color.lerp(gray200, other.gray200, t)!,
      darkBlue100: Color.lerp(darkBlue100, other.darkBlue100, t)!,
      darkBlue200: Color.lerp(darkBlue200, other.darkBlue200, t)!,
      darkTurquoise100: Color.lerp(darkTurquoise100, other.darkTurquoise100, t)!,
      ghostWhite100: Color.lerp(ghostWhite100, other.ghostWhite100, t)!,
      lightSlateGrayA10: Color.lerp(lightSlateGrayA10, other.lightSlateGrayA10, t)!,
      lightSlateGrayA25: Color.lerp(lightSlateGrayA25, other.lightSlateGrayA25, t)!,
      darkTurquoiseA10: Color.lerp(darkTurquoiseA10, other.darkTurquoiseA10, t)!,
    );
  }
}

/// Central TextTheme builder so the same metrics are used across light/dark.
TextTheme buildTextTheme(TextTheme base) {
  // Map a few CSS sizes onto Material roles to anchor typography parity.
  return base.copyWith(
    displayLarge: base.displayLarge?.copyWith(
      fontSize: AppTokens.fs29XL, // ~48px
      fontWeight: FontWeight.w700,
      height: 56/48, // keep explicit, avoids engine differences
    ),
    headlineMedium: base.headlineMedium?.copyWith(
      fontSize: AppTokens.fs13XL, // ~32px
      fontWeight: FontWeight.w700,
      height: 40/32,
    ),
    titleLarge: base.titleLarge?.copyWith(
      fontSize: AppTokens.fs2XL,  // ~21px
      fontWeight: FontWeight.w600,
      height: 28/21,
    ),
  );
}
