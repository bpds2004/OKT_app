import 'package:flutter/material.dart';

class UtenteReportsScreen extends StatelessWidget {
  const UtenteReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Relatórios')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                const Text('Ordenar por:'),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: 'Data (Mais Recente)',
                  items: const [
                    DropdownMenuItem(
                      value: 'Data (Mais Recente)',
                      child: Text('Data (Mais Recente)'),
                    ),
                  ],
                  onChanged: (_) {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: Text(
                  'Sem relatórios disponíveis.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
