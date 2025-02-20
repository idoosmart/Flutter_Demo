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
}
