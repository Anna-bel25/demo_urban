import 'package:flutter/material.dart';



// BOTON GRADIANT PINK - RED
ButtonStyle botonEstiloGradientRed() {
  return FilledButton.styleFrom(
    backgroundColor: Colors.transparent,
    side: const BorderSide(color: Colors.white, width: 1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
}

class CustomButtonGradientRed extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonStyle style;
  final TextStyle? textStyle;

  const CustomButtonGradientRed({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.style,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 225, 10, 81),
              Color.fromARGB(255, 88, 17, 12),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: FilledButton(
          onPressed: onPressed,
          style: style,
          child: Text(
            text,
            style: textStyle ??
                const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}



// BOTON GRADIANT RED PARA FORMULARIOS DE SOLICITUDES
class CustomButtonGradientRedForms extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonStyle style;
  final TextStyle? textStyle;

  const CustomButtonGradientRedForms({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.style,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 225, 10, 81),
              Color.fromARGB(255, 88, 17, 12),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: FilledButton(
          onPressed: onPressed,
          style: style,
          child: Text(
            text,
            style: textStyle ??
                const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}



// BOTON GRADIANT BLACK
ButtonStyle botonEstiloGradientBlack() {
  return FilledButton.styleFrom(
    backgroundColor: Colors.transparent,
    side: const BorderSide(color: Colors.white, width: 1),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
}


class CustomButtonGradientBlack extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final ButtonStyle style;
  final TextStyle? textStyle;

  const CustomButtonGradientBlack({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.style,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 60, 5, 22),
              Color.fromARGB(255, 0, 0, 0),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: FilledButton(
          onPressed: onPressed,
          style: style,
          child: Text(
            text,
            style: textStyle ??
              const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}



// BOTON GRADIANT PINK - RED
ButtonStyle botonEstiloDialog() {
  return FilledButton.styleFrom(
    backgroundColor: Colors.white70,
    side: BorderSide(
      color: Colors.grey[400]!,
      width: 0.2,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
  );
}

// BOTÓN PARA DIALOGOS
class CustomButtonDialog extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonStyle style;
  final TextStyle? textStyle;

  const CustomButtonDialog({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.style,
    this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color textColor = onPressed == null ? Colors.grey[700]!.withOpacity(0.2) : Colors.white;
    Color backgroundColor = onPressed == null ? Colors.grey[200]!.withOpacity(0.2) : Colors.white;

    return SizedBox(
      width: double.infinity,
      height: 30,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: Colors.grey[100]!,
            width: 0.5,
          ),
        ),
        child: FilledButton(
          onPressed: onPressed,
          style: style.copyWith(
            backgroundColor: WidgetStateProperty.all(backgroundColor),
            overlayColor: WidgetStateProperty.all(Colors.transparent),
          ),
          child: ShaderMask(
            shaderCallback: (bounds) {
              return const LinearGradient(
                colors: [
                  Color.fromARGB(255, 225, 10, 82),
                  Color.fromARGB(255, 88, 17, 12),
                ],
              ).createShader(bounds);
            },
            child: Text(
              text,
              style: (textStyle ?? const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
              )).copyWith(
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}


// Función para obtener el gradiente de acuerdo con el estado
RadialGradient getStateGradient(String estado) {
  switch (estado) {
    case 'Aprobada':
      return const RadialGradient(
        colors: [
          Color.fromARGB(255, 225, 10, 82),
          Color.fromARGB(255, 88, 17, 12),
        ],
        center: Alignment.center,
        radius: 2,
        focal: Alignment.center,
        focalRadius: 0.1,
      );
    case 'Ingresada':
      return const RadialGradient(
        colors: [
          Color.fromARGB(154, 225, 10, 82),
          Color.fromARGB(210, 146, 33, 61),
        ],
        center: Alignment.center,
        radius: 2,
        focal: Alignment.center,
        focalRadius: 0.1,
      );
    case 'Rechazada':
      return const RadialGradient(
        colors: [
          Color.fromARGB(255, 60, 5, 22),
          Color.fromARGB(255, 0, 0, 0),
        ],
        center: Alignment.center,
        radius: 2,
        focal: Alignment.center,
        focalRadius: 0.1,
      );
    default:
      return const RadialGradient(
        colors: [
          Color.fromARGB(255, 60, 5, 22),
          Color.fromARGB(255, 0, 0, 0),
        ],
        center: Alignment.center,
        radius: 2,
        focal: Alignment.center,
        focalRadius: 0.1,
      );
  }
}






// DATE PICKER CUSTOM
class CustomDatePicker {
  static Future<DateTime?> showDatePickerCustom(BuildContext context) async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color.fromARGB(255, 225, 10, 81),
            hintColor: const Color.fromARGB(255, 225, 10, 81),
            colorScheme: ColorScheme.light(primary: const Color.fromARGB(255, 225, 10, 81)),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            dialogBackgroundColor: Colors.white,
          ),
          child: child ?? const SizedBox(),
        );
      },
    );
  }

  // TIME PICKER PERSONALIZADO
  static Future<TimeOfDay?> showTimePickerCustom(BuildContext context) async {
    return await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color.fromARGB(255, 225, 10, 81),
            hintColor: const Color.fromARGB(255, 225, 10, 81),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary), 
            dialogBackgroundColor: Colors.white, // Fondo blanco
            colorScheme: const ColorScheme.light(
              primaryContainer: Color.fromARGB(255, 225, 10, 81),
            ),
            primaryTextTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.black),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: const Color.fromARGB(255, 225, 10, 81)),
            ),
            timePickerTheme: TimePickerThemeData(
              dialTextColor: Colors.black,
              dialHandColor: Colors.grey[300],
              dialBackgroundColor: Colors.white,
              entryModeIconColor: Colors.black,
              backgroundColor: Colors.white,
            ),
          ),
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}
