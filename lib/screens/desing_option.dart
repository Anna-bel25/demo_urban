import 'package:edukar/modules/security/login/pages/login_page.dart';
import 'package:edukar/shared/helpers/global_helper.dart';
import 'package:edukar/shared/helpers/responsive.dart';
import 'package:edukar/shared/providers/functional_provider.dart';
import 'package:edukar/shared/providers/student_provider.dart';
import 'package:edukar/shared/secure_storage/user_data_storage.dart';
import 'package:edukar/shared/widgets/alerts_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../env/theme/app_theme.dart';
import '../../../shared/widgets/title.dart';

class MenuOptionsPage extends StatefulWidget {
  final GlobalKey<ScaffoldState>? scaffoldKey;
  const MenuOptionsPage({Key? key, this.scaffoldKey}) : super(key: key);

  @override
  State<MenuOptionsPage> createState() => _MenuOptionsPageState();
}

class _MenuOptionsPageState extends State<MenuOptionsPage> {
  late FunctionalProvider fp;
  late StudentProvider sp;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fp = Provider.of<FunctionalProvider>(context, listen: false);
      sp = Provider.of<StudentProvider>(context, listen: false);
    });
    GlobalHelper().trackScreen("Pantalla de Menú de Opciones");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final responsive = Responsive(context);
    final iconSelect = context.watch<FunctionalProvider>().iconAppBarItem;
    //final isLargeScreen = size.width > 2550 && size.height > 1700;

    return Scaffold(
      backgroundColor: config!.white,
      body: MediaQuery.withNoTextScaling(
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Stack(
            children: [
              Container(
                alignment: Alignment.topRight,
                child: Padding(
                  // padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 45),
                  padding: EdgeInsets.only(
                      left: size.width * 0.02,
                      right: size.width * 0.02,
                      top: size.height * 0.07,
                      bottom: size.height * 0.07),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // title(
                          //   title: 'GESTIÓN ADMINISTRATIVA', 
                          //   fontSize: responsive.dp(1.2),
                          // ),
                          Text('GESTIÓN ADMINISTRATIVA', style: TextStyle(
                            color: config!.primaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: responsive.dp(1.2),
                          ),),
                          Padding(
                            padding: const EdgeInsets.only(top: 18, bottom: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GestureDetector(
                                onTap: () {
                                  Navigator.pop(context, false);
                                },
                                child: Icon(
                                  Icons.arrow_back_ios_outlined,
                                  color: AppTheme.primaryColor, size: size.height *0.0181 ,)),
                                Spacer(),
                                
                                InkWell(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  onTap: () {widget.scaffoldKey!.currentState?.closeEndDrawer();
                                  final keyAlertRemoveSession = GlobalHelper.genKey();
                                  fp = Provider.of<FunctionalProvider>(
                                    widget.scaffoldKey!.currentState!.context, listen: false);
                                        
                                    fp.showAlert(
                                      key: keyAlertRemoveSession,
                                      content: AlertGeneric(
                                        content: ConfirmContent(
                                          message: "Estás a punto de cerrar la sesión actual. ¿Deseas continuar?",
                                          cancel: () { fp.dismissAlert(key: keyAlertRemoveSession);},
                                          confirm: () {
                                            sp.setCloseSession(true);
                                            fp.clearAllAlert();
                                            Navigator.pushAndRemoveUntil(
                                              widget.scaffoldKey!.currentState!.context,
                                              PageRouteBuilder(
                                                fullscreenDialog: true,
                                                reverseTransitionDuration: Duration(milliseconds: 100),
                                                transitionDuration: Duration(milliseconds: 100),
                                                pageBuilder: (context, animation, _) =>
                                                  FadeTransition(
                                                  opacity: animation,
                                                  child: const LoginPage(),
                                                ),
                                              ),
                                              (route) => false,
                                            );
                                            sp.setPositionStudent(0);
                                            UserDataStorage().removeDataLogin();
                                            UserDataStorage().removeSelected();
                                            fp.setIconAppBarItem(IconItems.iconMenuHome);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  child:  Row(
                                    children: [
                                      Text('Buscar factura', style: TextStyle(
                                        color: config!.primaryColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: responsive.dp(0.9),
                                      ),),
                                      const SizedBox(width: 10),
                                      Icon(
                                        size: size.height * 0.0281,
                                        Icons.fact_check,
                                        color: AppTheme.primaryColor,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(color: AppTheme.dividerColor,),


                          Padding(
                            padding: const EdgeInsets.only(top: 6, bottom: 6),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                GestureDetector(
                                onTap: () {
                                  Navigator.pop(context, false);
                                },
                                child: Icon(
                                  Icons.arrow_back_ios_outlined,
                                  color: AppTheme.primaryColor, size: size.height *0.0181 ,)),
                                Spacer(),
                            
                                InkWell(
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  onTap: () {widget.scaffoldKey!.currentState?.closeEndDrawer();
                                  final keyAlertRemoveSession = GlobalHelper.genKey();
                                  fp = Provider.of<FunctionalProvider>(
                                    widget.scaffoldKey!.currentState!.context, listen: false);
                                        
                                    fp.showAlert(
                                      key: keyAlertRemoveSession,
                                      content: AlertGeneric(
                                        content: ConfirmContent(
                                          message: "Estás a punto de cerrar la sesión actual. ¿Deseas continuar?",
                                          cancel: () { fp.dismissAlert(key: keyAlertRemoveSession);},
                                          confirm: () {
                                            sp.setCloseSession(true);
                                            fp.clearAllAlert();
                                            Navigator.pushAndRemoveUntil(
                                              widget.scaffoldKey!.currentState!.context,
                                              PageRouteBuilder(
                                                fullscreenDialog: true,
                                                reverseTransitionDuration: Duration(milliseconds: 100),
                                                transitionDuration: Duration(milliseconds: 100),
                                                pageBuilder: (context, animation, _) =>
                                                  FadeTransition(
                                                  opacity: animation,
                                                  child: const LoginPage(),
                                                ),
                                              ),
                                              (route) => false,
                                            );
                                            sp.setPositionStudent(0);
                                            UserDataStorage().removeDataLogin();
                                            UserDataStorage().removeSelected();
                                            fp.setIconAppBarItem(IconItems.iconMenuHome);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  child:  Row(
                                    children: [
                                      Text('Eliminar factura', style: TextStyle(
                                        color: config!.primaryColor,
                                        fontWeight: FontWeight.w400,
                                        fontSize: responsive.dp(0.9),
                                      ),),
                                      const SizedBox(width: 10),
                                      Icon(
                                        size: size.height * 0.0281,
                                        Icons.fact_check_outlined,
                                        color: AppTheme.primaryColor,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(color: AppTheme.dividerColor,),
                        ],
                      ),
                      
                      Text('data'),
                      Text('data'),
                    ],
                  ),
                ),
              ),

              Positioned(
                top: size.height * 0.8,
                left: size.width * 0.76,
                child: SvgPicture.asset(
                  config!.cargando,
                  fit: BoxFit.fill,
                  height: size.height * 0.12,
                ),
              ),

              // if (isLargeScreen)
              //   Positioned(
              //     top: size.height * 0.9,
              //     left: size.width * 0.82,
              //     child: _buildMenuItemFilled(size.width * 0.1 + 29),
              //   ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildMenuItem(
      {required String svgImage,
      required String label,
      required double containerSize,
      required Size size,
      void Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        //key: keymenuGeneral,
        width: containerSize,
        height: containerSize,
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(svgImage,
                height: containerSize * 0.4,
                colorFilter:
                    ColorFilter.mode(config!.primaryColor, BlendMode.srcIn)),
            const SizedBox(height: 8),
            Text(label,
                style: TextStyle(
                    color: config!.colorTextMenu,
                    fontWeight: FontWeight.bold,
                    fontSize: size.height * 0.017)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItemFilled(double containerSize) {
    return Container(
        width: containerSize,
        height: containerSize,
        decoration: BoxDecoration(
          color: config!.colorMenu,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const SizedBox());
  }
}
