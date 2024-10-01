import 'package:flutter/material.dart';
import 'package:shirt_avenue/models/prodotto.dart';
import 'package:shirt_avenue/services/prodotto_service.dart';
import 'package:shirt_avenue/widgets/prodotto_card_widget.dart';

class OffertePage extends StatefulWidget {
  const OffertePage({super.key});

  @override
  _OffertePageState createState() => _OffertePageState();
}

class _OffertePageState extends State<OffertePage> {
  late Future<List<Prodotto>> _prodottiScontati;

  @override
  void initState() {
    super.initState();
    _prodottiScontati = ProdottoService().getProdottiScontati();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offerte del mese'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Prodotto>>(
        future: _prodottiScontati,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Errore: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nessun prodotto in offerta'));
          }

          List<Prodotto> prodottiScontati = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Numero di colonne
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: 0.7, // Proporzioni delle card
            ),
            itemCount: prodottiScontati.length,
            itemBuilder: (context, index) {
              return ProdottoCard(
                  prodotto:
                      prodottiScontati[index]); // Usa la card del prodotto
            },
          );
        },
      ),
    );
  }
}
