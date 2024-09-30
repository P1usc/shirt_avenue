class Prodotto {
  final int id;
  final String nome;
  final String marca;
  final String categoria;
  final String? shortdescrizione;
  final double costo; // Original cost
  final String tipo;
  final dynamic sconto; // Discount info
  final double prezzoScontato; // Changed to double
  final String pngProd;

  static const String baseUrl = 'http://10.11.11.135:1337';

  Prodotto({
    required this.id,
    required this.nome,
    required this.marca,
    required this.categoria,
    this.shortdescrizione,
    required this.costo,
    required this.tipo,
    this.sconto,
    required this.prezzoScontato, // Changed to double
    required this.pngProd,
  });

  factory Prodotto.fromJson(Map<String, dynamic> json) {
    String imageUrl =
        (json['pngProd'] != null && json['pngProd']['url'] != null)
            ? '$baseUrl${json['pngProd']['url']}'
            : '$baseUrl/default-image.png';

    return Prodotto(
      id: json['id'],
      nome: json['nome'] ?? 'N/A',
      marca: json['marca'] ?? 'N/A',
      categoria: json['categoria'] ?? 'N/A',
      shortdescrizione: json['shortdescrizione'],
      costo: _parseDouble(json['costo']), // Correct parsing for original cost
      tipo: json['tipo'] ?? 'N/A',
      sconto: json['sconto'],
      prezzoScontato: _parseDouble(
          json['prezzoScontato']), // Correct parsing for discounted price
      pngProd: imageUrl,
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0; // Handle null case
    if (value is String) {
      return double.tryParse(value) ?? 0.0; // Try to parse as double
    } else if (value is num) {
      return value.toDouble(); // Return as double if it's a number
    }
    return 0.0; // Default case
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'marca': marca,
      'categoria': categoria,
      'shortdescrizione': shortdescrizione,
      'costo': costo,
      'tipo': tipo,
      'sconto': sconto,
      'prezzoScontato': prezzoScontato, // Correct type
      'pngProd': {
        'url': pngProd,
      },
    };
  }
}
