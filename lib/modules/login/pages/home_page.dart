import 'dart:developer';

import 'package:edukar/env/theme/app_theme.dart';
import 'package:edukar/shared/helpers/responsive.dart';
import 'package:edukar/shared/helpers/tutorial_coach_mark.dart';
import 'package:edukar/shared/providers/tutorial_provider.dart';
import 'package:edukar/shared/widgets/cards/card_product.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../modules/home/models/home_response.dart';
import '../../../modules/home/service/home_service.dart';
import '../../../modules/home/widget/indicator_carrousel.dart';
import '../../../modules/home/widget/skeleaton_schedule.dart';
import '../../../shared/helpers/global_helper.dart';
import '../../../shared/providers/functional_provider.dart';
import '../../../shared/providers/student_provider.dart';
import '../../../shared/widgets/cards/card_teacher.dart';
import '../../../shared/widgets/home_layout.dart';
import '../../../shared/widgets/title.dart';
import '../widget/list_activity.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  //final GlobalKey<State<StatefulWidget>>? keyPage;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final HomeService _homeService = HomeService();
  HomeResponse? _homeResponse;
  bool _screenActive = false;

  //final TutorialHelperHome tutorialHelper = TutorialHelperHome();
  GlobalKey keyhomeAtencion = GlobalKey();
  GlobalKey keyhomeActividades = GlobalKey();
  final GlobalKey<HomeLayoutWidgetState> homeLayoutKey = GlobalKey();

  @override
  void initState() {
    GlobalHelper().trackScreen("Pantalla de Inicio/Home");
    //super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sp = Provider.of<StudentProvider>(context, listen: false);
      //sp.closeSession = false;
      sp.setCloseSession(false);
      _getHome();
    });
    
    super.initState();
  }

  void _getService({required StudentProvider sp}) {
    sp.changeStudent = false;
    _homeResponse = null;
    _currentIndex = 0;
    _getHome();
  }

  _getHome() async {
    DateTime now = DateTime.now();
    String endDate = DateFormat('yyyy-MM-dd hh:mm:s')
        .format(now.add(const Duration(days: 1)));
    DateTime startDate = now.add(const Duration(days: 14));
    String startDateFormat = DateFormat('yyyy-MM-dd').format(startDate);

    final body = {"fechaDesde": startDateFormat, "fechaHasta": endDate};

    final response = await _homeService.getHomeInformation(context, body);

    if (!response.error) {
      _homeResponse = response.data;
      setState(() {});
    } else {
      debugPrint('No hay información');
    }
  }

  Widget _skeletonTabs() {
    return _homeResponse == null
        ? skeleatonSchedules(context)
        : const Text('Hubo un error en la ejecución');
  }


  void showTutorial() async {
    if (!mounted) return;
    final targets = TutorialCoachMarkHelper.getTargets(
      keys: {
        "keyhomeActividades": keyhomeActividades,
        "keyhomeAtencion": keyhomeAtencion,
      },
      texts: {
        "keyhomeActividades": "lorem",
        "keyhomeAtencion": "lorem",
      },
    );

    if (!mounted) return;
    TutorialCoachMarkHelper.showTutorial(
      targets: targets,
      context: context,
      onFinish: () {
        TutorialCoachMarkHelper.setTutorialVisto('HomePage');
      },
    );
  }
  

  @override
  Widget build(BuildContext context) {
    final tutorialProvider = Provider.of<TutorialProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;
    final responsive = Responsive(context);
    const double heightTablet = 1080;
    int maxDots = _homeResponse != null ? _homeResponse!.horarios!.length : 0;

    return HomeLayoutWidget(
      onRefresh: () async {
        await Future.delayed(
          const Duration(milliseconds: 600),
          () {
            setState(() {
              _homeResponse == null;
              maxDots = 0;
              _currentIndex = 0;
              _homeResponse!.horarios = [];
              _homeResponse!.listDetails = [];
            });
            _getHome();
          },
        );
      },
      nameInterceptor: 'home',
      key: homeLayoutKey,
      isProfile: true,
      // showFloatingButton: true,
      // onClickButton: () async {
      //   final homeLayoutState = homeLayoutKey.currentState;
      //   if (homeLayoutState != null) {
      //     print("HomeLayoutState encontrado");
      //     await homeLayoutState.showTutorial();
      //   }
      //   showTutorial();
      // },
      child: Consumer2<StudentProvider, FunctionalProvider>(
        builder: (context, sp, fp, child) {
          if (!sp.closeSession) {
            if (sp.changeStudent) {
              GlobalHelper.logger
                  .w('Entro a la validación de cambio de estudiante');
              if (fp.alerts.isNotEmpty) {
                _screenActive = true;
                GlobalHelper.logger.w('Hay alertas levantadas');
              } else {
                _getService(sp: sp);
                GlobalHelper.logger.w('Se ejecutó el servicio');
              }
            }
            if (fp.alerts.isEmpty && _screenActive == true) {
              GlobalHelper.logger.w('ultima validacion');
              _getService(sp: sp);
              _screenActive = false;
            }
          } else {
            sp.changeStudent = false;
            GlobalHelper.logger.w('entro al else');
          }

          return Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  key: keyhomeAtencion,
                  child: title(
                    //key: keyhomeAtencion,
                    title: 'CATEGORIAS:', 
                    fontSize: responsive.dp(1.7)
                  ),
                ),
                SizedBox(height: size.height * 0.01),
                _homeResponse != null
                    ? _homeResponse!.horarios!.isNotEmpty
                        //AGREGAR EL KEY
                        ? Column(
                            children: [
                              GridView.builder(
                                padding: EdgeInsets.only(top: 5, bottom: 5),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: responsive.isTablet ? 3 : 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 0.9,
                                ),
                                itemCount: _homeResponse!.horarios!.length,
                                itemBuilder: (context, index) {
                                  final horario = _homeResponse!.horarios![index];
                                  return CardProduct(
                                    title: horario.materiaNombre ?? '',
                                    horario: horario,
                                    index: index,
                                    onTap: () {
                                      log("tap: ${horario.materiaNombre}");
                                    },
                                  );
                                },
                              ),
                            ],
                          )
                        : Align(
                            child: Text(
                            "No hay categorias disponibles.",
                            style: TextStyle(
                                color: config!.dateNotification,
                                fontWeight: FontWeight.bold),
                          ))
                    // : skeleatonSchedules()
                    : _skeletonTabs(),
                SizedBox(height: size.height * 0.01),
                // SizedBox(
                //   key:keyhomeActividades, 
                //   child: title(
                //     //key:keyhomeActividades, 
                //     title: 'ACTIVIDADES:', 
                //     fontSize: responsive.dp(1.7)
                //   ),
                // ),
                // SizedBox(height: size.height * 0.01),
                // _homeResponse != null
                //     ? (_homeResponse!.listDetails!.isNotEmpty)
                //         ? ListActivityWidget(
                //             activity: _homeResponse!.listDetails,
                //           )
                //         : Center(
                //             child: Padding(
                //             padding: EdgeInsets.symmetric(vertical: 30),
                //             child: Text(
                //               'No existen actividades en este momento',
                //               style: TextStyle(
                //                   color: AppTheme.hinText,
                //                   fontSize: responsive.dp(1.8)),
                //             ),
                //           ))
                //     : Container(),
              ],
            ),
          );
        },
      ),
    );
  }

  
}
