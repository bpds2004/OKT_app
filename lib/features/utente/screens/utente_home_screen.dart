import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../data/repositories/articles_repo.dart';

final utenteHighlightsProvider = FutureProvider((ref) {
  return ref.watch(articlesRepoProvider).fetchLatestArticles();
});

class UtenteHomeScreen extends ConsumerWidget {
  const UtenteHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Utente'),
        actions: [
          IconButton(
            onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              title: const Text('Fazer novo teste'),
              subtitle: const Text('Ligação BLE e recolha de dados'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go('/utente/novo-teste'),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Relatórios'),
              subtitle: const Text('Histórico de testes e resultados'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go('/utente/relatorios'),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Notificações'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go('/utente/notificacoes'),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Perfil'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go('/utente/perfil'),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Artigos em destaque', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Consumer(
            builder: (context, ref, child) {
              final articlesAsync = ref.watch(utenteHighlightsProvider);
              return articlesAsync.when(
                data: (articles) {
                  if (articles.isEmpty) {
                    return const Text('Sem artigos publicados.');
                  }
                  return Column(
                    children: articles
                        .map(
                          (article) => Card(
                            child: ListTile(
                              title: Text(article['title'] as String? ?? ''),
                              subtitle: Text(article['excerpt'] as String? ?? ''),
                              onTap: () => context.go('/artigos/${article['slug']}'),
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
                loading: () => const LinearProgressIndicator(),
                error: (error, stackTrace) => Text('Erro: $error'),
              );
            },
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => context.go('/artigos'),
              child: const Text('Ver todos os artigos'),
            ),
          ),
        ],
      ),
    );
  }
}
