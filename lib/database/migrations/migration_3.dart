import 'package:sqflite/sqflite.dart';
import 'migration_base.dart';

class Migration3 extends Migration {
  @override
  Future<void> upgrade(Database db) async {
    await db.execute('''
      CREATE TABLE user_preferences (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        isDarkMode INTEGER DEFAULT 0,
        fontSize REAL DEFAULT 16.0,
        notificationsEnabled INTEGER DEFAULT 1,
        autoSyncEnabled INTEGER DEFAULT 1,
        soundEffectsEnabled INTEGER DEFAULT 1,
        defaultReadingMode TEXT DEFAULT 'scroll',
        dailyReadingGoal INTEGER DEFAULT 30,
        libraryLayout TEXT DEFAULT 'grid',
        showAuthor INTEGER DEFAULT 1,
        showProgress INTEGER DEFAULT 1,
        showLastRead INTEGER DEFAULT 1,
        sortBy TEXT DEFAULT 'title',
        language TEXT DEFAULT 'en',
        themeColor TEXT DEFAULT '#2196F3'
      )
    ''');

    // Insert default preferences
    await db.insert('user_preferences', {
      'isDarkMode': 0,
      'fontSize': 16.0,
      'notificationsEnabled': 1,
      'autoSyncEnabled': 1,
      'soundEffectsEnabled': 1,
      'defaultReadingMode': 'scroll',
      'dailyReadingGoal': 30,
      'libraryLayout': 'grid',
      'showAuthor': 1,
      'showProgress': 1,
      'showLastRead': 1,
      'sortBy': 'title',
      'language': 'en',
      'themeColor': '#2196F3',
    });
  }

  @override
  Future<void> downgrade(Database db) async {
    await db.execute('DROP TABLE IF EXISTS user_preferences');
  }
} 