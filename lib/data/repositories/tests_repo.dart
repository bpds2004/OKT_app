import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase/supabase_client.dart';

class TestsRepository {
  TestsRepository(this._client);

  final SupabaseClient _client;

  Future<Map<String, dynamic>> createTest({
    required String patientUserId,
    required String healthUnitId,
    String status = 'PENDING',
  }) async {
    final data = await _client
        .from('tests')
        .insert({
          'patient_user_id': patientUserId,
          'health_unit_id': healthUnitId,
          'status': status,
        })
        .select()
        .single();
    return data;
  }

  Future<List<Map<String, dynamic>>> fetchUtenteTests(String userId) async {
    final data = await _client
        .from('tests')
        .select('id,status,created_at,health_unit_id')
        .eq('patient_user_id', userId)
        .order('created_at', ascending: false);
    return (data as List<dynamic>).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> fetchUnidadeTests(String healthUnitId) async {
    final data = await _client
        .from('tests')
        .select('id,status,created_at,patient_user_id')
        .eq('health_unit_id', healthUnitId)
        .order('created_at', ascending: false);
    return (data as List<dynamic>).cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>> fetchTest(String testId) async {
    return _client.from('tests').select().eq('id', testId).single();
  }

  Future<void> updateStatus({
    required String testId,
    required String status,
  }) {
    return _client.from('tests').update({'status': status}).eq('id', testId);
  }
}

final testsRepoProvider = Provider<TestsRepository>(
  (ref) => TestsRepository(SupabaseClientFactory.client),
);
