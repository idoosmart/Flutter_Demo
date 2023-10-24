// ignore_for_file: constant_identifier_names

import 'package:protocol_ffi/protocol_ffi.dart';

import '../../protocol_core.dart';
import '../manager/manager_clib.dart';

extension IDOProtocolCoreManagerExtSport on IDOProtocolCoreManager {

  void initParameter() {
    return IDOProtocolClibManager().cLib.initParameter();
  }

  /// gsp运动后优化轨迹,根据运动类型初始化速度阈值，若输入其他运动类型，会导致无运动轨迹
  ///
  /// [motionTypeIn] 运动类型：
  /// ```dart
  /// 1、户外走路 = 52, 走路 = 1, 徒步 = 4, 运动类型设为0
  /// 2、户外跑步 = 48, 跑步 = 2, 运动类型设为1
  /// 3、户外骑行 = 50, 骑行 = 3, 运动型性设为2
  /// ```dart
  int initType(int motionTypeIn) {
    return IDOProtocolClibManager().cLib.initType(motionTypeIn);
  }

  /// gps数据实时处理入口,需要对输出的数据进行判断，若纬度为-180则为错误值，不应该输出
  /// ```dart
  /// { lon,经度,数据类型double
  ///  lat,纬度,数据类型double
  ///  timestamp,时间戳,数据类型int
  ///  accuracy,定位精度,数据类型double
  ///  gpsaccuracystatus,定位等级，0 = 定位未知, 1 = 定位好, 2 = 定位差,数据类型int }
  /// ```dart
  String appGpsAlgProcessRealtime({required String json}) {
    return IDOProtocolClibManager().cLib.appGpsAlgProcessRealtime(json: json);
  }

  /// 平滑数据，结果保存在数组lat和lon中
  /// ```dart
  /// {lat,纬度数组,长度为len,数据类型double
  ///  lon,经度数组,长度为len,数据类型double len,数据长度}
  /// ```dart
  String smoothData({required String json}) {
    return IDOProtocolClibManager().cLib.smoothData(json: json);
  }

}
