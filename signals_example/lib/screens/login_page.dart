import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _isLoading = signal(false);
  final _authService = AuthService();

  Future<void> _login() async {
    _isLoading.value = true;
    try {
      await _authService.login(_emailController.text, _passwordController.text);
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              Watch((context) {
                if (_isLoading.value) {
                  return const CircularProgressIndicator();
                }
                return ElevatedButton(
                  onPressed: _login,
                  child: const Text('Login'),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
