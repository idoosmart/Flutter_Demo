//
//  Enum.swift
//  flutter_bluetooth
//
//  Created by lux on 2022/9/6.
//

import UIKit

//通道方法
enum MethodChannel: String {
//    获取版本
    case getPlatformVersion
//    开始搜索
    case startScan
//    停止搜索
    case stopScan
//    连接
    case connect
//    取消连接
    case cancelConnect
//    上报设备状态
    case deviceState
//    发送数据
    case sendData
//    发送数据状态
    case sendState
//    收到数据
    case receiveData
//    获取蓝牙状态
    case state
//    获取设备状态
    case getDeviceState
//    上传ServicesUUID判断是否OTA
    case isOtaWithServices
//    Mac地址上报到keychain存储
    case requestMacAddress
//    写日志
    case writeLog
    
    case startNordicDFU
    
    //DFU进度
    case dfuProgress
    
    /// 获取Document目录路径
    case getDocumentPath
    
    /// 关闭通知服务
    case setCloseNotify
    
    /// iPhone11及以下设备
    case isIphone11OrLower
}


//连接错误
enum ConnectError: Int {
//    无状态
    case none
//    UUID或Mac地址异常
    case abnormalUUIDMacAddress
//    蓝牙关闭
    case bluetoothOff
//    主动断开连接
    case Conectcancel
//    连接失败
    case fail
//    连接超时
    case timeOut
//    发现服务失败
    case ServiceFial
//    发现特征失败
    case CharacteristicsFial
//    配对异常
    case pairFail

}
