import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseAuth {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_data.db');
    return openDatabase(path, version: 1, onCreate: (db, version) {
      return db.execute(
        'CREATE TABLE user (id INTEGER PRIMARY KEY, token TEXT, role TEXT)',
      );
    });
  }

  static Future<void> saveUser(String token, String role) async {
    final db = await database;
    await db.insert(
      'user',
      {'token': token, 'role': role},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<Map<String, String>?> getUser() async {
    final db = await database;
    final result = await db.query('user', limit: 1);
    if (result.isNotEmpty) {
      return {
        'token': result.first['token'] as String? ?? '',
        'role': result.first['role'] as String? ?? '',
      };
    }
    return null;
  }
}
