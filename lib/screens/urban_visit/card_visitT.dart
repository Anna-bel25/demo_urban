import 'dart:developer';

import 'package:edukar/env/theme/app_theme.dart';
import 'package:edukar/modules/home/models/home_response.dart';
import 'package:edukar/shared/helpers/responsive.dart';
import 'package:flutter/material.dart';

class CardTableProduct extends StatefulWidget {
  final List<HorarioHome> selectedHorarios;

  const CardTableProduct({super.key, required this.selectedHorarios});

  @override
  State<CardTableProduct> createState() => _CardTableProductState();
}

class _CardTableProductState extends State<CardTableProduct> {
  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.only(top: 15, left: 10, right: 20),
        child: Card(
          color: AppTheme.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: AppTheme.white,
            ),
            //color: AppTheme.white,
            constraints: BoxConstraints(maxHeight: 260, minHeight: 260),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
                  columnSpacing: 10,
                  headingRowHeight: 40,
                  decoration: BoxDecoration(color: AppTheme.white),
                  border: TableBorder.all(color: AppTheme.white),
                  headingRowColor: MaterialStateProperty.all(AppTheme.primaryColor),
                  headingTextStyle: TextStyle(
                    fontSize: responsive.dp(0.8),
                    fontWeight: FontWeight.w700,
                    color: AppTheme.white,
                  ),
                  dataTextStyle: TextStyle(
                    fontSize: responsive.dp(0.8),
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                  columns: <DataColumn>[
                    DataColumn(label: SizedBox(width: 30, child: Center(child: Text(' ')))),
                    DataColumn(label: SizedBox(width: 230, child: Center(child: Text('Producto'.toUpperCase())))),
                    DataColumn(label: SizedBox(width: 40, child: Center(child: Text('Cant.'.toUpperCase())))),
                    DataColumn(label: SizedBox(width: 80, child: Center(child: Text('Precio'.toUpperCase())))),
                    DataColumn(label: SizedBox(width: 50, child: Center(child: Text('Total'.toUpperCase())))),
                    DataColumn(label: SizedBox(width: 200, child: Center(child: Text(' '.toUpperCase())))),
                  ],
                  rows: widget.selectedHorarios.map((horario) {
                  log("Horario: ${horario.materiaNombre}, ${horario.cursoId}, ${horario.profesorId}, ${horario.paralelo}, ${horario.anioLectivo}");
                  return DataRow(
                    cells: [
                      DataCell(Center(child: Text(horario.cursoId ?? ' '))),
                      DataCell(Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(horario.materiaNombre ?? ' '),
                      )),
                      DataCell(Center(child: Text(horario.profesorId ?? ' '))),
                      DataCell(Center(child: Text(horario.paralelo ?? ' '))),
                      DataCell(Center(child: Text(horario.anioLectivo ?? ' '))),
                      DataCell(Center(child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: size.width * 0.01),
                          IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.add_circle_outline_rounded, color: AppTheme.primaryColor),
                            onPressed: () {},
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.remove_circle_outline_rounded, color: AppTheme.primaryColor),
                            onPressed: () {},
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.delete_forever_outlined, color: AppTheme.primaryColor),
                            onPressed: () {log('tap remove');},
                          ),
                        ],
                      ))),
                    ],
                  );
                }).toList(),
                
                            
                
                
                  // rows: [
                  //   DataRow(
                  //     cells: [
                  //       DataCell(Center(child: Text(' '))),
                  //       DataCell(Text('Ejemplo Producto')),
                  //       DataCell(Center(child: Text('2'))),
                  //       DataCell(Center(child: Text('\$10.00'))),
                  //       DataCell(Center(child: Text('\$20.00'))),
                  //       DataCell(Center(child: Row(
                  //         // mainAxisSize:MainAxisSize.min, 
                  //         mainAxisAlignment: MainAxisAlignment.center, 
                  //         crossAxisAlignment: CrossAxisAlignment.center,
                  //       children: [
                  //         IconButton(
                  //           padding: EdgeInsets.zero,
                  //           icon: Icon(Icons.add_circle_outline_rounded, color: AppTheme.primaryColor),
                  //           onPressed: () {},
                  //         ),
                  //         IconButton(
                  //           padding: EdgeInsets.zero,
                  //           icon: Icon(Icons.remove_circle_outline_rounded, color: AppTheme.primaryColor),
                  //           onPressed: () {},
                  //         ),
                  //         IconButton(
                  //           padding: EdgeInsets.zero,
                  //           icon: Icon(Icons.delete_forever_outlined, color: AppTheme.primaryColor),
                  //           onPressed: () {},
                  //         ),
                  //       ])),),
                  //     ],
                  //   ),
                  // ],
                
                            
                            
                    // rows: (
                    //   widget.homeResponse.horarios != null 
                    //   && widget.homeResponse.horarios!.isNotEmpty
                    // ) ? widget.homeResponse.horarios!.map((horario) {
                    //   log('listDetail: ${horario.toJson()}');
                    //   return DataRow(
                    //     cells: [
                    //       DataCell(Text(' ')),
                    //       DataCell(Text(' ')),
                    //       DataCell(Text(' ')),
                    //       DataCell(Text(' ')),
                    //       // DataCell(Text(horario.anioLectivo ?? '')),
                    //       // DataCell(Text(horario.materiaNombre ?? '')),
                    //       // DataCell(Text(horario.profesorNombre ?? '')),
                    //       // DataCell(Text(horario.detalle ?? '')),
                    //       DataCell(Text(' ')),
                    //     ],
                    //   );
                    // }).toList() : [],
                  ),
              ),
              ),
          ),
        ),
      ),
    );
  }
}