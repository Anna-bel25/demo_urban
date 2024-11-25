enum RolUsuario { Visitante, Residente }

class RegisterModel {
  final String numeroCedula;
  final String contrasena;
  final String nombre;
  final String apellido;
  final RolUsuario rol;
  final List<String>? biometria;

  RegisterModel({
    required this.numeroCedula,
    required this.contrasena,
    required this.nombre,
    required this.apellido,
    required this.rol,
    this.biometria,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      numeroCedula: json['NumeroCedula'] as String,
      contrasena: json['Contrasena'] as String,
      nombre: json['Nombre'] as String,
      apellido: json['Apellido'] as String,
      rol: RolUsuario.values.byName(json['Rol']),
      biometria: json['Biometria'] != null
          ? List<String>.from(json['Biometria'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'NumeroCedula': numeroCedula,
      'Contrasena': contrasena,
      'Nombre': nombre,
      'Apellido': apellido,
      'Rol': rol.name,
      'Biometria': biometria,
    };
  }
}
