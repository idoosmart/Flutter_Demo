//
//  IDOAlgorithmRawDataModel.swift
//  protocol_channel
//
//  Created by hc on 10/28/25.
//

import Foundation


// 加速度计数据项
// MARK: - IDOAccDataItem
@objcMembers
public class IDOAccDataItem: NSObject, IDOBaseModel {
    
    // acc x轴(int16)
    public var x: Int16
    
    // acc y轴(int16)
    public var y: Int16
    
    // acc z轴(int16)
    public var z: Int16
    
    public init(x: Int16, y: Int16, z: Int16) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    public enum CodingKeys: String, CodingKey {
        case x
        case y
        case z
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            return String(data: jsonData, encoding: .utf8)
        }
        return nil
    }
}


// 光电容积图数据项
// MARK: - IDOPpgDataItem
@objcMembers
public class IDOPpgDataItem: NSObject, IDOBaseModel {
    
    // ppg绿光(uint32)
    public var green: UInt32
    
    // ppg红外光(uint32)
    public var infrared: UInt32
    
    // ppg红光(uint32)
    public var red: UInt32
    
    // MARK: - Initializer
    public init(green: UInt32, infrared: UInt32, red: UInt32) {
        self.green = green
        self.infrared = infrared
        self.red = red
    }
    
    // MARK: - CodingKeys
    public enum CodingKeys: String, CodingKey {
        case green
        case infrared
        case red
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            return String(data: jsonData, encoding: .utf8)
        }
        return nil
    }
}

// MARK: - IDOSensorInfo
@objcMembers
public class IDORawDataSensorInfoReply: NSObject, IDOBaseModel {
    
    // 开始或结束同步的时间
    public var year: Int
    public var month: Int
    public var day: Int
    public var hour: Int
    public var min: Int
    public var sec: Int
    
    /// 数据类型 1--ppg 2--acc
    public var dataType: Int
    
    // 采集频率
    public var frequency: Int
    
    // acc_data_count==0时，acc_data_item无效... 最大值：60
    internal var accDataCount: Int
    
    // ppg_data_count==0时，ppg_data_item无效... 最大值：30
    internal var ppgDataCount: Int
    
    // 预留字段
    //private var data: [Int] // uint8_t data[10]
    
    public var accDataItems: [IDOAccDataItem]?
    
    public var ppgDataItems: [IDOPpgDataItem]?
    
    // MARK: - Initializer
    public init(year: Int, month: Int, day: Int, hour: Int, min: Int, sec: Int, dataType: Int, frequency: Int, accDataCount: Int, ppgDataCount: Int, accDataItems: [IDOAccDataItem]?, ppgDataItems: [IDOPpgDataItem]?) {
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.min = min
        self.sec = sec
        self.dataType = dataType
        self.frequency = frequency
        self.accDataCount = accDataCount
        self.ppgDataCount = ppgDataCount
        //self.data = data
        self.accDataItems = accDataItems
        self.ppgDataItems = ppgDataItems
    }
    
    // MARK: - CodingKeys
    public enum CodingKeys: String, CodingKey {
        case year
        case month
        case day
        case hour
        case min
        case sec
        case dataType = "data_type"
        case frequency
        case accDataCount = "acc_data_count"
        case ppgDataCount = "ppg_data_count"
        //case data
        case accDataItems = "acc_data_items"
        case ppgDataItems = "ppg_data_items"
    }

    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            return String(data: jsonData, encoding: .utf8)
        }
        return nil
    }
}

// MARK: - IDOSensorConfig
@objcMembers
public class IDOSensorConfig: NSObject, IDOBaseModel {
    
    public var ppgSwitch: IDOAlgorithmSensorSwitch
    
    public var accSwitch: IDOAlgorithmSensorSwitch
    
    // 预留字段
    //public var data: [Int] // uint8_t data[10]
    
    // MARK: - Initializer
    public init(ppgSwitch: IDOAlgorithmSensorSwitch, accSwitch: IDOAlgorithmSensorSwitch) {
        self.ppgSwitch = ppgSwitch
        self.accSwitch = accSwitch
        //self.data = data
    }
    
    // MARK: - CodingKeys
    public enum CodingKeys: String, CodingKey {
        case ppgSwitch = "ppg_switch"
        case accSwitch = "acc_switch"
        //case data
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try container.decodeIfPresent(Int.self, forKey: .ppgSwitch) {
            ppgSwitch = IDOAlgorithmSensorSwitch(rawValue: value)!
        } else {
            ppgSwitch = .invalid
        }
        if let value = try container.decodeIfPresent(Int.self, forKey: .accSwitch) {
            accSwitch = IDOAlgorithmSensorSwitch(rawValue: value)!
        } else {
            accSwitch = .invalid
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(ppgSwitch.rawValue, forKey: .ppgSwitch)
        try container.encode(accSwitch.rawValue, forKey: .accSwitch)
    }

    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            return String(data: jsonData, encoding: .utf8)
        }
        return nil
    }
    
    private static func convertInternalToExternal(value: Int) -> Int {
        switch value {
        case 0xAA: return 1
        case 0x55: return 0
        case 0: return -1
        default: return -1
        }
    }
}


// MARK: - IDORawDataSensorConfigReply
@objcMembers
public class IDORawDataSensorConfigReply: NSObject, IDOBaseModel {
    
    // 版本号 0
    private var version: Int
    
    // 错误码
    public var errCode: Int
    
    // 0x00为无效,0x01为开始采集,0x02为数据采集中,0x03为结束采集,0x04为设置开关,0x05为查询开关
    internal var operate: Int
    
    // 开关配置信息count 通常为1
    internal var configCount: Int
    
    // 操作(5:查询开关)有效
    public var configItem: IDOSensorConfig?
    
    // MARK: - Initializer
    public init(errCode: Int, operate: Int, configItem: IDOSensorConfig?) {
        self.version = 0
        self.errCode = errCode
        self.operate = operate
        self.configCount = configItem != nil ? 1 : 0
        self.configItem = configItem
    }
    
    // MARK: - CodingKeys
    public enum CodingKeys: String, CodingKey {
        case version
        case errCode = "error_code"
        case operate
        case configCount = "config_count"
        case configItem = "config_items"
    }

    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            return String(data: jsonData, encoding: .utf8)
        }
        return nil
    }
}


// MARK: - IDOAlgorithmRawDataParam
@objcMembers 
internal class IDOAlgorithmRawDataParam: NSObject, IDOBaseModel {
    
    // 0x00为无效,0x01为开始采集,0x02为数据采集中,0x03为结束采集,0x04为设置开关,0x05为查询开关
    public var operate: Int
    
    // ppg开关: 0:无效 0xaa:打开 0x55:关闭
    public var ppgSwitch: Int
    
    // acc开关: 0:无效 0xaa:打开 0x55:关闭
    public var accSwitch: Int
    
    // 预留字段
    //public var data: [Int] // uint8_t data[10]
    
    // MARK: - Initializer (构造方法)
    public init(operate: Int, ppgSwitch: Int, accSwitch: Int) {
        self.operate = operate
        self.ppgSwitch = ppgSwitch
        self.accSwitch = accSwitch
        //self.data = data
    }
    
    // MARK: - CodingKeys
    public enum CodingKeys: String, CodingKey {
        case operate
        case ppgSwitch = "ppg_switch"
        case accSwitch = "acc_switch"
        //case data
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            return String(data: jsonData, encoding: .utf8)
        }
        return nil
    }
}

@objc
public enum IDOAlgorithmSensorSwitch: Int {
    case `invalid` = -1
    case open = 1
    case close = 0
}
