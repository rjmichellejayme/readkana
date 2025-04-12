class Chapter {
  final String title;
  final int startPage;
  final int endPage;

  Chapter({
    required this.title,
    required this.startPage,
    required this.endPage,
  });

  // Optional: Add a factory method to create a Chapter from a map
  factory Chapter.fromMap(Map<String, dynamic> map) {
    return Chapter(
      title: map['title'] ?? '',
      startPage: map['startPage'] ?? 0,
      endPage: map['endPage'] ?? 0,
    );
  }

  // Optional: Add a method to convert a Chapter to a map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'startPage': startPage,
      'endPage': endPage,
    };
  }
}
