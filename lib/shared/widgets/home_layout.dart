import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:edukar/env/environment_company.dart';
import 'package:edukar/modules/home/pages/home_page.dart';
import 'package:edukar/modules/notifications/pages/notifications_page.dart';
import 'package:edukar/modules/security/login/models/login_response.dart';
import 'package:edukar/shared/helpers/global_helper.dart';
import 'package:edukar/shared/helpers/responsive.dart';
import 'package:edukar/shared/helpers/tutorial_coach_mark.dart';
import 'package:edukar/shared/providers/functional_provider.dart';
import 'package:edukar/shared/providers/student_provider.dart';
import 'package:edukar/shared/providers/tutorial_provider.dart';
import 'package:edukar/shared/secure_storage/user_data_storage.dart';
import 'package:edukar/shared/widgets/cards/card_client.dart';
import 'package:edukar/shared/widgets/cards/card_iconbutton.dart';
import 'package:edukar/shared/widgets/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../env/theme/app_theme.dart';
import '../../modules/class_schedule/models/schedule_class_response.dart';
import '../../modules/menu/page/menu_options.dart';
import 'alert_modal.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  bool isActive = false;
  bool visible = false;
  LoginResponse? dataLogin;
  List<Estudiante> students = [];

  // GlobalKey keyhomeNotificaiones = GlobalKey();
  // GlobalKey keyhomeMenu = GlobalKey();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _scrollController = ScrollController();
    fp = Provider.of<FunctionalProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getDataStudent();
      //showTutorial();
    });
    super.initState();
  }

  _getDataStudent() async {
    dataLogin = await UserDataStorage().getUserData();
    students = dataLogin!.informacion!.estudiantes!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print("showFloatingButton: ${widget.showFloatingButton}");
    final size = MediaQuery.of(context).size;
    final responsive = Responsive(context);
    //final sp = Provider.of<StudentProvider>(context, listen: false);
    final config = EnvironmentCompany().config!;
    final iconSelect = context.watch<FunctionalProvider>().iconAppBarItem;
    final positionStudent = context.watch<StudentProvider>().positionStudent;

    return Scaffold(
      key: scaffoldKey,
      drawerEnableOpenDragGesture: false,
      drawer: MenuOptionsPage(
        scaffoldKey: scaffoldKey,
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
              Row(
                children: [
                  Expanded(
                      flex: 4.8.toInt(),
                      child: Stack(
                        children: [
                          CustomScrollView(
                            controller: _scrollController,
                            physics: !widget.isProfile!
                                ? const NeverScrollableScrollPhysics()
                                : const AlwaysScrollableScrollPhysics(),
                            slivers: [
                              SliverAppBar(
                                expandedHeight: 180,
                                pinned: true,
                                //leading: Container(),
                                automaticallyImplyLeading: false,
                                flexibleSpace: FlexibleSpaceBar(
                                  background: Container(
                                    color: AppTheme.backgroundHome,
                                    //width: size.width * 0.011,
                                    child: CardClient(
                                      titlePrefix: 'Nombre:', 
                                      title: students.isNotEmpty
                                          ? students[positionStudent].nombreEstudiante!
                                          : '',
                                      subtitlePrefix: 'Pararlelo',
                                      subtitle: students.isNotEmpty
                                          ? students[positionStudent].paraleloFisico!
                                          : '',
                                      
                                      
                                      subtitles: [
                                        {
                                          'Grado': students.isNotEmpty
                                              ? students[positionStudent].grado!
                                              : ''
                                        },
                                        {
                                          'Paralelo': students.isNotEmpty
                                              ? students[positionStudent].paralelo!
                                              : ''
                                        }
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          widget.child,
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ],
                      )),
                  Expanded(
                    flex: 5.2.toInt(),
                    child: Stack(
                      children: [
                        CustomScrollView(
                            controller: _scrollController,
                            physics: !widget.isProfile!
                                ? const NeverScrollableScrollPhysics()
                                : const AlwaysScrollableScrollPhysics(),
                            slivers: [
                              SliverAppBar(
                                floating: true,
                                pinned: true,
                                snap: false,
                                toolbarHeight: size.height * 0.09,
                                backgroundColor: AppTheme.backgroundHome,
                                elevation: 0,
                                centerTitle: true,
                                leadingWidth: size.width * 0.70,
                                leading: Padding(
                                      padding: EdgeInsets.only(left: 30),
                                      child: Column( 
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [ 
                                          Text(
                                            'Factura:',
                                            style: TextStyle(
                                              color: config.secondaryColor,
                                              fontSize: responsive.dp(1.5),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            '006-854-655521000',
                                            style: TextStyle(
                                              color: config.secondaryColor,
                                              fontSize: responsive.dp(1.5),
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                actions: [
                                  SizedBox(width: size.width * 0.018),
                                  Row(
                                    children: [
                                      Container(
                                        //color: config.secondaryColor,
                                        width: size.width * 0.25,
                                        padding: EdgeInsets.all(8.0),
                                        decoration: const BoxDecoration(
                                          color: AppTheme.secondaryColor,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16),
                                            bottomLeft: Radius.circular(16),
                                          ),
                                        ),
                                        child: SingleChildScrollView(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              SizedBox(
                                                  width: size.width * 0.018),
                                              Text(
                                                'EMPRESA',
                                                style: TextStyle(
                                                  color: config.white,
                                                  fontSize: responsive.dp(1.5),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                  width: size.width * 0.018),
                                              Container(
                                                //height: size.height * 0.063,
                                                decoration: BoxDecoration(
                                                  color: config.white,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: IconButton(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                    size: responsive.dp(2.5),
                                                    Icons.business_rounded,
                                                    color:
                                                        config.secondaryColor,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                  width: size.width * 0.018),
                                              IconButton(
                                                onPressed: () {
                                                  scaffoldKey.currentState
                                                      ?.openDrawer();
                                                },
                                                icon: Icon(
                                                  size: responsive.dp(2.5),
                                                  Icons.menu_rounded,
                                                  color: config.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SliverToBoxAdapter(
                                //child: SizedBox(height: widget.isProfile! ? 0 : 40),
                                child: Container(
                                  color: AppTheme.backgroundHome,
                                  height: size.height * 0.17,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(width: size.width * 0.018),
                                      CardIconButton(
                                        onTap: () {},
                                        icon: Icons.search,
                                        color: config.secondaryColor,
                                        size: responsive.dp(4.5),
                                        iconSize: responsive.dp(1.5),
                                      ),
                                      SizedBox(width: size.width * 0.018),
                                      CardIconButton(
                                        onTap: () {},
                                        icon: Icons.percent_rounded,
                                        color: config.secondaryColor,
                                        size: responsive.dp(4.5),
                                        iconSize: responsive.dp(1.5),
                                      ),
                                      SizedBox(width: size.width * 0.018),
                                      CardIconButton(
                                        onTap: () {},
                                        icon: Icons.keyboard,
                                        color: config.secondaryColor,
                                        size: responsive.dp(4.5),
                                        iconSize: responsive.dp(1.5),
                                      ),
                                      SizedBox(width: size.width * 0.018),
                                      CardIconButton(
                                        onTap: () {},
                                        icon: Icons.person_add_alt_outlined,
                                        color: config.secondaryColor,
                                        size: responsive.dp(4.5),
                                        iconSize: responsive.dp(1.5),
                                      ),
                                      SizedBox(width: size.width * 0.018),
                                      CardIconButton(
                                        onTap: () {},
                                        icon: Icons.groups_outlined,
                                        color: config.secondaryColor,
                                        size: responsive.dp(4.5),
                                        iconSize: responsive.dp(1.5),
                                      ),
                                      SizedBox(width: size.width * 0.018),
                                      CardIconButton(
                                        onTap: () {},
                                        icon: Icons.delete_forever_rounded,
                                        color: config.secondaryColor,
                                        size: responsive.dp(4.5),
                                        iconSize: responsive.dp(1.5),
                                      ),
                                      SizedBox(width: size.width * 0.018),
                                    ],
                                  ),
                                ),
                              ),
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
              if (widget.requiredStack) const AlertModal(),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedItemBouncyWidget extends StatefulWidget {
  final Widget child;
  final Alignment align;
  final bool isActive = false;
  final int millisecondsDelay;
  final int millisecondsAnimated;

  const AnimatedItemBouncyWidget({
    super.key,
    required this.child,
    this.align = Alignment.center,
    this.millisecondsDelay = 300,
    this.millisecondsAnimated = 500,
    // this.listenerChange = false
  });

  @override
  _AnimatedItemBouncyWidgetState createState() =>
      _AnimatedItemBouncyWidgetState();
}

class _AnimatedItemBouncyWidgetState extends State<AnimatedItemBouncyWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _valueAnimate;

  bool shouldRestartAnimation = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.millisecondsAnimated),
    )..repeat(reverse: true);
    _valueAnimate = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.isAnimating ? _controller.stop() : null;
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _valueAnimate,
      builder: (context, child) {
        return Transform.scale(
          scale: _valueAnimate.value,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
