import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/auth_controller.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  final _phoneController = TextEditingController();
  final _nifController = TextEditingController();
  final _birthController = TextEditingController();
  final _addressController = TextEditingController();

  final _unitNameController = TextEditingController();
  final _unitAddressController = TextEditingController();
  final _unitCodeController = TextEditingController();

  bool _isUtente = true;

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
    _unitAddressController.dispose();
    _unitCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(authControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registo concluído. Verifique o email.')),
          );
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro: $error')),
          );
        },
      );
    });

    final state = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Criar Conta')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Utente')),
                ButtonSegment(value: false, label: Text('Unidade de Saúde')),
              ],
              selected: {_isUtente},
              onSelectionChanged: (value) {
                setState(() {
                  _isUtente = value.first;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            if (_isUtente) ...[
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
                decoration: const InputDecoration(labelText: 'Data de nascimento (AAAA-MM-DD)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Morada'),
              ),
            ] else ...[
              TextField(
                controller: _unitNameController,
                decoration: const InputDecoration(labelText: 'Nome da unidade'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _unitAddressController,
                decoration: const InputDecoration(labelText: 'Morada da unidade'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _unitCodeController,
                decoration: const InputDecoration(labelText: 'Código da unidade'),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: state.isLoading
                  ? null
                  : () async {
                      if (_isUtente) {
                        await ref
                            .read(authControllerProvider.notifier)
                            .registerUtente(
                              email: _emailController.text.trim(),
                              password: _passwordController.text,
                              name: _nameController.text.trim(),
                              phone: _phoneController.text.trim(),
                              nif: _nifController.text.trim(),
                              birthDate: _birthController.text.trim(),
                              address: _addressController.text.trim(),
                            );
                      } else {
                        await ref
                            .read(authControllerProvider.notifier)
                            .registerUnidade(
                              email: _emailController.text.trim(),
                              password: _passwordController.text,
                              name: _nameController.text.trim(),
                              unitName: _unitNameController.text.trim(),
                              unitAddress: _unitAddressController.text.trim(),
                              unitCode: _unitCodeController.text.trim(),
                            );
                      }
                    },
              child: state.isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Criar Conta'),
            ),
          ],
        ),
      ),
    );
  }
}
