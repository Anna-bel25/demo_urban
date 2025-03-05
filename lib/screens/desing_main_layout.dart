import 'dart:async';
import 'dart:developer';
import 'package:edukar/env/environment_company.dart';
import 'package:edukar/modules/home/models/home_response.dart';
import 'package:edukar/modules/home/service/home_service.dart';
import 'package:edukar/modules/security/login/models/login_response.dart';
import 'package:edukar/shared/helpers/responsive.dart';
import 'package:edukar/shared/providers/functional_provider.dart';
import 'package:edukar/shared/providers/student_provider.dart';
import 'package:edukar/shared/secure_storage/user_data_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../env/theme/app_theme.dart';
import '../../modules/class_schedule/models/schedule_class_response.dart';
import '../../modules/menu/page/menu_options.dart';
import 'alert_modal.dart';

class HomeLayoutWidget extends StatefulWidget {
  const HomeLayoutWidget({
    Key? key,
    required this.child,
    this.requiredStack = true,
    this.keyDismiss,
    this.nameInterceptor,
    this.hasScrollBody = false,
    this.onRefresh,
    this.scheduleResponse,
    this.showDownloadButton = false,
    this.isProfile = true,
    this.floatingActionButton,
    this.showFloatingButton = false,
    this.onClickButton,
  }) : super(key: key);

  final Widget child;
  final bool requiredStack;
  final GlobalKey<State<StatefulWidget>>? keyDismiss;
  final String? nameInterceptor;
  final bool? isProfile;
  final bool? hasScrollBody;
  final Future<void> Function()? onRefresh;
  final List<Clase>? scheduleResponse;
  final bool? showDownloadButton;
  final FloatingActionButton? floatingActionButton;
  final bool? showFloatingButton;
  final VoidCallback? onClickButton;

  @override
  State<HomeLayoutWidget> createState() => HomeLayoutWidgetState();
}

class HomeLayoutWidgetState extends State<HomeLayoutWidget> {
  ScrollController _scrollController = ScrollController();
  late FunctionalProvider fp;
  late StudentProvider sp;
  bool isActive = false;
  bool visible = false;
  LoginResponse? dataLogin;
  List<Estudiante> students = [];

  HomeResponse? homeResponse;
  List<HorarioHome> horarios = [];
  
  int _currentIndex = 0;
  final HomeService _homeService = HomeService();
  //HomeResponse _homeResponse = HomeResponse();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _scrollController = ScrollController();
    fp = Provider.of<FunctionalProvider>(context, listen: false);
    sp = Provider.of<StudentProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getDataStudent();
      //_getHome();
    });
    super.initState();
  }

  _getDataStudent() async {
    dataLogin = await UserDataStorage().getUserData();
    if (dataLogin != null && dataLogin!.informacion != null) {
        students = dataLogin!.informacion!.estudiantes!;
        log('Estudiantes: ${students.length}');
    } else {
        log('dataLogin o informacion es null');
    }
    setState(() {});
}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final responsive = Responsive(context);
    //final sp = Provider.of<StudentProvider>(context, listen: false);
    final config = EnvironmentCompany().config!;
    final iconSelect = context.watch<FunctionalProvider>().iconAppBarItem;
    final positionStudent = context.watch<StudentProvider>().positionStudent;

    return SafeArea(
        child: Scaffold(
          key: scaffoldKey,
          drawerEnableOpenDragGesture: true,
          endDrawer: Drawer(
            child: MenuOptionsPage(
              scaffoldKey: scaffoldKey,
            ),
          ),
          backgroundColor: AppTheme.backgroundHome,
          body: MediaQuery.withNoTextScaling(
            child: RefreshIndicator(
              displacement: 50,
              backgroundColor: AppTheme.backgroundHome,
              color: config.primaryColor,
              onRefresh:
                  (widget.onRefresh != null) ? widget.onRefresh! : () async {},
              child: Stack(
                children: [
                  widget.child,
                  if (widget.showFloatingButton!)
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: FloatingActionButton(
                        onPressed: widget.onClickButton,
                        backgroundColor: config.primaryColor,
                        child: const Icon(Icons.add),
                      ),
                    
                  ),
                  if (widget.requiredStack) const AlertModal(),
                ],
              ),
            ),
          ),
        ),
      
    );
    // return PopScope(
    //   canPop: false,
    //   onPopInvoked: (didPop) {
    //     if (Navigator.of(context).canPop()) {
    //       Navigator.of(context).pop();
    //     } else {
    //       log('No hay una página anterior en la pila de navegación');
    //     }
    //   },
    //   child: SafeArea(
    //     child: Scaffold(
    //       key: scaffoldKey,
    //       drawerEnableOpenDragGesture: true,
    //       endDrawer: Drawer(
    //         child: MenuOptionsPage(
    //           scaffoldKey: scaffoldKey,
    //         ),
    //       ),
    //       backgroundColor: AppTheme.backgroundHome,
    //       body: MediaQuery.withNoTextScaling(
    //         child: RefreshIndicator(
    //           displacement: 50,
    //           backgroundColor: AppTheme.backgroundHome,
    //           color: config.primaryColor,
    //           onRefresh:
    //               (widget.onRefresh != null) ? widget.onRefresh! : () async {},
    //           child: Stack(
    //             children: [
    //               widget.child,
    //               if (widget.showFloatingButton!)
    //                 Positioned(
    //                   bottom: 20,
    //                   right: 20,
    //                   child: FloatingActionButton(
    //                     onPressed: widget.onClickButton,
    //                     backgroundColor: config.primaryColor,
    //                     child: const Icon(Icons.add),
    //                   ),
                    
    //               ),
    //               if (widget.requiredStack) const AlertModal(),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
