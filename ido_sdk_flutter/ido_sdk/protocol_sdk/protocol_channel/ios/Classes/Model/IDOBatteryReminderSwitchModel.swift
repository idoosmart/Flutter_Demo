import Foundation

/// 设备电量提醒开关获取返回
@objcMembers
public class IDOBatteryReminderSwitchModel: NSObject, IDOBaseModel {
    /// 1：开启；0：关闭；0xFF：无效/未知
    public var lowBatteryOnOff: Int

    enum CodingKeys: String, CodingKey {
        case lowBatteryOnOff = "low_battery_on_off"
    }

    public init(lowBatteryOnOff: Int) {
        self.lowBatteryOnOff = lowBatteryOnOff
    }

    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            return String(data: jsonData, encoding: .utf8)
        }
        return nil
    }
}

