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
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    final sessionProvider =
        Provider.of<SessionProvider>(context, listen: false);
    // Verifica se il prodotto è già tra i preferiti
    _isFavorited = sessionProvider.preferiti.any((preferito) =>
        preferito.prodotti.any((p) => p.id == widget.prodotto.id));
    _isLoading = false; // Inizializza il flag di caricamento
  }

  Future<void> _onFavoritePressed() async {
    final sessionProvider =
        Provider.of<SessionProvider>(context, listen: false);
    final cliente = sessionProvider.account.cliente;

    if (!sessionProvider.isLoggedIn) {
      _showLoginDialog();
    } else {
      setState(() {
        _isLoading = true; // Inizia il caricamento
      });

      try {
        print('Cliente: $cliente');
        print('ID del prodotto selezionato: ${widget.prodotto.id}');

        if (_isFavorited) {
          // Se il cuore è rosso, rimuovi il prodotto dai preferiti
          await sessionProvider.removePreferito(widget.prodotto);
          print('Prodotto rimosso dai preferiti: ${widget.prodotto.id}');
        } else {
          // Se il cuore non è rosso, aggiungi il prodotto ai preferiti
          await sessionProvider.addPreferito(widget.prodotto);
          print('Prodotto aggiunto ai preferiti: ${widget.prodotto.id}');
        }

        // Aggiorna lo stato del cuore
        setState(() {
          _isFavorited = !_isFavorited; // Inverti lo stato
        });
      } catch (error) {
        print('Errore durante la gestione dei preferiti: $error');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Errore: $error'),
        ));
      } finally {
        setState(() {
          _isLoading = false; // Fine del caricamento
        });
      }
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
                _isLoading
                    ? const CircularProgressIndicator() // Mostra un indicatore di caricamento
                    : IconButton(
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
