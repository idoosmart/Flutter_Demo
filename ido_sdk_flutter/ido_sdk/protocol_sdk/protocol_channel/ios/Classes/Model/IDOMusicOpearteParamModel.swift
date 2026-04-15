//
//  IDOMusicOpearteParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/18.
//

import Foundation

// MARK: - IDOMusicOpearteParamModel
@objcMembers
public class IDOMusicOpearteParamModel: NSObject, IDOBaseModel {
    private let version: Int
    /// Music operation
    /// 0: Invalid operation
    /// 1: Delete music
    /// 2: Add music
    public var musicOperate: Int
    /// Folder (playlist) operation
    /// 0: Invalid operation
    /// 1: Delete folder
    /// 2: Add folder
    /// 3: Modify playlist
    /// 4: Import playlist
    /// 5: Delete music
    public var folderOperate: Int
    /// Folder (playlist) details
    public var folderItem: IDOMusicFolderItem?
    /// Music details
    public var musicItem: IDOMusicItem
    
    enum CodingKeys: String, CodingKey {
        case version
        case musicOperate = "music_operate"
        case folderOperate = "folder_operate"
        case folderItem = "folder_items"
        case musicItem = "music_items"
    }
    
    public init(musicOperate: Int, folderOperate: Int, folderItem: IDOMusicFolderItem? = nil, musicItem: IDOMusicItem) {
        self.version = 0
        self.musicOperate = musicOperate
        self.folderOperate = folderOperate
        self.folderItem = folderItem
        self.musicItem = musicItem
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}


// MARK: - IDOMusicInfoModel
@objcMembers
public class IDOMusicInfoModel: NSObject, IDOBaseModel {
    /// Firmware SDK card information<br />Total space<br />Uint:Byte
    public var allMemory: Int
    public var folderItems: [IDOMusicFolderItem]?
    private let folderNum: Int
    public var musicItems: [IDOMusicItem]?
    private let musicNum: Int
    /// Firmware SDK card information<br />Current used space in bytes<br />Uint:Byte
    public var usedMemory: Int
    /// Firmware SDK card information<br />Available space<br />Uint:Byte
    public var usefulMemory: Int
    private let version: Int

    enum CodingKeys: String, CodingKey {
        case allMemory = "all_memory"
        case folderItems = "folder_items"
        case folderNum = "folder_num"
        case musicItems = "music_items"
        case musicNum = "music_num"
        case usedMemory = "used_memory"
        case usefulMemory = "useful_memory"
        case version = "version"
    }

    public init(allMemory: Int, folderItems: [IDOMusicFolderItem]?, musicItems: [IDOMusicItem]?, usedMemory: Int, usefulMemory: Int) {
        self.allMemory = allMemory
        self.folderItems = folderItems
        self.folderNum = folderItems?.count ?? 0
        self.musicItems = musicItems
        self.musicNum = musicItems?.count ?? 0
        self.usedMemory = usedMemory
        self.usefulMemory = usefulMemory
        self.version = 0
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}


// MARK: - IDOMusicOpearteFolderItem
@objcMembers
public class IDOMusicFolderItem: NSObject, Codable {
    /// Playlist (folder) id, ranging from 1 to 10
    public var folderID: Int
    /// Number of songs in the playlist, maximum of 100
    public var musicNum: Int
    /// Playlist (folder) name, maximum of 19 bytes
    public var folderName: String
    /// Corresponding song ids in the playlist, arranged in order of addition
    public var musicIndex: [Int]
    
    enum CodingKeys: String, CodingKey {
        case folderID = "folder_id"
        case musicNum = "music_num"
        case folderName = "folder_name"
        case musicIndex = "music_index"
    }
    
    public init(folderID: Int, musicNum: Int, folderName: String, musicIndex: [Int]) {
        self.folderID = folderID
        self.musicNum = musicNum
        self.folderName = folderName
        self.musicIndex = musicIndex
    }
}

// MARK: - IDOMusicOpearteMusicItem
@objcMembers
public class IDOMusicItem: NSObject, Codable {
    /// Music id, starting from 1
    public var musicID: Int
    /// Space occupied by the music
    public var musicMemory: Int
    /// Music name, maximum of 44 bytes
    public var musicName: String
    /// Singer name, maximum of 29 bytes
    public var singerName: String
    
    enum CodingKeys: String, CodingKey {
        case musicID = "music_id"
        case musicMemory = "music_memory"
        case musicName = "music_name"
        case singerName = "singer_name"
    }
    
    public init(musicID: Int, musicMemory: Int, musicName: String, singerName: String) {
        self.musicID = musicID
        self.musicMemory = musicMemory
        self.musicName = musicName
        self.singerName = singerName
    }
}
