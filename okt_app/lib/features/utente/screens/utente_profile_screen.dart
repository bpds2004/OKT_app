import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../controllers/utente_profile_controller.dart';

class UtenteProfileScreen extends ConsumerWidget {
  const UtenteProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(utenteProfileProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: profileState.when(
          data: (profile) {
            final info = {
              'ID Máquina': profile?.deviceId ?? '—',
              'Nome Completo': profile?.fullName ?? '—',
              'Email': profile?.email ?? '—',
              'Número de Telemóvel': profile?.phone ?? '—',
              'Número de Utente': profile?.numeroUtente ?? '—',
              'NIF': profile?.nif ?? '—',
              'Data de Nascimento': profile?.birthDate ?? '—',
              'Histórico Médico': profile?.medicalHistory ?? '—',
              'Médico de Família': profile?.familyDoctor ?? '—',
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
                  onPressed: () => context.push('/utente/profile/edit'),
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
