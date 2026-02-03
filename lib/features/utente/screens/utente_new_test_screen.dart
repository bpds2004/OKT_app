import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../ble/controllers/ble_controller.dart';
import '../controllers/utente_test_controller.dart';
import '../../../data/repositories/profile_repo.dart';

final healthUnitsProvider = FutureProvider((ref) {
  return ref.watch(profileRepoProvider).fetchHealthUnits();
});

class UtenteNewTestScreen extends ConsumerStatefulWidget {
  const UtenteNewTestScreen({super.key});

  @override
  ConsumerState<UtenteNewTestScreen> createState() => _UtenteNewTestScreenState();
}

class _UtenteNewTestScreenState extends ConsumerState<UtenteNewTestScreen> {
  String? _selectedHealthUnitId;

  @override
  Widget build(BuildContext context) {
    final bleState = ref.watch(bleControllerProvider);
    final bleController = ref.read(bleControllerProvider.notifier);
    final testState = ref.watch(utenteTestControllerProvider);

    ref.listen<AsyncValue<void>>(utenteTestControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (_) => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Teste guardado no Supabase.')),
        ),
        error: (error, stackTrace) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao guardar teste: $error')),
        ),
      );
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Novo Teste')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('1. Ligar dispositivo', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: [
                ElevatedButton(
                  onPressed: bleState.scanning ? null : bleController.startScan,
                  child: const Text('Procurar BLE'),
                ),
                OutlinedButton(
                  onPressed: bleState.scanning ? bleController.stopScan : null,
                  child: const Text('Parar'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...(() {
              final results = bleState.results;
              final hasOkt = results.any(
                (result) => result.device.platformName.startsWith('OKT'),
              );
              final visibleResults = hasOkt
                      ? results.where(
                          (result) => result.device.platformName.startsWith('OKT'),
                        )
                      : results;
              if (visibleResults.isEmpty) {
                return [const Text('Nenhum dispositivo encontrado.')];
              }
              return visibleResults.map((result) {
                return Card(
                  child: ListTile(
                    title: Text(result.device.platformName.isEmpty
                        ? 'Dispositivo sem nome'
                        : result.device.platformName),
                  subtitle: Text('RSSI ${result.rssi}'),
                  trailing: const Icon(Icons.bluetooth),
                  onTap: () => bleController.connect(result.device),
                  ),
                );
              }).toList();
            })(),
            const SizedBox(height: 16),
            const Text('2. Configurar BLE', style: TextStyle(fontSize: 18)),
            if (bleState.device != null) ...[
              Text('Conectado a ${bleState.device!.platformName}'),
              const SizedBox(height: 8),
              ...bleState.services.map((service) {
                return ExpansionTile(
                  title: Text('Service ${service.uuid}'),
                  children: service.characteristics.map((characteristic) {
                    final isNotify = characteristic.properties.notify;
                    final isWrite =
                        characteristic.properties.write || characteristic.properties.writeWithoutResponse;
                    return ListTile(
                      title: Text(characteristic.uuid.str),
                      subtitle: Text(
                        'Notify: $isNotify, Write: $isWrite',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isNotify)
                            IconButton(
                              icon: const Icon(Icons.notifications_active),
                              onPressed: () => bleController.selectNotify(characteristic),
                            ),
                          if (isWrite)
                            IconButton(
                              icon: const Icon(Icons.upload),
                              onPressed: () => bleController.selectWrite(characteristic),
                            ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              }),
            ] else
              const Text('Conecte um dispositivo para listar services.'),
            const SizedBox(height: 16),
            const Text('3. Fazer teste', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Consumer(
              builder: (context, ref, child) {
                final unitsAsync = ref.watch(healthUnitsProvider);
                return unitsAsync.when(
                  data: (units) {
                    if (units.isEmpty) {
                      return const Text('Sem unidades de saúde registadas.');
                    }
                    return DropdownButtonFormField<String>(
                      value: _selectedHealthUnitId,
                      decoration: const InputDecoration(labelText: 'Selecionar unidade de saúde'),
                      items: units
                          .map(
                            (unit) => DropdownMenuItem(
                              value: unit['id'] as String,
                              child: Text('${unit['name']} (${unit['code']})'),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedHealthUnitId = value;
                        });
                      },
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (error, stackTrace) => Text('Erro ao carregar unidades: $error'),
                );
              },
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: [
                ElevatedButton(
                  onPressed: bleState.testing ? null : bleController.startTest,
                  child: const Text('Iniciar Teste'),
                ),
                OutlinedButton(
                  onPressed: bleState.testing ? bleController.stopTest : null,
                  child: const Text('Terminar Teste'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (bleState.rawData.isNotEmpty)
              Text('Bytes recebidos: ${bleState.rawData.length}'),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: testState.isLoading || _selectedHealthUnitId == null
                  ? null
                  : () async {
                      await ref
                          .read(utenteTestControllerProvider.notifier)
                          .finalizeTest(
                            healthUnitId: _selectedHealthUnitId!,
                            rawData: bleState.rawData,
                          );
                      await bleController.clearData();
                      if (context.mounted) {
                        context.go('/utente/teste-realizado');
                      }
                    },
              icon: const Icon(Icons.cloud_upload),
              label: const Text('Guardar no Supabase'),
            ),
          ],
        ),
      ),
    );
  }
}
