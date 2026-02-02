import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../controllers/ble_controller.dart';

class DeviceScanScreen extends ConsumerStatefulWidget {
  const DeviceScanScreen({super.key, required this.onDeviceSelected});

  final void Function(BluetoothDevice device) onDeviceSelected;

  @override
  ConsumerState<DeviceScanScreen> createState() => _DeviceScanScreenState();
}

class _DeviceScanScreenState extends ConsumerState<DeviceScanScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(bleControllerProvider.notifier).startScan();
  }

  @override
  Widget build(BuildContext context) {
    final scanState = ref.watch(bleControllerProvider);
    return Column(
      children: [
        const Text('Selecione um dispositivo OKT para iniciar o teste.'),
        const SizedBox(height: 12),
        Expanded(
          child: scanState.when(
            data: (results) {
              final filtered = results
                  .where((result) => result.device.platformName
                      .toUpperCase()
                      .contains('OKT'))
                  .toList();
              final devices = filtered.isEmpty ? results : filtered;
              if (devices.isEmpty) {
                return const Center(child: Text('Nenhum dispositivo encontrado'));
              }
              return ListView.separated(
                itemCount: devices.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final result = devices[index];
                  return ListTile(
                    title: Text(result.device.platformName.isEmpty
                        ? 'Dispositivo sem nome'
                        : result.device.platformName),
                    subtitle: Text('RSSI: ${result.rssi}'),
                    trailing: const Icon(Icons.bluetooth_connected),
                    onTap: () => widget.onDeviceSelected(result.device),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Erro: $error')),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () => ref.read(bleControllerProvider.notifier).startScan(),
          child: const Text('Procurar novamente'),
        ),
      ],
    );
  }
}
