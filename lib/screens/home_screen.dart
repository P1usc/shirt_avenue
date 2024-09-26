import 'package:flutter/material.dart';
import 'package:shirt_avenue/pages/cerca_page.dart';
import 'package:shirt_avenue/pages/home_page.dart';
import 'package:shirt_avenue/pages/offerte_page.dart';
import 'package:shirt_avenue/pages/preferiti_page.dart';
import 'package:shirt_avenue/pages/profilo_page.dart';
import 'package:shirt_avenue/widgets/navbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const OffertePage(),
    const CercaPage(),
    const PreferitiPage(),
    const ProfiloPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shirt Avenue'),
      ),
      body: _pages[_selectedIndex], // Mostra la pagina selezionata
      bottomNavigationBar: Navbar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
