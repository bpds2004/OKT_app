import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/okt_scaffold.dart';
import '../../../data/repositories/providers.dart';

class UtenteReportDetailScreen extends ConsumerWidget {
  const UtenteReportDetailScreen({super.key, required this.testId});

  final String testId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OktScaffold(
      title: 'Detalhe do relatório',
      child: FutureBuilder<Map<String, dynamic>?>(
        future: ref.read(resultsRepoProvider).fetchResult(testId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final result = snapshot.data;
          if (result == null) {
            return const Center(child: Text('Sem resultado para este teste.'));
          }
          return FutureBuilder<List<Map<String, dynamic>>>(
            future: ref.read(resultsRepoProvider).fetchVariables(result['id']),
            builder: (context, varsSnapshot) {
              if (!varsSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final vars = varsSnapshot.data!;
              return ListView(
                children: [
                  Text('Resumo: ${result['summary'] ?? '---'}'),
                  const SizedBox(height: 8),
                  Text('Risco: ${result['risk_level']}'),
                  const SizedBox(height: 16),
                  const Text('Variáveis identificadas'),
                  const SizedBox(height: 8),
                  ...vars.map(
                    (item) => Card(
                      child: ListTile(
                        title: Text(item['name']),
                        subtitle: Text(item['recommendation'] ?? ''),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
