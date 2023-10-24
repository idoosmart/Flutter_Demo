import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth/ido_bluetooth.dart';
import 'package:protocol_alexa/protocol_alexa.dart';
import 'package:protocol_lib/protocol_lib.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'UI/home/home_page.dart';
import 'generated/l10n.dart';

const clientId =
    'amzn1.application-oa2-client.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';

// const clientId =
//     'amzn1.application-oa2-client.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';

void main() async {
  runApp(const MyApp());

  await registerProtocolSDK();
  await registerBluetoothSDK();
  await registerProtocolAlexa();
  await bridgeConnect();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        S.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      title: "Demo",
      home: const HomePage(),
      builder: EasyLoading.init(),
    );
  }
}

/// 注册协议库
registerProtocolSDK() async {
  // 注册协议库
  await IDOProtocolLibManager.register(outputToConsole: true);
  // ios注册监听更新消息图标
  libManager.messageIcon.registerListenUpdate();
  // 监听设备状态
  libManager.listenDeviceNotification((event) {
    print('listenDeviceNotification: ${event.toMap().toString()}');
  });
}

///注册蓝牙库
registerBluetoothSDK() async {
  await bluetoothManager.register();

  /// 获取版本号
  final version = bluetoothManager.getSdkVersion();

  /// deviceName: 只搜索deviceName的设备
  /// deviceID：只搜索deviceID的设备
  /// uuids: 只搜索 uuid设备
  //bluetoothManager.scanFilter();
}

registerProtocolAlexa() async {
  await IDOProtocolAlexa.register(clientId: clientId);
}

/// 蓝牙与协议库桥接
bridgeConnect() async {
  // 处理蓝牙返回数据
  bluetoothManager.receiveData().listen((event) {
    if (event.data != null) {
      libManager.receiveDataFromBle(
          event.data!, event.macAddress, event.spp ?? false ? 1 : 0);
    }
  });

  // 监听协议库状态改变
  libManager.listenStatusNotification((status) async {
    if (status == IDOStatusNotification.protocolConnectCompleted) {
      // 协议库设备连接完成初始化
    } else if (status == IDOStatusNotification.fastSyncCompleted) {
      // 快速配置完成
    } else if (status == IDOStatusNotification.deviceInfoUpdateCompleted) {
      // 设备信息更新完成
    } else if (status == IDOStatusNotification.unbindOnBindStateError) {
      // 绑定状态错误，解绑删除当前设备
    } else if (status == IDOStatusNotification.fastSyncFailed) {
      // 快速配置失败，功能表获取失败
    }
  });

  // 写数据到蓝牙设备
  IDOBluetoothWriteType rs = IDOBluetoothWriteType.withoutResponse;
  libManager.registerWriteDataToBle((event) async {
    rs = await bluetoothManager.writeData(event.data, type: event.type);
    if (rs == IDOBluetoothWriteType.withoutResponse && Platform.isIOS) {
      // 无响应发送数据
      libManager.writeDataComplete();
    }
  });

  // 蓝牙写入状态回调
  bluetoothManager.writeState().listen((event) {
    if (event.state ?? false) {
      if (Platform.isAndroid ||
          event.type == IDOBluetoothWriteType.withResponse) {
        // 写入完成
        libManager.writeDataComplete();
      }
    }
  });

  //监听连接状态
  bluetoothManager.deviceState().listen((value) async {
    if (value.errorState == IDOBluetoothDeviceConnectErrorType.pairFail) {
      //  配对异常提示去忽略设备
    }
    if ((value.state == IDOBluetoothDeviceStateType.connected &&
        (value.macAddress != null && value.macAddress!.isNotEmpty))) {
      // 设备连接成功
      // 获取ota枚举类型
      final isTlwOta = bluetoothManager.currentDevice?.isTlwOta ?? false;
      final isOta = bluetoothManager.currentDevice?.isOta ?? false;
      final otaType = isTlwOta
          ? IDOOtaType.telink
          : isOta
              ? IDOOtaType.nordic
              : IDOOtaType.none;

      // 获取设备名字
      final devicenName = bluetoothManager.currentDevice?.name;
      var uniqueId = value.macAddress!;

      // 获取设备uuid(只有ios)
      if (Platform.isIOS && bluetoothManager.currentDevice?.uuid != null) {
        uniqueId = bluetoothManager.currentDevice!.uuid!;
      }

      // 执行协议库连接设备
      await libManager.markConnectedDeviceSafe(
          uniqueId: uniqueId,
          otaType: otaType,
          isBinded: false, // 该状态由使用者记录
          deviceName: devicenName);
    } else if (value.state == IDOBluetoothDeviceStateType.disconnected) {
      // 设备断线
      await libManager.markDisconnectedDevice(
          macAddress: value.macAddress, uuid: value.uuid);
    }
  });

  /// 监听蓝牙状态
  bluetoothManager.bluetoothState().listen((event) async {
    // 获取设备mac地址
    final macAddress = bluetoothManager.currentDevice?.macAddress;

    // 获取设备uuid(只有ios)
    final uuid = bluetoothManager.currentDevice?.uuid;
    if (event.state == IDOBluetoothStateType.poweredOff) {
      /// 蓝牙关闭
      await libManager.markDisconnectedDevice(
          macAddress: macAddress, uuid: uuid);
    }
  });
}
