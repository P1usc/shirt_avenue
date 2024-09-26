import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shirt_avenue/providers/session_provider.dart'; // Assicurati di importare il tuo SessionProvider

class ProfiloPage extends StatelessWidget {
  const ProfiloPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ottieni il provider della sessione
    final session = Provider.of<SessionProvider>(context);

    // Assicurati che il cliente sia caricato
    final cliente = session.isLoggedIn ? session.cliente : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilo'),
      ),
      body: cliente != null
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nome: ${cliente.nome}',
                      style: const TextStyle(fontSize: 20)),
                  Text('Cognome: ${cliente.cognome}',
                      style: const TextStyle(fontSize: 20)),
                  Text('Email: ${session.username}',
                      style: const TextStyle(fontSize: 20)),
                  Text('Indirizzo: ${cliente.indirizzo}',
                      style: const TextStyle(fontSize: 20)),
                  Text('Telefono: ${cliente.telefono}',
                      style: const TextStyle(fontSize: 20)),
                  // Se hai un'immagine del profilo
                  if (cliente.imgprofile != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Image.network(cliente.imgprofile!),
                    ),
                ],
              ),
            )
          : const Center(child: Text('Nessun cliente trovato')),
    );
  }
}
