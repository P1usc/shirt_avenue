class Prodotto {
  final int id;
  final String nome;
  final String marca;
  final String categoria;
  final String? shortdescrizione;
  final double costo;
  final String lunghezza;
  final dynamic sconto;
  final double prezzoScontato;
  final String pngProd;
  final String taglia;
  final String colore;

  static const String baseUrl = 'http://10.11.11.135:1337';

  Prodotto({
    required this.id,
    required this.nome,
    required this.marca,
    required this.categoria,
    this.shortdescrizione,
    required this.costo,
    required this.lunghezza,
    this.sconto,
    required this.prezzoScontato,
    required this.pngProd,
    required this.taglia,
    required this.colore,
  });

  factory Prodotto.fromJsonPreferiti(Map<String, dynamic> json) {
    String pngProd = json['url'] != null
        ? '$baseUrl${json['url']}'
        : '$baseUrl/default-image.png';

    return Prodotto(
      id: json['id'],
      nome: json['nome'] ?? 'N/A',
      marca: json['marca'] ?? 'N/A',
      categoria: json['categoria'] ?? 'N/A',
      shortdescrizione: json['shortdescrizione'],
      costo: _parseDouble(json['costoOriginale']),
      lunghezza: json['lunghezza'] ??
          'N/A', // Ensure you handle this correctly based on your requirements
      sconto: json['sconto'],
      prezzoScontato: _parseDouble(json['prezzoScontato'] ??
          0.0), // Ensure this is set correctly as needed
      pngProd: pngProd,
      taglia: json['taglia'] ?? 'N/A',
      colore: json['colore'] ?? 'N/A',
    );
  }

  factory Prodotto.fromJsonOldFormat(Map<String, dynamic> json) {
    String pngProd = (json['pngProd'] != null && json['pngProd']['url'] != null)
        ? '$baseUrl${json['pngProd']['url']}'
        : '$baseUrl/default-image.png';

    return Prodotto(
      id: json['id'],
      nome: json['nome'] ?? 'N/A',
      marca: json['marca'] ?? 'N/A',
      categoria: json['categoria'] ?? 'N/A',
      shortdescrizione: json['shortdescrizione'],
      costo: _parseDouble(json['costo']),
      lunghezza: json['lunghezza'] ?? 'N/A', // Ensure this is relevant
      sconto: json['sconto'],
      prezzoScontato: _parseDouble(
          json['prezzoScontato'] ?? 0.0), // Ensure this is set correctly
      pngProd: pngProd,
      taglia: json['taglia'] ?? 'N/A',
      colore: json['colore'] ?? 'N/A',
    );
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    } else if (value is num) {
      return value.toDouble();
    }
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'marca': marca,
      'categoria': categoria,
      'shortdescrizione': shortdescrizione,
      'costoOriginale': costo,
      'lunghezza': lunghezza,
      'sconto': sconto,
      'prezzoScontato': prezzoScontato,
      'pngProd': {'url': pngProd},
      'taglia': taglia,
      'colore': colore,
    };
  }
}
