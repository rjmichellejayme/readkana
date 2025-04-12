import 'package:sqflite/sqflite.dart';
import 'migration_base.dart';

class Migration1 extends Migration {
  @override
  Future<void> upgrade(Database db) async {
    await db.execute('''
      CREATE TABLE books (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        author TEXT,
        description TEXT,
        coverPath TEXT,
        filePath TEXT NOT NULL,
        totalPages INTEGER NOT NULL,
        currentPage INTEGER DEFAULT 0,
        lastRead TEXT,
        tags TEXT,
        isFavorite INTEGER DEFAULT 0,
        format TEXT DEFAULT 'epub'
      )
    ''');

    await db.execute('''
      CREATE TABLE bookmarks (
        id TEXT PRIMARY KEY,
        bookId TEXT NOT NULL,
        pageNumber INTEGER NOT NULL,
        title TEXT,
        note TEXT,
        createdAt TEXT NOT NULL,
        modifiedAt TEXT,
        FOREIGN KEY (bookId) REFERENCES books (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE annotations (
        id TEXT PRIMARY KEY,
        bookId TEXT NOT NULL,
        pageNumber INTEGER NOT NULL,
        content TEXT NOT NULL,
        note TEXT,
        createdAt TEXT NOT NULL,
        modifiedAt TEXT,
        color TEXT DEFAULT '#FFD700',
        isHighlight INTEGER DEFAULT 1,
        FOREIGN KEY (bookId) REFERENCES books (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE reading_progress (
        id TEXT PRIMARY KEY,
        bookId TEXT NOT NULL,
        currentPage INTEGER NOT NULL,
        totalPages INTEGER NOT NULL,
        lastRead TEXT NOT NULL,
        readingTime INTEGER NOT NULL,
        pagesReadToday INTEGER DEFAULT 0,
        isCompleted INTEGER DEFAULT 0,
        FOREIGN KEY (bookId) REFERENCES books (id) ON DELETE CASCADE
      )
    ''');
  }

  @override
  Future<void> downgrade(Database db) async {
    await db.execute('DROP TABLE IF EXISTS reading_progress');
    await db.execute('DROP TABLE IF EXISTS annotations');
    await db.execute('DROP TABLE IF EXISTS bookmarks');
    await db.execute('DROP TABLE IF EXISTS books');
  }
} 