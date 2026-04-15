import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:protocol_lib/protocol_lib.dart';

import '../pigeon_generate/data_sync.g.dart';

class DataSyncImpl extends SyncData {

  final _delegate = SyncDataDelegate();

  DataSyncImpl() {
    libManager.syncData.listenSyncStatus().listen((event) {
      debugPrint('pigeon listenSyncStatus:${event.name}');
      _delegate.listenSyncStatus(ApiSyncStatus.values[event.index]);
    });
  }

  @override
  Future<bool> startSyncWithTypes(List<int?> types) {
    final completer = Completer<bool>();
    final items = types.whereType<int>().map((e) => SyncDataType.values[e]).toList();
    libManager.syncData.startSync(types: items, funcProgress: (double progress) {
      _delegate.callbackSyncProgress(progress);
    }, funcData: (SyncDataType type, String jsonStr, int errorCode) {
      final json = _cleanFutureDataIfNeed(type, jsonStr, errorCode);
      _delegate.callbackSyncData(ApiSyncDataType.values[type.index], json, errorCode);
    }, funcCompleted: (int errorCode) {
      _delegate.callbackSyncCompleted(errorCode);
    }).listen((e) {
      completer.complete(e);
    });
    return completer.future;
  }

  @override
  Future<bool> startSync() {
    return startSyncWithTypes([]);
  }

  @override
  void stopSync() {
    libManager.syncData.stopSync();
  }

  @override
  ApiSyncStatus syncStatus() {
    return ApiSyncStatus.values[libManager.syncData.syncStatus.index];
  }

  @override
  List<int?> getSupportSyncDataTypeList() {
    final list = libManager.syncData.getSupportSyncDataTypeList();
    final rs = list.map((e) => e.index).toList();
    return rs;
  }

}

extension _DataSyncImplExt on DataSyncImpl {

  /// 未来数据清洗
  String _cleanFutureDataIfNeed(SyncDataType type,String jsonStr,int errorCode) {
    // 仅处理379设备（id206)
    if (libManager.deviceInfo.deviceId != 379 || errorCode != 0) {
      return jsonStr;
    }

    try {
      // 心率数据过滤掉未来数据
      if (type == SyncDataType.heartRate) {
        // 获取当前时间
        DateTime now = DateTime.now();
        final jsonMap = json.decode(jsonStr);
        // 确保 JSON 数据中的日期是今天的数据
        DateTime jsonDate = DateTime(jsonMap['year'], jsonMap['month'], jsonMap['day']);
        if (jsonDate.year != now.year || jsonDate.month != now.month ||
            jsonDate.day != now.day) {
          //print('JSON 数据不是今天的数据，无需清洗。');
          return jsonStr;
        }

        // 计算当天当前时间的偏移秒数
        int currentOffset = now.hour * 3600 + now.minute * 60 + now.second;

        // 计算每个 item 的绝对偏移值并清洗数据
        List<Map<String, dynamic>> items = List<Map<String, dynamic>>.from(
            jsonMap['items']);
        int cumulativeOffset = 0; // 累加的绝对偏移值
        List<Map<String, dynamic>> cleanedItems = [];

        for (var item in items) {
          // 累加偏移值
          cumulativeOffset += (item['offset'] as int);

          // 如果累加的绝对偏移值小于等于当前的偏移秒数，则保留该记录
          if (cumulativeOffset <= currentOffset) {
            cleanedItems.add({
              'heart_rateVal': item['heart_rateVal'],
              'offset': item['offset']
            });
          } else {
            libManager.cache.writeLog("_cleanFutureDataIfNeed before: ${items.length} after: ${cleanedItems.length}");
            break;
          }
        }

        // 更新清洗后的数据
        jsonMap['items'] = cleanedItems;
        final resJsonStr = json.encode(jsonMap);
        return resJsonStr;
      }
    } catch (e) {
      libManager.cache.writeLog("_cleanFutureDataIfNeed error: $e");
    }
    return jsonStr;
  }
}
