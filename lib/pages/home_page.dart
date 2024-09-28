import 'package:flutter/material.dart';
import 'package:shirt_avenue/services/fprodotto_service.dart';
import 'package:shirt_avenue/widgets/banner_widget.dart';
import 'package:shirt_avenue/widgets/filter_button_widget.dart';
import 'package:shirt_avenue/widgets/prodotto_card_widget.dart';
import 'package:shirt_avenue/models/prodotto.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _activeButton = "Uomo";
  List<Prodotto> _prodotti = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProdotti();
  }

  void _loadProdotti() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final prodotti =
          await ProdottofiltroService().fetchProdottiPerGenere(_activeButton);

      print(prodotti); // Log dei prodotti

      setState(() {
        _prodotti = prodotti;
      });
    } catch (e) {
      print('Errore nel caricamento dei prodotti: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const CustomBanner(),
          const SizedBox(height: 20),
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
                    _loadProdotti();
                  },
                ),
                CustomButton(
                  label: "Donna",
                  isActive: _activeButton == "Donna",
                  onPressed: () {
                    setState(() {
                      _activeButton = "Donna";
                    });
                    _loadProdotti();
                  },
                ),
                CustomButton(
                  label: "Accessorio",
                  isActive: _activeButton == "Accessorio",
                  onPressed: () {
                    setState(() {
                      _activeButton = "Accessorio";
                    });
                    _loadProdotti();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _prodotti.isNotEmpty
                    ? GridView.builder(
                        padding: const EdgeInsets.all(16.0),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: _prodotti.length,
                        itemBuilder: (context, index) {
                          final prodotto = _prodotti[index];
                          return ProdottoCard(prodotto: prodotto);
                        },
                      )
                    : const Center(child: Text('Nessun prodotto trovato')),
          ),
        ],
      ),
    );
  }
}
