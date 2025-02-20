import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth/model/ido_bluetooth_dfu_config.dart';
import 'package:flutter_bluetooth/model/ido_bluetooth_dfu_state.dart';
import 'package:rxdart/rxdart.dart';

import 'Tool/ido_bluetooth_heart_ping.dart';
import 'Tool/logger/ido_bluetooth_logger.dart';
import 'Tool/ido_bluetooth_tool.dart';
import 'channel/ido_bluetooth_channel.dart';
import 'ido_bluetooth.dart';
import 'ido_bluetooth_update_log.dart';
import 'mixin/ido_bluetooth_commend_mixin.dart';
import 'mixin/ido_bluetooth_timeout_mixin.dart';
import 'model/ido_bluetooth_media_state.dart';
part 'manager/ido_bluetooth_manager.dart';

final bluetoothManager = IDOBluetoothManager();

abstract class IDOBluetoothManager {
  factory IDOBluetoothManager() => _IDOBluetoothManager();

  ///获取sdk版本号
  ///Get the sdk version number
  String getSdkVersion();

  /// 最后一次连接设备
  /// last connected device
  IDOBluetoothDeviceModel? get currentDevice;

  /// 更新绑定状态,决定是否重连
  /// autoConnect： 是否自动重连
  /// Update the binding status to decide whether to reconnect
  /// autoConnect： Whether to automatically reconnect
  needAutoConnect(bool autoConnect);

  /// 注册,程序开始运行调用
  /// heartPingSecond: 心跳包间隔(ios)
  /// outputToConsole：控制台输出日志
  /// Register, the program starts to run and calls
  /// heartPingSecond: Heartbeat interval (ios)
  /// outputToConsole：console output log
  register({int heartPingSecond, bool outputToConsole});

  heartPingSwitch(bool isOn);

  /// 开始搜索
  /// macAddress（Android）:根据Mac地址搜索
  /// 返回指定搜索的设备，如未指定返回null
  /// start searching
  /// macAddress（Android）:Search by macAddress
  /// Returns the specified search device, or null if not specified
  Future<List<IDOBluetoothDeviceModel>?> startScan([String? macAddress]);

  /// 停止搜索
  /// stop searching
  stopScan();

  /// 搜索结果
  /// deviceName: 只搜索deviceName的设备
  /// deviceID：只搜索deviceID的设备
  /// search results
  /// deviceName: Only search devices with deviceName
  /// deviceID：Only search for devices with deviceID
  Stream<List<IDOBluetoothDeviceModel>> scanResult(
      {List<String>? deviceName,
        List<int>? deviceID,
        List<String>? macAddress,
        List<String>? uuid});

  /// 手动连接
  /// device: Mac地址必传，iOS要带上uuid，最好使用搜索返回的对象
  /// manual connection
  /// device: Mac address must be passed, iOS must bring uuid, it is best to use the object returned by the search
  /// delayDuration: 连接延迟时长, 默认不延迟
  connect(IDOBluetoothDeviceModel? device, {Duration? delayDuration = Duration.zero});

  /// 使用这个重连设备
  /// Use this to reconnect the device
  autoConnect({IDOBluetoothDeviceModel? device});

  /// 取消连接
  /// macAddress： 指定设备
  /// cancel connection
  /// macAddress： specified equipment
  Future<bool> cancelConnect({String? macAddress});

  /// 获取蓝牙状态
  /// get bluetooth status
  Future<IDOBluetoothStateType> getBluetoothState();

  /// 获取设备连接状态
  /// Get device connection status
  Future<IDOBluetoothDeviceStateType> getDeviceState(
      [IDOBluetoothDeviceModel? device]);

  /// 发送数据
  /// data:数据
  /// device: 发送数据的设备
  /// type:0 BLE数据, 1 SPP数据
  /// send data
  /// data: data
  /// device: device sending data
  /// type:0 BLE data, 1 SPP data
  /// platform: 0 爱都, 1 恒玄, 2 VC
  Future<IDOBluetoothWriteType> writeData(Uint8List data,
      {IDOBluetoothDeviceModel? device,
        int type = 0,
        int platform = 0});

  /// 发送数据状态
  /// Send data status
  Stream<IDOBluetoothWriteState> writeState({IDOBluetoothDeviceModel? device});

  /// 收到数据
  /// received data
  Stream<IDOBluetoothReceiveData> receiveData(
      {IDOBluetoothDeviceModel? device});

  /// 监听蓝牙状态
  /// Monitor Bluetooth status
  Stream<IDOBluetoothStateModel> bluetoothState();

  /// 监听设备状态状态
  /// Monitor device status status
  Stream<IDOBluetoothDeviceStateModel> deviceState();

  /// bt配对（android）
  /// bt pairing (android)
  setBtPair(IDOBluetoothDeviceModel device);

  /// 取消配对（android）
  /// unpair (android)
  cancelPair({IDOBluetoothDeviceModel? device});

  /// bt状态（android）
  /// bt status (android)
  Stream<bool> stateBt();

  /// btMacAddress 连接SPP（android）
  /// btMacAddress connect to SPP (android)
  connectSPP(String btMacAddress);

  /// btMacAddress 断开SPP（android）
  /// btMacAddress disconnect SPP (android)
  disconnectSPP(String btMacAddress);

  /// spp状态（android）
  /// spp status (android)
  Stream<IDOBluetoothSPPStateType> stateSPP();

  /// spp文件写完成  返回btMac地址（android）
  /// The spp file is written and returns the btMac address (android)
  Stream<String> writeSPPCompleteState();

  /// 发起dfu升级
  /// Initiate dfu upgrade
  startNordicDFU(IDOBluetoothDfuConfig config);

  /// 监听dfu进度，外部调用
  /// progress： 进度
  /// state： Completed升级完成
  /// error: 不为空就是错误
  /// Monitor dfu progress, external call
  /// progress： progress
  /// state： 'Completed' Upgrade completed
  /// error: error
  Stream<Map> dfuProgress();

  ///主动获取媒体音频开关状态
  Future<IDOBluetoothMediaState> getMediaAudioState(String btMac);

  ///主动获取SPP连接状态
  Future<bool> getSppState({String btMac});

  ///监听媒体音频开关状态
  Stream<IDOBluetoothMediaState> mediaAudioState();

  /// 日志路径
  /// log path
  Future<String?> logPath();

  //The following are internal methods, please do not call

  /// 原生调用 监听当前设备
  Stream<IDOBluetoothDeviceModel> listenCurrentDevice();

  /// 原生调用 搜索接口
  Stream<List<IDOBluetoothDeviceModel>> scanResultNative();

  /// 原生调用 设置设备筛选过滤条件
  /// deviceName: 只搜索deviceName的设备
  /// deviceID：只搜索deviceID的设备
  /// uuids: 只搜索 uuid设备
  scanFilter({List<String>? deviceNames, List<int>? deviceIDs, List<String>? macAddresss, List<String>? uuids});

  /// 设备上报到keychain存储（ios）
  requestMacAddress(IDOBluetoothDeviceModel? device);

  /// 取消连接，内部使用
  channelCancelConnect(String? macAddress);

  ///内部调用
  addDeviceState(IDOBluetoothDeviceStateModel model);

  /// 写日志，内部使用
  addLog(
    String detail, {
    String className = 'IDOBluetoothManager',
    required String method,
  });
}
