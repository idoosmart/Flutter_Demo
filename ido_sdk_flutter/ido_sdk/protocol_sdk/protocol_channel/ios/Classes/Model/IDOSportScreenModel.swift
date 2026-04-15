//
//  IDOSportScreenModel.swift
//  protocol_channel
//
//  Created by hc on 2025/3/11.
//

import Foundation

// MARK: - IDOSportScreenParamModel
@objcMembers
public class IDOSportScreenParamModel: NSObject, IDOBaseModel {
    private var version: Int = 4
    /// 0x01查询基础信息--支持的所有运动类型,支持的屏幕布局配置信息
    /// 0x02查询基础信息--运动类型支持的数据项和数据子项，最多支持同时查询23个
    /// 0x03查询详情信息, 最多支持2个同时查询
    /// 0x04编辑, 最多支持2个同时编辑
    public var operate: Int = 0
    var sportNum: Int = 0
    public var sportItems: [IDOSportScreenSportItemModel]?
    
    public init(operate: Int, sportItems: [IDOSportScreenSportItemModel]?) {
        self.version = 4
        self.operate = operate
        self.sportNum = sportItems?.count ?? 0
        self.sportItems = sportItems
    }
    
    enum CodingKeys: String, CodingKey {
        case version
        case operate
        case sportNum = "sport_num"
        case sportItems = "sport_item"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        version = try container.decodeIfPresent(Int.self, forKey: .version) ?? 4
        operate = try container.decodeIfPresent(Int.self, forKey: .operate) ?? 0
        if let value = try container.decodeIfPresent([IDOSportScreenSportItemModel].self, forKey: .sportItems) {
            sportNum = value.count
            sportItems = value
        } else {
            sportNum = 0
            sportItems = nil
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(version, forKey: .version)
        try container.encode(operate, forKey: .operate)
        try container.encode(sportItems?.count ?? 0, forKey: .sportNum)
        try container.encode(sportItems, forKey: .sportItems)
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

@objcMembers
public class IDOSportScreenSportItemModel: NSObject, Codable {
    /// 运动类型
    public var sportType: Int = 0
    var screenNum: Int = 0
    public var screenItems: [IDOSportScreenItemModel]?
    
    public init(sportType: Int, screenItems: [IDOSportScreenItemModel]? = nil) {
        self.sportType = sportType
        self.screenNum = screenItems?.count ?? 0
        self.screenItems = screenItems
    }
    
    enum CodingKeys: String, CodingKey {
        case sportType = "sport_type"
        case screenNum = "screen_num"
        case screenItems = "screen_item"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sportType = try container.decodeIfPresent(Int.self, forKey: .sportType)!
        if let value = try container.decodeIfPresent([IDOSportScreenItemModel].self, forKey: .screenItems) {
            screenNum = value.count
            screenItems = value
        } else {
            screenNum = 0
            screenItems = nil
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sportType, forKey: .sportType)
        try container.encode(screenItems?.count ?? 0, forKey: .screenNum)
        try container.encode(screenItems, forKey: .screenItems)
    }
}

@objcMembers
public class IDOSportScreenItemModel: NSObject, Codable {
    /// 已配置的数据项数量，已配置的数据项最大个数15
    var dataItemCount: Int = 0
    public var dataItem: [IDOSportScreenDataItemModel]?
    
    public init(dataItem: [IDOSportScreenDataItemModel]?) {
        self.dataItemCount = dataItem?.count ?? 0
        self.dataItem = dataItem
    }
    
    enum CodingKeys: String, CodingKey {
        case dataItemCount = "data_item_count"
        case dataItem = "data_item"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try container.decodeIfPresent([IDOSportScreenDataItemModel].self, forKey: .dataItem) {
            dataItemCount = value.count
            dataItem = value
        } else {
            dataItemCount = 0
            dataItem = nil
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(dataItem?.count ?? 0, forKey: .dataItemCount)
        try container.encode(dataItem, forKey: .dataItem)
    }
}

@objcMembers
public class IDOSportScreenDataItemModel: NSObject, Codable {
    public var dataType: IDODataType = .none
    
    /// 当前选中的数据项子项，正常取值范围:0~15； 无效值：0XFF，表示没有选择任何子选项
    public var dataSubType: IDODataSubType = .none
    
    enum CodingKeys: String, CodingKey {
        case dataType = "data_type"
        case dataSubType = "data_sub_type"
    }
    public init(dataType:IDODataType,subType:IDODataSubType){
        self.dataType=dataType
        self.dataSubType=subType
    }
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try container.decodeIfPresent(Int.self, forKey: .dataType) {
            dataType = IDODataType(rawValue: value) ?? .none
        } else {
            dataType = .none
        }
        
        if let value = try container.decodeIfPresent(Int.self, forKey: .dataSubType) {
            dataSubType = IDODataSubType.combineBytes(highByte: UInt8(dataType.rawValue), lowByte: 0x1 << value) ?? .none
        } else {
            dataSubType = .none
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(dataType.rawValue, forKey: .dataType)
        try container.encode(findLeftShiftBits(n: dataSubType.rawValue & 0xFF), forKey: .dataSubType)
    }
    
    func findLeftShiftBits(n: Int) -> Int {
        // 检查 n 是否为正整数且是 2 的幂次
        guard n > 0 && (n & (n - 1)) == 0 else {
            return 0 // 不符合条件返回 nil
        }
        // 计算二进制中尾随零的数量（即左移位数）
        return n.trailingZeroBitCount
    }
}


// MARK: - IDOSportScreenModel

@objcMembers
public class IDOSportScreenInfoReplyModel: NSObject, IDOBaseModel {
    private var version: Int = 4
    public var errCode: Int = 0
    
    /// 0x01查询基础信息--支持的所有运动类型,支持的屏幕布局配置信息
    /// 0x02查询基础信息--运动类型支持的数据项和数据子项，最多支持同时查询23个
    /// 0x03查询详情信息, 最多支持2个同时查询
    /// 0x04编辑, 最多支持2个同时编辑
    public var operate: Int = 0
    
    /// 最小数据项显示个数
    public var minDataNum: Int = 0
    
    /// 最大数据项显示个数
    public var maxDataNum: Int = 0
    
    /// 最小屏幕显示个数
    public var minScreenNum: Int = 0
    
    /// 最大屏幕显示个数
    public var maxScreenNum: Int = 0
    
    var sportNum: Int = 0
    var screenConfNum: Int = 0
    //public var data: [Int]?
    public var sportItems: [IDOSportScreenItemReply]?
    
    /// 获取屏幕信息，查基础使用，查详情返回NULL
    public var screenConfItems: [IDOSportScreenLayoutType]?
    public var specialDataItems:[IDOSportScreenDataItemModel]?
    var specialDataItemCount: Int = 0
    
    public init(errCode: Int, operate: Int, minDataNum: Int, maxDataNum: Int, minScreenNum: Int, maxScreenNum: Int, sportItems: [IDOSportScreenItemReply]? = nil, screenConfItems: [IDOSportScreenLayoutType]? = nil, specialDataItems: [IDOSportScreenDataItemModel]? = nil) {
        self.version = 4
        self.errCode = errCode
        self.operate = operate
        self.minDataNum = minDataNum
        self.maxDataNum = maxDataNum
        self.minScreenNum = minScreenNum
        self.maxScreenNum = maxScreenNum
        self.sportNum = sportItems?.count ?? 0
        self.screenConfNum = screenConfItems?.count ?? 0
        //self.data = data
        self.sportItems = sportItems
        self.screenConfItems = screenConfItems
        self.specialDataItems = specialDataItems
        self.specialDataItemCount = specialDataItems?.count ?? 0
    }
    
    enum CodingKeys: String, CodingKey {
        case version
        case errCode = "err_code"
        case operate
        case minDataNum = "min_data_num"
        case maxDataNum = "max_data_num"
        case minScreenNum = "min_screen_num"
        case maxScreenNum = "max_screen_num"
        case sportNum = "sport_num"
        case screenConfNum = "screen_conf_num"
        //case data
        case sportItems = "sport_item"
        case screenConfItems = "screen_conf"
        case specialDataItems = "speical_data_item"
        case specialDataItemCount = "special_data_item_count"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        version = try container.decodeIfPresent(Int.self, forKey: .version)!
        errCode = try container.decodeIfPresent(Int.self, forKey: .errCode)!
        operate = try container.decodeIfPresent(Int.self, forKey: .operate)!
        minDataNum = try container.decodeIfPresent(Int.self, forKey: .minDataNum)!
        maxDataNum = try container.decodeIfPresent(Int.self, forKey: .maxDataNum)!
        minScreenNum = try container.decodeIfPresent(Int.self, forKey: .minScreenNum)!
        maxScreenNum = try container.decodeIfPresent(Int.self, forKey: .maxScreenNum)!
        
        if let value = try container.decodeIfPresent([IDOSportScreenItemReply].self, forKey: .sportItems) {
            sportNum = value.count
            sportItems = value
        } else {
            sportNum = 0
            sportItems = nil
        }
        
        if let value = try container.decodeIfPresent([IDOSportScreenLayoutType].self, forKey: .screenConfItems) {
            screenConfNum = value.count
            screenConfItems = value
        } else {
            screenConfNum = 0
            screenConfItems = nil
        }
        
        if let value = try container.decodeIfPresent([IDOSportScreenDataItemModel].self, forKey: .specialDataItems) {
            specialDataItemCount = value.count
            specialDataItems = value
        } else {
            specialDataItemCount = 0
            specialDataItems = nil
        }
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(version, forKey: .version)
        try container.encode(errCode, forKey: .errCode)
        try container.encode(operate, forKey: .operate)
        try container.encode(minDataNum, forKey: .minDataNum)
        try container.encode(maxDataNum, forKey: .maxDataNum)
        try container.encode(minScreenNum, forKey: .minScreenNum)
        try container.encode(maxScreenNum, forKey: .maxScreenNum)
        try container.encode(sportItems, forKey: .sportItems)
        try container.encode(sportItems?.count ?? 0, forKey: .sportNum)
        try container.encode(screenConfItems, forKey: .screenConfItems)
        try container.encode(screenConfItems?.count ?? 0, forKey: .screenConfNum)
        try container.encode(specialDataItems, forKey: .specialDataItems)
        try container.encode(specialDataItems?.count ?? 0, forKey: .specialDataItemCount)
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}

@objcMembers
public class IDOSportScreenItemReply: NSObject, Codable {
    public var sportType: Int = 0
    var screenNum: Int = 0
    var supportDataTypeNum: Int = 0
    public var screenItems: [IDOSportScreenItemModel]?
    public var supportDataTypes: [IDOSportScreenDataType]?
    
    public init(sportType: Int, screenItems: [IDOSportScreenItemModel]? = nil, supportDataTypes: [IDOSportScreenDataType]? = nil) {
        self.sportType = sportType
        self.screenNum = screenItems?.count ?? 0
        self.supportDataTypeNum = supportDataTypes?.count ?? 0
        self.screenItems = screenItems
        self.supportDataTypes = supportDataTypes
    }
    
    enum CodingKeys: String, CodingKey {
        case sportType = "sport_type"
        case screenNum = "screen_num"
        case supportDataTypeNum = "support_data_type_num"
        case screenItems = "screen_item"
        case supportDataTypes = "support_data_type"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sportType = try container.decodeIfPresent(Int.self, forKey: .sportType)!
        if let value = try container.decodeIfPresent([IDOSportScreenItemModel].self, forKey: .screenItems) {
            screenNum = value.count
            screenItems = value
        } else {
            screenNum = 0
            screenItems = nil
        }
        if let value = try container.decodeIfPresent([IDOSportScreenDataType].self, forKey: .supportDataTypes) {
            supportDataTypeNum = value.count
            supportDataTypes = value
        } else {
            supportDataTypeNum = 0
            supportDataTypes = nil
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sportType, forKey: .sportType)
        try container.encode(screenItems?.count ?? 0, forKey: .screenNum)
        try container.encode(screenItems, forKey: .screenItems)
        try container.encode(supportDataTypes?.count ?? 0, forKey: .supportDataTypeNum)
        try container.encode(supportDataTypes, forKey: .supportDataTypes)
    }
}

@objcMembers
public class IDOSportScreenDataType: NSObject, Codable {
    public var dataType: IDODataType = .none
    public var dataValue: [IDODataSubType] = []
    private var dataValueRaw: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case dataType = "data_type"
        case dataValue = "data_value"
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try container.decodeIfPresent(Int.self, forKey: .dataType) {
            dataType = IDODataType(rawValue: value) ?? .none
        }
        
        if let value = try container.decodeIfPresent(Int.self, forKey: .dataValue) {
            var items = [IDODataSubType]()
            dataValueRaw = value
            for i in 0..<8 {
                let bit = (value >> i) & 1
                if bit == 1, let subType = IDODataSubType.combineBytes(highByte: UInt8(dataType.rawValue), lowByte: 1 << i) {
                    items.append(subType)
                }
            }
            dataValue = items
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(dataType.rawValue, forKey: .dataType)
        try container.encode(dataValueRaw, forKey: .dataValue)
    }
}

@objcMembers
public class IDOSportScreenLayoutType: NSObject, Codable {
    public var layoutType: Int = 0
    public var style: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case layoutType = "layout_type"
        case style
    }
}

/// 数据项类型
@objc public enum IDODataType: Int, Codable {
    case none = 0x00
    /// 总响应时间
    case overallResponseTime = 0x01
    /// 距离类
    case distance = 0x02
    /// 海拔类
    case elevation = 0x03
    /// 配速类
    case pace = 0x04
    /// 速度类
    case speed = 0x05
    /// 心率类
    case heartRate = 0x06
    /// 功率类
    case power = 0x07
    /// 步频类
    case cadence = 0x08
    /// 跑步类
    case runningEconomy = 0x09
    /// 跑步健身类
    case runningFitness = 0x0A
    /// 时间类
    case time = 0x0B
    /// 其他类
    case other = 0x0C
}


/// 数据子选项项类型
@objc public enum IDODataSubType: Int, Codable {
    case none = 0x0000

    // overall response time (总响应时间)
    case overallResponseTimeOverall = 0x0101

    // Distance (距离类) - 0x02
    // Total_Distance 距离
    case distanceTotalDistance = 0x0201
    // Current_Lap_Distance 圈距
    case distanceCurrentLapDistance = 0x0202
    // Last_Lap_Distance 最后一圈距离
    case distanceLastLapDistance = 0x0204

    // Elevation (海拔类) - 0x03
    // Elevation 海拔
    case elevationElevation = 0x0301
    // Total_Ascent 总上升高度
    case elevationTotalAscent = 0x0302
    // Lap_Ascent 上升圈数
    case elevationLapAscent = 0x0304
    // Last_lap_ascent 最后一圈爬升
    case elevationLastLapAscent = 0x0308
    // Total_descent 总下降
    case elevationTotalDescent = 0x0310
    // Lap_descent 下降圈数
    case elevationLapDescent = 0x0320
    // Last_lap_descent 最后一圈下降
    case elevationLastLapDescent = 0x0340
    // Grade 级别
    case elevationGrade = 0x0380

    // Pace (配速类) - 0x04
    // Pace 当前配速
    case pacePace = 0x0401
    // Average_pace 平均配速
    case paceAveragePace = 0x0402
    // Lap_pace 单圈配速
    case paceLapPace = 0x0404
    // Last_lap_pace 最后一圈配速
    case paceLastLapPace = 0x0408
    // Effort_pace 努力配速
    case paceEffortPace = 0x0410
    // Average_effort_pace 平均努力配速
    case paceAverageEffortPace = 0x0420
    // Lap_effort_pace 单圈努力配速
    case paceLapEffortPace = 0x0440

    // Speed (速度类) - 0x05
    // Speed 当前速度
    case speedCurrentSpeed = 0x0501
    // Average_Speed 平均速度
    case speedAverageSpeed = 0x0502
    // Maximum_Speed 最大速度
    case speedMaximumSpeed = 0x0504
    // Lap_Speed 单圈速度
    case speedLapSpeed = 0x0508
    // Last_Lap_Speed 最后一圈速度
    case speedLastLapSpeed = 0x0510
    // Vertical_Speed 垂直速度
    case speedVerticalSpeed = 0x0520
    // Average_vertical_Speed 平均垂直速度
    case speedAverageVerticalSpeed = 0x0540
    // Lap_vertical_Speed 单圈垂直速度
    case speedLapVerticalSpeed = 0x0580

    // Heart rate(HR) (心率类) - 0x06
    // Heart_rate 心率
    case heartRateHeartRate = 0x0601
    // Heart_rate_zone 心率区
    case heartRateHeartRateZone = 0x0602
    // Average_heart_rate 平均心率
    case heartRateAverageHeartRate = 0x0604
    // Max_heart_rate 最大心率
    case heartRateMaxHeartRate = 0x0608
    // Lap_heart_rate 单圈心率
    case heartRateLapHeartRate = 0x0610
    // Last_lap_heart_rate 最后一圈心率
    case heartRateLastLapHeartRate = 0x0620
    // heart_rate_reserve 心率储备
    case heartRateHeartRateReserve = 0x0640

    // Power (功率类) - 0x07
    // Power 功率
    case powerPower = 0x0701
    // Average_Power 平均功率
    case powerAveragePower = 0x0702
    // Lap_power 单圈功率
    case powerLapPower = 0x0704
    // 3s_average_power 3 秒平均功率
    case power3sAveragePower = 0x0708
    // 10s_average_power 10s 平均功率
    case power10sAveragePower = 0x0710
    // 30s_average_power 30 秒平均功率
    case power30sAveragePower = 0x0720

    // Cadence (步频类) - 0x08
    // Cadence 步频
    case cadenceCadence = 0x0801
    // Average_cadence 平均步频
    case cadenceAverageCadence = 0x0802
    // Lap_cadence 圈步频
    case cadenceLapCadence = 0x0804
    // Last_lap_cadence 最后一圈节奏
    case cadenceLastLapCadence = 0x0808

    // running Economy (跑步类) - 0x09
    // Stride_length 步幅
    case runningEconomyStrideLength = 0x0901
    // Average_stride_length 平均步幅
    case runningEconomyAverageStrideLength = 0x0902
    // lap_strido_length 单圈歩幅
    case runningEconomyLapStridoLength = 0x0904

    // running fitness (跑步健身类) - 0x0A
    // Training_load 训练负荷
    case runningFitnessTrainingLoad = 0x0A01
    // Aerobic_training_effect 有氧训练效果
    case runningFitnessAerobicTrainingEffect = 0x0A02
    // Anaerobic_training_efect 无氧训练效果
    case runningFitnessAnaerobicTrainingEfect = 0x0A04
    // Calorie 卡路里
    case runningFitnessCalorie = 0x0A08

    // Time (时间类) - 0x0B
    // Activity_time 活动时间
    case timeActivityTime = 0x0B01
    // Total_time 总时间
    case timeTotalTime = 0x0B02
    // Current_time 当前本地时间
    case timeCurrentTime = 0x0B04
    // Time_to_sunrise_sunset 日出 / 日落时间
    case timeTimeToSunriseSunset = 0x0B08
    // Lap_time 单圈时间
    case timeLapTime = 0x0B10
    // Last_lap_time 最后一圈时间
    case timeLastLapTime = 0x0B20

    // other (其他类) - 0x0C
    // VO2max 最大摄氧量
    case otherVO2max = 0x0C01
    // Battery_level 电池电量
    case otherBatteryLevel = 0x0C02
    // Battery_life_based_on_soc 基于剩余电量的电池寿命
    case otherBatteryLifeBasedOnSoc = 0x0C04
}

fileprivate extension IDODataSubType {
    
    func extractValues() -> (UInt8, UInt8) {
        let rawValue = self.rawValue
        let highByte = UInt8((rawValue & 0xFF00) >> 8)
        let lowByte = UInt8(rawValue & 0x00FF)
        return (highByte, lowByte)
    }
    
    static func combineBytes(highByte: UInt8, lowByte: UInt8) -> IDODataSubType? {
        let combinedValue = (UInt16(highByte) << 8) | UInt16(lowByte)
        return IDODataSubType(rawValue: Int(combinedValue))
    }
}

