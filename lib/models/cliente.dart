import 'package:shirt_avenue/models/preferito.dart';
import 'package:shirt_avenue/models/carrello.dart'; // Assicurati di importare il modello Carrello

class Cliente {
  final int id;
  final String nome;
  final String cognome;
  final String indirizzo;
  final String telefono;
  final List<Preferito>? preferiti;
  final Carrello? carrello; // Aggiunto carrello qui

  Cliente({
    required this.id,
    required this.nome,
    required this.cognome,
    required this.indirizzo,
    required this.telefono,
    this.preferiti,
    this.carrello, // Imposta carrello come opzionale
  });

  factory Cliente.fromJson(Map<String, dynamic> json) {
    List<Preferito>? preferitiList;
    if (json['preferiti'] != null) {
      preferitiList = (json['preferiti'] as List)
          .map((i) => Preferito.fromJson(i))
          .toList();
    }

    Carrello? carrello;
    if (json['carrello'] != null) {
      carrello = Carrello.fromJson(json['carrello']);
    }

    return Cliente(
      id: json['id'],
      nome: json['nome'],
      cognome: json['cognome'],
      indirizzo: json['indirizzo'],
      telefono: json['telefono'],
      preferiti: preferitiList,
      carrello: carrello, // Set carrello se esiste
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'cognome': cognome,
      'indirizzo': indirizzo,
      'telefono': telefono,
      'preferiti': preferiti?.map((e) => e.toJson()).toList(),
      'carrello': carrello?.toJson(), // Usa toJson se carrello non è null
    };
  }
}
