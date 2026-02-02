import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/okt_scaffold.dart';
import '../../../data/repositories/providers.dart';
import '../../auth/controllers/auth_controller.dart';

class UnidadeTestsScreen extends ConsumerWidget {
  const UnidadeTestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authRepoProvider).currentUser;
    if (user == null) {
      return const OktScaffold(title: 'Testes', child: Text('Sem sessão.'));
    }

    return OktScaffold(
      title: 'Testes',
      child: FutureBuilder<Map<String, dynamic>?>(
        future: ref.read(profileRepoProvider).fetchUnitProfile(user.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final unitProfile = snapshot.data;
          if (unitProfile == null) {
            return const Center(child: Text('Unidade não encontrada.'));
          }
          final healthUnitId = unitProfile['health_unit_id'] as String;
          return FutureBuilder<List<Map<String, dynamic>>>(
            future: ref.read(testsRepoProvider).fetchTestsForUnit(healthUnitId),
            builder: (context, testsSnapshot) {
              if (!testsSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final tests = testsSnapshot.data!;
              if (tests.isEmpty) {
                return const Center(child: Text('Sem testes pendentes.'));
              }
              return ListView.separated(
                itemCount: tests.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final test = tests[index];
                  return ListTile(
                    title: Text('Teste ${test['id']}'),
                    subtitle: Text('Estado: ${test['status']}'),
                    onTap: () => context.go('/unidade/testes/${test['id']}'),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
