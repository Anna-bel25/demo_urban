import 'package:demo_urban/modules/404/pages/page_404.dart';
import 'package:demo_urban/screens/home_page_screen.dart';
import 'package:demo_urban/screens/urban_resident/resident_view_screen.dart';
import 'package:demo_urban/screens/urban_visit/visit_view_screen.dart';
import 'package:demo_urban/screens/user/login_screen.dart';
import 'package:demo_urban/splash/pages/slplash_page.dart';
import 'package:flutter/material.dart';


class AppRoutes{
  static const initialRoute = '/splash';

  static Map<String, Widget Function(BuildContext)> routes ={
    '/splash' : (_) => const SplashPage(),
    '/login' : (_) => LoginPage(),
    '/residente' : (_) =>  ResidentViewScreen(),
    '/visitante' : (_) =>  VisitViewScreen(),
    '/home' : (_) => HomePage(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const PageNotFound(),
    );
  }
}
