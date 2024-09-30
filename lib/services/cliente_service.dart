import 'package:dio/dio.dart';
import 'package:shirt_avenue/models/account.dart';
import 'package:shirt_avenue/models/cliente.dart';

class ClienteService {
  final String baseUrl = 'http://10.11.11.135:1337/api';
  final Dio dio = Dio();

  Future<Map<String, dynamic>> getInfoCliente(int id) async {
    try {
      final response = await dio.get('$baseUrl/infoclienti/$id');

      if (response.statusCode == 200) {
        // Estrai i dati dell'account e del cliente
        Map<String, dynamic> accountData = response.data['account'];
        Map<String, dynamic> clienteData = response.data['cliente'];

        // Mappa nei rispettivi modelli
        Account account = Account.fromJson(accountData);
        Cliente cliente = Cliente.fromJson(clienteData);

        // Ritorna un dizionario con account e cliente
        return {'account': account, 'cliente': cliente};
      } else {
        throw Exception('Errore nel recupero delle informazioni del cliente');
      }
    } catch (e) {
      throw Exception('Errore di connessione: $e');
    }
  }
}
