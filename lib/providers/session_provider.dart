import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shirt_avenue/services/auth_service.dart';

class SessionProvider with ChangeNotifier {
  String _username = '';
  bool _isLoggedIn = false;
  final AuthService _authService = AuthService();

  String get username => _username;
  bool get isLoggedIn => _isLoggedIn;

  // Carica i dati della sessione da SharedPreferences
  Future<void> loadSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username') ?? '';
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    notifyListeners();
  }

  // Effettua il login
  Future<void> login(String username, String password) async {
    try {
      final response = await _authService.login(username, password);

      // Assicurati che la chiave sia corretta per il tuo response
      _username = response['username'] ?? '';
      _isLoggedIn = true;

      // Salva i dati della sessione in SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', _username);
      await prefs.setBool('isLoggedIn', true);
      notifyListeners();
    } catch (error) {
      throw Exception('Login fallito: $error');
    }
  }

  // Effettua il logout
  Future<void> logout() async {
    _username = '';
    _isLoggedIn = false;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.setBool('isLoggedIn', false);
    notifyListeners();
  }
}
