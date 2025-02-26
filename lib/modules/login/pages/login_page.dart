import 'package:edukar/env/theme/app_theme.dart';
import 'package:edukar/shared/helpers/responsive.dart';
import 'package:edukar/shared/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../shared/widgets/layout.dart';
import '../widget/form_login.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final responsive = Responsive.of(context);
    return LayoutWidget(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.isTablet ? 100 : 40,
          vertical: responsive.isTablet ? 100 : 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Hero(
                      tag: 'logo',
                      child: SvgPicture.asset(
                        config!.logoSplash,
                        width: responsive.isTablet
                            ? responsive.wp(30)
                            : responsive.wp(20),
                        height: responsive.isTablet
                            ? responsive.hp(30)
                            : responsive.hp(20),
                      ),
                    ),
                  ),
                  SizedBox(width: responsive.isTablet ? 50 : 50),
                  const Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // RichText(
                          //   textAlign: TextAlign.center,
                          //   text: TextSpan(
                          //     text:
                          //         'Para acceder por favor ingrese el usuario y contraseña de su ',
                          //     style: TextStyle(
                          //         color: config!.white,
                          //         fontSize: responsive.isTablet
                          //             ? responsive.dp(1.2)
                          //             : responsive.dp(0.8)),
                          //     children: const <TextSpan>[
                          //       TextSpan(
                          //         text: 'Portal de Padres',
                          //         style: TextStyle(fontWeight: FontWeight.bold),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          //SizedBox(height: responsive.isTablet ? 50 : 20),
                          FormLoginWidget(),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}