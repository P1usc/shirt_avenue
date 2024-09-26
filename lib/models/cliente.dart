class Cliente {
  final String nome;
  final String cognome;
  final String indirizzo;
  final int telefono;
  final String? imgprofile;

  Cliente({
    required this.nome,
    required this.cognome,
    required this.indirizzo,
    required this.telefono,
    this.imgprofile,
  });

  // Factory method to create Cliente from JSON
  factory Cliente.fromJson(Map<String, dynamic> json) {
    return Cliente(
      nome: json['nome'],
      cognome: json['cognome'],
      indirizzo: json['indirizzo'],
      telefono: json['telefono'],
      imgprofile: json['imgprofile'],
    );
  }

  // Method to convert Cliente to JSON
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'cognome': cognome,
      'indirizzo': indirizzo,
      'telefono': telefono,
      'imgprofile': imgprofile,
    };
  }
}
