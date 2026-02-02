import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/okt_scaffold.dart';
import '../../auth/controllers/auth_controller.dart';

class UnidadeHomeScreen extends ConsumerWidget {
  const UnidadeHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OktScaffold(
      title: 'Painel Unidade',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Gestão de testes OKT.'),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => context.go('/unidade/testes'),
            child: const Text('Lista de testes'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => context.go('/unidade/notificacoes'),
            child: const Text('Notificações'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => context.go('/unidade/perfil'),
            child: const Text('Perfil'),
          ),
          const Spacer(),
          TextButton(
            onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
            child: const Text('Terminar sessão'),
          ),
        ],
      ),
    );
  }
}
