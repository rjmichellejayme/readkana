//Achievement badge model

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final int progress;
  final int goal;
  final bool isUnlocked;
  final DateTime? unlockedDate;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.progress,
    required this.goal,
    this.isUnlocked = false,
    this.unlockedDate,
  });

  factory Achievement.initial() {
    return Achievement(
      id: '',
      title: '',
      description: '',
      icon: '',
      progress: 0,
      goal: 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'progress': progress,
      'goal': goal,
      'isUnlocked': isUnlocked,
      'unlockedDate': unlockedDate?.toIso8601String(),
    };
  }

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      icon: map['icon'] ?? '',
      progress: map['progress'] ?? 0,
      goal: map['goal'] ?? 0,
      isUnlocked: map['isUnlocked'] ?? false,
      unlockedDate: map['unlockedDate'] != null
          ? DateTime.parse(map['unlockedDate'])
          : null,
    );
  }

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    int? progress,
    int? goal,
    bool? isUnlocked,
    DateTime? unlockedDate,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      progress: progress ?? this.progress,
      goal: goal ?? this.goal,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedDate: unlockedDate ?? this.unlockedDate,
    );
  }
}