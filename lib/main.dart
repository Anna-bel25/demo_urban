import 'package:demo_urban/.env/enviroment.dart';
import 'package:demo_urban/.env/theme/app_theme.dart';
import 'package:demo_urban/providers/resident_provider.dart';
import 'package:demo_urban/shared/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'helpers/database_helper.dart';
import 'providers/login_provider.dart';
import 'providers/register_provider.dart';
import 'providers/visit_provider.dart';
import 'screens/home_page_screen.dart';
import 'styles/theme.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await DatabaseHelper.deleteUserDatabase();
  // try {
  //   await DatabaseHelper.database;
  //   print("Base de datos inicializada correctamente.");
  // } catch (e) {
  //   print("Error al inicializar la base de datos: $e");
  // }
  String environment = const String.fromEnvironment('ENVIRONMENT', defaultValue: Environment.prod);
  Environment().initConfig(environment);
  initializeDateFormatting('es');
  SystemChrome.setPreferredOrientations([ DeviceOrientation.portraitUp, DeviceOrientation.portraitDown ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appName = Environment().config?.appName ?? 'name app default';

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RegisterProvider()),
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => VisitProvider()),
        ChangeNotifierProvider(create: (_) => ResidentProvider()),
      ],
      child: MaterialApp(
        title: appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme().theme(),
        initialRoute: AppRoutes.initialRoute,
        routes: AppRoutes.routes,
        onGenerateRoute: AppRoutes.onGenerateRoute
      ),
    );
  }
}
