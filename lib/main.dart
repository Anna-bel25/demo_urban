import 'package:demo_urban/providers/resident_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'helpers/database_helper.dart';
import 'providers/login_provider.dart';
import 'providers/register_provider.dart';
import 'providers/visit_provider.dart';
import 'screens/home_page_screen.dart';
import 'styles/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await DatabaseHelper.deleteUserDatabase();
  try {
    await DatabaseHelper.database;
    print("Base de datos inicializada correctamente.");
  } catch (e) {
    print("Error al inicializar la base de datos: $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => VisitProvider()),
        ChangeNotifierProvider(create: (_) => ResidentProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: themeData(),
      home: HomePage(),
      routes: {
        '/home': (context) => HomePage(),
      },
      initialRoute: '/home',
    );
  }
}
