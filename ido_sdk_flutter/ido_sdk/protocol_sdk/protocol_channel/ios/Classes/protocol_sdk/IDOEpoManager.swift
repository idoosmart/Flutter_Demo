//
//  IDOEpoManager.swift
//  protocol_channel
//
//  Created by hc on 2024/8/8.
//

import Foundation

private var _epoMgr: ApiEPOManager? {
    return SwiftProtocolChannelPlugin.shared.epo
}

private var _epoImpl: EpoManagerDelegateImpl {
    return EpoManagerDelegateImpl.shared
}

@objcMembers
public class IDOEpoManager {
    public static let shared = IDOEpoManager()
    private init() {}
    
    /// 启用自动epo升级，默认为 关
    ///
    /// ```Swift
    /// 触发条件：
    /// 1、每次快速配置完成后倒计时1分钟；
    /// 2、数据同步完成后立即执行；
    /// ```
    public var enableAutoUpgrade: Bool = false {
        didSet {
            let newValue = enableAutoUpgrade
            _runOnMainThread {
                _epoMgr?.setEnableAutoUpgrade(value: newValue, completion: { })
            }
        }
    }
    
    /// 当前升级状态
    public var status: IDOEpoUpgradeStatus {
        get {
            return _epoImpl.upgradeStatus
        }
    }
    
    /// 是否支持epo升级
    public var isSupported: Bool {
        get {
            let ft = sdk.funcTable
            return (ft.setAirohaGpsChip && (ft.syncGps || ft.syncV3Gps)) || sdk.device.gpsPlatform == 3
        }
    }
    
    /// app提供当前手机gps信息，用于设备快速定位
    public var delegateGetGps: IDOEpoManagerDelegate? {
        didSet {
            _epoImpl.delegateGps = delegateGetGps
        }
    }
    
    /// 获取最后一次更新的时间戳，单位：毫秒
    ///
    /// 无记录则返回0
    public func lastUpdateTimestamp(completion: @escaping (Int) -> Void) {
        _runOnMainThread {
            _epoMgr?.lastUpdateTimestamp(completion: { rs in
                completion(rs.int)
            })
        }
    }
    
    /// 是否需要更新
    public func shouldUpdateForEPO(isForce: Bool = false, completion: @escaping (Bool) -> Void) {
        _runOnMainThread {
            _epoMgr?.shouldUpdateForEPO(isForce: isForce, completion: completion)
        }
    }
    
    /// 启动升级任务
    /// - Parameters:
    ///   - isForce: 是否强制更新, 默认为false
    ///   - retryCount:  重试次数，默认3次
    public func willStartInstall(isForce: Bool = false, retryCount: Int = 3) {
        _runOnMainThread {
            _epoMgr?.willStartInstall(isForce: isForce, retryCount: retryCount.int64, completion: { })
        }
    }
    
    /// 停止升级任务
    ///
    /// 注：只支持下载中和发送中的任务，不支持正在升级的任务
    public func stop() {
        _runOnMainThread {
            _epoMgr?.stop(completion: { })
        }
    }
    
    /// 监听epo升级回调（全局监听一次）
    /// - Parameters:
    ///  - funcStatus 升级状态
    ///  -  downProgress 下载进度
    ///  - sendProgress 发送进度
    ///  - funcComplete 升级完成, errorCode: 0成功，非0失败
    public func listenEpoUpgrade(
        funcStatus: @escaping (IDOEpoUpgradeStatus) -> Void,
        downProgress: ((Float) -> Void)?,
        sendProgress: ((Float) -> Void)?,
        funcComplete: @escaping (Int) -> Void
    ) -> Void {
        let epoImpl = EpoManagerDelegateImpl.shared
        epoImpl.callbackUpgradeStatus = funcStatus
        epoImpl.callbackDownProgress = downProgress
        epoImpl.callbackSendProgress = sendProgress
        epoImpl.callbackComplete = funcComplete
    }
}

@objc
public protocol IDOEpoManagerDelegate {
    /// 提供当前手机gps信息用于加快设备定位（仅限支持的设备）
    func getAppGpsInfo() -> IDOOtaGpsInfo?
}

@objc
public class IDOOtaGpsInfo: NSObject {
//    /// 晶振偏移
//    public var tcxoOffset: Int = 0
    
    /// 经度
    public var longitude: Float = 0.0
    
    /// 纬度
    public var latitude: Float = 0.0
    
    /// 海拔高度
    public var altitude: Float = 0.0
    
    
    public init(longitude: Float, latitude: Float, altitude: Float) {
//        self.tcxoOffset = tcxoOffset
        self.longitude = longitude
        self.latitude = latitude
        self.altitude = altitude
    }
}

/// EPO升级状态
@objc
public enum IDOEpoUpgradeStatus: Int {
    /// 空闲
    case idle = 0
    /// 准备更新
    case ready = 1
    /// 下载中
    case downing = 2
    /// 制作中
    case making = 3
    /// 发送中
    case sending = 4
    /// 安装中
    case installing = 5
    /// 成功
    case success = 6
    /// 失败
    case failure = 7
}
