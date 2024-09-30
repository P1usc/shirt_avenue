// lib/widgets/product_drawer.dart

import 'package:flutter/material.dart';
import 'package:shirt_avenue/models/prodotto.dart';

class ProductDrawer extends StatelessWidget {
  final Prodotto prodotto;

  const ProductDrawer({
    super.key,
    required this.prodotto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildAppBar(), // Simplified app bar with just a title
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildProductImage(),
                    const SizedBox(height: 16),
                    _buildProductDetails(),
                    const SizedBox(height: 20),
                    _buildActionButtons(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        prodotto.nome,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.black, // Change text color to black for better contrast
        ),
      ),
      centerTitle: true, // Center the title
      elevation: 0, // Remove elevation for a flat look
      automaticallyImplyLeading: false, // Remove the back arrow
      backgroundColor: Colors.white,
      toolbarHeight: 80, // Increase the height of the AppBar to give more space
    );
  }

  Widget _buildProductImage() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16), // Rounded corners
        child: Image.network(
          prodotto.pngProd,
          fit: BoxFit.cover,
          height: 300,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error, size: 100);
          },
        ),
      ),
    );
  }

  Widget _buildProductDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          prodotto.nome,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Categoria: ${prodotto.categoria}',
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        // Display original and discounted price
        Row(
          children: [
            if (prodotto.sconto != null)
              Text(
                '€${prodotto.costo.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.red, // Original price in red
                  decoration:
                      TextDecoration.lineThrough, // Strike-through effect
                ),
              ),
            const SizedBox(width: 8), // Space between prices
            Text(
              '€${prodotto.prezzoScontato.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: prodotto.sconto != null ? Colors.green : Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text(
          'Descrizione:',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          prodotto.shortdescrizione ?? 'Descrizione non disponibile.',
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue, // Button color
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Rounded corners
            ),
          ),
          onPressed: () {
            // Action for adding to favorites
            // Add your logic here
            Navigator.pop(context); // Close the drawer
          },
          child: const Text('Aggiungi ai Preferiti'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green, // Button color
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Rounded corners
            ),
          ),
          onPressed: () {
            // Action for buying the product
            // Add your logic here
            Navigator.pop(context); // Close the drawer
          },
          child: const Text('Acquista Ora'),
        ),
      ],
    );
  }
}
