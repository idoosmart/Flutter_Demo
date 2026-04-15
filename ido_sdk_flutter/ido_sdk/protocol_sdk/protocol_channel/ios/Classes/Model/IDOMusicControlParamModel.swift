//
//  IDOMusicControlParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/17.
//

import Foundation

@objcMembers
public class IDOMusicControlParamModel: NSObject, IDOBaseModel {
    /// Status: 0: Invalid 1: Play 2: Pause 3: Stop
    public var status: Int
    /// Current play time Unit:second
    public var curTimeSecond: Int
    /// Total play time Unit:second
    public var totalTimeSecond: Int
    /// Music name (maximum 63 bytes)
    public var musicName: String
    /// Singer name (maximum 63 bytes)
    /// This value is not applicable if v3MusicControl02AddSingerName is not enabled on the firmware
    public var singerName: String

    enum CodingKeys: String, CodingKey {
        case status
        case curTimeSecond = "cur_time_second"
        case totalTimeSecond = "total_time_second"
        case musicName = "music_name"
        case singerName = "singer_name"
    }

    public init(status: Int, curTimeSecond: Int, totalTimeSecond: Int, musicName: String, singerName: String) {
        self.status = status
        self.curTimeSecond = curTimeSecond
        self.totalTimeSecond = totalTimeSecond
        self.musicName = musicName
        self.singerName = singerName
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
