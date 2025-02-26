import 'package:edukar/env/environment_company.dart';
import 'package:edukar/env/theme/app_theme.dart';
import 'package:edukar/modules/home/models/home_response.dart';
import 'package:edukar/shared/helpers/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CardProduct extends StatelessWidget {
  const CardProduct({
    Key? key,
    required this.title,
    required this.onTap,
    this.size = 50,
    this.padding,
    this.borderRadius = 10,
    this.elevation = 3,
    this.colorFilter,
    this.imagePath,
    this.horario,
    this.index,
  }) : super(key: key);

  final String title;
  final VoidCallback onTap;
  final double size;
  final double? padding;
  final double borderRadius;
  final double elevation;
  final String? colorFilter;
  final String? imagePath;
  final HorarioHome? horario;
  final int? index;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final responsive = Responsive(context);
    final config = EnvironmentCompany().config!;

    return Padding(
      padding: EdgeInsets.all(padding ?? 20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          // height: size.height * 0.2,
          // width: size.width * 0.3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: Theme.of(context).primaryColor.withOpacity(0.5),
            image: imagePath != null
                ? DecorationImage(
                  image: NetworkImage(imagePath!),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5),
                    BlendMode.darken,
                  ),
            ) : null,
          ),
          child: ClipRRect( 
            borderRadius: BorderRadius.circular(borderRadius),
            child: Stack( 
              children: [ 
                Container( 
                  decoration: BoxDecoration( 
                    borderRadius: BorderRadius.circular(borderRadius),
                    color: Theme.of(context).primaryColor.withOpacity(0.7),
                  ),
                ),
                Center( 
                  child: Padding( 
                    padding: EdgeInsets.all(10),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text( 
                        horario?.materiaNombre ?? '',
                        //Ññtitle,
                        style: TextStyle( 
                          color: AppTheme.white,
                          fontSize: responsive.dp(1.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class CardProductGrid extends StatelessWidget {
  const CardProductGrid({
    Key? key,
    required this.items,
  }) : super(key: key);

  final List<HorarioHome> items;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final responsive = Responsive(context);
    final config = EnvironmentCompany().config!;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: GridView.builder(
        itemCount: items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: responsive.isTablet ? 3 : 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (context, index) => CardProduct(
          title: items[index].materiaNombre ?? '',
          onTap: () {},
          horario: items[index],
          index: index,
        ),
        // itemBuilder: (context, index) {
        //   final horario = items[index];
        //   return CardProduct(
        //     title: horario.materiaNombre ?? '',
        //     onTap: () {},
        //     horario: horario,
        //     index: index,
        //   );
        // },
      ),
    );
  }
}
