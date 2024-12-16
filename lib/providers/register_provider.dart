import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../helpers/biometric_helper.dart';
import '../styles/theme.dart';

class RegisterProvider extends ChangeNotifier {
  GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  String nombre = '';
  String apellido = '';
  String numeroCedula = '';
  String rol = 'Visitante';
  String manzanaVilla = '';
  String contrasena = '';
  String confirmContrasena = '';
  String metodoAutenticacion = 'Tradicional';

  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidoController = TextEditingController();
  TextEditingController numeroCedulaController = TextEditingController();
  TextEditingController contrasenaController = TextEditingController();
  TextEditingController confirmContrasenaController = TextEditingController();
  TextEditingController manzanaVillaController = TextEditingController();

  final BiometricHelper biometricHelper = BiometricHelper();



  // Autenticar al usuario utilizando la biometría seleccionada
  Future<void> authenticateBiometrics(BuildContext context) async {
    if (metodoAutenticacion == 'Face ID') {
      String? biometriaToken = await biometricHelper.authenticateWithFaceId(context);
      if (biometriaToken != null) {
        showCenteredDialog(context, "Face ID registrado correctamente.");
      } else {
        showCenteredDialog(context, "Error al registrar Face ID.");
      }
    } else if (metodoAutenticacion == 'Huella Digital') {
      String? biometriaToken = await biometricHelper.authenticateWithFingerprint();
      if (biometriaToken != null) {
        showCenteredDialog(context, "Huella digital registrada correctamente.");
      } else {
        showCenteredDialog(context, "Error al registrar huella digital.");
      }
    }
  }


  // Registrar un nuevo usuario en la base de datos
  Future<void> registerUser(BuildContext context) async {
    if (registerFormKey.currentState?.validate() ?? false) {
      final createUserDto = {
        'nombre': nombreController.text,
        'apellido': apellidoController.text,
        'numeroCedula': numeroCedulaController.text,
        'rol': rol,
        'manzanaVilla': manzanaVillaController.text,
        'contrasena': '',
        'fotoPerfil': '',
        'biometria': '',
      };

      // Registrar biometría solo si el token ha sido generado
      if (metodoAutenticacion == 'Face ID' && biometricHelper.getBiometricToken() != null) {
        createUserDto['biometria'] = biometricHelper.getBiometricToken()!;
        print("Token Face ID generado: ${biometricHelper.getBiometricToken()}");
      } else if (metodoAutenticacion == 'Huella Digital' && biometricHelper.getBiometricToken() != null) {
        createUserDto['biometria'] = biometricHelper.getBiometricToken()!;
        print("Token Huella Digital generado: ${biometricHelper.getBiometricToken()}");
      } else if (metodoAutenticacion == 'Tradicional' && contrasenaController.text.isNotEmpty) {
        createUserDto['contrasena'] = contrasenaController.text;
      } else {
        showCenteredDialog(context, "Faltan datos para completar el registro.");
        return;
      }

      print("Datos enviados para el registro:");
      print(json.encode(createUserDto));

      try {
        final response = await http.post(
          Uri.parse('http://192.168.100.8:3000/user/register'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(createUserDto),
        );

        print("Respuesta del servidor (código de estado: ${response.statusCode}):");
        print("Cuerpo de la respuesta: ${response.body}");

        if (response.statusCode == 201) {
          showCenteredDialog(context, "Cuenta creada exitosamente!");
          limpiarCampos();
        } else if (response.statusCode == 409) {
          showCenteredDialog(context, "El número de cédula ya está registrado.");
        } else {
          showCenteredDialog(context, "Error al crear la cuenta.");
        }
      } catch (e) {
        showCenteredDialog(context, "Error al comunicarse con el servidor.");
      }
    } else {
      showCenteredDialog(context, "Por favor, corrige los errores en el formulario.");
    }
  }


  // Mensaje emergente
  void submitRegisterForm(BuildContext context) {
    registerUser (context);
  }

  // Métodos para actualizar el rol
  void setRol(String newRol) {
    rol = newRol;
    notifyListeners();
  }

  // Métodos para actualizar el método de autenticación
  void setMetodoAutenticacion(String newMetodo) {
    metodoAutenticacion = newMetodo;
    notifyListeners();
  }

  // Limpiar los campos del formulario
  void limpiarCampos() {
    nombreController.clear();
    apellidoController.clear();
    numeroCedulaController.clear();
    contrasenaController.clear();
    confirmContrasenaController.clear();
    manzanaVillaController.clear();
    nombre = '';
    apellido = '';
    numeroCedula = '';
    rol = 'Visitante';
    manzanaVilla = '';
    contrasena = '';
    confirmContrasena = '';
    metodoAutenticacion = 'Tradicional';

    registerFormKey = GlobalKey<FormState>();
    notifyListeners();
  }
}
