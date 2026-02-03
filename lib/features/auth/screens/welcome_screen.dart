import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OKT')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Bem-vindo à OKT',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Registe-se ou entre para começar o teste com o dispositivo OKT.',
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => context.go('/login'),
              child: const Text('Entrar'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => context.go('/register'),
              child: const Text('Criar Conta'),
            ),
          ],
        ),
      ),
    );
  }
}
