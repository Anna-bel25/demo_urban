import 'package:demo_urban/.env/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

@override
Widget drawerWidget404(BuildContext context) {
  final size = MediaQuery.of(context).size;
  return Container(
    height: size.height,
    width: size.width,
    color: AppTheme.white,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(AppTheme.icon404Path),
        ],
      ),
    ),
  );
}
