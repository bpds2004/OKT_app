import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/repositories/articles_repo.dart';

final articlesListProvider = FutureProvider((ref) {
  return ref.watch(articlesRepoProvider).fetchArticles();
});

class ArticlesListScreen extends ConsumerWidget {
  const ArticlesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articlesAsync = ref.watch(articlesListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Artigos')),
      body: articlesAsync.when(
        data: (articles) {
          if (articles.isEmpty) {
            return const Center(child: Text('Sem artigos publicados.'));
          }
          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              final title = article['title'] as String? ?? '';
              final excerpt = article['excerpt'] as String? ?? '';
              final slug = article['slug'] as String? ?? '';
              return Card(
                child: ListTile(
                  title: Text(title),
                  subtitle: Text(excerpt),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go('/artigos/$slug'),
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
