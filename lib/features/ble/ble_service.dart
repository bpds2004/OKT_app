import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleService {
  BleService();

  Stream<List<ScanResult>> scanResults() => FlutterBluePlus.scanResults;

  Future<void> startScan({Duration timeout = const Duration(seconds: 8)}) {
    return FlutterBluePlus.startScan(timeout: timeout);
  }

  Future<void> stopScan() {
    return FlutterBluePlus.stopScan();
  }

  Future<void> connect(BluetoothDevice device) {
    return device.connect();
  }

  Future<void> disconnect(BluetoothDevice device) {
    return device.disconnect();
  }

  Future<List<BluetoothService>> discoverServices(BluetoothDevice device) {
    return device.discoverServices();
  }

  Future<Stream<List<int>>> subscribe(BluetoothCharacteristic characteristic) async {
    await characteristic.setNotifyValue(true);
    return characteristic.lastValueStream;
  }

  Future<void> write(
    BluetoothCharacteristic characteristic,
    List<int> data,
  ) {
    return characteristic.write(data, withoutResponse: false);
  }
}
