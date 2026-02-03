import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/auth_repo.dart';
import '../../../data/repositories/profile_repo.dart';
import '../../../data/repositories/tests_repo.dart';

final unidadePatientsProvider = FutureProvider((ref) async {
  final userId = ref.watch(authRepoProvider).currentUser?.id;
  if (userId == null) return <Map<String, dynamic>>[];
  final unitProfile = await ref.watch(profileRepoProvider).fetchUnitProfile(userId);
  final healthUnitId = unitProfile['health_unit_id'] as String?;
  if (healthUnitId == null) return <Map<String, dynamic>>[];
  final tests = await ref.watch(testsRepoProvider).fetchUnidadeTests(healthUnitId);
  final patientIds = tests
      .map((test) => test['patient_user_id'] as String)
      .toSet()
      .toList();
  if (patientIds.isEmpty) return <Map<String, dynamic>>[];
  return ref.watch(profileRepoProvider).fetchProfilesByIds(patientIds);
});

class UnidadePatientsScreen extends ConsumerWidget {
  const UnidadePatientsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patients = ref.watch(unidadePatientsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pacientes')),
      body: patients.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('Sem pacientes associados.'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final patient = items[index];
              return Card(
                child: ListTile(
                  title: Text(patient['name'] as String? ?? 'Sem nome'),
                  subtitle: Text('ID: ${patient['id']}'),
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
