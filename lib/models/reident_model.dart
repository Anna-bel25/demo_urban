enum MedioIngreso { Vehiculo, Caminando }
enum EstadoSolicitud { Ingresada, Aprobada, Rechazada }

class ResidentModel {
  String nombreVisitante;
  String apellidoVisitante;
  String numeroCedulaVisitante;
  String numeroCedulaResidente;
  String manzanaVilla;
  String fechaHoraVisita;
  String medioIngreso;
  EstadoSolicitud? estadoSolicitud;

  ResidentModel({
    required this.nombreVisitante,
    required this.apellidoVisitante,
    required this.numeroCedulaVisitante,
    required this.numeroCedulaResidente,
    required this.manzanaVilla,
    required this.fechaHoraVisita,
    required this.medioIngreso,
    this.estadoSolicitud,
  });

  factory ResidentModel.fromJson(Map<String, dynamic> json) {
    return ResidentModel(
      nombreVisitante: json['NombreVisitante'] as String? ?? 'Sin nombre',
      apellidoVisitante: json['ApellidoVisitante'] as String? ?? 'Sin apellido',
      numeroCedulaVisitante: json['CedulaVisitante'] as String? ?? '',
      numeroCedulaResidente: json['CedulaResidente'] as String? ?? '',
      manzanaVilla: json['ManzanaVilla'] as String? ?? '',
      fechaHoraVisita: json['FechaHoraVisita'] as String? ?? '',
      medioIngreso: json['MedioIngreso'] as String? ?? '',
      estadoSolicitud: json['EstadoSolicitud'] != null 
          ? EstadoSolicitud.values.byName(json['EstadoSolicitud']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'NombreVisitante': nombreVisitante,
      'ApellidoVisitante': apellidoVisitante,
      'CedulaVisitante': numeroCedulaVisitante,
      'CedulaResidente': numeroCedulaResidente,
      'ManzanaVilla': manzanaVilla,
      'FechaHoraVisita': fechaHoraVisita,
      'MedioIngreso': medioIngreso,
      'EstadoSolicitud': estadoSolicitud?.name,
    };
  }

  ResidentModel updateEstadoSolicitud(EstadoSolicitud newEstado) {
    return ResidentModel(
      nombreVisitante: this.nombreVisitante,
      apellidoVisitante: this.apellidoVisitante,
      numeroCedulaVisitante: this.numeroCedulaVisitante,
      numeroCedulaResidente: this.numeroCedulaResidente,
      manzanaVilla: this.manzanaVilla,
      fechaHoraVisita: this.fechaHoraVisita,
      medioIngreso: this.medioIngreso,
      estadoSolicitud: newEstado,
    );
  }
}