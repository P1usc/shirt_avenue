// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shirt_avenue/providers/session_provider.dart';
import 'package:shirt_avenue/screens/home_screen.dart';
import 'package:shirt_avenue/models/prodotto.dart';
import 'package:shirt_avenue/models/preferito.dart';
import 'package:shirt_avenue/models/item_carrello.dart'; // Assicurati di importare ItemCarrello

class ProfiloPage extends StatelessWidget {
  const ProfiloPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cliente = Provider.of<SessionProvider>(context).cliente;
    final preferiti = Provider.of<SessionProvider>(context).preferiti;
    final carrello = Provider.of<SessionProvider>(context).carrello;

    // Debugging: Stampa i dettagli del carrello
    print(
        'Numero di articoli nel carrello: ${carrello?.item_carrelli.length ?? 0}');

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sezione Cliente
              Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nome: ${cliente.nome}',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('Cognome: ${cliente.cognome}',
                          style: const TextStyle(fontSize: 18)),
                      Text('Indirizzo: ${cliente.indirizzo}',
                          style: const TextStyle(fontSize: 18)),
                      Text('Telefono: ${cliente.telefono}',
                          style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Sezione Preferiti
              const Text('Preferiti:',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              if (preferiti.isNotEmpty)
                Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: preferiti.length,
                    itemBuilder: (context, index) {
                      Preferito preferito = preferiti[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Preferito ID: ${preferito.id}',
                                style: const TextStyle(fontSize: 16)),
                          ),
                          ...preferito.prodotti.map((Prodotto prodotto) {
                            return ListTile(
                              leading:
                                  const Icon(Icons.favorite, color: Colors.red),
                              title: Text(prodotto.nome),
                              subtitle:
                                  Text('Costo: €${prodotto.costo.toString()}'),
                            );
                          }).toList(),
                          const Divider(),
                        ],
                      );
                    },
                  ),
                )
              else
                const Text('Nessun prodotto preferito trovato.',
                    style: TextStyle(fontSize: 16)),
              const SizedBox(height: 20),

              // Sezione Carrello
              const Text('Carrello:',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              if (carrello?.item_carrelli.isNotEmpty ?? false)
                Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: carrello!.item_carrelli.length,
                    itemBuilder: (context, index) {
                      ItemCarrello item = carrello.item_carrelli[index];

                      // Debugging: Stampa i dettagli dell'articolo del carrello
                      print(
                          'Articolo nel carrello: ${item.prodotto.nome}, Quantità: ${item.quantita}, Costo: €${item.prodotto.costo * item.quantita}');

                      return ListTile(
                        title: Text(item.prodotto.nome),
                        subtitle: Text(
                            'Quantità: ${item.quantita}, Costo: €${item.prodotto.costo * item.quantita}'),
                        trailing: const Icon(Icons.shopping_cart),
                      );
                    },
                  ),
                )
              else
                const Text('Il carrello è vuoto.',
                    style: TextStyle(fontSize: 16)),
              const SizedBox(height: 20),

              // Bottone di Logout
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red, // Colore del testo
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                  ),
                  onPressed: () async {
                    await Provider.of<SessionProvider>(context, listen: false)
                        .logout();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                  },
                  child: const Text('Logout', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
