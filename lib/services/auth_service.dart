import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio = Dio();

  AuthService() {
    _dio.options.connectTimeout = const Duration(milliseconds: 100000);
    _dio.options.receiveTimeout = const Duration(milliseconds: 5000);
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

      if (response.statusCode != 200) {
        throw Exception('Errore di rete: ${response.statusCode}');
      }

      if (response.data['message'] != 'Login ha avuto successo') {
        throw Exception(response.data['message'] ?? 'Errore durante il login');
      }

      return response.data;
    } catch (e) {
      throw Exception('Errore durante il login: $e');
    }
  }
}
