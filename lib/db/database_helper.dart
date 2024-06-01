// lib/db/database_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'memo_database.db');
    return await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE memos(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<int> insertMemo(Map<String, dynamic> memo) async {
    final db = await database;
    return await db.insert(
      'memos',
      memo,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getMemos() async {
    final db = await database;
    return await db.query('memos');
  }

  Future<void> updateMemo(Map<String, dynamic> memo) async {
    final db = await database;
    await db.update(
      'memos',
      memo,
      where: 'id = ?',
      whereArgs: [memo['id']],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteDatabase() async {
    String path = join(await getDatabasesPath(), 'memo_database.db');
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}
