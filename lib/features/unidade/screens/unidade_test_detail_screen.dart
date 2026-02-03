import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/repositories/tests_repo.dart';
import '../controllers/unidade_test_controller.dart';

final unidadeTestDetailProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, testId) {
  return ref.watch(testsRepoProvider).fetchTest(testId);
});

class UnidadeTestDetailScreen extends ConsumerWidget {
  const UnidadeTestDetailScreen({super.key, required this.testId});

  final String testId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testAsync = ref.watch(unidadeTestDetailProvider(testId));

    return Scaffold(
      appBar: AppBar(title: const Text('Detalhe do Teste')),
      body: testAsync.when(
        data: (test) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Utente: ${test['patient_user_id']}'),
                const SizedBox(height: 8),
                Text('Status atual: ${test['status']}'),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: test['status'] as String,
                  items: const [
                    DropdownMenuItem(value: 'PENDING', child: Text('PENDING')),
                    DropdownMenuItem(value: 'IN_REVIEW', child: Text('IN_REVIEW')),
                    DropdownMenuItem(value: 'DONE', child: Text('DONE')),
                  ],
                  onChanged: (value) async {
                    if (value == null) return;
                    await ref
                        .read(unidadeTestControllerProvider.notifier)
                        .updateStatus(testId: testId, status: value);
                    ref.invalidate(unidadeTestDetailProvider(testId));
                  },
                  decoration: const InputDecoration(labelText: 'Atualizar status'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.go('/unidade/testes/$testId/criar-resultado'),
                  child: const Text('Criar resultado'),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Erro: $error')),
      ),
    );
  }
}
