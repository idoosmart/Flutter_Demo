//
//  IDOBpAlgVersionModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Get blood pressure algorithm version information event number
@objcMembers
public class IDOBpAlgVersionModel: NSObject, IDOBaseModel {
    /// Firmware blood pressure algorithm version1
    public var bpVersion1: Int
    /// Firmware blood pressure algorithm version2
    public var bpVersion2: Int
    /// Firmware blood pressure algorithm version3
    public var bpVersion3: Int

    enum CodingKeys: String, CodingKey {
        case bpVersion1 = "bp_version_1"
        case bpVersion2 = "bp_version_2"
        case bpVersion3 = "bp_version_3"
    }

    public init(bpVersion1: Int, bpVersion2: Int, bpVersion3: Int) {
        self.bpVersion1 = bpVersion1
        self.bpVersion2 = bpVersion2
        self.bpVersion3 = bpVersion3
    }

    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
