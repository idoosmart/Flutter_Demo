import 'dart:typed_data';

import 'package:flutter_bluetooth/Tool/ido_bluetooth_tool.dart';

class IDOBluetoothUpdateStateModel {
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
  int? dataType;
  //  1 闹钟已经修改 2 固件过热异常告警 4 亮屏参数有修改 8 抬腕参数有修改
  //  16  勿擾模式获取 32 手机音量的下发
  int? notifyType;
  //  每个消息对应一个ID
  int? msgId;
  //  0 无效 1 自定义短信1（正在开会，稍后联系）2 自定义短信2
  int? msgNotice;
  //  01 ACC  加速度 02 PPG  心率 03 TP   触摸 04 FLASH
  //  05 过热（PPG）06 气压 07 GPS 08 地磁
  int? errorIndex;

  IDOBluetoothUpdateStateModel.fromData(Uint8List? data) {
    if (data == null || data.isEmpty) {
      return;
    }
    final subList = data.sublist(0, 2);
    if (subList.compare(Uint8List.fromList([0x07, 0x40])) && data.length >= 14) {
      dataType =
          data.sublist(2, 4).reduce((value, element) => (value + element));
      notifyType =
          data.sublist(4, 5).reduce((value, element) => (value + element));
      msgId = data.sublist(5, 9).reduce((value, element) => (value + element));
      msgNotice =
          data.sublist(9, 10).reduce((value, element) => (value + element));
      errorIndex =
          data.sublist(10, 14).reduce((value, element) => (value + element));
    }
  }
}
