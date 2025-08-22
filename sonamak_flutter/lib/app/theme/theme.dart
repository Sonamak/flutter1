
import 'package:flutter/material.dart';
import 'tokens.dart';

/// Light theme with explicit ThemeExtensions list (no null-aware spreads).
ThemeData buildLightTheme() {
  final colorScheme = ColorScheme.fromSeed(seedColor: AppTokens.seed);
  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: AppTokens.fontFamily,
    scaffoldBackgroundColor: Colors.white,
    // Keep extensions explicit; add more via copyWith if needed.
    extensions: const <ThemeExtension<dynamic>>[],
  );
}

/// Dark theme counterpart.
ThemeData buildDarkTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: AppTokens.seed,
    brightness: Brightness.dark,
  );
  return ThemeData(
    colorScheme: colorScheme,
    useMaterial3: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    fontFamily: AppTokens.fontFamily,
    extensions: const <ThemeExtension<dynamic>>[],
  );
}
