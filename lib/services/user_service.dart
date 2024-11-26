import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';

import '../models/login_model.dart';
import '../models/register_model.dart';
import 'databse_service.dart';


class UserService {
  final String _baseUrl = 'http://192.168.100.8:3000/user';
  final LocalAuthentication _localAuth = LocalAuthentication(); 
  List<String> tokens = [];
  List<String> userRoles = [];
  List<String> numeroCedulas = [];
  List<String> nombres = [];
  List<String> apellidos = [];
  List<List<String>> biometriaList = [];
  

  //Iniciar sesión
  Future<Map<String, dynamic>> login(LoginModel loginData) async {
    final url = Uri.parse('$_baseUrl/login');
    final headers = {'Content-Type': 'application/json'};

    try {
      print('Enviando solicitud a: $url');
      print('Datos del login: ${loginData.toJson()}');

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(loginData.toJson()),
      );

      print('Estado de la respuesta: ${response.statusCode}');
      print('Cuerpo de la respuesta: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        final token = responseData['Authorization'] ?? '';
        final role = responseData['Rol'] ?? 'Desconocido';
        final numeroCedula = loginData.numeroCedula;
        final nombre = responseData['Nombre'] ?? 'Desconocido';
        final apellido = responseData['Apellido'] ?? 'Desconocido';

        await DatabaseAuth.saveUser (token, role, numeroCedula, nombre, apellido);
        print('Rol guardado en la base de datos: $role');

        print('Token guardado: $token');
        print('Rol del usuario: $role');
        print('Número de cédula guardado: $numeroCedula');
        print('Nombre y Apellido guardado: $nombre $apellido');

        return {
          'success': true,
          'data': responseData,
        };
      } else {
        return {
          'success': false,
          'message': 'Ocurrió un error al iniciar sesión',
        };
      }
    } catch (error) {
      print('Error al iniciar sesión: $error');
      return {
        'success': false,
        'message': 'Error de conexión: $error',
      };
    }
  }


  // Registro de usuario
  Future<Map<String, dynamic>> register(RegisterModel registerData) async {
    final url = Uri.parse('$_baseUrl/register');
    final headers = {'Content-Type': 'application/json'};

    try {
      print('Enviando solicitud a: $url');
      print('Datos del registro: ${registerData.toJson()}');

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(registerData.toJson()),
      );

      print('Estado de la respuesta: ${response.statusCode}');
      print('Cuerpo de la respuesta: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        return {
          'success': true,
          'data': responseData,
        };
      } else {
        return {
          'success': false,
          'message': 'Ocurrió un error al registrar el usuario',
        };
      }

    } catch (error) {
      return {
        'success': false,
        'message': 'Error de conexión: $error',
      };
    }
  }

  Future<void> authenticateFingerprint() async {
    try {
      bool isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Por favor, autentique con su huella digital.',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      if (isAuthenticated) {
        print("Autenticación por huella digital exitosa");
      } else {
        print("Autenticación fallida");
      }
    } catch (e) {
      print("Error en la autenticación: $e");
    }
  }
  

}
