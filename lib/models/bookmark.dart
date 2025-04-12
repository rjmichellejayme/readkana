// Bookmark model
class Bookmark {
  final String id;
  final String bookId;
  final int pageNumber;
  final String? title;
  final String? note;
  final DateTime createdAt;
  final DateTime? modifiedAt;
  final DateTime date;

  Bookmark({
    required this.id,
    required this.bookId,
    required this.pageNumber,
    this.title,
    this.note,
    required this.createdAt,
    this.modifiedAt,
    required this.date,
  });

  factory Bookmark.initial() {
    return Bookmark(
      id: '',
      bookId: '',
      pageNumber: 0,
      createdAt: DateTime.now(),
      date: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookId': bookId,
      'pageNumber': pageNumber,
      'title': title,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt?.toIso8601String(),
    };
  }

  factory Bookmark.fromMap(Map<String, dynamic> map) {
    return Bookmark(
      id: map['id'] ?? '',
      bookId: map['bookId'] ?? '',
      pageNumber: map['pageNumber'] ?? 0,
      title: map['title'],
      note: map['note'],
      date: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      createdAt: map['createdAt'] != null
          ? DateTime.parse(map['createdAt'])
          : DateTime.now(),
      modifiedAt:
          map['modifiedAt'] != null ? DateTime.parse(map['modifiedAt']) : null,
    );
  }

  Bookmark copyWith({
    String? id,
    String? bookId,
    int? pageNumber,
    String? title,
    String? note,
    DateTime? createdAt,
    DateTime? modifiedAt,
    DateTime? newDate, // Rename parameter to avoid conflict
  }) {
    return Bookmark(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      pageNumber: pageNumber ?? this.pageNumber,
      title: title ?? this.title,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      date: newDate ?? date, // Use renamed parameter
    );
  }
}
