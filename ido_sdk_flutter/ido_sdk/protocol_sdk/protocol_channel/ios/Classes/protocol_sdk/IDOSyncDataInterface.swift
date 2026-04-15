//
//  IDOSyncDataInterface.swift
//  alexa_channel
//
//  Created by hc on 2023/11/2.
//

import Foundation

/// 数据同步
@objc
public protocol IDOSyncDataInterface {
    
    /// 同步状态
    var syncStatus: IDOSyncStatus { get }
    
    /// 开始同步所有数据
    func startSync(
        funcProgress: @escaping BlockDataSyncProgress,
        funcData: @escaping BlockDataSyncData,
        funcCompleted: @escaping BlockDataSyncCompleted)
    
    /// 同步指定数据（无进度且不支持的类型不会回调）
    func startSync(
        types: [IDOSyncDataTypeClass],
        funcData: @escaping BlockDataSyncData,
        funcCompleted: @escaping BlockDataSyncCompleted)
    
    /// 获取支持的同步数据类型
    func getSupportSyncDataTypeList(completion: @escaping ([IDOSyncDataTypeClass]) -> Void)
    
    /// 停止同步所有数据
    func stopSync()
    
}

@objcMembers public class IDOSyncDataTypeClass: NSObject {
    public let syncDataType: IDOSyncDataType
    
    public init(type: IDOSyncDataType) {
        self.syncDataType = type
    }
}
