// User settings and preferences

class UserPreferences {
  final bool isDarkMode;
  final double fontSize;
  final bool notificationsEnabled;
  final bool autoSyncEnabled;
  final bool soundEffectsEnabled;
  final String defaultReadingMode;
  final int dailyReadingGoal;
  final String libraryLayout;
  final bool showAuthor;
  final bool showProgress;
  final bool showLastRead;
  final String sortBy;
  final String language;
  final String themeColor;

  UserPreferences({
    this.isDarkMode = false,
    this.fontSize = 16.0,
    this.notificationsEnabled = true,
    this.autoSyncEnabled = true,
    this.soundEffectsEnabled = true,
    this.defaultReadingMode = 'scroll',
    this.dailyReadingGoal = 30,
    this.libraryLayout = 'grid',
    this.showAuthor = true,
    this.showProgress = true,
    this.showLastRead = true,
    this.sortBy = 'title',
    this.language = 'en',
    this.themeColor = '#2196F3',
  });

  factory UserPreferences.initial() {
    return UserPreferences();
  }

  Map<String, dynamic> toMap() {
    return {
      'isDarkMode': isDarkMode,
      'fontSize': fontSize,
      'notificationsEnabled': notificationsEnabled,
      'autoSyncEnabled': autoSyncEnabled,
      'soundEffectsEnabled': soundEffectsEnabled,
      'defaultReadingMode': defaultReadingMode,
      'dailyReadingGoal': dailyReadingGoal,
      'libraryLayout': libraryLayout,
      'showAuthor': showAuthor,
      'showProgress': showProgress,
      'showLastRead': showLastRead,
      'sortBy': sortBy,
      'language': language,
      'themeColor': themeColor,
    };
  }

  factory UserPreferences.fromMap(Map<String, dynamic> map) {
    return UserPreferences(
      isDarkMode: map['isDarkMode'] ?? false,
      fontSize: map['fontSize']?.toDouble() ?? 16.0,
      notificationsEnabled: map['notificationsEnabled'] ?? true,
      autoSyncEnabled: map['autoSyncEnabled'] ?? true,
      soundEffectsEnabled: map['soundEffectsEnabled'] ?? true,
      defaultReadingMode: map['defaultReadingMode'] ?? 'scroll',
      dailyReadingGoal: map['dailyReadingGoal'] ?? 30,
      libraryLayout: map['libraryLayout'] ?? 'grid',
      showAuthor: map['showAuthor'] ?? true,
      showProgress: map['showProgress'] ?? true,
      showLastRead: map['showLastRead'] ?? true,
      sortBy: map['sortBy'] ?? 'title',
      language: map['language'] ?? 'en',
      themeColor: map['themeColor'] ?? '#2196F3',
    );
  }

  UserPreferences copyWith({
    bool? isDarkMode,
    double? fontSize,
    bool? notificationsEnabled,
    bool? autoSyncEnabled,
    bool? soundEffectsEnabled,
    String? defaultReadingMode,
    int? dailyReadingGoal,
    String? libraryLayout,
    bool? showAuthor,
    bool? showProgress,
    bool? showLastRead,
    String? sortBy,
    String? language,
    String? themeColor,
  }) {
    return UserPreferences(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      fontSize: fontSize ?? this.fontSize,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      autoSyncEnabled: autoSyncEnabled ?? this.autoSyncEnabled,
      soundEffectsEnabled: soundEffectsEnabled ?? this.soundEffectsEnabled,
      defaultReadingMode: defaultReadingMode ?? this.defaultReadingMode,
      dailyReadingGoal: dailyReadingGoal ?? this.dailyReadingGoal,
      libraryLayout: libraryLayout ?? this.libraryLayout,
      showAuthor: showAuthor ?? this.showAuthor,
      showProgress: showProgress ?? this.showProgress,
      showLastRead: showLastRead ?? this.showLastRead,
      sortBy: sortBy ?? this.sortBy,
      language: language ?? this.language,
      themeColor: themeColor ?? this.themeColor,
    );
  }
}