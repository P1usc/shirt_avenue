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
        children: [
          Text('Nome: ${account.cliente.nome}'),
          Text('Cognome: ${account.cliente.cognome}'),
          Text('Indirizzo: ${account.cliente.indirizzo}'),
          Text('Telefono: ${account.cliente.telefono}'),
          const SizedBox(height: 20), // Spazio aggiuntivo
          ElevatedButton(
            onPressed: () async {
              // Esegui il logout
              await Provider.of<SessionProvider>(context, listen: false)
                  .logout();
              // Torna alla pagina di login o alla schermata principale
              MaterialPageRoute(builder: (context) => const HomeScreen());
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
