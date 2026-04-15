//
//  IDOLiveDataModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation
/// Get Real-time Data event number
@objcMembers
public class IDOLiveDataModel: NSObject, IDOBaseModel {
    /// Total steps
    public var totalStep: Int
    /// Total calories (in kilocalories)
    public var totalCalories: Int
    /// Total distance (in meters)
    public var totalDistances: Int
    /// Total active time (in seconds)
    public var totalActiveTime: Int
    /// Heart rate data (in beats per minute)
    public var heartRate: Int
    
    enum CodingKeys: String, CodingKey {
        case totalStep = "total_step"
        case totalCalories = "total_calories"
        case totalDistances = "total_distances"
        case totalActiveTime = "total_active_time"
        case heartRate = "heart_rate"
    }
    
    public init(totalStep: Int,totalCalories: Int,totalDistances: Int,totalActiveTime: Int,heartRate: Int) {
        self.totalStep = totalStep
        self.totalCalories = totalCalories
        self.totalDistances = totalDistances
        self.totalActiveTime = totalActiveTime
        self.heartRate = heartRate
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

