import 'dart:convert' as convert;
import 'dart:developer';

import 'package:protocol_lib/src/private/logger/logger.dart';

import '../../ido_protocol_lib.dart';
import '../../type_define/event_type.dart';

abstract class AbstractSyncCalculate {
  /// v2 健康进度比例
  int v2HealthProportion = 0;

  /// v2 多运动进度比例
  int v2ActivityProportion = 0;

  /// v2 GPS进度比例
  int v2GpsProportion = 0;

  /// v3 同步进度比例
  int v3DataProportion = 0;

  /// v2 健康进度
  int v2HealthProgress = 0;

  /// v2 多运动进度
  int v2ActivityProgress = 0;

  /// v2 GPS进度
  int v2GpsProgress = 0;

  /// v3 同步进度
  int v3DataProgress = 0;

  /// 获取同步总进度 0-100
  double getSyncProgress();

  /// 刷新进度分配
  refreshProgressProportion();

  /// 获取v2 多运动数量
  int get activityCount;

  /// 获取v2 GPS数量
  int get gpsCount;

  /// 获取同步超时时长
  int get syncTimeout;
}

class SyncCalculate extends AbstractSyncCalculate {
  late final _libMgr = IDOProtocolLibManager();
  late final _funTable = _libMgr.funTable;
  int _activityCount = 0;
  int _gpsCount = 0;
  int _syncTimeout = 0;

  @override
  double getSyncProgress() {
    final progress = (v2HealthProgress * (v2HealthProportion / 100) +
        v2ActivityProgress * (v2ActivityProportion / 100) +
        v2GpsProgress * (v2GpsProportion / 100) +
        v3DataProgress * (v3DataProportion / 100));
    return progress > 100 ? 100 : progress; //保证不超过100
  }

  @override
  refreshProgressProportion() async {
    if (_isNeedSyncV2Data() && !_isNeedSyncV3Data()) {
      //只同步v2
      List<int> countData = await _getActivityAndGpsCount();
      _activityCount = countData[0];
      _gpsCount = countData[1];
      _distributionProportion(true, false, _activityCount, _gpsCount);
    } else if (!_isNeedSyncV2Data() && _isNeedSyncV3Data()) {
      //只同步v3
      _distributionProportion(false, true, 0, 0);
    } else {
      //同步v2和v3
      List<int> countData = await _getActivityAndGpsCount();
      _activityCount = countData[0];
      _gpsCount = countData[1];
      _distributionProportion(true, true, _activityCount, _gpsCount);
    }
  }

  @override
  int get activityCount => _activityCount;

  @override
  int get gpsCount => _gpsCount;

  @override
  int get syncTimeout => _syncTimeout;

  // 获取v2活动个数
  Future<List<int>> _getActivityAndGpsCount() async {
    return _libMgr.send(evt: CmdEvtType.getActivityCount).map((response) {
      if (response.code == 0 && response.json != null) {
        var obj = convert.jsonDecode(response.json!);
        int activityCount = obj['count'] as int;
        int gpsCount = obj['gps_count'] as int;
        return [activityCount, gpsCount];
      } else {
        return [0, 0];
      }
    }).first;
  }

  // 判断功能表是否需要同步v2数据
  _isNeedSyncV2Data() {
    return _funTable.syncNeedV2 && _funTable.syncTimeLine;
  }

  // 判断功能表是否需要同步v3数据
  _isNeedSyncV3Data() {
    return _funTable.syncV3Hr ||
        _funTable.syncV3Sleep ||
        _funTable.syncV3Swim ||
        _funTable.syncV3Pressure ||
        _funTable.syncV3Activity ||
        _funTable.syncV3Gps ||
        _funTable.syncV3Sports ||
        _funTable.syncV3Spo2 ||
        _funTable.syncV3Noise ||
        _funTable.syncV3Temperature;
  }

  // 分配v2和v3的进度比例
  _distributionProportion(bool v2, bool v3, int count1, int count2) {
    if (v2 && !v3) {
      //只同步v2
      if (count1 > 0 && count2 > 0) {
        v2HealthProportion = 40;
        v2ActivityProportion = 30;
        v2GpsProportion = 30;
        _syncTimeout = 10 * 60;
      } else if (count1 > 0 && count1 == 0) {
        v2HealthProportion = 50;
        v2ActivityProportion = 50;
        v2GpsProportion = 0;
        _syncTimeout = 7 * 60;
      } else if (count1 == 0 && count1 == 0) {
        v2HealthProportion = 100;
        v2ActivityProportion = 0;
        v2GpsProportion = 0;
        _syncTimeout = 5 * 60;
      }
      v3DataProportion = 0;
    } else if (!v2 && v3) {
      //只同步v3
      v2HealthProportion = 0;
      v2ActivityProportion = 0;
      v2GpsProportion = 0;
      v3DataProportion = 100;
      _syncTimeout = 10 * 60;
    } else {
      //同步v2和v3
      if (count1 > 0 && count2 > 0) {
        v2HealthProportion = 20;
        v2ActivityProportion = 15;
        v2GpsProportion = 15;
        v3DataProportion = 50;
      } else if (count1 > 0 && count1 == 0) {
        v2HealthProportion = 30;
        v2ActivityProportion = 20;
        v2GpsProportion = 0;
        v3DataProportion = 50;
      } else if (count1 == 0 && count1 == 0) {
        v2HealthProportion = 30;
        v2ActivityProportion = 0;
        v2GpsProportion = 0;
        v3DataProportion = 70;
      }
      _syncTimeout = 10 * 60;
    }
    logger?.d('v2 health proportion: $v2HealthProportion '
        'v2 activity proportion: $v2ActivityProportion '
        'v2 gps proportion: $v2GpsProportion '
        'v3 data proportion: $v3DataProportion '
        'sync timeout: $_syncTimeout');
  }
}
