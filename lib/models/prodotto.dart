class Prodotto {
  final int id;
  final String nome;
  final double costo;
  final String categoria; // You can use an enum for this
  final String marca;

  Prodotto({
    required this.id,
    required this.nome,
    required this.costo,
    required this.categoria,
    required this.marca,
  });

  factory Prodotto.fromJson(Map<String, dynamic> json) {
    return Prodotto(
      id: json['id'],
      nome: json['nome'],
      costo: (json['costo'] is int)
          ? json['costo'].toDouble()
          : json['costo'], // Assicurati che sia double
      categoria: json['categoria'],
      marca: json['marca'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'costo': costo,
      'categoria': categoria,
      'marca': marca,
    };
  }
}
