//
//  IDOMusicOnOffParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Set Music On/Off Event
@objcMembers
public class IDOMusicOnOffParamModel: NSObject, IDOBaseModel {
    /// 1: On
    /// 0: Off                                            
    public var onOff: Int
    /// Show song information switch
    /// 1: On
    /// 0: Off
    /// Requires firmware support for menu:  `supportV2SetShowMusicInfoSwitch`
    public var showInfoStatus: Int
    
    enum CodingKeys: String, CodingKey {
        case onOff = "on_off"
        case showInfoStatus = "show_info_status"
    }
    
    public init(onOff: Int,showInfoStatus: Int = 0) {
        self.onOff = onOff
        self.showInfoStatus = showInfoStatus
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

