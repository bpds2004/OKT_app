import 'package:flutter/material.dart';

class PacientesScreen extends StatelessWidget {
  const PacientesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pacientes')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Pesquisar',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Filtro'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('0 Resultados',
                  style: Theme.of(context).textTheme.bodySmall),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Center(
                child: Text(
                  'Sem pacientes associados.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.chevron_left),
                  label: const Text('Anterior'),
                ),
                OutlinedButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.chevron_right),
                  label: const Text('Seguinte'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
