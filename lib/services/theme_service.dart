import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/preferences_utils.dart';

class ThemeService extends ChangeNotifier {
  static const String _themeNameKey = 'selectedTheme';
  static const String _themeColorKey = 'themeColor';

  static const Map<String, Color> themeColors = {
    'Default': Color(0xFFF3EFEA),
    'Sepia': Color(0xFFF9F1E6),
    'Dark': Color(0xFF303030),
    'Sky': Color(0xFFE6F4F9),
  };

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

  static Future<Color> getReaderBackgroundColor() async {
    final prefs = await SharedPreferences.getInstance();
    final themeName = prefs.getString(_themeNameKey) ?? 'Default';
    return themeColors[themeName] ?? themeColors['Default']!;
  }

  static Future<String> getCurrentThemeName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeNameKey) ?? 'Default';
  }
}
