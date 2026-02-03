import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(unidadeProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil da Unidade')),
      body: profileAsync.when(
        data: (profile) {
          if (_nameController.text.isEmpty) {
            _nameController.text = profile['name'] ?? '';
          }

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nome do utilizador'),
                ),
                const SizedBox(height: 16),
                Text('Health Unit ID: ${profile['health_unit_id'] ?? ''}'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    final userId = ref.read(authRepoProvider).currentUser?.id;
                    if (userId == null) return;
                    await ref.read(profileRepoProvider).updateProfile(
                          userId: userId,
                          name: _nameController.text.trim(),
                        );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Perfil atualizado.')),
                    );
                  },
                  child: const Text('Guardar'),
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
