import 'package:shirt_avenue/models/cliente.dart';

class Account {
  final String username;
  final String email;
  final Cliente cliente; // Rappresenta la relazione con il modello Cliente

  Account({
    required this.username,
    required this.email,
    required this.cliente,
  });

  // Factory method to create Account from JSON
  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      username: json['username'],
      email: json['email'],
      cliente: Cliente.fromJson(
          json['cliente']), // Assicurati che il cliente sia incluso
    );
  }

  // Method to convert Account to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'cliente': cliente.toJson(),
    };
  }
}
