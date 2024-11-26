enum MedioIngreso { Vehiculo, Caminando }
enum EstadoSolicitud { Ingresada, Aceptada, Rechazada }

class CreateResidentModel {
  String nombreVisitante;
  String apellidoVisitante;
  String cedulaVisitante;
  String cedulaResidente;
  String manzanaVilla;
  String fechaVisita;
  MedioIngreso medioIngreso;
  EstadoSolicitud? estadoSolicitud;

  CreateResidentModel({
    required this.nombreVisitante,
    required this.apellidoVisitante,
    required this.cedulaVisitante,
    required this.cedulaResidente,
    required this.manzanaVilla,
    required this.fechaVisita,
    required this.medioIngreso,
    this.estadoSolicitud,
  });

  factory CreateResidentModel.fromJson(Map<String, dynamic> json) {
    return CreateResidentModel(
      nombreVisitante: json['NombreVisitante'] as String? ?? 'Sin nombre',
      apellidoVisitante: json['ApellidoVisitante'] as String? ?? 'Sin apellido',
      cedulaVisitante: json['CedulaVisitante'] as String? ?? '',
      cedulaResidente: json['CedulaResidente'] as String? ?? '',
      manzanaVilla: json['ManzanaVilla'] as String? ?? '',
      fechaVisita: json['FechaVisita'] as String? ?? '',
      medioIngreso: MedioIngreso.values.byName(json['MedioIngreso'] ?? 'Caminando'),
      estadoSolicitud: json['EstadoSolicitud'] != null 
          ? EstadoSolicitud.values.byName(json['EstadoSolicitud']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'NombreVisitante': nombreVisitante,
      'ApellidoVisitante': apellidoVisitante,
      'CedulaVisitante': cedulaVisitante,
      'CedulaResidente': cedulaResidente,
      'ManzanaVilla': manzanaVilla,
      'FechaVisita': fechaVisita,
      'MedioIngreso': medioIngreso.name,
      'EstadoSolicitud': estadoSolicitud?.name,
    };
  }

  CreateResidentModel updateEstadoSolicitud(EstadoSolicitud newEstado) {
    return CreateResidentModel(
      nombreVisitante: this.nombreVisitante,
      apellidoVisitante: this.apellidoVisitante,
      cedulaVisitante: this.cedulaVisitante,
      cedulaResidente: this.cedulaResidente,
      manzanaVilla: this.manzanaVilla,
      fechaVisita: this.fechaVisita,
      medioIngreso: this.medioIngreso,
      estadoSolicitud: newEstado,
    );
  }
}