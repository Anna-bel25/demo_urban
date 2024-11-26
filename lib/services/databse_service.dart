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
    String path = join(await getDatabasesPath(), 'auth_data.db');
    return openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute(
        'CREATE TABLE auth (id INTEGER PRIMARY KEY AUTOINCREMENT, token TEXT, role TEXT, cedula TEXT, nombre TEXT, apellido TEXT)',
      );
    });
  }

  static Future<void> saveUser(String token, String role, String cedula, String nombre, String apellido) async {
    final db = await database;
    await db.delete('auth'); 
    await db.insert(
      'auth',
      {
        'token': token,
        'role': role,
        'cedula': cedula,
        'nombre': nombre,
        'apellido': apellido
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('Datos guardados en la base de datos - Rol: $role');
  }


  static Future<Map<String, String>?> getUser() async {
    final db = await database;
    final result = await db.query('auth', limit: 1);
    if (result.isNotEmpty) {
      print('Datos obtenidos de la base de datos: $result');
      return {
        'token': result.first['token'] as String? ?? '',
        'role': result.first['role'] as String? ?? '',
        'cedula': result.first['cedula'] as String? ?? '',
        'nombre': result.first['nombre'] as String? ?? '',
        'apellido': result.first['apellido'] as String? ?? '',
      };
    }
    return null;
  }

  static Future<bool> isLoggedIn() async {
    final user = await getUser();
    return user != null && user['token']?.isNotEmpty == true;
  }


  static Future<void> deleteUserDatabase() async {
    String path = join(await getDatabasesPath(), 'auth_data.db');
    await deleteDatabase(path);
    print('Base de datos eliminada.');
  }
}

