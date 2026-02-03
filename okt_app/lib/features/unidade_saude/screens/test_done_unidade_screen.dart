import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TestDoneUnidadeScreen extends StatelessWidget {
  const TestDoneUnidadeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teste Realizado')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Icon(Icons.check_circle_outline, size: 72),
            const SizedBox(height: 16),
            Text(
              'Teste concluído com sucesso!',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            const Text('Parabéns! O processo de análise foi finalizado com êxito.'),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: const [
                    Text('Detalhes do Teste'),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('ID do Teste:'), Text('—')],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('Data:'), Text('—')],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('Hora:'), Text('—')],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('Nome do Paciente:'), Text('—')],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Aguarde 1h para receber o seu relatório'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/unidade/home'),
              child: const Text('Voltar à página principal'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => context.push('/unidade/new-test'),
              child: const Text('Novo Teste'),
            ),
          ],
        ),
      ),
    );
  }
}
