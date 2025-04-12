class Note {
  final String id;
  final String title;
  final String content;
  final String? bookId;
  final String? bookTitle;

  Note({
    required this.id,
    required this.title,
    required this.content,
    this.bookId,
    this.bookTitle,
  });

  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? bookId,
    String? bookTitle,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      bookId: bookId ?? this.bookId,
      bookTitle: bookTitle ?? this.bookTitle,
    );
  }
}
