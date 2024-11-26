import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import '../models/visit_model.dart';
import '../services/visit_service.dart';
import 'visit_register_screen.dart';


class VisitViewScreen extends StatelessWidget {
  const VisitViewScreen({super.key});

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
      home: const VisitViewPage(title: 'Mis solicitudes'),
    );
  }
}

class VisitViewPage extends StatefulWidget {
  const VisitViewPage({super.key, required this.title});
  final String title;

  @override
  State<VisitViewPage> createState() => _VisitViewPageState();
}

class _VisitViewPageState extends State<VisitViewPage> {
  final VisitService _visitService = VisitService();
  late Future<List<CreateVisitModel>> _visitas;


  @override
  void initState() {
    super.initState();
    _visitas = _visitService.getVisitRequests();
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
              onPressed: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const VisitRegisterScreen()),
              ),
            ),
            Text(widget.title),
            IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const MyApp()),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: _visitasLista(),
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



  Widget _visitasLista() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: FutureBuilder<List<CreateVisitModel>>(
        future: _visitas,
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

          final visitas = snapshot.data!;

          return ListView.builder(
            itemCount: visitas.length,
            itemBuilder: (context, index) {
              final visita = visitas[index];

              return Card(
                child: ListTile(
                  title: Text('${visita.nombreVisitante} ${visita.apellidoVisitante}'),
                  subtitle: Text('${visita.cedulaVisitante} - ${visita.manzanaVilla}'),
                  trailing: const Icon(Icons.arrow_forward ),
                  onTap: () {
                    _showVisitasDetalle(context, visita);
                  },
                  leading: PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      if (value == 'editar') {
                        _showEditModal(context, visita);
                      } else if (value == 'eliminar') {
                        _showDeleteConfirmation(context, visita);
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

  void _showVisitasDetalle(BuildContext context, CreateVisitModel visita) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            margin: const EdgeInsets.all(0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ListTile(
                    //title: Text('Detalles de la Solicitud'),
                    title: Text(
                      'Detalles de la Solicitud',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text('Cédula del Residente'),
                    subtitle: Text('Cédula: ${visita.cedulaResidente}'),
                  ),
                  ListTile(
                    title: const Text('Nombre y Apellido del Visitante'),
                    subtitle: Text('${visita.nombreVisitante} ${visita.apellidoVisitante}'),
                  ),
                  ListTile(
                    title: const Text('Cédula del Visitante'),
                    subtitle: Text('Cédula: ${visita.cedulaVisitante}'),
                  ),
                  ListTile(
                    title: const Text('Manzana/Villa'),
                    subtitle: Text(visita.manzanaVilla),
                  ),
                  ListTile(
                    title: const Text('Fecha y Hora de Visita'),
                    //subtitle: Text(visita.fechaVisita),
                    //subtitle: Column(
                    subtitle: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Fecha: ${_formatearFecha(visita.fechaVisita)}' ' -'),
                        const SizedBox(width: 4),
                        Text('Hora: ${_formatearHora(visita.fechaVisita)}'), 
                      ],
                    ),
                  ),
                  ListTile(
                    title: const Text('Medio de Ingreso'),
                    subtitle: Text(visita.medioIngreso.name),
                  ),
                  if (visita.fotoPlaca != null)
                    ListTile(
                      title: const Text('Foto de Placa'),
                      subtitle: Image.memory(
                        base64Decode(visita.fotoPlaca!),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ListTile(
                    title: const Text('Estado de la solicitud'),
                    subtitle: Text(visita.estadoSolicitud!.name),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context, CreateVisitModel visita) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: const Text('¿Estás seguro de que deseas eliminar esta solicitud?'),
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

  void _showEditModal(BuildContext context, CreateVisitModel visita) {
    final fechaController = TextEditingController(text: visita.fechaVisita);
    final medioIngresoController = TextEditingController(text: visita.medioIngreso.name);
    MedioIngreso selectedMedioIngreso = visita.medioIngreso;
    DateTime selectedDate = DateTime.parse(visita.fechaVisita);
    TimeOfDay selectedTime = TimeOfDay.fromDateTime(selectedDate);
    fechaController.text = DateFormat('dd-MM-yyyy H:mm:ss').format(selectedDate);

    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                      'Editar Solicitud',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                  ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          visita.fechaVisita = fechaController.text;
                          visita.medioIngreso = selectedMedioIngreso;
                          // Lógica para guardar cambios
                          Navigator.of(context).pop();
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
  }

}