import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:protocol_lib/protocol_lib.dart';
import 'package:get_storage_lite/get_storage.dart';
import 'package:native_channel/native_channel.dart';

import '../../function_table/model/function_table_model.dart';
import '../../device_info/model/firmware_version_model.dart';
import '../../device_info/model/device_info_ext_model.dart';
import '../../sub_modules/model/device_ota_info.dart';
import '../logger/logger.dart';

part 'part/local_storage_impl.dart';

/// 存储器（sdk内部私有）
LocalStorage? storage;

abstract class LocalStorageConfig {
  String get macAddress;
}

abstract class LocalStorage {
  late final LocalStorageConfig config;
  factory LocalStorage.config({required LocalStorageConfig config}) =>
      _LocalStorage._internal(config);

  /// 初始化存储器
  Future<bool>initStorage();

  /// 存储键-值数据（当前连接设备可用）
  Future<bool> setString({required String key, required String value});

  /// 获取键-值数据（当前连接设备可用）
  Future<String?> getString({required String key});


  /// 存储键-值数据（当前连接设备可用）
  Future<bool> setInt({required String key, required int value});

  /// 获取键-值数据（当前连接设备可用）
  Future<int?> getInt({required String key});


  /// 存储键-值数据（当前连接设备可用）
  Future<bool> setBool({required String key, required bool value});

  /// 获取键-值数据（当前连接设备可用）
  Future<bool?> getBool({required String key});

  /// 删除键-值数据
  ///
  /// 不指定mac地址，默认使用当前连接设备mac地址
  Future<bool> remove({required String key, String? macAddress});

  /// 获取当前storage根目录
  /// ```
  /// 返回：/xx/../ido_sdk/devices/{macAddress}
  /// ```
  Future<String> pathRoot();

  /// 获取当前sdk根目录
  /// ```
  /// 返回：/xx/../ido_sdk
  /// ```
  Future<String> pathSDK();

  /// 获取当前sdk根目录 (静态方法)
  /// ```
  /// 返回：/xx/../ido_sdk
  /// ```
  static Future<String> pathSDKStatic() {
    return _LocalStorage.pathSDKStatic();
  }

  /// 消息图标缓存目录
  /// ```
  /// 返回：/xx/../ido_sdk/message_icon
  /// ```
  Future<String> pathMessageIcon();

  /// alexa缓存目录
  /// ```
  /// 返回：/xx/../ido_sdk/alexa
  /// ```
  Future<String> pathAlexa();

  /// 设备日志缓存目录
  /// ```
  /// 返回：/xx/../ido_sdk/devices
  /// ```
  Future<String> pathDevices();

  /// 设备日志缓存目录
  /// ```
  /// 返回：/xx/../ido_sdk/devices/{macAddress}/device_logs
  /// ```
  Future<String> pathDeviceLog();

  /// c库功能表缓存目录
  /// ```
  /// 返回：/xx/../ido_sdk/devices/{macAddress}/c_files
  /// ```
  Future<String> pathCLibFuncTable();

  /// ota缓存目录
  /// ```
  /// 返回：/xx/../ido_sdk/devices/ota
  /// ```
  Future<String> pathOTA();

  /// 创建目录
  Future<bool> createDir({required String absoluteDirPath});
  /// 删除目录（同时删除目录下所有内容）
  Future<bool> removeDir({required String absoluteDirPath});

  /// 创建文件
  Future<bool> createFile({required String absoluteFilePath});
  /// 删除文件
  Future<bool> removeFile({required String absoluteFilePath});

  /// 清除所有缓存数据（待实现）
  Future<bool> cleanAll();

  /// 切换设备时重置内存中的缓存路径
  void resetCachePathOnDeviceChanged();

  // 设备列表
  Future<List<DeviceInfoExtModel>> loadDeviceExtListByDisk({bool sortDesc = true});
  DeviceInfoExtModel? loadDeviceInfoExtWith(String? macAddress);
  Future<bool> saveDeviceInfoExtToDisk(DeviceInfoExtModel deviceInfoExt);

  // 功能表
  Future<FunctionTableModel?> loadFunctionTableByDisk();
  Future<bool> saveFunctionTableToDisk(FunctionTableModel functionTableModel);
  Future<FunctionTableModel?> loadFunctionTableWith({required String macAddress});

  // 设备信息
  Future<DeviceInfoModel?> loadDeviceInfoByDisk();
  Future<bool> saveDeviceInfoToDisk(DeviceInfoModel deviceInfoModel);
  Future<List<DeviceInfoModel>> loadDeviceInfoListByDisk({bool sortDesc = true});

  // 固件三级版本
  Future<FirmwareVersionModel?> loadFirmwareVersionByDisk();
  Future<bool> saveFirmwareVersionToDisk(FirmwareVersionModel fwVersion);

  // 绑定 授权码
  Future<String?> loadBindEncryptedDataByDisk();
  Future<bool> saveBindEncryptedDataToDisk(String data);
  Future<bool> cleanBindEncryptedData();

  // 绑定 配对码
  Future<String?> loadBindAuthDataByDisk();
  Future<bool> saveBindAuthDataToDisk(String data);
  Future<bool> cleanBindAuthData();

  // 绑定状态
  Future<bool> loadBindStatus({required String macAddress});
  Future<bool> cleanBindStatus({required String macAddress});
  Future<bool?> saveBindStatus(bool isBind);

  // 授权模式 （0 未知，1 授权码，2 配对码)
  Future<int> loadAuthMode();
  Future<bool?> saveAuthMode(int authMode);
  Future<bool> cleanAuthMode([String? macAddress]);

  // 动态消息图标 信息
  Future<IDOAppIconInfoModel?> loadIconInfoDataByDisk();
  Future<bool> saveIconInfoDataToDisk(IDOAppIconInfoModel model);
  Future<bool> cleanIconInfoData(String macAddress);
  Future<bool> removeIconDir(String dirPath);

  // 用户设置的默认消息图标
  Future<IDOAppIconInfoModel?> loadUserDefaultMsgIconByDisk();
  Future<bool> saveUserDefaultMsgIconToDisk(IDOAppIconInfoModel model);
  Future<bool> cleanUserMsgDefaultIcon();

  // 日志文件保存策略
  Future<Map<String, dynamic>?> loadLogConfigProtocol();
  Future<int?> loadLogConfigClib();
  Future<bool> saveLogConfigProtocol(int fileSize, fileCount);
  Future<bool> saveLogConfigClib(int saveDay);

  Future<IDODeviceOtaInfo?> loadOtaInfoByDisk();
  Future<bool> saveOtaInfoToDisk(IDODeviceOtaInfo otaInfo);
  Future<bool> removeOtaInfo(String macAddress);
}
