//
//  IDOSchedulerReminderParamModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/19.
//

import Foundation

// MARK: - IDOSchedulerReminderParamModel
@objcMembers
public class IDOSchedulerReminderParamModel: NSObject, IDOBaseModel {
    private let version: Int
    public var operate: Int
    private let num: Int
    public var items: [IDOSchedulerReminderItem]
    
    enum CodingKeys: String, CodingKey {
        case version = "version"
        case operate = "operate"
        case num = "num"
        case items = "items"
    }
    
    public init(operate: Int, items: [IDOSchedulerReminderItem]) {
        self.version = 0
        self.operate = operate
        self.num = items.count
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

// MARK: - IDOSchedulerReminderModel
@objcMembers
public class IDOSchedulerReminderModel: NSObject, IDOBaseModel {
    private let version: Int
    /// Operation type<br />0: Invalid<br />1: Add<br />2: Delete<br />3: Query<br />4: Modify
    public var operate: Int
    /// Error code. 0 if successful, non-zero if error
    public var errCode: Int
    private let num: Int
    public var items: [IDOSchedulerReminderItem]?
    
    enum CodingKeys: String, CodingKey {
        case version = "version"
        case operate = "operate"
        case num = "num"
        case items = "items"
        case errCode = "err_code"
    }
    
    public init(operate: Int, errCode: Int, items: [IDOSchedulerReminderItem]) {
        self.version = 0
        self.operate = operate
        self.num = items.count
        self.items = items
        self.errCode = errCode
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

// MARK: - IDOSchedulerReminderItem
@objcMembers
public class IDOSchedulerReminderItem: NSObject, Codable {
    /// Reminder event ID. Incremental value sent by the app, starting from 0
    public var id: Int
    public var year: Int
    public var mon: Int
    public var day: Int
    public var hour: Int
    public var min: Int
    public var sec: Int
    /// Repeat time <br />Set bit1-bit7 for week-based repeat if enabled with
    /// `getSupportSetRepeatWeekTypeOnScheduleReminderV3` (Monday to Sunday, with bit 0 as the general switch)
    /// Set repeat type (0: Invalid, 1: Once, 2: Daily, 3: Weekly, 4: Monthly, 5: Yearly) if enabled with
    /// `getSupportSetRepeatTypeOnScheduleReminderV3`
    public var repeatType: Int
    /// Daily reminder switch<br />0: Off, 1: On
    public var remindOnOff: Int
    /// State code <br />0: Invalid, 1: Deleted, 2: Enabled
    public var state: Int
    /// Title content. Maximum 74 bytes
    public var title: String
    /// Reminder content. Maximum 149 bytes
    public var note: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case year = "year"
        case mon = "mon"
        case day = "day"
        case hour = "hour"
        case min = "min"
        case sec = "sec"
        case repeatType = "repeat_type"
        case remindOnOff = "remind_on_off"
        case state = "state"
        case title = "title"
        case note = "note"
    }
    
    public init(id: Int, year: Int, mon: Int, day: Int, hour: Int, min: Int, sec: Int, repeatType: Int, remindOnOff: Int, state: Int, title: String, note: String) {
        self.id = id
        self.year = year
        self.mon = mon
        self.day = day
        self.hour = hour
        self.min = min
        self.sec = sec
        self.repeatType = repeatType
        self.remindOnOff = remindOnOff
        self.state = state
        self.title = title
        self.note = note
    }
}
