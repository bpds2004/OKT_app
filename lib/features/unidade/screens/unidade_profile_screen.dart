import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/okt_scaffold.dart';
import '../../../data/supabase/supabase_client.dart';
import '../../auth/controllers/auth_controller.dart';

class UnidadeProfileScreen extends ConsumerStatefulWidget {
  const UnidadeProfileScreen({super.key});

  @override
  ConsumerState<UnidadeProfileScreen> createState() =>
      _UnidadeProfileScreenState();
}

class _UnidadeProfileScreenState extends ConsumerState<UnidadeProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _unitNameController = TextEditingController();
  final _unitAddressController = TextEditingController();
  final _unitCodeController = TextEditingController();
  bool _loading = true;
  String? _healthUnitId;

  @override
  void dispose() {
    _nameController.dispose();
    _unitNameController.dispose();
    _unitAddressController.dispose();
    _unitCodeController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final user = ref.read(authRepoProvider).currentUser;
    if (user == null) return;
    final profile =
        await ref.read(profileRepoProvider).fetchProfile(user.id);
    final unitProfile =
        await ref.read(profileRepoProvider).fetchUnitProfile(user.id);
    if (unitProfile != null) {
      final unit = await SupabaseClientFactory.client
          .from('health_units')
          .select()
          .eq('id', unitProfile['health_unit_id'])
          .maybeSingle();
      _healthUnitId = unit?['id'];
      _unitNameController.text = unit?['name'] ?? '';
      _unitAddressController.text = unit?['address'] ?? '';
      _unitCodeController.text = unit?['code'] ?? '';
    }
    _nameController.text = profile?['name'] ?? '';
    setState(() => _loading = false);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final user = ref.read(authRepoProvider).currentUser;
    if (user == null) return;
    await ref.read(profileRepoProvider).upsertProfile({
      'id': user.id,
      'role': 'UNIDADE_SAUDE',
      'name': _nameController.text.trim(),
    });
    if (_healthUnitId != null) {
      await SupabaseClientFactory.client.from('health_units').update({
        'name': _unitNameController.text.trim(),
        'address': _unitAddressController.text.trim(),
      }).eq('id', _healthUnitId!);
    }
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
              decoration: const InputDecoration(labelText: 'Nome do utilizador'),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Obrigatório' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _unitNameController,
              decoration: const InputDecoration(labelText: 'Nome da unidade'),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Obrigatório' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _unitAddressController,
              decoration: const InputDecoration(labelText: 'Morada da unidade'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _unitCodeController,
              decoration: const InputDecoration(labelText: 'Código'),
              readOnly: true,
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
