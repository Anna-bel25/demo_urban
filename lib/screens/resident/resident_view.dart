import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import '../../models/resident_model.dart';
import '../../services/resident_service.dart';
import 'resident_register.dart';


class ResidentViewScreen extends StatelessWidget {
  const ResidentViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulario de Solicitud de Visita',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 249, 252, 254),
        ),
        useMaterial3: true,
      ),
      home: const ResidentViewPage(title: 'Mis registros'),
    );
  }
}

class ResidentViewPage extends StatefulWidget {
  const ResidentViewPage({super.key, required this.title});
  final String title;

  @override
  State<ResidentViewPage> createState() => _ResidentViewPageState();
}

class _ResidentViewPageState extends State<ResidentViewPage> {
  final ResidentService _residentService = ResidentService();
  late Future<List<CreateResidentModel>> _residentes;


  @override
  void initState() {
    super.initState();
    _residentes = _residentService.getResidentRequests();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: Color.fromARGB(185, 218, 224, 232),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Volver',
              onPressed: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const ResidentRegisterScreen()),
              ),
            ),
            Text(widget.title),
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              tooltip: 'Salir',
              onPressed: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const MyApp()),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: _registrosLista(),
    );
  }

  // Función para formatear la fecha
  String _formatearFecha(String fechaHora) {
    try {
      DateTime dateTime = DateTime.parse(fechaHora);
      return DateFormat('dd-MM-yyyy').format(dateTime);
    } catch (e) {
      return fechaHora;
    }
  }

  // Función para formatear la hora
  String _formatearHora(String fechaHora) {
    try {
      DateTime dateTime = DateTime.parse(fechaHora);
      return DateFormat('H:mm:ss').format(dateTime);
    } catch (e) {
      return '';
    }
  }



  Widget _registrosLista() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FutureBuilder<List<CreateResidentModel>>(
        future: _residentes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No hay solicitudes disponibles para esta cuenta'),
            );
          }

          final registros = snapshot.data!;

          return ListView.builder(
            itemCount: registros.length,
            itemBuilder: (context, index) {
              final registro = registros[index];

              return Card(
                child: ListTile(
                  title: Text('${registro.nombreVisitante} ${registro.apellidoVisitante}'),
                  subtitle: Text('${registro.cedulaVisitante} - ${registro.manzanaVilla}'),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    _showRegistrosDetalle(context, registro);
                  },
                  leading: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'editar') {
                        _showEditModal(context, registro);
                      } else if (value == 'eliminar') {
                        _showDeleteConfirmation(context, registro);
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        const PopupMenuItem<String>(
                          value: 'editar',
                          child: Text('Editar'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'eliminar',
                          child: Text('Eliminar'),
                        ),
                      ];
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showRegistrosDetalle(BuildContext context, CreateResidentModel registro) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            margin: const EdgeInsets.all(0),
            //margin: const EdgeInsets.symmetric(horizontal: 5),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ListTile(
                    title: Text(
                      'Detalles del registro',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text('Cédula del Residente'),
                    subtitle: Text('Cédula: ${registro.cedulaResidente}'),
                  ),
                  ListTile(
                    title: const Text('Nombre y Apellido del Visitante'),
                    subtitle: Text('${registro.nombreVisitante} ${registro.apellidoVisitante}'),
                  ),
                  ListTile(
                    title: const Text('Cédula del Visitante'),
                    subtitle: Text('Cédula: ${registro.cedulaVisitante}'),
                  ),
                  ListTile(
                    title: const Text('Manzana/Villa'),
                    subtitle: Text(registro.manzanaVilla),
                  ),
                  ListTile(
                    title: const Text('Fecha y Hora de Visita'),
                    //subtitle: Column(
                    subtitle: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // children: [
                      //   Text(_formatearFecha(registro.fechaVisita)),
                      //   const SizedBox(width: 4),
                      //   Text(_formatearHora(registro.fechaVisita)),
                      // ],
                      children: [
                        Text('Fecha: ${_formatearFecha(registro.fechaVisita)}' ' -'),
                        const SizedBox(width: 4),
                        Text('Hora: ${_formatearHora(registro.fechaVisita)}'), 
                      ],
                    ),
                  ),
                  ListTile(
                    title: const Text('Medio de Ingreso'),
                    subtitle: Text(registro.medioIngreso.name),
                  ),
                  ListTile(
                    title: const Text('Estado del Registro'),
                    subtitle: Text(registro.estadoSolicitud!.name),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, CreateResidentModel registro) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text('¿Estás seguro de que deseas eliminar este registro?'),
          actions: [
            TextButton(
              onPressed: () {
                // Lógica de eliminación aquí
                Navigator.of(context).pop();
              },
              child: const Text('Eliminar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _showEditModal(BuildContext context, CreateResidentModel registro) {
    final fechaController = TextEditingController(text: registro.fechaVisita);
    final medioIngresoController = TextEditingController(text: registro.medioIngreso.name);
    MedioIngreso selectedMedioIngreso = registro.medioIngreso;
    String selectedEstado = registro.estadoSolicitud?.name ?? EstadoSolicitud.Ingresada.name;
    DateTime selectedDate = DateTime.parse(registro.fechaVisita);
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(selectedDate);
    fechaController.text = DateFormat('dd-MM-yyyy H:mm:ss').format(selectedDate);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                margin: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ListTile(
                        title: Text(
                          'Editar registro',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      // Campo Fecha y Hora de Visita
                      ListTile(
                        //title: const Text('Fecha y Hora de Visita'),
                        subtitle: TextField(
                          controller: fechaController,
                          decoration: const InputDecoration(
                            labelText: 'Fecha y Hora',
                            hintText: 'Seleccione una fecha y hora',
                          ),
                          readOnly: true, // No permitir edición manual
                          onTap: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );

                            if (pickedDate != null) {
                              final pickedTime = await showTimePicker(
                                context: context,
                                initialTime: selectedTime,
                              );

                              if (pickedTime != null) {
                                selectedDate = DateTime(
                                  pickedDate.year,
                                  pickedDate.month,
                                  pickedDate.day,
                                  pickedTime.hour,
                                  pickedTime.minute,
                                );
                                setState(() {
                                  selectedTime = pickedTime; // Actualizar la hora
                                  fechaController.text = DateFormat('dd-MM-yyyy H:mm:ss').format(selectedDate);
                                });
                              }
                            }
                          },
                        ),
                      ),
                      // Campo Medio de Ingreso
                      ListTile(
                        subtitle: DropdownButton<MedioIngreso>(
                          value: selectedMedioIngreso,
                          onChanged: (MedioIngreso? newValue) {
                            setState(() {
                              selectedMedioIngreso = newValue ?? selectedMedioIngreso;
                            });
                          },
                          isExpanded: true,
                          items: MedioIngreso.values.map((MedioIngreso medio) {
                            return DropdownMenuItem<MedioIngreso>(
                              value: medio,
                              child: Text(medio.name),
                            );
                          }).toList(),
                        ),
                      ),
                      // Dropdown para Estado de la Solicitud
                      ListTile(
                        //title: const Text('Estado de la Solicitud'),
                        subtitle: DropdownButton<String>(
                          value: selectedEstado,
                          hint: const Text('Seleccionar Estado'),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedEstado = newValue ?? selectedEstado;
                              print("Estado seleccionado: $selectedEstado");
                            });
                          },
                          isExpanded: true,
                          items: EstadoSolicitud.values.map((EstadoSolicitud estado) {
                            return DropdownMenuItem<String>(
                              value: estado.name,
                              child: Text(estado.name),
                            );
                          }).toList(),
                        ),
                      ),
                      // Botones de acción
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              if (selectedEstado != null) {
                                final nuevoEstado = EstadoSolicitud.values.byName(selectedEstado);
                                final updatedRegistro = registro.updateEstadoSolicitud(nuevoEstado);

                                Navigator.of(context).pop();
                              }
                            },
                            child: const Text('Guardar'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancelar'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }


}