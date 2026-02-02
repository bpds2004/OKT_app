import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/providers.dart';
import '../../../data/repositories/auth_repo.dart';
import '../controllers/ble_controller.dart';

class BleTestScreen extends ConsumerStatefulWidget {
  const BleTestScreen({
    super.key,
    required this.device,
    required this.healthUnitId,
  });

  final BluetoothDevice device;
  final String healthUnitId;

  @override
  ConsumerState<BleTestScreen> createState() => _BleTestScreenState();
}

class _BleTestScreenState extends ConsumerState<BleTestScreen> {
  final List<int> _rawData = [];
  StreamSubscription<List<int>>? _notifySub;
  bool _running = false;
  int _seconds = 0;
  Timer? _timer;

  Future<void> _startTest() async {
    final characteristics =
        await ref.read(bleServiceProvider).loadCharacteristics();
    if (characteristics == null) {
      _showMessage('Configure o dispositivo primeiro.');
      return;
    }
    setState(() {
      _running = true;
      _seconds = 0;
      _rawData.clear();
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _seconds++);
    });

    await ref.read(bleServiceProvider).writeCommand(
          widget.device,
          characteristics['write']!,
          'START'.codeUnits,
        );
    _notifySub = ref
        .read(bleServiceProvider)
        .subscribeToNotify(widget.device, characteristics['notify']!)
        .listen((chunk) {
      setState(() {
        _rawData.addAll(chunk);
      });
    });
  }

  Future<void> _stopTest() async {
    if (!_running) return;
    final characteristics =
        await ref.read(bleServiceProvider).loadCharacteristics();
    if (characteristics != null) {
      await ref.read(bleServiceProvider).writeCommand(
            widget.device,
            characteristics['write']!,
            'STOP'.codeUnits,
          );
    }
    await _notifySub?.cancel();
    _timer?.cancel();
    setState(() => _running = false);
    await _saveResult();
  }

  Future<void> _saveResult() async {
    final user = ref.read(authRepoProvider).currentUser;
    if (user == null) return;
    final testsRepo = ref.read(testsRepoProvider);
    final resultsRepo = ref.read(resultsRepoProvider);
    final notificationsRepo = ref.read(notificationsRepoProvider);

    final test = await testsRepo.createTest({
      'patient_user_id': user.id,
      'health_unit_id': widget.healthUnitId,
      'status': 'DONE',
    });

    final result = await resultsRepo.upsertResult({
      'test_id': test['id'],
      'summary': 'Dados recolhidos via BLE (${_rawData.length} bytes).',
      'risk_level': _rawData.isEmpty ? 'BAIXO' : 'MEDIO',
    });

    await resultsRepo.upsertVariables([
      {
        'test_result_id': result['id'],
        'name': 'raw_bytes',
        'significance': 'Dados brutos recolhidos no teste.',
        'recommendation': 'Validar protocolo OKT.',
      }
    ]);

    await notificationsRepo.createNotification({
      'user_id': user.id,
      'title': 'Teste concluído',
      'message': 'O teste foi guardado com sucesso.',
    });

    if (mounted) {
      _showMessage('Teste guardado.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _notifySub?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tempo: $_seconds s'),
        const SizedBox(height: 12),
        Text('Bytes recebidos: ${_rawData.length}'),
        const SizedBox(height: 12),
        if (_rawData.isNotEmpty)
          Text('Últimos bytes: ${_rawData.take(20).toList()}'),
        const SizedBox(height: 24),
        Row(
          children: [
            FilledButton(
              onPressed: _running ? null : _startTest,
              child: const Text('Iniciar Teste'),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: _running ? _stopTest : null,
              child: const Text('Terminar Teste'),
            ),
          ],
        ),
      ],
    );
  }
}
