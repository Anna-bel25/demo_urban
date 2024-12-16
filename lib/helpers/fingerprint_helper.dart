import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class FingerprintHelper {
  final LocalAuthentication _localAuth = LocalAuthentication();

  // Verificar si el dispositivo soporta la autenticación biométrica
  Future<bool> isBiometricAvailable() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print("Error verificando biometría: ${e.message}");
      return false;
    }
  }

  // Intentar autenticar usando huella digital
  Future<bool> authenticateWithFingerprint() async {
    try {
      bool canAuthenticate = await isBiometricAvailable();
      if (canAuthenticate) {
        return await _localAuth.authenticate(
          localizedReason: 'Por favor, autentíquese con su huella digital para continuar.',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );
      } else {
        print('Biometría no disponible');
        return false;
      }
    } on PlatformException catch (e) {
      print("Error durante la autenticación: ${e.message}");
      return false;
    }
  }
}