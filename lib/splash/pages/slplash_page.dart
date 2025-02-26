import 'package:demo_urban/.env/theme/app_theme.dart';
import 'package:demo_urban/modules/404/pages/page_404.dart';
import 'package:demo_urban/screens/home_page_screen.dart';
import 'package:demo_urban/shared/helpers/global_helper.dart';
import 'package:demo_urban/shared/models/login_response.dart';
import 'package:demo_urban/shared/providers/functional_provider.dart';
import 'package:demo_urban/shared/routes/app_routes.dart';
import 'package:demo_urban/shared/secure_storage/user_data_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _verifySessions();
    });
    super.initState();
  }

  void _verifySessions() async {
    final userSession = await UserDataStorage().getUserData();

    if (userSession != null) {
      _getNamePatient(data: userSession);
      Future.delayed(const Duration(seconds: 3), () => Navigator.pushAndRemoveUntil(context, GlobalHelper.navigationFadeIn(context, HomePage()), (route) => false));
    } else {
      Future.delayed(const Duration(seconds: 3), () => _goTo('/login'));
    }
  }

  _goTo(String routeName) {
    final route = AppRoutes.routes[routeName];
    final page = (route != null) ? route.call(context) : const PageNotFound();
    Navigator.push(
      context,
      PageRouteBuilder(
        fullscreenDialog: true,
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          var fadeTween = Tween(begin: 0.0, end: 1.0);
          var fadeAnimation = animation.drive(fadeTween);
          return FadeTransition(
            opacity: fadeAnimation,
            child: SlideTransition(
              position: offsetAnimation,
              child: child,
            ),
          );
        },
      ),
    );
  }

  _getNamePatient({required LoginResponse data}) async {
    final fp = Provider.of<FunctionalProvider>(context, listen: false);
    fp.saveUserName(data.primerNombrePaciente);
    fp.SaveUserImage(data.foto);
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme();
    final size = MediaQuery.of(context).size;

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.white,
        resizeToAvoidBottomInset: false,
        body: Container(
          height: size.height,
          width: size.width,
          alignment: FractionalOffset.center,
          decoration: const BoxDecoration(
            color: AppTheme.transparent,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Hero(
                tag: 'logo',
                child: SvgPicture.asset(theme.logoImagePathLight, width: size.width * 0.45),
              ),
            ],
          ),
        ),
      ),
    );
  }
}