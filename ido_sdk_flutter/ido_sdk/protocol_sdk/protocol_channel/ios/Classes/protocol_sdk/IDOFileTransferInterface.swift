//
//  IDOFileTransferInterface.swift
//  alexa_channel
//
//  Created by hc on 2023/11/2.
//

import Foundation

/// 文件传输
@objc
public protocol IDOFileTransferInterface {
    /// 是否在执行传输
    var isTransmitting: Bool { get }

    /// 当前传输中的文件类型
    var transFileType: IDOTransTypeClass? { get }

    /// 执行文件传输
    /// - Parameters:
    ///   - fileItems: 待传文件
    ///   - cancelPrevTranTask: 是否取消执行中的传输任务（如果有）
    ///   - transProgress: 文件传输进度
    ///   - transStatus: 文件传输状态
    ///   - completion: 传输结果，形如：[true, true, ...] 和传入的 fileItems 一一对应
    @discardableResult
    func transferFiles(fileItems: [IDOTransBaseModel],
                       cancelPrevTranTask: Bool,
                       transProgress: @escaping BlockFileTransProgress,
                       transStatus: @escaping BlockFileTransStatus,
                       completion: @escaping ([Bool]) -> Void) -> IDOCancellable?

    /// 获取压缩前.iwf文件大小
    /// - Parameters:
    ///   - filePath: 表盘文件绝对路径
    ///   - type: 表盘类型 1 云表盘 ，2 壁纸表盘
    ///   - completion: 文件大小（单位 字节）
    func iwfFileSize(filePath: String, type: Int64, completion: @escaping (Int64) -> Void)
    
    /// 注册 设备文件->app传输 (全局注册一次）
    ///
    /// transTask 接收到的文件任务
    func registerDeviceTranFileToApp(transTask: @escaping BlockDeviceFileToAppTask)

    /// 取消注册 设备文件 -> app传输
    func unregisterDeviceTranFileToApp()
}


@objcMembers public class IDOTransTypeClass: NSObject {
    let transType: IDOTransType
    
    public init(type: IDOTransType) {
        self.transType = type
    }
    
}
