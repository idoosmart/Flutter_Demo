//
//  IDOGlucoseCurrentInfo.swift
//  protocol_channel
//
//  Created by hc on 10/27/25.
//

import Foundation

// MARK: - IDOBloodGlucoseModel
@objcMembers
class IDOBloodGlucoseModel: NSObject, IDOBaseModel {
    
    private var version: Int = 0
    
    public var operate: Int
    
    private var currentInfoCount: Int
    
    // 血糖统计数据count 通常为1
    private var statisticsInfoCount: Int
    
    // 血糖CGM历史数据count 通常为1
    private var historyInfoCount: Int
    
    // 预留字节
    //private var data: [Int]
    
    public var currentInfoItem: IDOBloodGlucoseCurrentInfo? = nil
    
    public var statisticsInfoItem: IDOBloodGlucoseStatisticsInfo? = nil
    
    public var historyInfoItem: IDOBloodGlucoseHistoryDataInfo? = nil
    
    
    public init(operate: Int, currentInfoItem: IDOBloodGlucoseCurrentInfo? = nil,  statisticsInfoItem: IDOBloodGlucoseStatisticsInfo? = nil, historyInfoItem: IDOBloodGlucoseHistoryDataInfo? = nil) {
        self.version = 0
        self.operate = operate
        self.currentInfoCount = currentInfoItem != nil ? 1 : 0
        self.statisticsInfoCount = statisticsInfoItem != nil ? 1 : 0
        self.historyInfoCount = historyInfoItem != nil ? 1 : 0
        self.currentInfoItem = currentInfoItem
        self.statisticsInfoItem = statisticsInfoItem
        self.historyInfoItem = historyInfoItem
        //self.data = []
    }
    
    // MARK: - CodingKeys
    public enum CodingKeys: String, CodingKey {
        case version
        case operate
        case currentInfoCount = "current_info_count"
        case statisticsInfoCount = "statistics_info_count"
        case historyInfoCount = "history_info_count"
        //case data
        case currentInfoItem = "current_info"
        case statisticsInfoItem = "statistics_info"
        case historyInfoItem = "history_info"
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            return String(data: jsonData, encoding: .utf8)
        }
        return nil
    }
}



// MARK: - IDOGlucoseCurrentInfo

@objcMembers 
public class IDOBloodGlucoseCurrentInfo: NSObject, IDOBaseModel {
    
    /// 最近一次测量的时间戳
    public var lastUtcDate: UInt32
    
    /// 血糖单位 1: mmol/L 2: mg/DL
    public var targetUnit: Int
    
    /// 血糖趋势
    public var trendVal: Int
    
    /// 传感器状态
    /// 0：无效
    /// 1:正常，在这个状态 血糖数值，trend才有用
    /// 2:sensor稳定中
    /// 3:sensor错误
    /// 4:sensor替换
    /// 5:确认新 sensor
    /// 6:预热中
    /// 7:sensor 过期
    /// 8:数据无效
    /// 9:sensor低电量
    public var sensorStatus: Int

    /// 最近一次测量的值 100倍
    public var lastGlucoseVal: Int = 0xFFFF

    /// 传感器预热时间（单位：分钟）
    public var sensorWarmUpTime: Int
    
    /// 血糖正常值范围最大值(100倍)
    public var normalGlucoseValMax: Int
    
    /// 血糖正常值范围最小值(100倍)
    public var normalGlucoseValMin: Int
    
    public enum CodingKeys: String, CodingKey {
        case lastUtcDate = "last_utc_date"
        case lastGlucoseVal = "last_glucose_val"
        case targetUnit = "targetUnit"
        case trendVal = "trend_val"
        case sensorStatus = "sensor_status"
        case sensorWarmUpTime = "sensor_warm_up_time"
        case normalGlucoseValMax = "normal_glucose_val_max"
        case normalGlucoseValMin = "normal_glucose_val_min"
    }
    
    public init(lastUtcDate: UInt32, lastGlucoseVal: Int = 0xFFFF, targetUnit: Int, trendVal: Int, sensorWarmUpTime: Int, sensorStatus: Int, normalGlucoseValMax: Int, normalGlucoseValMin: Int) {
        self.lastUtcDate = lastUtcDate
        self.lastGlucoseVal = lastGlucoseVal
        self.targetUnit = targetUnit
        self.trendVal = trendVal
        self.sensorStatus = sensorStatus
        self.sensorWarmUpTime = sensorWarmUpTime
        self.normalGlucoseValMax = normalGlucoseValMax
        self.normalGlucoseValMin = normalGlucoseValMin
    }

}


// MARK: - IDOGlucoseStatisticsItem

@objcMembers 
public class IDOBloodGlucoseStatisticsItem: NSObject, IDOBaseModel {
    
    /// 血糖最大值 扩大一百倍
    public var glucoseMax: Int = 0xFFFF
    
    /// 血糖最小值 扩大一百倍
    public var glucoseMin: Int = 0xFFFF
    
    /// 扩大一百倍
    public var maxFlu: Int = 0xFFFF
    
    /// 扩大一百倍
    public var ehba1c: Int = 0xFFFF
    
    /// 扩大一百倍
    public var mbg: Int = 0xFFFF
    
    /// 扩大一百倍
    public var sdbg: Int = 0xFFFF
    
    /// 扩大一百倍
    public var cv: Int = 0xFFFF
    
    /// 扩大一百倍
    public var mage: Int = 0xFFFF
    
    /// 预留字节，长度为 6
    //public var data: [Int]
    
    // MARK: - Initializer (构造方法)
    public init(glucoseMax: Int = 0xFFFF, glucoseMin: Int = 0xFFFF, maxFlu: Int = 0xFFFF, ehba1c: Int = 0xFFFF, mbg: Int = 0xFFFF, sdbg: Int = 0xFFFF, cv: Int = 0xFFFF, mage: Int = 0xFFFF) {
        self.glucoseMax = glucoseMax
        self.glucoseMin = glucoseMin
        self.maxFlu = maxFlu
        self.ehba1c = ehba1c
        self.mbg = mbg
        self.sdbg = sdbg
        self.cv = cv
        self.mage = mage
    }
    
    // MARK: - CodingKeys
    public enum CodingKeys: String, CodingKey {
        case glucoseMax = "glucose_max"
        case glucoseMin = "glucose_min"
        case maxFlu = "maxflu"
        case ehba1c
        case mbg
        case sdbg
        case cv
        case mage
    }
    
}

// MARK: - IDOBloodGlucoseStatisticsInfo

@objcMembers 
public class IDOBloodGlucoseStatisticsInfo: NSObject, IDOBaseModel {
    
    /// 血糖单位 1: mmol/L  2: mg/DL
    public var targetUnit: Int
    
    /// 胰岛素注射量 四位小数扩大10000倍
    public var insulinDose: Int
    
    // 预留字节，长度为 8
    //public var data: [Int]

    private var todayCount: Int
    private var weekCount: Int
    private var monthCount: Int
    
    /// 当日统计数据
    public var todayItem: IDOBloodGlucoseStatisticsItem? = nil
    
    /// 本周统计数据
    public var weekItem: IDOBloodGlucoseStatisticsItem? = nil
    
    /// 本月统计数据
    public var monthItem: IDOBloodGlucoseStatisticsItem? = nil
    
    public init(targetUnit: Int, insulinDose: Int, todayItem: IDOBloodGlucoseStatisticsItem? = nil, weekItem: IDOBloodGlucoseStatisticsItem? = nil, monthItem: IDOBloodGlucoseStatisticsItem? = nil) {
        self.targetUnit = targetUnit
        self.insulinDose = insulinDose
        //self.data = data
        self.todayItem = todayItem
        self.weekItem = weekItem
        self.monthItem = monthItem
        self.todayCount = todayItem != nil ? 1 : 0
        self.weekCount = weekItem != nil ? 1 : 0
        self.monthCount = monthItem != nil ? 1 : 0
    }
    
    public enum CodingKeys: String, CodingKey {
        case targetUnit = "targetUnit"
        case insulinDose = "insulin_count"
        //case data
        case todayItem = "today_item"
        case weekItem = "week_item"
        case monthItem = "month_item"
        case todayCount = "today_count"
        case weekCount = "week_count"
        case monthCount = "month_count"
    }

}


// MARK: - IDOBloodGlucoseHistoryDataInfo
@objcMembers 
public class IDOBloodGlucoseHistoryDataInfo: NSObject, IDOBaseModel {
    
    /// 总item个数
    internal var allItemsNum: Int
    
    /// 已发送/接收的item个数
    //internal var finishItemsNum: Int
    
    /// 当前包item个数 (最大130）
    //internal var curItemsNum: Int
    
    /// 历史血糖个数
    //internal var historyDataCount: Int
    
    /// 历史数据项列表
    public var dataInfos: [IDOBloodGlucoseHistoryDataItem]?
    
    // MARK: - Initializer (构造方法)
    public init(dataInfos: [IDOBloodGlucoseHistoryDataItem]?) {
        self.allItemsNum = dataInfos?.count ?? 0
        //self.finishItemsNum = 0
        //self.curItemsNum = 0
        //self.historyDataCount = dataInfo?.count ?? 0
        self.dataInfos = dataInfos
    }
    
    // MARK: - CodingKeys
    public enum CodingKeys: String, CodingKey {
        case allItemsNum = "all_items_num"
//        case finishItemsNum = "finish_items_num"
//        case curItemsNum = "cur_items_num"
//        case historyDataCount = "history_data_count"
        case dataInfos = "data_infos"
    }

    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            return String(data: jsonData, encoding: .utf8)
        }
        return nil
    }
}

// MARK: - IDOGlucoseHistoryDataItem

@objcMembers 
public class IDOBloodGlucoseHistoryDataItem: NSObject, IDOBaseModel {
    
    // 时间
    public var date: UInt32
    
    // 血糖值 扩大一百倍
    public var glucoseVal: Int
    
    // 血糖单位 1: mmol/L  2: mg/DL
    public var targetUnit: Int
    
    public init(date: UInt32, glucoseVal: Int, targetUnit: Int) {
        self.date = date
        self.glucoseVal = glucoseVal
        self.targetUnit = targetUnit
    }
    
    public enum CodingKeys: String, CodingKey {
        case date
        case glucoseVal = "glucose_val"
        case targetUnit = "targetUnit"
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            return String(data: jsonData, encoding: .utf8)
        }
        return nil
    }
}

