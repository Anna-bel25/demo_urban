import 'package:demo_urban/main.dart';
import 'package:demo_urban/screens/resident_register_screen.dart';
import 'package:demo_urban/screens/visit_register_screen.dart';
import 'package:flutter/material.dart';
import '../models/login_model.dart';
import '../services/user_service.dart';
import 'register_screen.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulario de Login',
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
      home: const LoginPage(title: ' '),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final ButtonStyle style = FilledButton.styleFrom(textStyle: const TextStyle(fontSize: 16));
  String numeroCedula = "", contrasena = "" ;

  String? validarFormulario(String? value, String campo) {
    if (value == null || value.isEmpty) return 'Este campo es requerido!';

    final reglas = {
      'cedula': () => value.length != 10 ? 'La cédula debe tener 10 dígitos' : null,
      'contrasena': () => value.length < 6 ? 'La contraseña debe tener al menos 6 caracteres' : null,
    };

    return reglas[campo]?.call();
  }

  Future<void> _handleLogin(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final loginService = UserService();
      final loginModel = LoginModel(
        numeroCedula: numeroCedula,
        contrasena: contrasena,
        metodoAutenticacion: 'Tradicional', // Establecer el método de autenticación
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Iniciando sesión...')),
      );

      final response = await loginService.login(loginModel);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();

      if (response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inicio de sesión exitoso')),
        );

        // Obtener el rol del usuario
        final userRole = loginService.userRoles.isNotEmpty ? loginService.userRoles.last : "";

        // Redirigir según el rol
        if (userRole == 'Residente') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ResidentRegisterScreen()),
          );
        } else if (userRole == 'Visitante') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const VisitRegisterScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Rol de usuario desconocido')),
          );
        }

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
            image: NetworkImage('https://images.unsplash.com/photo-1576502202167-791eca35a78d?q=80&w=1781&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
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
        mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                );
              },
            ),
          ],
        ),
        const Text(
          'Inicio de sesión',
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
        const SizedBox(height: 20),

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
          FilledButton.tonal(
            style: style,
            onPressed: () {
              _handleLogin(context);
            },
            child: const Text(
              'Iniciar Sesión',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),

          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterForm()),
              );
            },
            child: const Text('¿No tienes una cuenta? Regístrate aquí'),
          ),

        ],
      ),
    );
  }

}