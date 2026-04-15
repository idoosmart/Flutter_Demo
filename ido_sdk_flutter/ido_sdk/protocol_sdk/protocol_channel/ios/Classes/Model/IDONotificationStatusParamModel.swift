//
//  IDONotificationStatusParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Notification app status setting event
@objcMembers
public class IDONotificationStatusParamModel: NSObject, IDOBaseModel {
    /// Notification type:
    /// 1: Allow notification
    /// 2: Silent notification
    /// 3: Disable notification
    public var notifyFlag: Int

    enum CodingKeys: String, CodingKey {
        case notifyFlag = "notify_flag"
    }

    public init(notifyFlag: Int) {
        self.notifyFlag = notifyFlag
    }

    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
