import 'package:dio/dio.dart';
import 'package:shirt_avenue/models/prodotto.dart';

class RicercaProdottoService {
  final String baseUrl = 'http://10.11.11.135:1337/api';
  final Dio dio = Dio();

  Future<List<Prodotto>> cercaProdotti(String valore) async {
    try {
      final response = await dio.get(
        '$baseUrl/ricerca-prod/',
        queryParameters: {
          'valore': valore,
        },
      );

      if (response.statusCode == 200) {
        // Assuming the response is a list of products
        List<Prodotto> prodotti = (response.data as List)
            .map((item) => Prodotto.fromJsonOldFormat(item))
            .toList();
        return prodotti;
      } else {
        throw Exception(
            'Errore nel recupero dei prodotti: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Errore di connessione: $e');
    }
  }
}
