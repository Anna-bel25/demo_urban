import 'package:edukar/env/environment_company.dart';
import 'package:edukar/env/theme/app_theme.dart';
import 'package:edukar/shared/helpers/responsive.dart';
import 'package:flutter/material.dart';

class CardClient extends StatelessWidget {
  final String title;
  final String? titlePrefix;
  final String? subtitle;
  final String? subtitlePrefix;
  final List<Map<String, String>>? subtitles;
  final VoidCallback? onTap;
  final double size;
  final double? padding;
  final double borderRadius;
  final double elevation;
  final double? iconSize;
  final double iconPadding;
  final double iconBorderRadius;
  final double iconElevation;
  final double iconSizePadding;
  // final Clase scheduleclass;
  // final List<Horario> horario;

  const CardClient({
    Key? key,
    required this.title,
    this.titlePrefix,
    this.subtitle,
    this.subtitlePrefix,
    this.subtitles,
    this.onTap,
    this.size = 50,
    this.padding,
    this.borderRadius = 10,
    this.elevation = 3,
    this.iconSize,
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

    return Padding(
      padding: EdgeInsets.only(
        left: padding ?? 20, right: padding ?? 20, 
        top: padding ?? 30, bottom: padding ?? 0
      ),
      child: Card(
        borderOnForeground: true,
        color: AppTheme.white,
        surfaceTintColor: AppTheme.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: CustomListTile(
          title: title,
          titlePrefix: titlePrefix, 
          subtitle: subtitle,
          subtitlePrefix: subtitlePrefix,
          subtitles: subtitles,
          icon: Icons.person,
          onTap: onTap,
        ),
      ),
    );
  }
}

class CustomListTile extends StatelessWidget {
  const CustomListTile({
    Key? key,
    required this.title,
    this.titlePrefix,
    this.subtitle,
    this.subtitlePrefix,
    this.subtitles,
    this.icon,
    this.leading,
    this.onTap,
  }) : super(key: key);

  final String title;
  final String? titlePrefix;
  final String? subtitle;
  final String? subtitlePrefix;
  final List<Map<String, String>>? subtitles;
  final IconData? icon;
  final Widget? leading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final responsive = Responsive(context);
    return ListTile(
      leading: leading,
      title: Row(
        children: [
          // Icon(
          //   icon,
          //   color: AppTheme.primaryColor,
          // ),
          // SizedBox(width: size.width * 0.012),
          // Text(
          //   "${titlePrefix ?? ''} $title",
          //   style: const TextStyle(
          //     fontWeight: FontWeight.bold,
          //     color: AppTheme.primaryColor,
          //   ),
          // ),
          RichText(
            text: TextSpan( 
              children: [ 
                TextSpan( 
                  text: "${titlePrefix ?? ''} ",
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w800,
                    fontSize: responsive.dp(1.2),
                  ),
                ),
                TextSpan( 
                  text: title,
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w500,
                    fontSize: responsive.dp(1.2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      subtitle: Column( 
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [ 
          Row( 
            children: [ 
              if(subtitle != null)
              RichText(
                text: TextSpan( 
                  children: [ 
                    TextSpan( 
                      text: "${subtitlePrefix ?? ''} ",
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w800,
                        fontSize: responsive.dp(1.2),
                      ),
                    ),
                    TextSpan( 
                      text: subtitle,
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: responsive.dp(1.2),
                      ),
                    ),
                  ],
                ),
              ),
              
            ],
          ),
          // if(subtitle != null)
          // Text(
          //   "${subtitlePrefix ?? ''} $subtitle",
          //   style: TextStyle(
          //     fontWeight: FontWeight.bold,
          //     color: AppTheme.primaryColor,
          //     fontSize: responsive.dp(1.2),
          //   ),
          // ),
          ...subtitles!.map((subtitle) {
            final key = subtitle.keys.first;
            final value = subtitle[key];
            return Row(
              children: [
                RichText(
                  text: TextSpan( 
                    children: [ 
                      TextSpan( 
                        text: "$key:",
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w800,
                          fontSize: responsive.dp(1.2),
                        ),
                      ),
                      TextSpan( 
                        text: "$value",
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: responsive.dp(1.2),
                        ),
                      ),
                    ],
                  ),
                ),
                // Text( 
                //   "$key: $value",
                //   style: TextStyle(
                //     fontWeight: FontWeight.bold,
                //     color: AppTheme.primaryColor,
                //     fontSize: responsive.dp(1.2),
                //   ),
                // ),
              ],
            );
          }).toList(),
        ],
      ),
      // subtitle: Row( 
      //   children: [ 
      //     Text(
      //       "${subtitlePrefix ?? ''} $subtitle",
      //       style: const TextStyle(
      //         fontWeight: FontWeight.bold,
      //         color: AppTheme.primaryColor,
      //       ),
      //     ),
      //   ],
      // ),
      
      onTap: onTap,
    );
  }
}
