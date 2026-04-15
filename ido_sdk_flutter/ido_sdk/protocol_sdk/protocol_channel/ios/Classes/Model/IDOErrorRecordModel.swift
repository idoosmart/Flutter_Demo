//
//  IDOErrorRecordModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Get Error Records event number
@objcMembers
public class IDOErrorRecordModel: NSObject, IDOBaseModel {
    /// 0 Query
    /// 1 Clear Log
    public var type: Int
    /// 0 Normal
    /// 1 Hard Faul
    /// 2 Watchdog service
    /// 3 Assertion reset
    /// 4 Power-off service
    /// 5 Other exceptions
    public var resetFlag: Int
    /// Hardware error code
    /// 0 Normal
    /// 1 Accelerometer error
    /// 2 Heart rate error
    /// 3 TP error
    /// 4 Flash error
    public var hwError: Int
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case resetFlag = "reset_flag"
        case hwError = "hw_error"
    }
    
    public init(type: Int,resetFlag: Int,hwError: Int) {
        self.type = type
        self.resetFlag = resetFlag
        self.hwError = hwError
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

