import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../supabase/supabase_client.dart';

class ProfileRepository {
  ProfileRepository(this._client);

  final SupabaseClient _client;

  Future<String?> fetchRole(String userId) async {
    final response = await _client
        .from('profiles')
        .select('role')
        .eq('id', userId)
        .single();
    return response['role'] as String?;
  }

  Future<void> createUtenteProfile({
    required String userId,
    required String name,
    required String phone,
    required String nif,
    required String birthDate,
    required String address,
  }) async {
    await _client.from('profiles').insert({
      'id': userId,
      'role': 'UTENTE',
      'name': name,
    });
    await _client.from('patient_profiles').insert({
      'user_id': userId,
      'phone': phone,
      'nif': nif,
      'birth_date': birthDate,
      'address': address,
    });
  }

  Future<void> createUnidadeProfile({
    required String userId,
    required String name,
    required String unitName,
    required String unitAddress,
    required String unitCode,
  }) async {
    await _client.from('profiles').insert({
      'id': userId,
      'role': 'UNIDADE_SAUDE',
      'name': name,
    });

    final unit = await _client
        .from('health_units')
        .select('id')
        .eq('code', unitCode)
        .maybeSingle();

    String unitId;
    if (unit == null) {
      final created = await _client
          .from('health_units')
          .insert({
            'name': unitName,
            'address': unitAddress,
            'code': unitCode,
          })
          .select('id')
          .single();
      unitId = created['id'] as String;
    } else {
      unitId = unit['id'] as String;
    }

    await _client.from('unit_profiles').insert({
      'user_id': userId,
      'health_unit_id': unitId,
    });
  }

  Future<Map<String, dynamic>> fetchProfile(String userId) {
    return _client.from('profiles').select().eq('id', userId).single();
  }

  Future<Map<String, dynamic>> fetchPatientProfile(String userId) {
    return _client.from('patient_profiles').select().eq('user_id', userId).single();
  }

  Future<Map<String, dynamic>> fetchUnitProfile(String userId) {
    return _client.from('unit_profiles').select().eq('user_id', userId).single();
  }

  Future<List<Map<String, dynamic>>> fetchHealthUnits() async {
    final data = await _client.from('health_units').select('id,name,code');
    return (data as List<dynamic>).cast<Map<String, dynamic>>();
  }

  Future<List<Map<String, dynamic>>> fetchProfilesByIds(List<String> ids) async {
    if (ids.isEmpty) return [];
    final data = await _client.from('profiles').select('id,name').inFilter('id', ids);
    return (data as List<dynamic>).cast<Map<String, dynamic>>();
  }

  Future<void> updateProfile({
    required String userId,
    required String name,
  }) {
    return _client.from('profiles').update({'name': name}).eq('id', userId);
  }

  Future<void> updatePatientProfile({
    required String userId,
    required String phone,
    required String nif,
    required String birthDate,
    required String address,
  }) {
    return _client
        .from('patient_profiles')
        .update({
          'phone': phone,
          'nif': nif,
          'birth_date': birthDate,
          'address': address,
        })
        .eq('user_id', userId);
  }
}

final profileRepoProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepository(SupabaseClientFactory.client),
);
