import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase/supabase_client.dart';

class ResultsRepository {
  ResultsRepository(this._client);

  final SupabaseClient _client;

  Future<Map<String, dynamic>> createResult({
    required String testId,
    required String summary,
    required String riskLevel,
  }) async {
    final data = await _client
        .from('test_results')
        .insert({
          'test_id': testId,
          'summary': summary,
          'risk_level': riskLevel,
        })
        .select()
        .single();
    return data;
  }

  Future<void> upsertVariables({
    required String testResultId,
    required List<Map<String, String>> variables,
  }) async {
    for (final variable in variables) {
      await _client.from('identified_variables').insert({
        'test_result_id': testResultId,
        'name': variable['name'],
        'significance': variable['significance'],
        'recommendation': variable['recommendation'],
      });
    }
  }

  Future<Map<String, dynamic>?> fetchResult(String testId) async {
    return _client
        .from('test_results')
        .select()
        .eq('test_id', testId)
        .maybeSingle();
  }

  Future<List<Map<String, dynamic>>> fetchVariables(String testResultId) async {
    final data = await _client
        .from('identified_variables')
        .select()
        .eq('test_result_id', testResultId);
    return (data as List<dynamic>).cast<Map<String, dynamic>>();
  }
}

final resultsRepoProvider = Provider<ResultsRepository>(
  (ref) => ResultsRepository(SupabaseClientFactory.client),
);
