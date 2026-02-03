import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/repositories/auth_repo.dart';
import '../../../data/repositories/profile_repo.dart';
import '../../../data/repositories/tests_repo.dart';

final unidadeNewTestsProvider = FutureProvider((ref) async {
  final userId = ref.watch(authRepoProvider).currentUser?.id;
  if (userId == null) return <Map<String, dynamic>>[];
  final profile = await ref.watch(profileRepoProvider).fetchUnitProfile(userId);
  final healthUnitId = profile['health_unit_id'] as String?;
  if (healthUnitId == null) return <Map<String, dynamic>>[];
  return ref
      .watch(testsRepoProvider)
      .fetchUnidadeTestsByStatus(healthUnitId: healthUnitId, status: 'PENDING');
});

class UnidadeNewTestsScreen extends ConsumerWidget {
  const UnidadeNewTestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tests = ref.watch(unidadeNewTestsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Novos Testes')),
      body: tests.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('Sem novos testes pendentes.'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final test = items[index];
              return Card(
                child: ListTile(
                  title: Text('Teste ${test['id']}'),
                  subtitle: Text('Utente: ${test['patient_user_id']}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go('/unidade/testes/${test['id']}'),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Erro: $error')),
      ),
    );
  }
}
