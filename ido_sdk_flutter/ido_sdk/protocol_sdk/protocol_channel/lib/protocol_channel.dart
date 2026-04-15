import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:protocol_lib/protocol_lib.dart';
import 'package:flutter_bluetooth/ido_bluetooth.dart';

import 'pigeon_generate/alexa.g.dart';
import 'pigeon_generate/bind.g.dart';
import 'pigeon_generate/bluetooth.g.dart';
import 'pigeon_generate/bridge.g.dart';
import 'pigeon_generate/cmd.g.dart';
import 'pigeon_generate/data_exchange.g.dart';
import 'pigeon_generate/data_sync.g.dart';
import 'pigeon_generate/device.g.dart';
import 'pigeon_generate/device_log.g.dart';
import 'pigeon_generate/file_transfer.g.dart';
import 'pigeon_generate/cache.g.dart';
import 'pigeon_generate/func_table.g.dart';
import 'pigeon_generate/message_icon.g.dart';
import 'pigeon_generate/tools.g.dart';
import 'pigeon_generate/epo.g.dart';
import 'pigeon_generate/measure.g.dart';

import 'pigeon_impl/bind_impl.dart';
import 'pigeon_impl/bluetooth_impl.dart';
import 'pigeon_impl/bridge_impl.dart';
import 'pigeon_impl/cmd_impl.dart';
import 'pigeon_impl/data_exchange_impl.dart';
import 'pigeon_impl/data_sync_impl.dart';
import 'pigeon_impl/device_impl.dart';
import 'pigeon_impl/device_log_impl.dart';
import 'pigeon_impl/file_transfer_impl.dart';
import 'pigeon_impl/alexa_impl.dart';
import 'pigeon_impl/cache_impl.dart';
import 'pigeon_impl/fun_table_impl.dart';
import 'pigeon_impl/message_icon_impl.dart';
import 'pigeon_impl/tool_impl.dart';
import 'pigeon_impl/epo_impl.dart';
import 'pigeon_impl/measure_impl.dart';

BridgeImpl? _bridgeImpl;
BluetoothImpl? _bluetoothImpl;

// 不需要自动连接bt的设备
// SKG: 7814
final _ignoreBtAutoConnectDeviceIDs = [7814];

Future<bool> registerProtocolChannel() async {
  await IDOProtocolLibManager.register(outputToConsole: true);
  _bridgeImpl = BridgeImpl();
  Bind.setup(BindImpl());
  _bluetoothImpl = BluetoothImpl();
  _bluetoothImpl?.bridgeImpl = _bridgeImpl;
  Bluetooth.setup(_bluetoothImpl!);
  Bridge.setup(_bridgeImpl!);
  Cache.setup(CacheImpl());
  Cmd.setup(CmdImpl());
  ApiExchangeData.setup(DataExchangeImpl());
  SyncData.setup(DataSyncImpl());
  Device.setup(DeviceImpl());
  DeviceLog.setup(DeviceLogImpl());
  FileTransfer.setup(FileTransferImpl());
  FuncTable.setup(FuncTableImpl());
  MessageIcon.setup(MessageIconImpl());
  Tool.setup(ToolImpl());
  Alexa.setup(AlexaImpl());
  ApiEPOManager.setup(EpoImpl());
  Measure.setup(MeasureImpl());
  _registerBluetooth(); // 内置蓝牙库注册
  _registerProtocolStateChangedListener();
  return true;
}

_registerBluetooth() {
  //==============do not edit directly begin==============
  bluetoothManager.register(outputToConsole: true);

  // 处理蓝牙返回数据
  bluetoothManager.receiveData().listen((event) {
    //print('<<-----call 蓝牙响应数据传入c库 data: ${event.data}');
    if (event.platform != 0) {
      debugPrint("非ido数据不处理 platform: ${event.platform} data: ${event.data}");
      return;
    }
    if (event.data != null) {
      int spp = (event.spp ?? false) ? 1 : 0;
      libManager.receiveDataFromBle(event.data!, event.macAddress, spp);
    }
  });

  // 蓝牙库获取设备的绑定状态，用于ble 配对逻辑处理
  bluetoothManager.setBindStateAsyncDelegate((macAddress) async {
    libManager.cache.recordNativeLog('checkDeviceBindState macAddress: $macAddress');
    final isBinded = await _bridgeImpl?.bridgeDelegate.checkDeviceBindState(macAddress) ?? false;
    libManager.cache.recordNativeLog('checkDeviceBindState macAddress: $macAddress, isBinded: $isBinded');
    return isBinded;
  });

  // // 蓝牙库拦截蓝牙自动连接代理，目前 Android 端 思澈 98平台ota 中自动连接、断连影响 ota，所以思澈 98平台 ota 时应禁止自动重连
  // // 因为禁止Android 端自动重连，所以需要在 ota 后主动触发蓝牙自动回连
  // // 因为禁止Android 端自动重连，所以需要在 ota 后主动触发蓝牙自动回连
  // // 因为禁止Android 端自动重连，所以需要在 ota 后主动触发蓝牙自动回连
  // bluetoothManager.setAutoConnectInterceptor((macAddress) => libManager.checkSiceOtaDoing());
  // libManager.transFile.listenSilfiOtaFinished((platform) {
  //   bluetoothManager.autoConnect();
  // });

  // 写数据到蓝牙设备
  IDOBluetoothWriteType rs = IDOBluetoothWriteType.withoutResponse;
  libManager.registerWriteDataToBle((e) async {
    //print('------>>call 写数据到蓝牙设备 data: ${e.data} type: ${e.type == 1 ? "spp" : "ble"}');
    rs = await bluetoothManager.writeData(e.data, type: e.type);
    if (rs == IDOBluetoothWriteType.withoutResponse) {
      libManager.writeDataComplete();
      // print('-------call writeDataComplete1');
    }
  });

  bluetoothManager.writeState().listen((event) {
    if (event.state ?? false) {
      if (event.type == IDOBluetoothWriteType.withResponse) {
        libManager.writeDataComplete();
        // print('writeDataComplete2');
      }
    }
  });

  // 监听状态通知
  libManager.listenStatusNotification((status) {
    //print('------- 状态上报 status: ${status.name}');
    switch (status) {
      case IDOStatusNotification.functionTableUpdateCompleted:
        //debugPrint('功能表获取完成');
        break;
      case IDOStatusNotification.deviceInfoUpdateCompleted:
        //debugPrint('设备信息已更新');
        break;
      case IDOStatusNotification.unbindOnAuthCodeError:
        //debugPrint('绑定授权码异常，设备强制解绑');
        break;
      case IDOStatusNotification.fastSyncCompleted:
        debugPrint('快速配置完成');
        if (libManager.deviceInfo.macAddressBt != null && bluetoothManager.currentDevice?.btMacAddress == null) {
          debugPrint('set bluetoothManager.currentDevice?.btMacAddress = ${libManager.deviceInfo.macAddressBt}');
          bluetoothManager.currentDevice?.btMacAddress = libManager.deviceInfo.macAddressBt;
        }
        // 未启用
        // // 自动连接BT
        // if (Platform.isAndroid &&
        //     !_ignoreBtAutoConnectDeviceIDs.contains(libManager.deviceInfo.deviceId)
        //     && bluetoothManager.currentDevice?.btMacAddress != null) {
        //   libManager.cache.recordNativeLog("auto bt pair: ${bluetoothManager.currentDevice!.btMacAddress}");
        //   bluetoothManager.setBtPair(bluetoothManager.currentDevice!);
        // } else if(_ignoreBtAutoConnectDeviceIDs.contains(libManager.deviceInfo.deviceId)) {
        //   libManager.cache.recordNativeLog("ignore auto bt pair");
        // }
        break;
      case IDOStatusNotification.deviceInfoBtAddressUpdateCompleted:
        //debugPrint('快速配置完成');
        if (libManager.deviceInfo.macAddressBt != null) {
          bluetoothManager.currentDevice?.btMacAddress = libManager.deviceInfo.macAddressBt;
        }
        break;
      case IDOStatusNotification.unbindOnBindStateError:
        if (bluetoothManager.currentDevice?.macAddress != null) {
          //debugPrint('绑定状态不匹配 需解绑');
          //libManager.deviceBind.unbind(macAddress: bluetoothManager.currentDevice!.macAddress!);
        }
        break;
      default:
        break;
    }
  });

  bluetoothManager.deviceState().listen((event) async {
    debugPrint('bluetoothManager event:${event.state.toString()}');
    if ((event.state == IDOBluetoothDeviceStateType.connected &&
        event.macAddress != null &&
        event.macAddress!.isNotEmpty)) {
      final device = bluetoothManager.currentDevice!;
      debugPrint('bluetoothManager.deviceState() platform:${device.platform} '
          'macAddress:${device.macAddress} name:${device.name} uuid:${device.uuid}');
      final otaType = device.isTlwOta
          ? IDOOtaType.telink
          : device.isOta
              ? IDOOtaType.nordic
              : IDOOtaType.none;
      final isBinded = await _bridgeImpl?.bridgeDelegate.checkDeviceBindState(event.macAddress!) ?? false;
      // await libManager.cache.loadBindStatus(macAddress: event.macAddress!);
      var uniqueId = event.macAddress!;
      // 获取设备uuid(只有ios)
      if (Platform.isIOS && bluetoothManager.currentDevice?.uuid != null) {
        uniqueId = bluetoothManager.currentDevice!.uuid!;
      }
      // 思澈ota模式特殊处理
      if ([98, 99].contains(device.platform) && device.isOta) {
        _sendOtaNotify(device);
      }else {
        await libManager.markConnectedDeviceSafe(
            uniqueId: uniqueId, isBinded: isBinded, otaType: otaType, deviceName: device.name);
      }
      // debugPrint('end markConnectedDevice');
    } else if (event.state == IDOBluetoothDeviceStateType.disconnected) {
      // iOS: 关闭系统蓝牙，此处不会调用，存在bug，在bluetoothManager.bluetoothState().listen((event) async { } 中处理
      libManager.cache.recordNativeLog("deviceState markDisconnectedDevice: ${event.macAddress}");
      await libManager.markDisconnectedDevice(macAddress: event.macAddress);
    }
  });

  libManager.listenDeviceNotification((m) async {
    debugPrint('listenDeviceNotification: ${m.toMap().toString()}');
    if (m.dataType == 59) {
      final device = bluetoothManager.currentDevice!;
      var platform = device.platform;
      if (platform == -1) {
        device.platform = libManager.deviceInfo.platform;
        platform = libManager.deviceInfo.platform;
      }
      // 当前处于DFU模式(思澈平台)
      debugPrint("当前处于DFU模式(思澈平台) type == ${m.dataType} "
          "platform: $platform device.isOta: "
          "${device.isOta} device.isTlwOta: ${device.isTlwOta}");
      if ([98, 99].contains(platform)) {
        _sendOtaNotify(device);
      }
    }

  });

  bluetoothManager.bluetoothState().listen((event) async {
    if (event.state == IDOBluetoothStateType.poweredOn) {
      // bluetoothManager.autoConnect(device: device);
    } else if (event.state == IDOBluetoothStateType.poweredOff) {
      if (Platform.isIOS) {
        final macAddress = bluetoothManager.currentDevice?.macAddress;
        libManager.cache.recordNativeLog("bluetoothState markDisconnectedDevice: $macAddress");
        await libManager.markDisconnectedDevice(macAddress: bluetoothManager.currentDevice?.macAddress);
      }
    }
  });

  bluetoothManager.listenCurrentDevice().listen((event) {
    event.addListener(() {
      // print("dart 监听到bleModel属性变更");
      final state = DeviceStateType.values[event.state!.index];
      final device = DeviceModel(rssi: event.rssi,
          name: event.name,
          state: state,
          uuid: event.uuid,
          macAddress: event.macAddress,
          otaMacAddress: event.otaMacAddress,
          btMacAddress: event.btMacAddress,
          deviceId: event.deviceId,
          deviceType: event.deviceType,
          isOta: event.isOta,
          isTlwOta: event.isTlwOta,
          bltVersion: event.bltVersion,
          isPair: event.isPair);
      _bluetoothImpl?.bluetoothDelegate.onCurrentDeviceAttrValChange(device);
    });
  });
  //==============do not edit directly end==============
}

_registerProtocolStateChangedListener() {
  libManager.listenAllStateChanged((p0) {
    _updateProtocolState();
  });
}

_updateProtocolState() {
  if (_bridgeImpl != null) {
    final ps = ProtocolState(
        isConnected: _bridgeImpl!.isConnected(),
        isConnecting: _bridgeImpl!.isConnecting(),
        isBinding: _bridgeImpl!.isBinding(),
        isFastSynchronizing: _bridgeImpl!.isFastSynchronizing(),
        otaType: _bridgeImpl!.otaType(),
        macAddress: _bridgeImpl!.macAddress());
    _bridgeImpl?.bridgeDelegate.listenProtocolStateChanged(ps);
  }
}

//==============do not edit directly begin==============
_sendOtaNotify(IDOBluetoothDeviceModel device) async{
  await libManager.markSiceOtaMode(
      macAddress: device.macAddress!,
      iosUUID: device.uuid!,
      platform: device.platform,
      deviceId: device.deviceId!);
  // 执行ota升级
  debugPrint("_sendOtaNotify device: ${device.toMap().toString()}");
  final otaDevice = OtaDeviceModel(
      rssi: device.rssi,
      name: device.name,
      uuid: device.uuid,
      macAddress: device.macAddress,
      otaMacAddress: device.otaMacAddress,
      btMacAddress: device.btMacAddress,
      deviceId: device.deviceId,
      deviceType: device.deviceType,
      isOta: device.isOta,
      isTlwOta: device.isTlwOta,
      bltVersion: device.bltVersion,
      platform: device.platform);
  await _bridgeImpl?.bridgeDelegate.listenWaitingOtaDevice(otaDevice);
}
//==============do not edit directly end==============