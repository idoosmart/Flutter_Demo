//
//  IDOUserInfoPramModel.swift
//  protocol_channel
//
//  Created by hc on 2024/1/8.
//

import Foundation


// MARK: - IDOUserInfoPramModel
@objcMembers
public class IDOUserInfoPramModel: NSObject, IDOBaseModel {
    public var year, monuth, day: Int
    
    /// 身高 单位厘米
    /// Height in centimeters
    public var heigh: Int
    
    /// 体重 单位千克 值需要x100
    /// Weight in kilograms Value needs x100
    public var weigh: Int
    
    /// 性别 1：女  0：男
    /// Gender 1: Female 0: Male
    public var gender: Int
    
    /// 当前时间戳
    public var setTime: Int32 = 0

    enum CodingKeys: String, CodingKey {
        case year, day, gender
        case monuth = "month"
        case heigh = "height"
        case weigh = "weight"
        case setTime = "set_time"
    }
    
    public init(year: Int, monuth: Int, day: Int, heigh: Int, weigh: Int, gender: Int) {
        self.year = year
        self.monuth = monuth
        self.day = day
        self.heigh = heigh
        self.weigh = weigh
        self.gender = gender
    }
    
    public init(year: Int, monuth: Int, day: Int, heigh: Int, weigh: Int, gender: Int, setTime: Int32 = 0) {
        self.year = year
        self.monuth = monuth
        self.day = day
        self.heigh = heigh
        self.weigh = weigh
        self.gender = gender
        self.setTime = setTime
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
