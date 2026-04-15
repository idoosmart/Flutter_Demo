//
//  DataSyncImpl.swift
//  protocol_channel
//
//  Created by hc on 2023/9/20.
//

import Foundation

private var _syncData: SyncData? {
    return SwiftProtocolChannelPlugin.shared.syncData
}

class SyncDataImpl: IDOSyncDataInterface {
    
    var syncStatus: IDOSyncStatus {
        return SyncDataDelegateImpl.shared.syncStatus
    }
    
    
    func startSync(funcProgress: @escaping BlockDataSyncProgress, funcData: @escaping BlockDataSyncData, funcCompleted: @escaping BlockDataSyncCompleted) {
        SyncDataDelegateImpl.shared.callbackProgress = funcProgress
        SyncDataDelegateImpl.shared.callbackSyncData = funcData
        SyncDataDelegateImpl.shared.callbackSyncCompleted = funcCompleted
        _runOnMainThread {
            _syncData?.startSync(completion: { _ in })
        }
    }
    
    func startSync(
        types: [IDOSyncDataTypeClass],
        funcData: @escaping BlockDataSyncData,
        funcCompleted: @escaping BlockDataSyncCompleted) {
            SyncDataDelegateImpl.shared.callbackProgress = nil
            SyncDataDelegateImpl.shared.callbackSyncData = funcData
            SyncDataDelegateImpl.shared.callbackSyncCompleted = funcCompleted
            let listType = types.map { $0.syncDataType.rawValue.int64 }
            _runOnMainThread {
                _syncData?.startSyncWithTypes(types: listType, completion: { _ in })
            }
        }
    
    func getSupportSyncDataTypeList(completion: @escaping ([IDOSyncDataTypeClass]) -> Void) {
        _runOnMainThread {
            _syncData?.getSupportSyncDataTypeList(completion: { list in
                let items = list.map { IDOSyncDataTypeClass(type: IDOSyncDataType(rawValue: $0.int)!) }
                completion(items)
            })
        }
    }

    func syncStatus(completion: @escaping (IDOSyncStatus) -> Void) {
        _runOnMainThread {
            _syncData?.syncStatus(completion: { type in
                completion(IDOSyncStatus(rawValue: type.rawValue)!)
            })
        }
    }

    func stopSync() {
        _runOnMainThread {
            _syncData?.stopSync {}
        }
    }
}

/// 同步整体进度 0-100
public typealias BlockDataSyncProgress = (_ progress: Double) -> Void

/// 不同类型JSON数据同步回调
///
/// ```dart
///  errorCode:
///  0 Successful command
///  1 SVC handler is missing
///  2 SoftDevice has not been enabled
///  3 Internal Error
///  4 No Memory for operation
///  5 Not found
///  6 Not supported
///  7 Invalid Parameter
///  8 Invalid state, operation disallowed in this state
///  9 Invalid Length
///  10 Invalid Flags
///  11 Invalid Data
///  12 Invalid Data size
///  13 Operation timed out
///  14 Null Pointer
///  15 Forbidden Operation
///  16 Bad Memory Address
///  17 Busy
///  18 Maximum connection count exceeded.
///  19 Not enough resources for operation
///  20 Bt Bluetooth upgrade error
///  21 Not enough space for operation
///  22 Low Battery
///  23 Invalid File Name/Format
///  24 空间够但需要整理
///  25 空间整理中
///
///  当指令发出前异常时:
/// -1 取消
/// -2 失败
/// -3 指令已存在队列中
/// -4 设备断线
/// -5 ota模式
/// ```
public typealias BlockDataSyncData = (_ type: IDOSyncDataType,
                                      _ jsonStr: String,
                                      _ errorCode: Int) -> Void
/// 所有数据同步完成
///
/// ```dart
///  0 Successful command
///  1 SVC handler is missing
///  2 SoftDevice has not been enabled
///  3 Internal Error
///  4 No Memory for operation
///  5 Not found
///  6 Not supported
///  7 Invalid Parameter
///  8 Invalid state, operation disallowed in this state
///  9 Invalid Length
///  10 Invalid Flags
///  11 Invalid Data
///  12 Invalid Data size
///  13 Operation timed out
///  14 Null Pointer
///  15 Forbidden Operation
///  16 Bad Memory Address
///  17 Busy
///  18 Maximum connection count exceeded.
///  19 Not enough resources for operation
///  20 Bt Bluetooth upgrade error
///  21 Not enough space for operation
///  22 Low Battery
///  23 Invalid File Name/Format
///  24 空间够但需要整理
///  25 空间整理中
///
///  当指令发出前异常时:
/// -1 取消
/// -2 失败
/// -3 指令已存在队列中
/// -4 设备断线
/// -5 ota模式
/// ```
public typealias BlockDataSyncCompleted = (_ errorCode: Int) -> Void

/// 同步数据类型
@objc
public enum IDOSyncDataType: Int, CustomStringConvertible {
    
    case nullType = 0
    /// 步数
    case stepCount = 1
    /// 心率
    case heartRate = 2
    /// 睡眠
    case sleep = 3
    /// 血压
    case bloodPressure = 4
    /// 血氧
    case bloodOxygen = 5
    /// 压力
    case pressure = 6
    /// 噪音
    case noise = 7
    /// 皮温
    case piven = 8
    /// 呼吸率
    case respirationRate = 9
    /// 身体电量
    case bodyPower = 10
    /// HRV
    case hRV = 11
    /// 多运动
    case activity = 12
    /// GPS
    case gPS = 13
    /// 游泳
    case swim = 14
    /// 情绪健康
    case emotionHealth = 21
    /// 多运动/游泳/跑步课程/跑步计划/跑后拉伸数据回调
    case activityMerge = 22
    /// 宠物睡眠数据
    case petSleep = 23
//    /// V2步数（旧）
//    case v2StepCount = 15
//    /// V2睡眠（旧）
//    case v2Sleep = 16
//    /// V2心率（旧）
//    case v2HeartRate = 17
//    /// V2血压（旧）
//    case v2BloodPressure = 18
//    /// V2 GPS
//    case v2GPS = 19
//    /// V2多运动
//    case v2Activity = 20
    
    public var description: String {
        switch self {
        case .nullType:
            return "nullType"
        case .stepCount:
            return "stepCount"
        case .heartRate:
            return "heartRate"
        case .sleep:
            return "sleep"
        case .bloodPressure:
            return "bloodPressure"
        case .bloodOxygen:
            return "bloodOxygen"
        case .pressure:
            return "pressure"
        case .noise:
            return "noise"
        case .piven:
            return "piven"
        case .respirationRate:
            return "respirationRate"
        case .bodyPower:
            return "bodyPower"
        case .hRV:
            return "hRV"
        case .activity:
            return "activity"
        case .gPS:
            return "gPS"
        case .swim:
            return "swim"
        case .emotionHealth:
            return "emotionHealth"
        case .activityMerge:
            return "activityMerge"
        case .petSleep:
            return "petSleep"
        }
    }
    
}

/// 状态
@objc
public enum IDOSyncStatus: Int {
    case `init` = 0
    /// 初始化
    case syncing = 1
    /// 同步中
    case finished = 2
    /// 同步完成
    case canceled = 3
    /// 同步取消
    case stopped = 4
    /// 同步停止
    case timeout = 5
    /// 同步超时
    case error = 6
}
