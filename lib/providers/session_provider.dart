import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shirt_avenue/models/preferito.dart';
import 'package:shirt_avenue/pages/profilo_page.dart';
import 'package:shirt_avenue/services/auth_service.dart';
import 'package:shirt_avenue/models/account.dart';
import 'package:shirt_avenue/models/cliente.dart';

class SessionProvider with ChangeNotifier {
  String _username = '';
  bool _isLoggedIn = false;
  late Account _account;
  final AuthService _authService = AuthService();
  List<Preferito> _preferiti = []; // Aggiungi i preferiti qui

  String get username => _username;
  bool get isLoggedIn => _isLoggedIn;
  Account get account => _account;
  Cliente get cliente => _account.cliente;
  List<Preferito> get preferiti => _preferiti; // Aggiungi questa riga

  Future<void> loadSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username') ?? '';
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String? accountJson = prefs.getString('account');
    if (accountJson != null) {
      _account = Account.fromJson(jsonDecode(accountJson));
    }
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    try {
      final response = await _authService.login(username, password);

      // Stampa l'intera risposta del server per verificarne il contenuto
      print('Risposta del server: $response');

      // Se la risposta è null o vuota, segnala l'errore
      if (response.isEmpty) {
        throw Exception('Errore di connessione o il server non ha risposto.');
      }

      // Verifica se la risposta contiene i dati dell'account
      if (!response.containsKey('account') || response['account'] == null) {
        throw Exception('La risposta non contiene i dati dell\'account.');
      } else {
        Account account = Account.fromJson({
          'id': response['account']['id'],
          'username': response['account']['username'],
          'email': response['account']['email'],
          'cliente': response['cliente'],
        });

        print('ID Account salvato: ${account.id}');

        // Parsing dei preferiti
        if (response.containsKey('preferiti') &&
            response['preferiti'] != null) {
          List<dynamic> preferitiJson = response['preferiti'];
          _preferiti = preferitiJson.map((p) => Preferito.fromJson(p)).toList();
        }

        _account = account;
        _isLoggedIn = true; // Aggiunto per impostare il login

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('accountId', account.id);
        await prefs.setString('username', account.username);
        await prefs.setBool('isLoggedIn', true);

        MaterialPageRoute(builder: (context) => const ProfiloPage());

        notifyListeners();
      }
    } catch (error) {
      print('Errore durante il login: $error');
      throw Exception('Login fallito: $error');
    }
  }

  void setAccount(Account account) {
    _account = account;
    notifyListeners();
  }

  Future<void> logout() async {
    _username = '';
    _isLoggedIn = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('account');
    await prefs.remove('preferiti'); // Rimuovi i preferiti
    notifyListeners();
  }
}
