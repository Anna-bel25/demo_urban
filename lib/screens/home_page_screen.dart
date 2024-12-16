import 'package:flutter/material.dart';

import '../styles/buttom_style.dart';
import 'user/register_screen.dart';
import 'user/login_screen.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              //color: Colors.blue,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1662129266558-d47562f75c1d?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            color: Colors.white.withOpacity(0.6),
          ),
  
          const Align(
            alignment: Alignment.center,
            child: Text(
              'Hello!',
              style: TextStyle(
                fontSize: 55,
                fontWeight: FontWeight.w900,
                color: Colors.black54,
              ),
            ),
          ),
          _botones(),
        ],
      ),
    );
  }

  Widget _botones() {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Card(
            color: Colors.white,
            elevation: 5,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 150,
                    height: 70,
                    child: CustomButtonGradientRed(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      style: botonEstiloGradientRed(),
                      text: 'LOGIN',
                    ),
                  ),
                  SizedBox(
                    width: 150,
                    height: 70,
                    child: CustomButtonGradientBlack(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterPage()),
                        );
                      },
                      style: botonEstiloGradientBlack(),
                      text: 'REGISTER',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
