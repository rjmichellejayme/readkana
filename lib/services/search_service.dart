import 'package:flutter/material.dart';
import '../models/book.dart';
import 'database_service.dart';

class SearchService extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  List<Book> _searchResults = [];
  String _lastQuery = '';
  bool _isSearching = false;

  List<Book> get searchResults => _searchResults;
  String get lastQuery => _lastQuery;
  bool get isSearching => _isSearching;

  Future<void> searchBooks(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      _lastQuery = '';
      notifyListeners();
      return;
    }

    _isSearching = true;
    _lastQuery = query;
    notifyListeners();

    try {
      final allBooks = await _databaseService.getBooks();
      _searchResults = allBooks.where((book) {
        final titleMatch =
            book.title.toLowerCase().contains(query.toLowerCase());
        final authorMatch =
            book.author?.toLowerCase().contains(query.toLowerCase()) ?? false;
        return titleMatch || authorMatch;
      }).toList();
    } catch (e) {
      _searchResults = [];
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  Future<List<Book>> searchByAuthor(String author) async {
    try {
      final allBooks = await _databaseService.getBooks();
      return allBooks
          .where((book) =>
              book.author?.toLowerCase().contains(author.toLowerCase()) ??
              false)
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Book>> searchByTitle(String title) async {
    try {
      final allBooks = await _databaseService.getBooks();
      return allBooks
          .where(
              (book) => book.title.toLowerCase().contains(title.toLowerCase()))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Book>> getRecentlyRead() async {
    try {
      final allBooks = await _databaseService.getBooks();
      allBooks.sort((a, b) {
        final aDate = a.lastReadDate ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bDate = b.lastReadDate ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bDate.compareTo(aDate);
      });
      return allBooks.take(5).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Book>> getMostRead() async {
    try {
      final allBooks = await _databaseService.getBooks();
      allBooks.sort((a, b) => b.totalPagesRead.compareTo(a.totalPagesRead));
      return allBooks.take(5).toList();
    } catch (e) {
      return [];
    }
  }

  void clearSearch() {
    _searchResults = [];
    _lastQuery = '';
    notifyListeners();
  }
}
