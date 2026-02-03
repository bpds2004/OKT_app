import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../data/repositories/articles_repo.dart';

final unidadeHighlightsProvider = FutureProvider((ref) {
  return ref.watch(articlesRepoProvider).fetchLatestArticles();
});

class UnidadeHomeScreen extends ConsumerWidget {
  const UnidadeHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Unidade'),
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
              title: const Text('Testes'),
              subtitle: const Text('Gerir testes da unidade'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go('/unidade/testes'),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Notificações'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go('/unidade/notificacoes'),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Perfil'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go('/unidade/perfil'),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Artigos em destaque', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Consumer(
            builder: (context, ref, child) {
              final articlesAsync = ref.watch(unidadeHighlightsProvider);
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
