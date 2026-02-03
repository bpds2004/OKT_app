import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/health_unit_profile_controller.dart';

class UnidadeProfileScreen extends ConsumerWidget {
  const UnidadeProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(healthUnitProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: profileState.when(
          data: (profile) {
            final info = {
              'ID Máquina': profile?.deviceId ?? '—',
              'Nome Completo': profile?.name ?? '—',
              'Email': profile?.email ?? '—',
              'Número de Telemóvel': profile?.phone ?? '—',
              'Endereço da Unidade': profile?.address ?? '—',
              'Código da Unidade': profile?.code ?? '—',
            };
            return ListView(
              children: [
                ...info.entries.map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Text('${entry.key}:')),
                        Expanded(child: Text(entry.value)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.push('/unidade/profile/edit'),
                  child: const Text('Editar Perfil'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => context.push('/settings'),
                  child: const Text('Definições de Conta'),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Erro: $error')),
        ),
      ),
    );
  }
}
