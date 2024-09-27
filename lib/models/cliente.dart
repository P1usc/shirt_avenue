import 'package:shirt_avenue/models/preferito.dart';
import 'package:shirt_avenue/models/prodotto.dart';
import 'package:shirt_avenue/models/carrello.dart'; // Ensure you have a Carrello model

class Cliente {
  final int id;
  final String nome;
  final String cognome;
  final String indirizzo;
  final String telefono;
  final List<Preferito>? preferiti;
  final Carrello? carrello; // Make carrello nullable

  Cliente({
    required this.id,
    required this.nome,
    required this.cognome,
    required this.indirizzo,
    required this.telefono,
    required this.preferiti,
    this.carrello, // Allow this to be optional
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
      carrello: carrello, // Set carrello if it exists
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
      'carrello': carrello?.toJson(), // Use toJson if carrello is not null
    };
  }
}
