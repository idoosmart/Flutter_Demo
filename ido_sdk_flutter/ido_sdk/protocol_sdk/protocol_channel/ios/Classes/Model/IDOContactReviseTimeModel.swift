//
//  IDOContactReviseTimeModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Get firmware local contact file modification time event number
@objcMembers
public class IDOContactReviseTimeModel: NSObject, IDOBaseModel {
    /// 0: No need to send contact file
    /// 1: Need to send contact data
    public var result: Int

    enum CodingKeys: String, CodingKey {
        case result
    }

    public init(result: Int) {
        self.result = result
    }

    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
