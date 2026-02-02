import '../supabase/supabase_client.dart';

class ResultsRepo {
  Future<Map<String, dynamic>?> fetchResult(String testId) async {
    return SupabaseClientFactory.client
        .from('test_results')
        .select()
        .eq('test_id', testId)
        .maybeSingle();
  }

  Future<List<Map<String, dynamic>>> fetchVariables(String resultId) async {
    final response = await SupabaseClientFactory.client
        .from('identified_variables')
        .select()
        .eq('test_result_id', resultId);
    return response;
  }

  Future<Map<String, dynamic>> upsertResult(Map<String, dynamic> data) async {
    final response = await SupabaseClientFactory.client
        .from('test_results')
        .upsert(data)
        .select()
        .single();
    return response;
  }

  Future<void> upsertVariables(List<Map<String, dynamic>> data) async {
    if (data.isEmpty) return;
    await SupabaseClientFactory.client.from('identified_variables').upsert(data);
  }
}
