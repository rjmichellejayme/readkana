import 'package:sqflite/sqflite.dart';
import 'migration_base.dart';

class Migration2 extends Migration {
  @override
  Future<void> upgrade(Database db) async {
    await db.execute('''
      CREATE TABLE achievements (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        icon TEXT NOT NULL,
        progress INTEGER NOT NULL,
        goal INTEGER NOT NULL,
        isUnlocked INTEGER DEFAULT 0,
        unlockedDate TEXT
      )
    ''');

    // Insert default achievements
    await db.insert('achievements', {
      'id': 'first_book',
      'title': 'First Book',
      'description': 'Read your first book',
      'icon': 'book',
      'progress': 0,
      'goal': 1,
    });

    await db.insert('achievements', {
      'id': 'book_worm',
      'title': 'Book Worm',
      'description': 'Read 10 books',
      'icon': 'book_open',
      'progress': 0,
      'goal': 10,
    });

    await db.insert('achievements', {
      'id': 'streak_7',
      'title': '7-Day Streak',
      'description': 'Read for 7 days in a row',
      'icon': 'local_fire_department',
      'progress': 0,
      'goal': 7,
    });
  }

  @override
  Future<void> downgrade(Database db) async {
    await db.execute('DROP TABLE IF EXISTS achievements');
  }
} 