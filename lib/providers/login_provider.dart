import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../helpers/biometric_helper.dart';
import '../helpers/database_helper.dart';
import '../screens/favorite_page_screen.dart';
import '../screens/urban_resident/resident_register_screen.dart';
import '../screens/urban_resident/resident_view_screen.dart';
import '../screens/urban_visit/visit_register_screen.dart';
import '../screens/urban_visit/visit_view_screen.dart';
import '../styles/custom_bar.dart';
import '../styles/theme.dart';
import 'visit_provider.dart';


class LoginProvider extends ChangeNotifier {
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  String numeroCedula = '';
  String contrasena = '';
  String metodoAutenticacion = 'Tradicional';
  String userRole = '';
  String token = '';
  String nombre = '';
  String apellido = '';
  String manzanaVilla = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  TextEditingController numeroCedulaController = TextEditingController();
  TextEditingController contrasenaController = TextEditingController();

  final BiometricHelper biometricHelper = BiometricHelper();

  // Método para cargar los datos del usuario desde la base de datos
  Future<void> authenticateBiometrics(BuildContext context) async {
    String? biometriaToken;

    if (metodoAutenticacion == 'Face ID') {
      biometriaToken = await biometricHelper.authenticateWithFaceId(context);
    } else if (metodoAutenticacion == 'Huella Digital') {
      biometriaToken = await biometricHelper.authenticateWithFingerprint();
    }

    if (biometriaToken != null) {
      print("Autenticación biométrica exitosa.");
      _loginWithBiometrics(context, biometriaToken);
    } else {
      showCenteredDialog(context, "Error al autenticar.");
    }
  }

  // Enviar solicitud de inicio de sesión biométrico
  Future<void> _loginWithBiometrics(BuildContext context, String biometriaToken) async {
    try {
      _isLoading = true;
      notifyListeners();

      final body = json.encode({
        'biometria': biometriaToken,
        'metodoAutenticacion': 'Biometrica',
      });
      print("Datos para el login con biometría: $body");
      
      final response = await http.post(
        Uri.parse('http://192.168.100.8:3000/user/login'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      print("Respuesta del servidor (código de estado: ${response.statusCode}):");
      print("Cuerpo de la respuesta: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = json.decode(response.body);
        token = responseData['token'];
        nombre = responseData['nombre'];
        apellido = responseData['apellido'];
        userRole = responseData['rol'];
        manzanaVilla = responseData['manzanaVilla'] ?? '';
        numeroCedula = numeroCedulaController.text;
        numeroCedula = responseData['numeroCedula'];

        await DatabaseHelper.saveUser(token, nombre, apellido, userRole, manzanaVilla, numeroCedula);
        final visitProvider = Provider.of<VisitProvider>(context, listen: false);
        await visitProvider.loadUserData();

        showCenteredDialog(context, "Autenticación exitosa.");
        await Future.delayed(Duration(seconds: 2));
        limpiarCampos();
        notifyListeners();
        List<Widget> pages = getPagesForRole(userRole);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CustomBottomNavigationBar(
              userRole: userRole,
              userName: '$nombre $apellido',
              pages: pages,
            ),
          ),
        );

      } else if (response.statusCode == 403) {
        showCenteredDialog(context, "La sesión ha caducado. Debe iniciar sesión nuevamente.");
        limpiarCampos();
        notifyListeners();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ResidentRegisterScreen()),
        );
      } else {
        showCenteredDialog(context, "Error al autenticar al usuario.");
      }
    } catch (e) {
      print("Error al comunicarse con el servidor: $e");
      showCenteredDialog(context, "Error al comunicarse con el servidor.");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  // Enviar solicitud de inicio de sesión tradicional
  Future<void> loginUser (BuildContext context) async {
    if (loginFormKey.currentState?.validate() ?? false) {
      _isLoading = true;
      notifyListeners();

      final loginDto = {
        'numeroCedula': numeroCedulaController.text,
        'contrasena': contrasenaController.text,
        'metodoAutenticacion': metodoAutenticacion,
      };
      print("Enviando datos para login tradicional:");
      print(loginDto);

      try {
        final response = await http.post(
          Uri.parse('http://192.168.100.8:3000/user/login'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(loginDto),
        );
        print("Respuesta del servidor (código de estado: ${response.statusCode}):");
        print("Cuerpo de la respuesta: ${response.body}");

        if (response.statusCode == 200 || response.statusCode == 201) {
          final responseData = json.decode(response.body);
          token = responseData['token'];
          nombre = responseData['nombre'];
          apellido = responseData['apellido'];
          userRole = responseData['rol'];
          manzanaVilla = responseData['manzanaVilla'] ?? '';
          numeroCedula = numeroCedulaController.text;
          numeroCedula = responseData['numeroCedula']; 

          await DatabaseHelper.saveUser(token, nombre, apellido, userRole, manzanaVilla, numeroCedulaController.text);
          final visitProvider = Provider.of<VisitProvider>(context, listen: false);
          await visitProvider.loadUserData();

          showCenteredDialog(context, "Autenticación exitosa.");
          await Future.delayed(Duration(seconds: 2));
          limpiarCampos();
          notifyListeners();
          List<Widget> pages = getPagesForRole(userRole);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CustomBottomNavigationBar(
                userRole: userRole,
                userName: '$nombre $apellido',
                pages: pages,
              ),
            ),
          );
        } else if (response.statusCode == 403) {
          showCenteredDialog(context, "La sesión ha caducado. Debe iniciar sesión nuevamente.");
          limpiarCampos();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ResidentRegisterScreen()),
          );
        } else {
          showCenteredDialog(context, "Error al autenticar al usuario.");
        }
      } catch (e) {
        print("Error al comunicarse con el servidor: $e");
        showCenteredDialog(context, "Error al comunicarse con el servidor.");
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }



  // Obtener las páginas de acuerdo al rol del usuario
  List<Widget> getPagesForRole(String role) {
    switch (role) {
      case 'Residente':
        return [
          ResidentViewScreen(),
          ResidentRegisterScreen(),
          FavoritePage(),
        ];
      case 'Visitante':
        return [
          VisitViewScreen(),
          VisitRegisterScreen(),
          FavoritePage(),
        ];
      default:
        return [
          ResidentViewScreen(),
          ResidentRegisterScreen(),
          FavoritePage(),
        ];
    }
  }

  // Método para enviar el formulario de inicio de sesión
  void submitLoginForm(BuildContext context) {
    if (metodoAutenticacion == 'Tradicional') {
      loginUser(context);
    } else {
      authenticateBiometrics(context);
    }
  }

  // Método para cambiar el metodo de autenticación
  void setMetodoAutenticacion(String newMetodo) {
    metodoAutenticacion = newMetodo;
    notifyListeners();
  }

  // Limpiar los campos del formulario
  void limpiarCampos() {
    numeroCedulaController.clear();
    contrasenaController.clear();
    numeroCedula = '';
    contrasena = '';
    metodoAutenticacion = 'Tradicional';

    loginFormKey = GlobalKey<FormState>();
    notifyListeners();
  }
}
