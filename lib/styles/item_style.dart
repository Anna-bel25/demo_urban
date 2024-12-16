import 'package:flutter/material.dart';


//ICONO CUSTOM
class CustomCircleAvatar extends StatelessWidget {
  final Color backgroundColor;
  final IconData icon;
  final double size;

  const CustomCircleAvatar({
    Key? key,
    this.backgroundColor = Colors.white,
    this.icon = Icons.person,
    this.size = 35,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: CircleAvatar(
        radius: size / 2,
        backgroundColor: backgroundColor,
        child: ShaderMask(
          shaderCallback: (bounds) {
            return const LinearGradient(
              colors : [
                Color.fromARGB(255, 225, 10, 81),
                Color.fromARGB(255, 88, 17, 12),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds);
          },
          child: Icon(
            icon,
            size: size * 0.7,
            color: Colors.white,
          ),
        ),
      ),
      // decoration: BoxDecoration(
      //   shape: BoxShape.circle,
      //   border: Border.all(
      //     color: Colors.black,
      //     width: 1,
      //   ),
      // ),
      // child: CircleAvatar(
      //   backgroundColor: backgroundColor,
      //   child: Icon(
      //     icon,
      //     color: Colors.black,
      //   ),
      // ),
    );
  }
}


//ITEMS DE MENU ESTADO
class CustomPopupMenuStatus extends StatelessWidget {
  final Function(String) onSelected;

  const CustomPopupMenuStatus({Key? key, required this.onSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      icon: const CustomCircleAvatar(
        backgroundColor: Colors.white,
        icon: Icons.more_vert,
      ),
      itemBuilder: (context) => [
        const PopupMenuItem<String>(
          value: 'estado',
          padding: EdgeInsets.zero,
          height: 14,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Text(
              'Estado',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
      color: Colors.white70,
    );
  }
}



//ITEMS DE MENU EDITAR Y ELIMINAR
class CustomPopupMenuEditDelete extends StatelessWidget {
  final Function(String) onSelected;

  const CustomPopupMenuEditDelete({Key? key, required this.onSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      icon: const CustomCircleAvatar(
        backgroundColor: Colors.white,
        icon: Icons.more_vert,
      ),
      itemBuilder: (context) => [
        const PopupMenuItem<String>(
          value: 'editar',
          padding: EdgeInsets.zero,
          height: 14,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Text(
              'Editar',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'eliminar',
          padding: EdgeInsets.zero,
          height: 14,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            child: Text(
              'Eliminar',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
      color: Colors.white70,
    );
  }
}



//ITEMS DE MENU EDITAR, ESTADO Y ELIMINAR
class CustomPopupMenuEditStatusDelete extends StatelessWidget {
  final Function(String) onSelected;

  const CustomPopupMenuEditStatusDelete({Key? key, required this.onSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      icon: const CustomCircleAvatar(
        backgroundColor: Colors.white,
        icon: Icons.more_vert,
      ),
      itemBuilder: (context) => [
        const PopupMenuItem<String>(
          value: 'editar',
          padding: EdgeInsets.zero,
          height: 14,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Text(
              'Editar',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'estado',
          padding: EdgeInsets.zero,
          height: 14,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Text(
              'Estado',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'eliminar',
          padding: EdgeInsets.zero,
          height: 14,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            child: Text(
              'Eliminar',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
      color: Colors.white70,
    );
  }
}



//ITEM DE LOGIN
class CustomPopupMenuButton extends StatelessWidget {
  final Function(String) onSelected;

  const CustomPopupMenuButton({Key? key, required this.onSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      icon: const CustomCircleAvatar(),
      itemBuilder: (context) => [
        const PopupMenuItem<String>(
          value: 'logout',
          padding: EdgeInsets.zero,
          height: 14,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            child: Text(
              'Cerrar sesión',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
      color: Colors.white70,
    );
  }
}
