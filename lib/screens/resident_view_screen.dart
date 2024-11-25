import 'package:flutter/material.dart';

import '../models/resident_model.dart';
import '../services/resident_service.dart';
import 'resident_register_screen.dart';


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
      home: const ResidentViewPage(title: ' '),
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
    _residentes = _residentService.getVisitRequests();
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
              MaterialPageRoute(builder: (context) => const ResidentRegisterScreen()),
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
      child: FutureBuilder<List<CreateResidentModel>>(
        future: _residentes,
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
                    _showVisitasDetalle(context, registro);
                  },
                  leading: IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      _showVisitasDetalle(context, registro);
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

  void _showVisitasDetalle(BuildContext context, CreateResidentModel registros) {
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
                    subtitle: Text('Cédula: ${registros.cedulaResidente}'),
                  ),
                  ListTile(
                    title: const Text('Nombre y Apellido del Visitante'),
                    subtitle: Text('${registros.nombreVisitante} ${registros.apellidoVisitante}'),
                  ),
                  ListTile(
                    title: const Text('Cédula del Visitante'),
                    subtitle: Text('Cédula: ${registros.cedulaVisitante}'),
                  ),
                  ListTile(
                    title: const Text('Manzana/Villa'),
                    subtitle: Text(registros.manzanaVilla),
                  ),
                  ListTile(
                    title: const Text('Fecha y Hora de Visita'),
                    subtitle: Text(registros.fechaVisita),
                  ),
                  ListTile(
                    title: const Text('Medio de Ingreso'),
                    subtitle: Text(registros.medioIngreso.name),
                  ),
                  ListTile(
                    title: const Text('Estado del Registro'),
                    subtitle: Text(registros.estadoRegistro.name),
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