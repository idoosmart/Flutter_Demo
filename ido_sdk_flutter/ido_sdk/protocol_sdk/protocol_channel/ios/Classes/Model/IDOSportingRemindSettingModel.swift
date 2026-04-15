//
//  IDOSportingRemindSettingModel.swift
//  protocol_channel
//
//  Created by Davy on 2025/4/30.
//

import Foundation



// MARK: - 运动提醒设置参数模型
@objcMembers
public class IDOSportingRemindSettingParamModel: NSObject, IDOBaseModel {
    /// 操作类型常量
    public static let SET: Int = 1
    public static let QUERY: Int = 2

    var version: Int = 0
    public var operate: Int?
    public var settingItems: [IDOSportingRemindSettingModel]?
    public var sportTypes:[Int]?

    // JSON Key 映射（通过 Codable 实现）
    private enum CodingKeys: String, CodingKey {
        case version
        case operate
        case settingItems = "setting_item"
        case settingItemCount = "setting_item_num"
        case sportTypeCount = "sport_type_num"
        case sportTypes = "sport_type"
    }

     private(set) var settingItemCount: Int

     private(set) var sportTypeCount: Int

    // 初始化方法
    public init(operate: Int? = nil, settingItems: [IDOSportingRemindSettingModel]? = nil,sportTypes:[Int]?=nil) {
        self.version = 0
        self.operate = operate
        self.settingItems = settingItems
        self.settingItemCount = settingItems?.count ?? 0
        self.sportTypes = sportTypes
        self.sportTypeCount = sportTypes?.count ?? 0
    }
}

// MARK: - 运动提醒设置响应模型

@objcMembers
public class IDOSportingRemindSettingReplyModel: NSObject, IDOBaseModel {
    public var errCode: Int = 0
    public var settingItems: [IDOSportingRemindSettingModel]?

    private enum CodingKeys: String, CodingKey {
        case errCode = "err_code"
        case settingItems = "setting_item"
    }

    public init(errCode: Int = 0, settingItems: [IDOSportingRemindSettingModel]? = nil) {
        self.errCode = errCode
        self.settingItems = settingItems
        super.init()
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

// MARK: - 运动提醒设置模型

@objcMembers
public class IDOSportingRemindSettingModel: NSObject, IDOBaseModel {
    public var sportType: Int = 0
    public var distanceRemind: DistanceRemind
    public var heartRateRemind: CommonRangeRemind
    public var paceRemind: PaceRemind
    public var stepFreqRemind: CommonRangeRemind

    private enum CodingKeys: String, CodingKey {
        case sportType = "sport_type"
        case distanceRemind = "dis_remind"
        case heartRateRemind = "hr_remind"
        case paceRemind = "pace_remind"
        case stepFreqRemind = "step_freq_remind"
    }

    public init(
        sportType: Int,
        distanceRemind: DistanceRemind,
        heartRateRemind: CommonRangeRemind,
        paceRemind: PaceRemind,
        stepFreqRemind: CommonRangeRemind
    ) {
        self.sportType = sportType
        self.distanceRemind = distanceRemind
        self.heartRateRemind = heartRateRemind
        self.paceRemind = paceRemind
        self.stepFreqRemind = stepFreqRemind
    }

}

// MARK: - 距离提醒

@objcMembers
public class DistanceRemind: NSObject, IDOBaseModel {
    public var isOpen: Bool = false
    public var isMetric: Bool = false
    public var goalValOrg: Int = 0

    private enum CodingKeys: String, CodingKey {
        case isOpen = "is_on"
        case isMetric = "is_metric"
        case goalValOrg = "goal_val_org"
    }

    public init(isOpen: Bool = false, isMetric: Bool = false, goalValOrg: Int = 0) {
        self.isOpen = isOpen
        self.isMetric = isMetric
        self.goalValOrg = goalValOrg
    }
}

// MARK: - 通用范围提醒

@objcMembers
public class CommonRangeRemind: NSObject, IDOBaseModel {
    public var isOpen: Bool = false
    public var maxThreshold: Int = 0
    public var minThreshold: Int = 0

    private enum CodingKeys: String, CodingKey {
        case isOpen = "is_on"
        case maxThreshold = "max_threshold"
        case minThreshold = "min_threshold"
    }

    public init(isOpen: Bool = false, maxThreshold: Int = 0, minThreshold: Int = 0) {
        self.isOpen = isOpen
        self.maxThreshold = maxThreshold
        self.minThreshold = minThreshold
    }
}

// MARK: - 配速提醒

@objcMembers
public class PaceRemind: NSObject, IDOBaseModel {
    public var isOpen: Bool = false
    public var isMetric: Bool = false
    public var fastThresholdOrg: Int = 0
    public var slowThresholdOrg: Int = 0

    private enum CodingKeys: String, CodingKey {
        case isOpen = "is_on"
        case isMetric = "is_metric"
        case fastThresholdOrg = "fast_threshold_org"
        case slowThresholdOrg = "slow_threshold_org"
    }

    public init(
        isOpen: Bool = false,
        isMetric: Bool = false,
        fastThresholdOrg: Int = 0,
        slowThresholdOrg: Int = 0
    ) {
        self.isOpen = isOpen
        self.isMetric = isMetric
        self.fastThresholdOrg = fastThresholdOrg
        self.slowThresholdOrg = slowThresholdOrg
    }
}

