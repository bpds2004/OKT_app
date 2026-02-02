import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../data/repositories/auth_repo.dart';
import '../../../data/repositories/profile_repo.dart';
import '../../../data/supabase/supabase_client.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nifController = TextEditingController();
  final _birthController = TextEditingController();
  final _addressController = TextEditingController();
  final _unitNameController = TextEditingController();
  final _unitCodeController = TextEditingController();
  bool _loading = false;
  String _role = 'UTENTE';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _nifController.dispose();
    _birthController.dispose();
    _addressController.dispose();
    _unitNameController.dispose();
    _unitCodeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final authResponse = await ref.read(authRepoProvider).signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
    final user = authResponse.user;
    if (user == null) {
      setState(() => _loading = false);
      return;
    }
    final profileRepo = ref.read(profileRepoProvider);
    await profileRepo.upsertProfile({
      'id': user.id,
      'role': _role,
      'name': _nameController.text.trim(),
    });

    if (_role == 'UTENTE') {
      await profileRepo.upsertPatientProfile({
        'user_id': user.id,
        'phone': _phoneController.text.trim(),
        'nif': _nifController.text.trim(),
        'birth_date': _birthController.text.trim(),
        'address': _addressController.text.trim(),
      });
    } else {
      final client = SupabaseClientFactory.client;
      final unitCode = _unitCodeController.text.trim();
      final existingUnit = await client
          .from('health_units')
          .select()
          .eq('code', unitCode)
          .maybeSingle();
      final unit = existingUnit ??
          await client
              .from('health_units')
              .insert({
                'name': _unitNameController.text.trim(),
                'address': _addressController.text.trim(),
                'code': unitCode,
              })
              .select()
              .single();
      await profileRepo.upsertUnitProfile({
        'user_id': user.id,
        'health_unit_id': unit['id'],
      });
    }

    if (mounted) {
      setState(() => _loading = false);
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Criar conta')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SegmentedButton<String>(
                  segments: const [
                    ButtonSegment(value: 'UTENTE', label: Text('Utente')),
                    ButtonSegment(
                        value: 'UNIDADE_SAUDE', label: Text('Unidade')),
                  ],
                  selected: {_role},
                  onSelectionChanged: (value) {
                    setState(() => _role = value.first);
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Obrigatório' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Obrigatório' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Obrigatório' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Morada'),
                ),
                const SizedBox(height: 12),
                if (_role == 'UTENTE') ...[
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(labelText: 'Telefone'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nifController,
                    decoration: const InputDecoration(labelText: 'NIF'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _birthController,
                    decoration: const InputDecoration(
                      labelText: 'Data de nascimento (YYYY-MM-DD)',
                    ),
                  ),
                ] else ...[
                  TextFormField(
                    controller: _unitNameController,
                    decoration: const InputDecoration(
                        labelText: 'Nome da unidade (novo ou existente)'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Obrigatório' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _unitCodeController,
                    decoration: const InputDecoration(labelText: 'Código da unidade'),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Obrigatório' : null,
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const CircularProgressIndicator()
                      : const Text('Criar conta'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
