import 'package:protocol_ffi/protocol_ffi.dart';

import '../../protocol_core.dart';
import '../manager/manager_clib.dart';

extension IDOProtocolCoreManagerExtSyncData on IDOProtocolCoreManager {

  /// 查找输入的数据同步类型支不支持
  /// @param data_type 数据同步类型
  /// 1  同步血氧
  /// 2  同步压力
  /// 3  同步心率(v3)
  /// 4  同步多运动数据(v3)
  /// 5  同步GPS数据(v3)
  /// 6  同步游泳数据
  /// 7  同步眼动睡眠数据
  /// 8  同步运动数据
  /// 9  同步噪音数据
  /// 10 同步温度数据
  /// 12 同步血压数据
  /// 14 同步呼吸频率数据
  /// 15 同步身体电量数据
  /// 16 同步HRV(心率变异性水平)数据
  ///
  /// @return:
  /// true:支持 false:不支持
  /// 注：方法实现前需获取功能表跟初始化c库
  bool isSupportSyncHealthDataType(int dataType) {
    final rs = IDOProtocolClibManager().cLib.isSupportSyncHealthDataType(dataType);
    print("isSupportSyncHealthDataType dataType:$dataType rs: $rs");
    return rs != 0;
  }

  /// 开关数据同步可靠缓存（默认关闭）
  ///
  /// 开启后须配合 [consumeReliableCacheRecord]；现网未接 consume 的客户请保持关闭。
  int setReliableCacheEnable(bool enable) {
    return IDOProtocolClibManager()
        .cLib
        .setReliableCacheEnable(enable: enable);
  }

  /// 查询数据同步可靠缓存是否开启
  bool isReliableCacheEnabled() {
    return IDOProtocolClibManager().cLib.isReliableCacheEnabled();
  }

  /// 确认一条已落库的 V3 健康同步缓存
  ///
  /// 按条：传完整年月日时分秒；按天：时分秒传 0。
  /// [dataType] 为 C 层 PROTOCOL_V3_HEALTH_DATA_TYPE（由 protocol_lib 从 SyncDataType 映射后传入）。
  /// 返回 0 成功（含尚未落盘：已记 pending）。
  int consumeReliableCacheRecord({
    required int dataType,
    required int year,
    required int month,
    required int day,
    int hour = 0,
    int minute = 0,
    int second = 0,
  }) {
    return IDOProtocolClibManager().cLib.consumeReliableCacheRecord(
      dataType: dataType,
      year: year,
      month: month,
      day: day,
      hour: hour,
      minute: minute,
      second: second,
    );
  }

  /// 清理全部可靠缓存（不依赖开关）
  int clearReliableCacheRecords() {
    return IDOProtocolClibManager().cLib.clearReliableCacheRecords();
  }
}
