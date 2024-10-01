import 'package:shirt_avenue/models/prodotto.dart';

class Preferito {
  final int id;
  final List<Prodotto> prodotti;

  Preferito({required this.id, required this.prodotti});

  factory Preferito.fromJson(Map<String, dynamic> json) {
    var prodottiFromJson = json['prodotti'] as List;
    List<Prodotto> prodottiList =
        prodottiFromJson.map((i) => Prodotto.fromJsonOldFormat(i)).toList();

    return Preferito(
      id: json['id'],
      prodotti: prodottiList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'prodotti': prodotti.map((e) => e.toJson()).toList(),
    };
  }
}
