import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/repositories/auth_repo.dart';
import '../../../data/repositories/tests_repo.dart';

final utenteTestsProvider = FutureProvider((ref) async {
  final userId = ref.watch(authRepoProvider).currentUser?.id;
  if (userId == null) return <Map<String, dynamic>>[];
  return ref.watch(testsRepoProvider).fetchUtenteTests(userId);
});

class UtenteReportsScreen extends ConsumerWidget {
  const UtenteReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tests = ref.watch(utenteTestsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Relatórios')),
      body: tests.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('Sem relatórios disponíveis.'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final test = items[index];
              return Card(
                child: ListTile(
                  title: Text('Teste ${test['id']}'),
                  subtitle: Text('Status: ${test['status']}'),
                  onTap: () => context.go('/utente/relatorios/${test['id']}'),
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
