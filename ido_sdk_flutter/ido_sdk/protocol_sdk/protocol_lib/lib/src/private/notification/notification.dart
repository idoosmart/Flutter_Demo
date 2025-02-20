import 'package:rxdart/rxdart.dart';

import '../../type_define/protocol_lib_type.dart';

/// 状态通知 (SDK)
PublishSubject<IDOStatusNotification>? statusSdkNotification;

/// 状态通知(设备）
PublishSubject<IDODeviceNotificationModel>? statusDeviceNotification;

/// 连接状态通知(内部使用）
PublishSubject<bool>? connectStatusChanged;