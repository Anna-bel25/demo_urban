import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class FaceIdHelper {
  final LocalAuthentication _localAuth = LocalAuthentication();

  // Verificar si el dispositivo soporta la autenticación biométrica - ios
  Future<bool> isBiometricAvailable() async {
    try {
      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      return availableBiometrics.contains(BiometricType.face);
    } on PlatformException catch (e) {
      print("Error verificando biometría: ${e.message}");
      return false;
    }
  }

  // Intentar autenticar usando Face ID
  Future<bool> authenticateWithFaceId() async {
    try {
      bool canAuthenticate = await isBiometricAvailable();
      if (canAuthenticate) {
        return await _localAuth.authenticate(
          localizedReason: 'Por favor, autentíquese con su rostro para continuar.',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );
      } else {
        print('Face ID no disponible');
        return false;
      }
    } on PlatformException catch (e) {
      print("Error durante la autenticación: ${e.message}");
      return false;
    }
  }
}
