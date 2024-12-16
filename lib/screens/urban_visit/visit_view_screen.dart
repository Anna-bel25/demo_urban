import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../models/urban_model.dart';
import '../../providers/visit_provider.dart';
import '../../styles/buttom_style.dart';
import '../../styles/inputselect_style.dart';
import '../../styles/item_style.dart';
import '../../styles/theme.dart';
import 'visit_modal.dart';


class VisitViewScreen extends StatefulWidget {
  @override
  _VisitViewScreenState createState() => _VisitViewScreenState();
}

class _VisitViewScreenState extends State<VisitViewScreen> {
  String selectedFilter = 'solicitudesVisita';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VisitProvider>(context, listen: false).getSolicitudesYRegistros(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final visitProvider = Provider.of<VisitProvider>(context);
    return Scaffold(
      body: Consumer<VisitProvider>(
        builder: (context, model, child) {
          if (model.userData.isEmpty) {
            model.loadUserData();
            return Center(child: CircularProgressIndicator());
          }

          return Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _selectFilter(visitProvider),
                      const SizedBox(height: 10),
                      _buildListView(visitProvider),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  // Seleccionar el filtro de solicitudes o registros de visita
  Widget _selectFilter(VisitProvider visitProvider) {
    return Center(
      child: CustomDropdownWithGradient<String>(
        value: selectedFilter,
        items: <String>[
          'solicitudesVisita',
          'registrosVisita',
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value == 'solicitudesVisita'
                ? 'Mis Solicitudes de Visita'
                : 'Registros de Visita'),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            selectedFilter = value!;
            visitProvider.setSelectedFilter(selectedFilter);
          });
        },
      ),
    );
  }

  
  // Construir la lista de solicitudes o registros de visita
  Widget _buildListView(VisitProvider visitProvider) {
    final items = selectedFilter == 'solicitudesVisita'
        ? visitProvider.solicitudesVisita
        : visitProvider.registrosVisita;

    if (items.isEmpty) {
      return const Center(
        child: Text(
          'No hay solicitudes disponibles',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w300,
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        if (item is SolicitudVisita) {
          return _buildSolicitudVisitaCard(item);
        } else if (item is RegistroVisita) {
          return _buildRegistroVisitaCard(item);
        } else {
          return Container();
        }
      },
    );
  }


  // Construir la tarjeta de solicitud de visita
  Widget _buildSolicitudVisitaCard(SolicitudVisita solicitud) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 2,
      child: ListTile(
        title: Text.rich(
          TextSpan(
            text: 'Para: ',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            children: <TextSpan>[
              TextSpan(
                text: '${solicitud.residente.nombre} ${solicitud.residente.apellido}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        subtitle: Text(
          'Cédula del residente: ${solicitud.residente.numeroCedula}',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w300,
          ),
        ),
        onTap: () => _showDetails(context, solicitud),
        leading: Padding(
          padding: const EdgeInsets.only(left: 2),
            child: CustomPopupMenuEditDelete(
              onSelected: (value) {
              if (value == 'editar') {
                if (solicitud.estadoSolicitud != 'Aprobada' && solicitud.estadoSolicitud != 'Rechazada') {
                  _showEditModal(context, solicitud);
                } else {
                  showCenteredDialog(context, 'No se puede editar una solicitud con estado Aprobada o Rechazada');
                }
              } else if (value == 'eliminar') {
                _showDeleteConfirmation(context, solicitud.id);
              }
              //   if (value == 'editar') {
              //   _showEditModal(context, solicitud);
              //   } else if (value == 'eliminar') {
              //   _showDeleteConfirmation(context, solicitud.id);
              // }
            },
          ),
        ),
      ),
    );
  }


  // Construir la tarjeta de registro de visita
  Widget _buildRegistroVisitaCard(RegistroVisita registro) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 2,
      child: ListTile(
        title: Text.rich(
          TextSpan(
            text: 'Por: ',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            children: <TextSpan>[
              TextSpan(
                text: '${registro.residente.nombre} ${registro.residente.apellido}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        subtitle: Text(
          'Cédula del residente: ${registro.residente.numeroCedula}',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w300,
          ),
        ),
        onTap: () => _showDetails(context, registro),
        // leading: Padding(
        //   padding: const EdgeInsets.only(left: 2),
        //     child: CustomPopupMenuEditDelete(
        //       onSelected: (value) {
        //         if (value == 'editar') {
        //         //_showEditModal(context, registro);
        //         }else if (value == 'eliminar') {
        //         //_showDeleteConfirmation(context, registro.id);
        //       }
        //     },
        //   ),
        // ),
      ),
    );
  }


  // Mostrar modal para editar solicitud visita
  void _showEditModal(BuildContext context, SolicitudVisita solicitud) {
    VisitModal.showEditModal(context, solicitud.id, solicitud.fechaHoraVisita, solicitud.medioIngreso, solicitud.fotoPlaca);
  }

  // Método para mostrar el modal de eliminación
  void _showDeleteConfirmation(BuildContext context, int id) {
    VisitModal.showDeleteModal(context, id);
  }
  
  // Mostrar los detalles de la solicitud o registro de visita
  void _showDetails(BuildContext context, dynamic item) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.parse(item.fechaHoraVisita));
    String formattedTime = DateFormat('HH:mm:ss').format(DateTime.parse(item.fechaHoraVisita));

    const textStyleTitle = TextStyle(fontSize: 12, fontWeight: FontWeight.w600);
    const textStyleValue = TextStyle(fontSize: 12, fontWeight: FontWeight.w400);

    Widget buildRow(String title, String value) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(title, style: textStyleTitle),
          ),
          const SizedBox(width: 10),
          Text(value, style: textStyleValue),
        ],
      );
    }

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (item is SolicitudVisita || item is RegistroVisita) ...[
                  Card(
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: getStateGradient(
                            item is SolicitudVisita
                                ? item.estadoSolicitud
                                : item.estadoVisita),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                      child: Text(
                        item is SolicitudVisita ? item.estadoSolicitud : item.estadoVisita,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w400, fontSize: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Colors.grey),
                ],
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildRow('Nombre Residente:', '${item.residente.nombre} ${item.residente.apellido}'),
                    buildRow('Cédula:', '${item.residente.numeroCedula}'),
                    buildRow('Manzana:', '${item.residente.manzanaVilla}'),

                    const SizedBox(height: 10),
                    const Divider(color: Colors.grey),
                    buildRow('Nombre Visitante:', '${item.visitante.nombre} ${item.visitante.apellido}'),
                    buildRow('Cédula:', '${item.visitante.numeroCedula}'),
                    buildRow('Fecha de Visita:', formattedDate),
                    buildRow('Hora de Visita:', formattedTime),
                    buildRow('Medio de Ingreso:', '${item.medioIngreso}'),

                    if (item is SolicitudVisita && item.medioIngreso == 'Vehiculo') ...{
                      if (item.fotoPlaca != null && item.fotoPlaca!.isNotEmpty) ... {
                        const SizedBox(height: 10),
                        Center(
                          child: Image.network(
                            'http://192.168.100.8:3000${item.fotoPlaca!}',
                            height: 180,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Text('Error al cargar la imagen');
                            },
                          ),
                        ),
                        // ignore: equal_elements_in_set
                        const SizedBox(height: 10),
                      },
                      buildRow('Estado de Solicitud:', item.estadoSolicitud),
                    } else if (item is RegistroVisita) ... {
                      buildRow('Estado de Visita:', item.estadoVisita),
                    },
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}