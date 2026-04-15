import 'dart:convert';

import 'package:protocol_lib/protocol_lib.dart';

import '../pigeon_generate/cache.g.dart';

class CacheImpl extends Cache {
  @override
  Future<String> alexaPath() async {
    return libManager.cache.alexaPath();
  }

  @override
  Future<String> alexaTestPath() async {
    return libManager.cache.alexaTestPath();
  }

  @override
  Future<String> currentDevicePath() async {
    return await libManager.cache.currentDevicePath() ?? '';
  }

  @override
  Future<String> exportLog() async {
    return await libManager.cache.exportLog() ?? '';
  }

  @override
  Future<bool> loadBindStatus(String macAddress) async {
    return await libManager.cache.loadBindStatus(macAddress: macAddress);
  }

  @override
  Future<String> logPath() async {
    return await libManager.cache.logPath();
  }

  @override
  Future<String> lastConnectDevice() async {
    final rs = await libManager.cache.lastConnectDevice();
    if (rs != null) {
      return jsonEncode(rs.toJson());
    }
    return '{}';
  }

  @override
  Future<List<String?>?> loadDeviceExtListByDisk(bool sortDesc) async {
    final rs =
        await libManager.cache.loadDeviceExtListByDisk(sortDesc: sortDesc);
    if (rs != null && rs.isNotEmpty) {
      final list = <String>[];
      for (final obj in rs) {
        list.add(jsonEncode(obj.toJson()));
      }
      return list;
    }
    return null;
  }
}
