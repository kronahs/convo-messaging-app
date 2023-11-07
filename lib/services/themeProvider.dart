import 'package:flutter/material.dart';

enum ThemeModeOptions { System, Light, Dark }

class ThemeProvider extends ChangeNotifier {
  ThemeModeOptions _themeMode = ThemeModeOptions.System;

  ThemeModeOptions get themeMode => _themeMode;

  void setThemeMode(ThemeModeOptions mode) {
    _themeMode = mode;
    notifyListeners();
  }

  String getTheme() {
    if (themeMode == ThemeModeOptions.System) {
      return 'System';
    } else if (themeMode == ThemeModeOptions.Light) {
      return 'Light';
    } else {
      return 'Dark';
    }
  }
}
