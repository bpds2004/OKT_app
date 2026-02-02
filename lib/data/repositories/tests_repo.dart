import '../supabase/supabase_client.dart';

class TestsRepo {
  Future<List<Map<String, dynamic>>> fetchTestsForUser(String userId) async {
    final response = await SupabaseClientFactory.client
        .from('tests')
        .select()
        .eq('patient_user_id', userId)
        .order('created_at', ascending: false);
    return response;
  }

  Future<List<Map<String, dynamic>>> fetchTestsForUnit(String healthUnitId) async {
    final response = await SupabaseClientFactory.client
        .from('tests')
        .select()
        .eq('health_unit_id', healthUnitId)
        .order('created_at', ascending: false);
    return response;
  }

  Future<Map<String, dynamic>> createTest(Map<String, dynamic> data) async {
    final response = await SupabaseClientFactory.client
        .from('tests')
        .insert(data)
        .select()
        .single();
    return response;
  }

  Future<void> updateStatus(String testId, String status) async {
    await SupabaseClientFactory.client
        .from('tests')
        .update({'status': status})
        .eq('id', testId);
  }

  Future<Map<String, dynamic>?> fetchTest(String testId) async {
    return SupabaseClientFactory.client
        .from('tests')
        .select()
        .eq('id', testId)
        .maybeSingle();
  }
}
