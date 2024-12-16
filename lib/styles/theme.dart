import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


// Tema de la aplicación
ThemeData themeData() {
  return ThemeData(
    textTheme: GoogleFonts.poppinsTextTheme(),
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),

    inputDecorationTheme: const InputDecorationTheme(
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Colors.black),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Colors.green),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide(color: Colors.redAccent),
      ),
    ),


    // Establecer el color de fondo del Scaffold
    scaffoldBackgroundColor: Colors.white,
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.grey[200],
      contentTextStyle: TextStyle(
        color: Colors.black,
        fontFamily: GoogleFonts.poppins().fontFamily,
        fontSize: 14,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 10,
    ),

    useMaterial3: true,
  );
}




void showCenteredDialog(BuildContext context, String message, {Duration duration = const Duration(seconds: 1)}) {
  if (!context.mounted) return;
  print("Mostrando el diálogo con el mensaje: $message");
  
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      Future.delayed(duration, () {
        if (context.mounted) {
          print("Cerrando el diálogo...");
          Navigator.of(context).pop();
        }
      });
      return AlertDialog(
        backgroundColor: Colors.grey[200],
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ],
        ),
      );
    },
  );
}




// Manejador de errores
class ErrorHandler {
  static String getErrorMessage(int statusCode, {String? customMessage}) {
    if (customMessage != null) {
      return _getCustomErrorMessage(customMessage) ?? customMessage;
    }
    return _getGeneralErrorMessage(statusCode);
  }

  // Errores personalizados
  static String? _getCustomErrorMessage(String message) {
    const errorMessages = {
      'El número de cédula ya está registrado.':
          'El número de cédula ya está registrado.',
      'Los residentes deben proporcionar manzana y villa.':
          'Los residentes deben proporcionar manzana y villa.',
      'La manzana y villa proporcionada no coinciden con el residente.':
          'La manzana y villa proporcionada no coinciden con el residente.',
      'Ya existe una solicitud de visita para este visitante. Pruebe con otra fecha y hora.':
          'Ya existe una solicitud de visita para este visitante. \nPruebe con otra fecha y hora.',
      'El nombre y apellido del visitante no coinciden con los datos registrados':
          'El nombre y apellido del visitante no coinciden con los datos registrados.',
      'No se encontraron solicitudes de visita.':
          'No hay solicitudes de visita para este visitante.\n',
      'Visitante o residente no encontrado. Verifique las cédulas ingresadas.':
          'Visitante o residente no encontrado. \nVerifique las cédulas ingresadas.',
      'La manzana y villa proporcionada no coinciden con el residente. Verifique la información.':
          'La manzana y villa proporcionada no coinciden con el residente. \nVerifique la información.',
      'Ya existe una solicitud para esta visita con los mismos datos. Intenta con una fecha u hora diferente.':
          'Ya existe una solicitud para esta visita con los mismos datos. \nIntenta con una fecha u hora diferente.',
      'La cédula corresponde a un residente, por lo tanto no hay registros de visita.':
          'La cédula corresponde a un residente, \npor lo tanto no hay registros de visita.',
      'Usuario no encontrado. No se encontró ningún usuario con esta cédula.':
          'Usuario no encontrado. \nNo se encontró ningún usuario con esta cédula.',
      'No se puede modificar una solicitud con estado diferente a "Ingresada".':
          'No se puede modificar una solicitud con estado diferente a "Ingresada".',
      'La foto de la placa es requerida cuando el medio de ingreso es "Vehiculo".':
          'La foto de la placa es requerida cuando el medio de ingreso es "Vehiculo".',
    };

    return errorMessages[message];
  }

  // Errores generales por código de estado HTTP
  static String _getGeneralErrorMessage(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Error al crear la solicitud. Verifique los datos ingresados.\n';
      case 403:
        return 'La sesión ha caducado. No tienes permiso para realizar esta acción.\n';
      case 404:
        return 'Residente no encontrado.\n';
      case 409:
        return 'Ya existe una solicitud para esta visita.\n';
      case 413:
        return 'La imagen es demasiado grande. Por favor, selecciona una más pequeña.\n';
      case 500:
        return 'Error en el servidor. Inténtalo nuevamente más tarde.\n';
      default:
        return 'Error desconocido. Inténtalo nuevamente.\n';
    }
  }
}