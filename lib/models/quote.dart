class Quote {
  final String id;
  final String text;
  final int page;
  final String? bookId;
  final String? bookTitle;

  Quote({
    required this.id,
    required this.text,
    required this.page,
    this.bookId,
    this.bookTitle,
  });

  Quote copyWith({
    String? id,
    String? text,
    int? page,
    String? bookId,
    String? bookTitle,
  }) {
    return Quote(
      id: id ?? this.id,
      text: text ?? this.text,
      page: page ?? this.page,
      bookId: bookId ?? this.bookId,
      bookTitle: bookTitle ?? this.bookTitle,
    );
  }
}
