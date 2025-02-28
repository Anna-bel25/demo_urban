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
      child: Table(
        columnWidths: const {
          0: FixedColumnWidth(40),
          1: FixedColumnWidth(150),
          2: FixedColumnWidth(230),
          3: FixedColumnWidth(100),
          4: FixedColumnWidth(100),
        },
        children: [
          const TableRow(
            children: [
              Text(' '),
              Text('Deb/Cred'),
              Text('Modelo tarjeta'),
              Text('Monto'),
              Text('Acciones'),
            ],
          ),
          if (_homeResponse?.horarios?.isEmpty ?? true)
            const TableRow(
              children: [
                Text(''),
                Text('No hay datos para mostrar.'),
                Text(''),
                Text(''),
                Text(''),
              ],
            )
          else
            ..._homeResponse!.horarios!.map((item) {
              return TableRow(
                children: [
                  // Text((item.id).toString()),
                  // Text(item.debCred),
                  // Text(item.modeloTarjeta),
                  // Text('\$${item.monto.toStringAsFixed(2)}'),
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
                ],
              );
            }).toList(),
        ],
      ),
    );
  }
}