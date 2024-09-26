import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shirt_avenue/services/auth_service.dart';
import 'package:shirt_avenue/models/cliente.dart'; // Assicurati di importare il modello Cliente

class SessionProvider with ChangeNotifier {
  String _username = '';
  bool _isLoggedIn = false;
  Cliente? _cliente; // Dichiarazione del cliente come variabile nullable
  final AuthService _authService = AuthService();

  String get username => _username;
  bool get isLoggedIn => _isLoggedIn;
  Cliente? get cliente => _cliente; // Getter per il cliente

  Future<void> loadSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username') ?? '';
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    try {
      final response = await _authService.login(username, password);

      // Controlla se la risposta contiene i dati attesi
      if (response.containsKey('account') && response['account'] != null) {
        _username =
            response['account']['username']; // Accesso corretto al nome utente
        _isLoggedIn = true;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', _username);
        await prefs.setBool('isLoggedIn', true);
        notifyListeners();
      } else {
        throw Exception('La risposta non contiene i dati dell\'account.');
      }
    } catch (error) {
      throw Exception('Login fallito: $error');
    }
  }

  Future<void> logout() async {
    _username = '';
    _isLoggedIn = false;
    _cliente = null; // Resetta il cliente
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.setBool('isLoggedIn', false);
    notifyListeners();
  }
}
