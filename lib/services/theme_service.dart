import 'package:flutter/material.dart';
import '../utils/preferences_utils.dart';

class ThemeService extends ChangeNotifier {
  bool _isDarkMode = false;
  double _fontSize = 16.0;

  bool get isDarkMode => _isDarkMode;
  double get fontSize => _fontSize;

  ThemeService() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    _isDarkMode = await PreferencesUtils.getIsDarkMode();
    _fontSize = await PreferencesUtils.getFontSize();
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await PreferencesUtils.setIsDarkMode(_isDarkMode);
    notifyListeners();
  }

  Future<void> updateFontSize(double size) async {
    _fontSize = size;
    await PreferencesUtils.setFontSize(size);
    notifyListeners();
  }

  ThemeData get themeData {
    return ThemeData(
      brightness: _isDarkMode ? Brightness.dark : Brightness.light,
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: _isDarkMode ? Brightness.dark : Brightness.light,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(fontSize: _fontSize),
        bodyMedium: TextStyle(fontSize: _fontSize),
        bodySmall: TextStyle(fontSize: _fontSize),
      ),
    );
  }
}
