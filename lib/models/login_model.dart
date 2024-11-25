
class LoginModel {
  final String numeroCedula;
  final String contrasena;
  final String metodoAutenticacion;
  final List<String>? biometria;

  LoginModel({
    required this.numeroCedula,
    this.metodoAutenticacion = 'Tradicional',
    required this.contrasena,
    this.biometria,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      numeroCedula: json['NumeroCedula'] as String,
      contrasena: json['Contrasena'] as String,
      metodoAutenticacion: json['MetodoAutenticacion'] as String,
      biometria: json['Biometria'] != null
          ? List<String>.from(json['Biometria'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'NumeroCedula': numeroCedula,
      'Contrasena': contrasena,
      'MetodoAutenticacion': metodoAutenticacion,
      'Biometria': biometria,
    };
  }
}
