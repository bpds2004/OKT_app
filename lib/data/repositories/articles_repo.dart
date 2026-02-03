import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase/supabase_client.dart';

class ArticlesRepository {
  ArticlesRepository(this._client);

  final SupabaseClient _client;

  Future<List<Map<String, dynamic>>> fetchLatestArticles({int limit = 3}) async {
    final data = await _client
        .from('articles')
        .select()
        .eq('published', true)
        .order('published_at', ascending: false)
        .limit(limit);
    return (data as List<dynamic>).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> fetchArticles() async {
    final data = await _client
        .from('articles')
        .select()
        .eq('published', true)
        .order('published_at', ascending: false);
    return (data as List<dynamic>).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> fetchArticleBySlug(String slug) async {
    final data = await _client
        .from('articles')
        .select()
        .eq('slug', slug)
        .eq('published', true)
        .single();
    return data;
  }
}

final articlesRepoProvider = Provider<ArticlesRepository>(
  (ref) => ArticlesRepository(SupabaseClientFactory.client),
);
