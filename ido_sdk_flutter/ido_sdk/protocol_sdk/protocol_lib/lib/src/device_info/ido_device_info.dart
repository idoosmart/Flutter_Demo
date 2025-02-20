import 'dart:async';
import 'dart:convert';

import 'package:protocol_core/protocol_core.dart';
import 'package:protocol_lib/protocol_lib.dart';

import '../private/logger/logger.dart';
import 'model/device_info_model.dart';
import 'model/device_info_ext_model.dart';
import 'model/firmware_version_model.dart';
import '../private/local_storage/local_storage.dart';
import '../private/notification/notification.dart';

class IDODeviceInfo {
  IDODeviceInfo._internal() {
    _subjectOnChanged.stream.listen((event) {
      _onDeviceInfoChanged();
    });
  }
  static final _instance = IDODeviceInfo._internal();
  factory IDODeviceInfo() => _instance;

  late final _subjectOnChanged = StreamController<int>.broadcast();

  // 设备信息

  /// 设备模式 0：运动模式，1：睡眠模式
  int get deviceMode => _device?.mode ?? 0;

  /// 电量状态 0:正常, 1:正在充电, 2:充满, 3:电量低
  int get battStatus => _device?.battStatus ?? 0;

  /// 电量级别 0～100
  int get battLevel => _device?.energe ?? 0;

  /// 是否重启 0:未重启 1:重启
  int get rebootFlag => _device?.reboot ?? 0;

  /// 绑定状态 0:未绑定 1:已绑定
  int get bindState => _device?.pairFlag ?? 0;

  /// 绑定类型 0:默认 1:单击 2:长按 3:屏幕点击 横向确认和取消,确认在左边 4:屏幕点击 横向确认和取消,确认在右边
  /// 5:屏幕点击 竖向确认和取消,确认在上边 6:屏幕点击 竖向确认和取消,确认在下边 7:点击(右边一个按键)
  int get bindType => _device?.bindConfirmMethod ?? 0;

  /// 绑定超时 最长为15秒,0表示不超时
  int get bindTimeout => _device?.bindConfirmTimeout ?? 0;

  /// 设备平台 0:nordic, 10:realtek 8762x, 20:cypress psoc6, 30:Apollo3, 40:汇顶, 50:nordic+泰凌微,
  /// 60:泰凌微+5340+no nand flash, 70:汇顶+富瑞坤, 80:5340, 90: 炬芯, 97: 恒玄, 98: 思澈1, 99: 思澈2
  int get platform => _device?.platform ?? 0;

  /// 设备形状类型 0：无效；1：圆形；2：方形的； 3：椭圆
  int get deviceShapeType => _device?.shape ?? 0;

  /// 设备类型 0：无效；1：手环；2：手表
  int get deviceType => _device?.devType ?? 0;

  /// 自定义表盘主版本 从1开始 0:不支持对应的自定义表盘功能
  int get dialMainVersion => _device?.userDefinedDialMainVersion ?? 0;

  /// 固件绑定时候显示勾ui界面 0:不需要 1:需要
  int get showBindChoiceUi => _device?.showBindChoiceUi ?? 0;

  /// 设备id
  int get deviceId => _device?.deivceId ?? 0;

  /// 设备固件主版本号
  int get firmwareVersion => _device?.firmwareVersion ?? 0;

  /// 设备SN
  String? get sn => _device?.snString();

  /// BtName
  String? get btName => _device?.btNameString();

  /// GPS芯片平台 0：无效 1：索尼 sony 2：洛达 Airoh 3：芯与物 icoe
  int get gpsPlatform => _device?.gpsPlatform ?? 0;


  // 扩展信息

  /// （SDK 内部专用， 外部慎用！！！）
  /// 当前设备mac地址 - 无冒号
  String get macAddress => _deviceExt?.macAddress ?? _libMgr.macAddress;

  /// （SDK 内部专用， 外部慎用！！！）
  /// 当前设备mac地址 - 带冒号
  String? get macAddressFull => _deviceExt?.macAddressFull ?? _libMgr.macAddressFull;

  /// （SDK 内部专用， 外部慎用！！！）
  /// 注意：该名称是由调用 libManager.markConnectedDevice(...)传入，sdk不会主去刷新该值
  /// 需要获取最新值可以使用 CmdEvtType.getDeviceName 指令
  String? get deviceName => _deviceExt?.deviceName;

  /// （SDK 内部专用， 外部慎用！！！）
  /// OTA模式
  bool get otaMode => _deviceExt?.otaMode ?? false;

  /// （（SDK 内部专用， 外部慎用！！！）
  /// UUID ios专用
  String? get uuid => _deviceExt?.uuid;

  /// BT macAddress - 带冒号
  String? get macAddressBt => _deviceExt?.macAddressBt;

  // 三级版本

  /// 固件版本version1
  int get fwVersion1 => _fw?.firmwareVersion1 ?? 0;

  /// 固件版本version2
  int get fwVersion2 => _fw?.firmwareVersion2 ?? 0;

  /// 固件版本version3
  int get fwVersion3 => _fw?.firmwareVersion3 ?? 0;

  /// BT版本生效标志位 0：无效 1：说明固件有对应的BT固件
  int get fwBtFlag => _fw?.btFlag ?? 0;

  /// BT的版本version1
  int get fwBtVersion1 => _fw?.btVersion1 ?? 0;

  /// BT的版本version2
  int get fwBtVersion2 => _fw?.btVersion2 ?? 0;

  /// BT的版本version3
  int get fwBtVersion3 => _fw?.btVersion3 ?? 0;

  /// BT的所需要匹配的版本version1
  int get fwBtMatchVersion1 => _fw?.btMatchVersion1 ?? 0;

  /// BT的所需要匹配的版本version2
  int get fwBtMatchVersion2 => _fw?.btMatchVersion2 ?? 0;

  /// BT的所需要匹配的版本version3
  int get fwBtMatchVersion3 => _fw?.btMatchVersion3 ?? 0;

  late final _libMgr = IDOProtocolLibManager();

  /// 设备信息
  DeviceInfoModel? _device;

  /// 设备信息扩展
  DeviceInfoExtModel? _deviceExt;

  /// 固件三级版本
  FirmwareVersionModel? _fw;


  /// 获取otaVersion，动态判断三级版本号
  ///
  /// ```dart
  /// 注：固件三级版本的获取需要走快速配置，在重连或绑定后触发
  /// 可监听以下通知，确保获取完成后使用
  /// libManager.listenStatusNotification((status) {
  ///      if(status == IDOStatusNotification.deviceInfoFwVersionCompleted) {
  ///         // 获取成功
  ///      }
  ///    });
  /// ```
  String getDeviceOtaVersion() {
    if (libManager.funTable.getBleAndBtVersion) {
      return '${fwVersion1.toString()}'
          '.${fwVersion2.toString().padLeft(2, '0')}'
          '.${fwVersion3.toString().padLeft(2, '0')}';
    }
    return "$firmwareVersion";
  }

  /// 刷新设备信息（SDK内部使用）
  Future<IDODeviceInfo?> refreshDeviceInfo({bool forced = true}) async {
    if (!_libMgr.isConnected) {
      logger?.e('Unconnected calls are not supported');
      throw UnsupportedError('Unconnected calls are not supported');
    }

    // 泰凌微OTA不需要存储设备信息
    final notTelink = _libMgr.otaType != IDOOtaType.telink;
    forced = forced || !notTelink;

    _device = await storage?.loadDeviceInfoByDisk();
    _subjectOnChanged.add(0);
    logger?.d('deviceInfo offline：${_device?.toJson().values.length}');
    if (!forced) {
      return Future(() => this);
    }

    return _libMgr.send(evt: CmdEvtType.getDeviceInfo).map((event) {
      if (event.code == 0 && event.json != null) {
        final map = jsonDecode(event.json!);
        _device = DeviceInfoModel.fromJson(map);
        _subjectOnChanged.add(0);
        logger?.d('deviceInfo online：${_device?.toJson().values.length}');
        if (notTelink) {
          storage?.saveDeviceInfoToDisk(_device!);
        }
        statusSdkNotification
            ?.add(IDOStatusNotification.deviceInfoUpdateCompleted);
        return this;
      } else {
        logger?.e('设备信息获取失败');
      }
      return null;
    }).first;
  }

  /// 刷新设备信息 绑定前使用（SDK内部使用）
  Future<IDODeviceInfo?> refreshDeviceInfoBeforeBind(
      {bool forced = true}) async {
    if (!_libMgr.isConnected) {
      throw UnsupportedError('Unconnected calls are not supported');
    }

    // 泰凌微OTA不需要存储设备信息
    final notTelink = _libMgr.otaType != IDOOtaType.telink;
    forced = forced || !notTelink;

    _device = await storage?.loadDeviceInfoByDisk();
    _subjectOnChanged.add(0);
    logger?.d('deviceInfo offline：${_device?.toJson().values.length}');
    if (!forced) {
      return Future(() => this);
    }

    return _libMgr.send(evt: CmdEvtType.getDeviceInfo).map((event) {
      if (event.code == 0 && event.json != null) {
        final map = jsonDecode(event.json!);
        _device = DeviceInfoModel.fromJson(map);
        _subjectOnChanged.add(0);
        logger?.d('deviceInfo online：${_device?.toJson().values.length}');
        if (notTelink) {
          storage?.saveDeviceInfoToDisk(_device!);
        }
        statusSdkNotification
            ?.add(IDOStatusNotification.deviceInfoUpdateCompleted);
        return this;
      }
      return null;
    }).first;
  }

  /// 刷新设备三级版本（SDK内部使用）
  Future<IDODeviceInfo?> refreshFirmwareVersion({bool forced = true}) async {
    if (!_libMgr.isConnected) {
      logger?.e('Unconnected calls are not supported');
      throw UnsupportedError('Unconnected calls are not supported');
    }

    // 泰凌微OTA不需要存储设备信息
    final notTelink = _libMgr.otaType != IDOOtaType.telink;
    forced = forced || !notTelink;

    _fw = await storage?.loadFirmwareVersionByDisk();
    _subjectOnChanged.add(0);
    logger?.d('deviceInfo fw offline：${_fw?.toJson().values.length}');
    if (!forced) {
      return Future(() => this);
    }

    return _libMgr.send(evt: CmdEvtType.getFirmwareBtVersion).map((event) {
      if (event.code == 0 && event.json != null) {
        final map = jsonDecode(event.json!);
        _fw = FirmwareVersionModel.fromJson(map);
        _subjectOnChanged.add(0);
        logger?.d('deviceInfo fw online：${_fw?.toJson().values.length}');
        if (notTelink) {
          storage?.saveFirmwareVersionToDisk(_fw!);
        }
        statusSdkNotification
            ?.add(IDOStatusNotification.deviceInfoFwVersionCompleted);
        return this;
      }
      return null;
    }).first;
  }

  /// 刷新设备扩展信息（SDK内部使用）
  Future<IDODeviceInfo> refreshDeviceExtInfo() async {
    _deviceExt = storage?.loadDeviceInfoExtWith(libManager.macAddress);
    _subjectOnChanged.add(0);
    return Future(() => this);
  }

  /// 刷新当前设备sn（SDK内部使用）
  Future<IDODeviceInfo?> refreshDeviceSn() async {
    if (!_libMgr.isConnected) {
      logger?.e('Unconnected calls are not supported');
      throw UnsupportedError('Unconnected calls are not supported');
    }
    if (!_libMgr.funTable.getSupportGetSnInfo) {
      logger?.e('refreshDeviceSn not supported');
      return null;
    }

    return _libMgr.send(evt: CmdEvtType.getSnInfo).asyncMap((event) {
      if (event.isOK && event.json != null) {
        final map = jsonDecode(event.json!);
        final sn = map['sn'];
        _device?.sn = sn;
        return this;
      }
      return null;
    }).first;
  }

  /// 刷新当前设备bt name（SDK内部使用）
  Future<IDODeviceInfo?> refreshDeviceBtName() async {
    if (!_libMgr.isConnected) {
      logger?.e('Unconnected calls are not supported');
      throw UnsupportedError('Unconnected calls are not supported');
    }
    if (!(_libMgr.funTable.getBtAddrV2 && _libMgr.funTable.alarmCount > 0)) {
      logger?.e('refreshDeviceBtName not supported');
      return null;
    }

    return _libMgr.send(evt: CmdEvtType.getBtName).asyncMap((event) {
      if (event.isOK && event.json != null) {
        final map = jsonDecode(event.json!);
        final btName = map['bt_name'];
        _device?.btName = btName;
      }
    }).first;
  }

  /// 设置设备BT MacAddress（SDK内部使用）
  void setDeviceBtMacAddress(String macAddressBt) {
    _deviceExt = storage?.loadDeviceInfoExtWith(libManager.macAddress);
    logger?.d("setDeviceBtMacAddress _deviceExt:${_deviceExt?.toJson()} macAddressBt: $macAddressBt");
    _deviceExt?.macAddressBt = macAddressBt;
    _subjectOnChanged.add(0);
  }

  /// 更新内存及缓存中的固件三级版本号
  /// ```dart
  /// macAddress 要修改的设备mac地址
  /// fwVersion1 固件版本version1
  /// fwVersion2 固件版本version2
  /// fwVersion3 固件版本version3
  ///
  void updateDeviceFwVersion({
    required String macAddress,
    required int fwVersion1,
    required int fwVersion2,
    required int fwVersion3
  }) async {
    final macAddr = macAddress.replaceAll(':', '').toUpperCase();
    // 当前连接设备
    if (macAddr == _libMgr.macAddress) {
      logger?.d("updateDeviceFwVersion online macAddr:$macAddr _fw: $_fw");
      if (_fw != null) {
        logger?.d("updateDeviceFwVersion: ${_fw?.firmwareVersion1}.${_fw?.firmwareVersion2}.${_fw?.firmwareVersion3} -> $fwVersion2.$fwVersion2.$fwVersion2");
        _fw?.firmwareVersion1 = fwVersion1;
        _fw?.firmwareVersion2 = fwVersion2;
        _fw?.firmwareVersion3 = fwVersion3;
        await storage?.saveFirmwareVersionToDisk(_fw!);
      }
    } else {
        // TODO 更新缓存
      logger?.d("updateDeviceFwVersion offline macAddr:$macAddr");
    }
  }

  /// 更新内存及缓存中的固件主版本号
  /// ```dart
  /// macAddress 要修改的设备mac地址
  /// firmwareVersion 固件主版本号
  ///
  void updateDeviceFwMainVersion({
    required String macAddress,
    required int firmwareVersion
  }) async {
    final macAddr = macAddress.replaceAll(':', '').toUpperCase();
    // 当前连接设备
    if (macAddr == _libMgr.macAddress) {
      logger?.d("updateDeviceFwMainVersion online macAddr:$macAddr _device: $_device");
      if (_device != null) {
        logger?.d("updateDeviceFwMainVersion: ${_device?.firmwareVersion} -> $firmwareVersion");
        _device?.firmwareVersion = firmwareVersion;
        await storage?.saveDeviceInfoToDisk(_device!);
      }
    } else {
      // TODO 更新缓存
      logger?.d("updateDeviceFwMainVersion offline macAddr:$macAddr");
    }
  }

  /// 清理数据 (SDK内部使用)
  void cleanDataOnMemory() {
    _deviceExt = null;
    _fw = null;
    _device = null;
    _subjectOnChanged.add(0);
  }

  /// 手动设置设备信息（SDK内部使用），外部不要调用
  void innerSetDeviceInfo({
    required int platform,
    required String macAddress,
    required bool otaMode,
    String uuid = '',
    int? deviceId}) {
    logger?.wtf("innerSetDeviceInfo platform: $platform macAddress: $macAddress otaMode: $otaMode uuid: $uuid");
    final tmpMacAddress = macAddress.replaceAll(':', '').toUpperCase();
    _deviceExt = DeviceInfoExtModel(
        macAddress: tmpMacAddress,
        macAddressFull: macAddress,
        macAddressBt: '',
        uuid: uuid,
        otaMode: otaMode,
        updateTime: DateTime.now().millisecondsSinceEpoch);
    _device = DeviceInfoModel(platform: platform, deivceId: deviceId);
    _subjectOnChanged.add(0);
  }

  /// 设备信息变更  (SDK内部使用)
  StreamSubscription onDeviceInfoChanged(void Function(int) func) {
    return _subjectOnChanged.stream.listen(func);
  }
}

extension IDODeviceInfoExt on IDODeviceInfo {
  /// 内部使用
  String toJson() {
    return jsonEncode({
      'deviceMode': deviceMode,
      'battStatus': battStatus,
      'battLevel': battLevel,
      'rebootFlag': rebootFlag,
      'bindState': bindState,
      'bindType': bindType,
      'bindTimeout': bindTimeout,
      'platform': platform,
      'deviceShapeType': deviceShapeType,
      'deviceType': deviceType,
      'dialMainVersion': dialMainVersion,
      'showBindChoiceUi': showBindChoiceUi,
      'deviceId': deviceId,
      'firmwareVersion': firmwareVersion,
      'macAddress': macAddress,
      'macAddressFull': macAddressFull,
      'deviceName': deviceName,
      'otaMode': otaMode,
      'uuid': uuid,
      'sn': sn,
      'btName': btName,
      'gpsPlatform': gpsPlatform,
      'macAddressBt': macAddressBt,
      'fwVersion1': fwVersion1,
      'fwVersion2': fwVersion2,
      'fwVersion3': fwVersion3,
      'fwBtFlag': fwBtFlag,
      'fwBtVersion1': fwBtVersion1,
      'fwBtVersion2': fwBtVersion2,
      'fwBtVersion3': fwBtVersion3,
      'fwBtMatchVersion1': fwBtMatchVersion1,
      'fwBtMatchVersion2': fwBtMatchVersion2,
      'fwBtMatchVersion3': fwBtMatchVersion3,
    });
  }

  void _onDeviceInfoChanged() {
    if (_device != null) {
      // 判断设备平台
      if (platform == 98 || platform == 99) {
        logger?.d("deviceInfo platform: $platform");
        IDOProtocolCoreManager().initSifliChannel();
      }
    }
  }

  /// 思澈平台
  bool isSilfiOta() {
    // 98: 思澈1, 99: 思澈2
    if (platform == 98 || platform == 99) {
      return true;
    }
    return false;
  }

  bool isNordicPlatform() => platform == 0;

  bool isRealtekPlatform() => platform == 10;

  bool isTelinkPlatform() => platform == 60;

  /// 通用的，ota的时候使用爱都自己的协议
  bool isCommonPlatform() => [30, 40, 50, 80, 90].contains(platform);

  /// 恒玄
  bool isPersimwearPlatform() => platform == 97;

  /// 思澈
  bool isSilfiPlatform() => [98, 99].contains(platform);

  /// 芯与物 icoe gps平台
  bool isIcoeGpsPlatform() => gpsPlatform == 3;

}

// 字节数组解析为字符串(待c库调整为返回字符串，此处再废弃）
extension _DeviceInfoModelConvertExt on DeviceInfoModel {

  String? btNameString() {
    if (btName != null) {
      if (btName is List) {
        final intList = (btName as List).map((element) => element as int).toList();
        return intList.convertToString();
      } else if(btName is String) {
          return btName;
      }
    }
    return null;
  }

  String? snString() {
    if (sn != null) {
      if (sn is List) {
        final intList = (sn as List).map((element) => element as int).toList();
        return intList.convertToString();
      } else if(sn is String) {
        return sn;
      }
    }
    return null;
  }
}

extension _IntExt on List<int> {

  String convertToString() {
    final bytes = _trimZeros();
    return String.fromCharCodes(bytes);
  }

  List<int> _trimZeros() {
    int startIndex = 0;
    int endIndex = length - 1;
    while (startIndex <= endIndex && this[startIndex] == 0) {
      startIndex++;
    }
    while (endIndex >= startIndex && this[endIndex] == 0) {
      endIndex--;
    }
    return sublist(startIndex, endIndex + 1);
  }
}
