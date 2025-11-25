import 'package:rxdart/rxdart.dart';

import '../../type_define/protocol_lib_type.dart';

/// 状态通知 (SDK)
final statusSdkNotification =  PublishSubject<IDOStatusNotification>();

/// 状态通知(设备）
final statusDeviceNotification = PublishSubject<IDODeviceNotificationModel>();

/// 连接状态通知(内部使用）
final connectStatusChanged = PublishSubject<bool>();

/// 连接状态通知(内部使用）
final sdkStateChanged = PublishSubject<void>();

/// 设备原始数据采集通知(内部使用)
final deviceRawDataReportStream = PublishSubject<DeviceRawDataReportModel>();

class DeviceRawDataReportModel {
  /// 1: 算法原始数据采集， 2: 预留字段
  final int dataType;
  final String data;
  DeviceRawDataReportModel(this.dataType, this.data);
}