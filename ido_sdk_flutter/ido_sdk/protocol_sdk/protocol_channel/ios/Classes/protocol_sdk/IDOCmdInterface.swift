//
//  IDOCmdInterface.swift
//  alexa_channel
//
//  Created by hc on 2023/11/2.
//

import Foundation

// 指令、绑定、解绑

public typealias IDOCmdResponse<U> = (Result<U?, CmdError>) -> ()

public protocol IDOCmdProtocol {
    associatedtype DataType
    
    @discardableResult func send(completion: @escaping IDOCmdResponse<DataType>) -> IDOCancellable
}

// priority 优先级 0: low， 1: normal， 2: high，3： veryHigh. default 1 (不要修改值）
/// 指令优先级
@objc
public enum IDOCmdPriority: Int {
    /// 很高
    case veryHigh = 3
    /// 高
    case high = 2
    /// 正常
    case normal = 1
    /// 低
    case low = 0
}

/// 指令
@objc
public protocol IDOCmdInterface {
    
//    /// 基础指令 先make再send
//    func make<T>(_ anyCmd: AnyCmd<T>) -> AnyCmd<T>

    /// 是否在绑定中 (绑定中，切换设备将受到限制）
    var isBinding: Bool { get }

    /// 设备绑定
    func bind(osVersion: Int,
              onDeviceInfo: ((IDODeviceInterface) -> Void)?,
              onFuncTable: ((IDOFuncTableInterface) -> Void)?,
              completion: @escaping (IDOBindStatus) -> Void)

    /// 取消当前绑定请求（仅限需要app确认绑定结果的设备使用）
    func cancelBind()
    
    /// APP下发绑定结果（仅限需要app确认绑定结果的设备使用）
    /// 唯一使用场景：bind(...)方法返回IDOBindStatus.needConfirmByApp时调用
    func appMarkBindResult(success: Bool)
      

    /// 发起解绑
    ///
    /// macAddress: 设备Mac地址
    /// isForceRemove：强制删除设备，设备无响应也删除
    func unbind(macAddress: String, isForceRemove: Bool, completion: @escaping (Bool) -> Void)

    /// 发送授权配对码
    ///
    /// code 配对码
    /// osVersion: 系统版本 (取主版本号)
    func setAuthCode(code: String, osVersion: Int, completion: @escaping (Bool) -> Void)

    // ------------------------------ 来电提醒 、消息提醒 ------------------------------

    /// v2发送来电提醒以及来电电话号码和来电联系人(部分设备实现)
    /// - Parameters:
    ///   - contactText: 联系人名称
    ///   - phoneNumber: 号码
    /// - Returns: 是否成功
    func setV2CallEvt(contactText: String, phoneNumber: String, completion: @escaping (Bool) -> Void)

    /// v2发送信息提醒以及信息内容(部分设备实现)
    /// - Parameters:
    ///   - type: 信息类型
    ///   - contactText: 通知内容
    ///   - phoneNumber: 号码
    ///   - dataText: 消息内容
    /// - Returns: 是否成功
    func setV2NoticeEvt(type: NoticeMessageType, contactText: String, phoneNumber: String, dataText: String, completion: @escaping (Bool) -> Void)

    /// v2发送来电提醒状态为来电已接, 告诉设备停止提醒用户(部分设备实现)
    /// - Returns: 是否成功
    func stopV2CallEvt(completion: @escaping (Bool) -> Void)

    /// v2发送来电提醒状态为来电已拒, 告诉设备停止提醒用户(部分设备实现)
    /// - Returns: 是否成功
    func missedV2MissedCallEvt(completion: @escaping (Bool) -> Void)
    
    
    // ------------------------------ 算法数据采集 ------------------------------
    
    /// 监听算法原始数据采集（全局监听一次）
    func listenReceiveAlgorithmRawData(rawDataReply: @escaping (IDORawDataSensorInfoReply) -> Void) -> Void;
}
