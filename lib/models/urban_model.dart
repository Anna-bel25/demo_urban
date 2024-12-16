
class Visitante {
  final int id;
  final String nombre;
  final String apellido;
  final String numeroCedula;
  final String? fotoPerfil;

  Visitante({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.numeroCedula,
    this.fotoPerfil,
  });

  factory Visitante.fromJson(Map<String, dynamic> json) {
    return Visitante(
      id: json['id'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      numeroCedula: json['numeroCedula'],
      fotoPerfil: json['fotoPerfil'],
    );
  }
}

class Residente {
  final int id;
  final String nombre;
  final String apellido;
  final String numeroCedula;
  final String manzanaVilla;
  final String? fotoPerfil;

  Residente({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.numeroCedula,
    required this.manzanaVilla,
    this.fotoPerfil,
  });

  factory Residente.fromJson(Map<String, dynamic> json) {
    return Residente(
      id: json['id'],
      nombre: json['nombre'],
      apellido: json['apellido'],
      numeroCedula: json['numeroCedula'],
      manzanaVilla: json['manzanaVilla'],
      fotoPerfil: json['fotoPerfil'],
    );
  }
}

class RegistroVisita {
  final int id;
  final Visitante visitante;
  final Residente residente;
  final String fechaHoraVisita;
  final String medioIngreso;
  final String estadoVisita;
  final String fechaCreacion;
  final String fechaActualizacion;

  RegistroVisita({
    required this.id,
    required this.visitante,
    required this.residente,
    required this.fechaHoraVisita,
    required this.medioIngreso,
    required this.estadoVisita,
    required this.fechaCreacion,
    required this.fechaActualizacion,
  });

  factory RegistroVisita.fromJson(Map<String, dynamic> json) {
    return RegistroVisita(
      id: json['id'],
      visitante: Visitante.fromJson(json['visitante']),
      residente: Residente.fromJson(json['residente']),
      fechaHoraVisita: json['fechaHoraVisita'],
      medioIngreso: json['medioIngreso'],
      estadoVisita: json['estadoVisita'],
      fechaCreacion: json['fechaCreacion'],
      fechaActualizacion: json['fechaActualizacion'],
    );
  }
}

class SolicitudVisita {
  final int id;
  final Visitante visitante;
  final Residente residente;
  final String fechaHoraVisita;
  final String medioIngreso;
  final String? fotoPlaca;
  final String estadoSolicitud;
  final String fechaCreacion;
  final String fechaActualizacion;

  SolicitudVisita({
    required this.id,
    required this.visitante,
    required this.residente,
    required this.fechaHoraVisita,
    required this.medioIngreso,
    this.fotoPlaca,
    required this.estadoSolicitud,
    required this.fechaCreacion,
    required this.fechaActualizacion,
  });

  factory SolicitudVisita.fromJson(Map<String, dynamic> json) {
    return SolicitudVisita(
      id: json['id'],
      visitante: Visitante.fromJson(json['visitante']),
      residente: Residente.fromJson(json['residente']),
      fechaHoraVisita: json['fechaHoraVisita'],
      medioIngreso: json['medioIngreso'],
      fotoPlaca: json['fotoPlaca'],
      estadoSolicitud: json['estadoSolicitud'],
      fechaCreacion: json['fechaCreacion'],
      fechaActualizacion: json['fechaActualizacion'],
    );
  }
}
