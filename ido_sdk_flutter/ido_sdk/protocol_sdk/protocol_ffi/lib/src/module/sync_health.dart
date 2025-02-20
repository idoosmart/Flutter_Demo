import 'dart:typed_data';
import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart' as pkg_ffi;

import '../ido_protocol_fii.dart';

// 同步健康数据
extension IDOProtocolAPIExtSyncHealthData on IDOProtocolAPI {
  // /// 开始同步配置信息,如果app需要绑定,不要调用此函数同步,发送事件BIND_EVT_START
  // int startSyncConfigInfo() {
  //   return bindings.StartSyncConfigInf;
  // }
  //
  // /// 停止配置信息
  // int stopSyncConfigInfo() {
  //   return bindings.StopSyncConfigInfo();
  // }

  /// 开始同步V2健康数据
  int startSyncV2HealthData() {
    return bindings.StartSyncV2HealthData();
  }

  /// 停止同步V2健康数据
  int stopSyncV2HealthData() {
    return bindings.StopSyncV2HealthData();
  }

  /// 设置同步健康数据偏移
  ///
  /// type  0 运动数据 , 1 睡眠数据,不支持, 2 心率数据
  int setSyncV2HealthOffset({required int type, required int value}) {
    return bindings.SetSyncV2HealthOffset(type, value);
  }

  /// 解绑清除v3缓存健康数据
  int unBindClearV3HealthData() {
    return bindings.unBindClearV3HealthData();
  }

  /// 开始同步v3健康数据
  int startSyncV3HealthData() {
    return bindings.startSyncV3HealthData();
  }

  /// app每半个小时主动更新 开始同步V3数据，睡眠数据不返回
  int startAutomaticSyncV3HealthData() {
    return bindings.startAutomaticSyncV3HealthData();
  }

  /// 停止同步v3健康数据
  int stopSyncV3HealthData() {
    return bindings.stopSyncV3HealthData();
  }

  /// 同步v3健康数据的自定义一项
  /// @param data_type 数据同步类型
  /// 1 同步血氧
  /// 2 同步压力
  /// 3 同步心率(v3)
  /// 4 同步多运动数据(v3)
  /// 5 同步GPS数据(v3)
  /// 6 同步游泳数据
  /// 7 同步眼动睡眠数据
  /// 8 同步运动数据
  /// 9 同步噪音数据
  /// 10 同步温度数据
  /// 12 同步血压数据
  /// 14 同步呼吸频率数据
  /// 15 同步身体电量数据
  /// 16 同步HRV(心率变异性水平)数据
  ///
  /// @return:
  /// SUCCESS(0)成功 非0失败
  /// (ERROR_NOT_SUPPORTED(6) 不支持
  /// ERROR_INVALID_STATE(8) 非法状态
  /// )
  int syncV3HealthDataCustomResource(int dataType) {
    return bindings.SyncV3HealthDataCustomResource(dataType);
  }

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
  /// 方法实现前需获取功能表跟初始化c库
  int isSupportSyncHealthDataType(int dataType) {
    return bindings.IsSupportSyncHealthDataType(dataType);
  }
}
