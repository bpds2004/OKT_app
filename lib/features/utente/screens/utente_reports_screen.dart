import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/okt_scaffold.dart';
import '../../../data/repositories/providers.dart';
import '../../auth/controllers/auth_controller.dart';

class UtenteReportsScreen extends ConsumerWidget {
  const UtenteReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authRepoProvider).currentUser;
    if (user == null) {
      return const OktScaffold(title: 'Relatórios', child: Text('Sem sessão.'));
    }

    return OktScaffold(
      title: 'Relatórios',
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: ref.read(testsRepoProvider).fetchTestsForUser(user.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final tests = snapshot.data!;
          if (tests.isEmpty) {
            return const Center(child: Text('Sem testes registados.'));
          }
          return ListView.separated(
            itemCount: tests.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final test = tests[index];
              return ListTile(
                title: Text('Teste ${test['id']}'),
                subtitle: Text('Estado: ${test['status']}'),
                onTap: () => context.go('/utente/relatorios/${test['id']}'),
              );
            },
          );
        },
      ),
    );
  }
}
