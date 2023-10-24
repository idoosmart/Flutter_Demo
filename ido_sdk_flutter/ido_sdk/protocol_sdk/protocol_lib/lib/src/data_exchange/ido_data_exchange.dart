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
  init, /// 初始化
  appStart, /// app发起开始
  appStartReply, /// app发起开始 ble回复
  appEnd, /// app发起结束
  appEndReply, /// app发起结束 ble回复
  appPause, /// app发起暂停
  appPauseReply, /// app发起暂停 ble回复
  appRestore, /// app发起恢复
  appRestoreReply, /// app发起恢复 ble回复
  appIng, /// app发起交换
  appIngReply, /// app发起交换 ble回复
  getActivity, /// 获取最后运动数据
  getActivityReply, /// 获取最后运动数据 ble回复
  getHr, /// 获取一分钟心率
  getHrReply, /// 获取一分钟心率 ble回复
  getActivityGps, /// 获取活动GPS
  getActivityGpsReply, /// 获取活动GPS ble回复
  appStartPlan, /// app开始运动计划
  appStartPlanReply, /// app开始运动计划 ble回复
  appPausePlan, /// app暂停运动计划
  appPausePlanReply, /// app暂停运动计划 ble回复
  appRestorePlan, /// app恢复运动计划
  appRestorePlanReply, /// app恢复运动计划 ble回复
  appEndPlan, /// app结束运动计划
  appEndPlanReply, /// app结束运动计划 ble回复
  appSwitchAction, /// app切换动作
  appSwitchActionReply, /// app切换动作 ble回复
  appBlePause, /// app发起的运动 ble发起暂停
  appBlePauseReply, /// app发起的运动 ble发起暂停 app回复
  appBleRestore, /// app发起的运动 ble发起恢复
  appBleRestoreReply, /// app发起的运动 ble发起恢复 app回复
  appBleEnd, /// app发起的运动 ble发起结束
  appBleEndReply, /// app发起的运动 ble发起结束 app回复
  bleStart, ///ble发起的运动 ble发起开始
  bleStartReply, ///ble发起的运动 ble发起开始 app回复
  bleEnd, ///ble发起的运动 ble发起结束
  bleEndReply, ///ble发起的运动 ble发起结束 app回复
  blePause, ///ble发起的运动 ble发起暂停
  blePauseReply, ///ble发起的运动 ble发起暂停 app回复
  bleRestore, ///ble发起的运动 ble发起恢复
  bleRestoreReply, ///ble发起的运动 ble发起恢复 app回复
  bleIng, ///ble发起的运动 ble发起交换
  bleIngReply, ///ble发起的运动 ble发起交换 app回复
  bleStartPlan, /// ble开始运动计划
  blePausePlan, /// ble暂停运动计划
  bleRestorePlan, /// ble恢复运动计划
  bleEndPlan, /// ble结束运动计划
  bleSwitchAction, /// ble切换动作
  bleOperatePlanReply, /// ble操作运动计划 app回复
}

abstract class IDOExchangeData {

  factory IDOExchangeData() => _IDOExchangeData();

  /// 获取是否支持v3运动数据交换
  bool get supportV3ActivityExchange;

  /// 数据交换状态
  ExchangeStatus? get status;

  /// app执行数据交换
  /// model
  /// IDOAppStartExchangeModel : app 开始发起运动
  /// IDOAppEndExchangeModel : app 发起运动结束
  /// IDOAppIngExchangeModel : app 交换运动数据
  /// IDOAppPauseExchangeModel : app 交换运动数据暂停
  /// IDOAppRestoreExchangeModel : app 交换运动数据恢复
  /// IDOAppIngV3ExchangeModel : app v3交换运动数据
  /// IDOAppOperatePlanExchangeModel : app 操作运动计划
  void appExec({required IDOBaseExchangeModel model});

  /// ble发起运动 ble执行数据交换 app回复
  /// model
  /// IDOBleStartReplyExchangeModel : ble设备发送交换运动数据开始 app回复
  /// IDOBleIngReplyExchangeModel : ble设备交换运动数据过程中 app回复
  /// IDOBleEndReplyExchangeModel : ble设备发送交换运动数据结束 app回复
  /// IDOBlePauseReplyExchangeModel : ble设备发送交换运动数据暂停 app回复
  /// IDOBleRestoreReplyExchangeModel : ble设备发送交换运动数据恢复 app回复
  /// IDOBleOperatePlanReplyExchangeModel : ble设备操作运动计划 app回复
  /// app发起运动 ble执行数据交换 app回复
  /// model
  /// IDOAppBlePauseReplyExchangeModel : ble设备发送交换运动数据暂停 app回复
  /// IDOAppBleRestoreReplyExchangeModel : ble设备发送交换运动数据恢复 app回复
  /// IDOAppBleEndReplyExchangeModel : ble设备发送交换运动数据结束 app回复
  void appReplyExec({required IDOBaseExchangeModel model});

  /// 多运动数据最后一次数据获取
  /// ExchangeResponse.model : IDOAppActivityDataV3ExchangeModel
  Stream<ExchangeResponse> getLastActivityData();

  /// 多运动获取一分钟心率数据
  /// ExchangeResponse.model : IDOAppHrDataExchangeModel
  Stream<ExchangeResponse> getActivityHrData();

  /// 多运动获取一段时间的gps数据
  Stream<ExchangeResponse> getActivityGpsData();

  /// ble发起运动 app监听ble
  /// ExchangeResponse.model
  /// IDOBleStartExchangeModel : ble设备发送交换运动数据开始
  /// IDOBleIngExchangeModel : ble设备交换运动数据过程中
  /// IDOBleEndExchangeModel : ble设备发送交换运动数据结束
  /// IDOBlePauseExchangeModel : ble设备发送交换运动数据暂停
  /// IDOBleRestoreExchangeModel : ble设备发送交换运动数据恢复
  /// IDOBleOperatePlanExchangeModel : ble设备操作运动计划
  /// app发起运动 app监听ble
  /// ExchangeResponse.model
  /// IDOAppBlePauseExchangeModel : ble设备发送交换运动数据暂停
  /// IDOAppBleRestoreExchangeModel : ble设备发送交换运动数据恢复
  /// IDOAppBleEndExchangeModel : ble设备发送交换运动数据结束
  Stream<ExchangeResponse> appListenBleExec();

  /// app执行响应 ExchangeResponse.model
  /// IDOAppStartReplyExchangeModel : app 开始发起运动 ble回复
  /// IDOAppEndReplyExchangeModel : app 发起运动结束 ble回复
  /// IDOAppIngReplyExchangeModel : app 交换运动数据 ble回复
  /// IDOAppPauseReplyExchangeModel : app 交换运动数据暂停 ble回复
  /// IDOAppRestoreReplyExchangeModel : app 交换运动数据恢复 ble回复
  /// IDOAppIngV3ReplyExchangeModel : app v3交换运动数据 ble回复
  /// IDOAppOperatePlanReplyExchangeModel app 操作运动计划 ble回复
  Stream<ExchangeResponse> appListenAppExec();

  /// 交换v2数据
  Stream<IDOV2ExchangeModel> v2_exchangeData();

  /// 交换v3数据
  Stream<IDOV3ExchangeModel> v3_exchangeData();


}
