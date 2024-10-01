import 'package:shirt_avenue/models/prodotto.dart';

class ItemCarrello {
  final int quantita;
  final Prodotto prodotto;

  ItemCarrello({required this.quantita, required this.prodotto});

  factory ItemCarrello.fromJson(Map<String, dynamic> json) {
    return ItemCarrello(
      quantita: json['quantita'],
      prodotto: Prodotto.fromJsonOldFormat(json['prodotto']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'quantita': quantita,
      'prodotto': prodotto.toJson(),
    };
  }
}
