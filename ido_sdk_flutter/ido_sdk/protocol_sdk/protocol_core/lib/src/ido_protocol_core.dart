import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

export 'package:async/async.dart';
import 'package:ido_logger/ido_logger.dart';
import 'package:protocol_core/protocol_core.dart';
import 'package:protocol_ffi/protocol_ffi.dart';
import 'package:tuple/tuple.dart';
import 'package:worker_manager_lite/worker_manager_lite.dart';
import 'package:native_channel/native_channel.dart';

import './task/cmd_task.dart';
import './task/file_task.dart';
import './task/sync_task.dart';
import './task/log_task.dart';
import './logger/logger.dart';

import './manager/manager_clib.dart';
import 'spp/spp_trans_manager.dart';
import 'task/base_task.dart';

part 'part/protocol_core_impl.dart';

/// protocol_core模块管理类
abstract class IDOProtocolCoreManager {
  factory IDOProtocolCoreManager() => _IDOProtocolCoreManager();

  SifliChannelImpl? get sifliChannel;

  /// 初始化c库
  Future<bool> initClib();

  /// 将数据包装成协议指令 json -> data
  ///
  /// cmdPriority 可指定更高优先级
  CancelableOperation<CmdResponse> writeJson(
      {required int evtBase,
      required int evtType,
      String? json,
      int? val1,
      int? val2,
      bool useQueue,
      CmdPriority cmdPriority,
      Map<String, String>? cmdMap});

  /// 数据同步
  CancelableOperation<CmdResponse> sync({
    List<int> selectTypes = const [],
    required SyncType type,
      required SyncProgressCallback progressCallback,
      required SyncDataCallback dataCallback});

  /// 文件传输
  CancelableOperation<CmdResponse> trans({
    required FileTranItem fileTranItem,
    required FileTranStatusCallback statusCallback,
    required FileTranProgressCallback progressCallback,
  });

  /// 设备日志
  CancelableOperation<CmdResponse> deviceLog(
      {required LogType type,
       required String dirPath,
      LogProgressCallback? progressCallback});

  /// 蓝牙响应数据总入口
  ///
  /// type 数据类型 0:ble 1:SPP
  void receiveDataFromBle(Uint8List data, String? macAddress, int type);

  /// 发送蓝牙数据完成
  void writeDataComplete();

  /// 发送SPP数据完成
  void writeSppDataComplete();

  /// 写数据到蓝牙设备
  void writeDataToBle(void Function(CmdRequest data) func);

  /// C库请求命令快速配置
  /// evt_type 获取Mac地址 =>300 , 获取设备信息 => 301 ,
  /// 获取功能表 => 302 , 获取BT连接状态 => 325 , 获取固件三级版本号 => 336 ,
  /// 开启ancs => 506 , 设置授权码 => 202
  void cRequestCmd(void Function(int evtType, int error, int val) func);

  /// C库通知（扩展）
  void cRequestCmdExt(void Function(int evtType, int error, int val) func);

  /// 快速配置完成回调
  StreamSubscription<int> fastSyncComplete(void Function(int errorCode) func);

  /// 暂停
  void pause();

  /// 恢复
  void resume();

  /// 释放
  void dispose({bool needKeepTransFileTask = false});

  /// c库队列清除  0 成功
  int cleanProtocolQueue();

  /// 手动停止快速同步配置
  int stopSyncConfig();

  /// 只监听设备响应数据
  ///
  /// ```dart
  /// 返回 Tuple3(int code, int evt, String json)
  /// ```
  StreamController<Tuple3<int, int, String>> get streamListenReceiveData;

  bool get isPaused;

  /// 获取快速配置状态
  bool get isFastSyncComplete;

  /// 监听设备状态
  ///
  /// code详细说明如下:
  /// ```dart
  /// 0 无效
  /// 1 手环已经解绑
  /// 2 心率模式改变
  /// 3 血氧产生数据，发生改变
  /// 4 压力产生数据，发生改变
  /// 5  Alexa识别过程中退出
  /// 6 固件发起恢复出厂设置，通知app弹框提醒
  /// 7 app需要进入相机界面（TIT01定制）
  /// 8 sos事件通知（205土耳其定制）
  /// 9 alexa设置的闹钟，固件修改，需要发送对应的通知位给app，app收到后发送获取V3的闹钟命令
  /// 10 固件有删除日程提醒，app这边( cmd = 0x33 ,  cmd_id = 0x36 )查询列表，要更新对应的列表数据
  /// 11 固件端有修改对应的表盘子样式，通知app获取（command\_id为0x33， key为 0x5000）
  /// 12 固件通知ios更新通知图标和名字
  /// 13 固件通知app图标已经更新，通知app获取已经更新的图标状态
  /// 14 固件请求重新设置天气，app收到收，下发天气数据
  /// 15 固件步数每次增加2000步，设备请求app同步数据，app调用同步接口
  /// 16 固件探测到睡眠结束，请求app同步睡眠数据，app调用同步接口同步
  /// 17 固件三环数据修改，通知app更新三环数据
  /// 18 固件充满电完成发送提醒，app收到后通知栏显示设备充电完成
  /// 19 结束运动后，手动测量心率后，手动测量血氧后，手动测量压力后，设备自动请求同步，先检查链接状态，未连接本次同步不执行，满足下个自动同步条件后再次判断发起同步请求
  /// 20 固件修改 心率通知状态类型、压力通知状态类型、血氧通知状态类型、生理周期通知状态类型、健康指导通知状态类型、提醒事项通知状态类型通知app更新心率、压力、血氧、生理周期、健康指导、提醒事项通知状态类型
  /// 21 固件压力值计算完成，通知app获取压力值
  /// 22 固件通知app，固件压力校准失败(固件退出测量界面/检测失败/检测超时/未佩戴)
  /// 23 固件产生心率过高或者过低提醒时，通知app获取心率数据
  /// 24 固件通知app bt蓝牙已连接
  /// 25 固件通知app bt蓝牙断开连接
  /// 26 固件蓝牙通话开始
  /// 27 固件蓝牙通话结束
  /// 28 新版本固件每隔4分30秒发送一个通知命令，用于修复ios 会显示离线的问题
  /// 29 通知app运动开始
  /// 30 通知app运动结束
  /// 31 固件重启发送通知给app  （app收到通知需要获取固件版本信息）
  /// 32 设备空闲时（没有使用aleax），需要上报通知给app（时间间隔为1小时）
  /// 33 固件整理空间完成通知app继续下传表盘文件
  /// 34 固件通知app结束寻找手环指令 （对应6.3寻找手环）
  /// 35 固件进入省电模式通知app
  /// 36 固件退出省电模式通知app
  /// 37 固件通知请求app下发设置gps热启动参数
  /// 38 固件传输原始数据完成，通知app获取特性向量信息
  /// 39 固件通知app，固件血压校准失败(固件退出测量界面/检测失败/检测超时/未佩戴)
  /// 40 固件传输原始数据完成，没有特性向量信息，通知app数据采集结束
  /// 41 v3健康数据同步单项数据完成通知 (android 内部使用）
  /// 42 固件整理gps数据空间完成通知app下发gps文件
  /// 43 固件升级EPO.dat文件失败，通知app再次下发EPO.dat文件（最多一次）
  /// 44 固件升级EPO.dat文件成功
  /// 45 固件升级GPS失败，通知app重新传输
  /// 46 固件升级GPS成功
  ///
  /// Example:
  /// ```dart
  /// final ss = listenDeviceStateChanged((code) {
  ///    ...
  /// });
  /// ss.cancel(); 注：不使用时，需要取消监听
  /// ```
  StreamSubscription listenDeviceStateChanged(void Function(int code) func);

  /// 设备主动通知/控制事件
  ///
  /// Tuple3(int code, int evtType, String json)
  StreamSubscription listenControlEvent(void Function(Tuple3 t3) func);

  /// 注册设备传文件到app监听
  void registerDeviceTranFileToApp({
    required FileTranRequestCallback requestCallback
  });

  /// 取消设备传文件到app监听
  void unregisterDeviceTranFileToApp();

  /// 监听进度和结果
  void listenDeviceTranFileToApp({
    required FileTranProgressCallback progressCallback,
    required FileTranStatusCallback statusCallback,
  });

  /// 初始化log
  initLogs({bool outputToConsoleClib = false});

  // /// 注入logger实例（日志合并）
  // static void setLogger(LoggerManager? aLogger) {
  //   logger = aLogger;
  //   Executor.showLog = false;
  //   IDOProtocolAPI.setLogger(aLogger);
  // }

  /// 设置flash获取时间，单位秒，默认一分钟
  /// return int SUCCESS(0)成功
  int setProtocolGetFlashLogSetTime(int time);

  /// 直接下发原始数据给固件
  int writeRawData({required Uint8List data});

  // ----------------- 内部方法（外部不要调用） -----------------
  /// 设备连接断开监听（内部方法）
  StreamSubscription listenOnBeforeDeviceDisconnect(void Function(void) func);

  /// 初始化思澈文件传输通道
  void initSifliChannel();
}
