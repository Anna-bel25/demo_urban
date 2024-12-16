import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


// CAMPO DE TEXTO
class CampoTexto extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType inputType;
  final bool readOnly;
  final AutovalidateMode? autoValidateMode;

  const CampoTexto({
    required this.labelText,
    required this.controller,
    this.validator,
    this.obscureText = false,
    this.inputType = TextInputType.text,
    this.readOnly = false,
    this.autoValidateMode,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        keyboardType: inputType,
        readOnly: readOnly,
        style: const TextStyle(fontSize: 13),
        autovalidateMode: autoValidateMode ?? AutovalidateMode.disabled,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.black54,
          ),
          filled: true,
          fillColor: readOnly ? Colors.grey[200] : Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        ).applyDefaults(Theme.of(context).inputDecorationTheme),
      ),
    );
  }
}




// CAMPO DE SELECT
class CampoSelect extends StatelessWidget {
  final String labelText;
  final String selectedValue;
  final List<String> options;
  final ValueChanged<String?>? onChanged;
  final String? Function(String?)? validator;

  const CampoSelect({
    required this.labelText,
    required this.selectedValue,
    required this.options,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    //double screenHeight = MediaQuery.of(context).size.height;
    //double fieldHeight = screenHeight * 0.010;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: GoogleFonts.poppins(
            fontSize: 12, 
            color: Colors.black54
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            //vertical: fieldHeight / 2
            //vertical: 2
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey),
          ),
        ).applyDefaults(Theme.of(context).inputDecorationTheme),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 250),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: options.contains(selectedValue) ? selectedValue : null,
              isExpanded: true,
              isDense: true,
              onChanged: onChanged,
              items: options.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: GoogleFonts.poppins(fontSize: 13),
                  ),
                );
              }).toList(),
              hint: Text(
                'Seleccione una opción',
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54),
              ),
              dropdownColor: Colors.white,
              iconSize: 24,
              alignment: Alignment.centerLeft,
              itemHeight: 48,
              icon: Icon(Icons.arrow_drop_down),
              iconEnabledColor: Colors.black54,
              iconDisabledColor: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}



// DROPDOWN PARA FILTROS
class CustomDropdownWithGradient<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final FormFieldValidator<T>? validator;

  const CustomDropdownWithGradient({
    Key? key,
    required this.value,
    required this.items,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 0, 0, 0),
              Color.fromARGB(255, 60, 5, 22),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButtonFormField<T>(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.transparent,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 18),
          ),
          value: value,
          isExpanded: true,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          dropdownColor: Color.fromARGB(218, 60, 5, 22),
          items: items,
          onChanged: onChanged,
          validator: validator,
          icon: const Icon(
            Icons.arrow_drop_down,
            color: Colors.white,
            size: 24,
          ),
          iconEnabledColor: Colors.white,
          iconDisabledColor: Colors.grey,
        ),
      ),
    );
  }
}

