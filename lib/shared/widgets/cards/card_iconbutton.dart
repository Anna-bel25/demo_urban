import 'package:edukar/env/environment_company.dart';
import 'package:edukar/env/theme/app_theme.dart';
import 'package:edukar/modules/class_schedule/models/schedule_class_response.dart';
import 'package:edukar/shared/helpers/responsive.dart';
import 'package:flutter/material.dart';

class CardIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final double size;
  final double? padding;
  final double borderRadius;
  final double elevation;
  final double iconSize;
  final double cardWidth;
  final double cardHeight;
  // final Clase scheduleclass;
  // final List<Horario> horario;

  const CardIconButton({
    Key? key,
    required this.icon,
    required this.color,
    required this.onTap,
    this.size = 50,
    this.padding,
    this.borderRadius = 10,
    this.elevation = 3,
    required this.iconSize,
    this.cardWidth = 60,
    this.cardHeight = 60,
    // required this.scheduleclass,
    // required this.horario,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = EnvironmentCompany().config;
    final zise = MediaQuery.of(context).size;
    final responsive = Responsive(context);

    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Card(
        borderOnForeground: true,
        color: AppTheme.white,
        surfaceTintColor: AppTheme.white,
        elevation: 2,
        shadowColor: AppTheme.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: IconButton(
          padding: EdgeInsets.only(left: 12, right: 12, ),
            iconSize: iconSize,
            icon: Icon(
              icon,
              size: size,
              color: color,
            ),
            onPressed: onTap,
          ),
      ),
    );
    
  }
}
