import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shirt_avenue/providers/session_provider.dart';
import 'package:shirt_avenue/screens/login_screen.dart';
import 'package:shirt_avenue/models/prodotto.dart';

class ProdottoCard extends StatefulWidget {
  final Prodotto prodotto;

  const ProdottoCard({super.key, required this.prodotto});

  @override
  _ProdottoCardState createState() => _ProdottoCardState();
}

class _ProdottoCardState extends State<ProdottoCard> {
  late bool _isFavorited;

  @override
  void initState() {
    super.initState();
    final sessionProvider =
        Provider.of<SessionProvider>(context, listen: false);
    // Verifica se il prodotto è già tra i preferiti
    _isFavorited = sessionProvider.preferiti.any((preferito) =>
        preferito.prodotti.any((p) => p.id == widget.prodotto.id));
  }

  void _onFavoritePressed() {
    final sessionProvider =
        Provider.of<SessionProvider>(context, listen: false);

    if (!sessionProvider.isLoggedIn) {
      _showLoginDialog();
    } else {
      setState(() {
        _isFavorited = !_isFavorited;

        if (_isFavorited) {
          // Aggiungi il prodotto ai preferiti
          sessionProvider.addPreferito(widget.prodotto);
        } else {
          // Rimuovi il prodotto dai preferiti
          sessionProvider.removePreferito(widget.prodotto);
        }
      });
    }
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Accesso richiesto'),
          content: const Text(
              'Devi effettuare il login per aggiungere ai preferiti.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annulla'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text('Login'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var imageUrl = widget.prodotto.pngProd;

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons
                      .error); // Mostra un'icona di errore se l'immagine non viene caricata
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.prodotto.nome,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _isFavorited ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorited ? Colors.red : Colors.grey,
                  ),
                  onPressed: _onFavoritePressed,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(widget.prodotto.categoria),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '€${widget.prodotto.costo.toStringAsFixed(2)}', // Format to two decimal places
              style: const TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }
}
