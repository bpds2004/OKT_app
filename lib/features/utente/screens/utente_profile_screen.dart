import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nifController = TextEditingController();
  final _birthController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _nifController.dispose();
    _birthController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(utenteProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: profileAsync.when(
        data: (profile) {
          if (_nameController.text.isEmpty) {
            _nameController.text = profile['name'] ?? '';
            _phoneController.text = profile['phone'] ?? '';
            _nifController.text = profile['nif'] ?? '';
            _birthController.text = profile['birth_date'] ?? '';
            _addressController.text = profile['address'] ?? '';
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Telefone'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _nifController,
                  decoration: const InputDecoration(labelText: 'NIF'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _birthController,
                  decoration: const InputDecoration(labelText: 'Data de nascimento'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Morada'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    final userId = ref.read(authRepoProvider).currentUser?.id;
                    if (userId == null) return;
                    await ref.read(profileRepoProvider).updateProfile(
                          userId: userId,
                          name: _nameController.text.trim(),
                        );
                    await ref.read(profileRepoProvider).updatePatientProfile(
                          userId: userId,
                          phone: _phoneController.text.trim(),
                          nif: _nifController.text.trim(),
                          birthDate: _birthController.text.trim(),
                          address: _addressController.text.trim(),
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
