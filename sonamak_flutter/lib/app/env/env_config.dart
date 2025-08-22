
import 'package:flutter/material.dart';

class EnvConfig {
  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'https://klinikkilici.com/api');
  static const String pusherKey = String.fromEnvironment('PUSHER_KEY', defaultValue: '');
  static const bool enableFeatureFlags = bool.fromEnvironment('FEATURE_FLAGS', defaultValue: true);

  static const Locale defaultLocale = Locale('en');
}
