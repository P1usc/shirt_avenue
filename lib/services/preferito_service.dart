import 'package:dio/dio.dart';

class WishlistService {
  static const String baseUrl = 'http://10.11.11.135:1337/api/wishlist';

  final Dio _dio = Dio();

  // Aggiungi preferito
  Future<void> addToWishlist(int clienteId, List<int> prodottiId) async {
    try {
      final response = await _dio.post(
        '$baseUrl/add',
        data: {
          'clienteId': clienteId,
          'prodottiId': prodottiId,
        },
      );
      print('Prodotto aggiunto ai preferiti: ${response.data}');
    } catch (e) {
      print('Errore durante l\'aggiunta ai preferiti: $e');
      throw Exception('Impossibile aggiungere il prodotto ai preferiti');
    }
  }

  // Rimuovi preferito
  Future<void> removeFromWishlist(int clienteId, int prodottoId) async {
    try {
      final response = await _dio.post(
        '$baseUrl/remove',
        data: {
          'clienteId': clienteId,
          'prodottoId': [prodottoId], // Lista singola per un prodotto
        },
      );
      print('Prodotto rimosso dai preferiti: ${response.data}');
    } catch (e) {
      print('Errore durante la rimozione dai preferiti: $e');
      throw Exception('Impossibile rimuovere il prodotto dai preferiti');
    }
  }
}
