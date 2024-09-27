import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shirt_avenue/providers/session_provider.dart';
import 'package:shirt_avenue/screens/home_screen.dart';

class ProfiloPage extends StatelessWidget {
  const ProfiloPage({super.key});

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<SessionProvider>(context).account;

    return Scaffold(
      appBar: AppBar(title: const Text('Profilo')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nome: ${account.cliente.nome}'),
          Text('Cognome: ${account.cliente.cognome}'),
          Text('Indirizzo: ${account.cliente.indirizzo}'),
          Text('Telefono: ${account.cliente.telefono}'),
          const SizedBox(height: 20),
          const Text('Preferiti:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: account.cliente.preferiti?.length ?? 0,
              itemBuilder: (context, index) {
                final preferito = account.cliente.preferiti![index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Preferito ${index + 1}:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: preferito.prodotti.length,
                      itemBuilder: (context, prodIndex) {
                        final prodotto = preferito.prodotti[prodIndex];
                        return ListTile(
                          title: Text(prodotto.nome),
                          subtitle: Text('Costo: \$${prodotto.costo}'),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          if (account.cliente.carrello != null) ...[
            const Text('Carrello:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // Display cart information here
            Text(
                'Totale: \$${account.cliente.carrello!.totale}'), // Use safe access
          ],
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await Provider.of<SessionProvider>(context, listen: false)
                  .logout();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
