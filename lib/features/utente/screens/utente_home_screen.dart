import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/okt_scaffold.dart';
import '../../auth/controllers/auth_controller.dart';

class UtenteHomeScreen extends ConsumerWidget {
  const UtenteHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OktScaffold(
      title: 'Painel Utente',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Bem-vindo à OKT. O que deseja fazer?'),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => context.go('/utente/novo-teste'),
            child: const Text('Fazer novo teste'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => context.go('/utente/relatorios'),
            child: const Text('Relatórios'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => context.go('/utente/notificacoes'),
            child: const Text('Notificações'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => context.go('/utente/perfil'),
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
