import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ble_service.dart';

class BleState {
  const BleState({
    this.scanning = false,
    this.results = const [],
    this.device,
    this.services = const [],
    this.notifyCharacteristic,
    this.writeCharacteristic,
    this.testing = false,
    this.rawData = const [],
  });

  final bool scanning;
  final List<ScanResult> results;
  final BluetoothDevice? device;
  final List<BluetoothService> services;
  final BluetoothCharacteristic? notifyCharacteristic;
  final BluetoothCharacteristic? writeCharacteristic;
  final bool testing;
  final List<int> rawData;

  BleState copyWith({
    bool? scanning,
    List<ScanResult>? results,
    BluetoothDevice? device,
    List<BluetoothService>? services,
    BluetoothCharacteristic? notifyCharacteristic,
    BluetoothCharacteristic? writeCharacteristic,
    bool? testing,
    List<int>? rawData,
  }) {
    return BleState(
      scanning: scanning ?? this.scanning,
      results: results ?? this.results,
      device: device ?? this.device,
      services: services ?? this.services,
      notifyCharacteristic: notifyCharacteristic ?? this.notifyCharacteristic,
      writeCharacteristic: writeCharacteristic ?? this.writeCharacteristic,
      testing: testing ?? this.testing,
      rawData: rawData ?? this.rawData,
    );
  }
}

class BleController extends StateNotifier<BleState> {
  BleController(this._bleService) : super(const BleState());

  final BleService _bleService;
  StreamSubscription<List<ScanResult>>? _scanSub;
  StreamSubscription<List<int>>? _notifySub;

  Future<void> startScan() async {
    state = state.copyWith(scanning: true, results: []);
    _scanSub?.cancel();
    _scanSub = _bleService.scanResults().listen((results) {
      state = state.copyWith(results: results);
    });
    await _bleService.startScan();
  }

  Future<void> stopScan() async {
    await _bleService.stopScan();
    state = state.copyWith(scanning: false);
  }

  Future<void> connect(BluetoothDevice device) async {
    await _bleService.connect(device);
    state = state.copyWith(device: device);
    await discoverServices();
  }

  Future<void> disconnect() async {
    if (state.device != null) {
      await _bleService.disconnect(state.device!);
    }
    _notifySub?.cancel();
    state = state.copyWith(
      device: null,
      services: [],
      notifyCharacteristic: null,
      writeCharacteristic: null,
      testing: false,
      rawData: [],
    );
  }

  Future<void> discoverServices() async {
    if (state.device == null) return;
    final services = await _bleService.discoverServices(state.device!);
    state = state.copyWith(services: services);
    await _restoreConfig(services);
  }

  Future<void> selectNotify(BluetoothCharacteristic characteristic) async {
    state = state.copyWith(notifyCharacteristic: characteristic);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ble_notify_uuid', characteristic.uuid.str);
  }

  Future<void> selectWrite(BluetoothCharacteristic characteristic) async {
    state = state.copyWith(writeCharacteristic: characteristic);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('ble_write_uuid', characteristic.uuid.str);
  }

  Future<void> startTest() async {
    final writeChar = state.writeCharacteristic;
    final notifyChar = state.notifyCharacteristic;
    if (writeChar == null || notifyChar == null) return;
    await _bleService.write(writeChar, 'START'.codeUnits);
    state = state.copyWith(testing: true);
    _notifySub?.cancel();
    final stream = await _bleService.subscribe(notifyChar);
    _notifySub = stream.listen((data) {
      final updated = List<int>.from(state.rawData)..addAll(data);
      state = state.copyWith(rawData: updated, testing: true);
    });
  }

  Future<void> stopTest() async {
    final writeChar = state.writeCharacteristic;
    if (writeChar != null) {
      await _bleService.write(writeChar, 'STOP'.codeUnits);
    }
    await _notifySub?.cancel();
    state = state.copyWith(testing: false);
  }

  Future<void> clearData() async {
    state = state.copyWith(rawData: []);
  }

  Future<void> _restoreConfig(List<BluetoothService> services) async {
    final prefs = await SharedPreferences.getInstance();
    final notifyUuid = prefs.getString('ble_notify_uuid');
    final writeUuid = prefs.getString('ble_write_uuid');

    BluetoothCharacteristic? notify;
    BluetoothCharacteristic? write;

    for (final service in services) {
      for (final char in service.characteristics) {
        if (notifyUuid != null && char.uuid.str == notifyUuid) {
          notify = char;
        }
        if (writeUuid != null && char.uuid.str == writeUuid) {
          write = char;
        }
      }
    }

    state = state.copyWith(
      notifyCharacteristic: notify,
      writeCharacteristic: write,
    );
  }

  @override
  void dispose() {
    _scanSub?.cancel();
    _notifySub?.cancel();
    super.dispose();
  }
}

final bleServiceProvider = Provider<BleService>((ref) => BleService());

final bleControllerProvider = StateNotifierProvider<BleController, BleState>(
  (ref) => BleController(ref.watch(bleServiceProvider)),
);
