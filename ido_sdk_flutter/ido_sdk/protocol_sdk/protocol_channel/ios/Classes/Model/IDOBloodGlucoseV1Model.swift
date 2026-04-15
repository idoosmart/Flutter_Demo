//
//  IDOBloodGlucoseV1Model.swift
//  protocol_channel
//
//  Created by hc on 2025/12/23.
//

import Foundation

// MARK: - IDOBloodGlucoseV1Model

@objcMembers
internal class IDOBloodGlucoseV1Model: NSObject, IDOBaseModel {
    
    private var version: Int = 1
    
    /// 操作码 1:发送 2:获取 3:设备结束监测
    public var operate: Int
    
    /// 操作码 1有效
    public var sendInfo: IDOBloodGlucoseSendInfo?
    
    /// 操作码 2有效
    public var getInfo: IDOBloodGlucoseGetInfo?
    
    public init(operate: Int, sendInfo: IDOBloodGlucoseSendInfo? = nil, getInfo: IDOBloodGlucoseGetInfo? = nil) {
        self.operate = operate
        self.sendInfo = sendInfo
        self.getInfo = getInfo
    }
    
    public enum CodingKeys: String, CodingKey {
        case version
        case operate
        case sendInfo = "send_info"
        case getInfo = "get_info"
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            return String(data: jsonData, encoding: .utf8)
        }
        return nil
    }
}

// MARK: - IDOBloodGlucoseSendInfo

@objcMembers
public class IDOBloodGlucoseSendInfo: NSObject, IDOBaseModel {
    
    /// 数据类型
    /// 1:app下发当前血糖数据
    /// 2:app下发血糖统计数据
    /// 3:app下发血糖CGM历史数据
    /// 4:app下发绑定设置血糖仪信息
    /// 5:app设置单位、目标范围
    public var dataType: Int
    
    private var currentInfoCount: Int
    private var statisticsInfoCount: Int
    private var historyInfoCount: Int
    private var sensorInfoCount: Int
    private var settingInfoCount: Int
    
    // 预留字节
    // private var data: [Int]
    
    /// data_type 1有效
    public var currentInfo: IDOBloodGlucoseCurrentInfoV1?
    
    /// data_type 2有效
    public var statisticsInfo: IDOBloodGlucoseStatisticsInfoV1?
    
    /// data_type 3有效
    public var historyInfo: IDOBloodGlucoseHistoryDataInfoV1?
    
    /// data_type 4有效
    public var sensorInfo: IDOBloodGlucoseSensorInfoV1?
    
    /// data_type 5有效
    public var settingInfo: IDOBloodGlucoseSettingInfoV1?
    
    public init(dataType: Int, currentInfo: IDOBloodGlucoseCurrentInfoV1? = nil, statisticsInfo: IDOBloodGlucoseStatisticsInfoV1? = nil, historyInfo: IDOBloodGlucoseHistoryDataInfoV1? = nil, sensorInfo: IDOBloodGlucoseSensorInfoV1? = nil, settingInfo: IDOBloodGlucoseSettingInfoV1? = nil) {
        self.dataType = dataType
        self.currentInfo = currentInfo
        self.statisticsInfo = statisticsInfo
        self.historyInfo = historyInfo
        self.sensorInfo = sensorInfo
        self.settingInfo = settingInfo
        
        self.currentInfoCount = currentInfo != nil ? 1 : 0
        self.statisticsInfoCount = statisticsInfo != nil ? 1 : 0
        self.historyInfoCount = historyInfo != nil ? 1 : 0
        self.sensorInfoCount = sensorInfo != nil ? 1 : 0
        self.settingInfoCount = settingInfo != nil ? 1 : 0
    }
    
    public enum CodingKeys: String, CodingKey {
        case dataType = "data_type"
        case currentInfoCount = "current_info_count"
        case statisticsInfoCount = "statistics_info_count"
        case historyInfoCount = "history_info_count"
        case sensorInfoCount = "sensor_info_count"
        case settingInfoCount = "setting_info_count"
        case currentInfo = "current_info"
        case statisticsInfo = "statistics_info"
        case historyInfo = "history_info"
        case sensorInfo = "sensor_info"
        case settingInfo = "setting_info"
    }
}

// MARK: - IDOBloodGlucoseCurrentInfoV1

@objcMembers
public class IDOBloodGlucoseCurrentInfoV1: NSObject, IDOBaseModel {
    
    /// 最近一次测量的时间戳
    public var lastUtcDate: UInt32
    
    /// 最近一次测量的值 100倍 0xffff为无效值
    public var lastGlucoseVal: Int
    
    /// 血糖单位 1: mmol/L  2: mg/DL
    public var targetUnit: Int
    
    /// 血糖趋势
    /// 0：无效
    /// 1：rapidlyfalling
    /// 2：falling
    /// 3：slowlyfalling
    /// 4：steady
    /// 5：slowlyrising
    /// 6：rising
    /// 7：rapidlyrising
    public var trendVal: Int
    
    /// 传感器状态
    /// 0:无效值
    /// 1:正常，在这个状态 血糖数值
    /// 2:sensor蓝牙连接中
    /// 3:sensor蓝牙断开
    public var sensorStatus: Int
    
    /// 传感器预热剩余时间(单位：分钟)
    public var sensorWarmUpTime: Int
    
    /// 血糖正常值范围最大值(100倍)
    public var normalGlucoseValMax: Int
    
    /// 血糖正常值范围最小值(100倍)
    public var normalGlucoseValMin: Int
    
    /// 序列号
    public var serialNumber: Int
    
    public init(lastUtcDate: UInt32, lastGlucoseVal: Int = 0xFFFF, targetUnit: Int, trendVal: Int, sensorStatus: Int, sensorWarmUpTime: Int, normalGlucoseValMax: Int, normalGlucoseValMin: Int, serialNumber: Int) {
        self.lastUtcDate = lastUtcDate
        self.lastGlucoseVal = lastGlucoseVal
        self.targetUnit = targetUnit
        self.trendVal = trendVal
        self.sensorStatus = sensorStatus
        self.sensorWarmUpTime = sensorWarmUpTime
        self.normalGlucoseValMax = normalGlucoseValMax
        self.normalGlucoseValMin = normalGlucoseValMin
        self.serialNumber = serialNumber
    }
    
    public enum CodingKeys: String, CodingKey {
        case lastUtcDate = "last_utc_date"
        case lastGlucoseVal = "last_glucose_val"
        case targetUnit
        case trendVal = "trend_val"
        case sensorStatus = "sensor_status"
        case sensorWarmUpTime = "sensor_warm_up_time"
        case normalGlucoseValMax = "normal_glucose_val_max"
        case normalGlucoseValMin = "normal_glucose_val_min"
        case serialNumber = "serial_number"
    }
}

// MARK: - IDOBloodGlucoseStatisticsInfoV1

@objcMembers
public class IDOBloodGlucoseStatisticsInfoV1: NSObject, IDOBaseModel {
    
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
        case insulinDose = "insulin_dose"
        //case data
        case todayItem = "today_item"
        case weekItem = "week_item"
        case monthItem = "month_item"
        case todayCount = "today_count"
        case weekCount = "week_count"
        case monthCount = "month_count"
    }

}

// MARK: - IDOBloodGlucoseHistoryDataInfoV1

@objcMembers
public class IDOBloodGlucoseHistoryDataInfoV1: NSObject, IDOBaseModel {
    
    /// 总item个数
    internal var allItemsNum: Int
    
    /// 已发送/接收的item个数
    //internal var finishItemsNum: Int
    
    /// 当前包item个数，最大值84
    //internal var curItemsNum: Int
    
    public var dataInfos: [IDOBloodGlucoseHistoryDataItemV1]?
    
    public init(dataInfos: [IDOBloodGlucoseHistoryDataItemV1]?) {
        self.allItemsNum = dataInfos?.count ?? 0
        self.dataInfos = dataInfos
    }
    
    public enum CodingKeys: String, CodingKey {
        case allItemsNum = "all_items_num"
        case dataInfos = "data_infos"
    }
}

// MARK: - IDOBloodGlucoseHistoryDataItemV1

@objcMembers
public class IDOBloodGlucoseHistoryDataItemV1: NSObject, IDOBaseModel {
    
    /// 时间
    public var date: UInt32
    
    /// 血糖值 （扩大100倍）
    public var glucoseVal: Int
    
    /// 血糖单位 1: mmol/L  2: mg/DL
    public var targetUnit: Int
    
    /// 序列号
    public var serialNumber: Int
    
    public init(date: UInt32, glucoseVal: Int, targetUnit: Int, serialNumber: Int) {
        self.date = date
        self.glucoseVal = glucoseVal
        self.targetUnit = targetUnit
        self.serialNumber = serialNumber
    }
    
    public enum CodingKeys: String, CodingKey {
        case date
        case glucoseVal = "glucose_val"
        case targetUnit
        case serialNumber = "serial_number"
    }
}

// MARK: - IDOBloodGlucoseSensorInfoV1

@objcMembers
public class IDOBloodGlucoseSensorInfoV1: NSObject, IDOBaseModel {
    
    /// 设备编码（仅搜索设备时用） len: 9
    public var sn: String
    
    /// mac地址 len: 13
    public var mac: String
    
    /// 完整设备编码sn号（唯一） len: 14
    public var intactSn: String
    
    /// 连接鉴权ID len: 13
    public var connectId: String
    
    /// 开始监测时间
    public var startTime: UInt32
    
    /// 结束监测时间
    public var endTime: UInt32
    
    /// 监测状态
    public var isTesting: Int
    
    /// 可使用天数
    public var monitoringDays: Int
    
    /// 血糖出值间隔（单位：秒）
    public var gluIntervals: Int
    
    /// 初始化时间（单位：分钟）
    public var initTime: UInt32
    
    /// 设备类型
    public var deviceType: Int

    /// 设备运行时间（单位：秒）
    public var deviceRunTime: UInt32
    
    public init(sn: String, mac: String, intactSn: String, connectId: String, startTime: UInt32, endTime: UInt32, isTesting: Int, monitoringDays: Int, gluIntervals: Int, initTime: UInt32, deviceType: Int, deviceRunTime: UInt32) {
        self.sn = sn
        self.mac = mac
        self.intactSn = intactSn
        self.connectId = connectId
        self.startTime = startTime
        self.endTime = endTime
        self.isTesting = isTesting
        self.monitoringDays = monitoringDays
        self.gluIntervals = gluIntervals
        self.initTime = initTime
        self.deviceType = deviceType
        self.deviceRunTime = deviceRunTime
    }
    
    public enum CodingKeys: String, CodingKey {
        case sn
        case mac
        case intactSn = "intact_sn"
        case connectId = "connect_id"
        case startTime = "start_time"
        case endTime = "end_time"
        case isTesting = "is_testing"
        case monitoringDays = "monitoring_days"
        case gluIntervals = "glu_intervals"
        case initTime = "init_time"
        case deviceType = "device_type"
        case deviceRunTime = "device_run_time"
    }
}

// MARK: - IDOBloodGlucoseSettingInfoV1

@objcMembers
public class IDOBloodGlucoseSettingInfoV1: NSObject, IDOBaseModel {
    
    /// 血糖单位 1: mmol/L  2: mg/DL
    public var targetUnit: Int
    
    /// 量程上限
    public var rangeMax: Int
    
    /// 量程下限
    public var rangeMin: Int
    
    /// 目标范围上限
    public var targetRangeMax: Int
    
    /// 目标范围下限
    public var targetRangeMin: Int
    
    /// 手表直连发射器开关
    public var deviceConnectSwitch: Int
    
    public init(targetUnit: Int, rangeMax: Int, rangeMin: Int, targetRangeMax: Int, targetRangeMin: Int, deviceConnectSwitch: Int) {
        self.targetUnit = targetUnit
        self.rangeMax = rangeMax
        self.rangeMin = rangeMin
        self.targetRangeMax = targetRangeMax
        self.targetRangeMin = targetRangeMin
        self.deviceConnectSwitch = deviceConnectSwitch
    }
    
    public enum CodingKeys: String, CodingKey {
        case targetUnit
        case rangeMax = "range_max"
        case rangeMin = "range_min" 
        case targetRangeMax = "target_range_max"
        case targetRangeMin = "target_range_min" 
        case deviceConnectSwitch = "device_connect_switch"
    }
}

// MARK: - IDOBloodGlucoseGetInfo

@objcMembers
internal class IDOBloodGlucoseGetInfo: NSObject, IDOBaseModel {
    
    /// 总item个数(首次请求为0，后续使用固件返回的值)
    internal var allItemsNum: Int = 0
    
    /// 已发送/接收的item个数(首次为0)
    internal var finishItemsNum: Int = 0
    
    /// 当前包item个数(请求时为0)
    internal var curItemsNum: Int = 0
    
    /// App本地最后一条血糖数据序列号 (app需要获取血糖数据时生效)(0表示获取全部)
    public var localSerialNumber: Int
    
    public init(localSerialNumber: Int) {
        self.localSerialNumber = localSerialNumber
    }
    
    public enum CodingKeys: String, CodingKey {
        case allItemsNum = "all_items_num"
        case finishItemsNum = "finish_items_num"
        case curItemsNum = "cur_items_num"
        case localSerialNumber = "local_serial_number"
    }
}


// MARK: - IDOBloodGlucoseInfoReplyV1

@objcMembers
public class IDOBloodGlucoseInfoReplyV1: NSObject, IDOBaseModel {
    
    private var version: Int = 1
    
    /// 操作码 1:发送  2:获取 3:设备结束监测
    public var operate: Int

    /// 错误码 0成功，非0失败
    public var errCode: Int
    
    /// 操作码 1有效 3有效
    public var replyInfo: IDOBloodGlucoseReplyInfoV1?
    
    /// 操作码 2有效
    public var dataInfo: IDOBloodGlucoseDataInfoV1?
    
    public init(errCode: Int, operate: Int, replyInfo: IDOBloodGlucoseReplyInfoV1? = nil, dataInfo: IDOBloodGlucoseDataInfoV1? = nil) {
        self.operate = operate
        self.replyInfo = replyInfo
        self.dataInfo = dataInfo
        self.errCode = errCode
    }
    
    public enum CodingKeys: String, CodingKey {
        case version
        case operate
        case errCode = "err_code"
        case replyInfo = "reply_info"
        case dataInfo = "data_info"
    }
}

// MARK: - IDOBloodGlucoseReplyInfoV1

@objcMembers
public class IDOBloodGlucoseReplyInfoV1: NSObject, IDOBaseModel {
    
//    /// 错误码 0成功，非0失败
//    private var errCode: Int
    
    /// 总item个数
    internal var allItemsNum: Int
    
    /// 已发送/接收的item个数
    internal var finishItemsNum: Int
    
    /// 当前包item个数
    internal var curItemsNum: Int
    
    // 1. 正常的初始化方法
    public init(allItemsNum: Int, finishItemsNum: Int, curItemsNum: Int) {
        //self.errCode = errCode
        self.allItemsNum = allItemsNum
        self.finishItemsNum = finishItemsNum
        self.curItemsNum = curItemsNum
    }
    
    // 2. 手动实现解码逻辑（给默认值的关键）
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
//        // 如果 JSON 里没有 err_code，这里还是会抛出异常（因为它没有默认值，必须有）
//        self.errCode = try container.decode(Int.self, forKey: .errCode)
        
        // 使用 decodeIfPresent 读取，如果为 nil 则赋默认值 0
        self.allItemsNum = try container.decodeIfPresent(Int.self, forKey: .allItemsNum) ?? 0
        self.finishItemsNum = try container.decodeIfPresent(Int.self, forKey: .finishItemsNum) ?? 0
        self.curItemsNum = try container.decodeIfPresent(Int.self, forKey: .curItemsNum) ?? 0
        
        super.init()
    }

    public enum CodingKeys: String, CodingKey {
        //case errCode = "err_code"
        case allItemsNum = "all_items_num"
        case finishItemsNum = "finish_items_num"
        case curItemsNum = "cur_items_num"
    }
}

// MARK: - IDOBloodGlucoseDataInfoV1

@objcMembers
public class IDOBloodGlucoseDataInfoV1: NSObject, IDOBaseModel {
    
    /// 数据类型
    /// 1:固件上报历史血糖数据
    /// 2:设备结束监测
    public var dataType: Int
    
    private var historyInfoCount: Int
    
    /// 血糖CGM历史数据count 有数据传1，没数据传0
    public var historyInfo: IDOBloodGlucoseHistoryDataInfoV1?
    
    public init(dataType: Int, historyInfo: IDOBloodGlucoseHistoryDataInfoV1? = nil) {
        self.dataType = dataType
        self.historyInfo = historyInfo
        self.historyInfoCount = historyInfo != nil ? 1 : 0
    }
    
    public enum CodingKeys: String, CodingKey {
        case dataType = "data_type"
        case historyInfoCount = "history_info_count"
        case historyInfo = "history_info"
    }
}
