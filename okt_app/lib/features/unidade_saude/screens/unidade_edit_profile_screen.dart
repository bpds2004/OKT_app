import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/health_unit_profile.dart';
import '../../../core/providers.dart';
import '../controllers/health_unit_profile_controller.dart';

class UnidadeEditProfileScreen extends ConsumerStatefulWidget {
  const UnidadeEditProfileScreen({super.key});

  @override
  ConsumerState<UnidadeEditProfileScreen> createState() =>
      _UnidadeEditProfileScreenState();
}

class _UnidadeEditProfileScreenState
    extends ConsumerState<UnidadeEditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _deviceController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _deviceController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(healthUnitProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Editar Perfil')),
      body: profileState.when(
        data: (profile) {
          final user = ref.watch(firebaseAuthProvider).currentUser;
          if (profile != null) {
            _deviceController.text = profile.deviceId;
            _nameController.text = profile.name;
            _emailController.text = profile.email;
            _phoneController.text = profile.phone;
            _addressController.text = profile.address;
            _codeController.text = profile.code;
          }

          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _deviceController,
                      decoration: const InputDecoration(labelText: 'ID Máquina'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Nome Completo'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration:
                          const InputDecoration(labelText: 'Número de Telemóvel'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _addressController,
                      decoration:
                          const InputDecoration(labelText: 'Endereço da Unidade'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _codeController,
                      decoration: const InputDecoration(labelText: 'Código da Unidade'),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () async {
                        if (user == null) return;
                        final updated = HealthUnitProfile(
                          uid: user.uid,
                          name: _nameController.text.trim(),
                          email: _emailController.text.trim(),
                          phone: _phoneController.text.trim(),
                          address: _addressController.text.trim(),
                          code: _codeController.text.trim(),
                          deviceId: _deviceController.text.trim(),
                        );
                        await ref
                            .read(healthUnitProfileControllerProvider)
                            .save(updated);
                        if (mounted) {
                          context.pop();
                        }
                      },
                      child: const Text('Guardar'),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () => context.pop(),
                      child: const Text('Cancelar'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Erro: $error')),
      ),
    );
  }
}
