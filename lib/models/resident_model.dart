enum MedioIngreso { Vehiculo, Caminando }
enum EstadoRegistro { Registrada, Completada, Cancelada }

class CreateResidentModel {
  final String nombreVisitante;
  final String apellidoVisitante;
  final String cedulaVisitante;
  final String cedulaResidente;
  final String manzanaVilla;
  final String fechaVisita;
  final MedioIngreso medioIngreso;
  final EstadoRegistro estadoRegistro;

  CreateResidentModel({
    required this.nombreVisitante,
    required this.apellidoVisitante,
    required this.cedulaVisitante,
    required this.cedulaResidente,
    required this.manzanaVilla,
    required this.fechaVisita,
    required this.medioIngreso,
    required this.estadoRegistro,
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
      estadoRegistro: EstadoRegistro.values.byName(json['Estado'] ?? 'Ingresada'),
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
      'EstadoRegistro': estadoRegistro.name,
    };
  }
}