import Foundation

@objc public enum OTALogLevel:NSInteger {
    case info = 0 // 信息
    case warn = 1 // 警告
    case debug = 2 // 调试信息
    case error = 3 // 错误
}

@objc public protocol SFOTALogManagerDelegate: NSObjectProtocol {
    
    /// OTA SDK 日志委托。可以将这些日志上报到你的异常管理平台
    /// - Parameters:
    ///   - manager:SFOTALogManager
    ///   - log: SDK 产生的日志文本
    ///   - level: 日志等级
    func otaLogManager(manager:SFOTALogManager, onLog log:SFOTALogModel!,logLevel level:OTALogLevel)
}

public class SFOTALogManager: NSObject {
    @objc public static let share = SFOTALogManager.init()
    private let coreLog = QBleLogManager.share
    @objc public weak var delegate:SFOTALogManagerDelegate?
    
    @objc public var logEnable:Bool = true {
        didSet {
            coreLog.openLog = logEnable
        }
    }
        
    private override init() {
        super.init()
        coreLog.openLog = logEnable
    }
}
