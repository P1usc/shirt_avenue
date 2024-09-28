import 'package:dio/dio.dart';

class ProdottofiltroService {
  final Dio _dio = Dio();

  Future<List<dynamic>> fetchProdottiPerGenere(String tipo) async {
    try {
      final response = await _dio
          .get('http://192.168.1.160:1337/api/prodotti-per-genere?tipo=$tipo');
      print(response.data); // Controlla la risposta

      // Controlla la struttura della risposta e restituisci i dati correttamente
      if (response.data is List) {
        return response.data; // Se i dati sono direttamente nella lista
      } else if (response.data['data'] is List) {
        return response.data['data']; // Se c'è un ulteriore livello 'data'
      } else {
        throw Exception('Unexpected response format');
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }
}
