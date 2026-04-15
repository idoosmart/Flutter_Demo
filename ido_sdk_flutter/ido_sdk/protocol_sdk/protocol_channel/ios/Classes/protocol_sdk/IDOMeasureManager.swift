//
//  IDOMeasureManager.swift
//  protocol_channel
//
//  Created by hc on 2026/3/19.
//

import Foundation

private var _measureMgr: Measure? {
    return SwiftProtocolChannelPlugin.shared.measure
}

private var _measureImpl: MeasureDelegateImpl {
    return MeasureDelegateImpl.shared
}

/// 测量类型
@objc
public enum IDOMeasureType: Int {
    /// 血压
    case bloodPressure = 0
    /// 心率
    case heartRate = 1
    /// 血氧
    case spo2 = 2
    /// 压力
    case stress = 3
    /// 一键测量
    case oneClick = 4
    /// 体温
    case temperature = 5
    /// 身体成分
    case bodyComposition = 6
}

/// 测量状态
@objc
public enum IDOMeasureStatus: Int {
    /// 不支持
    case notSupport = 0
    /// 正在测量
    case measuring = 1
    /// 测量成功
    case success = 2
    /// 测量失败
    case failed = 3
    /// 设备正在运动模式
    case deviceInSportMode = 4
    /// 返回测量中数据
    case measuringData = 5
    /// 超时 (APP)
    case timeout = 6
    /// 停止 (APP)
    case stopped = 7
    /// 断连 (APP)
    case disconnected = 8
    /// 未佩戴 (设备通知 72)
    case unworn = 9
}

/// 测量结果模型
@objcMembers
public class IDOMeasureResult: NSObject {
    /// 状态
    public var status: IDOMeasureStatus = .notSupport
    /// 收缩压 (高压)
    public var systolicBp: Int = 0
    /// 舒张压 (低压)
    public var diastolicBp: Int = 0
    /// 值 (心率/血氧/压力)
    public var value: Int = 0
    /// 一键测量-心率
    public var oneClickHr: Int = 0
    /// 一键测量-压力
    public var oneClickStress: Int = 0
    /// 一键测量-血氧
    public var oneClickSpo2: Int = 0
    /// 体温值 (单位摄氏度,该值扩大了10倍, 如 366 表示 36.6度)
    public var temperatureValue: Int = 0
    
    fileprivate static func fromPigeon(_ result: MeasureResult) -> IDOMeasureResult {
        let rs = IDOMeasureResult()
        rs.status = IDOMeasureStatus(rawValue: result.status?.rawValue ?? 0) ?? .notSupport
        rs.systolicBp = Int(result.systolicBp ?? 0)
        rs.diastolicBp = Int(result.diastolicBp ?? 0)
        rs.value = Int(result.value ?? 0)
        rs.oneClickHr = Int(result.oneClickHr ?? 0)
        rs.oneClickStress = Int(result.oneClickStress ?? 0)
        rs.oneClickSpo2 = Int(result.oneClickSpo2 ?? 0)
        rs.temperatureValue = Int(result.temperatureValue ?? 0)
        return rs
    }
}


@objcMembers
public class IDOMeasureManager {
    public static let shared = IDOMeasureManager()
    private init() {}
    
    /// 监听测量中数据（心率/血氧有效）
    public func listenProcessMeasureData(callback: @escaping (IDOMeasureResult) -> Void) {
        _measureImpl.callbackProcessMeasureData = { result in
            let rs = IDOMeasureResult.fromPigeon(result)
            callback(rs)
        }
    }
    
    /// 开始测量
    public func startMeasure(type: IDOMeasureType, completion: @escaping (Bool) -> Void) {
        let pType = MeasureType(rawValue: type.rawValue)!
        _measureMgr?.startMeasure(type: pType, completion: completion)
    }
    
    /// 停止测量
    public func stopMeasure(type: IDOMeasureType, completion: @escaping (Bool) -> Void) {
        let pType = MeasureType(rawValue: type.rawValue)!
        _measureMgr?.stopMeasure(type: pType, completion: completion)
    }
    
    /// 获取测量数据
    public func getMeasureData(type: IDOMeasureType, completion: @escaping (IDOMeasureResult) -> Void) {
        let pType = MeasureType(rawValue: type.rawValue)!
        _measureMgr?.getMeasureData(type: pType, completion: { result in
            completion(IDOMeasureResult.fromPigeon(result))
        })
    }
}
