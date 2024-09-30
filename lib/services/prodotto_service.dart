import 'package:dio/dio.dart';
import 'package:shirt_avenue/models/prodotto.dart';

class ProdottoService {
  final String baseUrl = 'http://10.11.11.135:1337/api';
  final Dio dio = Dio();

  // Metodo per ottenere tutti i prodotti
  Future<List<Prodotto>> getProdotti() async {
    try {
      final response = await dio.get('$baseUrl/prodotti/');

      if (response.statusCode == 200) {
        List<Prodotto> prodotti = (response.data['data'] as List)
            .map((item) =>
                Prodotto.fromJson(item['attributes'])) // Access 'attributes'
            .toList();
        return prodotti;
      } else {
        throw Exception('Errore nel recupero dei prodotti');
      }
    } catch (e) {
      throw Exception('Errore di connessione: $e');
    }
  }

  // Metodo per ottenere tutti i prodotti scontati
  Future<List<Prodotto>> getProdottiScontati() async {
    try {
      final response = await dio.get('$baseUrl/prodotti-scontati/');

      if (response.statusCode == 200) {
        List<Prodotto> prodottiScontati = (response.data as List)
            .map((item) => Prodotto.fromJson(
                item)) // Mappa i dati in una lista di oggetti Prodotto
            .toList();
        return prodottiScontati;
      } else {
        throw Exception('Errore nel recupero dei prodotti scontati');
      }
    } catch (e) {
      throw Exception('Errore di connessione: $e');
    }
  }
}
