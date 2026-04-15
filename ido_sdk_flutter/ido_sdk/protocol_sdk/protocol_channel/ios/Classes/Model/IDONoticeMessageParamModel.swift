//
//  IDONoticeMessageParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/17.
//

import Foundation

@objcMembers
public class IDONoticeMessageParamModel: NSObject, IDOBaseModel {
    /// Protocol library version number
    /// Default version=1
    /// Version=2 is the sent format with msg_id
    private var verison: Int
    /// Message application type
    public var evtType: Int
    /// Message ID
    /// If evt_type is message reminder, mesg_ID is valid
    public var msgID: Int
    /// Support answering: 1
    /// Do not support answering: 0
    public var supportAnswering: Bool
    /// Support mute: 1
    /// Do not support mute: 0
    public var supportMute: Bool
    /// Support hang up: 1
    /// Do not support hang up: 0
    public var supportHangUp: Bool
    /// Contact name (maximum 63 bytes)
    public var contact: String
    /// Phone number (maximum 31 bytes)
    public var phoneNumber: String
    /// Message content (maximum 249 bytes)
    public var dataText: String

    enum CodingKeys: String, CodingKey {
        case verison
        case evtType = "evt_type"
        case msgID = "msg_id"
        case supportAnswering = "support_answering"
        case supportMute = "support_mute"
        case supportHangUp = "support_hang_up"
        case contact
        case phoneNumber = "phone_number"
        case dataText = "data_text"
    }

    public init(evtType: Int, msgID: Int, supportAnswering: Bool, supportMute: Bool, supportHangUp: Bool, contact: String, phoneNumber: String, dataText: String) {
        self.verison = 0
        self.evtType = evtType
        self.msgID = msgID
        self.supportAnswering = supportAnswering
        self.supportMute = supportMute
        self.supportHangUp = supportHangUp
        self.contact = contact
        self.phoneNumber = phoneNumber
        self.dataText = dataText
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
