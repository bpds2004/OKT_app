import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/okt_scaffold.dart';
import '../../../data/repositories/providers.dart';

class UnidadeTestDetailScreen extends ConsumerWidget {
  const UnidadeTestDetailScreen({super.key, required this.testId});

  final String testId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OktScaffold(
      title: 'Teste',
      child: FutureBuilder<Map<String, dynamic>?>(
        future: ref.read(testsRepoProvider).fetchTest(testId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final test = snapshot.data;
          if (test == null) {
            return const Center(child: Text('Teste não encontrado.'));
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID: ${test['id']}'),
              const SizedBox(height: 8),
              Text('Estado atual: ${test['status']}'),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children: [
                  FilledButton(
                    onPressed: () => ref
                        .read(testsRepoProvider)
                        .updateStatus(testId, 'IN_REVIEW'),
                    child: const Text('Marcar em revisão'),
                  ),
                  OutlinedButton(
                    onPressed: () => ref
                        .read(testsRepoProvider)
                        .updateStatus(testId, 'DONE'),
                    child: const Text('Marcar concluído'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () =>
                    context.go('/unidade/testes/$testId/criar-resultado'),
                child: const Text('Criar/Editar resultado'),
              ),
            ],
          );
        },
      ),
    );
  }
}
