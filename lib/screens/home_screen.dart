import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shirt_avenue/pages/cerca_page.dart';
import 'package:shirt_avenue/pages/home_page.dart';
import 'package:shirt_avenue/pages/offerte_page.dart';
import 'package:shirt_avenue/pages/preferiti_page.dart';
import 'package:shirt_avenue/pages/profilo_page.dart';
import 'package:shirt_avenue/screens/login_screen.dart';
import 'package:shirt_avenue/widgets/carrello_drawer.dart';
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
    // Non aggiungiamo PreferitiPage qui
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = Provider.of<SessionProvider>(context);

    // Funzione per ottenere la pagina dei preferiti
    Widget getFavoritesPage() {
      if (session.isLoggedIn) {
        return const PreferitiPage(); // Mostra PreferitiPage se loggato
      } else {
        return const LoginScreen(); // Mostra LoginScreen se non loggato
      }
    }

    // Funzione per ottenere la pagina del profilo
    Widget getProfilePage() {
      if (session.isLoggedIn) {
        return const ProfiloPage(); // Mostra ProfiloPage se loggato
      } else {
        return const LoginScreen(); // Mostra LoginScreen se non loggato
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shirt Avenue'),
        actions: [
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  // Usa il context fornito da Builder per aprire il drawer
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
      ),
      endDrawer: const CartDrawer(), // Drawer del carrello
      body: _selectedIndex == 3
          ? getFavoritesPage() // Mostra PreferitiPage o Login a seconda dello stato di login
          : _selectedIndex == 4
              ? getProfilePage() // Mostra Login o Profilo a seconda dello stato di login
              : _pages[_selectedIndex], // Mostra le altre pagine
      bottomNavigationBar: Navbar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
