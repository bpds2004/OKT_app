import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/okt_scaffold.dart';
import '../../../data/supabase/supabase_client.dart';
import '../../auth/controllers/auth_controller.dart';

class UtenteProfileScreen extends ConsumerStatefulWidget {
  const UtenteProfileScreen({super.key});

  @override
  ConsumerState<UtenteProfileScreen> createState() => _UtenteProfileScreenState();
}

class _UtenteProfileScreenState extends ConsumerState<UtenteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nifController = TextEditingController();
  final _birthController = TextEditingController();
  final _addressController = TextEditingController();
  bool _loading = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _nifController.dispose();
    _birthController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final user = ref.read(authRepoProvider).currentUser;
    if (user == null) return;
    final profile =
        await ref.read(profileRepoProvider).fetchProfile(user.id);
    final patientProfile = await SupabaseClientFactory.client
        .from('patient_profiles')
        .select()
        .eq('user_id', user.id)
        .maybeSingle();
    _nameController.text = profile?['name'] ?? '';
    _phoneController.text = patientProfile?['phone'] ?? '';
    _nifController.text = patientProfile?['nif'] ?? '';
    _birthController.text = patientProfile?['birth_date'] ?? '';
    _addressController.text = patientProfile?['address'] ?? '';
    setState(() => _loading = false);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final user = ref.read(authRepoProvider).currentUser;
    if (user == null) return;
    await ref.read(profileRepoProvider).upsertProfile({
      'id': user.id,
      'role': 'UTENTE',
      'name': _nameController.text.trim(),
    });
    await ref.read(profileRepoProvider).upsertPatientProfile({
      'user_id': user.id,
      'phone': _phoneController.text.trim(),
      'nif': _nifController.text.trim(),
      'birth_date': _birthController.text.trim(),
      'address': _addressController.text.trim(),
    });
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Perfil atualizado.')));
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const OktScaffold(
        title: 'Perfil',
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return OktScaffold(
      title: 'Perfil',
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Obrigatório' : null,
            ),
            const SizedBox(height: 12),
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
              decoration: const InputDecoration(labelText: 'Data de nascimento'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Morada'),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _save,
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
