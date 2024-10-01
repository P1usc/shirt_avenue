import 'package:flutter/material.dart';

class CartDrawer extends StatelessWidget {
  const CartDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Center(
              child: Text(
                'Il tuo carrello',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Aggiungi qui i prodotti del carrello
                _buildCartItem(context, 'Prodotto 1', Icons.local_mall),
                _buildCartItem(context, 'Prodotto 2', Icons.local_mall),
                _buildCartItem(context, 'Prodotto 3', Icons.local_mall),
                _buildCartItem(context, 'Prodotto 4', Icons.local_mall),
                const Divider(), // Separatore
                ListTile(
                  leading: const Icon(Icons.shopping_cart_checkout,
                      color: Colors.blue),
                  title: const Text('Checkout',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () {
                    // Naviga alla pagina di checkout
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue,
                minimumSize: const Size(double.infinity, 50), // Larghezza piena
              ),
              child: const Text('Continua a comprare'),
              onPressed: () {
                // Chiudi il drawer e torna alla pagina precedente
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      onTap: () {
        // Naviga ai dettagli del prodotto
      },
    );
  }
}
