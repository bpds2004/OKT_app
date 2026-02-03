import 'package:flutter/material.dart';

class ReportDetailScreen extends StatelessWidget {
  const ReportDetailScreen({super.key, required this.reportId});

  final String reportId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ID:$reportId')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: Text('Sem resultado',
                style: Theme.of(context).textTheme.titleMedium),
          ),
          const SizedBox(height: 16),
          _InfoCard(
            title: 'Informações Gerais do Relatório',
            rows: const {
              'ID do Relatório': '—',
              'Nome do Paciente': '—',
              'Data do Teste': '—',
              'Genes Testados': '—',
            },
          ),
          const SizedBox(height: 16),
          _InfoCard(
            title: 'Variáveis Identificadas',
            rows: const {
              'Gene': '—',
              'Variante': '—',
              'Classificação': '—',
              'Significado': '—',
            },
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.orangeAccent),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('Consultar um geneticista ou oncologista'),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.share),
            label: const Text('Enviar para médico'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Voltar'),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.rows});

  final String title;
  final Map<String, String> rows;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...rows.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key),
                    Text(entry.value),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
