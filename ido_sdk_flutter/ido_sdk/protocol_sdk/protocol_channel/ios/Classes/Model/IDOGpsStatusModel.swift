//
//  IDOGpsStatusModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Get GPS Status event number
@objcMembers
public class IDOGpsStatusModel: NSObject, IDOBaseModel {
    /// GPS running status
    /// 0 - Not running
    /// 1 - Searching for satellites
    /// 2 - Tracking
    public var gpsRunStatus: Int
    /// Validity of AGPS (Assisted GPS) in hours
    /// Non-zero values indicate validity
    public var agpsIsValid: Int

    enum CodingKeys: String, CodingKey {
        case gpsRunStatus = "gps_run_status"
        case agpsIsValid = "agps_is_valid"
    }

    public init(gpsRunStatus: Int, agpsIsValid: Int) {
        self.gpsRunStatus = gpsRunStatus
        self.agpsIsValid = agpsIsValid
    }

    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
