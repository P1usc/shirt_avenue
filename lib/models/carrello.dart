import 'package:shirt_avenue/models/item_carrello.dart';

class Carrello {
  final int id;
  final List<ItemCarrello> item_carrelli;

  Carrello({required this.id, required this.item_carrelli});

  factory Carrello.fromJson(Map<String, dynamic> json) {
    var items = json['items'] as List;
    List<ItemCarrello> itemCarrelliList =
        items.map((i) => ItemCarrello.fromJson(i)).toList();

    return Carrello(
      id: json['id'],
      item_carrelli: itemCarrelliList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': item_carrelli.map((item) => item.toJson()).toList(),
    };
  }
}
