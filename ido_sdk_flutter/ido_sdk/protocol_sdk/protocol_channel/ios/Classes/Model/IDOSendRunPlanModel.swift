//
//  IDOSendRunPlanModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// App issued running plan (exercise plan) event number
@objcMembers
public class IDOSendRunPlanModel: NSObject, IDOBaseModel {
    /// 00: Success, 01: Failed, 02: Another running plan is already enabled
    public var errCode: Int
    /// Protocol library version number
    public var version: Int
    /// Operation:
    /// 1: Start plan
    /// 2: Plan data sent
    /// 3: End plan
    /// 4: Query running plan
    public var operate: Int
    /// Plan type:
    /// 1: 3km running plan
    /// 2: 5km running plan
    /// 3: 10km running plan
    /// 4: Half marathon training (Phase 2)
    /// 5: Marathon training (Phase 2)
    public var type: Int
    /// Plan implementation start time year
    public var year: Int
    /// Plan implementation start time month
    public var month: Int
    /// Plan implementation start time day
    public var day: Int
    /// Plan implementation start time hour
    public var hour: Int
    /// Plan implementation start time minute
    public var min: Int
    /// Plan implementation start time second
    public var sec: Int
    
    enum CodingKeys: String, CodingKey {
        case errCode = "err_code"
        case version = "version"
        case operate = "operate"
        case type = "type"
        case year = "year"
        case month = "month"
        case day = "day"
        case hour = "hour"
        case min = "min"
        case sec = "sec"
    }
    
    public init(errCode: Int,version: Int,operate: Int,type: Int,year: Int,month: Int,day: Int,hour: Int,min: Int,sec: Int) {
        self.errCode = errCode
        self.version = version
        self.operate = operate
        self.type = type
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.min = min
        self.sec = sec
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

