import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio();

  AuthService() {
    _dio.options.connectTimeout =
        const Duration(milliseconds: 30000); // Aumenta il timeout a 10 secondi
    _dio.options.receiveTimeout =
        const Duration(milliseconds: 5000); // Mantieni il timeout di ricezione
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    const String url = 'http://10.11.11.158:1337/api/login/';

    try {
      Response response = await _dio.post(
        url,
        data: {
          'identifier': username,
          'password': password,
        },
      );

      print('Risposta API: ${response.data}'); // Aggiunto per debug

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Errore durante il login: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Errore di rete: ${e.message}');
    }
  }
}
