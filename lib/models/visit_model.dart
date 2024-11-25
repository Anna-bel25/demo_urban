enum MedioIngreso { Vehiculo, Caminando }
enum EstadoSolicitud { Ingresada, Aceptada, Rechazada }

class CreateVisitModel {
  final String nombreVisitante;
  final String apellidoVisitante;
  final String cedulaVisitante;
  final String cedulaResidente;
  final String manzanaVilla;
  final String fechaVisita;
  final MedioIngreso medioIngreso;
  final EstadoSolicitud estadoSolicitud;
  final String? fotoPlaca;

  CreateVisitModel({
    required this.nombreVisitante,
    required this.apellidoVisitante,
    required this.cedulaVisitante,
    required this.cedulaResidente,
    required this.manzanaVilla,
    required this.fechaVisita,
    required this.medioIngreso,
    required this.estadoSolicitud,
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
      estadoSolicitud: EstadoSolicitud.values.byName(json['Estado'] ?? 'Ingresada'),
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
      'EstadoSolicitud': estadoSolicitud.name,
      if (fotoPlaca != null) 'fotoPlaca': fotoPlaca,
    };
  }
}