import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

import '../styles/theme.dart';


class BiometricHelper {
  final LocalAuthentication _localAuth = LocalAuthentication();
  String? _biometricToken;

  // Verificar si el dispositivo soporta la autenticación biométrica
  Future<bool> isBiometricAvailable() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print("Error verificando biometría: ${e.message}");
      return false;
    }
  }

  // Verificar qué tipo de biometría está disponible
  Future<bool> isFaceIdAvailable() async {
    try {
      final availableBiometrics = await _localAuth.getAvailableBiometrics();
      return availableBiometrics.contains(BiometricType.face);
    } on PlatformException catch (e) {
      print("Error verificando Face ID: ${e.message}");
      return false;
    }
  }

  // Método para generar y guardar el token biométrico
  Future<String?> authenticateWithBiometrics({String? reason}) async {
    try {
      bool canAuthenticate = await isBiometricAvailable();
      if (canAuthenticate) {
        bool isAuthenticated = await _localAuth.authenticate(
          localizedReason: reason ?? 'Por favor, autentíquese con su biometría para continuar.',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ),
        );

        if (isAuthenticated) {
          final biometricData = await _localAuth.getAvailableBiometrics();
          _biometricToken = _generateBiometricToken(biometricData);
          return _biometricToken;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } on PlatformException catch (e) {
      print("Error durante la autenticación: ${e.message}");
      return null;
    }
  }

  // Método para generar un hash del token biométrico
  String _generateBiometricToken(List<BiometricType> biometricData) {
    final biometricString = biometricData.map((type) => type.toString()).join(',');
    final bytes = utf8.encode(biometricString);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Obtener el token biométrico actual
  String? getBiometricToken() {
    return _biometricToken;
  }

  // Autenticación utilizando huella digital
  Future<String?> authenticateWithFingerprint() async {
    return await authenticateWithBiometrics(
      reason: 'Por favor, autentíquese con su huella digital para continuar.',
    );
  }

  // Autenticación utilizando Face ID
  Future<String?> authenticateWithFaceId(BuildContext context) async {
    if (await isFaceIdAvailable()) {
      return await authenticateWithBiometrics(
        reason: 'Por favor, autentíquese con su rostro para continuar.',
      );
    } else {
      showCenteredDialog(context, 'Face ID no disponible.', duration: const Duration(seconds: 2));
      return null;
    }
  }
}