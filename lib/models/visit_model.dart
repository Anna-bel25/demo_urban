enum MedioIngreso { Vehiculo, Caminando }
enum EstadoSolicitud { Ingresada, Aprobada, Rechazada }

class CreateVisitModel {
  String nombreVisitante;
  String apellidoVisitante;
  String cedulaVisitante;
  String cedulaResidente;
  String manzanaVilla;
  String fechaVisita;
  MedioIngreso medioIngreso;
  EstadoSolicitud? estadoSolicitud;
  String? fotoPlaca;

  CreateVisitModel({
    required this.nombreVisitante,
    required this.apellidoVisitante,
    required this.cedulaVisitante,
    required this.cedulaResidente,
    required this.manzanaVilla,
    required this.fechaVisita,
    required this.medioIngreso,
    this.estadoSolicitud,
    this.fotoPlaca,
  });

  factory CreateVisitModel.fromJson(Map<String, dynamic> json) {
    return CreateVisitModel(
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
      fotoPlaca: json['FotoPlaca'] as String?,
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
      if (fotoPlaca != null) 'FotoPlaca': fotoPlaca,
    };
  }
}