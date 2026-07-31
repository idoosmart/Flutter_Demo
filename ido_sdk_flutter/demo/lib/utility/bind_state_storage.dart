import 'dart:convert';

import 'package:flutter_bluetooth/ido_bluetooth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 本地已绑定设备快照（供首页列表恢复）
class BoundDeviceRecord {
  final String name;
  final String macAddress;
  final String? uuid;
  final int? deviceId;
  final bool isBinded;
  final int updatedAt;

  BoundDeviceRecord({
    required this.name,
    required this.macAddress,
    this.uuid,
    this.deviceId,
    this.isBinded = true,
    int? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now().millisecondsSinceEpoch;

  factory BoundDeviceRecord.fromJson(Map<String, dynamic> json) {
    return BoundDeviceRecord(
      name: (json['name'] as String?) ?? '',
      macAddress: (json['macAddress'] as String?) ?? '',
      uuid: json['uuid'] as String?,
      deviceId: json['deviceId'] as int?,
      isBinded: json['isBinded'] as bool? ?? true,
      updatedAt: json['updatedAt'] as int? ??
          DateTime.now().millisecondsSinceEpoch,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'macAddress': macAddress,
        'uuid': uuid,
        'deviceId': deviceId,
        'isBinded': isBinded,
        'updatedAt': updatedAt,
      };

  /// 还原为蓝牙库设备模型，用于点击回连
  IDOBluetoothDeviceModel toDeviceModel() {
    return IDOBluetoothDeviceModel(
      rssi: -2,
      name: name.isNotEmpty ? name : macAddress,
      macAddress: macAddress,
      uuid: uuid,
      deviceId: deviceId,
    );
  }

  factory BoundDeviceRecord.fromDevice(
    IDOBluetoothDeviceModel device, {
    bool isBinded = true,
  }) {
    final mac = device.macAddress ?? '';
    final displayName = (device.name?.isNotEmpty ?? false) ? device.name! : mac;
    return BoundDeviceRecord(
      name: displayName,
      macAddress: mac,
      uuid: device.uuid,
      deviceId: device.deviceId,
      isBinded: isBinded,
    );
  }
}

/// 绑定状态 + 已绑定设备列表持久化
class BindStateStorage {
  static const String _bindStatePrefix = 'bind_state_';
  static const String _boundDevicesKey = 'bound_devices_v1';

  static Future<bool> load(String macAddress) async {
    final prefs = await SharedPreferences.getInstance();
    final isBinded = prefs.getBool('$_bindStatePrefix$macAddress') ?? false;
    print("获取缓存绑定状态：$isBinded $macAddress");
    return isBinded;
  }

  static Future<void> save(String macAddress, bool isBinded) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_bindStatePrefix$macAddress', isBinded);
    print("缓存绑定状态：$isBinded $macAddress");
  }

  static Future<void> clear(String macAddress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_bindStatePrefix$macAddress');
    print("清除缓存的绑定状态：$macAddress");
  }

  /// 读取全部已绑定设备（含旧 bind_state_* 迁移）
  static Future<List<BoundDeviceRecord>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    await _migrateLegacyIfNeeded(prefs);

    final raw = prefs.getString(_boundDevicesKey);
    if (raw == null || raw.isEmpty) {
      return [];
    }
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .whereType<Map>()
          .map((e) => BoundDeviceRecord.fromJson(Map<String, dynamic>.from(e)))
          .where((e) => e.macAddress.isNotEmpty)
          .toList();
    } catch (e) {
      print("解析已绑定设备列表失败: $e");
      return [];
    }
  }

  static Future<List<String>> loadBindedMacAddresses() async {
    final devices = await loadAll();
    return devices
        .where((e) => e.isBinded)
        .map((e) => e.macAddress)
        .toList();
  }

  /// 插入或更新设备快照，并同步 bind bool
  static Future<void> upsert(
    IDOBluetoothDeviceModel device, {
    bool isBinded = true,
  }) async {
    final mac = device.macAddress;
    if (mac == null || mac.isEmpty) {
      print("upsert 失败：macAddress 为空");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final list = await loadAll();
    final record = BoundDeviceRecord.fromDevice(device, isBinded: isBinded);
    final index = list.indexWhere((e) => e.macAddress == mac);
    if (index >= 0) {
      list[index] = record;
    } else {
      list.insert(0, record);
    }
    await prefs.setString(
      _boundDevicesKey,
      jsonEncode(list.map((e) => e.toJson()).toList()),
    );
    await save(mac, isBinded);
    print("upsert 已绑定设备：$mac ${record.name}");
  }

  /// 从列表移除并清除绑定标记
  static Future<void> remove(String macAddress) async {
    if (macAddress.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final list = await loadAll();
    list.removeWhere((e) => e.macAddress == macAddress);
    await prefs.setString(
      _boundDevicesKey,
      jsonEncode(list.map((e) => e.toJson()).toList()),
    );
    await clear(macAddress);
    print("移除已绑定设备：$macAddress");
  }

  /// 兼容旧版仅存 bind_state_* 的数据
  static Future<void> _migrateLegacyIfNeeded(SharedPreferences prefs) async {
    final existing = prefs.getString(_boundDevicesKey);
    if (existing != null && existing.isNotEmpty) {
      return;
    }

    final keys = prefs.getKeys();
    final legacyMacs = keys
        .where((k) => k.startsWith(_bindStatePrefix))
        .where((k) => prefs.getBool(k) == true)
        .map((k) => k.substring(_bindStatePrefix.length))
        .where((mac) => mac.isNotEmpty)
        .toList();

    if (legacyMacs.isEmpty) return;

    final migrated = legacyMacs
        .map((mac) => BoundDeviceRecord(
              name: mac,
              macAddress: mac,
              isBinded: true,
            ))
        .toList();
    await prefs.setString(
      _boundDevicesKey,
      jsonEncode(migrated.map((e) => e.toJson()).toList()),
    );
    print("已迁移旧绑定 MAC 共 ${migrated.length} 台");
  }
}
