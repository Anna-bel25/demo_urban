import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:demo_urban/main.dart';
import '../../services/databse_service.dart';
import '../resident/resident_register.dart';
import '../visit/visit_register.dart';
import 'faceid_login.dart';
import 'register.dart';
import 'tradicional_login.dart';

class FingerprintLogin extends StatelessWidget {
  const FingerprintLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulario de Login',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 249, 252, 254),
        ),
        useMaterial3: true,
      ),
      home: const FingerprintLoginPage(title: ''),
    );
  }
}

class FingerprintLoginPage extends StatefulWidget {
  const FingerprintLoginPage({super.key, required this.title});
  final String title;

  @override
  State<FingerprintLoginPage> createState() => _FingerprintLoginPageState();
}

class _FingerprintLoginPageState extends State<FingerprintLoginPage> {
  final ButtonStyle style = FilledButton.styleFrom(textStyle: const TextStyle(fontSize: 16));
  final LocalAuthentication _auth = LocalAuthentication();
  String _authorized = 'Esperando autenticación';



  Future<void> _authenticateFingerPrint() async {
    bool authenticated = false;

    try {
      //soporta autenticación biometrica?
      bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      if (!canAuthenticateWithBiometrics) {
        setState(() {
          _authorized = 'Este dispositivo no soporta autenticación por huella digital.';
        });
        return;
      }

      setState(() {
        _authorized = 'Autenticando...';
      });

      // Intenta autenticar al usuario
      authenticated = await _auth.authenticate(
        localizedReason: 'Por favor, autentíquese usando su huella digital.',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        setState(() {
          _authorized = 'Autenticación exitosa';
        });

        // Obtiene el rol del usuario desde la base de datos
        final userData = await DatabaseAuth.getUser();
        final userRole = userData?['role'] ?? '';

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
        setState(() {
          _authorized = 'Autenticación fallida';
        });
      }
    } catch (e) {
      print("Error en la autenticación: $e");
      setState(() {
        _authorized = 'Error en la autenticación: $e';
      });

      // mensaje de error si es un problema con el canal nativo
      if (e is PlatformException && e.code == 'channel-error') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo conectar con el dispositivo para la autenticación biométrica.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hubo un error desconocido: $e')),
        );
      }
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://images.unsplash.com/photo-1533158326339-7f3cf2404354?q=80&w=1968&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.white.withOpacity(0.9),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Form(
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
              tooltip: 'Volver',
              onPressed: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const MyApp()),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.lock),
              tooltip: 'Inicio de sesión con Contraseña',
              onPressed: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const TraditionalLogin()),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.fingerprint),
              tooltip: 'Inicio de sesión con Huella Digital',
              onPressed: _authenticateFingerPrint,
            ),
            IconButton(
              icon: const Icon(Icons.face),
              tooltip: 'Inicio de sesión con Face ID',
              onPressed: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const FaceIDLogin()),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.person_add),
              tooltip: 'Crear cuenta',
              onPressed: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const RegisterForm()),
              ),
            ),
          ],
        ),
        const SizedBox(height: 80),
        const Text(
          'Iniciar sesión',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 45),
        Text(
          _authorized,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
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
            onPressed: _authenticateFingerPrint,
            child: const Text(
              'Autenticar con Huella Digital',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
