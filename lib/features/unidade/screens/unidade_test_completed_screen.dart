import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class UnidadeTestCompletedScreen extends StatelessWidget {
  const UnidadeTestCompletedScreen({super.key});

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
              'Resultado guardado!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'O relatório foi criado e o utente já pode consultar o resultado.',
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => context.go('/unidade/testes'),
              child: const Text('Voltar aos testes'),
            ),
          ],
        ),
      ),
    );
  }
}
