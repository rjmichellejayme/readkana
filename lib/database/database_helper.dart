import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/book.dart';
import '../models/bookmark.dart';
import '../models/annotation.dart';
import '../models/reading_progress.dart';
import '../models/achievement.dart';
import '../models/user_preferences.dart';
import 'migrations/migration_1.dart';
import 'migrations/migration_2.dart';
import 'migrations/migration_3.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('readkana.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await Migration1().upgrade(db);
    await Migration2().upgrade(db);
    await Migration3().upgrade(db);
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 1) await Migration1().upgrade(db);
    if (oldVersion < 2) await Migration2().upgrade(db);
    if (oldVersion < 3) await Migration3().upgrade(db);
  }

  // Book operations
  Future<int> insertBook(Book book) async {
    final db = await database;
    return await db.insert('books', book.toMap());
  }

  Future<List<Book>> getAllBooks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('books');
    return List.generate(maps.length, (i) => Book.fromMap(maps[i]));
  }

  Future<Book?> getBook(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Book.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateBook(Book book) async {
    final db = await database;
    return await db.update(
      'books',
      book.toMap(),
      where: 'id = ?',
      whereArgs: [book.id],
    );
  }

  Future<int> deleteBook(String id) async {
    final db = await database;
    return await db.delete(
      'books',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Bookmark operations
  Future<int> insertBookmark(Bookmark bookmark) async {
    final db = await database;
    return await db.insert('bookmarks', bookmark.toMap());
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

  Future<int> deleteBookmark(String id) async {
    final db = await database;
    return await db.delete(
      'bookmarks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Annotation operations
  Future<int> insertAnnotation(Annotation annotation) async {
    final db = await database;
    return await db.insert('annotations', annotation.toMap());
  }

  Future<List<Annotation>> getAnnotations(String bookId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'annotations',
      where: 'bookId = ?',
      whereArgs: [bookId],
    );
    return List.generate(maps.length, (i) => Annotation.fromMap(maps[i]));
  }

  Future<int> updateAnnotation(Annotation annotation) async {
    final db = await database;
    return await db.update(
      'annotations',
      annotation.toMap(),
      where: 'id = ?',
      whereArgs: [annotation.id],
    );
  }

  Future<int> deleteAnnotation(String id) async {
    final db = await database;
    return await db.delete(
      'annotations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Reading Progress operations
  Future<int> insertReadingProgress(ReadingProgress progress) async {
    final db = await database;
    return await db.insert('reading_progress', progress.toMap());
  }

  Future<ReadingProgress?> getReadingProgress(String bookId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'reading_progress',
      where: 'bookId = ?',
      whereArgs: [bookId],
    );
    if (maps.isNotEmpty) {
      return ReadingProgress.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateReadingProgress(ReadingProgress progress) async {
    final db = await database;
    return await db.update(
      'reading_progress',
      progress.toMap(),
      where: 'id = ?',
      whereArgs: [progress.id],
    );
  }

  // Achievement operations
  Future<int> insertAchievement(Achievement achievement) async {
    final db = await database;
    return await db.insert('achievements', achievement.toMap());
  }

  Future<List<Achievement>> getAllAchievements() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('achievements');
    return List.generate(maps.length, (i) => Achievement.fromMap(maps[i]));
  }

  Future<int> updateAchievement(Achievement achievement) async {
    final db = await database;
    return await db.update(
      'achievements',
      achievement.toMap(),
      where: 'id = ?',
      whereArgs: [achievement.id],
    );
  }

  // User Preferences operations
  Future<int> insertUserPreferences(UserPreferences preferences) async {
    final db = await database;
    return await db.insert('user_preferences', preferences.toMap());
  }

  Future<UserPreferences?> getUserPreferences() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('user_preferences');
    if (maps.isNotEmpty) {
      return UserPreferences.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateUserPreferences(UserPreferences preferences) async {
    final db = await database;
    return await db.update(
      'user_preferences',
      preferences.toMap(),
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}