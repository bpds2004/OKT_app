import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/utente_profile.dart';
import '../../../core/providers.dart';
import '../controllers/utente_profile_controller.dart';

class UtenteEditProfileScreen extends ConsumerStatefulWidget {
  const UtenteEditProfileScreen({super.key});

  @override
  ConsumerState<UtenteEditProfileScreen> createState() =>
      _UtenteEditProfileScreenState();
}

class _UtenteEditProfileScreenState
    extends ConsumerState<UtenteEditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _deviceController = TextEditingController();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _numeroUtenteController = TextEditingController();
  final _nifController = TextEditingController();
  final _birthController = TextEditingController();
  final _historyController = TextEditingController();
  final _familyDoctorController = TextEditingController();

  @override
  void dispose() {
    _deviceController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _numeroUtenteController.dispose();
    _nifController.dispose();
    _birthController.dispose();
    _historyController.dispose();
    _familyDoctorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(utenteProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Editar Perfil')),
      body: profileState.when(
        data: (profile) {
          final user = ref.watch(firebaseAuthProvider).currentUser;
          if (profile != null) {
            _deviceController.text = profile.deviceId;
            _nameController.text = profile.fullName;
            _emailController.text = profile.email;
            _phoneController.text = profile.phone;
            _numeroUtenteController.text = profile.numeroUtente;
            _nifController.text = profile.nif;
            _birthController.text = profile.birthDate;
            _historyController.text = profile.medicalHistory;
            _familyDoctorController.text = profile.familyDoctor;
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
                      controller: _numeroUtenteController,
                      decoration: const InputDecoration(labelText: 'Número de Utente'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nifController,
                      decoration: const InputDecoration(labelText: 'NIF'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _birthController,
                      decoration:
                          const InputDecoration(labelText: 'Data de Nascimento'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _historyController,
                      decoration: const InputDecoration(labelText: 'Histórico Médico'),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _familyDoctorController,
                      decoration: const InputDecoration(
                        labelText: 'Nome do Médico de Família',
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () async {
                        if (user == null) return;
                        final updated = UtenteProfile(
                          uid: user.uid,
                          fullName: _nameController.text.trim(),
                          email: _emailController.text.trim(),
                          phone: _phoneController.text.trim(),
                          numeroUtente: _numeroUtenteController.text.trim(),
                          nif: _nifController.text.trim(),
                          birthDate: _birthController.text.trim(),
                          medicalHistory: _historyController.text.trim(),
                          familyDoctor: _familyDoctorController.text.trim(),
                          deviceId: _deviceController.text.trim(),
                        );
                        await ref
                            .read(utenteProfileControllerProvider)
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
