//
//  IDOHotStartParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Get Hot Start Parameters event number
@objcMembers
public class IDOHotStartParamModel: NSObject, IDOBaseModel {
    /// TCXO offset
    public var tcxoOffset: Int
    /// Longitude (multiplied by 10^6)
    public var longitude: Int
    /// Latitude (multiplied by 10^6)
    public var latitude: Int
    /// Altitude (multiplied by 10)
    public var altitude: Int

    enum CodingKeys: String, CodingKey {
        case tcxoOffset = "tcxo_offset"
        case longitude = "longitude"
        case latitude = "latitude"
        case altitude = "altitude"
    }

    public init(tcxoOffset: Int, longitude: Int, latitude: Int, altitude: Int) {
        self.tcxoOffset = tcxoOffset
        self.longitude = longitude
        self.latitude = latitude
        self.altitude = altitude
    }

    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
