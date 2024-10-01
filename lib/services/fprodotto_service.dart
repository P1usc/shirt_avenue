import 'package:dio/dio.dart';
import 'package:shirt_avenue/models/prodotto.dart';

class ProdottofiltroService {
  final Dio _dio = Dio();

  Future<List<Prodotto>> fetchProdottiPerGenere(String tipo) async {
    try {
      final response = await _dio
          .get('http://10.11.11.135:1337/api/prodotti-per-genere?tipo=$tipo');
      print(response.data); // Controlla la risposta

      // Controlla la struttura della risposta e restituisci i dati correttamente
      if (response.data is List) {
        List<dynamic> prodottiJson = response.data;

        // Converti ogni elemento della lista in un oggetto Prodotto
        List<Prodotto> prodotti = prodottiJson
            .map((json) => Prodotto.fromJsonOldFormat(json))
            .toList();

        return prodotti;
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      print('Error: ${e.toString()}'); // Mostra l'errore dettagliato
      throw Exception('Failed to load products: $e');
    }
  }
}
