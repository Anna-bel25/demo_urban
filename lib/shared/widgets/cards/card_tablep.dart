import 'package:edukar/env/theme/app_theme.dart';
import 'package:edukar/modules/home/models/home_response.dart';
import 'package:flutter/material.dart';

class CardTableProduct extends StatefulWidget {
  const CardTableProduct({super.key});

  @override
  State<CardTableProduct> createState() => _CardTableProductState();
}

class _CardTableProductState extends State<CardTableProduct> {
  HomeResponse? _homeResponse;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          constraints: const BoxConstraints(minHeight: 500),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(15),
            //border: Border.all(color: Colors.grey),
          ),
          child: Table(
            columnWidths: const {
        
              // 0: IntrinsicColumnWidth(),
              // 1: IntrinsicColumnWidth(),
              // 2: IntrinsicColumnWidth(),
              // 3: IntrinsicColumnWidth(),
              // 4: IntrinsicColumnWidth(),
              
              0: FixedColumnWidth(40),
              1: FixedColumnWidth(190),
              2: FixedColumnWidth(230),
              3: FixedColumnWidth(100),
              4: FixedColumnWidth(100),
            },
            border: TableBorder.all(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(10),
            ),
            children: [
              const TableRow(
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      ' ',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Deb/Cred',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Modelo tarjeta',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Monto',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Acciones',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              if (_homeResponse?.horarios?.isEmpty ?? true)
                const TableRow(
                  children: [
                    Text(''),
                    Text(''),
                    Text('No hay datos para mostrar.'),
                    Text(''),
                    Text(''),
                  ],
                )
              else
                ..._homeResponse!.horarios!.map((item) {
                  return TableRow(
                    children: [
                      Text(item.cursoId ?? 0.toString()),
                      Text(item.cursoId.toString()),
                      Text(item.materiaNombre ?? ''),
                      Text('\$${item.anioLectivo.toString()}'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      Divider(height: 1, color: Colors.grey),
                    ],
                  );
                }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}