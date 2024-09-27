import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shirt_avenue/models/carrello.dart';
import 'package:shirt_avenue/models/item_carrello.dart';
import 'package:shirt_avenue/models/preferito.dart';
import 'package:shirt_avenue/services/auth_service.dart';
import 'package:shirt_avenue/models/account.dart';
import 'package:shirt_avenue/models/cliente.dart';

class SessionProvider with ChangeNotifier {
  String _username = '';
  bool _isLoggedIn = false;
  late Account _account;
  final AuthService _authService = AuthService();

  List<Preferito> _preferiti = [];
  Carrello? _carrello =
      Carrello(id: 0, item_carrelli: []); // Inizializza come vuoto

  String get username => _username;
  bool get isLoggedIn => _isLoggedIn;
  Account get account => _account;
  Cliente get cliente => _account.cliente;
  List<Preferito> get preferiti => _preferiti;
  Carrello? get carrello => _carrello;

  Future<void> loadSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username') ?? '';
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String? accountJson = prefs.getString('account');

    print('Caricamento della sessione...');
    print('Username: $_username');
    print('IsLoggedIn: $_isLoggedIn');

    if (accountJson != null) {
      _account = Account.fromJson(jsonDecode(accountJson));
      print('Account caricato: ${_account.username}');
    } else {
      print('Nessun account trovato nelle preferenze.');
    }

    String? carrelloJson = prefs.getString('carrello');
    if (carrelloJson != null) {
      _carrello = Carrello.fromJson(jsonDecode(carrelloJson));
      print('Carrello caricato: ${jsonEncode(_carrello!.toJson())}');
    } else {
      print('Nessun carrello trovato nelle preferenze.');
      _carrello = Carrello(
          id: 0, item_carrelli: []); // Imposta carrello vuoto se non esiste
    }

    // Carica i preferiti
    String? preferitiJson = prefs.getString('preferiti');
    if (preferitiJson != null) {
      _preferiti = (jsonDecode(preferitiJson) as List)
          .map((p) => Preferito.fromJson(p))
          .toList();
      print('Preferiti caricati: ${_preferiti.length}');
    } else {
      print('Nessun preferito trovato nelle preferenze.');
      _preferiti = []; // Imposta preferiti come vuoti
    }

    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    try {
      final response = await _authService.login(username, password);
      print('Risposta del server: $response');

      if (response.isEmpty) {
        throw Exception('Errore di connessione o il server non ha risposto.');
      }

      if (!response.containsKey('account') || response['account'] == null) {
        throw Exception('La risposta non contiene i dati dell\'account.');
      } else {
        Account account = Account.fromJson({
          'id': response['account']['id'],
          'username': response['account']['username'],
          'email': response['account']['email'],
          // Gestione cliente con indirizzo e telefono null
          'cliente': {
            'id': response['cliente']['id'],
            'nome': response['cliente']['nome'],
            'cognome': response['cliente']['cognome'],
            'indirizzo': response['cliente']['indirizzo'] ??
                '', // Imposta come stringa vuota se null
            'telefono': response['cliente']['telefono'] ??
                '', // Imposta come stringa vuota se null
          },
        });

        print('ID Account salvato: ${account.id}');

        // Parsing dei preferiti
        if (response.containsKey('preferiti') &&
            response['preferiti'] != null) {
          List<dynamic> preferitiJson = response['preferiti'];
          _preferiti = preferitiJson.map((p) => Preferito.fromJson(p)).toList();
          print('Preferiti caricati: ${_preferiti.length}');
        } else {
          print('Nessun preferito trovato nella risposta.');
          _preferiti = []; // Imposta come vuoti se non ci sono preferiti
        }

        // Parsing del carrello
        if (response.containsKey('carrello') && response['carrello'] != null) {
          var carrelloJson = response['carrello'];
          List<ItemCarrello> items = [];

          if (carrelloJson['items'] != null) {
            for (var item in carrelloJson['items']) {
              items.add(ItemCarrello.fromJson(item));
            }
          }

          _carrello = Carrello(id: carrelloJson['id'], item_carrelli: items);
          print('Carrello caricato: ${jsonEncode(_carrello!.toJson())}');
        } else {
          print('Nessun carrello trovato nella risposta.');
          _carrello =
              Carrello(id: 0, item_carrelli: []); // Inizializza come vuoto
        }

        _account = account;
        _isLoggedIn = true;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('accountId', account.id);
        await prefs.setString('username', account.username);
        await prefs.setBool('isLoggedIn', true);

        if (_carrello != null) {
          await prefs.setString('carrello', jsonEncode(_carrello!.toJson()));
          print('Carrello salvato nelle preferenze.');
        }

        if (_preferiti.isNotEmpty) {
          await prefs.setString('preferiti',
              jsonEncode(_preferiti.map((p) => p.toJson()).toList()));
          print('Preferiti salvati nelle preferenze.');
        }

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
    print('Logout in corso...');
    _username = '';
    _isLoggedIn = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('account');
    await prefs.remove('preferiti');
    await prefs.remove('carrello');

    notifyListeners();
  }
}
