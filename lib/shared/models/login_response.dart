import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
  LoginResponse.fromJson(json.decode(str));

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  String tokenSession;
  bool cambiarClave;
  String nombrePaciente;
  String numeroPaciente;
  String primerNombrePaciente;
  String politicaPrivacidadAceptada;
  String urlPoliticaPrivacidad;
  String urlWhatsapp;
  String foto;

  LoginResponse({
    required this.tokenSession,
    required this.cambiarClave,
    required this.nombrePaciente,
    required this.numeroPaciente,
    required this.primerNombrePaciente,
    required this.politicaPrivacidadAceptada,
    required this.urlPoliticaPrivacidad,
    required this.urlWhatsapp,
    required this.foto,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        tokenSession: json["tokenSession"] ?? '',
        cambiarClave: json["cambiarClave"] ?? '',
        nombrePaciente: json["nombrePaciente"] ?? '',
        numeroPaciente: json["numeroPaciente"] ?? '',
        primerNombrePaciente: json["primerNombrePaciente"] ?? '',
        politicaPrivacidadAceptada: json["politicaPrivacidadAceptada"] ?? '',
        urlPoliticaPrivacidad: json["urlPoliticaPrivacidad"] ?? '',
        urlWhatsapp:  json["urlWhatsapp"] ??  '',
        foto: json["foto"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "tokenSession": tokenSession,
        "cambiarClave": cambiarClave,
        "nombrePaciente": nombrePaciente,
        "numeroPaciente": numeroPaciente,
        "primerNombrePaciente": primerNombrePaciente,
        "politicaPrivacidadAceptada": politicaPrivacidadAceptada,
        "urlPoliticaPrivacidad": urlPoliticaPrivacidad,
        "urlWhatsapp": urlWhatsapp,
        "foto": foto,
      };
}
