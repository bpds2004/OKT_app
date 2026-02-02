import '../supabase/supabase_client.dart';

class ProfileRepo {
  Future<Map<String, dynamic>?> fetchProfile(String userId) async {
    final response = await SupabaseClientFactory.client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    return response;
  }

  Future<void> upsertProfile(Map<String, dynamic> data) async {
    await SupabaseClientFactory.client.from('profiles').upsert(data);
  }

  Future<void> upsertPatientProfile(Map<String, dynamic> data) async {
    await SupabaseClientFactory.client.from('patient_profiles').upsert(data);
  }

  Future<void> upsertUnitProfile(Map<String, dynamic> data) async {
    await SupabaseClientFactory.client.from('unit_profiles').upsert(data);
  }

  Future<Map<String, dynamic>?> fetchUnitProfile(String userId) async {
    return SupabaseClientFactory.client
        .from('unit_profiles')
        .select('health_unit_id')
        .eq('user_id', userId)
        .maybeSingle();
  }
}
