//
//  CmdImpl.swift
//  protocol_channel
//
//  Created by hc on 2023/7/18.
//

import Foundation

private var _cmd: Cmd? {
    return SwiftProtocolChannelPlugin.shared.cmd
}

private var _bind: Bind? {
    return SwiftProtocolChannelPlugin.shared.bind
}

private var _tool: Tool? {
    return SwiftProtocolChannelPlugin.shared.tools
}

class CmdImpl: IDOCmdInterface {
    private(set) var isBinding: Bool = false
    
    func make<T>(_ anyCmd: AnyCmd<T>) -> AnyCmd<T> {
        return anyCmd
    }
    
    func bind(osVersion: Int, onDeviceInfo: ((IDODeviceInterface) -> ())?, onFuncTable: ((IDOFuncTableInterface) -> ())?, completion: @escaping (IDOBindStatus) -> ()) {
        DeviceDelegateImpl.shared.callbackDeviceInfo = onDeviceInfo
        FuncTableDelegateImpl.shared.callbackFuncTable = onFuncTable
        isBinding = true
        _runOnMainThread {
            _bind?.bind(osVersion: Int64(osVersion)) { [weak self] status in
                self?.isBinding = false
                completion(IDOBindStatus(rawValue: Int(status))!)
            }
        }
    }
    
    func appMarkBindResult(success: Bool) {
        _runOnMainThread {
            _bind?.appMarkBindResult(success: success, completion: { })
        }
    }
    
    func cancelBind() {
        _runOnMainThread {
            _bind?.cancelBind { [weak self] in
                self?.isBinding = false
            }
        }
    }
    
    func unbind(macAddress: String, isForceRemove: Bool, completion: @escaping (Bool) -> ()) {
        _runOnMainThread {
            _bind?.unbind(macAddress: macAddress, isForceRemove: isForceRemove, completion: completion)
        }
    }
    
    func setAuthCode(code: String, osVersion: Int, completion: @escaping (Bool) -> ()) {
        _runOnMainThread {
            _bind?.setAuthCode(code: code, osVersion: Int64(osVersion), completion: completion)
        }
    }
    
    func setV2CallEvt(contactText: String, phoneNumber: String, completion: @escaping (Bool) -> ()) {
        _runOnMainThread {
            _tool?.setV2CallEvt(contactText: contactText, phoneNumber: phoneNumber, completion: { rs in
                completion(rs == 0)
            })
        }
    }
    
    func setV2NoticeEvt(type: NoticeMessageType, contactText: String, phoneNumber: String, dataText: String, completion: @escaping (Bool) -> ()) {
        _runOnMainThread {
            _tool?.setV2NoticeEvt(type: type.rawValue.int64, contactText: contactText, phoneNumber: phoneNumber, dataText: dataText, completion: { rs in
                completion(rs == 0)
            })
        }
    }
    
    func stopV2CallEvt(completion: @escaping (Bool) -> ()) {
        _runOnMainThread {
            _tool?.stopV2CallEvt(completion: { rs in
                completion(rs == 0)
            })
        }
    }
    
    func missedV2MissedCallEvt(completion: @escaping (Bool) -> ()) {
        _runOnMainThread {
            _tool?.missedV2MissedCallEvt(completion: { rs in
                completion(rs == 0)
            })
        }
    }
    
    func listenReceiveAlgorithmRawData(rawDataReply: @escaping (IDORawDataSensorInfoReply) -> Void) -> Void {
        BridgeDelegateImpl.shared.callbackRawDataSensorInfoReply = rawDataReply
    }
    
    fileprivate func cancel(token: CancelToken) {
        _runOnMainThread {
            _cmd?.cancelSend(cancelToken: token) {}
        }
    }
}

// MARK: - AnyCmd、CmdError、CmdCancellable

struct AnyCmd<T>: IDOCmdProtocol {
    private let _send: (@escaping IDOCmdResponse<T>) -> IDOCancellable
    
    public init<U: IDOCmdProtocol>(_ fetchable: U) where U.DataType == T {
        _send = fetchable.send
    }
    
    @discardableResult public func send(completion: @escaping IDOCmdResponse<T>) -> IDOCancellable {
        return _send(completion)
    }
}

/// 错误
@objcMembers
public class CmdError: NSObject, Error {
    /// 错误码
    ///  ```
    ///  0 Successful command
    ///  1 SVC handler is missing
    ///  2 SoftDevice has not been enabled
    ///  3 Internal Error
    ///  4 No Memory for operation
    ///  5 Not found
    ///  6 Not supported
    ///  7 Invalid Parameter
    ///  8 Invalid state, operation disallowed in this state
    ///  9 Invalid Length
    ///  10 Invalid Flags
    ///  11 Invalid Data
    ///  12 Invalid Data size
    ///  13 Operation timed out
    ///  14 Null Pointer
    ///  15 Forbidden Operation
    ///  16 Bad Memory Address
    ///  17 Busy
    ///  18 Maximum connection count exceeded.
    ///  19 Not enough resources for operation
    ///  20 Bt Bluetooth upgrade error
    ///  21 Not enough space for operation
    ///  22 Low Battery
    ///  23 Invalid File Name/Format
    ///  24 空间够但需要整理
    ///  25 空间整理中
    ///
    ///  当指令发出前异常时:
    /// -1 取消
    /// -2 失败
    /// -3 指令已存在队列中
    /// -4 设备断线
    /// -5 指令被中断(由于发出的指令不能被实际取消，故存在修改指令被中断后可能还会导致设备修改生效的情况)
    /// -6 未连接设备
    /// -99 json解析失败
    /// ```
    public let code: Int
    public let message: String?
    
    public lazy var isOK: Bool = code == 0
    
    public init(code: Int = -2, message: String? = nil) {
        self.code = code
        guard let msg = message else {
            self.message = {
                switch code {
                case 0: return "Successful command"
                case 1: return "SVC handler is missing"
                case 2: return "SoftDevice has not been enabled"
                case 3: return "Internal Error"
                case 4: return "No Memory for operation"
                case 5: return "Not found"
                case 6: return "Not supported"
                case 7: return "Invalid Parameter"
                case 8: return "Invalid state, operation disallowed in this state"
                case 9: return "Invalid Length"
                case 10: return "Invalid Flags"
                case 11: return "Invalid Data"
                case 12: return "Invalid Data size"
                case 13: return "Operation timed out"
                case 14: return "Null Pointer"
                case 15: return "Forbidden Operation"
                case 16: return "Bad Memory Address"
                case 17: return "Busy"
                case 18: return "Maximum connection count exceeded."
                case 19: return "Not enough resources for operation"
                case 20: return "Bt Bluetooth upgrade error"
                case 21: return "Not enough space for operation"
                case 22: return "Low Battery"
                case 23: return "Invalid File Name/Format"
                case 24: return "空间够但需要整理"
                case 25: return "空间整理中"
                case -1: return "取消"
                case -2: return "失败"
                case -3: return "指令已存在队列中"
                case -4: return "设备断线"
                case -5: return "指令被中断(由于发出的指令不能被实际取消，故存在修改指令被中断后可能还会导致设备修改生效的情况)"
                case -6: return "未连接设备"
                case -99: return "json解析失败"
                default: return ""
                }
            }()
            return
        }
        self.message = msg
    }
}

class CmdCancellable: IDOCancellable {
    var isCancelled = false
    let token: String?
    
    init(token: String? = nil) {
        self.token = token
    }
    
    func cancel() {
        isCancelled = true
        guard token != nil else {
            return
        }
        _runOnMainThread {
            _cmd?.cancelSend(cancelToken: CancelToken(token: self.token)) {}
        }
    }
}

// MARK: -

@objc
public enum NoticeMessageType: Int {
    case sms = 0x01
    case email = 0x02
    case wx = 0x03
    case qq = 0x04
    case weibo = 0x05
    case facebook = 0x06
    case twitter = 0x07
    case whatsapp = 0x08
    case messenger = 0x09
    case instagram = 0x0a
    case linkedin = 0x0b
    case calendar = 0x0c
    case skype = 0x0d
    case alarm = 0x0e
    case vkontakte = 0x10
    case line = 0x11
    case viber = 0x12
    case kakao_talk = 0x13
    case gmail = 0x14
    case outlook = 0x15
    case snapchat = 0x16
    case telegram = 0x17
    case chatwork = 0x20
    case slack = 0x21
    case tumblr = 0x23
    case youtube = 0x24
    case pinterest_yahoo = 0x25
    case tiktok = 0x26
    case redbus = 0x27
    case dailyhunt = 0x28
    case hotstar = 0x29
    case inshorts = 0x2a
    case paytm = 0x2b
    case amazon = 0x2c
    case flipkart = 0x2d
    case prime = 0x2e
    case netflix = 0x2f
    case gpay = 0x30
    case phonpe = 0x31
    case swiggy = 0x32
    case zomato = 0x33
    case makemytrip = 0x34
    case jiotv = 0x35
    case keep = 0x36
}

// MARK: - 基础指令实现

private protocol CmdProtocolParam {
    var evtType: ApiEvtType { get }
    var json: String? { get }
}

private struct InnerCmdProtocolParam: CmdProtocolParam {
    var evtType: ApiEvtType
    var json: String?
    
    init(evtType: ApiEvtType, json: String?, priority: IDOCmdPriority = .normal) {
        self.evtType = evtType
        self.json = json ?? "{}"
    }
}

public struct Cmds {
    /// 获取SN信息 返回 sn
    /// Get SN information Return sn
    public struct getSn: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getSnInfo
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<String>) -> IDOCancellable {
            return Cmds._parseJson(self) { code, dic in
                guard code == 0 else {
                    completion(.failure(CmdError(code: code, message: nil)))
                    return
                }
                guard let obj = dic else {
                    completion(.success(nil))
                    return
                }
                completion(.success(obj["sn"] as? String))
            }
        }
    }
    
    /// 获取bt蓝牙名称
    /// Get bt bluetooth name
    public struct getBtName: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getBtName
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<String>) -> IDOCancellable {
            return Cmds._parseJson(self) { code, dic in
                guard code == 0 else {
                    completion(.failure(CmdError(code: code, message: nil)))
                    return
                }
                guard let obj = dic else {
                    completion(.success(nil))
                    return
                }
                completion(.success(obj["bt_name"] as? String))
            }
        }
    }
    
    /// 获得实时数据
    /// Get Real-time Data event number
    public struct getLiveData: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getLiveData
        var json: String?
        /// 0：无功能 1：强制打开心率监测 2：强制打开血压监测
        /// 0: No function 1: force on the heart rate monitor 2: force on the blood pressure monitor
        public init(flag: Int) {
            self.json = ["flag": flag].toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOLiveDataModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取错误记录
    /// Get error record
    public struct getErrorRecord: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getErrorRecord
        var json: String?
        private let type: Int
        /// 0 查询 1 清除记录
        /// 0 Query 1 Clear records
        public init(type: Int) {
            self.type = type
            self.json = ["type": type].toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOErrorRecordModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取HID信息
    /// Get HID Information event number
    public struct getHidInfo: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getHidInfo
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<Bool>) -> IDOCancellable {
            return Cmds._parseJson(self) { code, dic in
                guard code == 0 else {
                    completion(.failure(CmdError(code: code, message: nil)))
                    return
                }
                guard let obj = dic else {
                    completion(.success(nil))
                    return
                }
                completion(.success(obj["is_start"] as? Int == 1))
            }
        }
    }
    
    /// 获取gps信息
    /// Get GPS Information event number
    public struct getGpsInfo: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getGpsInfo
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOGpsInfoModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取版本信息
    /// Get version information event number
    public struct getVersionInfo: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getVersionInfo
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOVersionInfoModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取mtu信息
    /// Get MTU Information event number
    public struct getMtuInfo: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getMtuInfo
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOMtuInfoModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取所有的健康监测开关
    /// Get event number for all health monitoring switches
    public struct getAllHealthSwitchState: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getAllHealthSwitchState
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOAllHealthSwitchStateModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取gps状态
    /// Get GPS Status event number
    public struct getGpsStatus: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getGpsStatus
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOGpsStatusModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取固件不可删除的快捷应用列表
    /// Get non-deletable menu list in firmware event number
    public struct getUnerasableMeunList: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getUnerasableMeunList
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOUnerasableMeunListModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 运动模式自动识别开关获取
    /// Get event number for activity switch
    public struct getActivitySwitch: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getActivitySwitch
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOActivitySwitchModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设备电量提醒开关获取
    /// Get event number for battery reminder switch
    public struct getBatteryReminderSwitch: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getBatteryReminderSwitch
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOBatteryReminderSwitchModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }

    /// 获取宠物信息
    /// Get pet info event number
    public struct getPetInfo: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getPetInfo
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOPetInfoModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取红点提醒开关
    /// Get unread app reminder switch event number
    public struct getUnreadAppReminder: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getUnreadAppReminder
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdGetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取字库信息
    /// Get Font Library Information event number
    public struct getFlashBinInfo: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getFlashBinInfo
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOFlashBinInfoModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 查询bt配对开关、连接、a2dp连接、hfp连接状态(仅支持带bt蓝牙的设备)
    /// Query BT pairing switch, connection, A2DP connection, HFP connection status (Only Supported on devices with BT Bluetooth) event number
    public struct getBtNotice: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getBtNotice
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOBtNoticeModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取抬腕数据
    /// Get wrist up gesture data event number
    public struct getUpHandGesture: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getUpHandGesture
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOUpHandGestureModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取表盘id
    /// Get watch ID event number
    public struct getWatchDialId: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getWatchDialId
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOWatchDialIdModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取勿扰模式状态
    /// Get Do Not Disturb mode status event number
    public struct getNotDisturbStatus: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getNotDisturbStatus
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDONotDisturbStatusModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取设置的卡路里/距离/中高运动时长 主界面
    /// Get Set Calorie/Distance/Mid-High Sport Time Goal event number
    public struct getMainSportGoal: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getMainSportGoal
        var json: String?
        /// 0: Invalid 1: Daily goal 2: Weekly goal
        public init(timeGoalType: Int) {
            self.json = ["time_goal_type": timeGoalType].toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOMainSportGoalModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取血压算法三级版本号信息事件号
    /// Get blood pressure algorithm version information event number
    public struct getBpAlgVersion: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getBpAlgVersion
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOBpAlgVersionModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取屏幕亮度
    /// Get screen brightness event number
    public struct getScreenBrightness: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getScreenBrightness
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOScreenBrightnessModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取热启动参数
    /// Get Hot Start Parameters event number
    public struct getHotStartParam: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getHotStartParam
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOHotStartParamModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取固件支持的详情最大设置数量
    /// Get maximum number of settings supported by firmware event number
    public struct getSupportMaxSetItemsNum: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getSupportMaxSetItemsNum
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOSupportMaxSetItemsNumModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取走动提醒
    /// Get walk reminder event number
    public struct getWalkRemind: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getWalkRemind
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOWalkRemindModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取全天步数目标
    /// Get daily step goal event number
    public struct getStepGoal: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getStepGoal
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOStepGoalModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取手表名字
    /// Get device name event number
    public struct getDeviceName: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getDeviceName
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<String>) -> IDOCancellable {
            return Cmds._parseJson(self) { code, dic in
                guard code == 0 else {
                    completion(.failure(CmdError(code: code, message: nil)))
                    return
                }
                guard let obj = dic else {
                    completion(.success(nil))
                    return
                }
                completion(.success(obj["dev_name"] as? String))
            }
        }
    }
    
    /// 获取固件本地保存联系人文件修改时间
    /// Get firmware local contact file modification time event number
    public struct getContactReviseTime: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getContactReviseTime
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOContactReviseTimeModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取设备升级状态
    /// Get device update status event number
    public struct getUpdateStatus: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getUpdateStatus
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOUpdateStatusModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取压力值
    /// Get stress value event number
    public struct getStressVal: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getStressVal
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOStressValModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取心率监测模式
    /// Get Heart Rate Monitoring Mode event number
    public struct getHeartRateMode: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getHeartRateMode
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOHeartRateModeModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取电池信息
    /// Get battery information event number
    public struct getBatteryInfo: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getBatteryInfo
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOBatteryInfoModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取设备的日志状态
    /// Get device log state event number
    public struct getDeviceLogState: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getDeviceLogState
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDODeviceLogStateModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 手机音量下发给ble
    /// Set phone volume for device event number
    public struct setBleVoice: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setBleVoice
        var json: String?
        public init(_ param: IDOBleVoiceParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置控制gps
    /// Control GPS event number
    public struct setGpsControl: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setGpsControl
        var json: String?
        public init(_ param: IDOGpsControlParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOGpsControlModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 智能心率模式设置
    /// Set Smart Heart Rate Mode Event
    public struct setHeartRateModeSmart: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setHeartRateModeSmart
        var json: String?
        public init(_ param: IDOHeartRateModeSmartParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置压力校准
    /// Set Stress Calibration Event Code
    public struct setStressCalibration: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setStressCalibration
        var json: String?
        public init(_ param: IDOStressCalibrationParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOStressCalibrationModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置洗手提醒
    /// Set Hand Washing Reminder Event
    public struct setHandWashingReminder: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setHandWashingReminder
        var json: String?
        public init(_ param: IDOHandWashingReminderParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置运动目标
    /// Set exercise goal event
    public struct setSportGoal: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setSportGoal
        var json: String?
        public init(_ param: IDOSportGoalParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置天气数据
    /// Set weather data event number
    public struct setWeatherData: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setWeatherData
        var json: String?
        public init(_ param: IDOWeatherDataParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 未读信息红点提示开关
    /// Unread message reminder switch event number
    public struct setUnreadAppReminder: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setUnreadAppReminder
        var json: String?
        public init(open: Bool) {
            self.json = ["on_off": open ? 1 : 0].toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 手机app通过这个命令开关，实现通知应用状态设置
    /// Notification app status setting event
    public struct setNotificationStatus: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setNotificationStatus
        var json: String?
        public init(_ param: IDONotificationStatusParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置科学睡眠开关
    /// Scientific sleep switch setting event
    public struct setScientificSleepSwitch: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setScientificSleepSwitch
        var json: String?
        public init(_ param: IDOScientificSleepSwitchParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 血压校准
    /// Blood pressure calibration event number
    public struct setBpCalibration: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setBpCalibration
        var json: String?
        public init(_ param: IDOBpCalibrationParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOBpCalibrationModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置防丢
    /// Set Lost Find Event
    public struct setLostFind: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setLostFind
        var json: String?
        public init(_ param: IDOLostFindParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置表盘 （废弃）
    /// Set watch face event number
    public struct setWatchDial: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setWatchDial
        var json: String?
        public init(_ param: IDOWatchDialParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置天气开关
    /// Set weather switch event number
    public struct setWeatherSwitch: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setWeatherSwitch
        var json: String?
        public init(open: Bool) {
            self.json = ["on_off": open ? 1 : 0].toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置单位
    /// Set Unit event number
    public struct setUnit: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setUnit
        var json: String?
        public init(_ param: IDOUnitParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置寻找手机
    /// Set Find Phone
    public struct setFindPhone: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setFindPhone
        var json: String?
        public init(open: Bool) {
            self.json = ["on_off": open ? 1 : 0].toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取下载语言支持
    /// Get Download Language Support
    public struct getDownloadLanguage: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getDownLanguage
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDODownloadLanguageModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置停止寻找手机
    /// Stop Find Phone
    public struct setOverFindPhone: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setOverFindPhone
        var json: String?
        public init(open: Bool) {
            self.json = ["states": 1].toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取设备支持的列表
    /// Get Supported Menu List
    public struct getMenuList: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getMenuList
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOMenuListModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置一键呼叫
    /// Set the one-touch calling event number
    public struct setOnekeySOS: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setOnekeySOS
        var json: String?
        /// - Parameters:
        ///   - open: on / off
        ///   - phoneType: 0: Invalid  1: Doro phone  2: Non-Doro phone
        public init(open: Bool, phoneType: Int) {
            self.json = [
                "on_off": open ? 1 : 0,
                "phone_type": phoneType
            ].toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置运动模式选择
    /// Set sport mode select event number
    public struct setSportModeSelect: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setSportModeSelect
        var json: String?
        public init(_ param: IDOSportModeSelectParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置运动模式排序
    /// Set Sport Mode Sorting
    public struct setSportModeSort: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setSportModeSort
        var json: String?
        public init(items: [IDOSportModeSortParamModel]) {
            var list = [[String: Any]]()
            for item in items {
                guard let jsonData = try? JSONEncoder().encode(item) else { continue }
                guard let dic = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else { continue }
                list.append(dic)
            }
            self.json = ["items": list].toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置久坐
    /// Set Long Sit Event
    public struct setLongSit: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setLongSit
        var json: String?
        public init(_ param: IDOLongSitParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置心率模式
    /// Set Heart Rate Mode Event
    public struct setHeartRateMode: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setHeartRateMode
        var json: String?
        public init(_ param: IDOHeartRateModeParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置身体电量开关
    /// Set body power switch event number
    public struct setBodyPowerTurn: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setBodyPowerTurn
        var json: String?
        public init(open: Bool) {
            self.json = ["on_off": open ? 1 : 0].toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置呼吸率开关
    /// Respiration rate switch setting event
    public struct setRRespiRateTurn: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setRRespiRateTurn
        var json: String?
        public init(open: Bool) {
            self.json = ["on_off": open ? 1 : 0].toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 环境音量的开关和阀值
    /// Set Environmental Noise Volume On/Off and Threshold Event
    public struct setV3Noise: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setV3Noise
        var json: String?
        public init(_ param: IDOV3NoiseParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置日出日落时间
    /// Set sunrise and sunset time event number
    public struct setWeatherSunTime: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setWeatherSunTime
        var json: String?
        public init(_ param: IDOWeatherSunTimeParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置快捷方式
    /// Set shortcut
    public struct setShortcut: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setShortcut
        var json: String?
        public init(_ param: IDOShortcutParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取通知中心开关
    /// Get notification center status event number
    public struct getNoticeStatus: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getNoticeStatus
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOSetNoticeStatusModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置通知中心
    /// Set Notification Center Event
    public struct setNoticeStatus: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setNotificationCenter
        var json: String?
        public init(_ param: IDOSetNoticeStatusModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDONotificationCenterModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置夜间体温开关
    /// Set Night-time Temperature Switch Event Code
    public struct setTemperatureSwitch: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setTemperatureSwitch
        var json: String?
        public init(_ param: IDOTemperatureSwitchParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置睡眠时间段
    /// Set sleep period event
    public struct setSleepPeriod: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setSleepPeriod
        var json: String?
        public init(_ param: IDOSleepPeriodParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置抬手亮屏
    /// Raise-to-wake gesture event number
    public struct setUpHandGesture: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setUpHandGesture
        var json: String?
        public init(_ param: IDOUpHandGestureParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置吃药提醒
    /// Set Taking Medicine Reminder Event Code
    public struct setTakingMedicineReminder: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setTakingMedicineReminder
        var json: String?
        public init(_ param: IDOTakingMedicineReminderParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置血氧开关
    /// Set SpO2 switch event
    public struct setSpo2Switch: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setSpo2Switch
        var json: String?
        public init(_ param: IDOSpo2SwitchParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置天气城市名称
    /// Set weather city name event number
    public struct setWeatherCityName: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setWeatherCityName
        var json: String?
        public init(cityName: String) {
            self.json = [
                "version": 0,
                "city_name": cityName
            ].toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// app获取ble的闹钟
    /// Getting Alarms for V3APP Devices
    public struct getAlarm: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getAlarmV3
        var json: String?
        var priority: IDOCmdPriority = .normal
        /// Flag for getting alarms
        /// 0: Get all alarms
        /// 1: Get alarms modified by the device notification
        public init(flag: Int, priority: IDOCmdPriority = .normal) {
            self.json = ["flag": flag].toJsonString()
            self.priority = priority
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOAlarmModel>) -> IDOCancellable {
            return Cmds._parseModel(self, priority: priority, completion: completion)
        }
    }
    
    /// app设置ble的闹钟
    /// Getting Alarms for V3APP Devices
    public struct setAlarm: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setAlarmV3
        var json: String?
        public init(alarm: IDOAlarmModel) {
            self.json = alarm.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取用户习惯信息
    /// Get User Habit Information in V3
    public struct getHabitInfo: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getHabitInfoV3
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOHabitInfoModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 健身指导
    /// Fitness Guidance Event
    public struct setFitnessGuidance: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setFitnessGuidance
        var json: String?
        public init(_ param: IDOFitnessGuidanceParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 显示模式
    /// Display mode event number
    public struct setDisplayMode: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setDisplayMode
        var json: String?
        public init(_ param: IDODisplayModeParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 血压测量
    /// Blood pressure measurement event number
    public struct setBpMeasurement: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setBpMeasurement
        var json: String?
        public init(_ param: IDOBpMeasurementParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOBpMeasurementModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 单项测量 | Single Measurement
    private struct setSingleMeasurement: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setBpMeasurement
        var json: String?
        init(type: IDOMeasurementType, action: IDOMeasurementAction) {
            let dic = [type.jsonKey: action.rawValue]
            if let data = try? JSONSerialization.data(withJSONObject: dic, options: []),
               let jsonString = String(data: data, encoding: .utf8) {
                self.json = jsonString
            }
        }
        
        @discardableResult func send(completion: @escaping IDOCmdResponse<IDOMeasurementModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 音乐开关
    /// Set Music On/Off Event
    public struct setMusicOnOff: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setMusicOnOff
        var json: String?
        public init(_ param: IDOMusicOnOffParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// app下发跑步计划(运动计划)
    /// App issued running plan (exercise plan) event number
    public struct setSendRunPlan: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setSendRunPlan
        var json: String?
        public init(_ param: IDORunPlanParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOSendRunPlanModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// v3 下发v3天气协议
    /// Send the v3 weather protocol event number under v3
    public struct setWeatherV3: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setWeatherV3
        var json: String?
        public init(_ param: IDOWeatherV3ParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取固件的歌曲名和文件夹
    /// Get Firmware Song Names and Folders
    public struct getBleMusicInfo: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getBleMusicInfo
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOMusicInfoModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 控制音乐
    /// Music control event number
    public struct musicControl: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .musicControl
        var json: String?
        public init(_ param: IDOMusicControlParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 操作歌曲或者文件夹
    /// Operation for songs or folders event
    public struct setMusicOperate: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setMusicOperate
        var json: String?
        public init(_ param: IDOMusicOpearteParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOMusicOperateModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 通知消息提醒
    /// Notification message reminder event number
    public struct noticeMessageV3: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .noticeMessageV3
        var json: String?
        public init(_ param: IDONoticeMessageParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置消息通知状态
    /// Setting Notification Status for a Single App
    public struct setNoticeMessageState: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setNoticeMessageState
        var json: String?
        public init(_ param: IDONoticeMessageStateParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDONoticeMessageStateModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 动态消息通知
    /// V3 dynamic notification message event number
    public struct setNoticeAppName: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setNoticeAppName
        var json: String?
        public init(_ param: IDONoticeMesaageParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 下发v3世界时间
    /// v3 set v3 world time
    public struct setWorldTimeV3: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setWorldTimeV3
        var json: String?
        private let count: Int
        public init(_ param: [IDOWorldTimeParamModel]) {
            self.count = param.count
            var list = [[String: Any]]()
            for item in param {
                guard let jsonData = try? JSONEncoder().encode(item) else { continue }
                guard let dic = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else { continue }
                list.append(dic)
            }
            self.json = [
                "version": 2,
                "items_num": self.count,
                "items": list
            ].toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            guard count <= 10 else {
                completion(.failure(CmdError(code: -2, message: "Number of clocks, send all clocks at a time Max 10")))
                return CmdCancellable()
            }
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置日程提醒
    /// Schedule Reminder
    public struct setSchedulerReminder: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setSchedulerReminderV3
        var json: String?
        public init(_ param: IDOSchedulerReminderParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOSchedulerReminderModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取屏幕信息
    /// Get Screen Information
    public struct getWatchDialInfo: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getWatchDialInfo
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOWatchDialInfoModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 血压校准控制
    /// Blood Pressure Calibration Control
    public struct setBpCalControlV3: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setBpCalControlV3
        var json: String?
        /// - Parameters:
        ///   - operate: 0: Invalid
        ///   1: Start blood pressure calibration
        ///   2: Stop blood pressure calibration
        ///   3: Get feature vector information
        ///   - filePath: The file path to save the raw data obtained during firmware blood pressure calibration
        ///     Path includes file name (../../blood.txt)
        ///     Valid when operate=1
        public init(operate: Int, filePath: String) {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOBpCalControlModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置表盘
    /// Set Watch Face
    public struct setWatchFaceData: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setWatchFaceData
        var json: String?
        public init(_ param: IDOWatchFaceParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOWatchFaceModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 同步常用联系人
    /// Synchronization Protocol Bluetooth Call Common Contacts
    public struct setSyncContact: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setSyncContact
        var json: String?
        public init(_ param: IDOSyncContactParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOSyncContactModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取表盘列表 v3
    /// Getting watch face list for V3 (New)
    public struct getWatchListV3: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getWatchListV3
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOWatchListModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取表盘列表 v2
    /// Get Watch Face List in V2
    public struct getWatchListV2: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getWatchFaceList
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOWatchListV2Model>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置运动子项数据排列
    /// Set and Query Sports Sub-item Data Sorting
    public struct setSportParamSort: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setBaseSportParamSortV3
        var json: String?
        public init(_ param: IDOSportSortParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOSportSortModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 新的100种运动排序
    /// Set and Query 100 Sports Sorting
    public struct setSport100Sort: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .set100SportSortV3
        var json: String?
        public init(_ param: IDOSport100SortParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOSport100SortModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置主界面控件排序
    /// Setting and Query Sorting of Main UI Controls
    public struct setMainUISortV3: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setMainUISortV3
        var json: String?
        public init(_ param: IDOMainUISortParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOMainUISortModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 经期的历史数据下发
    /// Menstrual historical data delivery event number
    public struct setHistoricalMenstruation: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getHistoricalMenstruation
        var json: String?
        public init(_ param: IDOHistoricalMenstruationParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取语言库列表
    /// Get Language Library List
    public struct getLanguageLibrary: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getLanguageLibraryDataV3
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOLanguageLibraryModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取固件本地提示音文件信息
    /// Getting firmware local beep file information for V3
    public struct getBleBeep: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getBleBeepV3
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOBleBeepModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置运动城市名称
    /// V3 Setting the Name of a Sports City event number
    public struct setLongCityNameV3: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setLongCityNameV3
        var json: String?
        /// City name Maximum 74 bytes
        public init(cityName: String) {
            self.json = [
                "version": 0,
                "name": cityName
            ].toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// V3设置心率模式
    /// Set Heart Rate Mode V3
    public struct setHeartMode: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setHeartMode
        var json: String?
        public init(_ param: IDOHeartModeParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOHeartModeModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 语音回复文本
    /// V3 voice reply text event number
    public struct setVoiceReplyText: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setVoiceReplyTxtV3
        var json: String?
        public init(_ param: IDOVoiceReplyParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置表盘顺序
    /// Set watch dial sort event
    public struct setWatchDialSort: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setWatchDialSort
        var json: String?
        public init(_ param: IDOWatchDialSortParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置多个走动提醒的时间点
    /// Set multiple walk reminder times event number
    public struct setWalkRemindTimes: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setWalkRemindTimes
        var json: String?
        public init(_ param: IDOWalkRemindTimesParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置壁纸表盘列表
    /// Set wallpaper dial list event number
    public struct setWallpaperDialReply: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setWallpaperDialReplyV3
        var json: String?
        public init(_ param: IDOWallpaperDialReplyV3ParamModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOWallpaperDialReplyV3Model>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置时间， 不指定参数将使用当前时间
    /// Set the time. If no reference is specified, the current time will be used.
    public struct setDateTime: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setTime
        var json: String?
        public init(_ param: IDODateTimeParamModel? = nil) {
            self.json = param?.toJsonString() ?? "{}"
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置用户信息
    /// Set user information
    public struct setUserInfo: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setUserInfo
        var json: String? = "{}"
        public init(_ param: IDOUserInfoPramModel) {
            self.json = param.toJsonString()
        }

        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 重启设备
    ///  Reboot the device
    public struct reboot: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .reboot
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 恢复出厂设置
    /// Factory reset
    public struct factoryReset: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .factoryReset
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 关机
    /// Shutdown
    public struct shutdown: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .shutdown
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 控制寻找设备开始
    /// Control search device start
    public struct findDeviceStart: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .findDeviceStart
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 控制寻找设备结束
    /// Control finding device ends
    public struct findDeviceStop: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .findDeviceStop
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 开始拍照 (app -> ble)
    /// Start taking photos (app -> ble)
    public struct photoStart: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .photoStart
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 结束拍照 (app -> ble)
    /// End photo taking (app -> ble)
    public struct photoStop: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .photoStop
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置左右手
    /// Set up left and right hands
    public struct setHand: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setHand
        var json: String?
        /// 0：左手 1：右手
        public init(isRightHand: Bool) {
            self.json = [
                "hand": isRightHand ? 1 : 0
            ].toJsonString()
        }

        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置屏幕亮度
    /// Set screen brightness
    public struct setScreenBrightness: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setScreenBrightness
        var json: String?
        public init(_ param: IDOScreenBrightnessModel) {
            self.json = param.toJsonString()
        }

        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 进入升级模式
    /// Enter upgrade mode
    public struct otaStart: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .otaStart
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdOTAResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置心率区间
    /// Set heart rate zone
    public struct setHeartRateInterval: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setHeartRateInterval
        var json: String?
        public init(_ param: IDOHeartRateIntervalModel) {
            self.json = param.toJsonString()
        }

        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置卡路里和距离目标(设置日常三环)
    /// Set calorie and distance goals (set daily three rings)
    public struct setCalorieDistanceGoal: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setCalorieDistanceGoal
        var json: String?
        public init(_ param: IDOMainSportGoalModel) {
            self.json = param.toJsonString()
        }

        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置走动提醒
    /// Set reminders to move around
    public struct setWalkRemind: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setWalkRemind
        var json: String?
        public init(_ param: IDOWalkRemindModel) {
            self.json = param.toJsonString()
        }

        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置经期
    /// Set menstrual period
    public struct setMenstruation: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setMenstruation
        var json: String?
        public init(_ param: IDOMenstruationModel) {
            self.json = param.toJsonString()
        }

        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取默认的运动类型
    /// Get the default motion type
    public struct getDefaultSportType: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getDefaultSportType
        var json: String? = "{}"
        public init() {}

        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDODefaultSportTypeModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置喝水提醒
    /// Set Drink Water Reminder
    public struct setDrinkWaterRemind: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setDrinkWaterRemind
        var json: String?
        public init(_ param: IDODrinkWaterRemindModel) {
            self.json = param.toJsonString()
        }

        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置经期提醒
    /// Set Menstrual Reminder
    public struct setMenstruationRemind: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setMenstruationRemind
        var json: String?
        public init(_ param: IDOMenstruationRemindParamModel) {
            self.json = param.toJsonString()
        }

        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置压力开关
    /// Set Pressure Switch
    public struct setStressSwitch: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setStressSwitch
        var json: String?
        public init(_ param: IDOStressSwitchParamModel) {
            self.json = param.toJsonString()
        }

        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置语音助手开关
    /// Setting Voice Assistant Switch
    public struct setVoiceAssistantOnOff: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setVoiceAssistantOnOff
        var json: String?
        /// 0：关 1：开
        public init(isOpen: Bool) {
            self.json = [
                "on_off": isOpen ? 1 : 0
            ].toJsonString()
        }

        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置勿扰模式
    /// Set do not disturb mode
    public struct setNotDisturb: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setNotDisturb
        var json: String?
        public init(_ param: IDONotDisturbParamModel) {
            self.json = param.toJsonString()
        }

        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置菜单列表
    /// Settings menu list
    public struct setMenuList: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setMenuList
        var json: String?
        public init(_ param: IDOMenuListParamModel) {
            self.json = param.toJsonString()
        }

        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置运动类型排序
    /// Set sport type sorting
    public struct setSportSortV3: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setSportSortV3
        var json: String?
        public init(_ param: IDOSportParamModel) {
            self.json = param.toJsonString()
        }

        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置固件来电快捷回复开关
    /// Set the firmware quick reply switch for incoming calls
    public struct setCallQuickReplyOnOff: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setCallQuickReplyOnOff
        var json: String?
        public init(isOpen: Bool) {
            self.json = [
                "on_off": isOpen ? 1 : 0
            ].toJsonString()
        }

        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取运动默认的类型 V3
    /// Get the default type of motion V3
    public struct getSportTypeV3: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getSportTypeV3
        var json: String? = "{}"
        public init() {}

        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDODefaultSportTypeModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取BT连接手机型号
    /// Get BT connected mobile phone model
    public struct getBtConnectPhoneModel: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getBtConnectPhoneModel
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<String>) -> IDOCancellable {
            return Cmds._parseJson(self) { code, dic in
                guard code == 0 else {
                    completion(.failure(CmdError(code: code, message: nil)))
                    return
                }
                guard let obj = dic else {
                    completion(.success(nil))
                    return
                }
                completion(.success(obj["phone_model"] as? String))
            }
        }
    }
    
    /// 设置运动模式识别开关
    /// Set the sports mode recognition switch
    public struct setActivitySwitch: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setActivitySwitch
        var json: String?
        public init(_ param: IDOActivitySwitchParamModel) {
            self.json = param.toJsonString()
        }

        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设备电量提醒开关设置
    /// Battery reminder switch event number
    public struct setBatteryReminderSwitch: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setBatteryReminderSwitch
        var json: String?
        public init(_ param: IDOBatteryReminderSwitchParamModel) {
            self.json = param.toJsonString()
        }

        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOBatteryReminderSwitchReplyModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }

    /// 设置宠物信息
    /// Set pet info event number
    public struct setPetInfo: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setPetInfo
        var json: String?
        public init(_ param: IDOPetInfoParamModel) {
            self.json = param.toJsonString()
        }

        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOPetInfoReplyModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 控制音乐开始
    /// Control music start
    public struct musicStart: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .musicStart
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 控制音乐停止
    /// Control music stop
    public struct musicStop: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .musicStop
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// APP下发配对结果
    /// The APP delivers the pairing result
    public struct sendBindResult: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .sendBindResult
        var json: String?
        public init(isSuccess: Bool) {
            self.json = [
                "bind_result": isSuccess ? 0 : 1
            ].toJsonString()
        }

        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取单位
    /// Get Unit event number
    public struct getUnit: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getUnit
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOUnitModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置热启动参数
    /// Set hot boot parameters
    public struct setHotStartParam: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setHotStartParam
        var json: String?
        public init(_ param: IDOGpsHotStartParamModel) {
            self.json = param.toJsonString()
        }

        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    
    /// 获取智能心率模式
    /// Get Smart Heart Rate Mode
    public struct getSmartHeartRateMode: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getHeartRateModeSmart
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOHeartRateModeSmartModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取血氧开关
    /// Get blood oxygen switch
    public struct getSpo2Switch: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getSpo2Switch
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOSpo2SwitchModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取压力开关
    /// Get the pressure switch
    public struct getStressSwitch: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getStressSwitch
        var json: String? = "{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOStressSwitchModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置默认的消息应用列表
    /// Set the default messaging app list
    public struct setDefaultMsgList: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setDefaultMsgList
        var json: String? = "{}"
        public init(_ param: IDODefaultMessageConfigParamModel) {
            self.json = param.toJsonString()
        }
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDODefaultMessageConfigModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 操作小程序信息（获取、启动、删除）
    /// Operation of applet information (obtain, start, delete)
    public struct setAppleControl: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setAppletControl
        var json: String?
        public init(_ param: IDOAppletControlModel) {
            self.json = param.toJsonString()
        }
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOAppletInfoModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取固件算法文件信息（ACC/GPS）
    /// Get firmware algorithm file information (ACC/GPS)
    public struct getAlgFileInfo: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getAlgFile
        var json: String? = "{\"operate\":1,\"type\":0,\"version\":0}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOAlgFileModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 请求固件算法文件信息（ACC/GPS）
    /// Request firmware algorithm file information (ACC/GPS)
    public struct rquestAlgFile: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getAlgFile
        var json: String?
        /// 1:ACC文件、2:GPS文件
        public init(type: Int) {
            self.json = [
                "type": type,
                "operate": 2,
                "version": 0
            ].toJsonString()
        }
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    // 内部使用
    private struct innerGetSportScreenDetailInfo: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setSportScreen
        var json: String?
        public init(_ param: [IDOSportScreenSportItemModel], operate: Int) {
            self.json = IDOSportScreenParamModel(operate: operate, sportItems: param).toJsonString()!
        }
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOSportScreenInfoReplyModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }

    /// 获取运动中屏幕显示详情信息
    public struct getSportScreenDetailInfo: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setSportScreen
        var json: String?
        private var param: [IDOSportScreenSportItemModel]
        private var cancellers = [IDOCancellable]()
        
        public init(_ param: [IDOSportScreenSportItemModel]) {
            self.param = param
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOSportScreenInfoReplyModel>) -> IDOCancellable {
            let canceller = InnerCmdCanceller()
            let cancelOpt2 = innerGetSportScreenDetailInfo(param, operate: 2).send { resOpt2 in
                if case .success(let valOpt2) = resOpt2 {
                    let cancelOpt3 = innerGetSportScreenDetailInfo(param, operate: 3).send { resOpt3 in
                        if case .success(let valOpt3) = resOpt3 {
                            let itOpt2SportItems = valOpt2?.sportItems
                            let itOpt3SportItems = valOpt3?.sportItems
                            do {
                                // 使用 guard 处理可选值和空数组检查
                                guard let sportItems2 = itOpt2SportItems,
                                      let sportItems3 = itOpt3SportItems,
                                      !sportItems2.isEmpty,
                                      !sportItems3.isEmpty,
                                      sportItems3.count == sportItems2.count else {
                                    throw NSError(domain: "InvalidData", code: 1) // 或直接 return
                                }
                                
                                // 执行映射操作
                                valOpt3!.sportItems = sportItems3.map { it3 in
                                    let modified = it3
                                    // 使用 first(where:) 查找匹配项
                                    if let matchedItem = sportItems2.first(where: { $0.sportType == it3.sportType }) {
                                        modified.supportDataTypes = matchedItem.supportDataTypes ?? []
                                    } else {
                                        modified.supportDataTypes = []
                                    }
                                    modified.supportDataTypeNum = modified.supportDataTypes?.count ?? 0
                                    return modified
                                }
                                valOpt3!.specialDataItems = valOpt2?.specialDataItems
                                valOpt3!.specialDataItemCount = valOpt2?.specialDataItemCount ?? 0
                            } catch {
                                #if DEBUG
                                // 异常处理（Swift 中需要明确错误类型）
                                print("Parse sporting screen Error occurred: \(error)")
                                #endif
                            }
                            completion(.success(valOpt3))
                        }else {
                            completion(.failure(CmdError()))
                        }
                    }
                    canceller.cancellers.append(cancelOpt3)
                }else {
                    completion(.failure(CmdError()))
                }
            }
            canceller.cancellers.append(cancelOpt2)
            return canceller
        }
    }
    
    /// 获取运动中屏幕显示基础信息
    public struct getSportScreenBaseInfo: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setSportScreen
        var json: String?
        public init() {
            self.json = IDOSportScreenParamModel(operate: 1, sportItems: nil).toJsonString()!
        }
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOSportScreenInfoReplyModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置运动中屏幕显示
    public struct setSportScreen: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setSportScreen
        var json: String?
        public init(_ param: [IDOSportScreenSportItemModel]) {
            self.json = IDOSportScreenParamModel(operate: 4, sportItems: param).toJsonString()!
        }
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置APP基本信息
    public struct setAppBaseInfo: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setAppBaseInfo
        var json: String?
        public init(_ param: IDOAppInfoModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }

    /// 运动中设置提示音开关
    public struct setDuringExercise: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setDuringExercise
        var json: String?
        public init(_ param: IDOSettingsDuringExerciseModel) {
            self.json = param.toJsonString()
        }
        
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取左右手佩戴设置
    public struct getLeftRightWearSettings: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getLeftRightWearSettings
        var json: String? = "{}"
        public init() { }
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOLeftRightWearModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取运动中设置提示音开关
    public struct getSettingsDuringExercise: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getSettingsDuringExercise
        var json: String? = "{}"
        public init() { }
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOSettingsDuringExerciseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    
    /// 查询运动中提醒
    public struct getSportingRemindSetting: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setSportingRemindSetting
        var json: String?
        public init(_ param: [Int]) {
            self.json = IDOSportingRemindSettingParamModel(operate: IDOSportingRemindSettingParamModel.QUERY, sportTypes: param).toJsonString()!
        }
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOSportingRemindSettingReplyModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置运动中提醒项
    public struct setSportingRemindSetting: IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setSportingRemindSetting
        var json: String?
        public init(_ param: [IDOSportingRemindSettingModel]) {
            self.json = IDOSportingRemindSettingParamModel(operate: IDOSportingRemindSettingParamModel.SET, settingItems: param).toJsonString()!
        }
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    //简单心率区间设置
    public struct setSimpleHeartRateZone : IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setSimpleHeartRateZone
        var json: String?
        public init(_ param: IDOSimpleHeartRateZoneSettingModel) {
            self.json = param.toJsonString()!
        }
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }

    // 查询心率区间
    public struct getSimpleHeartRateZone : IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getSimpleHeartRateZone
        var json: String?="{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOSimpleHeartRateZoneSettingModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 获取用户信息
    public struct getUserInfo : IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .getUserInfo
        var json: String?="{}"
        public init() {}
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOUserInfoPramModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 更新当前血糖数据
    public struct uploadBloodGlucoseCurrentData : IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .uploadBloodGlucose
        var json: String?
        public init(_ param: IDOBloodGlucoseCurrentInfo) {
            // operate - 1:当前血糖数据 2:血糖统计数据 3:血糖CGM历史数据
            self.json = IDOBloodGlucoseModel(operate: 1, currentInfoItem: param, statisticsInfoItem: nil, historyInfoItem: nil).toJsonString()!
        }
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 更新血糖统计数据
    public struct uploadBloodGlucoseStatisticsData : IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .uploadBloodGlucose
        var json: String?
        public init(_ param: IDOBloodGlucoseStatisticsInfo) {
            // operate - 1:当前血糖数据 2:血糖统计数据 3:血糖CGM历史数据
            self.json = IDOBloodGlucoseModel(operate: 2, currentInfoItem: nil, statisticsInfoItem: param, historyInfoItem: nil).toJsonString()!
        }
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 更新血糖CGM历史数据
    public struct uploadBloodGlucoseHistoryData : IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .uploadBloodGlucose
        var json: String?
        public init(_ param: IDOBloodGlucoseHistoryDataInfo) {
            // operate - 1:当前血糖数据 2:血糖统计数据 3:血糖CGM历史数据
            self.json = IDOBloodGlucoseModel(operate: 3, currentInfoItem: nil, statisticsInfoItem: nil, historyInfoItem: param).toJsonString()!
        }
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }

    
    /// 开始算法原始数据采集
    public struct startAlgorithmRawDataDAQ : IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .algorithmRawData
        var json: String?
        public init() {
            // operate - 0x00为无效,0x01为开始采集,0x02为数据采集中,0x03为结束采集,0x04为设置开关,0x05为查询开关
            self.json = IDOAlgorithmRawDataParam(operate: 1, ppgSwitch: -1, accSwitch: -1).toJsonString()!
        }
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 结束算法原始数据采集
    public struct stopAlgorithmRawDataDAQ : IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .algorithmRawData
        var json: String?
        public init() {
            // operate - 0x00为无效,0x01为开始采集,0x02为数据采集中,0x03为结束采集,0x04为设置开关,0x05为查询开关
            self.json = IDOAlgorithmRawDataParam(operate: 3, ppgSwitch: -1, accSwitch: -1).toJsonString()!
        }
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 设置算法原始数据采集配置
    public struct setAlgorithmRawDataSensorConfig : IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .algorithmRawData
        var json: String?
        public init(ppg: IDOAlgorithmSensorSwitch, acc: IDOAlgorithmSensorSwitch) {
            // operate - 0x00为无效,0x01为开始采集,0x02为数据采集中,0x03为结束采集,0x04为设置开关,0x05为查询开关
            self.json = IDOAlgorithmRawDataParam(operate: 4, ppgSwitch: ppg.rawValue, accSwitch: acc.rawValue).toJsonString()!
        }
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 查询算法原始数据采集配置
    public struct getAlgorithmRawDataSensorConfig : IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .algorithmRawData
        var json: String?
        public init() {
            // operate - 0x00为无效,0x01为开始采集,0x02为数据采集中,0x03为结束采集,0x04为设置开关,0x05为查询开关
            self.json = IDOAlgorithmRawDataParam(operate: 5, ppgSwitch: -1, accSwitch: -1).toJsonString()!
        }
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDORawDataSensorConfigReply>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 查询v3菜单列表
    public struct getMenuListV3 : IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setV3MenuList
        var json: String?
        public init() {
            let param = IDOMenuListV3ParamModel(operate: 2)
            self.json = param.toJsonString()!
        }
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOMenuListV3Model>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }

     /// 设置v3菜单列表
    public struct setMenuListV3 : IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setV3MenuList
        var json: String?
        public init(_ items: [Int]) {
            let param = IDOMenuListV3ParamModel(operate: 1, itemList: items)
            self.json = param.toJsonString()!
        }
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 情绪健康提醒 （设置 / 查询）
    public struct emotionHealthReminder : IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setEmotionHealthReminder
        var json: String?
        public init(_ param: IDOEmotionHealthReminderParamModel) {
            self.json = param.toJsonString()!
        }
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOEmotionHealthReminderReplyModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    /// 应用列表样式 （设置/查询/删除）
    public struct appListStyle : IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setApplicationListStyle
        var json: String?
        public init(_ param: IDOAppListStyleParamModel) {
            self.json = param.toJsonString()!
        }
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOAppListStyleReplyModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    // -------------- 三诺app下发和获取V3血糖数据 --------------

    /// 设置血糖数据 (v01)
    public struct setBloodGlucoseDataV01 : IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .uploadBloodGlucose
        var json: String?
        public init(_ param: IDOBloodGlucoseSendInfo) {
            // operate - 1:发送 2:获取 3:设备结束监测
            let model = IDOBloodGlucoseV1Model(operate: 1, sendInfo: param)
            self.json = model.toJsonString()!
        }
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOBloodGlucoseInfoReplyV1>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }

    /// 获取血糖数据（v01）
    public struct getBloodGlucoseDataV01 : IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .uploadBloodGlucose
        var json: String?
        public init(localSerialNumber: Int) {
            // operate - 1:发送 2:获取 3:设备结束监测
            let getInfo = IDOBloodGlucoseGetInfo(localSerialNumber: localSerialNumber)
            let model = IDOBloodGlucoseV1Model(operate: 2, getInfo:getInfo)
            self.json = model.toJsonString()!
        }
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOBloodGlucoseInfoReplyV1>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }

    /// 停止血糖监测（v01）
    public struct stopBloodGlucoseDataV01 : IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .uploadBloodGlucose
        var json: String?
        public init() {
            // operate - 1:发送 2:获取 3:设备结束监测
            let model = IDOBloodGlucoseV1Model(operate: 3)
            self.json = model.toJsonString()!
        }
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOBloodGlucoseInfoReplyV1>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }

    // -------------- 车锁管理 --------------
    
    /// 获取车锁列表
    public struct getBikeLockList : IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .bikeLock
        var json: String?
        public init() {
            // 操作类型 1:设置 2:查询
            let param = IDOBikeLockModel(operate: 2)
            self.json = param.toJsonString()!
        }
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOBikeLockReplyModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }

    /// 设置车锁列表
    public struct setBikeLockList : IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .bikeLock
        var json: String?
        public init(_ items: [IDOBikeLockInfo]) {
            // 操作类型 1:设置 2:查询
            let param = IDOBikeLockModel(operate: 1, items: items)
            self.json = param.toJsonString()!
        }
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    // ----------- 手势控制 (15.82) ------------
    
    /// 设置手势控制
    /// Set gesture control
    public struct setGestureControl : IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setGestureControl
        var json: String?
        /// 初始化
        /// - Parameter model: 手势控制模型 | Gesture control model
        public init(_ model: IDOGestureControlModel) {
            model.operate = 1
            self.json = model.toJsonString()
        }
        /// 发送指令
        /// - Parameter completion: 回调 | Completion callback
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }

    /// 获取手势控制
    /// Get gesture control settings
    public struct getGestureControl : IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setGestureControl
        var json: String?
        public init() {
            let model = IDOGestureControlModel(operate: 2)
            self.json = model.toJsonString()
        }
        /// 发送指令
        /// - Parameter completion: 回调 | Completion callback
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOGestureControlModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }

    /// 获取手势控制支持配置项
    /// Get supported configurations for gesture control
    public struct getGestureControlSupportConfigs : IDOCmdProtocol, CmdProtocolParam {
        var evtType: ApiEvtType = .setGestureControl
        var json: String?
        public init() {
            let model = IDOGestureControlModel(operate: 3)
            self.json = model.toJsonString()
        }
        /// 发送指令
        /// - Parameter completion: 回调 | Completion callback
        @discardableResult public func send(completion: @escaping IDOCmdResponse<IDOGestureControlModel>) -> IDOCancellable {
            return Cmds._parseModel(self, completion: completion)
        }
    }
    
    
    // 指令发送 & 解析 返回模型
    fileprivate static func _parseModel<T: IDOBaseModel>(_ param: CmdProtocolParam, priority: IDOCmdPriority = .normal, completion: @escaping IDOCmdResponse<T>) -> IDOCancellable {
        let cancelToken = param.evtType.cancelToken
        _cmd?._sendOnMainThread(evtType: param.evtType.rawValue.int64, json: param.json, cancelToken: cancelToken, priority: priority) { rs in
            guard rs.code == 0 else {
                completion(.failure(CmdError(code: Int(rs.code?.int ?? -2), message: "code is null")))
                return
            }
            guard let jsonString = rs.json else {
                completion(.success(nil))
                return
            }
            if T.self is String.Type {
                completion(.success(jsonString as? T))
                return
            }
            guard let jsonData = jsonString.data(using: .utf8) else {
                completion(.success(nil))
                return
            }
            do {
                guard T.self is IDOCmdSetResponseModel.Type else {
                    let obj = try JSONDecoder().decode(T.self, from: jsonData)
                    completion(.success(obj))
                    return
                }
                
                // 针对不同的返回值，整合为同一个实体类
                // is_success / status_code / ret_code / err_code / status
                let jsonObj = try JSONSerialization.jsonObject(with: jsonData, options: [])
                guard let jsonDict = jsonObj as? [String: Any] else {
                    completion(.success(nil))
                    return
                }
                var val: Any?
                for key in ["is_success", "status_code", "ret_code", "err_code", "status", "error_code"] {
                    if jsonDict[key] != nil {
                        val = jsonDict[key]
                        break
                    }
                }
                if val != nil && val is Int {
                    completion(.success(IDOCmdSetResponseModel(isSuccess: val as! Int) as? T))
                } else {
                    completion(.success(nil))
                }
            } catch {
                #if DEBUG
                print("2error json:\(jsonString)")
                #endif
                completion(.failure(CmdError(code: -99, message: "Error parsing JSON: \(error)")))
            }
        }
        return CmdCancellable(token: cancelToken.token)
    }
    
    // 指令发送 & 解析 返回json
    fileprivate static func _parseJson(_ param: CmdProtocolParam, priority: IDOCmdPriority = .normal, completion: @escaping (Int, [String: Any]?) -> ()) -> IDOCancellable {
        let cancelToken = param.evtType.cancelToken
        _cmd?._sendOnMainThread(evtType: param.evtType.rawValue.int64, json: param.json, cancelToken: cancelToken) { rs in
            guard rs.code == 0 else {
                completion(rs.code?.int ?? -1, nil)
                return
            }
            guard let jsonString = rs.json else {
                completion(0, nil)
                return
            }
            guard let jsonData = jsonString.data(using: .utf8) else {
                completion(0, nil)
                return
            }
            do {
                let obj = try JSONSerialization.jsonObject(with: jsonData, options: [])
                if let jsonDict = obj as? [String: Any] {
                    completion(0, jsonDict)
                } else {
                    completion(0, nil)
                }
            } catch {
                completion(0, nil)
            }
        }
        return CmdCancellable(token: cancelToken.token)
    }
}

@objcMembers
public class Cmdoc: NSObject {
    /// 获取SN信息 返回 sn
    /// Get SN information Return sn
    @discardableResult public static func getSn(_ completion: @escaping (_ err: CmdError, _ sn: String?) -> ()) -> IDOCancellable {
        return Cmds._parseJson(InnerCmdProtocolParam(evtType: .getSnInfo, json: nil)) { code, dic in
            let err = CmdError(code: code)
            guard code == 0 else {
                completion(err, nil)
                return
            }
            guard let obj = dic else {
                completion(err, nil)
                return
            }
            completion(err, obj["sn"] as? String)
        }
    }
    
    /// 获取bt蓝牙名称
    /// Get bt bluetooth name
    @discardableResult public static func getBtName(_ completion: @escaping (_ err: CmdError, _ btName: String?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getBtName, json: nil)
        return Cmds._parseJson(param) { code, dic in
            let err = CmdError(code: code)
            guard code == 0 else {
                completion(err, nil)
                return
            }
            guard let obj = dic else {
                completion(err, nil)
                return
            }
            completion(err, obj["bt_name"] as? String)
        }
    }
    
    /// 获得实时数据
    /// Get Real-time Data event number
    ///
    /// - Parameter flag: 0：无功能 1：强制打开心率监测 2：强制打开血压监测 | 0: No function 1: force on the heart rate monitor 2: force on the blood pressure monitor
    @discardableResult public static func getLiveData(_ flag: Int, completion: @escaping (_ err: CmdError, _ liveData: IDOLiveDataModel?) -> ()) -> IDOCancellable {
        let json = ["flag": flag].toJsonString()
        let param = InnerCmdProtocolParam(evtType: .getLiveData, json: json)
        
        func send(completion: @escaping IDOCmdResponse<IDOLiveDataModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取错误记录
    /// Get error record
    ///
    /// - Parameter type: 0 查询 1 清除记录 | 0 Query 1 Clear records
    @discardableResult public static func getErrorRecord(_ type: Int, completion: @escaping (_ err: CmdError, _ recordData: IDOErrorRecordModel?) -> ()) -> IDOCancellable {
        let json = ["type": type].toJsonString()
        let param = InnerCmdProtocolParam(evtType: .getErrorRecord, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOErrorRecordModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取HID信息
    /// Get HID Information event number
    @discardableResult public static func getHidInfo(_ completion: @escaping (_ err: CmdError, _ isStart: Bool) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getHidInfo, json: nil)
        return Cmds._parseJson(param) { code, dic in
            let err = CmdError(code: code)
            guard code == 0 else {
                completion(err, false)
                return
            }
            guard let obj = dic else {
                completion(err, false)
                return
            }
            completion(err, obj["is_start"] as? Int == 1)
        }
    }

    /// 获取gps信息
    /// Get GPS Information event number
    @discardableResult public static func getGpsInfo(_ completion: @escaping (_ err: CmdError, _ gpsInfo: IDOGpsInfoModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getGpsInfo, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOGpsInfoModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取版本信息
    /// Get version information event number
    @discardableResult public static func getVersionInfo(_ completion: @escaping (_ err: CmdError, _ versionInfo: IDOVersionInfoModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getVersionInfo, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOVersionInfoModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取mtu信息
    /// Get MTU Information event number
    @discardableResult public static func getMtuInfo(_ completion: @escaping (_ err: CmdError, _ mtuInfo: IDOMtuInfoModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getMtuInfo, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOMtuInfoModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取所有的健康监测开关
    /// Get event number for all health monitoring switches
    @discardableResult public static func getAllHealthSwitchState(_ completion: @escaping (_ err: CmdError, _ state: IDOAllHealthSwitchStateModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getAllHealthSwitchState, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOAllHealthSwitchStateModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取gps状态
    /// Get GPS Status event number
    @discardableResult public static func getGpsStatus(_ completion: @escaping (_ err: CmdError, _ gpsStatus: IDOGpsStatusModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getGpsStatus, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOGpsStatusModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取固件不可删除的快捷应用列表
    /// Get non-deletable menu list in firmware event number
    @discardableResult public static func getUnerasableMeunList(_ completion: @escaping (_ err: CmdError, _ menuList: IDOUnerasableMeunListModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getUnerasableMeunList, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOUnerasableMeunListModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 运动模式自动识别开关获取
    /// Get event number for activity switch
    @discardableResult public static func getActivitySwitch(_ completion: @escaping (_ err: CmdError, _ switchModel: IDOActivitySwitchModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getActivitySwitch, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOActivitySwitchModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设备电量提醒开关获取
    /// Get event number for battery reminder switch
    @discardableResult public static func getBatteryReminderSwitch(_ completion: @escaping (_ err: CmdError, _ switchModel: IDOBatteryReminderSwitchModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getBatteryReminderSwitch, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOBatteryReminderSwitchModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }

    /// 获取宠物信息
    /// Get pet info event number
    @discardableResult public static func getPetInfo(_ completion: @escaping (_ err: CmdError, _ petInfo: IDOPetInfoModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getPetInfo, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOPetInfoModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取红点提醒开关
    /// Get unread app reminder switch event number
    @discardableResult public static func getUnreadAppReminder(_ completion: @escaping (_ err: CmdError, _ response: IDOCmdGetResponseModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getUnreadAppReminder, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOCmdGetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取字库信息
    /// Get Font Library Information event number
    @discardableResult public static func getFlashBinInfo(_ completion: @escaping (_ err: CmdError, _ binInfo: IDOFlashBinInfoModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getFlashBinInfo, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOFlashBinInfoModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 查询bt配对开关、连接、a2dp连接、hfp连接状态(仅支持带bt蓝牙的设备)
    /// Query BT pairing switch, connection, A2DP connection, HFP connection status (Only Supported on devices with BT Bluetooth) event number
    @discardableResult public static func getBtNotice(_ completion: @escaping (_ err: CmdError, _ noticeModel: IDOBtNoticeModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getBtNotice, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOBtNoticeModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取抬腕数据
    /// Get wrist up gesture data event number
    @discardableResult public static func getUpHandGesture(_ completion: @escaping (_ err: CmdError, _ gestureModel: IDOUpHandGestureModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getUpHandGesture, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOUpHandGestureModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取表盘id
    /// Get watch ID event number
    @discardableResult public static func getWatchDialId(_ completion: @escaping (_ err: CmdError, _ watchModel: IDOWatchDialIdModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getWatchDialId, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOWatchDialIdModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取勿扰模式状态
    /// Get Do Not Disturb mode status event number
    @discardableResult public static func getNotDisturbStatus(_ completion: @escaping (_ err: CmdError, _ statusModel: IDONotDisturbStatusModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getNotDisturbStatus, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDONotDisturbStatusModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取设置的卡路里/距离/中高运动时长 主界面
    /// Get Set Calorie/Distance/Mid-High Sport Time Goal event number
    ///
    /// - Parameter timeGoalType: 0: Invalid 1: Daily goal 2: Weekly goal
    @discardableResult public static func getMainSportGoal(_ timeGoalType: Int, completion: @escaping (_ err: CmdError, _ sportGoalModel: IDOMainSportGoalModel?) -> ()) -> IDOCancellable {
        let json = ["time_goal_type": timeGoalType].toJsonString()
        let param = InnerCmdProtocolParam(evtType: .getMainSportGoal, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOMainSportGoalModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取血压算法三级版本号信息事件号
    /// Get blood pressure algorithm version information event number
    @discardableResult public static func getBpAlgVersion(_ completion: @escaping (_ err: CmdError, _ bpAlgModel: IDOBpAlgVersionModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getBpAlgVersion, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOBpAlgVersionModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取屏幕亮度
    /// Get screen brightness event number
    @discardableResult public static func getScreenBrightness(_ completion: @escaping (_ err: CmdError, _ brightnessModel: IDOScreenBrightnessModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getScreenBrightness, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOScreenBrightnessModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取热启动参数
    /// Get Hot Start Parameters event number
    @discardableResult public static func getHotStartParam(_ completion: @escaping (_ err: CmdError, _ hotStartModel: IDOHotStartParamModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getHotStartParam, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOHotStartParamModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取固件支持的详情最大设置数量
    /// Get maximum number of settings supported by firmware event number
    @discardableResult public static func getSupportMaxSetItemsNum(_ completion: @escaping (_ err: CmdError, _ maxSetItemsModel: IDOSupportMaxSetItemsNumModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getSupportMaxSetItemsNum, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOSupportMaxSetItemsNumModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取走动提醒
    /// Get walk reminder event number
    @discardableResult public static func getWalkRemind(_ completion: @escaping (_ err: CmdError, _ walkRemindModel: IDOWalkRemindModelObjc?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getWalkRemind, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOWalkRemindModelObjc>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取全天步数目标
    /// Get daily step goal event number
    @discardableResult public static func getStepGoal(_ completion: @escaping (_ err: CmdError, _ stepGoalModel: IDOStepGoalModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getStepGoal, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOStepGoalModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取手表名字
    /// Get device name event number
    @discardableResult public static func getDeviceName(_ completion: @escaping (_ err: CmdError, _ deviceName: String?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getDeviceName, json: nil)
        return Cmds._parseJson(param) { code, dic in
            let err = CmdError(code: code)
            guard code == 0 else {
                completion(err, nil)
                return
            }
            guard let obj = dic else {
                completion(err, nil)
                return
            }
            completion(err, obj["dev_name"] as? String)
        }
    }
    
    /// 获取固件本地保存联系人文件修改时间
    /// Get firmware local contact file modification time event number
    @discardableResult public static func getContactReviseTime(_ completion: @escaping (_ err: CmdError, _ timeModel: IDOContactReviseTimeModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getContactReviseTime, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOContactReviseTimeModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取设备升级状态
    /// Get device update status event number
    @discardableResult public static func getUpdateStatus(_ completion: @escaping (_ err: CmdError, _ statusModel: IDOUpdateStatusModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getUpdateStatus, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOUpdateStatusModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取压力值
    /// Get stress value event number
    @discardableResult public static func getStressVal(_ completion: @escaping (_ err: CmdError, _ stressVal: IDOStressValModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getStressVal, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOStressValModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取心率监测模式
    /// Get Heart Rate Monitoring Mode event number
    @discardableResult public static func getHeartRateMode(_ completion: @escaping (_ err: CmdError, _ heartRateModel: IDOHeartRateModeModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getHeartRateMode, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOHeartRateModeModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取电池信息
    /// Get battery information event number
    @discardableResult public static func getBatteryInfo(_ completion: @escaping (_ err: CmdError, _ batteryInfo: IDOBatteryInfoModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getBatteryInfo, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOBatteryInfoModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取设备的日志状态
    /// Get device log state event number
    @discardableResult public static func getDeviceLogState(_ completion: @escaping (_ err: CmdError, _ liveData: IDODeviceLogStateModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getDeviceLogState, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDODeviceLogStateModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 手机音量下发给ble
    /// Set phone volume for device event number
    @discardableResult public static func setBleVoice(_ bleVoiceParam: IDOBleVoiceParamModel, completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable {
        let json = bleVoiceParam.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setBleVoice, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置控制gps
    /// Control GPS event number
    @discardableResult public static func setGpsControl(_ gpsControl: IDOGpsControlParamModel, completion: @escaping (_ err: CmdError, _ gpsControl: IDOGpsControlModel?) -> ()) -> IDOCancellable {
        let json = gpsControl.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setGpsControl, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOGpsControlModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 智能心率模式设置
    /// Set Smart Heart Rate Mode Event
    @discardableResult public static func setHeartRateModeSmart(_ heartRateMode: IDOHeartRateModeSmartParamModel, completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable {
        let json = heartRateMode.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setHeartRateModeSmart, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置压力校准
    /// Set Stress Calibration Event Code
    @discardableResult public static func setStressCalibration(_ stressCalibration: IDOStressCalibrationParamModel, completion: @escaping (_ err: CmdError, _ stressCalibration: IDOStressCalibrationModel?) -> ()) -> IDOCancellable {
        let json = stressCalibration.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setStressCalibration, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOStressCalibrationModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置洗手提醒
    /// Set Hand Washing Reminder Event
    @discardableResult public static func setHandWashingReminder(_ handWashingParam: IDOHandWashingReminderParamModelObjc, completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable {
        let json = handWashingParam.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setHandWashingReminder, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置运动目标
    /// Set exercise goal event
    @discardableResult public static func setSportGoal(_ sportGoalParam: IDOSportGoalParamModel, completion: @escaping (_ err: CmdError, _ liveData: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable {
        let json = sportGoalParam.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setSportGoal, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置天气数据
    /// Set weather data event number
    @discardableResult public static func setWeatherData(_ weatherData: IDOWeatherDataParamModel, completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable {
        let json = weatherData.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setWeatherData, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 未读信息红点提示开关
    /// Unread message reminder switch event number
    @discardableResult public static func setUnreadAppReminder(_ open: Bool, completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable {
        let json = ["on_off": open ? 1 : 0].toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setUnreadAppReminder, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 手机app通过这个命令开关，实现通知应用状态设置
    /// Notification app status setting event
    @discardableResult public static func setNotificationStatus(_ statusParam: IDONotificationStatusParamModel, completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable {
        let json = statusParam.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setNotificationStatus, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置科学睡眠开关
    /// Scientific sleep switch setting event
    @discardableResult public static func setScientificSleepSwitch(_ sleepSwitchParam: IDOScientificSleepSwitchParamModel,
                                                                   completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let json = sleepSwitchParam.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setScientificSleepSwitch, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 血压校准
    /// Blood pressure calibration event number
    @discardableResult public static func setBpCalibration(_ bpParam: IDOBpCalibrationParamModel, completion: @escaping (_ err: CmdError, _ bpModel: IDOBpCalibrationModel?) -> ()) -> IDOCancellable {
        let json = bpParam.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setBpCalibration, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOBpCalibrationModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置防丢
    /// Set Lost Find Event
    @discardableResult public static func setLostFind(_ lostFindParam: IDOLostFindParamModel, completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable {
        let json = lostFindParam.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setLostFind, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置表盘（废弃）
    /// Set watch face event number
    @discardableResult public static func setWatchDial(_ watchDial: IDOWatchDialParamModel, completion: @escaping (_ err: CmdError, _ liveData: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable {
        let json = watchDial.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setWatchDial, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置天气开关
    /// Set weather switch event number
    @discardableResult public static func setWeatherSwitch(_ open: Bool, completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable {
        let json = ["on_off": open ? 1 : 0].toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setWeatherSwitch, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置单位
    /// Set Unit event number
    @discardableResult public static func setUnit(_ unitParam: IDOUnitParamModel, completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable {
        let json = unitParam.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setUnit, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置寻找手机
    /// Set Find Phone
    @discardableResult public static func setFindPhone(_ open: Bool, completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable {
        let json = ["on_off": open ? 1 : 0].toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setFindPhone, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取下载语言支持
    /// Get Download Language Support
    @discardableResult public static func getDownloadLanguage(_ completion: @escaping (_ err: CmdError, _ downLanguage: IDODownloadLanguageModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getDownLanguage, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDODownloadLanguageModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置停止寻找手机
    /// Stop Find Phone
    @discardableResult public static func setOverFindPhone(_ completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable {
        let json = ["states": 1].toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setOverFindPhone, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取设备支持的菜单列表
    /// Get Supported Menu List
    @discardableResult public static func getMenuList(_ completion: @escaping (_ err: CmdError, _ menuModel: IDOMenuListModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getMenuList, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOMenuListModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置一键呼叫
    /// Set the one-touch calling event number
    ///
    /// - Parameters:
    ///   - open: on / off
    ///   - phoneType: 0: Invalid  1: Doro phone  2: Non-Doro phone
    @discardableResult public static func setOnekeySOS(_ open: Bool,
                                                       phoneType: Int,
                                                       completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let json = [
            "on_off": open ? 1 : 0,
            "phone_type": phoneType
        ].toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setOnekeySOS, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置运动模式选择
    /// Set sport mode select event number
    @discardableResult public static func setSportModeSelect(_ sportModeSelect: IDOSportModeSelectParamModel,
                                                             completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let json = sportModeSelect.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setSportModeSelect, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置运动模式排序
    /// Set Sport Mode Sorting
    @discardableResult public static func setSportModeSort(_ items: [IDOSportModeSortParamModel],
                                                           completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        var list = [[String: Any]]()
        for item in items {
            guard let jsonData = try? JSONEncoder().encode(item) else { continue }
            guard let dic = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else { continue }
            list.append(dic)
        }
        assert(list.count == items.count, "参数解析异常")
        let json = ["items": list].toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setSportModeSort, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置久坐
    /// Set Long Sit Event
    @discardableResult public static func setLongSit(_ longSit: IDOLongSitParamModel, completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable {
        let json = longSit.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setLongSit, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置心率模式
    /// Set Heart Rate Mode Event
    @discardableResult public static func setHeartRateMode(_ heartRateMode: IDOHeartRateModeParamModel,
                                                           completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let json = heartRateMode.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setHeartRateMode, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置身体电量开关
    /// Set body power switch event number
    @discardableResult public static func setBodyPowerTurn(_ open: Bool, completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable {
        let json = ["on_off": open ? 1 : 0].toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setBodyPowerTurn, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置呼吸率开关
    /// Respiration rate switch setting event
    @discardableResult public static func setRRespiRateTurn(_ open: Bool, completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable {
        let json = ["on_off": open ? 1 : 0].toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setRRespiRateTurn, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 环境音量的开关和阀值
    /// Set Environmental Noise Volume On/Off and Threshold Event
    @discardableResult public static func setV3Noise(_ noiseParam: IDOV3NoiseParamModel,
                                                     completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let json = noiseParam.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setV3Noise, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置日出日落时间
    /// Set sunrise and sunset time event number
    @discardableResult public static func setWeatherSunTime(_ weatherSunTime: IDOWeatherSunTimeParamModel,
                                                            completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let json = weatherSunTime.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setWeatherSunTime, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置快捷方式
    /// Set shortcut
    @discardableResult public static func setShortcut(_ shortcutParam: IDOShortcutParamModel,
                                                      completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let json = shortcutParam.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setShortcut, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取通知中心开关
    /// Get notification center status event number
    @discardableResult public static func getNoticeStatus(_ completion: @escaping (_ err: CmdError, _ noticeStatus: IDOSetNoticeStatusModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getNoticeStatus, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOSetNoticeStatusModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置通知中心
    /// Set Notification Center Event
    @discardableResult public static func setNoticeStatus(_ noticeStatus: IDOSetNoticeStatusModel,
                                                          completion: @escaping (_ err: CmdError, _ notifCenter: IDONotificationCenterModel?) -> ()) -> IDOCancellable
    {
        let json = noticeStatus.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setNotificationCenter, json: json)
        func send(completion: @escaping IDOCmdResponse<IDONotificationCenterModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置夜间体温开关
    /// Set Night-time Temperature Switch Event Code
    @discardableResult public static func setTemperatureSwitch(_ switchParam: IDOTemperatureSwitchParamModel,
                                                               completion: @escaping (_ err: CmdError, _ liveData: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let json = switchParam.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setTemperatureSwitch, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置睡眠时间段
    /// Set sleep period event
    @discardableResult public static func setSleepPeriod(_ sleepPeriod: IDOSleepPeriodParamModel,
                                                         completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let json = sleepPeriod.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setSleepPeriod, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置抬手亮屏
    /// Raise-to-wake gesture event number
    @discardableResult public static func setUpHandGesture(_ upHandGesture: IDOUpHandGestureParamModel,
                                                           completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let json = upHandGesture.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setUpHandGesture, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置吃药提醒
    /// Set Taking Medicine Reminder Event Code
    @discardableResult public static func setTakingMedicineReminder(_ takingMedicine: IDOTakingMedicineReminderParamModelObjc,
                                                                    completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let json = takingMedicine.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setTakingMedicineReminder, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置血氧开关
    /// Set SpO2 switch event
    @discardableResult public static func setSpo2Switch(_ spo2Switch: IDOSpo2SwitchParamModel,
                                                        completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let json = spo2Switch.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setSpo2Switch, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置天气城市名称
    /// Set weather city name event number
    @discardableResult public static func setWeatherCityName(_ cityName: String,
                                                             completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let json = [
            "version": 0,
            "city_name": cityName
        ].toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setWeatherCityName, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }

    /// app获取ble的闹钟
    /// Getting Alarms for V3APP Devices
    /// - Parameters:
    ///   - flag: Flag for getting alarms  0: Get all alarms 1: Get alarms modified by the device notification
    @discardableResult public static func getAlarm(_ flag: Int, 
                                                   completion: @escaping (_ err: CmdError, _ alarmModel: IDOAlarmModelObjc?) -> ()) -> IDOCancellable
    {
        return getAlarm(flag, priority: .normal, completion: completion)
    }
    
    /// app获取ble的闹钟
    /// Getting Alarms for V3APP Devices
    /// - Parameters:
    ///   - flag: Flag for getting alarms  0: Get all alarms 1: Get alarms modified by the device notification
    @discardableResult public static func getAlarm(_ flag: Int, priority: IDOCmdPriority = .normal,
                                                   completion: @escaping (_ err: CmdError, _ alarmModel: IDOAlarmModelObjc?) -> ()) -> IDOCancellable
    {
        let json = ["flag": flag].toJsonString()
        let param = InnerCmdProtocolParam(evtType: .getAlarmV3, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOAlarmModelObjc>) -> IDOCancellable {
            return Cmds._parseModel(param, priority: priority, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// app设置ble的闹钟
    /// Getting Alarms for V3APP Devices
    @discardableResult public static func setAlarm(_ alarm: IDOAlarmModelObjc,
                                                   completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let json = alarm.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setAlarmV3, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取用户习惯信息
    /// Get User Habit Information in V3
    @discardableResult public static func getHabitInfo(_ completion: @escaping (_ err: CmdError, _ habitInfo: IDOHabitInfoModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getHabitInfoV3, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOHabitInfoModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 健身指导
    /// Fitness Guidance Event
    @discardableResult public static func setFitnessGuidance(_ fitness: IDOFitnessGuidanceParamModelObjc,
                                                             completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let json = fitness.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setFitnessGuidance, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 显示模式
    /// Display mode event number
    @discardableResult public static func setDisplayMode(_ displayMode: IDODisplayModeParamModel,
                                                         completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let json = displayMode.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setDisplayMode, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 血压测量
    /// Blood pressure measurement event number
    @discardableResult public static func setBpMeasurement(_ bpMeasurment: IDOBpMeasurementParamModel,
                                                           completion: @escaping (_ err: CmdError, _ bpMeasurement: IDOBpMeasurementModel?) -> ()) -> IDOCancellable
    {
        let json = bpMeasurment.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setBpMeasurement, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOBpMeasurementModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 单项测量 | Single Measurement
    @discardableResult private static func setSingleMeasurement(type: IDOMeasurementType,
                                                               action: IDOMeasurementAction,
                                                               completion: @escaping (_ err: CmdError, _ measurement: IDOMeasurementModel?) -> ()) -> IDOCancellable
    {
        let dic = [type.jsonKey: action.rawValue]
        var json: String? = nil
        if let data = try? JSONSerialization.data(withJSONObject: dic, options: []),
           let jsonString = String(data: data, encoding: .utf8) {
            json = jsonString
        }
        let param = InnerCmdProtocolParam(evtType: .setBpMeasurement, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOMeasurementModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 音乐开关
    /// Set Music On/Off Event
    @discardableResult public static func setMusicOnOff(_ musicOnOff: IDOMusicOnOffParamModel,
                                                        completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let json = musicOnOff.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setMusicOnOff, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// app下发跑步计划(运动计划)
    /// App issued running plan (exercise plan) event number
    @discardableResult public static func setSendRunPlan(_ runPlan: IDORunPlanParamModel,
                                                         completion: @escaping (_ err: CmdError, _ runPlanModel: IDOSendRunPlanModel?) -> ()) -> IDOCancellable
    {
        let json = runPlan.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setSendRunPlan, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOSendRunPlanModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// v3 下发v3天气协议
    /// Send the v3 weather protocol event number under v3
    @discardableResult public static func setWeatherV3(_ weather: IDOWeatherV3ParamModel,
                                                       completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let json = weather.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setWeatherV3, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取固件的歌曲名和文件夹
    /// Get Firmware Song Names and Folders
    @discardableResult public static func getBleMusicInfo(_ completion: @escaping (_ err: CmdError, _ musiceInfo: IDOMusicInfoModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getBleMusicInfo, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOMusicInfoModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 控制音乐
    /// Music control event number
    @discardableResult public static func musicControl(_ musicControl: IDOMusicControlParamModel,
                                                       completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let json = musicControl.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .musicControl, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 操作歌曲或者文件夹
    /// Operation for songs or folders event
    @discardableResult public static func setMusicOperate(_ musicOpt: IDOMusicOpearteParamModel,
                                                          completion: @escaping (_ err: CmdError, _ musicOptModel: IDOMusicOperateModel?) -> ()) -> IDOCancellable
    {
        let json = musicOpt.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setMusicOperate, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOMusicOperateModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 通知消息提醒
    /// Notification message reminder event number
    @discardableResult public static func noticeMessageV3(_ noticeMsg: IDONoticeMessageParamModel,
                                                          completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let json = noticeMsg.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .noticeMessageV3, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置消息通知状态
    /// Setting Notification Status for a Single App
    @discardableResult public static func setNoticeMessageState(_ noticeMsgState: IDONoticeMessageStateParamModel,
                                                                completion: @escaping (_ err: CmdError, _ msgState: IDONoticeMessageStateModel?) -> ()) -> IDOCancellable
    {
        let json = noticeMsgState.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setNoticeMessageState, json: json)
        func send(completion: @escaping IDOCmdResponse<IDONoticeMessageStateModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 动态消息通知
    /// V3 dynamic notification message event number
    @discardableResult public static func setNoticeAppName(_ noticeMsgParam: IDONoticeMesaageParamModel,
                                                           completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let json = noticeMsgParam.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setNoticeAppName, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 下发v3世界时间
    /// v3 set v3 world time
    @discardableResult public static func setWorldTimeV3(_ worldTimes: [IDOWorldTimeParamModel],
                                                         completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        var list = [[String: Any]]()
        for item in worldTimes {
            guard let jsonData = try? JSONEncoder().encode(item) else { continue }
            guard let dic = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else { continue }
            list.append(dic)
        }
        assert(list.count == worldTimes.count, "参数解析异常")
        let json = [
            "version": 2,
            "items_num": list.count,
            "items": list
        ].toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setWorldTimeV3, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            guard list.count <= 10 else {
                completion(.failure(CmdError(code: -2, message: "Number of clocks, send all clocks at a time Max 10")))
                return CmdCancellable()
            }
            return Cmds._parseModel(param, completion: completion)
        }
    
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置日程提醒
    /// Schedule Reminder
    @discardableResult public static func setSchedulerReminder(_ schedulerReminderParam: IDOSchedulerReminderParamModel,
                                                               completion: @escaping (_ err: CmdError, _ schedulerReminderModel: IDOSchedulerReminderModel?) -> ()) -> IDOCancellable
    {
        let json = schedulerReminderParam.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setSchedulerReminderV3, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOSchedulerReminderModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取屏幕信息
    /// Get Screen Information
    @discardableResult public static func getWatchDialInfo(_ completion: @escaping (_ err: CmdError, _ watchDialInfo: IDOWatchDialInfoModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getWatchDialInfo, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOWatchDialInfoModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 血压校准控制
    /// Blood Pressure Calibration Control
    ///
    /// - Parameters:
    ///   - operate: 0: Invalid
    ///   1: Start blood pressure calibration
    ///   2: Stop blood pressure calibration
    ///   3: Get feature vector information
    ///   - filePath: The file path to save the raw data obtained during firmware blood pressure calibration
    ///     Path includes file name (../../blood.txt)
    ///     Valid when operate=1
    @discardableResult public static func setBpCalControlV3(_ operate: Int,
                                                            filePath: String,
                                                            completion: @escaping (_ err: CmdError, _ bpCalControl: IDOBpCalControlModel?) -> ()) -> IDOCancellable
    {
        let json = ["operate": operate, "file_path": filePath].toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setBpCalControlV3, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOBpCalControlModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置表盘
    /// Set Watch Face
    @discardableResult public static func setWatchFaceData(_ watchFace: IDOWatchFaceParamModel,
                                                           completion: @escaping (_ err: CmdError, _ watchFaceModel: IDOWatchFaceModel?) -> ()) -> IDOCancellable
    {
        let json = watchFace.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setWatchFaceData, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOWatchFaceModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 同步常用联系人
    /// Synchronization Protocol Bluetooth Call Common Contacts
    @discardableResult public static func setSyncContact(_ syncContactParam: IDOSyncContactParamModel, completion: @escaping (_ err: CmdError, _ syncContactModel: IDOSyncContactModel?) -> ()) -> IDOCancellable {
        let json = syncContactParam.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setSyncContact, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOSyncContactModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取表盘列表 v3
    /// Getting watch face list for V3 (New)
    @discardableResult public static func getWatchListV3(_ completion: @escaping (_ err: CmdError, _ watchListModel: IDOWatchListModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getWatchListV3, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOWatchListModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取表盘列表 v2
    /// Get Watch Face List in V2
    @discardableResult public static func getWatchListV2(_ completion: @escaping (_ err: CmdError, _ watchList: IDOWatchListV2Model?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getWatchFaceList, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOWatchListV2Model>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置运动子项数据排列
    /// Set and Query Sports Sub-item Data Sorting
    @discardableResult public static func setSportParamSort(_ sportSortParam: IDOSportSortParamModel,
                                                            completion: @escaping (_ err: CmdError, _ sportSortModel: IDOSportSortModel?) -> ()) -> IDOCancellable
    {
        let json = sportSortParam.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setBaseSportParamSortV3, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOSportSortModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 新的100种运动排序
    /// Set and Query 100 Sports Sorting
    @discardableResult public static func setSport100Sort(_ sport100SortParam: IDOSport100SortParamModel, completion: @escaping (_ err: CmdError, _ sportSortModel: IDOSport100SortModel?) -> ()) -> IDOCancellable {
        let json = sport100SortParam.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .set100SportSortV3, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOSport100SortModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置主界面控件排序
    /// Setting and Query Sorting of Main UI Controls
    @discardableResult public static func setMainUISortV3(_ mainUISortParam: IDOMainUISortParamModel,
                                                          completion: @escaping (_ err: CmdError, _ mainUISortModel: IDOMainUISortModel?) -> ()) -> IDOCancellable
    {
        let json = mainUISortParam.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setMainUISortV3, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOMainUISortModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 经期的历史数据下发
    /// Menstrual historical data delivery event number
    @discardableResult public static func setHistoricalMenstruation(_ historical: IDOHistoricalMenstruationParamModel,
                                                                    completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let json = historical.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .getHistoricalMenstruation, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取语言库列表
    /// Get Language Library List
    @discardableResult public static func getLanguageLibrary(_ completion: @escaping (_ err: CmdError, _ languageLib: IDOLanguageLibraryModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getLanguageLibraryDataV3, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOLanguageLibraryModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取固件本地提示音文件信息
    /// Getting firmware local beep file information for V3
    @discardableResult public static func getBleBeep(_ completion: @escaping (_ err: CmdError, _ bleBeep: IDOBleBeepModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getBleBeepV3, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOBleBeepModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置运动城市名称
    /// V3 Setting the Name of a Sports City event number
    ///
    /// - Parameters:
    ///   - cityName: City name Maximum 74 bytes
    @discardableResult public static func setLongCityNameV3(_ cityName: String, completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable {
        let json = [
            "version": 0,
            "name": cityName
        ].toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setLongCityNameV3, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// V3设置心率模式
    /// Set Heart Rate Mode V3
    @discardableResult public static func setHeartMode(_ heartModeParam: IDOHeartModeParamModel,
                                                       completion: @escaping (_ err: CmdError, _ heartModeModel: IDOHeartModeModel?) -> ()) -> IDOCancellable
    {
        let json = heartModeParam.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setHeartMode, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOHeartModeModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 语音回复文本
    /// V3 voice reply text event number
    @discardableResult public static func setVoiceReplyText(_ voiceReplyParam: IDOVoiceReplyParamModel,
                                                            completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let json = voiceReplyParam.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setVoiceReplyTxtV3, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置表盘顺序
    /// Set watch dial sort event
    @discardableResult public static func setWatchDialSort(_ watchDialSortParam: IDOWatchDialSortParamModel,
                                                           completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let json = watchDialSortParam.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setWatchDialSort, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置多个走动提醒的时间点
    /// Set multiple walk reminder times event number
    @discardableResult public static func setWalkRemindTimes(_ walkRemindTimes: IDOWalkRemindTimesParamModel,
                                                             completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let json = walkRemindTimes.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setWalkRemindTimes, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置壁纸表盘列表
    /// Set wallpaper dial list event number
    @discardableResult public static func setWallpaperDialReply(_ wallpaperDial: IDOWallpaperDialReplyV3ParamModel,
                                                                completion: @escaping (_ err: CmdError, _ wallpaperDialReplyModel: IDOWallpaperDialReplyV3Model?) -> ()) -> IDOCancellable
    {
        let json = wallpaperDial.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setWallpaperDialReplyV3, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOWallpaperDialReplyV3Model>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置时间, 不指定参数将使用当前时间
    /// Set the time. If no reference is specified, the current time will be used.
    @discardableResult public static func setDateTime(_ dateTimeParam: IDODateTimeParamModel? = nil,
                                                      completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let json = dateTimeParam?.toJsonString() ?? "{}"
        let param = InnerCmdProtocolParam(evtType: .setTime, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置用户信息
    /// Set user information
    @discardableResult public static func setUserInfo(_ userInfo: IDOUserInfoPramModel,
                                                      completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let json = userInfo.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setUserInfo, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 重启设备
    @discardableResult public static func reboot(_ completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .reboot, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 恢复出厂设置
    @discardableResult public static func factoryReset(_ completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .factoryReset, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 关机
    /// Shutdown
    @discardableResult public static func shutdown(_ completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .shutdown, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 控制寻找设备开始
    @discardableResult public static func findDeviceStart(_ completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .findDeviceStart, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 控制寻找设备结束
    @discardableResult public static func findDeviceStop(_ completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .findDeviceStop, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 开始拍照 (app -> ble)
    @discardableResult public static func photoStart(_ completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .photoStart, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 结束拍照 (app -> ble)
    @discardableResult public static func photoStop(_ completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .photoStop, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置左右手
    @discardableResult public static func setHand(_ isRightHand: Bool,
                                                  completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let json = [
            "hand": isRightHand ? 1 : 0
        ].toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setHand, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置屏幕亮度
    @discardableResult public static func setScreenBrightness(_ screenBrightness: IDOScreenBrightnessModel,
                                                              completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let json = screenBrightness.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setScreenBrightness, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 进入升级模式
    @discardableResult public static func otaStart(_ completion: @escaping (_ err: CmdError, _ response: IDOCmdOTAResponseModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .otaStart, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOCmdOTAResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置心率区间
    @discardableResult public static func setHeartRateInterval(_ heartRateInterval: IDOHeartRateIntervalModel,
                                                               completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let json = heartRateInterval.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setHeartRateInterval, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置卡路里和距离目标(设置日常三环)
    @discardableResult public static func setCalorieDistanceGoal(_ sportGoal: IDOMainSportGoalModel,
                                                                 completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let json = sportGoal.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setCalorieDistanceGoal, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置走动提醒
    @discardableResult public static func setWalkRemind(_ walkRemind: IDOWalkRemindModelObjc,
                                                        completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let json = walkRemind.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setWalkRemind, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置经期
    @discardableResult public static func setMenstruation(_ menstruation: IDOMenstruationModel,
                                                          completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let param = InnerCmdProtocolParam(evtType: .setMenstruation, json: menstruation.toJsonString())
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取默认的运动类型
    /// Get the default motion type
    @discardableResult public static func getDefaultSportType(_ completion: @escaping (_ err: CmdError, _ sportTypeModel: IDODefaultSportTypeModel?) -> ()) -> IDOCancellable
    {
        let param = InnerCmdProtocolParam(evtType: .getDefaultSportType, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDODefaultSportTypeModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }

    
    /// 设置喝水提醒
    /// Set Drink Water Reminder
    @discardableResult public static func setDrinkWaterRemind(_ drinkWaterRemind: IDODrinkWaterRemindModelObjc,
                                                          completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let param = InnerCmdProtocolParam(evtType: .setDrinkWaterRemind, json: drinkWaterRemind.toJsonString())
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    
    /// 设置经期提醒
    /// Set Menstrual Reminder
    @discardableResult public static func setMenstruationRemind(_ menstruationRemind: IDOMenstruationRemindParamModel,
                                                          completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let param = InnerCmdProtocolParam(evtType: .setMenstruationRemind, json: menstruationRemind.toJsonString())
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    
    
    /// 设置压力开关
    /// Set Pressure Switch
    @discardableResult public static func setStressSwitch(_ stressSwitchParam: IDOStressSwitchParamModelObjc,
                                                          completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let param = InnerCmdProtocolParam(evtType: .setStressSwitch, json: stressSwitchParam.toJsonString())
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    
    /// 设置语音助手开关
    /// Setting Voice Assistant Switch
    @discardableResult public static func setVoiceAssistantOnOff(_ isOpen: Bool,
                                                  completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let json = [
            "on_off": isOpen ? 1 : 0
        ].toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setVoiceAssistantOnOff, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    
    /// 设置勿扰模式
    /// Set do not disturb mode
    @discardableResult public static func setNotDisturb(_ notDisturbModel: IDONotDisturbParamModel,
                                                          completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let param = InnerCmdProtocolParam(evtType: .setNotDisturb, json: notDisturbModel.toJsonString())
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }

    
    /// 设置菜单列表
    /// Settings menu list
    @discardableResult public static func setMenuList(_ menuListParam: IDOMenuListParamModel,
                                                          completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let param = InnerCmdProtocolParam(evtType: .setMenuList, json: menuListParam.toJsonString())
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }

    
    /// 设置运动类型排序
    /// Set sport type sorting
    @discardableResult public static func setSportSortV3(_ sportParam: IDOSportParamModel,
                                                          completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let param = InnerCmdProtocolParam(evtType: .setSportSortV3, json: sportParam.toJsonString())
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }

    
    /// 设置固件来电快捷回复开关
    /// Set the firmware quick reply switch for incoming calls
    @discardableResult public static func setCallQuickReplyOnOff(_ isOpen: Bool,
                                                  completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let json = [
            "on_off": isOpen ? 1 : 0
        ].toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setCallQuickReplyOnOff, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    
    /// 获取运动默认的类型 V3
    /// Get the default type of motion V3
    @discardableResult public static func getSportTypeV3(_ completion: @escaping (_ err: CmdError, _ sportTypeModel: IDODefaultSportTypeModel?) -> ()) -> IDOCancellable
    {
        let param = InnerCmdProtocolParam(evtType: .getSportTypeV3, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDODefaultSportTypeModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取BT连接手机型号
    /// Get BT connected mobile phone model
    @discardableResult public static func getBtConnectPhoneModel(_ completion: @escaping (_ err: CmdError, _ phoneModel: String?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getBtConnectPhoneModel, json: nil)
        return Cmds._parseJson(param) { code, dic in
            let err = CmdError(code: code)
            guard code == 0 else {
                completion(err, nil)
                return
            }
            guard let obj = dic else {
                completion(err, nil)
                return
            }
            completion(err, obj["phone_model"] as? String)
        }
    }
    
    /// 设置运动模式识别开关
    /// Set the sports mode recognition switch
    @discardableResult public static func setActivitySwitch(_ switchParam: IDOActivitySwitchParamModel,
                                                          completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let param = InnerCmdProtocolParam(evtType: .setActivitySwitch, json: switchParam.toJsonString())
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设备电量提醒开关设置
    /// Battery reminder switch event number
    @discardableResult public static func setBatteryReminderSwitch(_ switchParam: IDOBatteryReminderSwitchParamModel,
                                                                 completion: @escaping (_ err: CmdError, _ response: IDOBatteryReminderSwitchReplyModel?) -> ()) -> IDOCancellable
    {
        let param = InnerCmdProtocolParam(evtType: .setBatteryReminderSwitch, json: switchParam.toJsonString())
        func send(completion: @escaping IDOCmdResponse<IDOBatteryReminderSwitchReplyModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }

    /// 设置宠物信息
    /// Set pet info event number
    @discardableResult public static func setPetInfo(_ petInfoParam: IDOPetInfoParamModel,
                                                     completion: @escaping (_ err: CmdError, _ response: IDOPetInfoReplyModel?) -> ()) -> IDOCancellable
    {
        let param = InnerCmdProtocolParam(evtType: .setPetInfo, json: petInfoParam.toJsonString())
        func send(completion: @escaping IDOCmdResponse<IDOPetInfoReplyModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 控制音乐开始
    /// Control music start
    @discardableResult public static func musicStart(_ completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .musicStart, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 控制音乐停止
    /// Control music stop
    @discardableResult public static func musicStop(_ completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .musicStop, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    
    /// APP下发配对结果
    /// The APP delivers the pairing result
    @discardableResult public static func sendBindResult(_ isSuccess: Bool, _ completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable {
        let json = [
            "bind_result": isSuccess ? 0 : 1
        ].toJsonString()
        let param = InnerCmdProtocolParam(evtType: .sendBindResult, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取单位
    /// Get Unit event number
    @discardableResult public static func getUnit(_ completion: @escaping (_ err: CmdError, _ unitModel: IDOUnitModel?) -> ()) -> IDOCancellable
    {
        let param = InnerCmdProtocolParam(evtType: .getUnit, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOUnitModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    
    /// 设置热启动参数
    /// Set hot boot parameters
    @discardableResult public static func setHotStartParam(_ gpsHotStart: IDOGpsHotStartParamModel,
                                                           completion: @escaping (_ err: CmdError, _ response: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable
    {
        let param = InnerCmdProtocolParam(evtType: .setHotStartParam, json: gpsHotStart.toJsonString())
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    
    /// 获取智能心率模式
    /// Get Smart Heart Rate Mode
    @discardableResult public static func getSmartHeartRateMode(_ completion: @escaping (_ err: CmdError, _ heartRateModel: IDOHeartRateModeSmartModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getHeartRateModeSmart, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOHeartRateModeSmartModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取血氧开关
    /// Get blood oxygen switch
    @discardableResult public static func getSpo2Switch(_ completion: @escaping (_ err: CmdError, _ spo2Model: IDOSpo2SwitchModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getSpo2Switch, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOSpo2SwitchModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取压力开关
    /// Get the pressure switch
    @discardableResult public static func getStressSwitch(_ completion: @escaping (_ err: CmdError, _ stressSwitchModel: IDOStressSwitchModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getStressSwitch, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOStressSwitchModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置默认的消息应用列表
    /// Set the default messaging app list
    @discardableResult public static func setDefaultMsgList(_ paramModel: IDODefaultMessageConfigParamModel, _ completion: @escaping (_ err: CmdError, _ aModel: IDODefaultMessageConfigModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .setDefaultMsgList, json: paramModel.toJsonString())
        func send(completion: @escaping IDOCmdResponse<IDODefaultMessageConfigModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 操作小程序信息（获取、启动、删除）
    /// Operation of applet information (obtain, start, delete)
    @discardableResult public static func setAppleControl(_ paramModel: IDOAppletControlModel, _ completion: @escaping (_ err: CmdError, _ aModel: IDOAppletInfoModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .setAppletControl, json: paramModel.toJsonString())
        func send(completion: @escaping IDOCmdResponse<IDOAppletInfoModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取固件算法文件信息（ACC/GPS）
    /// Get firmware algorithm file information (ACC/GPS)
    @discardableResult public static func getAlgFileInfo(_ completion: @escaping (_ err: CmdError, _ aModel: IDOAlgFileModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getAlgFile, json: "{\"operate\":1,\"type\":0,\"version\":0}")
        func send(completion: @escaping IDOCmdResponse<IDOAlgFileModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 请求固件算法文件信息（ACC/GPS）
    /// Request firmware algorithm file information (ACC/GPS)
    @discardableResult public static func rquestAlgFile(_ type: Int, _ completion: @escaping (_ err: CmdError, _ aModel: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable {
        let json = [
            "type": type,
            "operate": 2,
            "version": 0
        ].toJsonString()
        let param = InnerCmdProtocolParam(evtType: .getAlgFile, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }

    // 内部使用
    @discardableResult private static func innerGetSportScreenDetailInfo(_ sportItems: [IDOSportScreenSportItemModel],
                                                                         operate: Int,
                                                                         completion: @escaping (_ err: CmdError, _ aModel: IDOSportScreenInfoReplyModel?) -> ()) -> IDOCancellable {
        let json = IDOSportScreenParamModel(operate: operate, sportItems: sportItems).toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setSportScreen, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOSportScreenInfoReplyModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }

    /// 获取运动中屏幕显示详情信息
    @discardableResult public static func getSportScreenDetailInfo(_ sportItems: [IDOSportScreenSportItemModel],
                                                                   completion: @escaping (_ err: CmdError, _ aModel: IDOSportScreenInfoReplyModel?) -> ()
    ) -> IDOCancellable {
        let canceller = InnerCmdCanceller()
        let cancelOpt2 = innerGetSportScreenDetailInfo(sportItems, operate: 2) { err, aModel in
            guard err.isOK, aModel != nil else {
                completion(CmdError(), nil)
                return
            }
            let valOpt2 = aModel
            let cancelOpt3 = innerGetSportScreenDetailInfo(sportItems, operate: 3) { err, aModel in
                guard err.isOK, aModel != nil else {
                    completion(CmdError(), nil)
                    return
                }
                let valOpt3 = aModel
                let itOpt2SportItems = valOpt2?.sportItems
                let itOpt3SportItems = valOpt3?.sportItems
                do {
                    // 使用 guard 处理可选值和空数组检查
                    guard let sportItems2 = itOpt2SportItems,
                          let sportItems3 = itOpt3SportItems,
                          !sportItems2.isEmpty,
                          !sportItems3.isEmpty,
                          sportItems3.count == sportItems2.count else {
                        throw NSError(domain: "InvalidData", code: 1) // 或直接 return
                    }
                    
                    // 执行映射操作
                    valOpt3!.sportItems = sportItems3.map { it3 in
                        let modified = it3
                        // 使用 first(where:) 查找匹配项
                        if let matchedItem = sportItems2.first(where: { $0.sportType == it3.sportType }) {
                            modified.supportDataTypes = matchedItem.supportDataTypes ?? []
                        } else {
                            modified.supportDataTypes = []
                        }
                        modified.supportDataTypeNum = modified.supportDataTypes?.count ?? 0
                        return modified
                    }
                    valOpt3!.specialDataItems = valOpt2?.specialDataItems
                    valOpt3!.specialDataItemCount = valOpt2?.specialDataItemCount ?? 0
                } catch {
                    // 异常处理（Swift 中需要明确错误类型）
                    #if DEBUG
                    print("Parse sporting screen Error occurred: \(error)")
                    #endif
                }
                completion(CmdError(code: 0), valOpt3)
            }
            canceller.cancellers.append(cancelOpt3)
            
        }
        canceller.cancellers.append(cancelOpt2)
        return canceller
    }
    
    /// 获取运动中屏幕显示基础信息
    @discardableResult public static func getSportScreenBaseInfo(_ completion: @escaping (_ err: CmdError, _ aModel: IDOSportScreenInfoReplyModel?) -> ()) -> IDOCancellable {
        
        let json = IDOSportScreenParamModel(operate: 1, sportItems: nil).toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setSportScreen, json: json)
        
        func send(completion: @escaping IDOCmdResponse<IDOSportScreenInfoReplyModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置运动中屏幕显示
    @discardableResult public static func setSportScreen(_ sportItems: [IDOSportScreenSportItemModel],
                                                         completion: @escaping (_ err: CmdError, _ aModel: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable {
        let json = IDOSportScreenParamModel(operate: 4, sportItems: sportItems).toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setSportScreen, json: json)
        
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
        
    }
    
    /// 设置APP基本信息
    @discardableResult public static func setAppBaseInfo(_ appInfoModel: IDOAppInfoModel,
                                                         completion: @escaping (_ err: CmdError, _ aModel: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable {
        let json = appInfoModel.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setAppBaseInfo, json: json)
        
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 运动中设置提示音开关
    @discardableResult public static func setDuringExercise(_ duringExerciseModel: IDOSettingsDuringExerciseModel,
                                                            completion: @escaping (_ err: CmdError, _ aModel: IDOCmdSetResponseModel?) -> ()) -> IDOCancellable {
        let json = duringExerciseModel.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setDuringExercise, json: json)
        
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取左右手佩戴设置
    @discardableResult public static func getLeftRightWearSettings(_ completion: @escaping (_ err: CmdError, _ aModel: IDOLeftRightWearModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getLeftRightWearSettings, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOLeftRightWearModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取运动中设置提示音开关
    @discardableResult public static func getSettingsDuringExercise(_ completion: @escaping (_ err: CmdError, _ aModel: IDOSettingsDuringExerciseModel?) -> ()) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getSettingsDuringExercise, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOSettingsDuringExerciseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 查询运动中提醒
    @discardableResult public static func getSportingRemindSetting(_ sportTypes:[Int], completion: @escaping (_ err: CmdError, _ aModel: IDOSportingRemindSettingReplyModel?) -> ()) -> IDOCancellable {
        let json = IDOSportingRemindSettingParamModel(operate: IDOSportingRemindSettingParamModel.QUERY, sportTypes: sportTypes).toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setSportingRemindSetting, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOSportingRemindSettingReplyModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }

    /// 设置运动中提醒项
    @discardableResult public static func setSportingRemindSetting(_ settingItems: [IDOSportingRemindSettingModel], completion: @escaping (_ err: CmdError, _ aModel: IDOCmdSetResponseModel?) -> Void) -> IDOCancellable {
        let json = IDOSportingRemindSettingParamModel(operate: IDOSportingRemindSettingParamModel.SET, settingItems: settingItems).toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setSportingRemindSetting, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case let .success(o) = rs {
                completion(CmdError(code: 0), o)
            } else if case let .failure(e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }

    /// 简单心率区间设置
    @discardableResult public static func setSimpleHeartRateZone(_ model: IDOSimpleHeartRateZoneSettingModel, completion: @escaping (_ err: CmdError, _ aModel: IDOCmdSetResponseModel?) -> Void) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .setSimpleHeartRateZone, json: model.toJsonString())
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case let .success(o) = rs {
                completion(CmdError(code: 0), o)
            } else if case let .failure(e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }

    /// 查询简单心率区间
    @discardableResult public static func getSimpleHeartRateZone(_ completion: @escaping (_ err: CmdError, _ aModel: IDOSimpleHeartRateZoneSettingModel?) -> Void) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getSimpleHeartRateZone, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOSimpleHeartRateZoneSettingModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case let .success(o) = rs {
                completion(CmdError(code: 0), o)
            } else if case let .failure(e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 获取用户信息
    @discardableResult public static func getUserInfo(_ completion: @escaping (_ err: CmdError, _ aModel: IDOUserInfoPramModel?) -> Void) -> IDOCancellable {
        let param = InnerCmdProtocolParam(evtType: .getUserInfo, json: nil)
        func send(completion: @escaping IDOCmdResponse<IDOUserInfoPramModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case let .success(o) = rs {
                completion(CmdError(code: 0), o)
            } else if case let .failure(e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 更新当前血糖数据
    @discardableResult public static func uploadBloodGlucoseCurrentData(_ item: IDOBloodGlucoseCurrentInfo, completion: @escaping (_ err: CmdError, _ aModel: IDOCmdSetResponseModel?) -> Void) -> IDOCancellable {
        let json = IDOBloodGlucoseModel(operate: 1, currentInfoItem: item, statisticsInfoItem: nil, historyInfoItem: nil).toJsonString()
        let param = InnerCmdProtocolParam(evtType: .uploadBloodGlucose, json: json)
        
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 更新血糖统计数据
    @discardableResult public static func uploadBloodGlucoseStatisticsData(_ item: IDOBloodGlucoseStatisticsInfo, completion: @escaping (_ err: CmdError, _ aModel: IDOCmdSetResponseModel?) -> Void) -> IDOCancellable {
        let json = IDOBloodGlucoseModel(operate: 2, currentInfoItem: nil, statisticsInfoItem: item, historyInfoItem: nil).toJsonString()
        let param = InnerCmdProtocolParam(evtType: .uploadBloodGlucose, json: json)
        
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 更新血糖CGM历史数据
    @discardableResult public static func uploadBloodGlucoseHistoryData(_ item: IDOBloodGlucoseHistoryDataInfo, completion: @escaping (_ err: CmdError, _ aModel: IDOCmdSetResponseModel?) -> Void) -> IDOCancellable {
        let json = IDOBloodGlucoseModel(operate: 3, currentInfoItem: nil, statisticsInfoItem: nil, historyInfoItem: item).toJsonString()
        let param = InnerCmdProtocolParam(evtType: .uploadBloodGlucose, json: json)
        
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 开始算法原始数据采集
    @discardableResult public static func startAlgorithmRawDataDAQ(_ completion: @escaping (_ err: CmdError, _ aModel: IDOCmdSetResponseModel?) -> Void) -> IDOCancellable {
        let json = IDOAlgorithmRawDataParam(operate: 1, ppgSwitch: -1, accSwitch: -1).toJsonString()
        let param = InnerCmdProtocolParam(evtType: .algorithmRawData, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 结束算法原始数据采集
    @discardableResult public static func stopAlgorithmRawDataDAQ(_ completion: @escaping (_ err: CmdError, _ aModel: IDOCmdSetResponseModel?) -> Void) -> IDOCancellable {
        let json = IDOAlgorithmRawDataParam(operate: 3, ppgSwitch: -1, accSwitch: -1).toJsonString()
        let param = InnerCmdProtocolParam(evtType: .algorithmRawData, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 设置算法原始数据采集配置
    @discardableResult public static func setAlgorithmRawDataSensorConfig(ppg: IDOAlgorithmSensorSwitch, acc: IDOAlgorithmSensorSwitch, completion: @escaping (_ err: CmdError, _ aModel: IDOCmdSetResponseModel?) -> Void) -> IDOCancellable {
        let json = IDOAlgorithmRawDataParam(operate: 4, ppgSwitch: ppg.rawValue, accSwitch: acc.rawValue).toJsonString()
        let param = InnerCmdProtocolParam(evtType: .algorithmRawData, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 查询算法原始数据采集配置
    @discardableResult public static func  getAlgorithmRawDataSensorConfig(_ completion: @escaping (_ err: CmdError, _ aModel: IDORawDataSensorConfigReply?) -> Void) -> IDOCancellable {
        let json = IDOAlgorithmRawDataParam(operate: 5, ppgSwitch: -1, accSwitch: -1).toJsonString()
        let param = InnerCmdProtocolParam(evtType: .algorithmRawData, json: json)
        func send(completion: @escaping IDOCmdResponse<IDORawDataSensorConfigReply>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }

    /// 查询v3菜单列表
    @discardableResult public static func getMenuListV3(_ completion: @escaping (_ err: CmdError, _ aModel: IDOMenuListV3Model?) -> Void) -> IDOCancellable {
        let json = IDOMenuListV3ParamModel(operate: 2).toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setV3MenuList, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOMenuListV3Model>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }

    /// 设置v3菜单列表
    @discardableResult public static func setMenuListV3(items: [Int], completion: @escaping (_ err: CmdError, _ aModel: IDOCmdSetResponseModel?) -> Void) -> IDOCancellable {
        let json = IDOMenuListV3ParamModel(operate: 1, itemList: items).toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setV3MenuList, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    /// 情绪健康提醒 （设置 / 查询）
    @discardableResult public static func emotionHealthReminder(param: IDOEmotionHealthReminderParamModel, completion: @escaping (_ err: CmdError, _ aModel: IDOEmotionHealthReminderReplyModel?) -> Void) -> IDOCancellable {
        let json = param.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setEmotionHealthReminder, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOEmotionHealthReminderReplyModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }

    /// 应用列表样式 （设置/查询/删除）
    @discardableResult public static func appListStyle(param: IDOAppListStyleParamModel, completion: @escaping (_ err: CmdError, _ aModel: IDOAppListStyleReplyModel?) -> Void) -> IDOCancellable {
        let json = param.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .setApplicationListStyle, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOAppListStyleReplyModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    // -------------- 三诺app下发和获取V3血糖数据 --------------

    /// 设置血糖数据 (v01)
    @discardableResult public static func setBloodGlucoseDataV01(_ param: IDOBloodGlucoseSendInfo, completion: @escaping (_ err: CmdError, _ aModel: IDOBloodGlucoseInfoReplyV1?) -> Void) -> IDOCancellable {
        let model = IDOBloodGlucoseV1Model(operate: 1, sendInfo: param)
        let json = model.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .uploadBloodGlucose, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOBloodGlucoseInfoReplyV1>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }

    /// 获取血糖数据（v01）
    @discardableResult public static func getBloodGlucoseDataV01(localSerialNumber: Int, completion: @escaping (_ err: CmdError, _ aModel: IDOBloodGlucoseDataInfoV1?) -> Void) -> IDOCancellable {
        let getInfo = IDOBloodGlucoseGetInfo(localSerialNumber: localSerialNumber)
        let model = IDOBloodGlucoseV1Model(operate: 2, getInfo: getInfo)
        let json = model.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .uploadBloodGlucose, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOBloodGlucoseDataInfoV1>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }

    /// 停止血糖监测（v01）
    @discardableResult public static func stopBloodGlucoseDataV01(_ completion: @escaping (_ err: CmdError, _ aModel: IDOBloodGlucoseInfoReplyV1?) -> Void) -> IDOCancellable {
        let model = IDOBloodGlucoseV1Model(operate: 3)
        let json = model.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .uploadBloodGlucose, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOBloodGlucoseInfoReplyV1>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }

    // -------------- 车锁管理 --------------
    
    /// 获取车锁列表
    @discardableResult public static func getBikeLockList(_ completion: @escaping (_ err: CmdError, _ aModel: IDOBikeLockReplyModel?) -> Void) -> IDOCancellable {
        let model = IDOBikeLockModel(operate: 2)
        let json = model.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .bikeLock, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOBikeLockReplyModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }

    /// 设置车锁列表
    @discardableResult public static func setBikeLockList(_ items: [IDOBikeLockInfo], completion: @escaping (_ err: CmdError, _ aModel: IDOCmdSetResponseModel?) -> Void) -> IDOCancellable {
        let model = IDOBikeLockModel(operate: 1, items: items)
        let json = model.toJsonString()
        let param = InnerCmdProtocolParam(evtType: .bikeLock, json: json)
        func send(completion: @escaping IDOCmdResponse<IDOCmdSetResponseModel>) -> IDOCancellable {
            return Cmds._parseModel(param, completion: completion)
        }
        return send { rs in
            if case .success(let o) = rs {
                completion(CmdError(code: 0), o)
            } else if case .failure(let e) = rs {
                completion(e, nil)
            } else {
                completion(CmdError(code: -2), nil)
            }
        }
    }
    
    // 指令发送 & 解析 返回模型
    fileprivate static func _parseModel<T: IDOBaseModel>(_ param: CmdProtocolParam, completion: @escaping IDOCmdResponse<T>) -> IDOCancellable {
        let cancelToken = param.evtType.cancelToken
        _cmd?._sendOnMainThread(evtType: param.evtType.rawValue.int64, json: param.json, cancelToken: cancelToken) { rs in
            guard rs.code == 0 else {
                completion(.failure(CmdError(code: Int(rs.code?.int ?? -2), message: "code is null")))
                return
            }
            guard let jsonString = rs.json else {
                completion(.success(nil))
                return
            }
            // 未用到
            /* if T.self is Int.Type {
                 completion(.success(nil))
                 return
             } */
            if T.self is String.Type {
                completion(.success(jsonString as? T))
                return
            }
            guard let jsonData = jsonString.data(using: .utf8) else {
                completion(.success(nil))
                return
            }
            do {
                guard T.self is IDOCmdSetResponseModel.Type else {
                    let obj = try JSONDecoder().decode(T.self, from: jsonData)
                    completion(.success(obj))
                    return
                }
                
                // 针对不同的返回值，整合为同一个实体类
                // is_success / status_code / ret_code / err_code / status
                let jsonObj = try JSONSerialization.jsonObject(with: jsonData, options: [])
                guard let jsonDict = jsonObj as? [String: Any] else {
                    completion(.success(nil))
                    return
                }
                var val: Any?
                for key in ["is_success", "status_code", "ret_code", "err_code", "status", "error_code"] {
                    if jsonDict[key] != nil {
                        val = jsonDict[key]
                        break
                    }
                }
                if val != nil && val is Int {
                    completion(.success(IDOCmdSetResponseModel(isSuccess: val as! Int) as? T))
                } else {
                    completion(.success(nil))
                }
            } catch {
                #if DEBUG
                print("1error json:\(jsonString)")
                #endif
                completion(.failure(CmdError(code: -99, message: "Error parsing JSON: \(error)")))
            }
        }
        return CmdCancellable(token: cancelToken.token)
    }
    
    // 指令发送 & 解析 返回json
    fileprivate static func _parseJson(_ param: CmdProtocolParam, completion: @escaping (Int, [String: Any]?) -> ()) -> IDOCancellable {
        let cancelToken = param.evtType.cancelToken
        _cmd?._sendOnMainThread(evtType: param.evtType.rawValue.int64, json: param.json, cancelToken: cancelToken) { rs in
            guard rs.code == 0 else {
                completion(rs.code?.int ?? -1, nil)
                return
            }
            guard let jsonString = rs.json else {
                completion(0, nil)
                return
            }
            guard let jsonData = jsonString.data(using: .utf8) else {
                completion(0, nil)
                return
            }
            do {
                let obj = try JSONSerialization.jsonObject(with: jsonData, options: [])
                if let jsonDict = obj as? [String: Any] {
                    completion(0, jsonDict)
                } else {
                    completion(0, nil)
                }
            } catch {
                completion(0, nil)
            }
        }
        return CmdCancellable(token: cancelToken.token)
    }
}

private extension ApiEvtType {
    var cancelToken: CancelToken {
        return CancelToken(token: "\(self.rawValue)_\(Date().milliStamp)")
    }
}

/// 内部用于多组取消
fileprivate class InnerCmdCanceller: IDOCancellable {
    var isCancelled = false
    let token: String?
    fileprivate var cancellers = [IDOCancellable]()
    
    init(token: String? = nil) {
        self.token = token
    }
    
    func cancel() {
        cancellers.forEach {
            $0.cancel()
        }
    }
}

// 确保主线程调用
extension Cmd {
    func _sendOnMainThread(evtType: Int64, json: String?, cancelToken: CancelToken?, priority: IDOCmdPriority = .normal, completion: @escaping (Response) -> Void) {
        _runOnMainThread { [self] in
            return send(evtType: evtType, json: json, cancelToken: cancelToken, priority: priority.rawValue.int64, completion: completion)
        }
    }
}
