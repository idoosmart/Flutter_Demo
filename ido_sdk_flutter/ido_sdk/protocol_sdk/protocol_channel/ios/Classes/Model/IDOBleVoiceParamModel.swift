//
//  IDOBleVoiceParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Set phone volume for device event number
@objcMembers
public class IDOBleVoiceParamModel: NSObject, IDOBaseModel {
    /// Total volume
    public var totalVolume: Int
    /// Current volume
    public var currentVolume: Int

    enum CodingKeys: String, CodingKey {
        case totalVolume = "total_voice"
        case currentVolume = "now_voice"
    }

    public init(totalVolume: Int, currentVolume: Int) {
        self.totalVolume = totalVolume
        self.currentVolume = currentVolume
    }

    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
