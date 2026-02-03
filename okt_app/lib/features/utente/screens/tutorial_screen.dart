import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TutorialScreen extends StatelessWidget {
  const TutorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tutorial')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _StepCard(
            number: '1',
            title: 'Prepare a Amostra',
            description:
                'Colete a amostra do paciente conforme o protocolo padrão, garantindo a quantidade e qualidade necessárias.',
          ),
          _StepCard(
            number: '2',
            title: 'Insira no Cartucho',
            description:
                'Transfira a amostra para o cartucho, evitando bolhas de ar ou derramamentos.',
          ),
          _StepCard(
            number: '3',
            title: 'Inicie o Dispositivo',
            description:
                'Conecte o cartucho ao dispositivo OKT e pressione o botão "Iniciar".',
          ),
          _StepCard(
            number: '4',
            title: 'Monitore o Progresso',
            description:
                'Aguarde a conclusão do teste. O dispositivo exibirá o tempo restante.',
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.go('/utente/test-done'),
            child: const Text('Iniciar Teste'),
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.number,
    required this.title,
    required this.description,
  });

  final String number;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 14,
              child: Text(number),
            ),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(description),
          ],
        ),
      ),
    );
  }
}
