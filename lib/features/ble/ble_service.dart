import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BleService {
  static const _notifyKey = 'ble_notify_characteristic';
  static const _writeKey = 'ble_write_characteristic';

  Stream<List<ScanResult>> scan() {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 6));
    return FlutterBluePlus.scanResults;
  }

  Future<void> stopScan() => FlutterBluePlus.stopScan();

  Future<BluetoothDevice> connect(ScanResult result) async {
    await result.device.connect(autoConnect: false);
    return result.device;
  }

  Future<void> disconnect(BluetoothDevice device) => device.disconnect();

  Future<List<BluetoothService>> discoverServices(BluetoothDevice device) {
    return device.discoverServices();
  }

  Future<void> saveCharacteristics({
    required Guid notify,
    required Guid write,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_notifyKey, notify.toString());
    await prefs.setString(_writeKey, write.toString());
  }

  Future<Map<String, Guid>?> loadCharacteristics() async {
    final prefs = await SharedPreferences.getInstance();
    final notify = prefs.getString(_notifyKey);
    final write = prefs.getString(_writeKey);
    if (notify == null || write == null) return null;
    return {
      'notify': Guid(notify),
      'write': Guid(write),
    };
  }

  Stream<List<int>> subscribeToNotify(
    BluetoothDevice device,
    Guid characteristicId,
  ) async* {
    final services = await device.discoverServices();
    for (final service in services) {
      for (final characteristic in service.characteristics) {
        if (characteristic.uuid == characteristicId) {
          await characteristic.setNotifyValue(true);
          yield* characteristic.lastValueStream;
          return;
        }
      }
    }
  }

  Future<void> writeCommand(
    BluetoothDevice device,
    Guid characteristicId,
    List<int> command,
  ) async {
    final services = await device.discoverServices();
    for (final service in services) {
      for (final characteristic in service.characteristics) {
        if (characteristic.uuid == characteristicId) {
          await characteristic.write(command, withoutResponse: false);
          return;
        }
      }
    }
  }
}
