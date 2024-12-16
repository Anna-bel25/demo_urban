import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/visit_provider.dart';
import 'item_style.dart';
import 'theme.dart';


// APP BAR
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String userRole;
  final Function(String) onMenuSelected;

  const CustomAppBar({
    Key? key,
    required this.userName,
    required this.userRole,
    required this.onMenuSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Bienvenido, ',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                      ),
                      TextSpan(
                        text: userName,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text.rich(
                  TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Rol: ',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w300),
                      ),
                      TextSpan(
                        text: userRole,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: CustomPopupMenuButton(onSelected: onMenuSelected),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
  //Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}




// NAVIGATION BAR STATE
class CustomBottomNavigationBar extends StatefulWidget {
  final List<Widget> pages;
  final String userName;
  final String userRole;

  const CustomBottomNavigationBar({
    Key? key,
    required this.pages,
    required this.userName,
    required this.userRole,
  }) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _currentIndex = 0;
  bool _isLoggingOut = false;

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _handleMenuSelection(String value) {
    if (value == 'logout') {
      _logout();
    }
  }

  void _logout() async {
    setState(() {
      _isLoggingOut = true;
    });

    await Future.delayed(const Duration(seconds: 2));
    final visitProvider = Provider.of<VisitProvider>(context, listen: false);
    visitProvider.limpiarCampos();

    if (mounted) {
      showCenteredDialog(
        context,
        'Sesión cerrada correctamente.',
        duration: const Duration(seconds: 1),
      );
      await Future.delayed(const Duration(seconds: 2));

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        userName: widget.userName,
        userRole: widget.userRole,
        onMenuSelected: _handleMenuSelection,
      ),
      body: _isLoggingOut
          ? Center(child: CircularProgressIndicator())
          : widget.pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTap,
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          iconSize: 20,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                decoration: const BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      Color.fromARGB(255, 225, 10, 81),
                      Color.fromARGB(255, 88, 17, 12)
                    ],
                    center: Alignment.center,
                    radius: 0.6,
                    focal: Alignment.center,
                    focalRadius: 0.1,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: Icon(Icons.add, color: Colors.white70),
                ),
              ),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
