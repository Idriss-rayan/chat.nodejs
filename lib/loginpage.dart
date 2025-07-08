import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _passwordController = TextEditingController();
  final String _correctPassword = '123456'; // à remplacer plus tard par une API
  String _message = '';

  void _handleLogin() {
    if (_passwordController.text == _correctPassword) {
      setState(() {
        _message = 'Connexion réussie ✅';
      });
    } else {
      setState(() {
        _message = 'Mot de passe incorrect ❌';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: isWide ? 400 : double.infinity),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Connexion',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _handleLogin,
                  child: const Text('Se connecter'),
                ),
                const SizedBox(height: 16),
                Text(_message,
                    style: TextStyle(
                        color: const Color.fromARGB(255, 54, 244, 67))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
