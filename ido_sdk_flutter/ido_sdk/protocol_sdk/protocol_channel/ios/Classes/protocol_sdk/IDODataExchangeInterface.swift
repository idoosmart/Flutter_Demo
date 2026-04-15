//
//  IDODataExchangeInterface.swift
//  alexa_channel
//
//  Created by hc on 2023/11/2.
//

import Foundation

// 由于需要适配oc，以下swift无法直接适配，暂时屏蔽
///// 数据交换
//protocol IDODataExchangeInterface {
//    /// 获取是否支持v3运动数据交换
//    var supportV3ActivityExchange: Bool { get }
//    
//    /// 数据交换状态
//    var status: IDOExchangeStatus { get }
//    
//    /// 设置监听代理
//    func addExchange(delegate: IDOExchangeDataDelegate?)
//    
//    /// app执行数据交换
//    func appExec(_ type: IDOAppExecType)
//    
//    /// ble发起运动 ble执行数据交换 app回复
//    func appReplyExec(_ type: IDOAppReplyType)
//    
//    /// 获取多运动数据最后一次数据
//    func getLastActivityData()
//    
//    /// 获取多运动一分钟心率数据
//    func getActivityHrData()
//    
//    /// 获取多运动一段时间的gps数据
//    func getActivityGpsData()
//}


/// 数据交换
@objc
public protocol IDODataExchangeOCInterface {
    /// 获取是否支持v3运动数据交换
    var supportV3ActivityExchange: Bool { get }
    
    /// 数据交换状态
    var status: IDOExchangeStatus { get }
    
    /// 设置监听代理
    func addExchange(delegate: IDOExchangeDataOCDelegate?)

    /// app执行数据交换
    /// - Parameter model:
    /// ```
    /// app 开始发起运动 IDOAppStartExchangeModel
    /// app 发起运动结束 IDOAppEndExchangeModel
    /// app 交换运动数据 IDOAppIngExchangeModel
    /// app 交换运动数据暂停 IDOAppPauseExchangeModel
    /// app 交换运动数据恢复 IDOAppRestoreExchangeModel
    /// app v3交换运动数据 IDOAppIngV3ExchangeModel
    /// app 操作计划运动 IDOAppOperatePlanExchangeModel
    /// ```
    func appExec(model: NSObject)
    
    /// ble发起运动 ble执行数据交换 app回复
    /// ```
    /// ble设备发送交换运动数据开始 app回复 IDOBleStartReplyExchangeModel
    /// ble设备交换运动数据过程中 app回复 IDOBleIngReplyExchangeModel
    /// ble设备发送交换运动数据结束 app回复 IDOBleEndReplyExchangeModel
    /// ble设备发送交换运动数据暂停 app回复 IDOBlePauseReplyExchangeModel
    /// ble设备发送交换运动数据恢复 app回复 IDOBleRestoreReplyExchangeModel
    /// ble设备操作运动计划 app回复 IDOBleOperatePlanReplyExchangeModel
    ///
    /// app发起运动 ble执行数据交换 app回复:
    ///
    /// ble设备发送交换运动数据暂停 app回复 IDOAppBlePauseReplyExchangeModel
    /// ble设备发送交换运动数据恢复 app回复 IDOAppBleRestoreReplyExchangeModel
    /// ble设备发送交换运动数据结束 app回复 IDOAppBleEndReplyExchangeModel
    /// ```
    func appReplyExec(model: NSObject)
    
    /// 获取多运动数据最后一次数据
    func getLastActivityData()
    
    /// 获取多运动一分钟心率数据
    func getActivityHrData()
    
    /// 获取多运动一段时间的gps数据
    func getActivityGpsData()
}
