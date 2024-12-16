import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


import '../../models/urban_model.dart';
import '../../providers/resident_provider.dart';
import '../../styles/buttom_style.dart';
import '../../styles/inputselect_style.dart';
import '../../styles/item_style.dart';
import 'resident_modal.dart';


class ResidentViewScreen extends StatefulWidget {
  @override
  _ResidentViewScreenState createState() => _ResidentViewScreenState();
}

class _ResidentViewScreenState extends State<ResidentViewScreen> {
  String selectedFilter = 'registrosComoResidente';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ResidentProvider>(context, listen: false).getRegistrosYSolicitudes(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final residentProvider = Provider.of<ResidentProvider>(context);
    return Scaffold(
      body: Consumer<ResidentProvider>(
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
                      _selectFilter(residentProvider),
                      const SizedBox(height: 10),
                      _buildListView(residentProvider),
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


  // Seleccionar el filtro de registros
  Widget _selectFilter(ResidentProvider residentProvider) {
    return Center(
      child: CustomDropdownWithGradient<String>(
        value: selectedFilter,
        items: <String>[
          'registrosComoResidente',
          'solicitudesHaciaResidente'
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value == 'registrosComoResidente'
                ? 'Mis Registros de Visita'
                : 'Solicitudes de Visita'),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            selectedFilter = value!;
          });
        },
      ),
    );
  }


  // Construir la lista de registros
  Widget _buildListView(ResidentProvider residentProvider) {
    final items = selectedFilter == 'registrosComoResidente'
        ? residentProvider.registrosComoResidente
        : residentProvider.solicitudesHaciaResidente;

    if (items.isEmpty) {
      return const Center(
        child: Text(
          'No hay registros disponibles',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w300,
          ),
        )
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
            text: 'De: ',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            children: <TextSpan>[
              TextSpan(
                text: '${solicitud.visitante.nombre} ${solicitud.visitante.apellido}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        subtitle: Text(
          'Cédula del visitante: ${solicitud.visitante.numeroCedula}',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w300,
          ),
        ),
        onTap: () => _showDetails(context, solicitud),
        leading: Padding(
          padding: const EdgeInsets.only(left: 2),
            child: CustomPopupMenuStatus(
              onSelected: (value) {
              if (value == 'estado') {
                _showEstadoModal(context, solicitud);
              }
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
            text: 'Para: ',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
            children: <TextSpan>[
              TextSpan(
                text: '${registro.visitante.nombre} ${registro.visitante.apellido}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        subtitle: Text(
          'Cédula del visitante: ${registro.visitante.numeroCedula}',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w300,
          ),
        ),
        onTap: () => _showDetails(context, registro),
        leading: Padding(
          padding: const EdgeInsets.only(left: 2),
            child: CustomPopupMenuEditDelete(
              onSelected: (value) {
                if (value == 'editar') {
                _showEditModal(context, registro);
                }else if (value == 'eliminar') {
                _showDeleteConfirmation(context, registro.id);
              }
            },
          ),
        ),
      ),
    );
  }
  

  // Mostrar modal para editar registro de visita
  void _showEditModal(BuildContext context, RegistroVisita registro) {
    ResidentModal.showEditModal(context, registro.id, registro.fechaHoraVisita, registro.medioIngreso);
  }

  // Mostrar modal para editar estado de solicitud
  void _showEstadoModal(BuildContext context, SolicitudVisita solicitud) {
    ResidentModal.showEditStatusModal(context, solicitud.id, solicitud.estadoSolicitud);
  }

  // Método para mostrar el modal de eliminación
  void _showDeleteConfirmation(BuildContext context, int id) {
    ResidentModal.showDeleteModal(context, id);
  }
    
  // Mostrar los detalles de la visita
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
                // const Center(
                //   child: Text(
                //     'Detalles',
                //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                //   ),
                // ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildRow('Nombre Visitante:', '${item.visitante.nombre} ${item.visitante.apellido}'),
                    buildRow('Cédula:', '${item.visitante.numeroCedula}'),
                    //buildRow('Fecha y Hora de Visita:', '$formattedDate - $formattedTime'),
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

                    const SizedBox(height: 10),
                    const Divider(color: Colors.grey),
                    buildRow('Nombre Residente:', '${item.residente.nombre} ${item.residente.apellido}'),
                    buildRow('Cédula:', '${item.residente.numeroCedula}'),
                    buildRow('Manzana:', '${item.residente.manzanaVilla}'),
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