import 'dart:convert';
import 'dart:io';

import 'package:protocol_lib/protocol_lib.dart';
import 'package:get_storage_lite/get_storage.dart';

import '../../service/model/voicealarm_model.dart';
import '../logger/logger.dart';
import '../../service/model/auth_model.dart';
import '../../type_define/alexa_type.dart';

part 'inner/local_storage_impl.dart';

/// 存储器（内部私有）
LocalStorage? storage;

abstract class LocalStorageConfig {
  String get uniqueID; // 唯一标识
}

abstract class LocalStorage {
  late final LocalStorageConfig config;
  factory LocalStorage.config({required LocalStorageConfig config}) =>
      _LocalStorage._internal(config);

  /// 存储键-值数据
  Future<bool> setString({required String key, required String value});

  /// 获取键-值数据
  Future<String?> getString({required String key});

  /// 存储键-值数据
  Future<bool> setInt({required String key, required int value});

  /// 获取键-值数据
  Future<int?> getInt({required String key});

  /// 存储键-值数据
  Future<bool> setBool({required String key, required bool value});

  /// 获取键-值数据
  Future<bool?> getBool({required String key});

  /// 删除键-值数据
  Future<bool> remove({required String key});

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

  /// 加载授权信息
  Future<AuthModel?> loadAuthDataByDisk();
  Future<bool> saveAuthDataToDisk(AuthModel model);
  void cleanAuthData();

  /// 加载语言
  Future<AlexaLanguageType?> loadLanguageType();
  Future<bool> saveLanguageType(AlexaLanguageType countryType);

  /// 加载ProductId
  Future<String?> loadProductId();
  Future<bool> saveProductId(String productId);

  /// 加载闹钟缓存信息
  Future<List?> loadAlarmDataByDisk(String mac);
  Future<bool> saveAlarmDataToDisk(String mac, List alexaAlarmList);
}
