import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../main.dart';
import '../../models/visit_model.dart';
import '../../services/visit_service.dart';
import '../login/register.dart';
import 'visit_view.dart';


class VisitRegisterScreen extends StatelessWidget {
  const VisitRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulario de Solicitud de Visita',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 249, 252, 254),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(color: Colors.green),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide(color: Colors.redAccent),
          ),
        ),
        useMaterial3: true,
      ),
      home: const VisitRegisterPage(title: 'Solicitud de Visita'),
    );
  }
}

class VisitRegisterPage extends StatefulWidget {
  const VisitRegisterPage({super.key, required this.title});
  final String title;

  @override
  State<VisitRegisterPage> createState() => _VisitRegisterPageState();
}

class _VisitRegisterPageState extends State<VisitRegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final ButtonStyle style = FilledButton.styleFrom(textStyle: const TextStyle(fontSize: 16));
  final ImagePicker _picker = ImagePicker();

  String nombreVisitante = "", apellidoVisitante = "", cedulaResidente = "", cedulaVisitante = "", manzanaVilla = "";
  String medioIngreso = "", estado = "";
  DateTime? fechaVisita;
  String? imagenBase64;

  String? validarFormulario(String? value, String campo) {
    if (value == null || value.isEmpty) return 'Este campo es requerido!';
    final reglas = {
      'cedulaResidente': () => value.length != 10 ? 'La cédula debe tener 10 dígitos' : null,
      'cedulaVisitante': () => value.length != 10 ? 'La cédula debe tener 10 dígitos' : null,
      'manzanaVilla': () => value.isEmpty ? 'Debe ingresar la manzana/villa' : null,
      'fechaVisita': () => value.isEmpty ? 'Debe ingresar una fecha de visita' : null,
      'medioIngreso': () => value.isEmpty ? 'Debe seleccionar un medio de ingreso' : null,
      'estado': () => value.isEmpty ? 'Debe seleccionar un estado' : null,
    };
    return reglas[campo]?.call();
  }

  Future<void> _seleccionarImagen() async {
    final XFile? imagen = await _picker.pickImage(source: ImageSource.gallery);
    if (imagen != null) {
      File imagenFile = File(imagen.path);
      List<int> imagenBytes = await imagenFile.readAsBytes();
      setState(() {
        imagenBase64 = base64Encode(imagenBytes);
      });
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (selectedDate != null && selectedDate != fechaVisita) {
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      );
      if (selectedTime != null) {
        setState(() {
          fechaVisita = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
            selectedTime.hour,
            selectedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final visitData = CreateVisitModel(
        nombreVisitante: nombreVisitante,
        apellidoVisitante: apellidoVisitante,
        cedulaVisitante: cedulaVisitante,
        cedulaResidente: cedulaResidente,
        manzanaVilla: manzanaVilla,
        fechaVisita: fechaVisita != null
            ? DateFormat('yyyy-MM-ddTHH:mm:ss').format(fechaVisita!)
            : '',
        medioIngreso: MedioIngreso.values.firstWhere(
          (e) => e.name == medioIngreso,
          orElse: () => MedioIngreso.Caminando,
        ),
        estadoSolicitud: EstadoSolicitud.Ingresada,
        fotoPlaca: imagenBase64,
      );

      final visitService = VisitService();
      try {
        final response = await visitService.registerVisitor(visitData);
        if (response['success']) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Visita registrada exitosamente')),
          );
          Navigator.pop(context);
        } else {
          throw Exception(response['message'] ?? 'Error desconocido');
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    }
  }


  void _resetForm() {
    setState(() {
      nombreVisitante = "";
      apellidoVisitante = "";
      cedulaResidente = "";
      cedulaVisitante = "";
      manzanaVilla = "";
      medioIngreso = "";
      estado = "";
      fechaVisita = null;
      imagenBase64 = null;
    });
    _formKey.currentState?.reset();
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
                context, MaterialPageRoute(builder: (context) => const RegisterForm()),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _formulario(),
                _botones(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _formulario() {
    return Column(
      children: [
        // Nombre
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Nombre',
            hintText: 'Ingrese el nombre',
            icon: Icon(Icons.person),
          ),
          validator: (value) => validarFormulario(value, 'nombreVisitante'),
          onSaved: (String? value) {
            nombreVisitante = value ?? '';
          },
        ),
        const SizedBox(height: 16),

        // Apellido
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Apellido',
            hintText: 'Ingrese el apellido',
            icon: Icon(Icons.person),
          ),
          validator: (value) => validarFormulario(value, 'apellidoVisitante'),
          onSaved: (String? value) {
            apellidoVisitante = value ?? '';
          },
        ),
        const SizedBox(height: 16),

        // Cedula Residente
        TextFormField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Cédula Residente',
            hintText: 'Ingrese la cédula del residente',
            icon: Icon(Icons.numbers_outlined),
          ),
          validator: (value) => validarFormulario(value, 'cedulaResidente'),
          onSaved: (String? value) {
            cedulaResidente = value ?? '';
          },
        ),
        const SizedBox(height: 16),

        // Cedula Visitante
        TextFormField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Cédula Visitante',
            hintText: 'Ingrese la cédula del visitante',
            icon: Icon(Icons.numbers_outlined),
          ),
          validator: (value) => validarFormulario(value, 'cedulaVisitante'),
          onSaved: (String? value) {
            cedulaVisitante = value ?? '';
          },
        ),
        const SizedBox(height: 16),

        // Manzana/Villa
        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Manzana/Villa',
            hintText: 'Ingrese la manzana o villa',
            icon: Icon(Icons.location_city),
          ),
          validator: (value) => validarFormulario(value, 'manzanaVilla'),
          onSaved: (String? value) {
            manzanaVilla = value ?? '';
          },
        ),
        const SizedBox(height: 16),

        // Fecha de Visita
        GestureDetector(
          onTap: () => _selectDateTime(context),
          child: AbsorbPointer(
            child: TextFormField(
              decoration: const InputDecoration(
                labelText: 'Fecha y Hora de Visita',
                hintText: 'Seleccione la fecha y hora de la visita',
                icon: Icon(Icons.calendar_today),
              ),
              controller: TextEditingController(
                text: fechaVisita == null
                    ? ''
                    : DateFormat('yyyy-MM-dd HH:mm').format(fechaVisita!),
              ),
              validator: (value) => validarFormulario(value, 'fechaVisita'),
              onSaved: (String? value) {},
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Medio de Ingreso
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Medio de Ingreso',
            icon: Icon(Icons.directions_car),
            border: OutlineInputBorder(),
          ),
          value: medioIngreso.isEmpty ? null : medioIngreso,
          isExpanded: true,
          items: const [
            DropdownMenuItem(value: "Vehiculo", child: Text("Vehículo")),
            DropdownMenuItem(value: "Caminando", child: Text("Caminando ")),
          ],
          onChanged: (String? newValue) {
            setState(() {
              medioIngreso = newValue ?? "";  // Asigna el valor seleccionado
              if (medioIngreso != "Vehiculo") {
                imagenBase64 = null;  // Si el medio de ingreso no es vehículo, reseteamos la imagen
              }
            });
          },
          validator: (value) => validarFormulario(value, 'medioIngreso'),
        ),
        const SizedBox(height: 16),

        // Si el medio de ingreso es Vehículo
        if (medioIngreso == 'Vehiculo') ...[
          ElevatedButton(
            onPressed: _seleccionarImagen,
            child: Text('Seleccionar Imagen'),
          ),
          const SizedBox(height: 16),
          if (imagenBase64 != null) 
            Column(
              children: [
                Text('Imagen seleccionada:'),
                Image.memory(
                  base64Decode(imagenBase64!),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ],
            ),
        ],
      ],
    );
  }

  Widget _botones() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.only(bottom: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FilledButton.tonal(
                style: style,
                onPressed: _handleRegister,
                child: const Text('Registrar Visita', textAlign: TextAlign.center),
              ),


              FilledButton.tonal(
                style: style,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const VisitViewScreen()),
                  );
                },
                child: const Text('Ver visitas', textAlign: TextAlign.center),
              ),
            ],
          ),
        ],
      ),
    );
  }
}