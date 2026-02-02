import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../../core/widgets/okt_scaffold.dart';
import '../../../data/supabase/supabase_client.dart';
import '../../ble/controllers/ble_controller.dart';
import '../../ble/screens/device_scan_screen.dart';
import '../../ble/screens/device_config_screen.dart';
import '../../ble/screens/ble_test_screen.dart';

class UtenteNewTestScreen extends ConsumerStatefulWidget {
  const UtenteNewTestScreen({super.key});

  @override
  ConsumerState<UtenteNewTestScreen> createState() => _UtenteNewTestScreenState();
}

class _UtenteNewTestScreenState extends ConsumerState<UtenteNewTestScreen> {
  BluetoothDevice? _device;
  String? _healthUnitId;
  List<Map<String, dynamic>> _healthUnits = [];
  bool _loadingUnits = true;

  @override
  void initState() {
    super.initState();
    _loadUnits();
  }

  Future<void> _loadUnits() async {
    final response = await SupabaseClientFactory.client
        .from('health_units')
        .select()
        .order('name');
    setState(() {
      _healthUnits = List<Map<String, dynamic>>.from(response);
      _loadingUnits = false;
    });
  }

  Future<void> _handleDeviceSelected(BluetoothDevice device) async {
    if (_healthUnitId == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Selecione a unidade de saúde.')),
        );
      }
      return;
    }
    await ref.read(bleServiceProvider).connect(device);
    setState(() {
      _device = device;
    });
  }

  @override
  Widget build(BuildContext context) {
    final step = _device == null ? 0 : 1;
    return OktScaffold(
      title: 'Novo teste',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Selecione a unidade de saúde e ligue o dispositivo.'),
          const SizedBox(height: 12),
          _loadingUnits
              ? const Center(child: CircularProgressIndicator())
              : DropdownButtonFormField<String>(
                  value: _healthUnitId,
                  decoration: const InputDecoration(labelText: 'Unidade de saúde'),
                  items: _healthUnits
                      .map(
                        (unit) => DropdownMenuItem(
                          value: unit['id'] as String,
                          child: Text(unit['name'] as String),
                        ),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _healthUnitId = value),
                ),
          const SizedBox(height: 16),
          Expanded(
            child: step == 0
                ? DeviceScanScreen(onDeviceSelected: _handleDeviceSelected)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Configuração do dispositivo'),
                      const SizedBox(height: 8),
                      DeviceConfigScreen(device: _device!),
                      const SizedBox(height: 16),
                      const Text('Executar teste'),
                      const SizedBox(height: 8),
                      BleTestScreen(
                        device: _device!,
                        healthUnitId: _healthUnitId!,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
