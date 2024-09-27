import 'package:shirt_avenue/models/cliente.dart';

class Account {
  final int id;
  final String username;
  final String email;
  final Cliente cliente;

  Account({
    required this.id,
    required this.username,
    required this.email,
    required this.cliente,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      cliente: Cliente.fromJson(json['cliente']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'cliente': cliente.toJson(),
    };
  }
}
