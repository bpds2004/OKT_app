import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/results_repo.dart';
import '../../../data/repositories/tests_repo.dart';

final testDetailProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, testId) {
  return ref.watch(testsRepoProvider).fetchTest(testId);
});

final testResultProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, testId) {
  return ref.watch(resultsRepoProvider).fetchResult(testId);
});

final testVariablesProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, testResultId) {
  return ref.watch(resultsRepoProvider).fetchVariables(testResultId);
});

class UtenteReportDetailScreen extends ConsumerWidget {
  const UtenteReportDetailScreen({super.key, required this.testId});

  final String testId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testAsync = ref.watch(testDetailProvider(testId));
    final resultAsync = ref.watch(testResultProvider(testId));

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhe do Relatório')),
      body: testAsync.when(
        data: (test) {
          return resultAsync.when(
            data: (result) {
              if (result == null) {
                return const Center(child: Text('Sem resultado disponível.'));
              }
              final variablesAsync = ref.watch(testVariablesProvider(result['id'] as String));
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text('Status: ${test['status']}'),
                  const SizedBox(height: 8),
                  Text('Resumo: ${result['summary'] ?? ''}'),
                  Text('Risco: ${result['risk_level']}'),
                  const SizedBox(height: 16),
                  const Text('Variáveis identificadas', style: TextStyle(fontSize: 16)),
                  variablesAsync.when(
                    data: (variables) => Column(
                      children: variables
                          .map(
                            (variable) => Card(
                              child: ListTile(
                                title: Text(variable['name'] as String),
                                subtitle: Text(
                                  'Significado: ${variable['significance'] ?? ''}\n'
                                  'Recomendação: ${variable['recommendation'] ?? ''}',
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    loading: () => const LinearProgressIndicator(),
                    error: (error, stackTrace) => Text('Erro: $error'),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(child: Text('Erro: $error')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Erro: $error')),
      ),
    );
  }
}
