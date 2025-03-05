import 'dart:convert';
import 'dart:developer';

import 'package:edukar/shared/helpers/responsive.dart';
import 'package:edukar/shared/widgets/cards/card_product.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../modules/home/models/home_response.dart';
import '../../../modules/home/service/home_service.dart';
import '../../../shared/helpers/global_helper.dart';
import '../../../shared/providers/functional_provider.dart';
import '../../../shared/providers/student_provider.dart';
import '../../../shared/widgets/title.dart';

class CardCategory extends StatefulWidget {
  const CardCategory({Key? key, required this.onSelectionChanged}) : super(key: key);
  //final GlobalKey<State<StatefulWidget>>? keyPage;
  final Function(List<HorarioHome>) onSelectionChanged;
  @override
  State<CardCategory> createState() => _CardCategoryState();
}

class _CardCategoryState extends State<CardCategory> {
  int _currentIndex = 0;
  final HomeService _homeService = HomeService();
  HomeResponse? _homeResponse;
  bool _screenActive = false;
  List<HorarioHome> selectedHorarios = [];


  @override
  void initState() {
    GlobalHelper().trackScreen("Pantalla de Inicio/Home");
    //super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sp = Provider.of<StudentProvider>(context, listen: false);
      //sp.closeSession = false;
      sp.setCloseSession(false);
      //_loadSelectedHorarios();
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

  _onCardTap(HorarioHome horario) {
    setState(() {
      if (selectedHorarios.contains(horario)) {
        selectedHorarios.remove(horario);
      } else {
        selectedHorarios.add(horario);
      }
    });
    _saveSelectedHorarios(selectedHorarios);
    widget.onSelectionChanged(selectedHorarios);
  }

  Future<void> _saveSelectedHorarios(List<HorarioHome> horarios) async {
    final pf = await SharedPreferences.getInstance();
    final List<String> horariosJson = horarios.map((horario) =>
    json.encode(horario.toJson())).toList();
    await pf.setStringList('selectedHorarios', horariosJson);
  }


    Future<void> _loadSelectedHorarios() async {
    final pf = await SharedPreferences.getInstance();
    List<String>? horariosJson = pf.getStringList('selectedHorarios');
    if (horariosJson != null) {
      selectedHorarios = horariosJson.map((horario) => 
      HorarioHome.fromJson(json.decode(horario))).toList();
      widget.onSelectionChanged(selectedHorarios);
      setState(() {
        //selectedHorarios = selectedHorarios;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final responsive = Responsive(context);
    const double heightTablet = 1080;
    int maxDots = _homeResponse != null ? _homeResponse!.horarios!.length : 0;


    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      // padding: EdgeInsets.zero,
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
            padding: const EdgeInsets.only(top: 15, left: 20, right: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: title(
                    //key: keyhomeAtencion,
                    title: 'CATEGORIAS:', 
                    fontSize: responsive.dp(1.7)
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                _homeResponse != null
                    ? _homeResponse!.horarios!.isNotEmpty
                        //AGREGAR EL KEY
                        ? Column(
                            children: [
                              GridView.builder(
                                padding: EdgeInsets.only(top: 8, bottom: 2),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: responsive.isTablet ? 3 : 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 1.1,
                                ),
                                itemCount: _homeResponse!.horarios!.length,
                                itemBuilder: (context, index) {
                                  final horario = _homeResponse!.horarios![index];
                                  return GestureDetector(
                                    child: CardProduct(
                                      title: horario.materiaNombre ?? '',
                                      horario: horario,
                                      index: index,
                                      isSelected: selectedHorarios.contains(horario),
                                      onTap: () async {
                                        _onCardTap(horario);
                                        log("tap: ${horario.materiaNombre}");
                                        log("Selected Horarios: $selectedHorarios");
                                      },
                                    ),
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
                    : const Center(
                      child: CircularProgressIndicator(),
                    ),
                SizedBox(height: size.height * 0.02),
              ],
            ),
          );
        },
      ),
    );
  }

  
}