//
//  MessageIconImpl.swift
//  protocol_channel
//
//  Created by hc on 2023/9/19.
//

import Foundation

private var _messageIcon: MessageIcon? {
    return SwiftProtocolChannelPlugin.shared.messageIcon
}

private var _delegate: MessageIconDelegateImpl {
    return MessageIconDelegateImpl.shared
}

class MessageIconImpl: IDOMessageIconInterface {
    
    var updating: Bool {
        return _delegate.updating
    }

    var iconDirPath: String {
        return _delegate.dirPath
    }
    
    func iOSConfig(countryCode: String, baseUrlPath: String, appKey: String, language: Int) {
        _runOnMainThread {
            _messageIcon?.iOSConfig(countryCode: countryCode, baseUrlPath: baseUrlPath, appKey: appKey, language: language.int64, completion: { })
        }
    }
    
    func config(countryCode: String?, baseUrlPath: String?, appKey: String?, language: NSNumber?) {
        _runOnMainThread {
            _messageIcon?.iOSConfig(countryCode: countryCode, baseUrlPath: baseUrlPath, appKey: appKey, language: language?.int64Value, completion: { })
        }
    }

    func getDefaultAppInfo(completion: @escaping ([IDOAppIconItemModel]) -> Void) {
        _runOnMainThread {
            _messageIcon?.getDefaultAppInfo(completion: { items in
                completion(items.map { $0.toIDOAppIconItemModel() })
            })
        }
    }
    
    func getCacheAppInfo(completion: @escaping (IDOAppIconInfoModel) -> Void) {
        _runOnMainThread {
            _messageIcon?.getCacheAppInfoModel(completion: { item in
                completion(item.toIDOAppIconInfoModel())
            })
        }
    }

    func resetIconInfoData(macAddress: String, deleteIcon: Bool, completion: @escaping (Bool) -> Void) {
        _runOnMainThread {
            _messageIcon?.resetIconInfoData(macAddress: macAddress, deleteIcon: deleteIcon, completion: completion)
        }
    }

    func firstGetAppInfo(force: Bool, completion: @escaping ([IDOAppIconItemModel]) -> Void) {
        _runOnMainThread {
            _messageIcon?.firstGetAllAppInfo(force: force, completion: { list in
                let rsList = list.map { $0.toIDOAppIconItemModel() }
                completion(rsList)
            })
        }
    }
    
    func setDefaultAppInfoList(list: [IDOAppIconItemModel], completion: @escaping (Bool) -> Void) {
        let rsList = list.map { $0.toAppIconItemModel() }
        _runOnMainThread {
            _messageIcon?.setDefaultAppInfoList(models: rsList, completion: {
                completion(true)
            })
        }
    }
}

@objcMembers
public class IDOAppIconItemModel: NSObject {
    /// 事件类型
    public let evtType: Int64
    /// 应用包名
    public let packName: String
    /// 应用名称
    public let appName: String
    /// icon 沙盒小图标地址 (设备使用)
    public let iconLocalPath: String
    /// 每个包名给一个id 由0开始
    public let itemId: NSNumber?
    /// 消息收到次数
    public let msgCount: NSNumber?
    /// icon 云端地址
    public let iconCloudPath: String?
    /// 消息图标更新状态
    /// 0：不需要更新 1：需要更新icon ，2：需要更新app名，3：icon和app都需要更新
    public let state: NSNumber?
    /// icon 沙盒大图标地址 (app 列表上展示)
    public let iconLocalPathBig: String?
    /// 国家编码
    public let countryCode: String?
    /// 应用版本号
    public let appVersion: String?
    /// 是否已经下载APP信息
    public let isDownloadAppInfo: NSNumber?
    /// 是否已经更新应用名称
    public let isUpdateAppName: NSNumber?
    /// 是否已经更新应用图标
    public let isUpdateAppIcon: NSNumber?
    /// 是否为默认应用
    public let isDefault: NSNumber?

    public init(evtType: Int64, packName: String, appName: String, iconLocalPath: String, itemId: NSNumber? = nil, msgCount: NSNumber? = nil, iconCloudPath: String? = nil, state: NSNumber? = nil, iconLocalPathBig: String? = nil, countryCode: String? = nil, appVersion: String? = nil, isDownloadAppInfo: NSNumber? = nil, isUpdateAppName: NSNumber? = nil, isUpdateAppIcon: NSNumber? = nil, isDefault: NSNumber? = nil) {
        self.evtType = evtType
        self.packName = packName
        self.appName = appName
        self.iconLocalPath = iconLocalPath
        self.itemId = itemId
        self.msgCount = msgCount
        self.iconCloudPath = iconCloudPath
        self.state = state
        self.iconLocalPathBig = iconLocalPathBig
        self.countryCode = countryCode
        self.appVersion = appVersion
        self.isDownloadAppInfo = isDownloadAppInfo
        self.isUpdateAppName = isUpdateAppName
        self.isUpdateAppIcon = isUpdateAppIcon
        self.isDefault = isDefault
    }
}

/// Generated class from Pigeon that represents data sent in messages.
@objcMembers
public class IDOAppIconInfoModel: NSObject {
    /// 版本号
    public var version: NSNumber?
    /// icon宽度
    public var iconWidth: NSNumber?
    /// icon高度
    public var iconHeight: NSNumber?
    /// 颜色格式
    public var colorFormat: NSNumber?
    /// 压缩块大小
    public var blockSize: NSNumber?
    /// 总个数
    public var totalNum: NSNumber?
    /// 包名详情集合
    public var items: [IDOAppIconItemModel]?

    public init(version: NSNumber? = nil, iconWidth: NSNumber? = nil, iconHeight: NSNumber? = nil, colorFormat: NSNumber? = nil, blockSize: NSNumber? = nil, totalNum: NSNumber? = nil, items: [IDOAppIconItemModel]? = nil) {
        self.version = version
        self.iconWidth = iconWidth
        self.iconHeight = iconHeight
        self.colorFormat = colorFormat
        self.blockSize = blockSize
        self.totalNum = totalNum
        self.items = items
    }
}

// MARK: - Private

private extension AppIconItemModel {
    func toIDOAppIconItemModel() -> IDOAppIconItemModel {
        return IDOAppIconItemModel(
            evtType: evtType ?? 0,
            packName: packName ?? "",
            appName: appName ?? "",
            iconLocalPath: iconLocalPath ?? "",
            itemId: itemId?.number,
            msgCount: msgCount?.number,
            iconCloudPath: iconCloudPath,
            state: state?.number,
            iconLocalPathBig: iconLocalPathBig,
            countryCode: countryCode,
            appVersion: appVersion,
            isDownloadAppInfo: isDownloadAppInfo?.number,
            isUpdateAppName: isUpdateAppName?.number,
            isUpdateAppIcon: isUpdateAppIcon?.number,
            isDefault: isDefault?.number)
    }
}

private extension IDOAppIconItemModel {
    func toAppIconItemModel() -> AppIconItemModel {
        return AppIconItemModel(
            evtType: evtType,
            packName: packName,
            appName: appName,
            iconLocalPath: iconLocalPath,
            itemId: itemId?.int64Value,
            msgCount: msgCount?.int64Value,
            iconCloudPath: iconCloudPath,
            state: state?.int64Value,
            iconLocalPathBig: iconLocalPathBig,
            countryCode: countryCode,
            appVersion: appVersion,
            isDownloadAppInfo: isDownloadAppInfo?.boolValue,
            isUpdateAppName: isUpdateAppName?.boolValue,
            isUpdateAppIcon: isUpdateAppIcon?.boolValue,
            isDefault: isDefault?.boolValue)
    }
}

private extension AppIconInfoModel {
    func toIDOAppIconInfoModel() -> IDOAppIconInfoModel {
        var list = [IDOAppIconItemModel]()
        items?.forEach {
            if $0 != nil {
                list.append($0!.toIDOAppIconItemModel())
            }
        }
        return IDOAppIconInfoModel(
            version: version?.number,
            iconWidth: iconWidth?.number,
            iconHeight: iconHeight?.number,
            colorFormat: colorFormat?.number,
            blockSize: blockSize?.number,
            totalNum: totalNum?.number,
            items: list)
    }
}
