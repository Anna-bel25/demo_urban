import 'package:demo_urban/providers/resident_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../styles/buttom_style.dart';
import '../../styles/inputselect_style.dart';
import '../../styles/validation.dart';


class ResidentRegisterScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
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
                padding: const EdgeInsets.all(18),
                child: Form(
                  key: model.residentFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _formulario(model, context),
                      _botones(model, context),
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



  Widget _formulario(ResidentProvider model, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Registro de Visita',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w100,
              ),
            ),
          ),
          const SizedBox(height: 20),
          
          CampoTexto(
            labelText: 'Número de Cédula Residente',
            controller: model.numeroCedulaResidenteController,
            validator: (value) => validateFormSolicitud(value, 'numeroCedulaResidente'),
            inputType: TextInputType.number,
            readOnly: true,
            autoValidateMode: AutovalidateMode.onUserInteraction,
          ),
          
          CampoTexto(
            labelText: 'Número de Cédula Visitante',
            controller: model.numeroCedulaVisitanteController,
            validator: (value) => validateFormSolicitud(value, 'numeroCedulaVisitante'),
            inputType: TextInputType.number,
            autoValidateMode: AutovalidateMode.onUserInteraction,
          ),

          CampoTexto(
            labelText: 'Nombre Visitante',
            controller: model.nombreVisitanteController,
            validator: (value) => validateFormSolicitud(value, 'nombreVisitante'),
            autoValidateMode: AutovalidateMode.onUserInteraction,
          ),
          
          CampoTexto(
            labelText: 'Apellido Visitante',
            controller: model.apellidoVisitanteController,
            validator: (value) => validateFormSolicitud(value, 'apellidoVisitante'),
            autoValidateMode: AutovalidateMode.onUserInteraction,
          ),

          CampoTexto(
            labelText: 'Manzana y Villa',
            controller: model.manzanaVillaController,
            validator: (value) => validateFormSolicitud(value, 'manzanaVilla'),
            readOnly: true,
            autoValidateMode: AutovalidateMode.onUserInteraction,
          ),
          const SizedBox(height: 4),

          GestureDetector(
            onTap: () async {
              await _selectDateTime(context, model);
            },
            child: AbsorbPointer(
              child: TextFormField(
                controller: model.fechaHoraVisitaController,
                validator: (value) => validateFormSolicitud(value, 'fechaVisita'),
                decoration: const InputDecoration(
                  labelText: 'Fecha y Hora de Visita',
                  labelStyle: TextStyle(fontSize: 12),
                  border: OutlineInputBorder(),
                ),
                style: TextStyle(fontSize: 12),
              ),
            ),
          ),
          const SizedBox(height: 4),

          CampoSelect(
            labelText: 'Medio de Ingreso',
            selectedValue: model.medioIngresoSeleccionado,
            options: ['Vehiculo', 'Caminando'],
            onChanged: (value) {
              model.setMedioIngresoSeleccionado(value!);
            },
            validator: (value) => validateFormSolicitud(value, 'medioIngreso'),
          ),
          const SizedBox(height: 8),

        ],
      ),
    );
  }


  Widget _botones(ResidentProvider model, BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CustomButtonGradientBlack(
            text: 'CREAR SOLICITUD',
            onPressed: () => model.createRegistroVisita(context),
            style: botonEstiloGradientBlack(),
          ),
        ],
      ),
    );
  }


  // Seleccionar fecha y hora de la visita
  Future<void> _selectDateTime(BuildContext context, ResidentProvider model) async {
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

        model.fechaHoraVisitaController.text =
          "${finalDateTime.toLocal()}".split(' ')[0] + " " + "${finalDateTime.toLocal()}".split(' ')[1].substring(0, 5);
      }
    }
  }
}