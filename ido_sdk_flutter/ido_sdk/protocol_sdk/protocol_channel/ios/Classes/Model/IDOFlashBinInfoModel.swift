//
//  IDOFlashBinInfoModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Get Font Library Information event number
@objcMembers
public class IDOFlashBinInfoModel: NSObject, IDOBaseModel {
    /// Status: 0 - Normal, 1 - Invalid font, checksum error, 2 - Version mismatch
    public var status: Int
    /// Font library version
    private let version: Int
    /// Matching version required by the firmware
    public var matchVersion: Int
    /// Font library checksum code
    public var checkCode: Int

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case version = "version"
        case matchVersion = "match_version"
        case checkCode = "check_code"
    }

    public init(status: Int, matchVersion: Int, checkCode: Int) {
        self.status = status
        self.version = 0
        self.matchVersion = matchVersion
        self.checkCode = checkCode
    }

    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
