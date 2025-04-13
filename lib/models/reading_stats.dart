// Reading statistics model

class ReadingStats {
  int totalPagesRead;
  int currentStreak;
  int totalReadingDays;
  int dailyGoal;
  int dailyProgress;
  List<String> unlockedAchievements;
  DateTime lastReadDate;

  ReadingStats({
    required this.totalPagesRead,
    required this.currentStreak,
    required this.totalReadingDays,
    required this.dailyGoal,
    required this.dailyProgress,
    required this.unlockedAchievements,
    required this.lastReadDate,
  });

  factory ReadingStats.initial() {
    return ReadingStats(
      totalPagesRead: 0,
      currentStreak: 0,
      totalReadingDays: 0,
      dailyGoal: 30,
      dailyProgress: 0,
      unlockedAchievements: [],
      lastReadDate: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalPagesRead': totalPagesRead,
      'currentStreak': currentStreak,
      'totalReadingDays': totalReadingDays,
      'dailyGoal': dailyGoal,
      'dailyProgress': dailyProgress,
      'unlockedAchievements': unlockedAchievements,
      'lastReadDate': lastReadDate.toIso8601String(),
    };
  }

  factory ReadingStats.fromMap(Map<String, dynamic> map) {
    return ReadingStats(
      totalPagesRead: map['totalPagesRead'] ?? 0,
      currentStreak: map['currentStreak'] ?? 0,
      totalReadingDays: map['totalReadingDays'] ?? 0,
      dailyGoal: map['dailyGoal'] ?? 30,
      dailyProgress: map['dailyProgress'] ?? 0,
      unlockedAchievements:
          List<String>.from(map['unlockedAchievements'] ?? []),
      lastReadDate: DateTime.parse(
          map['lastReadDate'] ?? DateTime.now().toIso8601String()),
    );
  }

  ReadingStats copyWith({
    int? totalPagesRead,
    int? currentStreak,
    int? totalReadingDays,
    int? dailyGoal,
    int? dailyProgress,
    List<String>? unlockedAchievements,
    DateTime? lastReadDate,
  }) {
    return ReadingStats(
      totalPagesRead: totalPagesRead ?? this.totalPagesRead,
      currentStreak: currentStreak ?? this.currentStreak,
      totalReadingDays: totalReadingDays ?? this.totalReadingDays,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      dailyProgress: dailyProgress ?? this.dailyProgress,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
      lastReadDate: lastReadDate ?? this.lastReadDate,
    );
  }
}
