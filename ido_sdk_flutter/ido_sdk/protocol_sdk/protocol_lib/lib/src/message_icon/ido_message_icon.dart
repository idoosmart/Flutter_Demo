
import 'dart:convert';
import 'dart:io';

import 'package:ido_logger/ido_logger.dart';
import 'package:protocol_core/protocol_core.dart';
import 'package:protocol_lib/protocol_lib.dart';

import 'module/download_icon.dart';
import 'module/get_app_info.dart';
import 'module/set_app_name.dart';
import 'module/transfer_icon.dart';
import '../private/logger/logger.dart';
import '../private/local_storage/local_storage.dart';

part 'part/message_icon_impl.dart';

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

  /// ios 正在更新图标和名字
  bool get ios_updating;

  /// 设备支持默认提醒的app包名集合
  List<String>? ios_defaultPackNames();

  /// 获取缓存的app信息数据
  Future<IDOAppIconInfoModel> ios_getInfoModel();

  /// 获取icon图片存放目录地址
  Future<String> ios_getIconDirPath();

  /// 重置APP图标信息（删除本地沙盒缓存的图片）
  Future<bool> ios_resetIconInfoData();

  /// ios注册监听更新消息图标(全局注册一次即可)
  void ios_registerListenUpdate();

  /// ios 主动获取默认APP信息
  Stream<bool> ios_getDefaultAppInfo();

  /// android 下发应用图标
  Stream<bool> android_transferAppIcon(List<IDOAppInfo> items);

}