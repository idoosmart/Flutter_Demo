//
//  IDOWatchDialIdModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Get watch ID event number
@objcMembers
public class IDOWatchDialIdModel: NSObject, IDOBaseModel {
    /// Watch ID
    public var watchId: Int

    enum CodingKeys: String, CodingKey {
        case watchId = "watch_id"
    }

    public init(watchId: Int) {
        self.watchId = watchId
    }

    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
