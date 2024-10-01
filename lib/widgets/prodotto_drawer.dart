import 'package:flutter/material.dart';
import 'package:shirt_avenue/models/prodotto.dart';

class ProductDrawer extends StatefulWidget {
  final Prodotto prodotto;

  const ProductDrawer({
    super.key,
    required this.prodotto,
  });

  @override
  _ProductDrawerState createState() => _ProductDrawerState();
}

class _ProductDrawerState extends State<ProductDrawer> {
  String? selectedSize;
  String? selectedColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildAppBar(),
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
                    _buildSizeSelector(),
                    const SizedBox(height: 16),
                    _buildColorSelector(),
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
        widget.prodotto.nome,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.black,
        ),
      ),
      centerTitle: true,
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      toolbarHeight: 80,
    );
  }

  Widget _buildProductImage() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          widget.prodotto.pngProd,
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
          widget.prodotto.nome,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Categoria: ${widget.prodotto.categoria}',
          style: const TextStyle(fontSize: 18, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        // Display original and discounted price
        Row(
          children: [
            if (widget.prodotto.sconto != null)
              Text(
                '€${widget.prodotto.costo.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.red, // Original price in red
                  decoration:
                      TextDecoration.lineThrough, // Strike-through effect
                ),
              ),
            const SizedBox(width: 8), // Space between prices
            Text(
              '€${widget.prodotto.prezzoScontato.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: widget.prodotto.sconto != null
                    ? Colors.green
                    : Colors.orange,
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
          widget.prodotto.shortdescrizione ?? 'Descrizione non disponibile.',
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ],
    );
  }

  // Size Selector Widget
  Widget _buildSizeSelector() {
    List<String> sizes = ['S', 'M', 'L', 'XL']; // Example sizes

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Taglia:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 16),
        DropdownButton<String>(
          value: selectedSize,
          hint: const Text('Seleziona taglia'),
          onChanged: (value) {
            setState(() {
              selectedSize = value;
            });
          },
          items: sizes.map((String size) {
            return DropdownMenuItem<String>(
              value: size,
              child: Text(size),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Color Selector Widget
  Widget _buildColorSelector() {
    List<String> colors = ['Rosso', 'Blu', 'Verde', 'Nero']; // Example colors

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Text(
          'Colore:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 16),
        DropdownButton<String>(
          value: selectedColor,
          hint: const Text('Seleziona colore'),
          onChanged: (value) {
            setState(() {
              selectedColor = value;
            });
          },
          items: colors.map((String color) {
            return DropdownMenuItem<String>(
              value: color,
              child: Text(color),
            );
          }).toList(),
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
