// Reading progress tracking

class ReadingProgress {
  final String id;
  final String bookId;
  final int currentPage;
  final int totalPages;
  final DateTime lastRead;
  final Duration readingTime;
  final int pagesReadToday;
  final bool isCompleted;

  ReadingProgress({
    required this.id,
    required this.bookId,
    required this.currentPage,
    required this.totalPages,
    required this.lastRead,
    required this.readingTime,
    this.pagesReadToday = 0,
    this.isCompleted = false,
  });

  factory ReadingProgress.initial() {
    return ReadingProgress(
      id: '',
      bookId: '',
      currentPage: 0,
      totalPages: 0,
      lastRead: DateTime.now(),
      readingTime: Duration.zero,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookId': bookId,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'lastRead': lastRead.toIso8601String(),
      'readingTime': readingTime.inSeconds,
      'pagesReadToday': pagesReadToday,
      'isCompleted': isCompleted,
    };
  }

  factory ReadingProgress.fromMap(Map<String, dynamic> map) {
    return ReadingProgress(
      id: map['id'] ?? '',
      bookId: map['bookId'] ?? '',
      currentPage: map['currentPage'] ?? 0,
      totalPages: map['totalPages'] ?? 0,
      lastRead:
          DateTime.parse(map['lastRead'] ?? DateTime.now().toIso8601String()),
      readingTime: Duration(seconds: map['readingTime'] ?? 0),
      pagesReadToday: map['pagesReadToday'] ?? 0,
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  ReadingProgress copyWith({
    String? id,
    String? bookId,
    int? currentPage,
    int? totalPages,
    DateTime? lastRead,
    Duration? readingTime,
    int? pagesReadToday,
    bool? isCompleted,
  }) {
    return ReadingProgress(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      lastRead: lastRead ?? this.lastRead,
      readingTime: readingTime ?? this.readingTime,
      pagesReadToday: pagesReadToday ?? this.pagesReadToday,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  double get progressPercentage {
    return totalPages > 0 ? (currentPage / totalPages) * 100 : 0;
  }

  int get remainingPages {
    return totalPages - currentPage;
  }

  Duration get averageReadingTimePerPage {
    return readingTime.inSeconds > 0 && currentPage > 0
        ? Duration(seconds: readingTime.inSeconds ~/ currentPage)
        : Duration.zero;
  }
}
