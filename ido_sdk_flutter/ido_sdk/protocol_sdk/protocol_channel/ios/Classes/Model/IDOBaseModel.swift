//
//  IDOBaseModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/11.
//

import Foundation

public protocol IDOBaseModel: Codable {
    func toJsonString() -> String?
}

extension IDOBaseModel {
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
