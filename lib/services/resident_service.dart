import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/resident_model.dart';
import 'user_sesion_service.dart';

class ResidentService {
  final String _baseUrl = 'http://192.168.100.8:3000/resident';


  // Crear registro de visita
  Future<Map<String, dynamic>> registerVisitor(CreateResidentModel visitData) async {
  final token = UserSessionService.getToken();
  if (token == null) {
    throw Exception('No se encontró el token');
  }

  final url = Uri.parse('$_baseUrl/visit');
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
  Future<List<CreateResidentModel>> getVisitRequests() async {
    final token = UserSessionService.getToken();
    if (token == null) {
      throw Exception('No se encontró el token');
    }

    final url = Uri.parse('$_baseUrl/visits');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        print('Respuesta de la API: $responseData');
        return responseData.map((item) => CreateResidentModel.fromJson(item)).toList();
      } else {
        throw Exception('Error al obtener solicitudes de visita');
      }
    } catch (error) {
      print('Error al obtener solicitudes de visita: $error');
      throw Exception('Hubo un error al obtener las solicitudes de visita');
    }
  }


}