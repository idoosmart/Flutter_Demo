import Foundation

@objc public enum SFOTAProgressStage:Int {
    case nand_res
    case nand_image
    case nor
}

protocol SFOTAModuleDelegate: NSObjectProtocol {
    
    
    ///  模块向Manager发起断连的请求
    /// - Parameter module: 模块
    func otaModuleDisconnectRequest(module:SFOTAModuleBase)
    
    ///  模块向Manager发起重连请求
    /// - Parameter module: 模块
    func otaModuleReconnectRequest(module:SFOTAModuleBase)
    
    
    /// 模块向Manager发起数据发送的请求
    /// - Parameters:
    ///   - module: 模块
    ///   - data: 待发数据（该数据在Manager再进行组包）
    func otaModuleSendDataRequest(module:SFOTAModuleBase, data:Data)
    
    
    /// 模块向Manager回调的进度信息
    /// - Parameters:
    ///   - module: 模块
    ///   - stage: 当前所处的发送阶段
    ///   - stageTotalBytes: 本阶段总字节数
    ///   - stageCompletedBytes: 本阶段已完成字节数
    func otaModuleProgress(module:SFOTAModuleBase, stage:SFOTAProgressStage, stageTotalBytes:Int, stageCompletedBytes:Int)
    
    
    
    /// 升级完成回调
    /// - Parameters:
    ///   - module: 模块
    ///   - error: nil-表示成功；否则表示失败
    func otaModuleCompletion(module:SFOTAModuleBase, error:SFOTAError?)
    
    
    /// Module内部通过该代理来获取蓝牙是否已经握手的状态
    /// - Returns:握手状态
    func otaModuleShakedHands() -> Bool
}
