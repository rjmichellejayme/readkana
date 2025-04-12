import 'package:shared_preferences/shared_preferences.dart';

class PreferencesUtils {
  static const String _themeKey = 'theme_mode';
  static const String _fontSizeKey = 'font_size';
  static const String _dailyGoalKey = 'daily_goal';
  static const String _streakKey = 'reading_streak';
  static const String _lastReadDateKey = 'last_read_date';
  static const String _totalReadingDaysKey = 'total_reading_days';
  static const String _booksReadKey = 'books_read';
  static const String _keyLibraryLayoutStyle = 'library_layout_style';
  static const String _keyShowAuthor = 'show_author';
  static const String _keyShowProgress = 'show_progress';
  static const String _keyShowLastRead = 'show_last_read';
  static const String _keyLibrarySortBy = 'library_sort_by';
  static const String _keyDarkMode = 'dark_mode';
  static const String _keyNotificationsEnabled = 'notifications_enabled';
  static const String _keyAutoSyncEnabled = 'auto_sync_enabled';
  static const String _keySoundEffectsEnabled = 'sound_effects_enabled';
  static const String _keyTotalPagesRead = 'total_pages_read';
  static const String _keyDailyProgress = 'daily_progress';
  static const String _keyUnlockedAchievements = 'unlocked_achievements';
  static const String _keyReadingSpeedAverage = 'reading_speed_average';
  static const String _keySoundVolume = 'sound_volume';
  static const String _keyCurrentSound = 'current_sound';

  static Future<SharedPreferences> get _prefs async {
    return await SharedPreferences.getInstance();
  }

  // Theme Preferences
  static Future<bool> getIsDarkMode() async {
    final prefs = await _prefs;
    return prefs.getBool(_themeKey) ?? false;
  }

  static Future<void> setIsDarkMode(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_themeKey, value);
  }

  // Reading Preferences
  static Future<double> getFontSize() async {
    final prefs = await _prefs;
    return prefs.getDouble(_fontSizeKey) ?? 16.0;
  }

  static Future<void> setFontSize(double value) async {
    final prefs = await _prefs;
    await prefs.setDouble(_fontSizeKey, value);
  }

  static Future<int> getDailyGoal() async {
    final prefs = await _prefs;
    return prefs.getInt(_dailyGoalKey) ?? 20;
  }

  static Future<void> setDailyGoal(int value) async {
    final prefs = await _prefs;
    await prefs.setInt(_dailyGoalKey, value);
  }

  // Reading Stats
  static Future<int> getCurrentStreak() async {
    final prefs = await _prefs;
    return prefs.getInt(_streakKey) ?? 0;
  }

  static Future<void> setCurrentStreak(int value) async {
    final prefs = await _prefs;
    await prefs.setInt(_streakKey, value);
  }

  static Future<DateTime?> getLastReadDate() async {
    final prefs = await _prefs;
    final dateString = prefs.getString(_lastReadDateKey);
    return dateString != null ? DateTime.parse(dateString) : null;
  }

  static Future<void> setLastReadDate(DateTime date) async {
    final prefs = await _prefs;
    await prefs.setString(_lastReadDateKey, date.toIso8601String());
  }

  static Future<int> getTotalReadingDays() async {
    final prefs = await _prefs;
    return prefs.getInt(_totalReadingDaysKey) ?? 0;
  }

  static Future<void> setTotalReadingDays(int value) async {
    final prefs = await _prefs;
    await prefs.setInt(_totalReadingDaysKey, value);
  }

  static Future<int> getBooksRead() async {
    final prefs = await _prefs;
    return prefs.getInt(_booksReadKey) ?? 0;
  }

  static Future<void> setBooksRead(int value) async {
    final prefs = await _prefs;
    await prefs.setInt(_booksReadKey, value);
  }

  // Library Preferences
  static Future<String> getLibraryLayoutStyle() async {
    final prefs = await _prefs;
    return prefs.getString(_keyLibraryLayoutStyle) ?? 'grid';
  }

  static Future<bool> getShowAuthor() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyShowAuthor) ?? true;
  }

  static Future<bool> getShowProgress() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyShowProgress) ?? true;
  }

  static Future<bool> getShowLastRead() async {
    final prefs = await _prefs;
    return prefs.getBool(_keyShowLastRead) ?? true;
  }

  static Future<int> getLibrarySortBy() async {
    final prefs = await _prefs;
    return prefs.getInt(_keyLibrarySortBy) ?? 0;
  }

  static Future<void> setLibraryLayoutStyle(String value) async {
    final prefs = await _prefs;
    await prefs.setString(_keyLibraryLayoutStyle, value);
  }

  static Future<void> setShowAuthor(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyShowAuthor, value);
  }

  static Future<void> setShowProgress(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyShowProgress, value);
  }

  static Future<void> setShowLastRead(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyShowLastRead, value);
  }

  static Future<void> setLibrarySortBy(int value) async {
    final prefs = await _prefs;
    await prefs.setInt(_keyLibrarySortBy, value);
  }

  // Clear all preferences
  static Future<void> clearAll() async {
    final prefs = await _prefs;
    await prefs.clear();
  }

  static Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyDarkMode) ?? false; // Default: false
  }

  static Future<bool> getNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyNotificationsEnabled) ?? true; // Default: true
  }

  static Future<bool> getAutoSyncEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyAutoSyncEnabled) ?? true; // Default: true
  }

  static Future<bool> getSoundEffectsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keySoundEffectsEnabled) ?? true; // Default: true
  }

  // Setters
  static Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDarkMode, value);
  }

  static Future<void> setNotificationsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotificationsEnabled, value);
  }

  static Future<void> setAutoSyncEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAutoSyncEnabled, value);
  }

  static Future<void> setSoundEffectsEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keySoundEffectsEnabled, value);
  }

  static Future<int> getTotalPagesRead() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyTotalPagesRead) ?? 0; // Default: 0
  }

  static Future<int> getDailyProgress() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyDailyProgress) ?? 0; // Default: 0
  }

  static Future<List<String>> getUnlockedAchievements() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyUnlockedAchievements) ??
        []; // Default: empty list
  }

  static Future<void> setTotalPagesRead(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyTotalPagesRead, value);
  }

  static Future<void> setDailyProgress(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyDailyProgress, value);
  }

  static Future<void> setUnlockedAchievements(List<String> achievements) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_keyUnlockedAchievements, achievements);
  }

  static Future<double> getReadingSpeedAverage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_keyReadingSpeedAverage) ?? 0.0; // Default: 0.0
  }

  static Future<void> setReadingSpeedAverage(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyReadingSpeedAverage, value);
  }

  static Future<double> getSoundVolume() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_keySoundVolume) ?? 0.5; // Default: 0.5
  }

  static Future<void> setSoundVolume(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keySoundVolume, value);
  }

  static Future<String?> getCurrentSound() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyCurrentSound); // Default: null
  }

  static Future<void> setCurrentSound(String? value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _keyCurrentSound, value ?? ''); // Default: empty string
  }
}
