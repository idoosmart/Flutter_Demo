import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:protocol_core/protocol_core.dart';
import 'package:protocol_lib/src/private/logger/logger.dart';

import '../../protocol_lib.dart';
import 'model/base_exchange_model.dart';
import 'model/exchange_response.dart';
import 'extension/ecxchange_tool.dart';

part 'part/data_exchange_impl.dart';

/// 交换数据状态
enum ExchangeStatus {
  /// 初始化
  init,
  /// app发起开始
  appStart,
  /// app发起开始 ble回复
  appStartReply,
  /// app发起结束
  appEnd,
  /// app发起结束 ble回复
  appEndReply,
  /// app发起暂停
  appPause,
  /// app发起暂停 ble回复
  appPauseReply,
  /// app发起恢复
  appRestore,
  /// app发起恢复 ble回复
  appRestoreReply,
  /// app发起交换
  appIng,
  /// app发起交换 ble回复
  appIngReply,
  /// 获取最后运动数据
  getActivity,
  /// 获取最后运动数据 ble回复
  getActivityReply,
  /// 获取一分钟心率
  getHr,
  /// 获取一分钟心率 ble回复
  getHrReply,
  /// 获取活动GPS
  getActivityGps,
  /// 获取活动GPS ble回复
  getActivityGpsReply,
  /// app开始运动计划
  appStartPlan,
  /// app开始运动计划 ble回复
  appStartPlanReply,
  /// app暂停运动计划
  appPausePlan,
  /// app暂停运动计划 ble回复
  appPausePlanReply,
  /// app恢复运动计划
  appRestorePlan,
  /// app恢复运动计划 ble回复
  appRestorePlanReply,
  /// app结束运动计划
  appEndPlan,
  /// app结束运动计划 ble回复
  appEndPlanReply,
  /// app切换动作
  appSwitchAction,
  /// app切换动作 ble回复
  appSwitchActionReply,
  /// app发起的运动 ble发起暂停
  appBlePause,
  /// app发起的运动 ble发起暂停 app回复
  appBlePauseReply,
  /// app发起的运动 ble发起恢复
  appBleRestore,
  /// app发起的运动 ble发起恢复 app回复
  appBleRestoreReply,
  /// app发起的运动 ble发起结束
  appBleEnd,
  /// app发起的运动 ble发起结束 app回复
  appBleEndReply,
  /// ble发起的运动 ble发起开始
  bleStart,
  /// ble发起的运动 ble发起开始 app回复
  bleStartReply,
  /// ble发起的运动 ble发起结束
  bleEnd,
  /// ble发起的运动 ble发起结束 app回复
  bleEndReply,
  /// ble发起的运动 ble发起暂停
  blePause,
  /// ble发起的运动 ble发起暂停 app回复
  blePauseReply,
  /// ble发起的运动 ble发起恢复
  bleRestore,
  /// ble发起的运动 ble发起恢复 app回复
  bleRestoreReply,
  /// ble发起的运动 ble发起交换
  bleIng,
  /// ble发起的运动 ble发起交换 app回复
  bleIngReply,
  /// ble开始运动计划
  bleStartPlan,
  /// ble暂停运动计划
  blePausePlan,
  /// ble恢复运动计划
  bleRestorePlan,
  /// ble结束运动计划
  bleEndPlan,
  /// ble切换动作
  bleSwitchAction,
  /// ble操作运动计划 app回复
  bleOperatePlanReply
}

abstract class IDOExchangeData {

  factory IDOExchangeData() => _IDOExchangeData();

  /// 获取是否支持v3运动数据交换
  bool get supportV3ActivityExchange;

  /// 数据交换状态
  ExchangeStatus? get status;

  /// 监听数据交换状态
  Stream<ExchangeStatus> listenExchangeStatus();

  /// app执行数据交换
  /// IDOAppStartExchangeModel : app 开始发起运动
  /// IDOAppEndExchangeModel : app 发起运动结束
  /// IDOAppIngExchangeModel : app 交换运动数据
  /// IDOAppPauseExchangeModel : app 交换运动数据暂停
  /// IDOAppRestoreExchangeModel : app 交换运动数据恢复
  /// IDOAppIngV3ExchangeModel : app v3交换运动数据
  /// IDOAppOperatePlanExchangeModel : app 操作运动计划
  void appExec({required IDOBaseExchangeModel model});

  /// ble发起运动 ble执行数据交换 app回复
  /// IDOBleStartReplyExchangeModel : ble设备发送交换运动数据开始 app回复
  /// IDOBleIngReplyExchangeModel : ble设备交换运动数据过程中 app回复
  /// IDOBleEndReplyExchangeModel : ble设备发送交换运动数据结束 app回复
  /// IDOBlePauseReplyExchangeModel : ble设备发送交换运动数据暂停 app回复
  /// IDOBleRestoreReplyExchangeModel : ble设备发送交换运动数据恢复 app回复
  /// IDOBleOperatePlanReplyExchangeModel : ble设备操作运动计划 app回复
  ///
  /// app发起运动 ble执行数据交换 app回复
  /// IDOAppBlePauseReplyExchangeModel : ble设备发送交换运动数据暂停 app回复
  /// IDOAppBleRestoreReplyExchangeModel : ble设备发送交换运动数据恢复 app回复
  /// IDOAppBleEndReplyExchangeModel : ble设备发送交换运动数据结束 app回复
  void appReplyExec({required IDOBaseExchangeModel model});

  /// 获取多运动数据最后一次数据
  Future<bool> getLastActivityData();

  /// 获取多运动一分钟心率数据
  Future<bool> getActivityHrData();

  /// 获取多运动一段时间的gps数据
  Future<bool> getActivityGpsData();

  /// ble发起运动 app监听ble
  /// ExchangeResponse.model
  /// IDOBleStartExchangeModel : ble设备发送交换运动数据开始
  /// IDOBleIngExchangeModel : ble设备交换运动数据过程中
  /// IDOBleEndExchangeModel : ble设备发送交换运动数据结束
  /// IDOBlePauseExchangeModel : ble设备发送交换运动数据暂停
  /// IDOBleRestoreExchangeModel : ble设备发送交换运动数据恢复
  /// IDOBleOperatePlanExchangeModel : ble设备操作运动计划
  ///
  /// app发起运动 ble操作响应
  /// IDOAppBlePauseExchangeModel : ble设备发送交换运动数据暂停
  /// IDOAppBleRestoreExchangeModel : ble设备发送交换运动数据恢复
  /// IDOAppBleEndExchangeModel : ble设备发送交换运动数据结束
  ///
  /// app发起运动 ble响应回复
  /// ExchangeResponse.model
  /// IDOAppStartReplyExchangeModel : app 开始发起运动 ble回复
  /// IDOAppEndReplyExchangeModel : app 发起运动结束 ble回复
  /// IDOAppIngReplyExchangeModel : app 交换运动数据 ble回复
  /// IDOAppPauseReplyExchangeModel : app 交换运动数据暂停 ble回复
  /// IDOAppRestoreReplyExchangeModel : app 交换运动数据恢复 ble回复
  /// IDOAppIngV3ReplyExchangeModel : app v3交换运动数据 ble回复
  /// IDOAppOperatePlanReplyExchangeModel app 操作运动计划 ble回复
  ///
  /// app 获取多运动响应的数据
  /// ExchangeResponse.model
  /// IDOAppActivityDataV3ExchangeModel : 获取多运动数据最后一次数据
  /// IDOAppHrDataExchangeModel : 多运动获取一分钟心率数据
  /// IDOAppGpsDataExchangeModel : 多运动获取一段时间的gps数据
  Stream<ExchangeResponse> listenBleResponse();

  /// 交换v2数据
  Stream<IDOV2ExchangeModel> v2_exchangeData();

  /// 交换v3数据
  Stream<IDOV3ExchangeModel> v3_exchangeData();


}
