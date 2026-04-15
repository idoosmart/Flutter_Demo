//
//  IDOUpdateStatusModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Get device update status event number
@objcMembers
public class IDOUpdateStatusModel: NSObject, IDOBaseModel {
    /// Firmware version number
    public var devVesion: Int
    /// 0 for normal state
    /// 1 for upgrade state
    public var state: Int

    enum CodingKeys: String, CodingKey {
        case devVesion = "dev_vesion"
        case state = "state"
    }

    public init(devVesion: Int, state: Int) {
        self.devVesion = devVesion
        self.state = state
    }

    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
