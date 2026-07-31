import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth/ido_bluetooth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../home/home_content.dart';
import 'package:demo/utility/connection_status_controller.dart';

/// 扫描添加设备页（由已绑定首页进入）
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EasyLoading.instance
      ..maskType = EasyLoadingMaskType.black
      ..loadingStyle = EasyLoadingStyle.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('添加设备'),
        actions: [
          IconButton(
            tooltip: '停止扫描',
            icon: const Icon(Icons.stop_circle),
            onPressed: () => bluetoothManager.stopScan(),
          ),
        ],
      ),
      body: const Column(
        children: [
          ConnectionStatusBanner(),
          Expanded(child: HomeContent()),
        ],
      ),
      floatingActionButton: ElevatedButton(
        style: TextButton.styleFrom(backgroundColor: Colors.red),
        onPressed: () {
          requestPermission();
        },
        child: const Icon(
          Icons.refresh,
        ),
      ),
    );
  }

  requestPermission() async {
    if (Platform.isAndroid) {
      if (!await checkLocationPermissionIfNeeded()) {
        return;
      }
      IDOBluetoothStateType bleState =
          await bluetoothManager.getBluetoothState();
      if (bleState != IDOBluetoothStateType.poweredOn) {
        EasyLoading.showError("需要打开蓝牙");
        return;
      }
      PermissionStatus bluetoothStatus =
          await Permission.bluetoothScan.request();
      PermissionStatus connectStatus =
          await Permission.bluetoothConnect.request();
      print("connectStatus: $connectStatus");
      print("bluetoothStatus: $bluetoothStatus");
      bluetoothManager.startScan();
    } else {
      bluetoothManager.startScan();
    }
  }

  Future<bool> checkLocationPermissionIfNeeded() async {
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 29) {
        var status = await Permission.location.status;
        if (!status.isGranted) {
          status = await Permission.location.request();
          if (!status.isGranted) {
            EasyLoading.showError("没有定位权限，无法执行蓝牙扫描");
            return false;
          }
        }
      }
    }
    return true;
  }
}
