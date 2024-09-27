class Carta {
  final String nome;
  final String circuito;
  final String iban;
  final int cvv;
  final double saldo;

  Carta({
    required this.nome,
    required this.circuito,
    required this.iban,
    required this.cvv,
    required this.saldo,
  });

  factory Carta.fromJson(Map<String, dynamic> json) {
    return Carta(
      nome: json['nome'],
      circuito: json['Circuito'],
      iban: json['iban'],
      cvv: json['cvv'],
      saldo: json['saldo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'Circuito': circuito,
      'iban': iban,
      'cvv': cvv,
      'saldo': saldo,
    };
  }
}
