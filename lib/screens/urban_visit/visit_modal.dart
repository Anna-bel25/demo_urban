import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/visit_provider.dart';
import '../../styles/buttom_style.dart';
import '../../styles/inputselect_style.dart';


class VisitModal {

  static Future<void> showEditModal(BuildContext context, int id, String currentDateTime, String currentMedioIngreso, String? fotoPlaca) async {
    final visitProvider = Provider.of<VisitProvider>(context, listen: false);

    DateTime parsedDateTime = DateTime.parse(currentDateTime);
    String formattedDateTime = DateFormat('dd-MM-yyyy HH:mm').format(parsedDateTime);

    TextEditingController fechaHoraVisita = TextEditingController(text: formattedDateTime);
    String selectedMedioIngreso = currentMedioIngreso;

    // if (fotoPlaca != null) {
    //   visitProvider.setFotoPlaca(File(fotoPlaca));
    // }

    bool isModified = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 60, 5, 22),
                              Color.fromARGB(255, 0, 0, 0),
                            ],
                            begin: Alignment.topRight,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 4),
                        child: const Text(
                          'Editar Registro',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Divider(color: Colors.grey),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await _selectDateTime(context, fechaHoraVisita, visitProvider);
                        setState(() {
                          isModified = true;
                        });
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: fechaHoraVisita,
                          decoration: const InputDecoration(
                            labelText: 'Fecha y Hora de Visita',
                            labelStyle: TextStyle(fontSize: 12),
                            border: OutlineInputBorder(),
                          ),
                          style: TextStyle(fontSize: 12),
                          onChanged: (value) {
                            if (value != formattedDateTime) {
                              setState(() {
                                isModified = true;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    CampoSelect(
                      labelText: 'Medio de Ingreso',
                      selectedValue: selectedMedioIngreso,
                      options: ['Vehiculo', 'Caminando'],
                      onChanged: (value) {
                        setState(() {
                          selectedMedioIngreso = value!;
                          //visitProvider.fotoPlaca;
                          visitProvider.setMedioIngresoSeleccionado(value);
                          isModified = true;
                        });
                      },
                    ),
                    if (selectedMedioIngreso == 'Vehiculo') ...[
                      CustomButtonGradientRedForms(
                        text: 'Seleccionar Imagen de Placa',
                        onPressed: () async {
                          await _pickImage(visitProvider, context, setState);
                          setState(() {
                            isModified = true;
                          });
                        },
                        style: botonEstiloGradientRed(),
                      ),
                      if (visitProvider.fotoPlaca != null) ...[
                        const SizedBox(height: 10),
                        const Text('Imagen seleccionada:', style: TextStyle(fontSize: 12)),
                        const SizedBox(height: 10),
                        Image.file(
                          visitProvider.fotoPlaca!,
                          width: 250,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ],
                  ],
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: CustomButtonDialog(
                        text: 'Guardar',
                        onPressed: isModified
                            ? () {
                                visitProvider.updateSolicitudVisita(
                                  context,
                                  id,
                                );
                                Navigator.of(context).pop();
                              }
                            : null,
                        style: botonEstiloDialog(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomButtonDialog(
                        text: 'Cancelar',
                        onPressed: () {
                          Navigator.of(context).pop();
                          visitProvider.limpiarCampos();
                        },
                        style: botonEstiloDialog(),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }


  // Método para mostrar el modal de eliminación de registro
  static Future<void> showDeleteModal(BuildContext context, int id) async {
    final visitProvider = Provider.of<VisitProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 60, 5, 22),
                              Color.fromARGB(255, 0, 0, 0),
                            ],
                            begin: Alignment.topRight,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 4),
                        child: const Text(
                          'Eliminar Registro',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Divider(color: Colors.grey),
                ],
              ),
              content: const SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '¿Estás seguro de que deseas eliminar este registro de visita?',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Esta acción no se puede deshacer.',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w100,
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center, 
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: CustomButtonDialog(
                        text: 'Eliminar',
                        onPressed: () {
                          visitProvider.deleteSolicitudVisita(context, id);
                          Navigator.of(context).pop();
                        },
                        style: botonEstiloDialog(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: CustomButtonDialog(
                        text: 'Cancelar',
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: botonEstiloDialog(),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }






  // Método para seleccionar fecha y hora
  static Future<void> _selectDateTime(BuildContext context, TextEditingController fechaHoraController, VisitProvider visitProvider) async {
    final DateTime? selectedDate = await CustomDatePicker.showDatePickerCustom(context);

    if (selectedDate != null) {
      final TimeOfDay? selectedTime = await CustomDatePicker.showTimePickerCustom(context);

      if (selectedTime != null) {
        final DateTime finalDateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        // Mostrar la fecha y hora en formato DD-MM-YYYY HH:mm
        //String formattedDateTime = DateFormat('dd-MM-yyyy HH:mm').format(finalDateTime);
        String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm').format(finalDateTime);
        fechaHoraController.text = formattedDateTime;
        
        visitProvider.fechaHoraVisita = formattedDateTime;
      }
    }
  }

  // Seleccionar imagen de la placa del vehículo
    static Future<void> _pickImage(VisitProvider visitProvider, BuildContext context, StateSetter setState) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      visitProvider.setFotoPlaca(File(image.path));
      setState(() {});
    }
  }
}