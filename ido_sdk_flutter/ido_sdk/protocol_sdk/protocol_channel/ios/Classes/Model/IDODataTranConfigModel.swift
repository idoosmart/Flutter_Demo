//
//  IDODataTranConfigModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Get data transfer configuration event number
@objcMembers
public class IDODataTranConfigModel: NSObject, IDOBaseModel {
    /// Error code
    /// 0: Normal
    /// Non-zero: Error
    public var errCode: Int
    /// Icon type corresponding to the activity type
    /// 0: Invalid
    /// 1: Small icon for activity
    /// 2: Large icon for activity
    /// 3: Animated icon for activity
    /// 4: Medium-sized icons for activity
    public var type: Int
    /// Event type
    /// 0: Invalid
    /// For example, 1: SMS, 2: Email, 3: WeChat, etc.
    public var evtType: Int
    /// Activity type
    /// 0: Invalid
    /// Activity mode type, 1: Walking, 2: Running, etc.
    public var sportType: Int
    /// Width required by the firmware icon (determined by type and evt_type/sport_type)
    public var iconWidth: Int
    /// Height required by the firmware icon (determined by type and evt_type/sport_type)
    public var iconHeight: Int
    /// Color format
    public var format: Int
    /// Compression block size
    public var blockSize: Int
    /// Number of big sports icons
    public var bigSportsNum: Int
    /// Number of message icons
    public var msgNum: Int
    /// Number of small sports and animation icons
    public var smallSportsAndAnimationNum: Int
    /// Number of medium-sized icons
    public var mediumNum: Int
    
    enum CodingKeys: String, CodingKey {
        case errCode = "err_code"
        case type = "type"
        case evtType = "evt_type"
        case sportType = "sport_type"
        case iconWidth = "icon_width"
        case iconHeight = "icon_height"
        case format = "format"
        case blockSize = "block_size"
        case bigSportsNum = "big_sports_num"
        case msgNum = "msg_num"
        case smallSportsAndAnimationNum = "small_sports_and_animation_num"
        case mediumNum = "medium_num"
    }
    
    public init(errCode: Int,type: Int,evtType: Int,sportType: Int,iconWidth: Int,iconHeight: Int,format: Int,blockSize: Int,bigSportsNum: Int,msgNum: Int,smallSportsAndAnimationNum: Int,mediumNum: Int) {
        self.errCode = errCode
        self.type = type
        self.evtType = evtType
        self.sportType = sportType
        self.iconWidth = iconWidth
        self.iconHeight = iconHeight
        self.format = format
        self.blockSize = blockSize
        self.bigSportsNum = bigSportsNum
        self.msgNum = msgNum
        self.smallSportsAndAnimationNum = smallSportsAndAnimationNum
        self.mediumNum = mediumNum
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

