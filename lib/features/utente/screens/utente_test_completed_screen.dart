import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UtenteTestCompletedScreen extends StatelessWidget {
  const UtenteTestCompletedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teste Realizado')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Teste concluído com sucesso!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'O resultado já está disponível no seu histórico e foi enviado para a unidade de saúde.',
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => context.go('/utente/relatorios'),
              child: const Text('Ver relatórios'),
            ),
          ],
        ),
      ),
    );
  }
}
