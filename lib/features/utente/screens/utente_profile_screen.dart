import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/repositories/auth_repo.dart';
import '../../../data/repositories/profile_repo.dart';

final utenteProfileProvider = FutureProvider((ref) async {
  final userId = ref.watch(authRepoProvider).currentUser?.id;
  if (userId == null) return <String, dynamic>{};
  final profile = await ref.watch(profileRepoProvider).fetchProfile(userId);
  final patient = await ref.watch(profileRepoProvider).fetchPatientProfile(userId);
  return {...profile, ...patient};
});

class UtenteProfileScreen extends ConsumerStatefulWidget {
  const UtenteProfileScreen({super.key});

  @override
  ConsumerState<UtenteProfileScreen> createState() => _UtenteProfileScreenState();
}

class _UtenteProfileScreenState extends ConsumerState<UtenteProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(utenteProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: profileAsync.when(
        data: (profile) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Nome: ${profile['name'] ?? ''}'),
                const SizedBox(height: 8),
                Text('Telefone: ${profile['phone'] ?? ''}'),
                const SizedBox(height: 8),
                Text('NIF: ${profile['nif'] ?? ''}'),
                const SizedBox(height: 8),
                Text('Data de nascimento: ${profile['birth_date'] ?? ''}'),
                const SizedBox(height: 8),
                Text('Morada: ${profile['address'] ?? ''}'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.go('/utente/editar-perfil'),
                  child: const Text('Editar perfil'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => context.go('/definicoes'),
                  child: const Text('Definições'),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Erro: $error')),
      ),
    );
  }
}
