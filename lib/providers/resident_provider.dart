import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../helpers/database_helper.dart';
import '../models/urban_model.dart';
import '../styles/theme.dart';


class ResidentProvider extends ChangeNotifier {
  GlobalKey<FormState> residentFormKey = GlobalKey<FormState>();

  String nombreVisitante = '';
  String apellidoVisitante = '';
  String numeroCedulaVisitante = '';
  String numeroCedulaResidente = '';
  String manzanaVilla = '';
  String fechaHoraVisita = '';

  String token = '';
  bool isLoading = false;

  String medioIngresoSeleccionado = 'Caminando';
  String selectedFilter = 'registrosComoResidente';

  Map<String, String> userData = {};
  List<dynamic> registrosComoResidente = [];
  List<dynamic> solicitudesHaciaResidente = [];

  TextEditingController nombreVisitanteController = TextEditingController();
  TextEditingController apellidoVisitanteController = TextEditingController();
  TextEditingController numeroCedulaVisitanteController = TextEditingController();
  TextEditingController numeroCedulaResidenteController = TextEditingController();
  TextEditingController manzanaVillaController = TextEditingController();
  TextEditingController fechaHoraVisitaController = TextEditingController();

  void setSelectedFilter(String value) {
    selectedFilter = value;
    notifyListeners();
  }

  
  Future<void> loadUserData() async {
    userData = await DatabaseHelper.getUser () ?? {};
    print('Datos cargados: ${userData['manzanaVilla']}');
    limpiarCampos();

    if (userData.isNotEmpty) {
      numeroCedulaResidenteController.text = userData['numeroCedula'] ?? '';
      manzanaVillaController.text = userData['manzanaVilla'] ?? '';
    }
    notifyListeners();
  }


  // Enviar la solicitud de visita al servidor
  Future<void> createRegistroVisita(BuildContext context) async {
    final userData = await DatabaseHelper.getUser();
    final token = userData?['token'] ?? '';
    final numeroCedulaResidente = userData?['numeroCedula'] ?? '';

    if (residentFormKey.currentState?.validate() ?? false) {
      final String url = 'http://192.168.100.8:3000/resident/registro-visita/$numeroCedulaResidente';
      
      try {
        final registroDto = {
          'nombreVisitante': nombreVisitanteController.text,
          'apellidoVisitante': apellidoVisitanteController.text,
          'numeroCedulaVisitante': numeroCedulaVisitanteController.text,
          'numeroCedulaResidente': numeroCedulaResidenteController.text,
          'manzanaVilla': manzanaVillaController.text,
          'fechaHoraVisita': fechaHoraVisitaController.text,
          'medioIngreso': medioIngresoSeleccionado,
        };

        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
          body: json.encode(registroDto),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          await getRegistrosYSolicitudes(context);
          limpiarCampos();
          notifyListeners();
          //residentFormKey.currentState?.validate();
          showCenteredDialog(context, "Solicitud creada exitosamente.");
          print("Solicitud creada exitosamente.");

        } else {
          final responseBody = json.decode(response.body);
          final errorMessage = ErrorHandler.getErrorMessage(response.statusCode, customMessage: responseBody['message']);
          showCenteredDialog(context, errorMessage);
          print("Error: $errorMessage");
        }
      } catch (e) {
        print("Error de conexión: $e");
        showCenteredDialog(context, "Error de conexión. Verifica tu conexión a internet.");
      }
    } else {
      showCenteredDialog(context, "Por favor, corrige los errores en el formulario.");
    }
  }
  

  // Obtener los registros y solicitudes de visita
  Future<void> getRegistrosYSolicitudes(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    final userData = await DatabaseHelper.getUser();
    final token = userData?['token'] ?? '';
    final numeroCedulaResidente = userData?['numeroCedula'] ?? '';
    final String url = 'http://192.168.100.8:3000/resident/solicitudes-visita/$numeroCedulaResidente';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = json.decode(response.body);
        registrosComoResidente = (responseBody['registrosComoResidente'] as List)
            .map((data) => RegistroVisita.fromJson(data))
            .toList();

        solicitudesHaciaResidente = (responseBody['solicitudesHaciaResidente'] as List)
            .map((data) => SolicitudVisita.fromJson(data))
            .toList();
        
        notifyListeners();
        //showCenteredDialog(context, "Datos cargados exitosamente.");
        print("Registros como Residente: $registrosComoResidente");
        print("Solicitudes hacia Residente: $solicitudesHaciaResidente");

      } else {
        final responseBody = json.decode(response.body);
        final errorMessage = ErrorHandler.getErrorMessage(response.statusCode, customMessage: responseBody['message']);
        
        showCenteredDialog(context, errorMessage);
        print("Error: $errorMessage");
        throw Exception("Error al obtener datos: ${response.body}");
      }
    } catch (e) {
      print("Error de conexión: $e");
      showCenteredDialog(context, "Error de conexión. Verifica tu conexión a internet.");
    }
    isLoading = false;
    notifyListeners();
  }


  // Aceptar o rechazar una solicitud de visita
  Future<void> approveRejectSolicitud(BuildContext context, int id, String estadoSolicitud) async {
    final userData = await DatabaseHelper.getUser();
    final token = userData?['token'] ?? '';
    final String url = 'http://192.168.100.8:3000/resident/solicitudes-visita/$id/approve-reject';
    final Map<String, dynamic> approvalData = {
      'estadoSolicitud': estadoSolicitud,
    };

    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(approvalData),
      );

      print("Código de estado: ${response.statusCode}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        await getRegistrosYSolicitudes(context);
        notifyListeners();
        showCenteredDialog(context, "Solicitud $estadoSolicitud exitosamente.");
        print("Solicitud $estadoSolicitud exitosamente.");

      } else {
        final responseBody = json.decode(response.body);
        final errorMessage = ErrorHandler.getErrorMessage(response.statusCode, customMessage: responseBody['message']);
        showCenteredDialog(context, errorMessage);
      }
    } catch (e) {
      print("Error de conexión: $e");
      showCenteredDialog(context, "Error de conexión. Verifica tu conexión a internet.");
    }
  }


  // Actualizar un registro de visita
  Future<void> updateRegistroVisita(BuildContext context, int id) async {
    final userData = await DatabaseHelper.getUser ();
    final token = userData?['token'] ?? '';
    final String url = 'http://192.168.100.8:3000/resident/registro-visita/$id';
    final Map<String, dynamic> updateData = {};

    print('Actualizando registro de visita con los siguientes datos:');
    print('fechaHoraVisita: $fechaHoraVisita');
    print('medioIngreso: $medioIngresoSeleccionado');
    
    if (fechaHoraVisita.isNotEmpty) {
      updateData['fechaHoraVisita'] = fechaHoraVisita;
      print('Se ha asignado fechaHoraVisita a updateData: $fechaHoraVisita');
    }

    if (medioIngresoSeleccionado.isNotEmpty) {
      updateData['medioIngreso'] = medioIngresoSeleccionado;
    }

    if (updateData.isEmpty) {
      showCenteredDialog(context, "No se proporcionaron datos para actualizar.");
      return;
    }

    try {
      print('Datos a enviar: $updateData'); 
      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(updateData),
      );

      print('Respuesta del servidor: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        await getRegistrosYSolicitudes(context);
        limpiarCampos(); 
        notifyListeners();
        showCenteredDialog(context, "Registro de visita actualizado exitosamente.");
        print("Registro de visita actualizado exitosamente.");

      } else {
        final responseBody = json.decode(response.body);
        final errorMessage = ErrorHandler.getErrorMessage(response.statusCode, customMessage: responseBody['message']);
        showCenteredDialog(context, errorMessage);
      }
    } catch (e) {
      print("Error de conexión: $e");
      showCenteredDialog(context, "Error de conexión. Verifica tu conexión a internet.");
    }
  }


  // Eliminar un registro de visita
  Future<void> deleteRegistroVisita(BuildContext context, int id) async {
    final userData = await DatabaseHelper.getUser();
    final token = userData?['token'] ?? '';
    final String url = 'http://192.168.100.8:3000/resident/registro-visita/$id';

    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await getRegistrosYSolicitudes(context);
        notifyListeners();
        showCenteredDialog(context, "Registro de visita eliminado exitosamente.");
        print("Registro de visita eliminado exitosamente.");

      } else {
        final responseBody = json.decode(response.body);
        final errorMessage = ErrorHandler.getErrorMessage(response.statusCode, customMessage: responseBody['message']);
        showCenteredDialog(context, errorMessage);
        print("Error: $errorMessage");
      }
    } catch (e) {
      print("Error de conexión: $e");
      showCenteredDialog(context, "Error de conexión. Verifica tu conexión a internet.");
    }
  }




  // Seleccionar imagen de la placa del vehículo
  void setMedioIngresoSeleccionado(String value) {
    medioIngresoSeleccionado = value;
    notifyListeners();
  }

  // Limpiar campos del formulario
  void limpiarCampos() {
    nombreVisitanteController.clear();
    apellidoVisitanteController.clear();
    numeroCedulaVisitanteController.clear();
    //numeroCedulaResidenteController.clear();
    //manzanaVillaController.clear();
    fechaHoraVisitaController.clear();
    medioIngresoSeleccionado = 'Caminando';

    residentFormKey = GlobalKey<FormState>();
    notifyListeners();
  }
}