import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/visit_model.dart';
import 'databse_service.dart';

class VisitService {
  final String _baseUrl = 'http://192.168.100.8:3000/visit';


  // Crear solicitud de visita
  Future<Map<String, dynamic>> registerVisitor(CreateVisitModel visitData) async {
    final userData = await DatabaseAuth.getUser();
    final cedulaVisitante = userData?['cedula'] ?? '';
    final token = userData?['token'] ?? '';

    if (cedulaVisitante.isEmpty || token.isEmpty) {
      throw Exception('Cédula o token no disponibles');
    }

    final url = Uri.parse('$_baseUrl/post');
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




  // Obtener solicitudes de visita
  Future<List<CreateVisitModel>> getVisitRequests() async {
    final userData = await DatabaseAuth.getUser ();
    final cedulaVisitante = userData?['cedula'] ?? '';
    final token = userData?['token'] ?? '';

    if (cedulaVisitante.isEmpty || token.isEmpty) {
      return [];
    }

    final url = Uri.parse('$_baseUrl/all?cedula=$cedulaVisitante');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);

        return jsonData.map((visit) => CreateVisitModel.fromJson(visit)).toList();
            } else {
        return [];
      }
    } catch (error) {
      print('Error al obtener las solicitudes de visita: $error');
      return [];
    }
  }


}
