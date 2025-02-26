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
  final double padding;
  final double borderRadius;
  final double elevation;
  final double iconSize;
  final double iconPadding;
  final double iconBorderRadius;
  final double iconElevation;
  final double iconSizePadding;
  // final Clase scheduleclass;
  // final List<Horario> horario;

  const CardIconButton({
    Key? key,
    required this.icon,
    required this.color,
    required this.onTap,
    this.size = 50,
    this.padding = 10,
    this.borderRadius = 10,
    this.elevation = 3,
    required this.iconSize,
    this.iconPadding = 10,
    this.iconBorderRadius = 10,
    this.iconElevation = 3,
    this.iconSizePadding = 10,
    // required this.scheduleclass,
    // required this.horario,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = EnvironmentCompany().config;
    final zise = MediaQuery.of(context).size;
    final responsive = Responsive(context);

    return Card(
      borderOnForeground: true,
      color: AppTheme.white,
      surfaceTintColor: AppTheme.white,
      elevation: 2,
      shadowColor: AppTheme.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: IconButton(
        iconSize: iconSize,
        icon: Icon(
          icon,
          size: size,
          color: color,
        ),
        onPressed: onTap,
      ),
    );
  }
}
