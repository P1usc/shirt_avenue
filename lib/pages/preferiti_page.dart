import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shirt_avenue/providers/session_provider.dart';
import 'package:shirt_avenue/models/prodotto.dart';
import 'package:shirt_avenue/models/preferito.dart';

class PreferitiPage extends StatelessWidget {
  const PreferitiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionProvider = Provider.of<SessionProvider>(context);
    final preferiti = sessionProvider.preferiti;
    final clienteId = sessionProvider.cliente?.id;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              _buildPreferitiList(preferiti, clienteId?.toString(), context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreferitiList(
      List<Preferito> preferiti, String? clienteId, BuildContext context) {
    // Controlla se la lista dei preferiti è vuota o se tutti i preferiti non contengono prodotti
    final preferitiConProdotti =
        preferiti.where((preferito) => preferito.prodotti.isNotEmpty).toList();

    if (preferitiConProdotti.isEmpty) {
      return const Center(
        child: Text(
          'Nessun prodotto preferito trovato.',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: preferitiConProdotti.length,
      itemBuilder: (context, index) {
        return _buildPreferitoCard(
            preferitiConProdotti[index], clienteId, context);
      },
    );
  }

  Widget _buildPreferitoCard(
      Preferito preferito, String? clienteId, BuildContext context) {
    if (preferito.prodotti.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: preferito.prodotti.map((Prodotto prodotto) {
            return _buildDismissibleItem(
                prodotto, clienteId, context, preferito);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDismissibleItem(Prodotto prodotto, String? clienteId,
      BuildContext context, Preferito preferito) {
    return Dismissible(
      key: Key(prodotto.id.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) async {
        await _removeFromWishlist(clienteId, prodotto, context, preferito);
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: const Icon(Icons.favorite, color: Colors.red),
        title: Text(
          prodotto.nome,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Costo: €${prodotto.costo.toStringAsFixed(2)}',
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Future<void> _removeFromWishlist(String? clienteId, Prodotto prodotto,
      BuildContext context, Preferito preferito) async {
    if (clienteId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Errore: Cliente ID non disponibile')),
      );
      return;
    }

    try {
      // Rimuovi il prodotto dai preferiti nel provider
      Provider.of<SessionProvider>(context, listen: false)
          .removePreferito(prodotto); // Cambia il metodo chiamato

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${prodotto.nome} rimosso dai preferiti')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Errore durante la rimozione: $e')),
      );
    }
  }
}
