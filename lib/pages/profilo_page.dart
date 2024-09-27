// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shirt_avenue/providers/session_provider.dart';
import 'package:shirt_avenue/screens/home_screen.dart';
import 'package:shirt_avenue/models/prodotto.dart';
import 'package:shirt_avenue/models/preferito.dart';

class ProfiloPage extends StatelessWidget {
  const ProfiloPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cliente = Provider.of<SessionProvider>(context).cliente;
    final preferiti = Provider.of<SessionProvider>(context).preferiti;

    return Scaffold(
      appBar: AppBar(title: const Text('Profilo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nome: ${cliente.nome}', style: TextStyle(fontSize: 18)),
            Text('Cognome: ${cliente.cognome}', style: TextStyle(fontSize: 18)),
            Text('Indirizzo: ${cliente.indirizzo}',
                style: TextStyle(fontSize: 18)),
            Text('Telefono: ${cliente.telefono}',
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Text('Preferiti:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            preferiti.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: preferiti.length,
                      itemBuilder: (context, index) {
                        Preferito preferito = preferiti[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Preferito ID: ${preferito.id}',
                                style: TextStyle(fontSize: 16)),
                            const SizedBox(height: 10),
                            Column(
                              children:
                                  preferito.prodotti.map((Prodotto prodotto) {
                                return ListTile(
                                  title: Text(prodotto.nome),
                                  subtitle: Text(
                                      'Costo: €${prodotto.costo.toString()}'),
                                );
                              }).toList(),
                            ),
                            const Divider(),
                          ],
                        );
                      },
                    ),
                  )
                : const Text('Nessun prodotto preferito trovato.',
                    style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await Provider.of<SessionProvider>(context, listen: false)
                    .logout();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()));
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
