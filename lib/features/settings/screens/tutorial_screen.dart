import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TutorialScreen extends StatelessWidget {
  const TutorialScreen({super.key});

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
              'Bem-vindo ao OKT',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Neste tutorial vamos mostrar como ligar o dispositivo, iniciar um teste '
              'e consultar os resultados com segurança.',
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => context.go('/tutorial2'),
              child: const Text('Seguinte'),
            ),
          ],
        ),
      ),
    );
  }
}
