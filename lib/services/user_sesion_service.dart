// import 'databse_service.dart';

// class UserSessionService {
//   static Future<void> checkUserSession() async {
//     final userData = await DatabaseAuth.getUser();
//     if (userData != null) {
//       final token = userData['token'];
//       final role = userData['role'];
//       final cedula = userData['cedula'];
//       final nombre = userData['nombre'];
//       final apellido = userData['apellido'];

//       print('Token: $token');
//       print('Rol: $role');
//       print('Cédula: $cedula');
//       print('Nombre: $nombre');
//       print('Apellido: $apellido');
//     } else {
//       print('No se encontró sesión de usuario.');
//     }
//   }

//   static Future<void> setSession(String token, String cedula, String role, String nombre, String apellido) async {
//     await DatabaseAuth.saveUser(token, role, cedula, nombre, apellido);
//     print('Sesión iniciada con token: $token');
//   }

//   static Future<String?> getToken() async {
//     final userData = await DatabaseAuth.getUser();
//     return userData?['token'];
//   }

//   static Future<void> clearSession() async {
//     final db = await DatabaseAuth.database;
//     await db.delete('user');
//     print('Sesión cerrada');
//   }
// }