import 'package:flutter/material.dart';
import 'package:shirt_avenue/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  void _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Reset dell'errore
    });

    final AuthService authService = AuthService();

    try {
      var response = await authService.login(
        _usernameController.text,
        _passwordController.text,
      );

      // Verifica se ci sono messaggi di errore nel JSON di risposta
      if (response.containsKey('error')) {
        throw Exception(response['error']);
      }

      // Qui puoi gestire il login di successo, ad esempio navigare a un'altra pagina.
      print('Login successful: $response');
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      print('Errore di login: $e'); // Stampa il messaggio d'errore
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                errorText: _errorMessage != null ? '$_errorMessage' : null,
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                errorText: _errorMessage != null ? '$_errorMessage' : null,
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: const Text('Login'),
                  ),
          ],
        ),
      ),
    );
  }
}
