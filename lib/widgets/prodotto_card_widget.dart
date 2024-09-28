import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shirt_avenue/providers/session_provider.dart';

class ProdottoCard extends StatefulWidget {
  final dynamic prodotto;

  const ProdottoCard({super.key, required this.prodotto});

  @override
  _ProdottoCardState createState() => _ProdottoCardState();
}

class _ProdottoCardState extends State<ProdottoCard> {
  bool _isFavorited = false;

  void _onFavoritePressed() {
    final sessionProvider =
        Provider.of<SessionProvider>(context, listen: false);

    if (!sessionProvider.isLoggedIn) {
      _showLoginDialog();
    } else {
      setState(() {
        _isFavorited = !_isFavorited;
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
                // Naviga alla pagina di login
                Navigator.pushNamed(context, '/login');
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
    var imageUrl = widget.prodotto['pngProd'] != null &&
            widget.prodotto['pngProd']['url'] != null
        ? 'http://192.168.1.160:1337${widget.prodotto['pngProd']['url']}'
        : 'https://via.placeholder.com/150';

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
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
                    widget.prodotto['nome'] ?? 'Prodotto',
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
            child: Text(
              widget.prodotto['categoria'] ?? 'Categoria',
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '€${widget.prodotto['costo']}',
              style: const TextStyle(color: Colors.orange),
            ),
          ),
        ],
      ),
    );
  }
}
