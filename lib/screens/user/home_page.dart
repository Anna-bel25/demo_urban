import 'dart:async';
import 'dart:developer';
import 'package:edukar/env/environment_company.dart';
import 'package:edukar/env/theme/app_theme.dart';
import 'package:edukar/modules/home/models/home_response.dart';
import 'package:edukar/modules/home/service/home_service.dart';
import 'package:edukar/modules/menu/page/menu_options.dart';
import 'package:edukar/modules/notifications/pages/notifications_page.dart';
import 'package:edukar/modules/security/login/models/login_response.dart';
import 'package:edukar/shared/helpers/global_helper.dart';
import 'package:edukar/shared/helpers/responsive.dart';
import 'package:edukar/shared/providers/functional_provider.dart';
import 'package:edukar/shared/providers/student_provider.dart';
import 'package:edukar/shared/secure_storage/user_data_storage.dart';
import 'package:edukar/shared/widgets/cards/card_category.dart';
import 'package:edukar/shared/widgets/cards/card_client.dart';
import 'package:edukar/shared/widgets/cards/card_iconbutton.dart';
import 'package:edukar/shared/widgets/cards/card_tableproduct.dart';
import 'package:edukar/shared/widgets/home_layout.dart';
import 'package:edukar/shared/widgets/layout.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    this.onRefresh,
    this.isProfile,
    this.onSelectionChanged,
  }) : super(key: key);
  final Future<void> Function()? onRefresh;
  final bool? isProfile;
  final Function(List<HorarioHome>)? onSelectionChanged;
  //final GlobalKey<State<StatefulWidget>>? keyPage;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  ScrollController _scrollController = ScrollController();
  late FunctionalProvider fp;
  late StudentProvider sp;
  bool isActive = false;
  bool visible = false;
  LoginResponse? dataLogin;
  List<Estudiante> students = [];

  HomeResponse? homeResponse;
  List<HorarioHome> horarios = [];
  List<HorarioHome> selectedHorarios = [];

  final HomeService _homeService = HomeService();
  //HomeResponse _homeResponse = HomeResponse();
  
  // GlobalKey keyhomeNotificaiones = GlobalKey();
  // GlobalKey keyhomeMenu = GlobalKey();
  final GlobalKey<ScaffoldState> scaffoldHomeKey = GlobalKey<ScaffoldState>();

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

  _getHome() async {
    DateTime now = DateTime.now();
    String endDate = DateFormat('yyyy-MM-dd hh:mm:s')
        .format(now.add(const Duration(days: 1)));
    DateTime startDate = now.add(const Duration(days: 14));
    String startDateFormat = DateFormat('yyyy-MM-dd').format(startDate);

    final body = {"fechaDesde": startDateFormat, "fechaHasta": endDate};

    try {
      final response = await _homeService.getHomeInformation(context, body);

      if (!response.error) {
        homeResponse = response.data;
        log('homeResponse cargado: ${homeResponse.toString()}');
        _getDataHorario();
        setState(() {});
      } else {
        log('Error al cargar homeResponse: ${response.message}');
      }
    } catch (e) {
      log('Error al obtener datos: $e');
    }
  }

  _getDataHorario() async {
    if (homeResponse?.horarios != null) {
      horarios = homeResponse!.horarios!;
      log('Horarios: ${horarios.length}');
      if (horarios.isNotEmpty) {
        log('Primer profesor: ${horarios[3].profesorNombre}');
      } else {
        log('No hay horarios disponibles');
      }
    } else {
      log('homeResponse es null o no tiene horarios');
    }
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

    return LayoutWidget(
      child: Scaffold(
        key: scaffoldHomeKey,
        drawerEnableOpenDragGesture: true,
        endDrawer: Drawer(
          child: MenuOptionsPage(
            scaffoldKey: scaffoldHomeKey,
          ),
        ),
        backgroundColor: AppTheme.backgroundHome,
        body: MediaQuery.withNoTextScaling(
          child: RefreshIndicator(
            displacement: 50,
            backgroundColor: AppTheme.backgroundHome,
            color: config.primaryColor,
            onRefresh: (widget.onRefresh != null) ? widget.onRefresh! : () async {},
            child: Stack(
              children: [
                Row(
                  children: [
                    Expanded(
                        flex: 4.8.toInt(),
                        child: Stack(
                          children: [
                            CustomScrollView(
                              controller: _scrollController,
                              physics: (widget.isProfile ?? true)
                                  ? const AlwaysScrollableScrollPhysics()
                                  : const NeverScrollableScrollPhysics(),
          
                              // physics: !widget.isProfile!
                              //     ? const NeverScrollableScrollPhysics()
                              //     : const AlwaysScrollableScrollPhysics(),
                              slivers: [
                                SliverAppBar(
                                  surfaceTintColor: AppTheme.backgroundHome,
                                  automaticallyImplyLeading: false,
                                  floating: false,
                                  pinned: true,
                                  snap: false,
                                  toolbarHeight: 0,
                                  //toolbarHeight: size.height * 0.26,
                                  backgroundColor: AppTheme.backgroundHome,
                                  elevation: 0,
                                  centerTitle: true,
                                  //leadingWidth: size.width * 0.40,
                                  leading: SizedBox.shrink(),
                                  expandedHeight: size.height * 0.25,
                                  //expandedHeight: size.height * 0.32,
                                  iconTheme:
                                      IconThemeData(color: config.transparent),
          
                                  flexibleSpace: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CardClient(
                                        titlePrefix: 'Nombre',
                                        title: students.isNotEmpty
                                            ? students[positionStudent]
                                                .nombreEstudiante!
                                            : '',
                                        subtitlePrefix: 'Pararlelo',
                                        subtitle: students.isNotEmpty
                                            ? students[positionStudent]
                                                .paraleloFisico!
                                            : '',
                                        subtitles: [
                                          {
                                            'Grado': students.isNotEmpty
                                                ? students[positionStudent].grado!
                                                : ''
                                          },
                                          {
                                            'Aula': students.isNotEmpty
                                                ? students[positionStudent]
                                                    .paralelo!
                                                : ''
                                          }
                                        ],
                                      ),
                                      // Container(
                                      //   padding: EdgeInsets.only(
                                      //       top: 14, bottom: 4, left: 24),
                                      //   child: title(
                                      //       title: 'CATEGORIAS:',
                                      //       fontSize: responsive.dp(1.7)),
                                      // ),
                                    ],
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: Container(
                                    height: size.height * 0.72,
                                    //height: size.height * 0.64,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          //CardTableProduct(),
                                          //CardCategory(),
                                          CardCategory(
                                            onSelectionChanged: (List<HorarioHome> selected) {
                                              setState(() {
                                                selectedHorarios = selected;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                // SliverToBoxAdapter(
                                //   child: Container(
                                //     height: size.height * 0.64,
                                //     alignment: Alignment.center,
                                //     child: SingleChildScrollView(
                                //       child: Column(
                                //         children: [
                                //           CardCategory(),
                                //           //widget.child,
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      flex: 5.2.toInt(),
                      child: Stack(
                        children: [
                          CustomScrollView(
                              controller: _scrollController,
                              physics: (widget.isProfile ?? true)
                                  ? const AlwaysScrollableScrollPhysics()
                                  : const NeverScrollableScrollPhysics(),
          
                              // physics: !widget.isProfile!
                              //     ? const NeverScrollableScrollPhysics()
                              //     : const AlwaysScrollableScrollPhysics(),
                              slivers: [
                                SliverAppBar(
                                  surfaceTintColor: AppTheme.backgroundHome,
                                  automaticallyImplyLeading: false,
                                  floating: false,
                                  pinned: true,
                                  snap: false,
                                  toolbarHeight: 0,
                                  //toolbarHeight: size.height * 0.20,
                                  backgroundColor: AppTheme.backgroundHome,
                                  elevation: 0,
                                  centerTitle: true,
                                  leadingWidth: size.width * 0.70,
                                  leading: SizedBox.shrink(),
                                  expandedHeight: size.height * 0.20,
                                  iconTheme:
                                      IconThemeData(color: config.transparent),
          
                                  //leading: Column(
                                  flexibleSpace: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            //horarios.isNotEmpty? horarios[3].profesorNombre! : '',
                                            students.isNotEmpty
                                                ? students[positionStudent].grado!
                                                : '',
                                            style: TextStyle(
                                                color: config.primaryColor,
                                                fontSize: responsive.dp(1.2),
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, bottom: 28),
                                            child: Container(
                                              //color: config.secondaryColor,
                                              width: size.width * 0.25,
                                              //padding: EdgeInsets.all(8.0),
                                              decoration: const BoxDecoration(
                                                color: AppTheme.secondaryColor,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(16),
                                                  bottomLeft: Radius.circular(16),
                                                ),
                                              ),
                                              child: SingleChildScrollView(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(height: size.height * 0.09),
                                                    // SizedBox(
                                                    //     width:
                                                    //         size.width * 0.011),
                                                    Text(
                                                      //'CHIPECOMP S.A',
                                                      students.isNotEmpty
                                                          ? students[
                                                                  positionStudent]
                                                              .nCurso!
                                                          : '',
                                                      style: TextStyle(
                                                        color: config.white,
                                                        fontSize: responsive.dp(1.2),
                                                        fontWeight: FontWeight.w800,
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Container(
                                                          //height: size.height * 0.063,
                                                          decoration: BoxDecoration(
                                                            color: config.white,
                                                            borderRadius: BorderRadius.circular(50),
                                                          ),
                                                          child: IconButton(
                                                            onPressed: () {},
                                                            icon: Icon(
                                                              size: responsive.dp(1.5),
                                                              Icons.business_rounded,
                                                              color: config.primaryColor,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: size.width * 0.008),
                                                        IconButton(
                                                          onPressed: () {
                                                            scaffoldHomeKey.currentState
                                                                ?.openEndDrawer();
                                                          },
                                                          icon: Icon(
                                                            size: responsive.dp(1.5),
                                                            Icons.menu_rounded,
                                                            color: config.white,
                                                          ),
                                                        ),
                                                        // SizedBox(
                                                        //     width:
                                                        //         size.width * 0.015),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            SizedBox(width: size.width * 0.010),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Factura:',
                                                  style: TextStyle(
                                                    color: config.primaryColor,
                                                    fontSize: responsive.dp(1.2),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Text(
                                                  '006-854-655521000',
                                                  style: TextStyle(
                                                    color: config.primaryColor,
                                                    fontSize: responsive.dp(1.2),
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: size.width * 0.010),
                                            CardIconButton(
                                              onTap: () {
                                                if (iconSelect == IconItems.iconAppBarNotification)
                                                  return;
                                                fp.setIconAppBarItem(IconItems
                                                    .iconAppBarNotification);
                                                final notificationPageKey =
                                                    GlobalHelper.genKey();
                                                fp.clearAllAlert();
                                                fp.addPage(
                                                    key: notificationPageKey,
                                                    content: NotificationsPage(
                                                      keyPage: notificationPageKey,
                                                      key: notificationPageKey,
                                                    ));
                                              },
                                              icon: Icons.search,
                                              color: config.primaryColor,
                                              size: responsive.dp(2.5),
                                              iconSize: responsive.dp(1.2),
                                            ),
                                            //SizedBox(width: size.width * 0.018),
                                            CardIconButton(
                                              onTap: () {},
                                              icon: Icons.percent_rounded,
                                              color: config.primaryColor,
                                              size: responsive.dp(2.5),
                                              iconSize: responsive.dp(1.2),
                                            ),
                                            //SizedBox(width: size.width * 0.018),
                                            CardIconButton(
                                              onTap: () {},
                                              icon: Icons.keyboard,
                                              color: config.primaryColor,
                                              size: responsive.dp(2.5),
                                              iconSize: responsive.dp(1.2),
                                            ),
                                            //SizedBox(width: size.width * 0.018),
                                            CardIconButton(
                                              onTap: () {},
                                              icon: Icons.person_add_alt_outlined,
                                              color: config.primaryColor,
                                              size: responsive.dp(2.5),
                                              iconSize: responsive.dp(1.2),
                                            ),
                                            //SizedBox(width: size.width * 0.018),
                                            CardIconButton(
                                              onTap: () {},
                                              icon: Icons.groups_outlined,
                                              color: config.primaryColor,
                                              size: responsive.dp(2.5),
                                              iconSize: responsive.dp(1.2),
                                            ),
                                            //SizedBox(width: size.width * 0.018),
                                            CardIconButton(
                                              onTap: () {},
                                              icon: Icons.delete_forever_rounded,
                                              color: config.primaryColor,
                                              size: responsive.dp(2.5),
                                              iconSize: responsive.dp(1.2),
                                            ),
                                            //SizedBox(width: size.width * 0.018),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: Container(
                                    height: size.height * 0.76,
                                    //height: size.height * 0.64,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          CardTableProduct(selectedHorarios: selectedHorarios),
                                          SizedBox(height: size.height * 0.018),
                                          //CardTableProduct(selectedHorarios: selectedHorarios,),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
          
                                // SliverToBoxAdapter(
                                //   child: Container(
                                //     height: size.height * 0.76,
                                //     padding: EdgeInsets.all(10),
                                //     child: SingleChildScrollView(
                                //       child: Column(
                                //         crossAxisAlignment:
                                //             CrossAxisAlignment.start,
                                //         mainAxisAlignment:
                                //             MainAxisAlignment.spaceEvenly,
                                //         children: [
                                //           CardTableProduct(),
                                //           SizedBox(height: size.height * 0.018),
                                //           CardTableProduct(),
                                //           //CardTableProduct(),
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // ),
          
                                // SliverToBoxAdapter(
                                //   child: Container(
                                //     alignment: Alignment.center,
                                //     child: SingleChildScrollView(
                                //       child: Column(
                                //         children: [
                                //           widget.child,
                                //         ],
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ]),
                        ],
                      ),
                    ),
                  ],
                ),
                //if (widget.requiredStack) const AlertModal(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
