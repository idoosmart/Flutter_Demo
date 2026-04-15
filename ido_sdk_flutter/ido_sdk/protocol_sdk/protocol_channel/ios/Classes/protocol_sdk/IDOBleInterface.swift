//
//  IDOBleInterface.swift
//  alexa_channel
//
//  Created by hc on 2023/11/2.
//

import Foundation

/// 蓝牙接口
@objc
public protocol IDOBleInterface {
    /// 添加蓝牙代理
    func addBleDelegate(api: IDOBleDelegate?)

    /// 添加DFU升级 (nordic)
    func addDfuDelegate(api: IDODfuDelegate?)
    
    /// 开始搜索
    /// macAddress（Android）:根据Mac地址搜索
    /// 返回指定搜索的设备，如未指定返回null
    func startScan(macAddress: String?, completion: @escaping ([IDODeviceModel]?) -> Void)

    /// 搜索筛选条件
    /// ```
    /// deviceName: 只搜索deviceName的设备
    /// deviceID：只搜索deviceID的设备
    /// macAddress：只搜索macAddress的设备
    /// uuid：只搜索uuid的设备
    /// ```
    func scanFilter(deviceName: [String]?, deviceID: [Int]?, macAddress: [String]?, uuid: [String]?)

    /// 停止搜索
    func stopScan()

    /// 连接
    /// device: Mac地址必传，iOS要带上uuid，最好使用搜索返回的对象
    func connect(device: IDODeviceModel?)

    /// 使用这个重连设备
    func autoConnect(device: IDODeviceModel?)

    /// 取消连接
    func cancelConnect(macAddress: String?, completion: @escaping (Bool) -> Void)

    /// 获取蓝牙状态
    func getBluetoothState(completion: @escaping (IDOBluetoothStateModel) -> Void)

    /// 获取设备连接状态
    func getDeviceState(device: IDODeviceModel?, completion: @escaping (IDODeviceStateModel) -> Void)

    
    /// 发送数据
    /// - Parameters:
    ///   - data: 数据
    ///   - device: 发送数据的设备
    ///   - type: 0 BLE数据, 1 SPP数据
    ///   - platform: 0 爱都, 1 恒玄, 2 VC
    ///   - completion: 结果 IDOWriteStateModel
    func writeData(data: Data, device: IDODeviceModel, type: Int, platform: Int, completion: @escaping (IDOWriteStateModel) -> Void)
    
    /// 发起dfu升级
    func startNordicDFU(config: IDODfuConfig)
    
    /// 导出ble日志，返回压缩后日志zip文件绝对路径
    func exportLog(completion: @escaping (String?) -> Void)
}



// MARK: - 代理
@objc
public protocol IDODfuDelegate: NSObjectProtocol {
    /// 监听dfu完成状态
    func dfuComplete()
    
    /// 监听dfu过程的错误
    func dfuError(error: String)
    
    /// 监听升级进度
    /// 0-100
    func dfuProgress(progress: Int)
}

@objc
public protocol IDOBleDelegate: NSObjectProtocol {
    /// 搜索设备结果
    func scanResult(list: [IDODeviceModel]?)
    
    /// 蓝牙状态
    func bluetoothState(state: IDOBluetoothStateModel)
    
    /// 设备状态状态
    func deviceState(state: IDODeviceStateModel)
    
    /// 接收到的蓝牙数据
    func receiveData(data: IDOReceiveData)
}
