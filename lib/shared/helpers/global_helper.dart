import 'dart:io';
import 'package:demo_urban/modules/404/pages/page_404.dart';
import 'package:demo_urban/shared/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/types/auth_messages_ios.dart';


class GlobalHelper {
static final _auth = LocalAuthentication();
  static navigateToPageRemove(BuildContext context, String routeName) {
    final route = AppRoutes.routes[routeName];
    final page = (route != null) ? route.call(context) : const PageNotFound();
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        fullscreenDialog: true,
        reverseTransitionDuration: const Duration(milliseconds: 100),
        transitionDuration: const Duration(milliseconds: 100),
        pageBuilder: (context, animation, _) => 
        FadeTransition(
          opacity: animation,
          child: page,
        ),
      ),
      (route) => false,
    );
  }

  static Route navigationFadeIn(BuildContext context, Widget page) {
    return PageRouteBuilder(
      fullscreenDialog: true,
      reverseTransitionDuration: const Duration(milliseconds: 100),
      transitionDuration: const Duration(milliseconds: 100),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: page,
        );
      },
    );
  }

  static GlobalKey genKey() {
    GlobalKey key = GlobalKey();
    return key;
  }

  static String device = (Platform.isAndroid) ? "android" : "ios";

  static dismissKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static String formatDate({ required String dateStr}){
    DateTime date = DateFormat('dd/MM/yyyy HH:mm').parse(dateStr);
    String formatDate = DateFormat('EEEE, dd \'de\' MMMM \'de\' yyyy HH:mm', "es").format(date);
    return formatDate[0].toUpperCase() + formatDate.substring(1).toLowerCase();
  }



  static Future<bool> isDeviceSupported({ required LocalAuthentication auth}) async {
    final isDeviceSupported = await auth.isDeviceSupported();
    return isDeviceSupported;
  }

  static Future<bool> hasBiometrics({ required LocalAuthentication auth}) async {
    final isAvailable = await auth.canCheckBiometrics;
    return isAvailable;
  }

  static Future<bool> autenticateBiometricUser() async {
    final deviceSupported = await GlobalHelper.isDeviceSupported(auth: _auth);
      if (deviceSupported) {
        final checkBiometri = await GlobalHelper.hasBiometrics(auth: _auth);
        if (checkBiometri) {
          final list = await _auth.getAvailableBiometrics();
          if (list.contains(BiometricType.strong) ||
              list.contains(BiometricType.face) ||
              list.contains(BiometricType.fingerprint)) {
            final authenticated = await _auth.authenticate(
                options: const AuthenticationOptions(useErrorDialogs: false),
                localizedReason:
                    'Toque con el dedo el sensor para iniciar sesión.',
                authMessages: const <AuthMessages>[
                  AndroidAuthMessages(
                    deviceCredentialsSetupDescription:
                        'Se requiere autenticación biométrica',
                    deviceCredentialsRequiredTitle:
                        'Se requiere autenticación biométrica',
                    //biometricSuccess: 'Autenticación exitosa',
                    biometricRequiredTitle:
                        'Se requiere autenticación biométrica',
                    biometricNotRecognized: 'No se reconoció la huella digital.',
                    biometricHint: '',
                    signInTitle: 'Se requiere autenticación biométrica',
                  ),
                  IOSAuthMessages(
                    cancelButton: 'No thanks',
                  ),
                ]);
            if (authenticated) {
              return true;
            }
          }
        } else {}
      } else {}
      return false;
    }
  }