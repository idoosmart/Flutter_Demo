//
//  IDOAppletControlModel.swift
//  protocol_channel
//
//  Created by hc on 2024/7/8.
//

import Foundation

// MARK: - IDOAppletControlModel
@objcMembers public class IDOAppletControlModel: NSObject, IDOBaseModel {
    /// 0:无效 1:启动小程序 2:删除小程序 3:获取已安装的小程序列表
    public var operate: Int
    /// 小程序名称 operate=0/operate=3无效,获取操作不需要下发名称，最大29个字节
    public var appName: String?
    private let version: Int = 1

    enum CodingKeys: String, CodingKey {
        case appName = "mini_program_name"
        case operate = "operate"
        case version = "verison"
    }

    public init(operate: Int, appName: String? = nil) {
        self.operate = operate
        self.appName = appName
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}


// MARK: - IDOAppletInfroModel
@objcMembers public class IDOAppletInfoModel: NSObject, IDOBaseModel {
    /// 0:成功 非0失败
    public var errorCode: Int
    /// 小程序列表 operate=3有效
    public var infoItem: [IDOAppletInfoItem]?
    /// 小程序个数 最多50个，operate=3有效
    public var appletNum: Int?
    /// 0:无效 1:启动小程序 2:删除小程序 3:获取已安装的小程序列表
    public var operate: Int
    /// 剩余空间 单位Byte
    public var residualSpace: Int
    /// 总空间 单位Byte
    public var totalSpace: Int
    private let version: Int = 1

    public enum CodingKeys: String, CodingKey {
        case errorCode = "error_code"
        case infoItem = "info_item"
        case appletNum = "mini_program_num"
        case operate = "operate"
        case residualSpace = "residual_space"
        case totalSpace = "total_space"
        case version = "version"
    }

    public init(errorCode: Int, 
                infoItem: [IDOAppletInfoItem],
                miniProgramNum: Int,
                operate: Int, 
                residualSpace: Int,
                totalSpace: Int) {
        self.errorCode = errorCode
        self.infoItem = infoItem
        self.appletNum = miniProgramNum
        self.operate = operate
        self.residualSpace = residualSpace
        self.totalSpace = totalSpace
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

// MARK: - IDOAppletInfoItem
@objcMembers public class IDOAppletInfoItem: NSObject, IDOBaseModel {
    /// 小程序名称 最大值29个字节
    public var appName: String
    /// 小程序大小 单位Byte
    public var size: Int
    /// 小程序版本号
    public var version: String

    public enum CodingKeys: String, CodingKey {
        case appName = "mini_program_name"
        case size = "mini_program_size"
        case version = "mini_program_version"
    }

    public init(appName: String, size: Int, version: String) {
        self.appName = appName
        self.size = size
        self.version = version
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

