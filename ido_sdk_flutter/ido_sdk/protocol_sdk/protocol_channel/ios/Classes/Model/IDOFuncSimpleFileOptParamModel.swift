//
//  IDOFuncSimpleFileOptParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Simple file operations event
@objcMembers
public class IDOFuncSimpleFileOptParamModel: NSObject, IDOBaseModel {
    /// Operation type
    /// 0: Get
    /// 1: Overwrite
    /// 2: Delete
    /// 3: Copy
    public var operate: Int
    /// Index number
    public var index: Int
    /// Destination index, only used for copying, invalid for other cases
    public var destIndex: Int

    enum CodingKeys: String, CodingKey {
        case operate = "operate"
        case index = "index"
        case destIndex = "dest_index"
    }

    public init(operate: Int, index: Int, destIndex: Int) {
        self.operate = operate
        self.index = index
        self.destIndex = destIndex
    }

    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
