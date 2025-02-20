
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:native_channel/pigeon_generate/get_app_info.g.dart';

abstract class GetAndroidAppInfo {

  factory GetAndroidAppInfo() => GetAppInfoImpl();

  /// 读取 Android 所有安装的APP信息
  /// Map => {type: $type, iconFilePath: $iconFilePath, appName: $appName, pkgName: $pkgName}
  /// 邮件、未接电话、日历、短信 （名称使用默认英语）
  /// force: 强制刷新数据
  Future<List<Map?>> getInstallAppInfoList({bool force = false});

  /// 读取 Android 默认的APP信息
  /// Map => {type: $type, iconFilePath: $iconFilePath, appName: $appName, pkgName: $pkgName}
  /// 读取 ios 默认的APP信息
  /// Map => {type: $type, iconFilePath: $iconFilePath, appName: $appName, pkgName: $pkgName, scheme: $scheme}
  /// 邮件、未接电话、日历、短信 （名称使用默认英语）
  Future<List<Map?>> getDefaultAppInfoList();

  /// 根据事件类型获取当前APP信息
  /// Map => {type: $type, iconFilePath: $iconFilePath, appName: $appName, pkgName: $pkgName}
  /// 邮件、未接电话、日历、短信 （名称使用默认英语）
  Future<Map?> getCurrentAppInfo(int type);

  /// 事件类型获取包名
  Future<String?> convertEventToPackageName(int type);

  /// 包名获取事件类型
  Future<int> convertEventByPackageName(String name);

  /// 判断是否为默认app
  Future<bool> isDefualtApp(String packageName);

  /// Android 应用图标存放目录
  Future<String> androidAppIconDirPath();

  /// 复制APP图标到指定目录
  Future<bool> copyAppIcon();
  
}

class GetAppInfoImpl extends ApiGetAppInfo implements GetAndroidAppInfo {

  static GetAppInfoImpl? _instance;
  factory GetAppInfoImpl() => _instance ??= GetAppInfoImpl._internal();
  GetAppInfoImpl._internal();

  final _getAppInfo = ApiGetAppInfo();

  /// 读取 Android 所有安装的APP信息
  /// Map => {type: $type, iconFilePath: $iconFilePath, appName: $appName, pkgName: $pkgName}
  /// 读取 ios 默认的APP信息
  /// Map => {type: $type, iconFilePath: $iconFilePath, appName: $appName, pkgName: $pkgName, scheme: $scheme}
  /// 邮件、未接电话、日历、短信 （名称使用默认英语）
  @override
  Future<List<Map?>> getInstallAppInfoList({bool force = false}) {
    if (!Platform.isAndroid) {
       return Future(() => []);
    }
    return _getAppInfo.readInstallAppInfoList(force);
  }

  /// 读取 Android 默认的APP信息
  /// Map => {type: $type, iconFilePath: $iconFilePath, appName: $appName, pkgName: $pkgName}
  /// 邮件、未接电话、日历、短信 （名称使用默认英语）
  @override
  Future<List<Map?>> getDefaultAppInfoList() {
    return _getAppInfo.readDefaultAppList();
  }
  
  @override
  Future<Map<Object?, Object?>?> getCurrentAppInfo(int type) {
    if (!Platform.isAndroid) {
      return Future(() => {});
    }
    return _getAppInfo.readCurrentAppInfo(type);
  }

  /// 事件类型获取包名
  @override
  Future<String?> convertEventToPackageName(int type) {
    if (!Platform.isAndroid) {
      return Future(() => null);
    }
    return _getAppInfo.convertEventType2PackageName(type);
  }

  /// 包名获取事件类型
  @override
  Future<int> convertEventByPackageName(String name) {
    if (!Platform.isAndroid) {
      return Future(() => -1);
    }
    return _getAppInfo.convertEventTypeByPackageName(name);
  }

  /// 判断是否默认app
  @override
  Future<bool> isDefualtApp(String packageName) {
    if (!Platform.isAndroid) {
      return Future(() => false);
    }
    return _getAppInfo.isDefaultApp(packageName);
  }

  /// Android 应用图标存放目录
  @override
  Future<String> androidAppIconDirPath() {
    if (!Platform.isAndroid) {
      return Future(() => "");
    }
     return _getAppInfo.androidAppIconDirPath();
  }

  /// 复制APP图标到指定目录
  @override
  Future<bool> copyAppIcon() {
     if (!Platform.isIOS) {
       return Future(() => false);
     }
     try {
       final rs = _getAppInfo.copyAppIcon();
       return rs;
     } catch (e) {
       debugPrint("copyAppIcon error: $e");
       return Future(() => false);
     }
  }

}
