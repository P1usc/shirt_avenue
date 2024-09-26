import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shirt_avenue/screens/home_screen.dart';
import 'package:shirt_avenue/services/auth_service.dart';
import 'package:shirt_avenue/providers/session_provider.dart'; // Assicurati di importare il tuo SessionProvider

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

      // Qui puoi gestire il login di successo
      print('Login successful: $_errorMessage');

      // Aggiorna lo stato della sessione
      final session = Provider.of<SessionProvider>(context, listen: false);
      await session.login(_usernameController.text, _passwordController.text);

      // Naviga alla HomeScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      print('Errore di login: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
