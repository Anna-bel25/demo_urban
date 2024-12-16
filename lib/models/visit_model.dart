enum MedioIngreso { Vehiculo, Caminando }
enum EstadoSolicitud { Ingresada, Aprobada, Rechazada }


class VisitModel {
  final String nombreVisitante;
  final String apellidoVisitante;
  final String cedulaVisitante;
  final String cedulaResidente;
  final String manzanaVilla;
  final String fechaVisita;
  final MedioIngreso medioIngreso;
  final String? fotoPlaca;
  final EstadoSolicitud? estadoSolicitud;

  VisitModel({
    required this.nombreVisitante,
    required this.apellidoVisitante,
    required this.cedulaVisitante,
    required this.cedulaResidente,
    required this.manzanaVilla,
    required this.fechaVisita,
    required this.medioIngreso,
    this.fotoPlaca,
    this.estadoSolicitud,
  });

  factory VisitModel.fromJson(Map<String, dynamic> json) {
    return VisitModel(
      nombreVisitante: json['NombreVisitante'] as String? ?? 'Sin nombre',
      apellidoVisitante: json['ApellidoVisitante'] as String? ?? 'Sin apellido',
      cedulaVisitante: json['CedulaVisitante'] as String? ?? '',
      cedulaResidente: json['CedulaResidente'] as String? ?? '',
      manzanaVilla: json['ManzanaVilla'] as String? ?? '',
      fechaVisita: json['FechaVisita'] as String? ?? '',
      medioIngreso: MedioIngreso.values.byName(json['MedioIngreso']),
      fotoPlaca: json['FotoPlaca'] as String?,
      estadoSolicitud: EstadoSolicitud.values.byName(json['EstadoSolicitud']) 
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
      'FotoPlaca': fotoPlaca,
      'EstadoSolicitud': estadoSolicitud?.name ?? 'Ingresada',
    };
  }
}


class UpdateVisitModel {
  String? fechaVisita;
  String? medioIngreso;
  String? fotoPlaca;

  UpdateVisitModel({
    this.fechaVisita,
    this.medioIngreso,
    this.fotoPlaca,
  });

  Map<String, dynamic> toJson() {
    return {
      'fechaVisita': fechaVisita,
      'medioIngreso': medioIngreso,
      'fotoPlaca': fotoPlaca,
    };
  }
}
