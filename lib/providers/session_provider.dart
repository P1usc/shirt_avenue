import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shirt_avenue/models/carrello.dart';
import 'package:shirt_avenue/models/item_carrello.dart';
import 'package:shirt_avenue/models/preferito.dart';
import 'package:shirt_avenue/services/auth_service.dart';
import 'package:shirt_avenue/models/account.dart';
import 'package:shirt_avenue/models/cliente.dart';
import 'package:shirt_avenue/models/prodotto.dart';
import 'package:shirt_avenue/services/preferito_service.dart';

class SessionProvider with ChangeNotifier {
  String _username = '';
  bool _isLoggedIn = false;
  late Account _account;
  final AuthService _authService = AuthService();
  final WishlistService _wishlistService =
      WishlistService(); // Inizializza il servizio wishlist

  List<Preferito> _preferiti = [];
  Carrello? _carrello = Carrello(id: 0, item_carrelli: []);

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

    if (accountJson != null) {
      _account = Account.fromJson(jsonDecode(accountJson));
    }

    String? carrelloJson = prefs.getString('carrello');
    if (carrelloJson != null) {
      _carrello = Carrello.fromJson(jsonDecode(carrelloJson));
    } else {
      _carrello = Carrello(id: 0, item_carrelli: []);
    }

    String? preferitiJson = prefs.getString('preferiti');
    if (preferitiJson != null) {
      _preferiti = (jsonDecode(preferitiJson) as List)
          .map((p) => Preferito.fromJson(p))
          .toList();
    } else {
      _preferiti = [];
    }

    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    try {
      final response = await _authService.login(username, password);

      if (!response.containsKey('account') || response['account'] == null) {
        throw Exception('La risposta non contiene i dati dell\'account.');
      } else {
        Account account = Account.fromJson({
          'id': response['account']['id'],
          'username': response['account']['username'],
          'email': response['account']['email'],
          'cliente': {
            'id': response['cliente']['id'],
            'nome': response['cliente']['nome'],
            'cognome': response['cliente']['cognome'],
            'indirizzo': response['cliente']['indirizzo'] ?? '',
            'telefono': response['cliente']['telefono'] ?? '',
          },
        });

        if (response.containsKey('preferiti') &&
            response['preferiti'] != null) {
          List<dynamic> preferitiJson = response['preferiti'];
          _preferiti = preferitiJson.map((p) => Preferito.fromJson(p)).toList();
        } else {
          _preferiti = [];
        }

        if (response.containsKey('carrello') && response['carrello'] != null) {
          var carrelloJson = response['carrello'];
          List<ItemCarrello> items = [];

          if (carrelloJson['items'] != null) {
            for (var item in carrelloJson['items']) {
              items.add(ItemCarrello.fromJson(item));
            }
          }

          _carrello = Carrello(id: carrelloJson['id'], item_carrelli: items);
        } else {
          _carrello = Carrello(id: 0, item_carrelli: []);
        }

        _account = account;
        _isLoggedIn = true;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('accountId', account.id);
        await prefs.setString('username', account.username);
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('account', jsonEncode(account.toJson()));
        if (_carrello != null) {
          await prefs.setString('carrello', jsonEncode(_carrello!.toJson()));
        }
        if (_preferiti.isNotEmpty) {
          await prefs.setString('preferiti',
              jsonEncode(_preferiti.map((p) => p.toJson()).toList()));
        }

        notifyListeners();
      }
    } catch (error) {
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
    await prefs.remove('preferiti');
    await prefs.remove('carrello');
    notifyListeners();
  }

  // Aggiungi un prodotto ai preferiti e chiama l'API
  Future<void> addPreferito(Prodotto prodotto) async {
    final preferito = Preferito(id: prodotto.id, prodotti: [prodotto]);
    _preferiti.add(preferito);

    // Salva localmente
    _savePreferiti();

    // Chiama l'API per aggiungere il prodotto ai preferiti
    try {
      await _wishlistService.addToWishlist(_account.cliente.id, [prodotto.id]);
      notifyListeners();
    } catch (error) {
      print('Errore durante l\'aggiunta ai preferiti: $error');
    }
  }

  // Rimuovi un prodotto dai preferiti e chiama l'API
  Future<void> removePreferito(Prodotto prodotto) async {
    _preferiti.removeWhere(
        (preferito) => preferito.prodotti.any((p) => p.id == prodotto.id));

    // Salva localmente
    _savePreferiti();

    // Chiama l'API per rimuovere il prodotto dai preferiti
    try {
      await _wishlistService.removeFromWishlist(
          _account.cliente.id, prodotto.id);
      notifyListeners();
    } catch (error) {
      print('Errore durante la rimozione dai preferiti: $error');
    }
  }

  // Salva i preferiti nelle SharedPreferences
  Future<void> _savePreferiti() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'preferiti', jsonEncode(_preferiti.map((p) => p.toJson()).toList()));
  }
}
