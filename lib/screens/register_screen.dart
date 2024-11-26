import 'package:demo_urban/screens/login_screen.dart';
import 'package:demo_urban/services/user_service.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../models/register_model.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulario de Registro',
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
      home: const RegisterPage(title: ' '),
    );
  }
}

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.title});
  final String title;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey  = GlobalKey<FormState>();
  final ButtonStyle style = FilledButton.styleFrom(textStyle: const TextStyle(fontSize: 16));
  String numeroCedula = "", contrasena = "", nombre = "", apellido = "";
  String rol = "";

  String? validarFormulario(String? value, String campo) {
    if (value == null || value.isEmpty) return 'Este campo es requerido!';

    final reglas = {
      'cedula': () => value.length != 10 ? 'La cédula debe tener 10 dígitos' : null,
      'contrasena': () => value.length < 6 ? 'La contraseña debe tener al menos 6 caracteres' : null,
      'nombre': () => !RegExp(r'^[a-zA-Z]+$').hasMatch(value) ? 'El nombre solo debe contener letras' : null,
      'apellido': () => !RegExp(r'^[a-zA-Z]+$').hasMatch(value) ? 'El apellido solo debe contener letras' : null,
      'rol': () => value.isEmpty ? 'Debe seleccionar un rol' : null,
    };

    return reglas[campo]?.call();
  }

  Future<void> _handleRegister(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      //RolUsuario rolEnum = RolUsuario.values.byName(rol.trim().toLowerCase());
      RolUsuario rolEnum = RolUsuario.values.byName(rol);

      final userService = UserService();
      final registerModel = RegisterModel(
        numeroCedula: numeroCedula,
        contrasena: contrasena,
        nombre: nombre,
        apellido: apellido,
        rol: rolEnum,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registrando...')),
      );

      final response = await userService.register(registerModel);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro exitoso')),
        );

        // Redirigir al login después del registro exitoso
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginForm()),
        );

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'])),
        );
      }

      _resetForm();
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: Color.fromARGB(185, 218, 224, 232),
        title: Text(widget.title),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyApp()),
            );
          },
        ),
      ),*/
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://images.unsplash.com/photo-1487083990731-52aaad54939a?q=80&w=1770&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.white.withOpacity(0.9),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18),
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
        ),
      ),
    );
  }


  Widget _formulario() {
    return Column(
      children: [
        const SizedBox(height: 15),
        Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const LoginForm()),
              ),
            ),
            Text(widget.title),
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const MyApp()),
              ),
            ),
          ],
          // children: [
          //   IconButton(
          //     icon: const Icon(Icons.arrow_back),
          //     onPressed: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => const LoginForm()),
          //       );
          //     },
          //   ),
          // ],
        ),
        const Text(
          'Registro',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 45),


        TextFormField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Número de Cédula',
            hintText: 'Ingrese su número de cédula',
            icon: Icon(Icons.numbers_outlined),
          ),
          validator: (value) => validarFormulario(value, 'cedula'),
          onSaved: (String? value) {
            numeroCedula = value ?? '';
          },
        ),
        const SizedBox(height: 16),


        TextFormField(
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Contraseña',
            hintText: 'Ingrese su contraseña',
            icon: Icon(Icons.password_outlined),
          ),
          validator: (value) => validarFormulario(value, 'contrasena'),
          onSaved: (String? value) {
            contrasena = value ?? '';
          },
        ),
        const SizedBox(height: 16),


        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Nombre',
            hintText: 'Ingrese su nombre',
            icon: Icon(Icons.person),
          ),
          validator: (value) => validarFormulario(value, 'nombre'),
          onSaved: (String? value) {
            nombre = value ?? '';
          },
        ),
        const SizedBox(height: 16),


        TextFormField(
          decoration: const InputDecoration(
            labelText: 'Apellido',
            hintText: 'Ingrese su apellido',
            icon: Icon(Icons.person),
          ),
          validator: (value) => validarFormulario(value, 'apellido'),
          onSaved: (String? value) {
            apellido = value ?? '';
          },
        ),
        const SizedBox(height: 16),


        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Rol',
            icon: Icon(Icons.person),
            border: OutlineInputBorder(),
          ),
          value: rol.isEmpty ? null : rol,
          isExpanded: false,
          items: const [
            DropdownMenuItem(value: "Visitante", child: Text("Visitante"),),
            DropdownMenuItem(value: "Residente", child: Text("Residente"),),
          ],
          onChanged: (String? newValue) {
            setState(() {
              rol = newValue ?? "";
            });
          },
          validator: (value) => validarFormulario(value, 'rol'),
        ),
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
                onPressed:  () {
                  _handleRegister(context);
                },
                child: const Text(
                  'Registrarse', 
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center
                ),
              ),


              // ElevatedButton(
              //   onPressed: () {
              //     _resetForm();
              //   },
              //   child: const Text('Borrar', textAlign: TextAlign.center),
              // ),


              // FilledButton.tonal(
              //   style: style,
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => const LoginForm()),
              //     );
              //   },
              //   child: const Text('Volver', textAlign: TextAlign.center),
              // ),
            ],
          ),
        ],
      ),
    );
  }

}