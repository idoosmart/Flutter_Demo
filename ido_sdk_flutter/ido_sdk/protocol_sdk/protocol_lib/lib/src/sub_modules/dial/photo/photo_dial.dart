/// ============================================================
/// File:           abs_phone_dial
/// Author:         hc
/// Created Date:   2025/3/24 15:48
/// Version:        1.0.0
/// Copyright:      © 2024 by IDO. All Rights Reserved.
/// Description:
///   -
/// ============================================================

import 'photo_dial_config.dart';
import 'photo_dial_preset_config.dart';

/// 照片表盘相关功能接口
abstract class IPhotoDial {
  /// 同步解析表盘配置包
  /// [dialPackagePath] 表盘配置包路径
  /// 返回表盘支持的一些配置项，如颜色、位置（坐标）、组件功能
  PhotoDialPresetConfig? prepareSync(String? dialPackagePath);

  /// 异步解析表盘配置包
  /// [dialPackagePath] 表盘配置包路径
  /// 返回表盘支持的一些配置项，如颜色、位置（坐标），组件功能
  Future<PhotoDialPresetConfig?> prepare(String? dialPackagePath);

  /// 安装表盘
  /// [config] 表盘配置
  /// [onSuccess] 安装成功时的回调函数
  /// [onFailed] 安装失败时的回调函数，回调错误码和错误信息
  void install(
      PhotoDialConfig config, {
        void Function()? onSuccess,
        void Function(int errCode, Object errMsg)? onFailed,
      });

  /// 取消安装
  void cancelInstall();
}