import 'package:flutter/material.dart';

class ProdottoCardWidget extends StatelessWidget {
  final String nome;
  final String categoria;
  final double costo; // Assicurati che qui sia un double
  final String immagineUrl;

  const ProdottoCardWidget({
    Key? key,
    required this.nome,
    required this.categoria,
    required this.costo,
    required this.immagineUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Image.network(immagineUrl), // Immagine del prodotto
          Text(nome),
          Text(categoria),
          Text('\$${costo.toStringAsFixed(2)}'), // Mostra il costo formattato
        ],
      ),
    );
  }
}
