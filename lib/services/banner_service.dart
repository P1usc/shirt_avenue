import 'package:dio/dio.dart';

class BannerService {
  final Dio _dio = Dio();
  final String _baseUrl =
      'http://192.168.1.160:1337/api/banners/?populate=imgbanner';

  Future<List<dynamic>> fetchBanners() async {
    try {
      final response = await _dio.get(_baseUrl);
      if (response.statusCode == 200) {
        print(response.data); // Stampa i dati ricevuti per il debug
        return response.data['data'];
      } else {
        throw Exception('Failed to load banners');
      }
    } catch (e) {
      print(e); // Stampa l'errore per il debug
      throw Exception('Failed to load banners: $e');
    }
  }
}
