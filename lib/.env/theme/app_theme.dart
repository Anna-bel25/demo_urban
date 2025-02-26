import 'package:flutter/material.dart';

class AppTheme {
  // Colores sólidos
  static const Color transparent = Color(0x00000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFFDFDFDF);
  static const Color lightGrey = Color(0xFFF6F6F6);
  static const Color darkGrey = Color(0xFF5B5B5B);
  static const Color error = Color(0xFFF94838);
  static const Color success = Color(0xFF7FCC5B);
  static const Color informative = Color(0xFFFFBE0B);
  static const Color green = Color(0xFF00CC55);
  static const Color hinText = Color(0xff5B5B5B);
  static const Color title = Color(0xFF43B1E);


  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 225, 10, 81),
      Color.fromARGB(255, 88, 17, 12),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [
      Color.fromARGB(255, 60, 5, 22),
      Color.fromARGB(255, 0, 0, 0),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const RadialGradient approvedGradient = RadialGradient(
    colors: [
      Color.fromARGB(255, 225, 10, 82),
      Color.fromARGB(255, 88, 17, 12),
    ],
    center: Alignment.center,
    radius: 2,
    focal: Alignment.center,
    focalRadius: 0.1,
  );

  static const RadialGradient enteredGradient = RadialGradient(
    colors: [
      Color.fromARGB(154, 225, 10, 82),
      Color.fromARGB(210, 146, 33, 61),
    ],
    center: Alignment.center,
    radius: 2,
    focal: Alignment.center,
    focalRadius: 0.1,
  );

  static const RadialGradient rejectedGradient = RadialGradient(
    colors: [
      Color.fromARGB(255, 60, 5, 22),
      Color.fromARGB(255, 0, 0, 0),
    ],
    center: Alignment.center,
    radius: 2,
    focal: Alignment.center,
    focalRadius: 0.1,
  );

  // Colores para textos y fondos
  static const Color textColor = white;
  static const Color backgroundColor = transparent;
  static const Color disabledTextColor = Color(0xFFBDBDBD);
  static const Color disabledBackgroundColor = Color(0xFFE0E0E0);

  // Bordes
  static const BorderSide whiteBorder = BorderSide(color: white, width: 1);


  // Iconos - Imágenes  
  String logoImagePathLight = "assets/logos/logo-light.svg";
  String logoNameImagePath = "assets/logos/logo-name.svg";
  static const String iconHistoryClinicPath = "assets/icon_cards/icon_historia_clinica.svg";
  static const String iconExamsPath = "assets/icon_cards/icon_examenes.svg";
  static const String iconDoctorPath = "assets/icon_cards/icon_doctor.svg";
  static const String iconPdfPath = "assets/pdf.svg";
  static const String icon404Path = "assets/404.svg";
  static const String iconErrorPath = "assets/error.svg";
  static const String iconCheckPath = "assets/check.svg";
  static const String iconCautionPath = "assets/caution.svg";

  static final String imglogin = "https://images.unsplash.com/photo-1662129266558-d47562f75c1d?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";
  static final String imgfavorite = "https://images.unsplash.com/photo-1631485221350-42316f117124?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D";


  ThemeData theme() {
    return ThemeData(
      textSelectionTheme: const TextSelectionThemeData(
        selectionHandleColor: white,
        cursorColor: white,
      ),
      fontFamily: 'Roboto',
      useMaterial3: true,
    );
  }

  
  // Métodos para obtener gradientes dinámicos
  static RadialGradient getStatusGradient(String status) {
    switch (status) {
      case 'Aprobada':
        return approvedGradient;
      case 'Ingresada':
        return enteredGradient;
      case 'Rechazada':
        return rejectedGradient;
      default:
        return rejectedGradient;
    }
  }

}
