import 'package:flutter/material.dart';
import '../models/book.dart';
import '../utils/file_utils.dart';
import '../utils/preferences_utils.dart';
import '../utils/date_utils.dart' as custom_date_utils;

class BookService extends ChangeNotifier {
  List<Book> _books = [];
  Book? _currentBook;
  int _currentPage = 0;
  int _dailyProgress = 0;

  List<Book> get books => _books;
  Book? get currentBook => _currentBook;
  int get currentPage => _currentPage;
  int get dailyProgress => _dailyProgress;

  Future<void> loadBooks() async {
    final bookFiles = await FileUtils.getBookFiles();
    final coverFiles = await FileUtils.getCoverFiles();

    _books = bookFiles.map((filePath) {
      final fileName = FileUtils.getFileNameWithoutExtension(filePath);
      final coverPath = coverFiles.firstWhere(
        (cover) => FileUtils.getFileNameWithoutExtension(cover) == fileName,
        orElse: () => '',
      );

      return Book(
        id: fileName,
        title: fileName,
        filePath: filePath,
        coverPath: coverPath, // Correct parameter name
        currentPage: 0, // Correct parameter name
        totalPages: 100, // This should be extracted from the book file
        readingTime: 0, // Provide a default value
        readingSpeed: 0, // Provide a default value
      );
    }).toList();

    notifyListeners();
  }

  Future<void> openBook(Book book) async {
    _currentBook = book;
    _currentPage = book.currentPage;
    notifyListeners();
  }

  Future<void> updateReadingProgress(int page) async {
    if (_currentBook == null) return;

    _currentPage = page;
    _currentBook = _currentBook!.copyWith(currentPage: page);

    // Update daily progress
    final dailyGoal = await PreferencesUtils.getDailyGoal();
    _dailyProgress = (_dailyProgress + 1).clamp(0, dailyGoal);

    // Update reading streak
    await _updateReadingStreak();

    notifyListeners();
  }

  Future<void> _updateReadingStreak() async {
    final lastReadDate = await PreferencesUtils.getLastReadDate();
    final now = DateTime.now();

    if (lastReadDate == null ||
        !custom_date_utils.DateUtils.isStreakActive(lastReadDate)) {
      await PreferencesUtils.setCurrentStreak(1);
    } else {
      final currentStreak = await PreferencesUtils.getCurrentStreak();
      await PreferencesUtils.setCurrentStreak(currentStreak + 1);
    }

    await PreferencesUtils.setLastReadDate(now);
    await PreferencesUtils.setTotalReadingDays(
      (await PreferencesUtils.getTotalReadingDays()) + 1,
    );
  }

  Future<void> addBookmark(int page, String? note) async {
    if (_currentBook == null) return;

    // Save bookmark to database
    // This should be implemented in DatabaseService
    notifyListeners();
  }

  Future<void> removeBookmark(String bookmarkId) async {
    // Remove bookmark from database
    // This should be implemented in DatabaseService
    notifyListeners();
  }

  Future<void> addHighlight(
      int startPage, int endPage, Color color, String? note) async {
    if (_currentBook == null) return;

    // Save highlight to database
    // This should be implemented in DatabaseService
    notifyListeners();
  }

  Future<void> removeHighlight(String highlightId) async {
    // Remove highlight from database
    // This should be implemented in DatabaseService
    notifyListeners();
  }
}
