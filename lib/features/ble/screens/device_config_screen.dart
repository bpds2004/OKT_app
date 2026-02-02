import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ble_service.dart';
import '../controllers/ble_controller.dart';

class DeviceConfigScreen extends ConsumerStatefulWidget {
  const DeviceConfigScreen({super.key, required this.device});

  final BluetoothDevice device;

  @override
  ConsumerState<DeviceConfigScreen> createState() => _DeviceConfigScreenState();
}

class _DeviceConfigScreenState extends ConsumerState<DeviceConfigScreen> {
  Guid? _notifyCharacteristic;
  Guid? _writeCharacteristic;
  List<BluetoothService> _services = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    final services = await widget.device.discoverServices();
    setState(() {
      _services = services;
      _loading = false;
    });
  }

  Future<void> _save() async {
    if (_notifyCharacteristic == null || _writeCharacteristic == null) return;
    await ref.read(bleServiceProvider).saveCharacteristics(
          notify: _notifyCharacteristic!,
          write: _writeCharacteristic!,
        );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Configuração guardada.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        SizedBox(
          height: 260,
          child: ListView.builder(
            itemCount: _services.length,
            itemBuilder: (context, index) {
              final service = _services[index];
              return ExpansionTile(
                title: Text('Service ${service.uuid}'),
                children: service.characteristics.map((characteristic) {
                  return ListTile(
                    title: Text('Char ${characteristic.uuid}'),
                    subtitle: Text(
                      'Props: ${characteristic.properties}',
                    ),
                    trailing: Wrap(
                      spacing: 8,
                      children: [
                        IconButton(
                          icon: Icon(
                            _notifyCharacteristic == characteristic.uuid
                                ? Icons.notifications_active
                                : Icons.notifications_none,
                          ),
                          onPressed: () {
                            setState(() {
                              _notifyCharacteristic = characteristic.uuid;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            _writeCharacteristic == characteristic.uuid
                                ? Icons.edit
                                : Icons.edit_outlined,
                          ),
                          onPressed: () {
                            setState(() {
                              _writeCharacteristic = characteristic.uuid;
                            });
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
        FilledButton(
          onPressed: _save,
          child: const Text('Guardar seleção'),
        ),
      ],
    );
  }
}
