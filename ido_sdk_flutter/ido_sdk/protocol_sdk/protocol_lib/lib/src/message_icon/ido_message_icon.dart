
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:native_channel/native_channel.dart';
import 'package:protocol_core/protocol_core.dart';
import 'package:protocol_lib/protocol_lib.dart';
import 'package:protocol_lib/src/private/notification/notification.dart';

import 'module/download_icon.dart';
import 'module/get_app_info.dart';
import 'module/set_app_name.dart';
import 'module/transfer_icon.dart';
import 'part/icon_help.dart';

import '../private/logger/logger.dart';
import '../private/local_storage/local_storage.dart';

part 'part/message_icon_impl.dart';

/// 恒玄消息图标传输状态回调
typedef SeCheFileTransStatus = void Function(bool isSuccess, String filePath);

/// 恒玄消息图标传输全部完成回调
typedef SeCheMessageIconComplete = void Function(bool complete);

abstract class SeCheMessageIconDelegate {
  /// 恒玄消息图标传输
  void iconTransferFile(List<MessageFileModel> models, SeCheFileTransStatus status, SeCheMessageIconComplete complete);
}

abstract class IDOMessageIcon {

  factory IDOMessageIcon() => _IDOMessageIcon();

  /// 国家编码 只有ios才要 例如 美国 'US',中国 'CN'
  /// oc代码
  /// NSString * countryCode = @"US";
  /// if (@available(iOS 10.0, *)) {
  /// countryCode = [NSLocale currentLocale].countryCode ? : @"US";
  /// }
  String? ios_countryCode;

  ///base url 缓存服务器地址 如果未赋值则走Apple接口(请求速度较慢)
  /// 例如: https://cn-user.idoocloud.com/api/ios/lookup/get
  String? ios_baseUrlPath;

  /// app key 后台请求分配，每个app有独立的appkey具体咨询后台开发人员，只有在使用缓存服务器才有效
  /// 例如: 800a6444f9c0433c8e88741b6ddf1443
  String? ios_appKey;

  /// 语言单位 无效:0,中文:1,英文:2,法语:3,德语:4,意大利语:5,西班牙语:6,日语:7,
  /// 波兰语:8,捷克语:9,罗马尼亚:10,立陶宛语:11,荷兰语:12,斯洛文尼亚:13,
  /// 匈牙利语:14,俄罗斯语:15,乌克兰语:16,斯洛伐克语:17,丹麦语:18,克罗地亚:19,印尼语:20,
  /// 韩语:21,印地语:22,葡萄牙语:23,土耳其:24,泰国语:25,越南语:26,缅甸语:27,
  /// 菲律宾语:28,繁体中文:29,希腊语:30,阿拉伯语:31,瑞典语:32,芬兰语:33,波斯语:34,挪威语:35
  /// 未设语言单位，默认为英文
  int? ios_languageUnit;

  /// 正在更新图标和名字
  Future<bool> get updating;

  /// 监听更新状态
  Stream<bool> listenUpdateState();

  /// 注册监听更新消息图标(全局注册一次即可)
  void registerListenUpdate();

  /// 设置默认app信息集合(支持的设备需要)
  void setDefaultAppInfoList(List<IDOAppIconItemModel> models);

  /// 设备支持默认app信息集合
  /// ios 只有默认的包名
  /// android 会包含默认的event_type 如果已经安装的应用则包含图标地址
  Future<List<IDOAppIconItemModel>> getDefaultAppInfo();

  /// android 已安装所有app信息集合 force: 强制更新Android 消息图标和名字
  /// ios 需要执行获取默认的APP包名列表信息，因为event_type是固件分配的 force 强制更新应用名称
  Future<List<IDOAppIconItemModel>> firstGetAllAppInfo({bool force = false});

  /// 获取缓存的app信息数据
  /// 如果有动态更新app图标则会缓存数据，获取数据显示到开关控制列表
  Future<IDOAppIconInfoModel> getCacheAppInfoModel();

  /// 获取icon图片存放目录地址
  Future<String> getIconDirPath();

  /// 监听icon图片存放目录地址
  Stream<String> listenIconDirPath();

  /// 重置APP图标信息（删除本地沙盒缓存的图片）
  /// macAddress 需要清除数据的MAC地址
  /// deleteIcon 是否删除icon 图片文件，默认删除
  Future<bool> resetIconInfoData({required String macAddress, bool deleteIcon = true});

  /// android 当有收到通知时下发消息图标到设备
  Future<bool> androidSendMessageIconToDevice(int eventType);

  /// android 原生图标存放目录地址c
  Future<String> androidOriginalIconDirPath();

  /// 注册恒玄图标传输
  void addSeChe(SeCheMessageIconDelegate delegate);

}