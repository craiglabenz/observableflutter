import 'package:flutter/material.dart';
import 'package:signals/signals.dart';

class SettingsService {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  final themeMode = signal<ThemeMode>(ThemeMode.system);
  final textScale = signal<double>(1.0);

  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
  }

  void setTextScale(double scale) {
    textScale.value = scale.clamp(0.8, 2.0);
  }
}
