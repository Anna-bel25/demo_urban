import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  // Obtener la base de datos
  static Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  // Inicializar la base de datos
  static Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'auth_data.db');
    return openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute(
        '''
          CREATE TABLE Usuario(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            token TEXT,
            nombre TEXT,
            apellido TEXT,
            rol TEXT,
            manzanaVilla TEXT,
            numeroCedula TEXT
          )
        '''
      );
    });
  }

  // Guardar los datos del usuario en la base de datos
  static Future<void> saveUser (String token, String nombre, String apellido, String rol, String manzanaVilla, String numeroCedula) async {
    try {
      final db = await database;
      if (db.isOpen) {
        await db.delete('Usuario');
        await db.insert(
          'Usuario',
          {
            'token': token,
            'nombre': nombre,
            'apellido': apellido,
            'rol': rol,
            'manzanaVilla': manzanaVilla,
            'numeroCedula': numeroCedula,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        print('Datos guardados en la base de datos - Token: $token, Nombre: $nombre, Apellido: $apellido, Rol: $rol, ManzanaVilla: $manzanaVilla, NumeroCedula: $numeroCedula');
      } else {
        print("La base de datos está cerrada antes de intentar guardar.");
      }
    } catch (e) {
      print("Error al guardar datos en la base de datos: $e");
    }
  }

  // Obtener los datos del usuario de la base de datos
  static Future<Map<String, String>?> getUser () async {
    final db = await database;
    final result = await db.query('Usuario', limit: 1);
    if (result.isNotEmpty) {
      print('Datos obtenidos de la base de datos: $result');
      return {
        'token': result.first['token'] as String? ?? '',
        'nombre': result.first['nombre'] as String? ?? '',
        'apellido': result.first['apellido'] as String? ?? '',
        'rol': result.first['rol'] as String? ?? '',
        'manzanaVilla': result.first['manzanaVilla'] as String? ?? '',
        'numeroCedula': result.first['numeroCedula'] as String? ?? '',
      };
    }
    return null;
  }

  // Verificar si el usuario está logueado
  static Future<bool> isLoggedIn() async {
    final user = await getUser();
    return user != null && user['token']?.isNotEmpty == true;
  }

  // Eliminar los datos del usuario de la base de datos
  static Future<void> deleteUserDatabase() async {
    String path = join(await getDatabasesPath(), 'auth_data.db');
    await deleteDatabase(path);
    print('Base de datos eliminada.');
  }
}

