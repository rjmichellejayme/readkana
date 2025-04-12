import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/book.dart';
import '../models/bookmark.dart';
import '../models/highlight.dart';
import '../models/quote.dart';
import '../models/note.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'readkana.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE books(
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        author TEXT,
        coverPath TEXT,
        filePath TEXT NOT NULL,
        currentPage INTEGER DEFAULT 0,
        totalPages INTEGER DEFAULT 0,
        lastReadDate TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE bookmarks(
        id TEXT PRIMARY KEY,
        bookId TEXT NOT NULL,
        page INTEGER NOT NULL,
        note TEXT,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (bookId) REFERENCES books (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE highlights(
        id TEXT PRIMARY KEY,
        bookId TEXT NOT NULL,
        startPage INTEGER NOT NULL,
        endPage INTEGER NOT NULL,
        color INTEGER NOT NULL,
        note TEXT,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (bookId) REFERENCES books (id)
      )
    ''');
  }

  // Book operations
  Future<void> insertBook(Book book) async {
    final db = await database;
    await db.insert('books', book.toMap());
  }

  Future<List<Book>> getBooks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('books');
    return List.generate(maps.length, (i) => Book.fromMap(maps[i]));
  }

  Future<void> updateBook(Book book) async {
    final db = await database;
    await db.update(
      'books',
      book.toMap(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  Future<void> deleteBook(String bookId) async {
    final db = await database;
    await db.delete(
      'books',
      where: 'id = ?',
      whereArgs: [bookId],
    );
  }

  // Bookmark operations
  Future<void> insertBookmark(Bookmark bookmark) async {
    final db = await database;
    await db.insert('bookmarks', bookmark.toMap());
  }

  Future<List<Bookmark>> getBookmarks(String bookId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'bookmarks',
      where: 'bookId = ?',
      whereArgs: [bookId],
    );
    return List.generate(maps.length, (i) => Bookmark.fromMap(maps[i]));
  }

  Future<void> deleteBookmark(String bookmarkId) async {
    final db = await database;
    await db.delete(
      'bookmarks',
      where: 'id = ?',
      whereArgs: [bookmarkId],
    );
  }

  // Highlight operations
  Future<void> insertHighlight(Highlight highlight) async {
    final db = await database;
    await db.insert('highlights', highlight.toMap());
  }

  Future<List<Highlight>> getHighlights(String bookId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'highlights',
      where: 'bookId = ?',
      whereArgs: [bookId],
    );
    return List.generate(maps.length, (i) => Highlight.fromMap(maps[i]));
  }

  Future<void> deleteHighlight(String highlightId) async {
    final db = await database;
    await db.delete(
      'highlights',
      where: 'id = ?',
      whereArgs: [highlightId],
    );
  }

  // Quote operations
  Future<List<Quote>> getQuotes(String bookId) async {
    // Fetch quotes for a specific book from the database
    return [];
  }

  Future<List<Quote>> getAllQuotes() async {
    // Fetch all quotes from the database
    return [];
  }

  Future<void> insertQuote(Quote quote) async {
    // Insert a new quote into the database
  }

  Future<void> deleteQuote(String quoteId) async {
    // Delete a quote from the database
  }

  Future<void> updateQuote(Quote quote) async {
    // Update a quote in the database
  }

  // Note operations
  Future<List<Note>> getNotes(String bookId) async {
    // Fetch notes for a specific book from the database
    return [];
  }

  Future<List<Note>> getAllNotes() async {
    // Fetch all notes from the database
    return [];
  }

  Future<void> insertNote(Note note) async {
    // Insert a new note into the database
  }

  Future<void> deleteNote(String noteId) async {
    // Delete a note from the database
  }

  Future<void> updateNote(Note note) async {
    // Update a note in the database
  }
}
