import 'dart:convert';
import 'package:demo_urban/services/databse_service.dart';
import 'package:http/http.dart' as http;
import '../models/resident_model.dart';

class ResidentService {
  final String _baseUrl = 'http://192.168.100.8:3000/resident';


  // Crear registro de visita
  Future<Map<String, dynamic>> registerVisitor(CreateResidentModel visitData) async {
    final userData = await DatabaseAuth.getUser ();
    final cedulaResidente = userData?['cedula'] ?? '';
    final token = userData?['token'] ?? '';

    if (cedulaResidente.isEmpty || token.isEmpty) {
        throw Exception('Cédula o token no disponibles');
    }

    final url = Uri.parse('$_baseUrl/post?cedula=$cedulaResidente');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

  try {
    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(visitData.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      return {
        'success': true,
        'data': responseData,
      };
    } else {
      throw Exception('Error al registrar la visita. Código: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('Error de conexión: $error');
  }
}



  // Obtener registro de visita
  Future<List<CreateResidentModel>> getResidentRequests() async {
    final userData = await DatabaseAuth.getUser ();
    final cedulaResidente = userData?['cedula'] ?? '';
    final token = userData?['token'] ?? '';

    if (cedulaResidente.isEmpty || token.isEmpty) {
      return [];
      //throw Exception('Cédula o token no disponibles');
    }

    final url = Uri.parse('$_baseUrl/all?cedula=$cedulaResidente');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        
        if (jsonData is List) {
          return jsonData.map((visit) => CreateResidentModel.fromJson(visit)).toList();
        } else {
          return [];
        }
      } else {
        return [];
      }
    } catch (error) {
      print('Error al obtener registros de solicitudes de visita: $error');
      throw Exception('Hubo un error al obtener registros de las solicitudes de visita');
    }
  }


}