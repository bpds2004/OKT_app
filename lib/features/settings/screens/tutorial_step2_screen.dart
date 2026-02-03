import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TutorialStep2Screen extends StatelessWidget {
  const TutorialStep2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tutorial')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Depois do teste',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Os resultados são guardados no Supabase e ficam disponíveis no histórico. '
              'A unidade de saúde poderá complementar o relatório e enviar notificações.',
            ),
            const Spacer(),
            OutlinedButton(
              onPressed: () => context.go('/tutorial'),
              child: const Text('Voltar'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => context.go('/welcome'),
              child: const Text('Concluir'),
            ),
          ],
        ),
      ),
    );
  }
}
