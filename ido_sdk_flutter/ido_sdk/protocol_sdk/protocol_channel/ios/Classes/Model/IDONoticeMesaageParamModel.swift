//
//  IDONoticeMesaageParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/17.
//

import Foundation

@objcMembers
public class IDONoticeMesaageParamModel: NSObject, IDOBaseModel {
    /// Protocol library version number
    private var verison: Int
    /// System 0: Invalid, 1: Android, 2: iOS
    public var osPlatform: Int
    /// Current mode 0: Invalid, 1: Message reminder
    public var evtType: Int
    /// Enumeration type of message Max value: 20000
    public var notifyType: Int
    /// Message ID Valid only if evt_type is message reminder and msg_ID is not 0
    public var msgID: Int
    /// Number of country and language details
    public var appItemsLen: Int
    /// Contact name (maximum 63 bytes)
    public var contact: String
    /// Phone number (maximum 31 bytes)
    public var phoneNumber: String
    /// Message content (maximum 249 bytes)
    public var msgData: String
    public var items: [IDONoticeMesaageParamItem]

    enum CodingKeys: String, CodingKey {
        case verison = "verison"
        case osPlatform = "os_platform"
        case evtType = "evt_type"
        case notifyType = "notify_type"
        case msgID = "msg_ID"
        case appItemsLen = "app_items_len"
        case contact = "contact"
        case phoneNumber = "phone_number"
        case msgData = "msg_data"
        case items = "items"
    }

    public init(osPlatform: Int, evtType: Int, notifyType: Int, msgID: Int, appItemsLen: Int, contact: String, phoneNumber: String, msgData: String, items: [IDONoticeMesaageParamItem]) {
        self.verison = 0
        self.osPlatform = osPlatform
        self.evtType = evtType
        self.notifyType = notifyType
        self.msgID = msgID
        self.appItemsLen = appItemsLen
        self.contact = contact
        self.phoneNumber = phoneNumber
        self.msgData = msgData
        self.items = items
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

// MARK: - IDOItem
@objcMembers
public class IDONoticeMesaageParamItem: NSObject, Codable {
    /// Language type
    public var language: Int
    /// App name corresponding to the country (maximum 49 bytes)
    public var name: String

    enum CodingKeys: String, CodingKey {
        case language
        case name
    }

    public init(language: Int, name: String) {
        self.language = language
        self.name = name
    }
}
