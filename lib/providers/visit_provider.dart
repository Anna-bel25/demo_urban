import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../helpers/database_helper.dart';
import '../models/urban_model.dart';
import '../styles/theme.dart';

class VisitProvider extends ChangeNotifier {
  GlobalKey<FormState> visitFormKey = GlobalKey<FormState>();

  String nombreVisitante = '';
  String apellidoVisitante = '';
  String numeroCedulaVisitante = '';
  String numeroCedulaResidente = '';
  String manzanaVilla = '';
  String fechaHoraVisita = '';

  String token = '';
  bool isLoading = false;

  String medioIngresoSeleccionado = 'Caminando';
  String selectedFilter = 'solicitudesVisita';
  String fotoPlacaRuta = '';

  File? fotoPlaca;

  Map<String, String> userData = {};
  List<SolicitudVisita> solicitudesVisita = [];
  List<RegistroVisita> registrosVisita = [];

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


  // Cargar los datos del usuario
  Future<void> loadUserData() async {
    userData = await DatabaseHelper.getUser () ?? {};
    print('Datos cargados: $userData');
    limpiarCampos();

    if (userData.isNotEmpty) {
      numeroCedulaVisitanteController.text = userData['numeroCedula'] ?? '';
      nombreVisitanteController.text = userData['nombre'] ?? '';
      apellidoVisitanteController.text = userData['apellido'] ?? '';
    }
    notifyListeners();
  }


  // Enviar la solicitud de visita al servidor
  Future<void> createSolicitudVisita(BuildContext context) async {
    final userData = await DatabaseHelper.getUser();
    final token = userData?['token'] ?? '';

    if (visitFormKey.currentState?.validate() ?? false) {
      if (token.isEmpty) {
        showCenteredDialog(context, "Token no encontrado.");
        return;
      }

      const String url = 'http://192.168.100.8:3000/visit/solicitudes';
      final request = http.MultipartRequest('POST', Uri.parse(url))
        ..headers['Authorization'] = 'Bearer $token';

      if (fotoPlaca != null) {
        final fotoPlacaFile = await http.MultipartFile.fromPath(
          'fotoPlaca',
          fotoPlaca!.path,
          contentType: MediaType('img', 'jpeg'),
        );
        request.files.add(fotoPlacaFile);
      }

      final solicitudDto = <String, String>{
        'nombreVisitante': nombreVisitanteController.text,
        'apellidoVisitante': apellidoVisitanteController.text,
        'numeroCedulaVisitante': numeroCedulaVisitanteController.text,
        'numeroCedulaResidente': numeroCedulaResidenteController.text,
        'manzanaVilla': manzanaVillaController.text,
        'fechaHoraVisita': fechaHoraVisitaController.text,
        'medioIngreso': medioIngresoSeleccionado,
        'fotoPlaca': fotoPlacaRuta.isNotEmpty ? fotoPlacaRuta : '',
      };
      request.fields.addAll(solicitudDto);

      try {
        final response = await request.send();
        final responseBody = await response.stream.bytesToString();

        print('Response Status Code: ${response.statusCode}');
        print('Response Body: $responseBody');

        if (response.statusCode == 200 || response.statusCode == 201) {
          await getSolicitudesYRegistros(context);
          limpiarCampos();
          notifyListeners();
          showCenteredDialog(context, "Solicitud creada exitosamente.");
          print("Solicitud creada exitosamente.");

        } else {
          final errorMessage = ErrorHandler.getErrorMessage(
            response.statusCode,
            customMessage: json.decode(responseBody)['message'],
          );
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
  Future<void> getSolicitudesYRegistros(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    final userData = await DatabaseHelper.getUser();
    final token = userData?['token'] ?? '';
    final numeroCedulaVisitante = userData?['numeroCedula'] ?? '';
    final String url = 'http://192.168.100.8:3000/visit/solicitudes-registros/$numeroCedulaVisitante';

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
        solicitudesVisita = (responseBody['solicitudesVisita'] as List)
            .map((data) => SolicitudVisita.fromJson(data))
            .toList();

        registrosVisita = (responseBody['registrosVisita'] as List)
            .map((data) => RegistroVisita.fromJson(data))
            .toList();

        notifyListeners();
        //showCenteredDialog(context, "Datos cargados exitosamente.");
        print("Solicitudes como Visitante: $solicitudesVisita");
        print("Registros de solicitudes por Residente: $registrosVisita");

      } else {
        final responseBody = json.decode(response.body);
        final errorMessage = ErrorHandler.getErrorMessage(response.statusCode, customMessage: responseBody['message']);

        showCenteredDialog(context, errorMessage);
        print("Error: $errorMessage");
        throw Exception("Error al obtener datos: ${response.body}");
      }
    } catch (e) {
      print("Error de conexión: $e");
      throw Exception("Error de conexión. Verifica tu conexión a internet.");
    }
    isLoading = false;
    notifyListeners();
  }


  // Actualizar una solicitud de visita
  Future<void> updateSolicitudVisita(BuildContext context, int id) async {
    final userData = await DatabaseHelper.getUser ();
    final token = userData?['token'] ?? '';
    String url = 'http://192.168.100.8:3000/visit/solicitudes/$id';
    final request = http.MultipartRequest('PATCH', Uri.parse(url))
      ..headers['Authorization'] = 'Bearer $token';
    print('Actualizando registro de visita con los siguientes datos:');
    print('fechaHoraVisita: $fechaHoraVisita');
    print('medioIngreso: $medioIngresoSeleccionado');

    // Solo agregar fechaHoraVisita si ha sido modificado
    if (fechaHoraVisita.isNotEmpty) {
      request.fields['fechaHoraVisita'] = fechaHoraVisita;
      print('Se ha asignado fechaHoraVisita a updateData: $fechaHoraVisita');
    }

    // Solo agregar medioIngreso si ha sido modificado
    if (medioIngresoSeleccionado.isNotEmpty) {
      request.fields['medioIngreso'] = medioIngresoSeleccionado;
      print('Se ha asignado medioIngreso a updateData: $medioIngresoSeleccionado');
    }
    if (medioIngresoSeleccionado == 'Vehiculo' && fotoPlaca != null) {
      final fotoPlacaFile = await http.MultipartFile.fromPath(
        'fotoPlaca',
        fotoPlaca!.path,
        contentType: MediaType('img', 'jpeg'),
      );
      request.files.add(fotoPlacaFile);
    }
    print('Campos a enviar: ${request.fields}');
    print('Archivos a enviar: ${request.files}');
    
    if (request.fields.isEmpty) {
      showCenteredDialog(context, "No se proporcionaron datos para actualizar.");
      return;
    }
    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        await getSolicitudesYRegistros(context);
        limpiarCampos();
        notifyListeners();
        showCenteredDialog(context, "Solicitud actualizada exitosamente.");
        print("Solicitud actualizada exitosamente.");

      } else {
        final errorMessage = ErrorHandler.getErrorMessage(
          response.statusCode,
          customMessage: json.decode(responseBody)['message'],
        );
        showCenteredDialog(context, errorMessage);
        print("Error: $errorMessage");
      }
    } catch (e) {
      print("Error de conexión: $e");
      showCenteredDialog(context, "Error de conexión. Verifica tu conexión a internet.");
    }
  }


  // Eliminar una solicitud de visita
  Future<void> deleteSolicitudVisita(BuildContext context, int id) async {
    final userData = await DatabaseHelper.getUser ();
    final token = userData?['token'] ?? '';
    String url = 'http://192.168.100.8:3000/visit/solicitudes/$id';
    
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        await getSolicitudesYRegistros(context);
        notifyListeners();
        showCenteredDialog(context, "Solicitud eliminada exitosamente.");
        print("Solicitud eliminada exitosamente.");

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




  // Future<void> setFotoPlaca(File imageFile) async {
  //   fotoPlaca = imageFile;
  //   notifyListeners();
  //   await _compressImage();
  // }

  // Método para comprimir la imagen
  Future<void> _compressImage() async {
    if (fotoPlaca != null && await fotoPlaca!.exists()) {
      try {
        final List<int>? compressedImage = await FlutterImageCompress.compressWithFile(
          fotoPlaca!.path,
          minWidth: 800,
          minHeight: 600,
          quality: 70,
          rotate: 0,
        );

        if (compressedImage != null) {
          final tempFile = File(fotoPlaca!.path)..writeAsBytesSync(compressedImage);
          fotoPlaca = tempFile;
          print('Tamaño de la imagen comprimida: ${compressedImage.length} bytes');
          notifyListeners();
        } else {
          print("Error al comprimir la imagen.");
        }
      } catch (e) {
        print("Error en la compresión de la imagen: $e");
      }
    } else {
      print("El archivo de imagen no existe, no se puede comprimir.");
    }
  }


  // Método para seleccionar la imagen de la placa
  void setFotoPlaca(File? imageFile) {
    fotoPlaca = imageFile;
    notifyListeners();
    if (imageFile != null) {
      _compressImage();
    }
  }

  // Seleccionar imagen de la placa del vehículo
  void setMedioIngresoSeleccionado(String value) {
    medioIngresoSeleccionado = value;
    if (value == 'Caminando') {
      fotoPlaca = null;
    }
    notifyListeners();
  }

  // Limpiar campos del formulario
  void limpiarCampos() {
    //nombreVisitanteController.clear();
    //apellidoVisitanteController.clear();
    //numeroCedulaVisitanteController.clear();
    numeroCedulaResidenteController.clear();
    manzanaVillaController.clear();
    fechaHoraVisitaController.clear();
    medioIngresoSeleccionado = 'Caminando';
    fotoPlacaRuta = '';
    fotoPlaca = null;

    visitFormKey = GlobalKey<FormState>();
    notifyListeners();
  }
}
