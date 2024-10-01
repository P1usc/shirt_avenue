import 'package:dio/dio.dart';
import 'package:shirt_avenue/models/prodotto.dart';

class ProdottoService {
  final String baseUrl = 'http://10.11.11.135:1337/api';
  final Dio dio = Dio();

  Future<List<Prodotto>> getProdotti() async {
    try {
      final response = await dio.get('$baseUrl/prodotti/');

      if (response.statusCode == 200) {
        List<Prodotto> prodotti = (response.data['data'] as List)
            .map((item) => Prodotto.fromJsonOldFormat(item['attributes']))
            .toList();
        return prodotti;
      } else {
        throw Exception('Errore nel recupero dei prodotti');
      }
    } catch (e) {
      throw Exception('Errore di connessione: $e');
    }
  }

  Future<List<Prodotto>> getProdottiScontati() async {
    try {
      final response = await dio.get('$baseUrl/prodotti-scontati/');

      if (response.statusCode == 200) {
        // Check if the response contains the error message
        if (response.data is Map &&
            response.data.containsKey('message') &&
            response.data['message'] == 'Nessun prodotto scontato trovato') {
          // Return an empty list if no discounted products are found
          return [];
        } else {
          // Continue processing the discounted products list
          List<Prodotto> prodottiScontati = (response.data as List)
              .map((item) => Prodotto.fromJsonPreferiti(item))
              .toList();
          return prodottiScontati;
        }
      } else {
        throw Exception('Errore nel recupero dei prodotti scontati');
      }
    } catch (e) {
      throw Exception('Errore di connessione: $e');
    }
  }
}
