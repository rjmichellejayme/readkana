import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book.dart';
import '../models/reading_stats.dart';
import '../utils/preferences_utils.dart';
import '../utils/date_utils.dart' as custom_date_utils;
import 'database_service.dart';
import 'book_processor_service.dart';
import 'dart:io';

class ReadingService extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  Book? _currentBook;
  int _currentPage = 0;
  int _readingSpeed = 0; // pages per minute
  DateTime? _lastReadingSession;
  final List<Book> _recentBooks =
      []; // Add a private list to store recent books

  int _currentStreak = 0;
  int _longestStreak = 0;
  int _totalReadingDays = 0;
  int _totalPagesRead = 0;
  int _booksRead = 0;
  double _readingSpeedAverage = 0.0;
  double _fontSize = 16.0; // Default font size

  ReadingStats _stats = ReadingStats(
    dailyProgress: 0,
    dailyGoal: 10,
    currentStreak: 0,
    totalReadingDays: 0,
    totalPagesRead: 0,
    lastReadDate: DateTime.now(),
    unlockedAchievements: [],
  );

  int _dailyProgress = 0; // Tracks the number of pages read today
  int _dailyGoal = 30; // Default daily goal

  List<Book> _books = []; // Add a private list to store books

  Book? get currentBook => _currentBook;
  int get currentPage => _currentPage;
  int get readingSpeed => _readingSpeed;
  DateTime? get lastReadingSession => _lastReadingSession;
  List<Book> get recentBooks => _recentBooks; // Getter for recent books

  int get currentStreak => _currentStreak;
  int get longestStreak => _longestStreak;
  int get totalReadingDays => _totalReadingDays;
  int get totalPagesRead => _totalPagesRead;
  int get booksRead => _booksRead;
  double get readingSpeedAverage => _readingSpeedAverage;
  double get fontSize => _fontSize; // Getter for font size

  ReadingStats get stats => _stats;

  int get dailyProgress => _dailyProgress; // Getter for daily progress
  int get dailyGoal => _dailyGoal; // Getter for daily goal

  Future<void> startReading(Book book) async {
    _currentBook = book;
    _currentPage = book.currentPage;
    _lastReadingSession = DateTime.now();
    addRecentBook(book); // Add book to recent books
    notifyListeners();
  }

  Future<void> updateReadingProgress(int page) async {
    if (_currentBook == null) return;

    _currentPage = page;
    _currentBook = _currentBook!.copyWith(currentPage: page);

    // Calculate reading speed
    if (_lastReadingSession != null) {
      final duration = DateTime.now().difference(_lastReadingSession!);
      final pagesRead = page - _currentBook!.currentPage;
      if (duration.inMinutes > 0) {
        _readingSpeed = (pagesRead / duration.inMinutes).round();
      }
    }

    // Update book progress in database
    await _databaseService.updateBook(_currentBook!);

    // Update reading statistics
    await _updateReadingStatistics();

    notifyListeners();
  }

  Future<void> _updateReadingStatistics() async {
    final now = DateTime.now();
    final lastReadDate = await PreferencesUtils.getLastReadDate();

    // Update reading streak
    if (lastReadDate == null ||
        !custom_date_utils.DateUtils.isStreakActive(lastReadDate)) {
      await PreferencesUtils.setCurrentStreak(1);
      updateCurrentStreak(1);
    } else {
      final currentStreak = await PreferencesUtils.getCurrentStreak();
      await PreferencesUtils.setCurrentStreak(currentStreak + 1);
      updateCurrentStreak(currentStreak + 1);
    }

    // Update total reading days
    if (lastReadDate == null || !DateUtils.isSameDay(lastReadDate, now)) {
      final totalReadingDays =
          (await PreferencesUtils.getTotalReadingDays()) + 1;
      await PreferencesUtils.setTotalReadingDays(totalReadingDays);
      updateTotalReadingDays(totalReadingDays);
    }

    // Update total pages read
    final totalPagesRead =
        (await PreferencesUtils.getTotalPagesRead()) + _currentPage;
    await PreferencesUtils.setTotalPagesRead(totalPagesRead);
    updateTotalPagesRead(totalPagesRead);

    // Update reading speed average
    final readingSpeedAverage =
        (await PreferencesUtils.getReadingSpeedAverage() + _readingSpeed) / 2;
    await PreferencesUtils.setReadingSpeedAverage(readingSpeedAverage);
    updateReadingSpeed(readingSpeedAverage);

    await PreferencesUtils.setLastReadDate(now);
  }

  Future<void> pauseReading() async {
    if (_currentBook != null) {
      await _databaseService.updateBook(_currentBook!);
    }
    _lastReadingSession = null;
    notifyListeners();
  }

  Future<void> resumeReading() async {
    _lastReadingSession = DateTime.now();
    notifyListeners();
  }

  Future<void> finishReading() async {
    if (_currentBook != null) {
      await _databaseService.updateBook(_currentBook!);
    }
    _currentBook = null;
    _currentPage = 0;
    _lastReadingSession = null;
    updateBooksRead(_booksRead + 1);
    notifyListeners();
  }

  void addRecentBook(Book book) {
    if (!_recentBooks.contains(book)) {
      _recentBooks.add(book);
    }
  }

  void updateCurrentStreak(int streak) {
    _currentStreak = streak;
    if (_currentStreak > _longestStreak) {
      _longestStreak = _currentStreak;
    }
    notifyListeners();
  }

  void updateTotalReadingDays(int days) {
    _totalReadingDays = days;
    notifyListeners();
  }

  void updateTotalPagesRead(int pages) {
    _totalPagesRead = pages;
  }

  void updateReadingSpeed(double speed) {
    _readingSpeedAverage = speed;
  }

  void updateBooksRead(int books) {
    _booksRead = books;
    notifyListeners();
  }

  void updateDailyProgress(int pages) {
    _dailyProgress += pages;
    _stats = _stats.copyWith(
        dailyProgress: _stats.dailyProgress + pages,
        currentStreak: _stats.dailyProgress + pages >= _stats.dailyGoal
            ? _stats.currentStreak + 1
            : _stats.currentStreak);
    notifyListeners();
  }

  Future<void> updateDailyGoal(int goal) async {
    _dailyGoal = goal;
    notifyListeners();

    // Save the daily goal to shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('daily_goal', _dailyGoal);
  }

  Future<void> loadDailyStats() async {
    final prefs = await SharedPreferences.getInstance();
    _dailyGoal = prefs.getInt('daily_goal') ?? 30; // Default to 30 pages
    _dailyProgress = prefs.getInt('daily_progress') ?? 0; // Default to 0 pages
    notifyListeners();
  }

  Future<void> updateFontSize(double value) async {
    _fontSize = value;
    notifyListeners();

    // Save the font size to shared preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('font_size', _fontSize);
  }

  Future<void> loadFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    _fontSize = prefs.getDouble('font_size') ?? 16.0; // Default to 16.0
    notifyListeners();
  }

  Future<void> loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    _currentStreak = prefs.getInt('current_streak') ?? 0;
    _longestStreak = prefs.getInt('longest_streak') ?? 0;
    _totalReadingDays = prefs.getInt('total_reading_days') ?? 0;
    _booksRead = prefs.getInt('books_read') ?? 0;
    notifyListeners();
  }

  Future<void> saveStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('current_streak', _currentStreak);
    await prefs.setInt('longest_streak', _longestStreak);
    await prefs.setInt('total_reading_days', _totalReadingDays);
    await prefs.setInt('books_read', _booksRead);
  }

  Future<void> addBook(Book book) async {
    try {
      // Process the book file
      final processedData =
          await BookProcessorService.processBook(book.filePath);

      // Update book with processed data (excluding coverPath)
      final updatedBook = book.copyWith(
        title: processedData['title'],
        author: processedData['author'],
        totalPages: processedData['totalPages'],
        description: processedData['description'],
      );

      // Add to database
      final addedBook = await _databaseService.addBook(updatedBook);

      // Add to recent books
      _recentBooks.insert(0, addedBook);

      // Update current book if needed
      _currentBook ??= addedBook;

      notifyListeners();
    } catch (e) {
      throw BookProcessingException('Failed to add book: $e');
    }
  }

  Future<void> loadBooksFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final bookIds = prefs.getStringList('book_ids') ?? [];

    _books = [];
    for (String id in bookIds) {
      final title = prefs.getString('book_title_$id') ?? '';
      final path = prefs.getString('book_path_$id') ?? '';

      _books.add(Book(
        id: id,
        title: title,
        filePath: path,
        totalPages: 100,
        currentPage: 0,
        readingTime: 0,
        readingSpeed: 0.0,
      ));
    }
    notifyListeners();
  }

  Future<void> deleteBook(String bookId) async {
    try {
      // Get the book to delete
      final bookToDelete = _books.firstWhere((book) => book.id == bookId);

      // Remove the book from the list
      _books.removeWhere((book) => book.id == bookId);

      // Delete the file if it exists
      if (bookToDelete.filePath.isNotEmpty) {
        final file = File(bookToDelete.filePath);
        if (await file.exists()) {
          await file.delete();
        }
      }

      // Remove from SharedPreferences
      final prefs = await SharedPreferences.getInstance();

      // Remove book details
      await prefs.remove('book_title_$bookId');
      await prefs.remove('book_path_$bookId');
      await prefs.remove('book_currentPage_$bookId');
      await prefs.remove('book_readingTime_$bookId');

      // Update book IDs list
      List<String> bookIds = prefs.getStringList('book_ids') ?? [];
      bookIds.remove(bookId);
      await prefs.setStringList('book_ids', bookIds);

      // Also remove from recent books if present
      _recentBooks.removeWhere((book) => book.id == bookId);

      // If this was the current book, clear it
      if (_currentBook?.id == bookId) {
        _currentBook = null;
        _currentPage = 0;
        _lastReadingSession = null;
      }

      // Notify listeners to update UI
      notifyListeners();
    } catch (e) {
      print("Error deleting book: $e");
      throw Exception('Failed to delete book: $e');
    }
  }
}
