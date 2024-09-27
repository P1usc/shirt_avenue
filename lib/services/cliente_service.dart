import 'package:dio/dio.dart';
import 'package:shirt_avenue/models/cliente.dart';

class ClienteService {
  final Dio _dio = Dio();

  Future<Cliente> getClienteInfo(String accountId) async {
    final response =
        await _dio.get('http://10.11.11.158:1337/api/infoclienti/$accountId');

    if (response.statusCode == 200) {
      return Cliente.fromJson(
          response.data['cliente']); // Assicurati che la chiave sia corretta
    } else {
      throw Exception('Failed to load cliente info');
    }
  }
}
