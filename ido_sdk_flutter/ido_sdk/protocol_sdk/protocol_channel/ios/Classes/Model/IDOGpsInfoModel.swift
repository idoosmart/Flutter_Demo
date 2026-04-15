//
//  IDOGpsInfoModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Get GPS Information event number
@objcMembers
public class IDOGpsInfoModel: NSObject, IDOBaseModel {
    /// GPS error code
    /// 0 - Normal, non-zero - Exceptional
    public var errCode: Int
    /// GPS firmware version
    public var fwVersion: Int
    /// Validity period of AGPS (Assisted GPS)
    public var agpsInfo: Int
    /// AGPS error code
    public var agpsErrCode: Int
    /// UTC year
    public var utcYear: Int
    /// UTC month
    public var utcMonth: Int
    /// UTC day
    public var utcDay: Int
    /// UTC hour
    public var utcHour: Int
    /// UTC minute
    public var utcMinute: Int
    /// Start mode
    /// 1 - Cold start
    /// 2 - Hot start
    public var startMode: Int
    /// Positioning satellite selection
    /// 1 - GPS
    /// 2 - GLONASS
    /// 3 - GPS + GLONASS
    public var gns: Int
    /// Fix start bit
    /// Default 0, used for debugging
    public var fixStartBit: Int
    
    /// GPS firmware version XX.XX.XX
    public var fwVersionString: String

    enum CodingKeys: String, CodingKey {
        case errCode = "err_code"
        case fwVersion = "fw_version"
        case agpsInfo = "agps_info"
        case agpsErrCode = "agps_err_code"
        case utcYear = "utc_year"
        case utcMonth = "utc_month"
        case utcDay = "utc_day"
        case utcHour = "utc_hour"
        case utcMinute = "utc_minute"
        case startMode = "start_mode"
        case gns = "gns"
        case fixStartBit = "fix_start_bit"
        case fwVersionString = "fw_version_str"
    }

    public init(errCode: Int, fwVersion: Int, agpsInfo: Int, agpsErrCode: Int, utcYear: Int, utcMonth: Int, utcDay: Int, utcHour: Int, utcMinute: Int, startMode: Int, gns: Int, fixStartBit: Int, fwVersionString: String) {
        self.errCode = errCode
        self.fwVersion = fwVersion
        self.agpsInfo = agpsInfo
        self.agpsErrCode = agpsErrCode
        self.utcYear = utcYear
        self.utcMonth = utcMonth
        self.utcDay = utcDay
        self.utcHour = utcHour
        self.utcMinute = utcMinute
        self.startMode = startMode
        self.gns = gns
        self.fixStartBit = fixStartBit
        self.fwVersionString = fwVersionString
    }

    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}




// MARK: - IDOGpsHotStartParamModel
@objcMembers
public class IDOGpsHotStartParamModel: NSObject, IDOBaseModel {
    /// Longitude (multiplied by 10^6)
    public var longitude: Int
    /// Latitude (multiplied by 10^6)
    public var latitude: Int
    /// Altitude (multiplied by 10)
    public var altitude: Int
    /// TCXO offset
    public var tcxoOffset: Int

    enum CodingKeys: String, CodingKey {
        case longitude = "longitude"
        case latitude = "latitude"
        case altitude = "altitude"
        case tcxoOffset = "tcxo_offset"
    }

    public init(longitude: Int, latitude: Int, altitude: Int, tcxoOffset: Int) {
        self.longitude = longitude
        self.latitude = latitude
        self.altitude = altitude
        self.tcxoOffset = tcxoOffset
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
