import 'package:sqflite/sqflite.dart';

abstract class Migration {
  Future<void> upgrade(Database db);
  Future<void> downgrade(Database db);
} 