import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ble_service.dart';

final bleServiceProvider = Provider<BleService>((ref) => BleService());

class BleController extends StateNotifier<AsyncValue<List<ScanResult>>> {
  BleController(this._bleService) : super(const AsyncValue.data([]));

  final BleService _bleService;
  StreamSubscription<List<ScanResult>>? _scanSub;

  void startScan() {
    _scanSub?.cancel();
    state = const AsyncValue.loading();
    _scanSub = _bleService.scan().listen((results) {
      state = AsyncValue.data(results);
    });
  }

  Future<void> stopScan() async {
    await _bleService.stopScan();
    await _scanSub?.cancel();
  }

  @override
  void dispose() {
    _scanSub?.cancel();
    super.dispose();
  }
}

final bleControllerProvider =
    StateNotifierProvider<BleController, AsyncValue<List<ScanResult>>>(
  (ref) => BleController(ref.watch(bleServiceProvider)),
);
