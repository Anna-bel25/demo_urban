import 'package:flutter/material.dart';


class FavoritePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1631485221350-42316f117124?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          
          const Align(
            alignment: Alignment.center,
            child: Text(
              'Hi!',
              style: TextStyle(
                fontSize: 55,
                fontWeight: FontWeight.w900,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
