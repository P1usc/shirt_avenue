class Prodotto {
  final int id;
  final String nome;
  final String marca;
  final String categoria;
  final String? shortdescrizione; // Campo nullable
  final double costo;
  final String tipo;
  final dynamic sconto; // Puoi specificare il tipo esatto se lo conosci
  final String prezzoScontato;
  final String pngProd; // URL relativo dell'immagine

  // Host base dell'API
  static const String baseUrl =
      'http://10.11.11.135:1337'; // Sostituisci con il tuo host

  Prodotto({
    required this.id,
    required this.nome,
    required this.marca,
    required this.categoria,
    this.shortdescrizione,
    required this.costo,
    required this.tipo,
    this.sconto,
    required this.prezzoScontato,
    required this.pngProd,
  });

  factory Prodotto.fromJson(Map<String, dynamic> json) {
    // Controlla se pngProd è presente e ha un valore 'url'
    String imageUrl = (json['pngProd'] != null &&
            json['pngProd']['url'] != null)
        ? '$baseUrl${json['pngProd']['url']}'
        : '$baseUrl/default-image.png'; // Percorso predefinito in caso di errore

    return Prodotto(
      id: json['id'],
      nome: json['nome'] ?? 'N/A', // Valore di default se è null
      marca: json['marca'] ?? 'N/A', // Valore di default se è null
      categoria: json['categoria'] ?? 'N/A', // Valore di default se è null
      shortdescrizione: json['shortdescrizione'], // Può essere null
      costo: (json['costo'] ?? 0).toDouble(), // Valore di default se è null
      tipo: json['tipo'] ?? 'N/A', // Valore di default se è null
      sconto: json['sconto'], // Può essere null
      prezzoScontato:
          json['prezzoScontato'] ?? '0.0', // Valore di default se è null
      pngProd: imageUrl, // Utilizza l'URL costruito
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'marca': marca,
      'categoria': categoria,
      'shortdescrizione': shortdescrizione, // Può essere null
      'costo': costo,
      'tipo': tipo,
      'sconto': sconto, // Può essere null
      'prezzoScontato': prezzoScontato,
      'pngProd': {
        'url': pngProd // Mantiene l'URL completo nel formato JSON
      },
    };
  }
}
