


// Función de validación para los campos de registro
String? validarFormRegister(String? value, String campo) {
  if (value == null || value.isEmpty) return 'Este campo es requerido!';

  final reglas = {
    'cedula': () => value.length != 10 ? 'La cédula debe tener 10 dígitos' : null,
    'contrasena': () => value.length < 6 ? 'Debe tener al menos 6 caracteres' : null,
    'nombre': () => !RegExp(r'^[a-zA-Z]+$').hasMatch(value) ? 'El nombre solo debe contener letras' : null,
    'apellido': () => !RegExp(r'^[a-zA-Z]+$').hasMatch(value) ? 'El apellido solo debe contener letras' : null,
    'manzanaVilla': () => value.isEmpty ? 'Por favor ingrese la manzana y villa' : null,
    'rol': () => value.isEmpty ? 'Debe seleccionar un rol' : null,
    'soloNumeros': () => !RegExp(r'^[0-9]+$').hasMatch(value) ? 'Este campo solo debe contener números' : null,
    'soloLetras': () => !RegExp(r'^[a-zA-Z]+$').hasMatch(value) ? 'Este campo solo debe contener letras' : null,
  };

  return reglas[campo]?.call();
}



// Función de validación para los campos de login
String? validarFormLogin(String? value, String campo) {
  if (value == null || value.isEmpty) return 'Este campo es requerido!';

  final reglas = {
    'cedula': () => value.length != 10 ? 'La cédula debe tener 10 dígitos' : null,
    'contrasena': () => value.length < 6 ? 'Debe tener al menos 6 caracteres' : null,
    'metodoAutenticacion': () => value.isEmpty ? 'Selecciona un método de autenticación' : null,
  };

  return reglas[campo]?.call();
}



// Función de validación para los campos de solicitud de visitantes
String? validateFormSolicitud(String? value, String campo) {
  if (value == null || value.isEmpty) return 'Este campo es requerido!';
  
  final reglas = {
    'nombreVisitante': () => !RegExp(r'^[a-zA-Z]+$').hasMatch(value) ? 'El nombre solo debe contener letras' : null,
    'apellidoVisitante': () => !RegExp(r'^[a-zA-Z]+$').hasMatch(value) ? 'El apellido solo debe contener letras' : null,
    'numeroCedulaVisitante': () => value.length != 10 ? 'La cédula debe tener 10 dígitos' : null,
    'numeroCedulaResidente': () => value.length != 10 ? 'La cédula debe tener 10 dígitos' : null,
    'manzanaVilla': () => value.isEmpty ? 'Por favor ingrese la manzana y villa' : null,
    'fechaHoraVisita': () => !RegExp(r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}$').hasMatch(value) ? 'La fecha y hora deben estar en formato "YYYY-MM-DD HH:MM"' : null,
    'medioIngreso': () => value.isEmpty ? 'Debe seleccionar un medio de ingreso' : null,
    'fotoPlaca': () => value.isEmpty ? 'Debe ingresar la foto de la placa' : null,
  };

  return reglas[campo]?.call();
}
