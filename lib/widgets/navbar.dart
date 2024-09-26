import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const Navbar(
      {super.key, required this.selectedIndex, required this.onItemTapped});

  @override
  NavbarState createState() => NavbarState();
}

class NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_offer),
          label: 'Offerte',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Cerca',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Preferiti',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profilo',
        ),
      ],
      currentIndex: widget.selectedIndex,
      selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.grey,
      onTap: widget.onItemTapped,
    );
  }
}
