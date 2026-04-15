//
//  IDOVoiceReplyParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/18.
//

import Foundation

@objcMembers
public class IDOVoiceReplyParamModel: NSObject, IDOBaseModel {
    private let version: Int
    /// Flag for continuing recording
    /// 0: Stop recording, 1: Continue recording
    public var flagIsContinue: Int
    /// Title data, maximum 31 bytes
    public var title: String
    /// Content data, maximum 511 bytes
    public var textContent: String

    enum CodingKeys: String, CodingKey {
        case version = "version"
        case flagIsContinue = "flag_is_continue"
        case title = "title"
        case textContent = "text_content"
    }

    public init(flagIsContinue: Int, title: String, textContent: String) {
        self.version = 0
        self.flagIsContinue = flagIsContinue
        self.title = title
        self.textContent = textContent
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
