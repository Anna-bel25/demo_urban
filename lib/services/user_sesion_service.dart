class UserSessionService {
  static String? token;
  static String? numeroCedula;
  static String? nombre;
  static String? apellido;
  static String? role;
  static List<String>? biometria;

  // Función para almacenar la sesión del usuario
  static void setSession(String newToken, String newNumeroCedula, String nombre, String apellido, String newRole, List<String>? newBiometria) {
    token = newToken;
    numeroCedula = newNumeroCedula;
    nombre = nombre;
    apellido = apellido;
    role = newRole;
    biometria = newBiometria;
  }

  static Map<String, dynamic> getSesion() {
    return {
      'token': token,
      'numeroCedula': numeroCedula,
      'nombre': nombre,
      'apellido': apellido,
      'role': role,
      'biometria': biometria,
    };
  }

  // Funciones para obtener los datos de la sesión
  static String? getToken() {
    return token;
  }

  static String? getNumeroCedula() {
    return numeroCedula;
  }

  static String? getNombre() {
    return nombre;
  }

  static String? getApellido() {
    return apellido;
  }

  static String? getRole() {
    return role;
  }

  static List<String>? getBiometria() {
    return biometria;
  }
}
