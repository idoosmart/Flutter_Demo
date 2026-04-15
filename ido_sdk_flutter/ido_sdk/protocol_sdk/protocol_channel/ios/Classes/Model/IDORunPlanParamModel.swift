//
//  IDORunPlanParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/17.
//

import Foundation

@objcMembers
public class IDORunPlanParamModel: NSObject, IDOBaseModel {
    /// Protocol library version number
    public var verison: Int
    /// Operation
    /// 1: Start plan
    /// 2: Plan data sent
    /// 3: End plan
    /// 4: Query running plan
    public var operate: Int
    /// Plan type
    /// 1: 3km running plan
    /// 2: 5km running plan
    /// 3: 10km running plan
    /// 4: Half marathon training (Phase 2)
    /// 5: Marathon training (Phase 2)
    public var type: Int
    public var year: Int
    public var month: Int
    public var day: Int
    public var hour: Int
    public var min: Int
    public var sec: Int
    /// Number of plan days
    /// Applicable when operate is 2
    public var dayNum: Int
    public var items: [IDOGpsInfoModelItem]

    enum CodingKeys: String, CodingKey {
        case verison
        case operate
        case type
        case year
        case month
        case day
        case hour
        case min
        case sec
        case dayNum
        case items
    }

    public init(verison: Int, operate: Int, type: Int, year: Int, month: Int, day: Int, hour: Int, min: Int, sec: Int, dayNum: Int, items: [IDOGpsInfoModelItem]) {
        self.verison = verison
        self.operate = operate
        self.type = type
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.min = min
        self.sec = sec
        self.dayNum = dayNum
        self.items = items
    }

    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

// MARK: - IDOGpsInfoModelItem

@objcMembers
public class IDOGpsInfoModelItem: NSObject, Codable {
    /// Training type
    /// 186: Rest plan
    /// 187: Outdoor running plan
    /// 188: Indoor running plan
    /// 189: Indoor fitness plan
    public var type: Int
    /// Number of actions
    /// Note: The number of actions is zero when resting, and non-zero for other actions
    public var num: Int
    public var item: [IDOItemItem]

    enum CodingKeys: String, CodingKey {
        case type
        case num
        case item
    }

    public init(type: Int, num: Int, item: [IDOItemItem]) {
        self.type = type
        self.num = num
        self.item = item
    }
}

// MARK: - IDOItemItem

@objcMembers
public class IDOItemItem: NSObject, Codable {
    /// Action type
    /// 1: Fast walk
    /// 2: Jog
    /// 3: Moderate run
    /// 4: Fast run
    public var type: Int
    /// Target time Unit: seconds
    public var time: Int
    /// Low heart rate range
    public var heightHeart: Int
    /// High heart rate range
    public var lowHeart: Int

    enum CodingKeys: String, CodingKey {
        case type
        case time
        case heightHeart = "height_heart"
        case lowHeart = "low_heart"
    }

    public init(type: Int, time: Int, heightHeart: Int, lowHeart: Int) {
        self.type = type
        self.time = time
        self.heightHeart = heightHeart
        self.lowHeart = lowHeart
    }
}
