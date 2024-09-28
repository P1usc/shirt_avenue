import 'package:flutter/material.dart';
import 'package:shirt_avenue/services/fprodotto_service.dart';
import 'package:shirt_avenue/widgets/banner_widget.dart';
import 'package:shirt_avenue/widgets/filter_button_widget.dart';
import 'package:shirt_avenue/widgets/prodotto_card_widget.dart'; // Importa il widget pulsante

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _activeButton = "Uomo"; // Pulsante attivo iniziale
  List<dynamic> _prodotti = []; // Lista dei prodotti caricati
  bool _isLoading = false; // Per gestire il caricamento

  @override
  void initState() {
    super.initState();
    _loadProdotti(); // Carica i prodotti inizialmente per "Uomo"
  }

  // Metodo per caricare i prodotti in base al genere
  void _loadProdotti() async {
    setState(() {
      _isLoading = true; // Mostra il caricamento
    });
    try {
      final prodotti =
          await ProdottofiltroService().fetchProdottiPerGenere(_activeButton);
      setState(() {
        _prodotti = prodotti; // Aggiorna la lista prodotti
      });
    } catch (e) {
      // Gestione errori
      print('Errore nel caricamento dei prodotti: $e');
    } finally {
      setState(() {
        _isLoading = false; // Nasconde il caricamento
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomBanner(),
          const SizedBox(height: 20), // Spazio sopra i pulsanti
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomButton(
                  label: "Uomo",
                  isActive: _activeButton == "Uomo",
                  onPressed: () {
                    setState(() {
                      _activeButton = "Uomo";
                    });
                    _loadProdotti(); // Ricarica i prodotti
                  },
                ),
                CustomButton(
                  label: "Donna",
                  isActive: _activeButton == "Donna",
                  onPressed: () {
                    setState(() {
                      _activeButton = "Donna";
                    });
                    _loadProdotti(); // Ricarica i prodotti
                  },
                ),
                CustomButton(
                  label: "Accessorio",
                  isActive: _activeButton == "Accessorio",
                  onPressed: () {
                    setState(() {
                      _activeButton = "Accessorio";
                    });
                    _loadProdotti(); // Ricarica i prodotti
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator()) // Mostra caricamento
                : _prodotti.isNotEmpty
                    ? GridView.builder(
                        padding: const EdgeInsets.all(16.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.7, // Proporzione delle card
                        ),
                        itemCount: _prodotti.length,
                        itemBuilder: (context, index) {
                          final prodotto = _prodotti[index];
                          return ProdottoCard(
                              prodotto:
                                  prodotto); // Card personalizzata per il prodotto
                        },
                      )
                    : const Center(child: Text('Nessun prodotto trovato')),
          ),
        ],
      ),
    );
  }
}
