import 'package:edukar/modules/activity/pages/circular_page.dart';
import 'package:edukar/modules/activity/pages/diary_page.dart';
import 'package:edukar/modules/client/models/client_model.dart';
import 'package:edukar/modules/notepad/pages/notepad.dart';
import 'package:edukar/modules/security/login/pages/login_page.dart';
import 'package:edukar/shared/helpers/global_helper.dart';
import 'package:edukar/shared/helpers/responsive.dart';
import 'package:edukar/shared/helpers/tutorial_coach_mark.dart';
import 'package:edukar/shared/helpers/tutorial_helper.dart';
import 'package:edukar/shared/providers/client_provider.dart';
import 'package:edukar/shared/providers/functional_provider.dart';
import 'package:edukar/shared/providers/student_provider.dart';
import 'package:edukar/shared/secure_storage/user_data_storage.dart';
import 'package:edukar/shared/widgets/alerts_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../../env/theme/app_theme.dart';
import '../../../shared/widgets/title.dart';
import '../../activity/pages/communications_page.dart';
import '../../assists/pages/assists_page.dart';
import '../../class_schedule/pages/class_schedule_page.dart';

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

    final iconSelect = context.watch<FunctionalProvider>().iconAppBarItem;
    //final isLargeScreen = size.width > 2550 && size.height > 1700;

    return Scaffold(
      backgroundColor: config!.secondaryColor,
      body: MediaQuery.withNoTextScaling(
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Stack(
            children: [
              Positioned(
                child: Image.asset(
                  config!.menuBackground2,
                  fit: BoxFit.fill,
                  width: size.width,
                  height: size.height * 0.2,
                  // width: size.width,
                  // height: size.height * 0.47,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(config!.menuBackground),
                    alignment: Alignment.bottomCenter,
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 45),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context, false);
                              },
                              child: Icon(
                                Icons.arrow_back_ios_outlined,
                                  color: AppTheme.white, size: size.height *0.0281 ,)),
                          InkWell(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            onTap: () {
                              widget.scaffoldKey!.currentState?.closeEndDrawer();
        
                              final keyAlertRemoveSession = GlobalHelper.genKey();
        
                              fp = Provider.of<FunctionalProvider>(
                                  widget.scaffoldKey!.currentState!.context,
                                  listen: false);
        
                              fp.showAlert(
                                key: keyAlertRemoveSession,
                                content: AlertGeneric(
                                  content: ConfirmContent(
                                    message:
                                        "Estás a punto de cerrar la sesión actual. ¿Deseas continuar?",
                                    cancel: () {
                                      fp.dismissAlert(key: keyAlertRemoveSession);
                                    },
                                    confirm: () {
                                      //GlobalHelper.logger.w(context.debugDoingBuild);
                                      //Navigator.pop(context, false);
                                      // sp.closeSession = true;
                                      sp.setCloseSession(true);
                                      //sp.setChangeStudent(false);
        
                                      fp.clearAllAlert();
                                      Navigator.pushAndRemoveUntil(
                                        widget.scaffoldKey!.currentState!.context,
                                        PageRouteBuilder(
                                          fullscreenDialog: true,
                                          reverseTransitionDuration:
                                              const Duration(milliseconds: 100),
                                          transitionDuration:
                                              const Duration(milliseconds: 100),
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
                                      fp.setIconAppBarItem(
                                          IconItems.iconMenuHome);
                                    },
                                  ),
                                ),
                              );
                            },
                            child:  Row(
                              children: [
                                Text('Cerrar Sesión',
                                    style: TextStyle(
                                        color: AppTheme.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.height * 0.0174),
                                    textAlign: TextAlign.right),
                                const SizedBox(width: 10),
                                 Icon(
                                  size: size.height * 0.0281,
                                  Icons.logout,
                                  color: AppTheme.white,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: size.height * 0.2,
                left: size.width * 0.63,
                child: _buildMenuItem(
                  svgImage: config!.iconDiary,
                  label: "Agenda",
                  containerSize: size.width * 0.1 + 70,
                  size: size,
                  onTap: () {
                    final diaryPageKey = GlobalHelper.genKey();
                    if (iconSelect == IconItems.iconMenuDiary) {
                      Navigator.pop(context, false);
                      return;
                    } else {
                      fp.setIconAppBarItem(IconItems.iconMenuDiary);
                      Navigator.pop(context, false);
                      fp.clearAllAlert();
                      fp.addPage(
                          key: diaryPageKey,
                          content: DiaryPage(
                              keyPage: diaryPageKey, key: diaryPageKey));
                    }
                  },
                ),
              ),
              Positioned(
                top: size.height * 0.77,
                left: size.width * 0.12,
                child: _buildMenuItem(
                    svgImage: config!.iconCircular,
                    label: "Circulares",
                    containerSize: size.width * 0.1 + 90,
                    size: size,
                    onTap: () {
                      final circularPageKey = GlobalHelper.genKey();
                      if (iconSelect == IconItems.iconCircular) {
                        Navigator.pop(context, false);
                        return;
                      } else {
                        fp.setIconAppBarItem(IconItems.iconCircular);
                        Navigator.pop(context, false);
                        fp.clearAllAlert();
                        fp.addPage(
                            key: circularPageKey,
                            content: CircularPage(
                                keyPage: circularPageKey, key: circularPageKey));
                      }
                    }),
              ),
              Positioned(
                top: size.height * 0.13,
                left: size.width * 0.26,
                child: _buildMenuItem(
                  svgImage: config!.iconHome,
                  label: "Inicio",
                  containerSize: size.width * 0.1 + 80,
                  size: size,
                  onTap: () {
                    if (iconSelect == IconItems.iconMenuHome) {
                      Navigator.pop(context, false);
                      return;
                    } else {
                      fp.clearAllAlert();
                      fp.setIconAppBarItem(IconItems.iconMenuHome);
                      Navigator.pop(context, false);
                    }
                  },
                ),
              ),
              Positioned(
                top: size.height * 0.33,
                left: size.width * 0.07,
                child: _buildMenuItem(
                  svgImage: config!.iconSchedule,
                  label: "Horario",
                  containerSize: size.width * 0.2 + 55,
                  size: size,
                  onTap: () {
                    final classSchedulesPageKey = GlobalHelper.genKey();
                    if (iconSelect == IconItems.iconMenuClassSchedule) {
                      Navigator.pop(context, false);
                      return;
                    } else {
                      fp.setIconAppBarItem(IconItems.iconMenuClassSchedule);
                      Navigator.pop(context, false);
                      fp.clearAllAlert();
                      fp.addPage(
                          key: classSchedulesPageKey,
                          content: ClassSchedulesPage(
                              keyPage: classSchedulesPageKey,
                              key: classSchedulesPageKey));
                    }
                  },
                ),
              ),
              Positioned(
                top: size.height * 0.4,
                left: size.width * 0.6,
                child: _buildMenuItem(
                  svgImage: config!.iconNotepad,
                  label: "Libreta",
                  containerSize: size.width * 0.1 + 80,
                  size: size,
                  onTap: () {
                    final keyNotepad = GlobalHelper.genKey();
                    if (iconSelect == IconItems.iconMenuNotepad) {
                      Navigator.pop(context, false);
                      return;
                    } else {
                      fp.setIconAppBarItem(IconItems.iconMenuNotepad);
                      Navigator.pop(context, false);
                      fp.clearAllAlert();
                      fp.addPage(
                          key: keyNotepad,
                          content:
                              NotepadPage(keyPage: keyNotepad, key: keyNotepad));
                    }
                  },
                ),
              ),
              Positioned(
                top: size.height * 0.56,
                left: size.width * 0.2,
                child: _buildMenuItem(
                  svgImage: config!.iconComunication,
                  label: "Comunicaciones",
                  containerSize: size.width * 0.14 + 90,
                  size: size,
                  onTap: () {
                    final keyComunication = GlobalHelper.genKey();
                    if (iconSelect == IconItems.iconMenuComunication) {
                      Navigator.pop(context, false);
                      return;
                    } else {
                      fp.setIconAppBarItem(IconItems.iconMenuComunication);
                      Navigator.pop(context, false);
                      fp.clearAllAlert();
                      fp.addPage(
                          key: keyComunication,
                          content: CommunicationPage(
                              keyPage: keyComunication, key: keyComunication));
                    }
                  },
                ),
              ),
              Positioned(
                top: size.height * 0.64,
                left: size.width * 0.69,
                child: _buildMenuItem(
                    svgImage: config!.iconAssists,
                    label: "Asistencias",
                    containerSize: size.width * 0.1 + 65,
                    size: size,
                    onTap: () {
                      final keyAssists = GlobalHelper.genKey();
                      if (iconSelect == IconItems.iconMenuAssits) {
                        Navigator.pop(context, false);
                        return;
                      } else {
                        fp.setIconAppBarItem(IconItems.iconMenuAssits);
                        Navigator.pop(context, false);
                        fp.clearAllAlert();
                        fp.addPage(
                            key: keyAssists,
                            content:
                            AssistsPage(
                              keyPage: keyAssists, key: keyAssists)
                            );
                      }
                    }),
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
                    color: config!.colorTextMenu, fontWeight: FontWeight.bold, fontSize: size.height * 0.017)),
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