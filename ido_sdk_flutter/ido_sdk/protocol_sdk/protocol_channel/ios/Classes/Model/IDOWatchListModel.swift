//
//  IDOWatchListModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/19.
//

import Foundation

// MARK: - IDOWatchListModel
@objcMembers
public class IDOWatchListModel: NSObject, IDOBaseModel {
    /// Total number of local watch faces
    public var localWatchNum: Int
    /// Total number of cloud watch faces
    public var cloudWatchNum: Int
    /// Total number of wallpaper watch faces
    public var wallpaperWatchNum: Int
    /// Number of cloud watch faces used
    public var userCloudWatchNum: Int
    /// Number of wallpaper watch faces used
    public var userWallpaperWatchNum: Int
    /// ID of the currently displayed watch face, maximum 30 bytes
    public var nowShowWatchName: String
    /// Framework version number, starting from 1
    public var watchFrameMainVersion: Int
    /// Maximum size of a single file, in kilobytes(reserve)
    public var fileMaxSize: Int
    private let listItemNumb: Int
    /// Total capacity of watch faces
    /// Uint:Byte
    /// Set to 0 if the firmware enables `setWatchCapacitySizeDisplay`
    public var watchCapacitySize: Int
    /// Used capacity of watch faces
    /// Uint:Byte
    /// Set to 0 if the firmware enables `setWatchCapacitySizeDisplay`
    public var userWatchCapacitySize: Int
    /// Maximum continuous space available for downloading watch faces
    /// Uint:Byte
    /// Set to 0 if the firmware enables `setWatchCapacitySizeDisplay`
    public var usableMaxDownloadSpaceSize: Int
    public var items: [IDOWatchItem]
    
    enum CodingKeys: String, CodingKey {
        case localWatchNum = "local_watch_num"
        case cloudWatchNum = "cloud_watch_num"
        case wallpaperWatchNum = "wallpaper_watch_num"
        case userCloudWatchNum = "user_cloud_watch_num"
        case userWallpaperWatchNum = "user_wallpaper_watch_num"
        case nowShowWatchName = "now_show_watch_name"
        case watchFrameMainVersion = "watch_frame_main_version"
        case fileMaxSize = "file_max_size"
        case listItemNumb = "list_item_numb"
        case watchCapacitySize = "watch_capacity_size"
        case userWatchCapacitySize = "user_watch_capacity_size"
        case usableMaxDownloadSpaceSize = "usable_max_download_space_size"
        case items = "item"
    }
    
    public init(localWatchNum: Int, cloudWatchNum: Int, wallpaperWatchNum: Int, userCloudWatchNum: Int, userWallpaperWatchNum: Int, nowShowWatchName: String, watchFrameMainVersion: Int, fileMaxSize: Int, watchCapacitySize: Int, userWatchCapacitySize: Int, usableMaxDownloadSpaceSize: Int, items: [IDOWatchItem]) {
        self.localWatchNum = localWatchNum
        self.cloudWatchNum = cloudWatchNum
        self.wallpaperWatchNum = wallpaperWatchNum
        self.userCloudWatchNum = userCloudWatchNum
        self.userWallpaperWatchNum = userWallpaperWatchNum
        self.nowShowWatchName = nowShowWatchName
        self.watchFrameMainVersion = watchFrameMainVersion
        self.fileMaxSize = fileMaxSize
        self.listItemNumb = items.count
        self.watchCapacitySize = watchCapacitySize
        self.userWatchCapacitySize = userWatchCapacitySize
        self.usableMaxDownloadSpaceSize = usableMaxDownloadSpaceSize
        self.items = items
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

// MARK: - IDOWatchItem
@objcMembers
public class IDOWatchItem: NSObject, Codable {
    /// Watch face type
    /// 1: Normal watch face
    /// 2: Wallpaper watch face
    /// 3: Cloud watch face
    public var type: Int
    /// Current version number of the watch face (applies to cloud watch faces)
    public var watchVersion: Int
    /// Watch face order number
    /// Start at 0
    public var sortNumber: Int
    /// Watch face name
    public var name: String
    /// Size of the watch face, in bytes
    /// Applies only if the firmware enables `v3SupportGetWatchSize`, otherwise the field is invalid
    public var size: Int
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case watchVersion = "watch_version"
        case sortNumber = "sort_number"
        case name = "name"
        case size = "size"
    }
    
    public init(type: Int, watchVersion: Int, sortNumber: Int, name: String, size: Int) {
        self.type = type
        self.watchVersion = watchVersion
        self.sortNumber = sortNumber
        self.name = name
        self.size = size
    }
}



// MARK: - IDOWatchListV2Model
@objcMembers
public class IDOWatchListV2Model: NSObject, IDOBaseModel {
    private let version: Int
    /// Number of remaining available files
    public var availableCount: Int
    /// Maximum size of a single file (in KB)
    public var fileMaxSize: Int
    public var items: [IDOWatchListV2Item]

    enum CodingKeys: String, CodingKey {
        case version = "version"
        case availableCount = "available_count"
        case fileMaxSize = "file_max_size"
        case items = "item"
    }

    public init(availableCount: Int, fileMaxSize: Int, items: [IDOWatchListV2Item]) {
        self.version = 0
        self.availableCount = availableCount
        self.fileMaxSize = fileMaxSize
        self.items = items
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

// MARK: - IDOWatchListV2Item
@objcMembers
public class IDOWatchListV2Item: NSObject, Codable {
    public var fileName: String

    enum CodingKeys: String, CodingKey {
        case fileName = "file_name"
    }

    public init(fileName: String) {
        self.fileName = fileName
    }
}
