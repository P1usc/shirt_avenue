import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shirt_avenue/pages/cerca_page.dart';
import 'package:shirt_avenue/pages/home_page.dart';
import 'package:shirt_avenue/pages/offerte_page.dart';
import 'package:shirt_avenue/pages/preferiti_page.dart';
import 'package:shirt_avenue/pages/profilo_page.dart';
import 'package:shirt_avenue/screens/login_screen.dart';
import 'package:shirt_avenue/widgets/navbar.dart';
import 'package:shirt_avenue/providers/session_provider.dart'; // Importa il tuo SessionProvider

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
    // Non aggiungiamo ProfiloPage qui
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<SessionProvider>(context);

    Widget getProfilePage() {
      // Controlla se l'utente è loggato
      if (session.isLoggedIn) {
        return const ProfiloPage(); // Mostra ProfiloPage se loggato
      } else {
        return const LoginScreen(); // Mostra LoginScreen se non loggato
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shirt Avenue'),
      ),
      body: _selectedIndex == 4
          ? getProfilePage()
          : _pages[
              _selectedIndex], // Mostra Login o Profilo a seconda dello stato di login
      bottomNavigationBar: Navbar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
