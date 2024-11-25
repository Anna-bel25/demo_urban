import 'dart:convert';
import 'package:flutter/material.dart';

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
      home: const VisitViewPage(title: ' '),
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
        title: const Text('Mis Solicitudes de Visita'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const VisitRegisterScreen()),
            );
          },
        ),
      ),
      body: _visitasLista(),
    );
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
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay solicitudes de visita'));
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
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    _showVisitasDetalle(context, visita);
                  },
                  leading: IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      _showVisitasDetalle(context, visita);
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
            //margin: const EdgeInsets.symmetric(horizontal: 5),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ListTile(
                    title: Text('Detalles de la Solicitud'),
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
                    subtitle: Text(visita.fechaVisita),
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
                    title: const Text('Estado del Registro'),
                    subtitle: Text(visita.estadoSolicitud.name),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  // void _showVisitasDetalle(BuildContext context, CreateVisitModel visita) {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (BuildContext context) {
  //       return Container(
  //         margin: const EdgeInsets.symmetric(horizontal: 20),
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(16),
  //         ),
  //         child: SingleChildScrollView(
  //           child: Card(
  //             elevation: 5,
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 ListTile(
  //                   title: const Text('Detalles de la Solicitud'),
  //                   subtitle: Text('Cédula del residente: ${visita.cedulaResidente}'),
  //                 ),
  //                 ListTile(
  //                   title: const Text('Nombre y Apellido del Visitante'),
  //                   subtitle: Text('${visita.nombreVisitante} ${visita.apellidoVisitante}'),
  //                 ),
  //                 ListTile(
  //                   title: const Text('Cédula del Visitante'),
  //                   subtitle: Text('Cédula: ${visita.cedulaVisitante}'),
  //                 ),
  //                 ListTile(
  //                   title: const Text('Manzana/Villa'),
  //                   subtitle: Text(visita.manzanaVilla),
  //                 ),
  //                 ListTile(
  //                   title: const Text('Fecha y Hora de Visita'),
  //                   subtitle: Text(visita.fechaVisita),
  //                 ),
  //                 ListTile(
  //                   title: const Text('Medio de Ingreso'),
  //                   subtitle: Text(visita.medioIngreso.name),
  //                 ),
  //                 if (visita.fotoPlaca != null)
  //                   ListTile(
  //                     title: const Text('Foto de Placa'),
  //                     subtitle: Image.memory(
  //                       base64Decode(visita.fotoPlaca!),
  //                       width: 100,
  //                       height: 100,
  //                       fit: BoxFit.cover,
  //                     ),
  //                   ),
  //                 ListTile(
  //                   title: const Text('Estado del Registro'),
  //                   subtitle: Text(visita.estado.name),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }



}