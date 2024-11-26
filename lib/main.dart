import 'package:demo_urban/screens/login_screen.dart';
import 'package:demo_urban/services/databse_service.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await DatabaseAuth.deleteUserDatabase();

  try {
    await DatabaseAuth.database;
    print("Base de datos inicializada correctamente.");
  } catch (e) {
    print("Error initializing database: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo Urban Visitantes',
      theme: ThemeData(
        colorScheme:  ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 249, 252, 254),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* appBar: AppBar(
        backgroundColor: Color.fromARGB(185, 218, 224, 232),
        title: Text(title),
      ),*/
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1732278881253-ed69fb34e01e?q=80&w=1843&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          // Contenido de la pantalla
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _title(context),
              ],
            ),
          ),
        ],
      ),
    );

  }


  Widget _title(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Bienvenido',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginForm()),
            );
          },
        child: const Text('Ir a Iniciar sesión'),
        ),
      ]
    );
  }


}