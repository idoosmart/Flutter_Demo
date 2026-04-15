//
//  IDOActivitySwitchModel.swift
//  protocol_channel
//
//  Created by hc on 2023/10/12.
//

import Foundation

/// Get event number for activity switch
@objcMembers
public class IDOActivitySwitchModel: NSObject, IDOBaseModel {
    /// 0 for success
    /// non-zero for error
    public var errCode: Int
    /// Auto identify walking switch: 0 for off, 1 for on, -1 for not supported
    public var autoIdentifySportWalk: Int
    /// Auto identify running switch: 0 for off, 1 for on, -1 for not supported
    public var autoIdentifySportRun: Int
    /// Auto identify cycling switch: 0 for off, 1 for on, -1 for not supported
    public var autoIdentifySportBicycle: Int
    /// Auto pause switch: 0 for off, 1 for on, -1 for not supported
    public var autoPauseOnOff: Int
    /// End reminder switch: 0 for off, 1 for on, -1 for not supported
    public var autoEndRemindOnOffOnOff: Int
    /// Auto identify elliptical switch: 0 for off, 1 for on, -1 for not supported
    public var autoIdentifySportElliptical: Int
    /// Auto identify rowing switch: 0 for off, 1 for on, -1 for not supported
    public var autoIdentifySportRowing: Int
    /// Auto identify swimming switch: 0 for off, 1 for on, -1 for not supported
    public var autoIdentifySportSwim: Int
    /// Auto identify smart rope switch: 0 for off, 1 for on, -1 for not supported
    public var autoIdentifySportSmartRope: Int

    enum CodingKeys: String, CodingKey {
        case errCode = "err_code"
        case autoIdentifySportWalk = "auto_identify_sport_walk"
        case autoIdentifySportRun = "auto_identify_sport_run"
        case autoIdentifySportBicycle = "auto_identify_sport_bicycle"
        case autoPauseOnOff = "auto_pause_on_off"
        case autoEndRemindOnOffOnOff = "auto_end_remind_on_off_on_off"
        case autoIdentifySportElliptical = "auto_identify_sport_elliptical"
        case autoIdentifySportRowing = "auto_identify_sport_rowing"
        case autoIdentifySportSwim = "auto_identify_sport_swim"
        case autoIdentifySportSmartRope = "auto_identify_sport_smart_rope"
    }

    public init(errCode: Int, autoIdentifySportWalk: Int, autoIdentifySportRun: Int, autoIdentifySportBicycle: Int, autoPauseOnOff: Int, autoEndRemindOnOffOnOff: Int, autoIdentifySportElliptical: Int, autoIdentifySportRowing: Int, autoIdentifySportSwim: Int, autoIdentifySportSmartRope: Int) {
        self.errCode = errCode
        self.autoIdentifySportWalk = autoIdentifySportWalk
        self.autoIdentifySportRun = autoIdentifySportRun
        self.autoIdentifySportBicycle = autoIdentifySportBicycle
        self.autoPauseOnOff = autoPauseOnOff
        self.autoEndRemindOnOffOnOff = autoEndRemindOnOffOnOff
        self.autoIdentifySportElliptical = autoIdentifySportElliptical
        self.autoIdentifySportRowing = autoIdentifySportRowing
        self.autoIdentifySportSwim = autoIdentifySportSwim
        self.autoIdentifySportSmartRope = autoIdentifySportSmartRope
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
public class IDOActivitySwitchParamModel: NSObject, IDOBaseModel {
    /// Automatic recognition of walking switch 0 off 1 on
    /// Function table: getAutoActivitySetGetUseNewStructExchange
    public var autoIdentifySportWalk: Int
    /// Automatic recognition of running switch 0 off 1 on
    /// Function table: getAutoActivitySetGetUseNewStructExchange
    public var autoIdentifySportRun: Int
    /// Automatically identify bicycle switch 0 off 1 on
    /// Function table: getAutoActivitySetGetUseNewStructExchange
    public var autoIdentifySportBicycle: Int
    /// Motion auto-pause 0 off 1 on
    /// Function table: getAutoActivitySetGetUseNewStructExchange
    public var autoPauseOnOff: Int
    /// End reminder 0 off 1 on
    /// Function table: getAutoActivitySetGetUseNewStructExchange
    public var autoEndRemindOnOffOnOff: Int
    /// Automatically identify the elliptical machine switch 0 off 1 on
    /// Function table: getAutoActivitySetGetUseNewStructExchange
    public var autoIdentifySportElliptical: Int
    /// Automatically identify rowing machine switch 0 off 1 on
    /// Function table: getAutoActivitySetGetUseNewStructExchange
    public var autoIdentifySportRowing: Int
    /// Automatic recognition of swimming switch 0 off 1 on
    /// Function table: getAutoActivitySetGetUseNewStructExchange
    public var autoIdentifySportSwim: Int
    /// Automatically identify smart rope skipping switch 0 off 1 on
    /// Function table: getAutoActivitySetGetUseNewStructExchange
    public var autoIdentifySportSmartRope: Int
    
    enum CodingKeys: String, CodingKey {
        case autoIdentifySportWalk = "auto_identify_sport_walk"
        case autoIdentifySportRun = "auto_identify_sport_run"
        case autoIdentifySportBicycle = "auto_identify_sport_bicycle"
        case autoPauseOnOff = "auto_pause_on_off"
        case autoEndRemindOnOffOnOff = "auto_end_remind_on_off_on_off"
        case autoIdentifySportElliptical = "auto_identify_sport_elliptical"
        case autoIdentifySportRowing = "auto_identify_sport_rowing"
        case autoIdentifySportSwim = "auto_identify_sport_swim"
        case autoIdentifySportSmartRope = "auto_identify_sport_smart_rope"
    }
    
    public init(autoIdentifySportWalk: Int, autoIdentifySportRun: Int, autoIdentifySportBicycle: Int, autoPauseOnOff: Int, autoEndRemindOnOffOnOff: Int, autoIdentifySportElliptical: Int, autoIdentifySportRowing: Int, autoIdentifySportSwim: Int, autoIdentifySportSmartRope: Int) {
        self.autoIdentifySportWalk = autoIdentifySportWalk
        self.autoIdentifySportRun = autoIdentifySportRun
        self.autoIdentifySportBicycle = autoIdentifySportBicycle
        self.autoPauseOnOff = autoPauseOnOff
        self.autoEndRemindOnOffOnOff = autoEndRemindOnOffOnOff
        self.autoIdentifySportElliptical = autoIdentifySportElliptical
        self.autoIdentifySportRowing = autoIdentifySportRowing
        self.autoIdentifySportSwim = autoIdentifySportSwim
        self.autoIdentifySportSmartRope = autoIdentifySportSmartRope
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
