import 'package:flutter/material.dart';
import 'package:shirt_avenue/widgets/banner_widget.dart';
import 'package:shirt_avenue/widgets/filter_button_widget.dart'; // Importa il nuovo widget

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _activeButton = "Uomo"; // Pulsante attivo iniziale

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomBanner(),
          const SizedBox(height: 20), // Aggiunto spazio sopra i pulsanti
          Padding(
            padding: const EdgeInsets.all(
                16.0), // Padding per distanziare i pulsanti
            child: Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceEvenly, // Distribuisce i pulsanti in modo uniforme
              children: [
                CustomButton(
                  label: "Uomo",
                  isActive: _activeButton == "Uomo",
                  onPressed: () {
                    setState(() {
                      _activeButton = "Uomo"; // Aggiorna il pulsante attivo
                    });
                  },
                ),
                CustomButton(
                  label: "Donna",
                  isActive: _activeButton == "Donna",
                  onPressed: () {
                    setState(() {
                      _activeButton = "Donna"; // Aggiorna il pulsante attivo
                    });
                  },
                ),
                CustomButton(
                  label: "Accessorio",
                  isActive: _activeButton == "Accessorio",
                  onPressed: () {
                    setState(() {
                      _activeButton =
                          "Accessorio"; // Aggiorna il pulsante attivo
                    });
                  },
                ),
              ],
            ),
          ),
          const Expanded(
            child: Center(child: Text('Contenuto della Home')),
          ),
        ],
      ),
    );
  }
}
