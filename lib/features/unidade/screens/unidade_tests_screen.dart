import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/repositories/auth_repo.dart';
import '../../../data/repositories/profile_repo.dart';
import '../../../data/repositories/tests_repo.dart';

final unidadeHealthUnitProvider = FutureProvider<String?>((ref) async {
  final userId = ref.watch(authRepoProvider).currentUser?.id;
  if (userId == null) return null;
  final profile = await ref.watch(profileRepoProvider).fetchUnitProfile(userId);
  return profile['health_unit_id'] as String?;
});

final unidadeTestsProvider = FutureProvider((ref) async {
  final unitId = await ref.watch(unidadeHealthUnitProvider.future);
  if (unitId == null) return <Map<String, dynamic>>[];
  return ref.watch(testsRepoProvider).fetchUnidadeTests(unitId);
});

class UnidadeTestsScreen extends ConsumerWidget {
  const UnidadeTestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tests = ref.watch(unidadeTestsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Testes')),
      body: tests.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('Sem testes atribuídos.'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final test = items[index];
              return Card(
                child: ListTile(
                  title: Text('Teste ${test['id']}'),
                  subtitle: Text('Status: ${test['status']}'),
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
