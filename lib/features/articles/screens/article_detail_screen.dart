import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/articles_repo.dart';

final articleDetailProvider = FutureProvider.family<Map<String, dynamic>, String>((ref, slug) {
  return ref.watch(articlesRepoProvider).fetchArticleBySlug(slug);
});

class ArticleDetailScreen extends ConsumerWidget {
  const ArticleDetailScreen({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articleAsync = ref.watch(articleDetailProvider(slug));

    return Scaffold(
      appBar: AppBar(title: const Text('Artigo')),
      body: articleAsync.when(
        data: (article) {
          final title = article['title'] as String? ?? '';
          final content = article['content'] as String? ?? '';
          final coverUrl = article['cover_url'] as String?;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              if (coverUrl != null && coverUrl.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    coverUrl,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 180,
                      color: Colors.grey.shade200,
                      alignment: Alignment.center,
                      child: const Text('Imagem indisponível'),
                    ),
                  ),
                )
              else
                Container(
                  height: 180,
                  color: Colors.grey.shade200,
                  alignment: Alignment.center,
                  child: const Text('Imagem indisponível'),
                ),
              const SizedBox(height: 16),
              Text(content),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Erro: $error')),
      ),
    );
  }
}
