// Highlight and note model

class Annotation {
  final String id;
  final String bookId;
  final int pageNumber;
  final String content;
  final String? note;
  final DateTime createdAt;
  final DateTime? modifiedAt;
  final String color;
  final bool isHighlight;

  Annotation({
    required this.id,
    required this.bookId,
    required this.pageNumber,
    required this.content,
    this.note,
    required this.createdAt,
    this.modifiedAt,
    this.color = '#FFD700',
    this.isHighlight = true,
  });

  factory Annotation.initial() {
    return Annotation(
      id: '',
      bookId: '',
      pageNumber: 0,
      content: '',
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookId': bookId,
      'pageNumber': pageNumber,
      'content': content,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt?.toIso8601String(),
      'color': color,
      'isHighlight': isHighlight,
    };
  }

  factory Annotation.fromMap(Map<String, dynamic> map) {
    return Annotation(
      id: map['id'] ?? '',
      bookId: map['bookId'] ?? '',
      pageNumber: map['pageNumber'] ?? 0,
      content: map['content'] ?? '',
      note: map['note'],
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      modifiedAt: map['modifiedAt'] != null
          ? DateTime.parse(map['modifiedAt'])
          : null,
      color: map['color'] ?? '#FFD700',
      isHighlight: map['isHighlight'] ?? true,
    );
  }

  Annotation copyWith({
    String? id,
    String? bookId,
    int? pageNumber,
    String? content,
    String? note,
    DateTime? createdAt,
    DateTime? modifiedAt,
    String? color,
    bool? isHighlight,
  }) {
    return Annotation(
      id: id ?? this.id,
      bookId: bookId ?? this.bookId,
      pageNumber: pageNumber ?? this.pageNumber,
      content: content ?? this.content,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      color: color ?? this.color,
      isHighlight: isHighlight ?? this.isHighlight,
    );
  }
}