import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

import '../../../protocol_lib.dart';
import '../../private/local_storage/local_storage.dart';
import '../../private/logger/logger.dart';

part 'private/om_manager_impl.dart';

enum IDOOfflineMapState {
  /// 成功
  successful,
  
  /// 取消
  canceled,

  /// 失败
  failed,

  /// 无效地图名称
  invalidMapName,

  /// 无效资源
  invalidResource,

  /// 空间不足
  insufficientSpace,

  /// 解压资源失败
  unzipResourceFailed,

  /// 查询地图配置失败
  queryConfigFailed,

  /// 查询地图详情失败
  queryMapInfoFailed,

  /// 设置地图信息(名称、总大小、文件列表等)失败
  setMapInfoFailed,

  /// 添加地图失败
  addMapFailed,

  /// 删除地图失败
  deleteMapFailed,

  /// 添加轨迹失败
  addTrackFailed,

  /// 轨迹已存在
  trackExists,

  /// 设备处于运动中，请结束运动后结束重试
  deviceIsSporting,

  /// 设备处于通话中，请结束通话后重试
  deviceIsCalling,

  /// 设备正在处于省电模式
  devicePowerSaving,

  /// 设备充电中
  deviceInCharging,

  /// 设备已满
  deviceFullNumber,
}

abstract class IDOOfflineMapManager {
  factory IDOOfflineMapManager() => _IDOOfflineMapManager();

  /// 查询授权 & uuid
  /// 
  /// ```dart
  /// return null 失败， 其它：根据OMAuthorizationInformation判断
  /// ```
  Future<List<OMAuthorizationInformation>?> checkAuthorized();

  /// 设置授权
  /// 
  /// ```dart
  /// return 0: 设置成功 其它: 设置失败
  /// ```
  Future<int> configureAuthorization({required String code});


  /// 查询固件地图配置信息
  ///
  /// ```dart
  /// return null 失败， 其它：OMMapConfigReply
  /// ```
 Future<List<OMMapConfigReply>?> queryMapConfig();

  /// 上传离线地图
  /// 
  /// ```dart
  /// mapName: 地图名称（最大31字节）
  /// filePath: 地图zip文件路径
  /// sendProgress: 发送进度回调
  /// funcComplete: 完成回调
  /// ```
  void uploadMap(
    String mapName,
    String filePath,
    void Function(double progress)? sendProgress,
    void Function(IDOOfflineMapState state) funcComplete,
  );

  /// 终止上传离线地图
  void stopUploadMap();


  /// 上传轨迹文件
  /// 
  /// ```dart
  /// trackName: 轨迹名称（最大91个字节）
  /// filePath: 轨迹文件路径
  /// distance: 运动路线距离，单位：米
  /// duration: 运动路线推荐时长，单位：秒
  /// type: 运动路线类型：0 无效，1 步行类，2 骑行类, ...
  /// sendProgress: 发送进度回调
  /// funcComplete: 完成回调
  /// ```
  void uploadTrack(
    String trackName,
    String filePath,
    int distance,
    int duration,
    int type,
    void Function(double progress)? sendProgress,
    void Function(IDOOfflineMapState errorCode) funcComplete,
  );

  /// 终止上传轨迹
  void stopUploadTrack();

  /// 删除地图
  /// 
  /// ```dart
  /// mapFiles: 地图文件列表 （支持最多一次性30个）
  /// return 0: 删除成功 其它: 删除失败
  /// ```
  Future<IDOOfflineMapState> deleteMap(List<OMOfflineMapFileInfo> mapFiles);

}
