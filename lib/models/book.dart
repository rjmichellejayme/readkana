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
  final DateTime? lastReadDate; // Add this field
  final int readingTime; // in minutes
  final double readingSpeed; // pages per minute
  final List<String> tags;
  final bool isFavorite;
  final String format;
  final String? fileType; // Add this field
  final int? fileSize; // Add this field

  String? get coverImage => coverPath;
  final int totalPagesRead; // Add this field
  Book({
    required this.id,
    required this.title,
    this.author,
    this.description,
    this.coverPath,
    required this.filePath,
    required this.totalPages,
    required this.currentPage,
    this.lastReadDate, // Initialize this field
    required this.readingTime,
    required this.readingSpeed,
    this.tags = const [],
    this.isFavorite = false,
    this.format = 'epub',
    this.totalPagesRead = 0,
    this.fileType, // Add this field
    this.fileSize, // Add this field
  });

  factory Book.initial() {
    return Book(
      id: '',
      title: '',
      filePath: '',
      totalPages: 0,
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
      'lastReadDate': lastReadDate?.toIso8601String(), // Update field name
      'readingTime': readingTime, // Add this field
      'readingSpeed': readingSpeed, // Add this field
      'tags': tags,
      'isFavorite': isFavorite,
      'format': format,
      'totalPagesRead': totalPagesRead, // Add this field
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
      lastReadDate: map['lastReadDate'] != null // Update field name
          ? DateTime.parse(map['lastReadDate'])
          : null,
      readingTime: map['readingTime'] ?? 0, // Add this field
      readingSpeed: map['readingSpeed'] ?? 0.0, // Add this field
      tags: List<String>.from(map['tags'] ?? []),
      isFavorite: map['isFavorite'] ?? false,
      format: map['format'] ?? 'epub',
      totalPagesRead: map['totalPagesRead'] ?? 0, // Add this field
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
    DateTime? lastReadDate, // Update field name
    int? readingTime, // Add this field
    double? readingSpeed, // Add this field
    List<String>? tags,
    bool? isFavorite,
    String? format,
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
      lastReadDate: lastReadDate ?? this.lastReadDate, // Update field name
      readingTime: readingTime ?? this.readingTime, // Add this field
      readingSpeed: readingSpeed ?? this.readingSpeed, // Add this field
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
      format: format ?? this.format,
      fileType: fileType ?? this.fileType, // Add this field
      fileSize: fileSize ?? this.fileSize,
    );
  }

  double get progressPercentage {
    if (totalPages == 0) return 0.0; // Avoid division by zero
    return (currentPage / totalPages) * 100;
  }
}
