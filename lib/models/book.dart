// Book data model

class Book {
  final String id;
  final String title;
  final String? author;
  final String? description;
  final String? coverPath;
  final String filePath;
  final int totalPages;
  final int currentPage;
  final DateTime? lastReadDate;
  final int readingTime;
  final double readingSpeed;
  final List<String> tags;
  final bool isFavorite;
  final String format;
  final String? fileType;
  final int? fileSize;
  final int totalPagesRead;

  String? get coverImage => coverPath;

  Book({
    required this.id,
    required this.title,
    this.author,
    this.description,
    this.coverPath,
    required this.filePath,
    required this.totalPages,
    required this.currentPage,
    this.lastReadDate,
    required this.readingTime,
    required this.readingSpeed,
    this.tags = const [],
    this.isFavorite = false,
    this.format = 'epub',
    this.totalPagesRead = 3,
    this.fileType,
    this.fileSize,
  });

  factory Book.initial() {
    return Book(
      id: '',
      title: '',
      filePath: '',
      totalPages: 3,
      currentPage: 0,
      readingTime: 0,
      readingSpeed: 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'coverPath': coverPath,
      'filePath': filePath,
      'totalPages': totalPages,
      'currentPage': currentPage,
      'lastReadDate': lastReadDate?.toIso8601String(),
      'readingTime': readingTime,
      'readingSpeed': readingSpeed,
      'tags': tags,
      'isFavorite': isFavorite,
      'format': format,
      'totalPagesRead': totalPagesRead,
      'fileType': fileType,
      'fileSize': fileSize,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      author: map['author'],
      description: map['description'],
      coverPath: map['coverPath'],
      filePath: map['filePath'] ?? '',
      totalPages: map['totalPages'] ?? 0,
      currentPage: map['currentPage'] ?? 0,
      lastReadDate: map['lastReadDate'] != null
          ? DateTime.parse(map['lastReadDate'])
          : null,
      readingTime: map['readingTime'] ?? 0,
      readingSpeed: map['readingSpeed'] ?? 0.0,
      tags: List<String>.from(map['tags'] ?? []),
      isFavorite: map['isFavorite'] ?? false,
      format: map['format'] ?? 'epub',
      totalPagesRead: map['totalPagesRead'] ?? 0,
      fileType: map['fileType'],
      fileSize: map['fileSize'],
    );
  }

  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? description,
    String? coverPath,
    String? filePath,
    int? totalPages,
    int? currentPage,
    DateTime? lastReadDate,
    int? readingTime,
    double? readingSpeed,
    List<String>? tags,
    bool? isFavorite,
    String? format,
    String? fileType,
    int? fileSize,
    int? totalPagesRead,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      description: description ?? this.description,
      coverPath: coverPath ?? this.coverPath,
      filePath: filePath ?? this.filePath,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      lastReadDate: lastReadDate ?? this.lastReadDate,
      readingTime: readingTime ?? this.readingTime,
      readingSpeed: readingSpeed ?? this.readingSpeed,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
      format: format ?? this.format,
      fileType: fileType ?? this.fileType,
      fileSize: fileSize ?? this.fileSize,
      totalPagesRead: totalPagesRead ?? this.totalPagesRead,
    );
  }

  double get progressPercentage {
    if (totalPages == 0) return 0.0;
    return (currentPage / totalPages) * 100;
  }
}
