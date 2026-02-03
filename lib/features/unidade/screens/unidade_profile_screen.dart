import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/repositories/auth_repo.dart';
import '../../../data/repositories/profile_repo.dart';

final unidadeProfileProvider = FutureProvider((ref) async {
  final userId = ref.watch(authRepoProvider).currentUser?.id;
  if (userId == null) return <String, dynamic>{};
  final profile = await ref.watch(profileRepoProvider).fetchProfile(userId);
  final unitProfile = await ref.watch(profileRepoProvider).fetchUnitProfile(userId);
  return {...profile, ...unitProfile};
});

class UnidadeProfileScreen extends ConsumerStatefulWidget {
  const UnidadeProfileScreen({super.key});

  @override
  ConsumerState<UnidadeProfileScreen> createState() => _UnidadeProfileScreenState();
}

class _UnidadeProfileScreenState extends ConsumerState<UnidadeProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(unidadeProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil da Unidade')),
      body: profileAsync.when(
        data: (profile) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Nome do utilizador: ${profile['name'] ?? ''}'),
                const SizedBox(height: 12),
                Text('Health Unit ID: ${profile['health_unit_id'] ?? ''}'),
                const SizedBox(height: 24),
                ElevatedButton(
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
