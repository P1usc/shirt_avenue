// lib/screens/prodotto_card.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shirt_avenue/providers/session_provider.dart';
import 'package:shirt_avenue/screens/login_screen.dart';
import 'package:shirt_avenue/models/prodotto.dart';
import 'package:shirt_avenue/widgets/prodotto_drawer.dart';

class ProdottoCard extends StatefulWidget {
  final Prodotto prodotto;

  const ProdottoCard({super.key, required this.prodotto});

  @override
  _ProdottoCardState createState() => _ProdottoCardState();
}

class _ProdottoCardState extends State<ProdottoCard> {
  late bool _isFavorited;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeFavoriteStatus();
  }

  void _initializeFavoriteStatus() {
    final sessionProvider =
        Provider.of<SessionProvider>(context, listen: false);
    _isFavorited = sessionProvider.preferiti.any((preferito) =>
        preferito.prodotti.any((p) => p.id == widget.prodotto.id));
  }

  Future<void> _onFavoritePressed() async {
    final sessionProvider =
        Provider.of<SessionProvider>(context, listen: false);

    if (!sessionProvider.isLoggedIn) {
      _showLoginDialog();
    } else {
      _toggleFavoriteStatus(sessionProvider);
    }
  }

  Future<void> _toggleFavoriteStatus(SessionProvider sessionProvider) async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_isFavorited) {
        await sessionProvider.removePreferito(widget.prodotto);
        _showSnackBar('Prodotto rimosso dai preferiti');
      } else {
        await sessionProvider.addPreferito(widget.prodotto);
        _showSnackBar('Prodotto aggiunto ai preferiti');
      }
      setState(() {
        _isFavorited = !_isFavorited;
      });
    } catch (error) {
      _showSnackBar('Errore: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Accesso richiesto'),
        content:
            const Text('Devi effettuare il login per aggiungere ai preferiti.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
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
      ),
    );
  }

  void _openProductDrawer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return ProductDrawer(prodotto: widget.prodotto);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openProductDrawer,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(),
            _buildProductInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    return Expanded(
      child: Center(
        child: Image.network(
          widget.prodotto.pngProd,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error);
          },
        ),
      ),
    );
  }

  Widget _buildProductInfo() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProductTitle(),
          Text(widget.prodotto.categoria),
          _buildProductPrice(),
        ],
      ),
    );
  }

  Widget _buildProductTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            widget.prodotto.nome,
            style: const TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        _isLoading
            ? const CircularProgressIndicator()
            : IconButton(
                icon: Icon(
                  _isFavorited ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorited ? Colors.red : Colors.grey,
                ),
                onPressed: _onFavoritePressed,
              ),
      ],
    );
  }

  Widget _buildProductPrice() {
    // Check if the product has a discount
    bool hasDiscount = widget.prodotto.sconto != null;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          if (hasDiscount)
            Text(
              '€${widget.prodotto.costo.toStringAsFixed(2)}', // Original price
              style: const TextStyle(
                color: Colors.red, // Original price in red
                decoration: TextDecoration.lineThrough, // Strike-through effect
              ),
            ),
          if (hasDiscount) const SizedBox(width: 8.0), // Space between prices
          Text(
            '€${hasDiscount ? widget.prodotto.prezzoScontato.toStringAsFixed(2) : widget.prodotto.costo.toStringAsFixed(2)}', // Display discounted price or original price
            style: TextStyle(
              color: hasDiscount
                  ? Colors.green
                  : Colors
                      .orange, // Discounted price in green, original price in orange
            ),
          ),
        ],
      ),
    );
  }
}
