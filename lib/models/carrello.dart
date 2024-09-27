class Carrello {
  final int id;
  final List<dynamic> item_carrelli; // Adjust this type as needed
  final double totale;

  Carrello({
    required this.id,
    required this.item_carrelli,
    required this.totale,
  });

  factory Carrello.fromJson(Map<String, dynamic> json) {
    return Carrello(
      id: json['id'],
      item_carrelli: json['item_carrelli'] ?? [],
      totale: json['totale']?.toDouble() ?? 0.0, // Handle potential null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item_carrelli': item_carrelli,
      'totale': totale,
    };
  }
}
