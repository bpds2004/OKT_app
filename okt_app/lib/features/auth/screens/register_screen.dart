import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/health_unit_profile.dart';
import '../../../core/models/utente_profile.dart';
import '../../../core/providers.dart';
import '../../utente/controllers/utente_profile_controller.dart';
import '../../unidade_saude/controllers/health_unit_profile_controller.dart';
import '../controllers/auth_controller.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _numeroUtenteController = TextEditingController();
  final _nifController = TextEditingController();
  final _birthController = TextEditingController();
  final _historyController = TextEditingController();
  final _familyDoctorController = TextEditingController();
  final _addressController = TextEditingController();
  final _unitCodeController = TextEditingController();

  String _role = 'utente';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _numeroUtenteController.dispose();
    _nifController.dispose();
    _birthController.dispose();
    _historyController.dispose();
    _familyDoctorController.dispose();
    _addressController.dispose();
    _unitCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Registo de Utilizador')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nome Completo'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Obrigatório' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Obrigatório' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Número de Telemóvel'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _role == 'utente',
                      onChanged: (value) {
                        if (value == true) {
                          setState(() => _role = 'utente');
                        }
                      },
                    ),
                    const Text('Utente'),
                    const SizedBox(width: 16),
                    Checkbox(
                      value: _role == 'unidade',
                      onChanged: (value) {
                        if (value == true) {
                          setState(() => _role = 'unidade');
                        }
                      },
                    ),
                    const Text('Unidade de Saúde'),
                  ],
                ),
                if (_role == 'utente') ...[
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
                    decoration: const InputDecoration(labelText: 'Data de Nascimento'),
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
                ] else ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(labelText: 'Endereço da Unidade'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _unitCodeController,
                    decoration: const InputDecoration(labelText: 'Código da Unidade'),
                  ),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: authState.isLoading
                      ? null
                      : () async {
                          if (!(_formKey.currentState?.validate() ?? false)) {
                            return;
                          }
                          await ref.read(authControllerProvider.notifier).register(
                                email: _emailController.text.trim(),
                                password: _passwordController.text.trim(),
                                role: _role,
                              );
                          final user = ref.read(firebaseAuthProvider).currentUser;
                          if (user == null) return;
                          if (_role == 'utente') {
                            final profile = UtenteProfile(
                              uid: user.uid,
                              fullName: _nameController.text.trim(),
                              email: _emailController.text.trim(),
                              phone: _phoneController.text.trim(),
                              numeroUtente: _numeroUtenteController.text.trim(),
                              nif: _nifController.text.trim(),
                              birthDate: _birthController.text.trim(),
                              medicalHistory: _historyController.text.trim(),
                              familyDoctor: _familyDoctorController.text.trim(),
                              deviceId: '',
                            );
                            await ref
                                .read(utenteProfileControllerProvider)
                                .save(profile);
                          } else {
                            final profile = HealthUnitProfile(
                              uid: user.uid,
                              name: _nameController.text.trim(),
                              email: _emailController.text.trim(),
                              phone: _phoneController.text.trim(),
                              address: _addressController.text.trim(),
                              code: _unitCodeController.text.trim(),
                              deviceId: '',
                            );
                            await ref
                                .read(healthUnitProfileControllerProvider)
                                .save(profile);
                          }
                          if (mounted) {
                            context.go('/splash');
                          }
                        },
                  child: authState.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Registar'),
                ),
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: const Text('Já tenho conta'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
