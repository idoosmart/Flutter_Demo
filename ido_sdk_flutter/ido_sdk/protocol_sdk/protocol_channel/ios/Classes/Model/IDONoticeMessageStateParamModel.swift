//
//  IDONoticeMessageStateParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/19.
//

import Foundation

@objcMembers
public class IDONoticeMessageStateParamModel: NSObject, IDOBaseModel {
    private var version: Int
    private var itemsNum: Int
    /// Operation 1: Add  2: Modify 3: Get and Query
    public var operat: Int
    /// Add and modify only
    /// Overall notification switch
    /// 1: Enable all notifications
    /// 0: Disable all notifications
    public var allOnOff: Int
    /// Total number of packets sent
    /// For sending more than 100 packets in multiple parts
    /// all_send_num = now_send_index for completion of sending
    public var allSendNum: Int
    /// Current sequence of sending
    public var nowSendIndex: Int
    /// Message details
    /// Collection of evt_type, notify_state, and pic_flag
    public var items: [IDONoticeMessageStateItem]
    
    enum CodingKeys: String, CodingKey {
        case version = "version"
        case itemsNum = "items_num"
        case operat = "operat"
        case allOnOff = "all_on_off"
        case allSendNum = "all_send_num"
        case nowSendIndex = "now_send_index"
        case items = "items"
    }
    
    public init(operat: Int, allOnOff: Int, allSendNum: Int, nowSendIndex: Int, items: [IDONoticeMessageStateItem]) {
        self.version = 0
        self.itemsNum = items.count
        self.operat = operat
        self.allOnOff = allOnOff
        self.allSendNum = allSendNum
        self.nowSendIndex = nowSendIndex
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

// MARK: - IDONoticeMessageStateItem
@objcMembers
public class IDONoticeMessageStateItem: NSObject, Codable {
    /// Event type
    public var evtType: Int
    /// Notification status
    /// 1: Allow notifications
    /// 2: Silent notifications
    /// 3: Close notifications
    public var notifyState: Int
    /// Applies when replying, set this parameter to 0
    /// 0: Invalid
    /// 1: Download corresponding image
    /// 2: No corresponding image
    public var picFlag: Int
    
    enum CodingKeys: String, CodingKey {
        case evtType = "evt_type"
        case notifyState = "notify_state"
        case picFlag = "pic_flag"
    }
    
    public init(evtType: Int, notifyState: Int, picFlag: Int) {
        self.evtType = evtType
        self.notifyState = notifyState
        self.picFlag = picFlag
    }
}
