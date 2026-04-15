//
//  IDOMusicOperateModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Operation for songs or folders event
@objcMembers
public class IDOMusicOperateModel: NSObject, IDOBaseModel {
    /// Operation type:
    /// 0: Invalid operation
    /// 1: Delete music
    /// 2: Add music
    /// 3: Delete folder
    /// 4: Add folder
    /// 5: Modify playlist
    /// 6: Import playlist
    /// 7: Delete music in playlist
    public var operateType: Int
    /// Firmware SDK card information
    /// Total space
    public var version: Int
    /// 0: Successful; non-zero: Failed
    public var errCode: Int
    /// Music id returned when adding music successfully
    public var musicId: Int?
    
    enum CodingKeys: String, CodingKey {
        case operateType = "operate_type"
        case version = "version"
        case errCode = "err_code"
        case musicId = "music_id"
    }
    
    public init(operateType: Int,version: Int,errCode: Int,musicId: Int?) {
        self.operateType = operateType
        self.version = version
        self.errCode = errCode
        self.musicId = musicId
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

