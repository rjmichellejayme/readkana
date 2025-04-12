import 'package:flutter/material.dart';
import '../utils/preferences_utils.dart';

class AchievementService extends ChangeNotifier {
  int _currentStreak = 0;
  int _totalReadingDays = 0;
  int _totalPagesRead = 0;
  int _dailyGoal = 30;
  int _dailyProgress = 0;

  final List<String> _unlockedAchievements = [];

  int get currentStreak => _currentStreak;
  int get totalReadingDays => _totalReadingDays;
  int get totalPagesRead => _totalPagesRead;
  int get dailyGoal => _dailyGoal;
  int get dailyProgress => _dailyProgress;
  List<String> get unlockedAchievements => _unlockedAchievements;

  AchievementService() {
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    _currentStreak = await PreferencesUtils.getCurrentStreak();
    _totalReadingDays = await PreferencesUtils.getTotalReadingDays();
    _totalPagesRead = await PreferencesUtils.getTotalPagesRead();
    _dailyGoal = await PreferencesUtils.getDailyGoal();
    _dailyProgress = await PreferencesUtils.getDailyProgress();
    notifyListeners();
  }

  Future<void> updateReadingProgress(int pagesRead) async {
    _totalPagesRead += pagesRead;
    _dailyProgress += pagesRead;

    await PreferencesUtils.setTotalPagesRead(_totalPagesRead);
    await PreferencesUtils.setDailyProgress(_dailyProgress);

    _checkAchievements();
    notifyListeners();
  }

  Future<void> _checkAchievements() async {
    // Check daily goal achievement
    if (_dailyProgress >= _dailyGoal) {
      await _unlockAchievement('daily_goal_completed');
    }

    // Check streak achievements
    if (_currentStreak >= 7) {
      await _unlockAchievement('weekly_streak');
    }
    if (_currentStreak >= 30) {
      await _unlockAchievement('monthly_streak');
    }

    // Check total reading achievements
    if (_totalPagesRead >= 1000) {
      await _unlockAchievement('thousand_pages');
    }
    if (_totalReadingDays >= 100) {
      await _unlockAchievement('hundred_days');
    }
  }

  Future<void> _unlockAchievement(String achievementId) async {
    if (!_unlockedAchievements.contains(achievementId)) {
      _unlockedAchievements.add(achievementId);
      final unlockedAchievementsFromPrefs =
          await PreferencesUtils.getUnlockedAchievements();
      if (!unlockedAchievementsFromPrefs.contains(achievementId)) {
        unlockedAchievementsFromPrefs.add(achievementId);
        await PreferencesUtils.setUnlockedAchievements(
            unlockedAchievementsFromPrefs);
        // Here you could trigger a notification or show a dialog
      }
    }
  }

  Future<void> updateDailyGoal(int newGoal) async {
    _dailyGoal = newGoal;
    await PreferencesUtils.setDailyGoal(newGoal);
    notifyListeners();
  }

  Future<void> resetDailyProgress() async {
    _dailyProgress = 0;
    await PreferencesUtils.setDailyProgress(0);
    notifyListeners();
  }

  void unlockAchievement(String id) {
    if (!_unlockedAchievements.contains(id)) {
      _unlockedAchievements.add(id);
    }
  }
}
