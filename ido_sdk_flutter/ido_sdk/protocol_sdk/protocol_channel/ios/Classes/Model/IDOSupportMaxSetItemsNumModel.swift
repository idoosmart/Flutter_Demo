//
//  IDOSupportMaxSetItemsNumModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Get maximum number of settings supported by firmware event number
@objcMembers
public class IDOSupportMaxSetItemsNumModel: NSObject, IDOBaseModel {
    /// Maximum number of frequently contacted persons that firmware supports for app to set (default is 10)
    public var contactMaxSetNum: Int
    /// Maximum number of schedule reminders that firmware supports for app to set(default is 30)
    public var reminderMaxSetNum: Int
    /// Maximum sending buffer size of message reminders (default is 250 bytes)
    public var msgMaxBuffSize: Int

    enum CodingKeys: String, CodingKey {
        case contactMaxSetNum = "contact_max_set_num"
        case reminderMaxSetNum = "reminder_max_set_num"
        case msgMaxBuffSize = "msg_max_buff_size"
    }

    public init(contactMaxSetNum: Int, reminderMaxSetNum: Int, msgMaxBuffSize: Int) {
        self.contactMaxSetNum = contactMaxSetNum
        self.reminderMaxSetNum = reminderMaxSetNum
        self.msgMaxBuffSize = msgMaxBuffSize
    }

    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
