//
//  DataExchangeImpl.swift
//  protocol_channel
//
//  Created by hc on 2023/9/27.
//

import Foundation

private var _exchangeData: ApiExchangeData? {
    return SwiftProtocolChannelPlugin.shared.exchangeData
}

// 由于需要适配oc，以下swift无法直接适配，暂时屏蔽
//class ExchangeDataImpl: IDODataExchangeInterface {
//    
//    var status: IDOExchangeStatus {
//        return ExchangeDataDelegateImpl.shared.exchangeStatus
//    }
//    
//    func addExchange(delegate: IDOExchangeDataDelegate?) {
//        ExchangeDataDelegateImpl.shared.addDelegate(api: delegate)
//    }
//    
//    var supportV3ActivityExchange: Bool {
//        return sdk.funcTable.syncV3ActivityExchangeData
//    }
//
//
//    func appExec(_ type: IDOAppExecType) {
//        var obj: Any?
//        switch type {
//        case .appStart(let o):
//            obj = o.toInnerModel()
//        case .appEnd(let o):
//            obj = o.toInnerModel()
//        case .appIng(let o):
//            obj = o.toInnerModel()
//        case .appPause(let o):
//            obj = o.toInnerModel()
//        case .appRestore(let o):
//            obj = o.toInnerModel()
//        case .appIngV3(let o):
//            obj = o.toInnerModel()
//        case .appOperatePlan(let o):
//            obj = o.toInnerModel()
//        }
//        _exchangeData?.appExec(model: obj) {}
//    }
//
//    func appReplyExec(_ type: IDOAppReplyType) {
//        var obj: Any?
//        switch type {
//        case .bleStartReply(let o):
//            obj = o.toInnerModel()
//        case .bleIngReply(let o):
//            obj = o.toInnerModel()
//        case .bleEndReply(let o):
//            obj = o.toInnerModel()
//        case .blePauseReply(let o):
//            obj = o.toInnerModel()
//        case .bleRestoreReply(let o):
//            obj = o.toInnerModel()
//        case .bleOperatePlanReply(let o):
//            obj = o.toInnerModel()
//        case .appBlePauseReply(let o):
//            obj = o.toInnerModel()
//        case .appBleRestoreReply(let o):
//            obj = o.toInnerModel()
//        case .appBleEndReply(let o):
//            obj = o.toInnerModel()
//        }
//        _exchangeData?.appReplyExec(model: obj) {}
//    }
//
//    func getLastActivityData() {
//        _exchangeData?.getLastActivityData(completion: { status in })
//    }
//
//    func getActivityHrData() {
//        _exchangeData?.getActivityHrData(completion: { status in })
//    }
//    
//    func getActivityGpsData() {
//        _exchangeData?.getActivityGpsData(completion: { status in })
//    }
//
//
//}


class ExchangeDataOCImpl: IDODataExchangeOCInterface {
    func appExec(model: NSObject) {
        /// app 开始发起运动 IDOAppStartExchangeModel
        /// app 发起运动结束 IDOAppEndExchangeModel
        /// app 交换运动数据 IDOAppIngExchangeModel
        /// app 交换运动数据暂停 IDOAppPauseExchangeModel
        /// app 交换运动数据恢复 IDOAppRestoreExchangeModel
        /// app v3交换运动数据 IDOAppIngV3ExchangeModel
        /// app 操作计划运动 IDOAppOperatePlanExchangeModel
        
        var obj: Any?
        if (model is IDOAppStartExchangeModel) {
            obj = (model as! IDOAppStartExchangeModel).toInnerModel()
        } else if (model is IDOAppEndExchangeModel) {
            obj = (model as! IDOAppEndExchangeModel).toInnerModel()
        } else if (model is IDOAppIngExchangeModel) {
            obj = (model as! IDOAppIngExchangeModel).toInnerModel()
        } else if (model is IDOAppPauseExchangeModel) {
            obj = (model as! IDOAppPauseExchangeModel).toInnerModel()
        } else if (model is IDOAppRestoreExchangeModel) {
            obj = (model as! IDOAppRestoreExchangeModel).toInnerModel()
        } else if (model is IDOAppIngV3ExchangeModel) {
            obj = (model as! IDOAppIngV3ExchangeModel).toInnerModel()
        } else if (model is IDOAppOperatePlanExchangeModel) {
            obj = (model as! IDOAppOperatePlanExchangeModel).toInnerModel()
        }
        _runOnMainThread {
            _exchangeData?.appExec(model: obj) {}
        }
    }
    
    func appReplyExec(model: NSObject) {
        /*
         ble设备发送交换运动数据开始 app回复 IDOBleStartReplyExchangeModel
         ble设备交换运动数据过程中 app回复 IDOBleIngReplyExchangeModel
         ble设备发送交换运动数据结束 app回复 IDOBleEndReplyExchangeModel
         ble设备发送交换运动数据暂停 app回复 IDOBlePauseReplyExchangeModel
         ble设备发送交换运动数据恢复 app回复 IDOBleRestoreReplyExchangeModel
         ble设备操作运动计划 app回复 IDOBleOperatePlanReplyExchangeModel

         app发起运动 ble执行数据交换 app回复:

         ble设备发送交换运动数据暂停 app回复 IDOAppBlePauseReplyExchangeModel
         ble设备发送交换运动数据恢复 app回复 IDOAppBleRestoreReplyExchangeModel
         ble设备发送交换运动数据结束 app回复 IDOAppBleEndReplyExchangeModel
         */
        var obj: Any?
        if (model is IDOBleStartReplyExchangeModel) {
            obj = (model as! IDOBleStartReplyExchangeModel).toInnerModel()
        } else if (model is IDOBleIngReplyExchangeModel) {
            obj = (model as! IDOBleIngReplyExchangeModel).toInnerModel()
        }else if (model is IDOBleEndReplyExchangeModel) {
            obj = (model as! IDOBleEndReplyExchangeModel).toInnerModel()
        }else if (model is IDOBlePauseReplyExchangeModel) {
            obj = (model as! IDOBlePauseReplyExchangeModel).toInnerModel()
        }else if (model is IDOBleRestoreReplyExchangeModel) {
            obj = (model as! IDOBleRestoreReplyExchangeModel).toInnerModel()
        }else if (model is IDOBleOperatePlanReplyExchangeModel) {
            obj = (model as! IDOBleOperatePlanReplyExchangeModel).toInnerModel()
            
        }else if (model is IDOAppBlePauseReplyExchangeModel) {
            obj = (model as! IDOAppBlePauseReplyExchangeModel).toInnerModel()
        }else if (model is IDOAppBleRestoreReplyExchangeModel) {
            obj = (model as! IDOAppBleRestoreReplyExchangeModel).toInnerModel()
        }else if (model is IDOAppBleEndReplyExchangeModel) {
            obj = (model as! IDOAppBleEndReplyExchangeModel).toInnerModel()
        }
        _runOnMainThread {
            _exchangeData?.appReplyExec(model: obj) {}
        }
    }
    
    func addExchange(delegate: IDOExchangeDataOCDelegate?) {
        ExchangeDataOCDelegateImpl.shared.addDelegate(api: delegate)
    }
    
    var status: IDOExchangeStatus {
        return ExchangeDataOCDelegateImpl.shared.exchangeStatus
    }
    
    var supportV3ActivityExchange: Bool {
        return sdk.funcTable.syncV3ActivityExchangeData
    }

    func getLastActivityData() {
        _runOnMainThread {
            _exchangeData?.getLastActivityData(completion: { status in })
        }
    }

    func getActivityHrData() {
        _runOnMainThread {
            _exchangeData?.getActivityHrData(completion: { status in })
        }
    }
    
    func getActivityGpsData() {
        _runOnMainThread {
            _exchangeData?.getActivityGpsData(completion: { status in })
        }
    }
}


// MARK: -

/// app执行数据交换
public enum IDOAppExecType {
    /// app 开始发起运动
    case appStart(IDOAppStartExchangeModel)
    /// app 发起运动结束
    case appEnd(IDOAppEndExchangeModel)
    /// app 交换运动数据
    case appIng(IDOAppIngExchangeModel)
    /// app 交换运动数据暂停
    case appPause(IDOAppPauseExchangeModel)
    /// app 交换运动数据恢复
    case appRestore(IDOAppRestoreExchangeModel)
    /// app v3交换运动数据
    case appIngV3(IDOAppIngV3ExchangeModel)
    /// app 操作计划运动
    case appOperatePlan(IDOAppOperatePlanExchangeModel)
}

/// ble执行数据交换
public enum IDOAppReplyType {
    // ble发起运动 ble执行数据交换 app回复

    /// ble设备发送交换运动数据开始 app回复
    case bleStartReply(IDOBleStartReplyExchangeModel)
    /// ble设备交换运动数据过程中 app回复
    case bleIngReply(IDOBleIngReplyExchangeModel)
    /// ble设备发送交换运动数据结束 app回复
    case bleEndReply(IDOBleEndReplyExchangeModel)
    /// ble设备发送交换运动数据暂停 app回复
    case blePauseReply(IDOBlePauseReplyExchangeModel)
    /// ble设备发送交换运动数据恢复 app回复
    case bleRestoreReply(IDOBleRestoreReplyExchangeModel)
    /// ble设备操作运动计划 app回复
    case bleOperatePlanReply(IDOBleOperatePlanReplyExchangeModel)

    // app发起运动 ble执行数据交换 app回复

    /// ble设备发送交换运动数据暂停 app回复
    case appBlePauseReply(IDOAppBlePauseReplyExchangeModel)
    /// ble设备发送交换运动数据恢复 app回复
    case appBleRestoreReply(IDOAppBleRestoreReplyExchangeModel)
    /// ble设备发送交换运动数据结束 app回复
    case appBleEndReply(IDOAppBleEndReplyExchangeModel)
}

/// ble发起运动 app监听ble
public enum IDOBleExecType {
    /// ble设备发送交换运动数据开始
    case bleStart(IDOBleStartExchangeModel?)
    /// ble设备交换运动数据过程中
    case bleIng(IDOBleIngExchangeModel?)
    /// ble设备发送交换运动数据结束
    case bleEnd(IDOBleEndExchangeModel?)
    /// ble设备发送交换运动数据暂停
    case blePause(IDOBlePauseExchangeModel?)
    /// ble设备发送交换运动数据恢复
    case bleRestore(IDOBleRestoreExchangeModel?)
    /// ble设备操作运动计划
    case bleOperatePlan(IDOBleOperatePlanExchangeModel?)

    // app发起运动 app监听ble
    /// ble设备发送交换运动数据暂停
    case appBlePause(IDOAppBlePauseExchangeModel?)
    ///  ble设备发送交换运动数据恢复
    case appBleRestore(IDOAppBleRestoreExchangeModel?)
    /// ble设备发送交换运动数据结束
    case appBleEnd(IDOAppBleEndExchangeModel?)
}

/// app执行响应
public enum IDOBleReplyType {
    /// app 开始发起运动 ble回复
    case appStartReply(IDOAppStartReplyExchangeModel?)
    /// app 发起运动结束 ble回复
    case appEndReply(IDOAppEndReplyExchangeModel?)
    ///  app 交换运动数据 ble回复
    case appIngReply(IDOAppIngReplyExchangeModel?)
    /// app 交换运动数据暂停 ble回复
    case appPauseReply(IDOAppPauseReplyExchangeModel?)
    /// app 交换运动数据恢复 ble回复
    case appRestoreReply(IDOAppRestoreReplyExchangeModel?)
    /// app v3交换运动数据 ble回复
    case appIngV3Reply(IDOAppIngV3ReplyExchangeModel?)
    /// app 操作运动计划 ble回复
    case appOperatePlanReply(IDOAppOperatePlanReplyExchangeModel?)
    /// app 获取v3多运动一次活动数据 ble回复
    case appActivityDataReply(IDOAppActivityDataV3ExchangeModel?)
    /// app 获取v3多运动一次心率数据 ble回复
    case appActivityHrReply(IDOAppHrDataExchangeModel?)
    /// app 获取v3多运动一次GPS数据 ble回复
    case appActivityGpsReply(IDOAppGpsDataExchangeModel?)
}

// MARK: -

/// 交换数据状态
@objc
public enum IDOExchangeStatus: Int {
    case initial = 0
    /// 初始化
    case appStart = 1
    /// app发起开始
    case appStartReply = 2
    /// app发起开始 ble回复
    case appEnd = 3
    /// app发起结束
    case appEndReply = 4
    /// app发起结束 ble回复
    case appPause = 5
    /// app发起暂停
    case appPauseReply = 6
    /// app发起暂停 ble回复
    case appRestore = 7
    /// app发起恢复
    case appRestoreReply = 8
    /// app发起恢复 ble回复
    case appIng = 9
    /// app发起交换
    case appIngReply = 10
    /// app发起交换 ble回复
    case getActivity = 11
    /// 获取最后运动数据
    case getActivityReply = 12
    /// 获取最后运动数据 ble回复
    case getHr = 13
    /// 获取一分钟心率
    case getHrReply = 14
    /// 获取一分钟心率 ble回复
    case appStartPlan = 15
    /// app开始运动计划
    case appStartPlanReply = 16
    /// app开始运动计划 ble回复
    case appPausePlan = 17
    /// app暂停运动计划
    case appPausePlanReply = 18
    /// app暂停运动计划 ble回复
    case appRestorePlan = 19
    /// app恢复运动计划
    case appRestorePlanReply = 20
    /// app恢复运动计划 ble回复
    case appEndPlan = 21
    /// app结束运动计划
    case appEndPlanReply = 22
    /// app结束运动计划 ble回复
    case appSwitchAction = 23
    /// app切换动作
    case appSwitchActionReply = 24
    /// app结束运动计划 ble回复
    case appBlePause = 25
    /// app发起的运动 ble发起暂停
    case appBlePauseReply = 26
    /// app发起的运动 ble发起暂停 app回复
    case appBleRestore = 27
    /// app发起的运动 ble发起恢复
    case appBleRestoreReply = 28
    /// app发起的运动 ble发起恢复 app回复
    case appBleEnd = 29
    /// app发起的运动 ble发起结束
    case appBleEndReply = 30
    /// app发起的运动 ble发起结束 app回复
    case bleStart = 31
    /// ble发起的运动 ble发起开始
    case bleStartReply = 32
    /// ble发起的运动 ble发起开始 app回复
    case bleEnd = 33
    /// ble发起的运动 ble发起结束
    case bleEndReply = 34
    /// ble发起的运动 ble发起结束 app回复
    case blePause = 35
    /// ble发起的运动 ble发起暂停
    case blePauseReply = 36
    /// ble发起的运动 ble发起暂停 app回复
    case bleRestore = 37
    /// ble发起的运动 ble发起恢复
    case bleRestoreReply = 38
    /// ble发起的运动 ble发起恢复 app回复
    case bleIng = 39
    /// ble发起的运动 ble发起交换
    case bleIngReply = 40
    /// ble发起的运动 ble发起交换 app回复
    case bleStartPlan = 41
    /// ble开始运动计划
    case blePausePlan = 42
    /// ble暂停运动计划
    case bleRestorePlan = 43
    /// ble恢复运动计划
    case bleEndPlan = 44
    /// ble结束运动计划
    case bleSwitchAction = 45
    /// ble切换动作
    case bleOperatePlanReply = 46
}

/// Generated class from Pigeon that represents data sent in messages.
@objcMembers public class IDOExchangeBaseModel: NSObject {
    /// 日期
    public var day: Int
    /// 时
    public var hour: Int
    /// 分钟
    public var minute: Int
    /// 秒钟
    public var second: Int
    /// 运动类型
    public var sportType: Int

    public init(day: Int, hour: Int, minute: Int, second: Int, sportType: Int) {
        self.day = day
        self.hour = hour
        self.minute = minute
        self.second = second
        self.sportType = sportType
    }

    fileprivate func toInnerModel() -> ApiExchangeBaseModel {
        return ApiExchangeBaseModel(day: day.int64, hour: hour.int64, minute: minute.int64, second: second.int64, sportType: sportType.int64)
    }
}

/// Generated class from Pigeon that represents data sent in messages.
@objcMembers public class IDOExchangeV2Model: NSObject {
    public var baseModel: IDOExchangeBaseModel?
    /// 1:请求app打开gps  2：发起运动请求
    public var operate: Int
    ///  0: 无目标， 1: 重复次数，单位：次，
    ///  2: 距离,单位：米,  3: 卡路里, 单位：大卡,
    ///  4: 时长,单位：分钟, 5:  步数, 单位：步
    public var targetValue: Int
    /// 目标数值
    public var targetType: Int
    /// 是否强制开始 0:不强制,1:强制
    public var forceStart: Int
    /// 0:成功; 1:设备已经进入运动模式失败;
    /// 2: 设备电量低失败; 3:手环正在充电 4:正在使用Alexa 5:通话中
    public var retCode: Int
    /// 卡路里 (单位:J)
    public var calories: Int
    /// 距离 (单位:米)
    public var distance: Int
    /// 持续时间 (单位:秒钟)
    public var durations: Int
    /// 步数 (单位:步)
    public var step: Int
    /// 平均心率
    public var avgHr: Int
    /// 最大心率
    public var maxHr: Int
    /// 当前心率
    public var curHr: Int
    /// 序列号
    public var hrSerial: Int
    /// 燃烧脂肪时长 (单位：分钟)
    public var burnFatMins: Int
    /// 有氧时长 (单位：分钟)
    public var aerobicMins: Int
    /// 极限时长 (单位：分钟)
    public var limitMins: Int
    /// 是否存储数据
    public var isSave: Bool
    /// 0:全部有效, 1:距离无效， 2: gps 信号弱
    public var status: Int
    /// 心率间隔
    public var interval: Int
    /// 心率数据集合
    public var hrValues: [Int]?

    public init(baseModel: IDOExchangeBaseModel? = nil, operate: Int, targetValue: Int, targetType: Int, forceStart: Int, retCode: Int, calories: Int, distance: Int, durations: Int, step: Int, avgHr: Int, maxHr: Int, curHr: Int, hrSerial: Int, burnFatMins: Int, aerobicMins: Int, limitMins: Int, isSave: Bool, status: Int, interval: Int, hrValues: [Int]? = nil) {
        self.baseModel = baseModel
        self.operate = operate
        self.targetValue = targetValue
        self.targetType = targetType
        self.forceStart = forceStart
        self.retCode = retCode
        self.calories = calories
        self.distance = distance
        self.durations = durations
        self.step = step
        self.avgHr = avgHr
        self.maxHr = maxHr
        self.curHr = curHr
        self.hrSerial = hrSerial
        self.burnFatMins = burnFatMins
        self.aerobicMins = aerobicMins
        self.limitMins = limitMins
        self.isSave = isSave
        self.status = status
        self.interval = interval
        self.hrValues = hrValues
    }
}

/// Generated class from Pigeon that represents data sent in messages.
@objcMembers public class IDOExchangeV3Model: NSObject {
    public var baseModel: IDOExchangeBaseModel?
    /// 训练课程年份
    public var year: Int
    /// 训练课程月份
    public var month: Int
    /// 计划类型：
    ///  1：跑步计划3km , 2：跑步计划5km ,
    ///  3：跑步计划10km , 4：半程马拉松训练（二期）, 5：马拉松训练（二期）
    public var planType: Int
    /// 动作类型  1:快走；2:慢跑；3:中速跑；4快跑；
    ///  5:结束课程运动 （还要等待用户是否有自由运动）;
    ///  6:课程结束后自由运动 （此字段当operate为5起作用）
    public var actionType: Int
    /// 数据版本
    public var version: Int
    /// 1:请求app打开gps  2：发起运动请求
    public var operate: Int
    ///  0: 无目标， 1: 重复次数，单位：次，
    ///  2: 距离,单位：米,  3: 卡路里, 单位：大卡,
    ///  4: 时长,单位：分钟, 5:  步数, 单位：步
    public var targetValue: Int
    /// 目标数值
    public var targetType: Int
    /// 是否强制开始 0:不强制,1:强制
    public var forceStart: Int
    /// 0:成功; 1:设备已经进入运动模式失败;
    /// 2: 设备电量低失败; 3:手环正在充电 4:正在使用Alexa 5:通话中
    public var retCode: Int
    /// 卡路里 (单位:J)
    public var calories: Int
    /// 距离 (单位:米)
    public var distance: Int
    /// 持续时间 (单位:秒钟)
    public var durations: Int
    /// 步数 (单位:步)
    public var step: Int
    /// 0: 混合泳; 1: 自由泳; 2: 蛙泳; 3: 仰泳; 4: 蝶泳;
    public var swimPosture: Int
    /// 手环返回的状态 开始:1,暂停:2, 结束:3,0:无效状态
    public var status: Int
    /// 信号强弱  0: 表示信号弱， 1: 表示信号强
    public var signalFlag: Int
    /// 是否存储数据
    public var isSave: Bool
    /// app计算显示实时速度 单位km/h 100倍 15秒一个记录
    public var realTimeSpeed: Int
    /// app计算显示实时配速 单位 s
    public var realTimePace: Int
    /// 心率间隔
    public var interval: Int
    /// 心率个数
    public var hrCount: Int
    /// 燃烧脂肪时长 (单位：分钟)
    public var burnFatMins: Int
    /// 有氧时长 (单位：分钟)
    public var aerobicMins: Int
    /// 极限时长 (单位：分钟)
    public var limitMins: Int
    /// 心率数据集合
    public var hrValues: [Int]?
    /// 热身锻炼时长(秒钟)
    public var warmUpSecond: Int
    /// 无氧锻炼时长(秒钟)
    public var anaeroicSecond: Int
    /// 燃脂锻炼时长(秒钟)
    public var fatBurnSecond: Int
    /// 有氧锻炼时长(秒钟)
    public var aerobicSecond: Int
    /// 极限锻炼时长(秒钟)
    public var limitSecond: Int
    /// 平均心率
    public var avgHr: Int
    /// 最大心率
    public var maxHr: Int
    /// 当前心率
    public var curHr: Int
    /// 热身运动值
    public var warmUpValue: Int
    /// 脂肪燃烧运动值
    public var fatBurnValue: Int
    /// 有氧运动值
    public var aerobicValue: Int
    /// 极限运动值
    public var limitValue: Int
    /// 无氧运动值
    public var anaerobicValue: Int
    /// 平均速度 km/h
    public var avgSpeed: Int
    /// 最大速度 km/h
    public var maxSpeed: Int
    /// 平均步频
    public var avgStepFrequency: Int
    /// 最大步频
    public var maxStepFrequency: Int
    /// 平均步幅
    public var avgStepStride: Int
    /// 最大步幅
    public var maxStepStride: Int
    /// 平均公里配速
    public var kmSpeed: Int
    /// 最快公里配速
    public var fastKmSpeed: Int
    /// 公里配速个数
    public var kmSpeedCount: Int
    /// 公里配速集合
    public var kmSpeeds: [Int]?
    /// 英里配速个数
    public var mileCount: Int
    /// 英里配速集合
    public var mileSpeeds: [Int]?
    /// 步频个数
    public var stepsFrequencyCount: Int
    /// 步频集合
    public var stepsFrequencys: [Int]?
    /// 训练效果；  单位：无   范围 1.0 ~ 5.0 （*10倍）
    public var trainingEffect: Int
    /// 无氧训练效果；  单位：无   范围 1.0 ~ 5.0 （*10倍）
    public var anaerobicTrainingEffect: Int
    /// 最大摄氧量；  单位：毫升/公斤/分钟； 范围  0-80
    public var vo2Max: Int
    /// 本次动作训练个数
    public var actionDataCount: Int
    /// 课程内运动热量  单位千卡
    public var inClassCalories: Int
    /// 动作完成率 0—100
    public var completionRate: Int
    /// 心率控制率 0—100
    public var hrCompletionRate: Int
    /// 恢复时长：单位小时(app收到该数据之后，每过一小时需要自减一)
    public var recoverTime: Int
    /// 上个月平均每周的运动时间 单位分钟
    public var avgWeekActivityTime: Int
    /// 摄氧量等级  1:低等 2:业余 3:一般 4：平均 5：良好 6：优秀 7：专业
    public var grade: Int
    ///  动作完成内容
    ///  type : 动作类型  1快走；2慢跑; 3中速跑；4快跑
    ///  heart_con_value : 每个动作心率控制
    ///  time : 动作完成时间 单位秒
    ///  goal_time ：动作目标时间
    public var actionData: [[String: Any]]?
    /// 训练的课程日期偏移 从0开始
    public var trainingOffset: Int
    /// 运动倒计时
    public var countHour: Int
    /// 运动倒计时分
    public var countMinute: Int
    /// 运动倒计时秒
    public var countSecond: Int
    /// 动作目标时间  单位秒
    public var time: Int
    /// 心率范围低值
    public var lowHeart: Int
    /// 心率范围高值
    public var heightHeart: Int
    /// 实时配速个数
    public var paceSpeedCount: Int
    /// 实时配速数组  传过来的是s 每5s算一次
    public var paceSpeeds: [Int]?
    /// 实时速度个数
    public var realSpeedCount: Int
    /// 实时速度数组 传过来的是s 每5s算一次
    public var realSpeeds: [Int]?

    public init(baseModel: IDOExchangeBaseModel? = nil, year: Int, month: Int, planType: Int, actionType: Int, version: Int, operate: Int, targetValue: Int, targetType: Int, forceStart: Int, retCode: Int, calories: Int, distance: Int, durations: Int, step: Int, swimPosture: Int, status: Int, signalFlag: Int, isSave: Bool, realTimeSpeed: Int, realTimePace: Int, interval: Int, hrCount: Int, burnFatMins: Int, aerobicMins: Int, limitMins: Int, hrValues: [Int]? = nil, warmUpSecond: Int, anaeroicSecond: Int, fatBurnSecond: Int, aerobicSecond: Int, limitSecond: Int, avgHr: Int, maxHr: Int, curHr: Int, warmUpValue: Int, fatBurnValue: Int, aerobicValue: Int, limitValue: Int, anaerobicValue: Int, avgSpeed: Int, maxSpeed: Int, avgStepFrequency: Int, maxStepFrequency: Int, avgStepStride: Int, maxStepStride: Int, kmSpeed: Int, fastKmSpeed: Int, kmSpeedCount: Int, kmSpeeds: [Int]? = nil, mileCount: Int, mileSpeeds: [Int]? = nil, stepsFrequencyCount: Int, stepsFrequencys: [Int]? = nil, trainingEffect: Int, anaerobicTrainingEffect: Int, vo2Max: Int, actionDataCount: Int, inClassCalories: Int, completionRate: Int, hrCompletionRate: Int, recoverTime: Int, avgWeekActivityTime: Int, grade: Int, actionData: [[String: Any]]? = nil, trainingOffset: Int, countHour: Int, countMinute: Int, countSecond: Int, time: Int, lowHeart: Int, heightHeart: Int, paceSpeedCount: Int, paceSpeeds: [Int]? = nil, realSpeedCount: Int, realSpeeds: [Int]? = nil) {
        self.baseModel = baseModel
        self.year = year
        self.month = month
        self.planType = planType
        self.actionType = actionType
        self.version = version
        self.operate = operate
        self.targetValue = targetValue
        self.targetType = targetType
        self.forceStart = forceStart
        self.retCode = retCode
        self.calories = calories
        self.distance = distance
        self.durations = durations
        self.step = step
        self.swimPosture = swimPosture
        self.status = status
        self.signalFlag = signalFlag
        self.isSave = isSave
        self.realTimeSpeed = realTimeSpeed
        self.realTimePace = realTimePace
        self.interval = interval
        self.hrCount = hrCount
        self.burnFatMins = burnFatMins
        self.aerobicMins = aerobicMins
        self.limitMins = limitMins
        self.hrValues = hrValues
        self.warmUpSecond = warmUpSecond
        self.anaeroicSecond = anaeroicSecond
        self.fatBurnSecond = fatBurnSecond
        self.aerobicSecond = aerobicSecond
        self.limitSecond = limitSecond
        self.avgHr = avgHr
        self.maxHr = maxHr
        self.curHr = curHr
        self.warmUpValue = warmUpValue
        self.fatBurnValue = fatBurnValue
        self.aerobicValue = aerobicValue
        self.limitValue = limitValue
        self.anaerobicValue = anaerobicValue
        self.avgSpeed = avgSpeed
        self.maxSpeed = maxSpeed
        self.avgStepFrequency = avgStepFrequency
        self.maxStepFrequency = maxStepFrequency
        self.avgStepStride = avgStepStride
        self.maxStepStride = maxStepStride
        self.kmSpeed = kmSpeed
        self.fastKmSpeed = fastKmSpeed
        self.kmSpeedCount = kmSpeedCount
        self.kmSpeeds = kmSpeeds
        self.mileCount = mileCount
        self.mileSpeeds = mileSpeeds
        self.stepsFrequencyCount = stepsFrequencyCount
        self.stepsFrequencys = stepsFrequencys
        self.trainingEffect = trainingEffect
        self.anaerobicTrainingEffect = anaerobicTrainingEffect
        self.vo2Max = vo2Max
        self.actionDataCount = actionDataCount
        self.inClassCalories = inClassCalories
        self.completionRate = completionRate
        self.hrCompletionRate = hrCompletionRate
        self.recoverTime = recoverTime
        self.avgWeekActivityTime = avgWeekActivityTime
        self.grade = grade
        self.actionData = actionData
        self.trainingOffset = trainingOffset
        self.countHour = countHour
        self.countMinute = countMinute
        self.countSecond = countSecond
        self.time = time
        self.lowHeart = lowHeart
        self.heightHeart = heightHeart
        self.paceSpeedCount = paceSpeedCount
        self.paceSpeeds = paceSpeeds
        self.realSpeedCount = realSpeedCount
        self.realSpeeds = realSpeeds
    }
}

/// app 开始发起运动
///
@objcMembers public class IDOAppStartExchangeModel: NSObject {
    public var baseModel: IDOExchangeBaseModel?
    /// 目标类型
    public var targetType: Int
    /// 目标值
    public var targetValue: Int
    /// 是否强制开始 0:不强制,1:强制
    public var forceStart: Int
    /// 最大摄氧量 单位 ml/kg/min
    public var vo2max: Int
    /// 恢复时长：单位小时
    public var recoverTime: Int
    /// 上个月平均每周的运动时间 单位分钟
    public var avgWeekActivityTime: Int

    public init(baseModel: IDOExchangeBaseModel? = nil, targetType: Int =  0, targetValue: Int =  0, forceStart: Int, vo2max: Int =  0, recoverTime: Int =  0, avgWeekActivityTime: Int =  0) {
        self.baseModel = baseModel
        self.targetType = targetType
        self.targetValue = targetValue
        self.forceStart = forceStart
        self.vo2max = vo2max
        self.recoverTime = recoverTime
        self.avgWeekActivityTime = avgWeekActivityTime
    }

    fileprivate func toInnerModel() -> AppStartExchangeModel {
        return AppStartExchangeModel(baseModel: baseModel?.toInnerModel(),
                                     targetType: targetType.int64,
                                     targetValue: targetValue.int64,
                                     forceStart: forceStart.int64,
                                     vo2max: vo2max.int64,
                                     recoverTime: recoverTime.int64,
                                     avgWeekActivityTime: avgWeekActivityTime.int64)
    }
}

/// app 开始发起运动 ble回复
///
/// Generated class from Pigeon that represents data sent in messages.
@objcMembers public class IDOAppStartReplyExchangeModel: NSObject {
    public var baseModel: IDOExchangeBaseModel?
    /// 0:成功; 1:设备已经进入运动模式失败;
    /// 2:设备电量低失败;3:手环正在充电
    /// 4:正在使用Alexa 5:通话中
    public var retCode: Int

    public init(baseModel: IDOExchangeBaseModel? = nil, retCode: Int) {
        self.baseModel = baseModel
        self.retCode = retCode
    }
}

/// app 发起运动结束
///
/// Generated class from Pigeon that represents data sent in messages.
@objcMembers public class IDOAppEndExchangeModel: NSObject {
    public var baseModel: IDOExchangeBaseModel?
    /// 持续时长（单位：s）
    public var duration: Int
    /// 卡路里，单位大卡
    public var calories: Int
    /// 距离（单位：米）
    public var distance: Int
    /// 0:不保存，1:保存
    public var isSave: Int

    public init(baseModel: IDOExchangeBaseModel? = nil, duration: Int, calories: Int, distance: Int, isSave: Int) {
        self.baseModel = baseModel
        self.duration = duration
        self.calories = calories
        self.distance = distance
        self.isSave = isSave
    }

    fileprivate func toInnerModel() -> AppEndExchangeModel {
        return AppEndExchangeModel(baseModel: baseModel?.toInnerModel(),
                                   duration: duration.int64,
                                   calories: calories.int64,
                                   distance: distance.int64,
                                   isSave: isSave.int64)
    }
}

/// app 交换运动数据
///
/// Generated class from Pigeon that represents data sent in messages.
@objcMembers public class IDOAppIngExchangeModel: NSObject {
    public var baseModel: IDOExchangeBaseModel?
    /// 持续时长 单位s
    public var duration: Int
    /// 卡路里 单位大卡
    public var calories: Int
    /// 距离 单位0.01km
    public var distance: Int
    /// 0: 全部有效、1: 距离无效、 2: GPS信号弱
    public var status: Int

    public init(baseModel: IDOExchangeBaseModel? = nil, duration: Int, calories: Int, distance: Int, status: Int) {
        self.baseModel = baseModel
        self.duration = duration
        self.calories = calories
        self.distance = distance
        self.status = status
    }

    fileprivate func toInnerModel() -> AppIngExchangeModel {
        return AppIngExchangeModel(baseModel: baseModel?.toInnerModel(),
                                   duration: duration.int64,
                                   calories: calories.int64,
                                   distance: distance.int64,
                                   status: status.int64)
    }
}

/// app 交换运动数据暂停 ble回复
///
/// Generated class from Pigeon that represents data sent in messages.
@objcMembers public class IDOAppPauseReplyExchangeModel: NSObject {
    public var baseModel: IDOExchangeBaseModel?
    /// 暂停错误码 0:成功 非0:失败
    public var errCode: Int

    public init(baseModel: IDOExchangeBaseModel? = nil, errCode: Int) {
        self.baseModel = baseModel
        self.errCode = errCode
    }
}

/// app 交换运动数据恢复
///
/// Generated class from Pigeon that represents data sent in messages.
@objcMembers public class IDOAppRestoreExchangeModel: NSObject {
    public var baseModel: IDOExchangeBaseModel?

    public init(baseModel: IDOExchangeBaseModel? = nil) {
        self.baseModel = baseModel
    }

    fileprivate func toInnerModel() -> AppRestoreExchangeModel {
        return AppRestoreExchangeModel(baseModel: baseModel?.toInnerModel())
    }
}

/// app 交换运动数据恢复 ble回复
///
/// Generated class from Pigeon that represents data sent in messages.
@objcMembers public class IDOAppRestoreReplyExchangeModel: NSObject {
    public var baseModel: IDOExchangeBaseModel?
    /// 暂停错误码 0:成功 非0:失败
    public var errCode: Int

    public init(baseModel: IDOExchangeBaseModel? = nil, errCode: Int) {
        self.baseModel = baseModel
        self.errCode = errCode
    }
}

/// app v3交换运动数据
///
/// Generated class from Pigeon that represents data sent in messages.
@objcMembers public class IDOAppIngV3ExchangeModel: NSObject {
    public var baseModel: IDOExchangeBaseModel?
    /// 协议版本号
    public var version: Int
    /// 0: 表示信号弱  1: 表示信号强
    public var signal: Int
    /// app 距离
    public var distance: Int
    /// app计算显示实时配速，单位km/h，100倍
    public var speed: Int
    /// 持续时间
    public var duration: Int
    /// 卡路里
    public var calories: Int

    public init(baseModel: IDOExchangeBaseModel? = nil, version: Int, signal: Int, distance: Int, speed: Int, duration: Int, calories: Int) {
        self.baseModel = baseModel
        self.version = version
        self.signal = signal
        self.distance = distance
        self.speed = speed
        self.duration = duration
        self.calories = calories
    }

    fileprivate func toInnerModel() -> AppIngV3ExchangeModel {
        return AppIngV3ExchangeModel(
            baseModel: baseModel?.toInnerModel(),
            version: version.int64,
            signal: signal.int64,
            distance: distance.int64,
            speed: speed.int64,
            duration: duration.int64,
            calories: calories.int64)
    }
}

/// app v3交换运动数据 ble回复
///
/// Generated class from Pigeon that represents data sent in messages.
@objcMembers public class IDOAppIngV3ReplyExchangeModel: NSObject {
    public var baseModel: IDOExchangeBaseModel?
    /// 协议版本号
    public var version: Int
    /// 心率数据
    public var heartRate: Int
    /// 距离 单位根据单位设置的单位显示
    public var distance: Int
    /// 持续时间 秒钟
    public var duration: Int
    /// 动态卡路里
    public var realTimeCalories: Int
    /// 实时速度，单位km/h，扩大100倍
    public var realTimeSpeed: Int
    /// 实时公里配速 单位s/公里
    public var kmSpeed: Int
    /// 步数
    public var steps: Int
    /// 主泳姿
    public var swimPosture: Int
    /// 状态 0：无效 1：开始 2：手动暂停 3：结束 4：自动暂停
    public var status: Int
    /// 实时的配速，单位秒，5秒使用滑动平均，第5秒使用1-5秒数据，第6秒使用2-6秒数据
    public var realTimeSpeedPace: Int
    /// 有氧训练效果等级  单位无  范围 0-50 扩大10倍传输
    public var trainingEffect: Int
    /// 无氧运动训练效果等级 单位无  范围 0-50 扩大10倍传输
    public var anaerobicTrainingEffect: Int
    /// 动作类型
    /// 1快走
    /// 2慢跑
    /// 3中速跑
    /// 4快跑
    /// 5结束课程运动 （还要等待用户是否有自由运动）
    /// 6课程结束后自由运动（此字段当operate为5起作用）
    /// 运动累积时间=课程内训练时间+课程结束后计时
    public var actionType: Int
    /// 需要固件开启功能表
    /// action_type = 1—5时，该字段是运动倒计时时间（注：时间递减）
    /// action_type = 6时，该字段是课程结束后计时（注：时间递增）
    public var countHour: Int
    /// 需要固件开启功能表
    /// action_type = 1—5时，该字段是运动倒计时时间（注：时间递减）
    /// action_type = 6时，该字段是课程结束后计时（注：时间递增）
    public var countMinute: Int
    /// 需要固件开启功能表
    /// action_type = 1—5时，该字段是运动倒计时时间（注：时间递减）
    /// action_type = 6时，该字段是课程结束后计时（注：时间递增）
    public var countSecond: Int

    public init(baseModel: IDOExchangeBaseModel? = nil, version: Int, heartRate: Int, distance: Int, duration: Int, realTimeCalories: Int, realTimeSpeed: Int, kmSpeed: Int, steps: Int, swimPosture: Int, status: Int, realTimeSpeedPace: Int, trainingEffect: Int, anaerobicTrainingEffect: Int, actionType: Int, countHour: Int, countMinute: Int, countSecond: Int) {
        self.baseModel = baseModel
        self.version = version
        self.heartRate = heartRate
        self.distance = distance
        self.duration = duration
        self.realTimeCalories = realTimeCalories
        self.realTimeSpeed = realTimeSpeed
        self.kmSpeed = kmSpeed
        self.steps = steps
        self.swimPosture = swimPosture
        self.status = status
        self.realTimeSpeedPace = realTimeSpeedPace
        self.trainingEffect = trainingEffect
        self.anaerobicTrainingEffect = anaerobicTrainingEffect
        self.actionType = actionType
        self.countHour = countHour
        self.countMinute = countMinute
        self.countSecond = countSecond
    }
}

/// app 获取v3多运动数据
///
/// Generated class from Pigeon that represents data sent in messages.
@objcMembers public class IDOAppActivityDataV3ExchangeModel: NSObject {
    public var baseModel: IDOExchangeBaseModel?
    /// 年份
    public var year: Int
    /// 月份
    public var month: Int
    /// 协议库版本号
    public var version: Int
    /// 心率间隔 单位分钟
    public var hrInterval: Int
    /// 步数
    public var step: Int
    /// 持续时间
    public var durations: Int
    /// 卡路里
    public var calories: Int
    /// 距离
    public var distance: Int
    /// 脂肪燃烧的心率持续时间 单位分钟
    public var burnFatMins: Int
    /// 有氧运动的持续时间 单位分钟
    public var aerobicMins: Int
    /// 极限锻炼的持续时间 单位分钟
    public var limitMins: Int
    /// 热身运动
    public var warmUp: Int
    /// 脂肪燃烧
    public var fatBurning: Int
    /// 有氧训练
    public var aerobicExercise: Int
    /// 无氧训练
    public var anaerobicExercise: Int
    /// 极限训练
    public var extremeExercise: Int
    /// 热身运动的累计时长 单位秒
    public var warmUpTime: Int
    /// 脂肪燃烧的累计时长 单位秒
    public var fatBurningTime: Int
    /// 有氧运动的累计时长 单位秒
    public var aerobicExerciseTime: Int
    /// 无氧运动的累计时长 单位秒
    public var anaerobicExerciseTime: Int
    /// 极限锻炼的累计时长 单位秒
    public var extremeExerciseTime: Int
    /// 平均速度 单位km/h
    public var avgSpeed: Int
    /// 最快速度 单位km/h
    public var maxSpeed: Int
    /// 平均步幅
    public var avgStepStride: Int
    /// 最大步幅
    public var maxStepStride: Int
    /// 平均公里配速
    public var kmSpeed: Int
    /// 最快公里配速
    public var fastKmSpeed: Int
    /// 平均步频
    public var avgStepFrequency: Int
    /// 最大步频
    public var maxStepFrequency: Int
    /// 平均心率
    public var avgHrValue: Int
    /// 最大心率
    public var maxHrValue: Int
    /// 恢复时长 单位小时 app收到该数据之后，每过1小时需要自减1
    public var recoverTime: Int
    /// 最大摄氧量 单位 ml/kg/min
    public var vo2max: Int
    /// 训练效果 范围： 1.0 - 5.0 （扩大10倍传输）
    public var trainingEffect: Int
    /// 摄氧量等级 1：低等 2：业余 3：一般 4：平均 5：良好 6：优秀 7：专业
    public var grade: Int
    /// 步频详情个数
    public var stepsFrequencyCount: Int
    /// 英里配速个数 最大100
    public var miSpeedCount: Int
    /// 实时速度个数
    public var realSpeedCount: Int
    /// 实时配速个数
    public var paceSpeedCount: Int
    /// 公里配速详情个数 最大100
    public var kmSpeedCount: Int
    /// 本次动作训练个数
    public var actionDataCount: Int
    /// 课程内运动热量 单位千卡
    public var inClassCalories: Int
    /// 动作完成率 0—100
    public var completionRate: Int
    /// 心率控制率 0—100
    public var hrCompletionRate: Int
    /// 每公里耗时秒数 配速集合
    public var kmSpeeds: [Int]?
    /// 步频集合 单位步/分钟
    public var stepsFrequency: [Int]?
    /// 英里配速数组
    public var itemsMiSpeed: [Int]?
    /// 实时速度数组 单位km/h
    public var itemRealSpeed: [Int]?
    /// 实时配速数组
    public var paceSpeedItems: [Int]?
    ///  动作完成内容
    ///  type : 动作类型  1快走；2慢跑; 3中速跑；4快跑
    ///  heart_con_value : 每个动作心率控制
    ///  time : 动作完成时间 单位秒
    ///  goal_time ：动作目标时间
    public var actionData: [[String: Any]]?
    public init(baseModel: IDOExchangeBaseModel? = nil, year: Int, month: Int, version: Int, hrInterval: Int, step: Int, durations: Int, calories: Int, distance: Int, burnFatMins: Int, aerobicMins: Int, limitMins: Int, warmUp: Int, fatBurning: Int, aerobicExercise: Int, anaerobicExercise: Int, extremeExercise: Int, warmUpTime: Int, fatBurningTime: Int, aerobicExerciseTime: Int, anaerobicExerciseTime: Int, extremeExerciseTime: Int, avgSpeed: Int, maxSpeed: Int, avgStepStride: Int, maxStepStride: Int, kmSpeed: Int, fastKmSpeed: Int, avgStepFrequency: Int, maxStepFrequency: Int, avgHrValue: Int, maxHrValue: Int, recoverTime: Int, vo2max: Int, trainingEffect: Int, grade: Int, stepsFrequencyCount: Int, miSpeedCount: Int, realSpeedCount: Int, paceSpeedCount: Int, kmSpeedCount: Int, actionDataCount: Int, inClassCalories: Int, completionRate: Int, hrCompletionRate: Int, kmSpeeds: [Int]? = nil, stepsFrequency: [Int]? = nil, itemsMiSpeed: [Int]? = nil, itemRealSpeed: [Int]? = nil, paceSpeedItems: [Int]? = nil, actionData: [[String: Any]]? = nil) {
        self.baseModel = baseModel
        self.year = year
        self.month = month
        self.version = version
        self.hrInterval = hrInterval
        self.step = step
        self.durations = durations
        self.calories = calories
        self.distance = distance
        self.burnFatMins = burnFatMins
        self.aerobicMins = aerobicMins
        self.limitMins = limitMins
        self.warmUp = warmUp
        self.fatBurning = fatBurning
        self.aerobicExercise = aerobicExercise
        self.anaerobicExercise = anaerobicExercise
        self.extremeExercise = extremeExercise
        self.warmUpTime = warmUpTime
        self.fatBurningTime = fatBurningTime
        self.aerobicExerciseTime = aerobicExerciseTime
        self.anaerobicExerciseTime = anaerobicExerciseTime
        self.extremeExerciseTime = extremeExerciseTime
        self.avgSpeed = avgSpeed
        self.maxSpeed = maxSpeed
        self.avgStepStride = avgStepStride
        self.maxStepStride = maxStepStride
        self.kmSpeed = kmSpeed
        self.fastKmSpeed = fastKmSpeed
        self.avgStepFrequency = avgStepFrequency
        self.maxStepFrequency = maxStepFrequency
        self.avgHrValue = avgHrValue
        self.maxHrValue = maxHrValue
        self.recoverTime = recoverTime
        self.vo2max = vo2max
        self.trainingEffect = trainingEffect
        self.grade = grade
        self.stepsFrequencyCount = stepsFrequencyCount
        self.miSpeedCount = miSpeedCount
        self.realSpeedCount = realSpeedCount
        self.paceSpeedCount = paceSpeedCount
        self.kmSpeedCount = kmSpeedCount
        self.actionDataCount = actionDataCount
        self.inClassCalories = inClassCalories
        self.completionRate = completionRate
        self.hrCompletionRate = hrCompletionRate
        self.kmSpeeds = kmSpeeds
        self.stepsFrequency = stepsFrequency
        self.itemsMiSpeed = itemsMiSpeed
        self.itemRealSpeed = itemRealSpeed
        self.paceSpeedItems = paceSpeedItems
        self.actionData = actionData
    }
}

/// app发起运动 ble设备发送交换运动数据暂停
///
/// Generated class from Pigeon that represents data sent in messages.
@objcMembers public class IDOAppBlePauseExchangeModel: NSObject {
    public var baseModel: IDOExchangeBaseModel?
    public init(baseModel: IDOExchangeBaseModel? = nil) {
        self.baseModel = baseModel
    }
}

/// app发起运动 ble设备发送交换运动数据暂停 app回复
///
/// Generated class from Pigeon that represents data sent in messages.
@objcMembers public class IDOAppBlePauseReplyExchangeModel: NSObject {
    public var baseModel: IDOExchangeBaseModel?
    /// 0: 成功; 1: 没有进入运动模式失败
    public var errCode: Int
    public init(baseModel: IDOExchangeBaseModel? = nil, errCode: Int) {
        self.baseModel = baseModel
        self.errCode = errCode
    }

    fileprivate func toInnerModel() -> AppBlePauseReplyExchangeModel {
        return AppBlePauseReplyExchangeModel(
            baseModel: baseModel?.toInnerModel(),
            errCode: errCode.int64)
    }
}

/// app发起运动 ble设备发送交换运动数据恢复
///
/// Generated class from Pigeon that represents data sent in messages.
@objcMembers public class IDOAppBleRestoreExchangeModel: NSObject {
    public var baseModel: IDOExchangeBaseModel?
    public init(baseModel: IDOExchangeBaseModel? = nil) {
        self.baseModel = baseModel
    }
}

/// app发起运动 ble设备发送交换运动数据恢复 app回复
///
/// Generated class from Pigeon that represents data sent in messages.
@objcMembers public class IDOAppBleRestoreReplyExchangeModel: NSObject {
    public var baseModel: IDOExchangeBaseModel?
    /// 0: 成功; 1: 没有进入运动模式失败
    public var errCode: Int
    public init(baseModel: IDOExchangeBaseModel? = nil, errCode: Int) {
        self.baseModel = baseModel
        self.errCode = errCode
    }

    fileprivate func toInnerModel() -> AppBleRestoreReplyExchangeModel {
        return AppBleRestoreReplyExchangeModel(
            baseModel: baseModel?.toInnerModel(),
            errCode: errCode.int64)
    }
}

/// app发起运动 ble设备发送交换运动数据结束
///
/// Generated class from Pigeon that represents data sent in messages.
@objcMembers public class IDOAppBleEndExchangeModel: NSObject {
    /// 持续时长 单位s
    public var duration: Int
    /// 卡路里 单位大卡
    public var calories: Int
    /// 距离 单位0.01km
    public var distance: Int
    /// 平均心率
    public var avgHr: Int
    /// 最大心率
    public var maxHr: Int
    /// 脂肪燃烧时长 单位分钟
    public var burnFatMins: Int
    /// 心肺锻炼时长 单位分钟
    public var aerobicMins: Int
    /// 极限锻炼时长 单位分钟
    public var limitMins: Int
    /// 0:不保存，1:保存
    public var isSave: Int
    public init(duration: Int, calories: Int, distance: Int, avgHr: Int, maxHr: Int, burnFatMins: Int, aerobicMins: Int, limitMins: Int, isSave: Int) {
        self.duration = duration
        self.calories = calories
        self.distance = distance
        self.avgHr = avgHr
        self.maxHr = maxHr
        self.burnFatMins = burnFatMins
        self.aerobicMins = aerobicMins
        self.limitMins = limitMins
        self.isSave = isSave
    }
}

/// app发起运动 ble设备发送交换运动数据结束 app回复
///
/// Generated class from Pigeon that represents data sent in messages.
@objcMembers public class IDOAppBleEndReplyExchangeModel: NSObject {
    public var baseModel: IDOExchangeBaseModel?
    /// 0: 成功; 1: 没有进入运动模式失败
    public var errCode: Int
    /// 持续时长 单位s
    public var duration: Int
    /// 卡路里 单位大卡
    public var calories: Int
    /// 距离 单位0.01km
    public var distance: Int
    public init(baseModel: IDOExchangeBaseModel? = nil, errCode: Int, duration: Int, calories: Int, distance: Int) {
        self.baseModel = baseModel
        self.errCode = errCode
        self.duration = duration
        self.calories = calories
        self.distance = distance
    }

    fileprivate func toInnerModel() -> AppBleEndReplyExchangeModel {
        return AppBleEndReplyExchangeModel(
            baseModel: baseModel?.toInnerModel(),
            errCode: errCode.int64,
            duration: duration.int64,
            calories: calories.int64,
            distance: distance.int64)
    }
}

/// ble发起运动 ble设备发送交换运动数据开始
///
/// Generated class from Pigeon that represents data sent in messages.
@objcMembers
public class IDOBleStartExchangeModel: NSObject {
    public var baseModel: IDOExchangeBaseModel?
    /// 1：请求app打开gps 2：发起运动请求  3:发起运动开始后台联动请求
    public var operate: Int
    public init(baseModel: IDOExchangeBaseModel? = nil, operate: Int) {
        self.baseModel = baseModel
        self.operate = operate
    }
}

/// ble发起的运动 ble设备交换运动数据过程中
///
/// Generated class from Pigeon that represents data sent in messages.
@objcMembers
public class IDOBleIngExchangeModel: NSObject {
    public var baseModel: IDOExchangeBaseModel?
    /// 距离 单位：0.01km
    public var distance: Int
    public init(baseModel: IDOExchangeBaseModel? = nil, distance: Int) {
        self.baseModel = baseModel
        self.distance = distance
    }
}

/// ble发起的运动 ble设备发送交换运动数据结束
///
/// Generated class from Pigeon that represents data sent in messages.
@objcMembers
public class IDOBleEndExchangeModel: NSObject {
    public var baseModel: IDOExchangeBaseModel?
    public init(baseModel: IDOExchangeBaseModel? = nil) {
        self.baseModel = baseModel
    }
}

/// ble发起的运动 ble设备发送交换运动数据暂停
///
/// Generated class from Pigeon that represents data sent in messages.
@objcMembers
public class IDOBlePauseExchangeModel: NSObject{
    public var baseModel: IDOExchangeBaseModel?
    public init(baseModel: IDOExchangeBaseModel? = nil) {
        self.baseModel = baseModel
    }
}

/// ble发起的运动 ble设备发送交换运动数据恢复
///
/// Generated class from Pigeon that represents data sent in messages.
@objcMembers
public class IDOBleRestoreExchangeModel: NSObject {
    public var baseModel: IDOExchangeBaseModel?
    public init(baseModel: IDOExchangeBaseModel? = nil) {
        self.baseModel = baseModel
    }
}

/// ble发起的运动 ble设备发送交换运动数据开始 app回复
///
/// Generated class from Pigeon that represents data sent in messages.
@objcMembers
public class IDOBleStartReplyExchangeModel: NSObject {
    public var baseModel: IDOExchangeBaseModel?
    /// 1：请求app打开gps 2：发起运动请求
    public var operate: Int
    /// 0: 成功 非0: 失败
    public var retCode: Int
    public init(baseModel: IDOExchangeBaseModel? = nil, operate: Int, retCode: Int) {
        self.baseModel = baseModel
        self.operate = operate
        self.retCode = retCode
    }

    fileprivate func toInnerModel() -> BleStartReplyExchangeModel {
        return BleStartReplyExchangeModel(
            baseModel: baseModel?.toInnerModel(),
            operate: operate.int64,
            retCode: retCode.int64)
    }
}

/// ble发起的运动 ble设备交换运动数据过程中 app回复
///
/// Generated class from Pigeon that represents data sent in messages.
@objcMembers
public class IDOBleIngReplyExchangeModel: NSObject {
    public var baseModel: IDOExchangeBaseModel?
    /// 距离 单位：0.01km
    public var distance: Int
    public init(baseModel: IDOExchangeBaseModel? = nil, distance: Int) {
        self.baseModel = baseModel
        self.distance = distance
    }

    fileprivate func toInnerModel() -> BleIngReplyExchangeModel {
        return BleIngReplyExchangeModel(
            baseModel: baseModel?.toInnerModel(),
            distance: distance.int64)
    }
}

/// ble发起的运动 ble设备发送交换运动数据结束 app回复
///
/// Generated class from Pigeon that represents data sent in messages.
@objcMembers
public class IDOBleEndReplyExchangeModel: NSObject {
    public var baseModel: IDOExchangeBaseModel?
    /// 0: 成功 非0: 失败
    public var retCode: Int

    public init(baseModel: IDOExchangeBaseModel? = nil, retCode: Int) {
        self.baseModel = baseModel
        self.retCode = retCode
    }

    fileprivate func toInnerModel() -> BleEndReplyExchangeModel {
        return BleEndReplyExchangeModel(
            baseModel: baseModel?.toInnerModel(),
            retCode: retCode.int64)
    }
}

/// ble发起的运动 ble设备发送交换运动数据暂停 app回复
///
/// Generated class from Pigeon that represents data sent in messages.
@objcMembers
public class IDOBlePauseReplyExchangeModel: NSObject {
    public var baseModel: IDOExchangeBaseModel?
    /// 0: 成功 非0: 失败
    public var retCode: Int

    public init(baseModel: IDOExchangeBaseModel? = nil, retCode: Int) {
        self.baseModel = baseModel
        self.retCode = retCode
    }

    fileprivate func toInnerModel() -> BlePauseReplyExchangeModel {
        return BlePauseReplyExchangeModel(
            baseModel: baseModel?.toInnerModel(),
            retCode: retCode.int64)
    }
}

/// ble发起的运动 ble设备发送交换运动数据恢复 app回复
///
/// Generated class from Pigeon that represents data sent in messages.
@objcMembers
public class IDOBleRestoreReplyExchangeModel: NSObject {
    public var baseModel: IDOExchangeBaseModel?
    /// 0: 成功 非0: 失败
    public var retCode: Int

    public init(baseModel: IDOExchangeBaseModel? = nil, retCode: Int) {
        self.baseModel = baseModel
        self.retCode = retCode
    }

    fileprivate func toInnerModel() -> BleRestoreReplyExchangeModel {
        return BleRestoreReplyExchangeModel(
            baseModel: baseModel?.toInnerModel(),
            retCode: retCode.int64)
    }
}

/// app 操作计划运动
///
/// Generated class from Pigeon that represents data sent in messages.
@objcMembers
public class IDOAppOperatePlanExchangeModel: NSObject {
    public var baseModel: IDOExchangeBaseModel?
    /// 1:开始运动，2：暂停运动, 3:恢复运动 ，4：结束运动, 5: 切换动作
    public var operate: Int
    /// 训练的课程日期偏移 从0开始
    public var trainingOffset: Int
    /// 计划类型：1：跑步计划3km，2：跑步计划5km，
    /// 3：跑步计划10km，4：半程马拉松训练（二期，5：马拉松训练（二期）
    public var planType: Int

    public init(baseModel: IDOExchangeBaseModel? = nil, operate: Int, trainingOffset: Int, planType: Int) {
        self.baseModel = baseModel
        self.operate = operate
        self.trainingOffset = trainingOffset
        self.planType = planType
    }

    fileprivate func toInnerModel() -> AppOperatePlanExchangeModel {
        return AppOperatePlanExchangeModel(
            baseModel: baseModel?.toInnerModel(),
            operate: operate.int64,
            trainingOffset: trainingOffset.int64,
            planType: planType.int64)
    }
}

/// app 操作计划运动 ble回复
///
/// Generated class from Pigeon that represents data sent in messages.
@objcMembers
public class IDOAppOperatePlanReplyExchangeModel: NSObject {
    public var baseModel: IDOExchangeBaseModel?
    /// 计划类型：1：跑步计划3km，2：跑步计划5km，
    /// 3：跑步计划10km，4：半程马拉松训练（二期，5：马拉松训练（二期）
    public var planType: Int
    /// 1:开始运动，2：暂停运动, 3:恢复运动 ，4：结束运动, 5: 切换动作
    public var operate: Int
    /// 动作类型  1:快走；2:慢跑；3:中速跑；4:快跑  ；
    /// 5:结束课程运动 （还要等待用户是否有自由运动）；
    /// 6:课程结束后自由运动 （此字段当operate为5起作用）
    public var actionType: Int
    /// 0为成功，非0为失败
    public var errorCode: Int

    public init(baseModel: IDOExchangeBaseModel? = nil, planType: Int, operate: Int, actionType: Int, errorCode: Int) {
        self.baseModel = baseModel
        self.planType = planType
        self.operate = operate
        self.actionType = actionType
        self.errorCode = errorCode
    }
}

/// ble 操作计划运动
///
/// Generated class from Pigeon that represents data sent in messages.
@objcMembers
public class IDOBleOperatePlanExchangeModel: NSObject {
    public var baseModel: IDOExchangeBaseModel?
    /// 1:开始运动，2：暂停运动, 3:恢复运动 ，4：结束运动, 5: 切换动作
    public var operate: Int
    /// 计划类型：1：跑步计划3km，2：跑步计划5km，
    /// 3：跑步计划10km，4：半程马拉松训练（二期，5：马拉松训练（二期）
    public var planType: Int
    /// 动作类型  1:快走；2:慢跑；3:中速跑；4:快跑  ；
    /// 5:结束课程运动 （还要等待用户是否有自由运动）；
    /// 6:课程结束后自由运动 （此字段当operate为5起作用）
    public var actionType: Int
    /// 0为成功，非0为失败
    public var errorCode: Int
    /// 训练课程年份
    public var trainingYear: Int
    /// 训练课程月份
    public var trainingMonth: Int
    /// 训练课程日期
    public var trainingDay: Int
    /// 动作目标时间  单位秒
    public var time: Int
    /// 心率范围低值
    public var lowHeart: Int
    /// 心率范围高值
    public var heightHeart: Int

    public init(baseModel: IDOExchangeBaseModel? = nil, operate: Int, planType: Int, actionType: Int, errorCode: Int, trainingYear: Int, trainingMonth: Int, trainingDay: Int, time: Int, lowHeart: Int, heightHeart: Int) {
        self.baseModel = baseModel
        self.operate = operate
        self.planType = planType
        self.actionType = actionType
        self.errorCode = errorCode
        self.trainingYear = trainingYear
        self.trainingMonth = trainingMonth
        self.trainingDay = trainingDay
        self.time = time
        self.lowHeart = lowHeart
        self.heightHeart = heightHeart
    }
}

/// ble 操作计划运动 app回复
///
/// Generated class from Pigeon that represents data sent in messages.
@objcMembers
public class IDOBleOperatePlanReplyExchangeModel: NSObject {
    public var baseModel: IDOExchangeBaseModel?
    /// 1:开始运动，2：暂停运动, 3:恢复运动 ，4：结束运动, 5: 切换动作
    public var operate: Int
    /// 计划类型：1：跑步计划3km，2：跑步计划5km，
    /// 3：跑步计划10km，4：半程马拉松训练（二期，5：马拉松训练（二期）
    public var planType: Int
    /// 动作类型  1:快走；2:慢跑；3:中速跑；4:快跑  ；
    /// 5:结束课程运动 （还要等待用户是否有自由运动）；
    /// 6:课程结束后自由运动 （此字段当operate为5起作用）
    public var actionType: Int
    /// 0为成功，非0为失败
    public var errorCode: Int

    public init(baseModel: IDOExchangeBaseModel? = nil, operate: Int, planType: Int, actionType: Int, errorCode: Int) {
        self.baseModel = baseModel
        self.operate = operate
        self.planType = planType
        self.actionType = actionType
        self.errorCode = errorCode
    }

    fileprivate func toInnerModel() -> BleOperatePlanReplyExchangeModel {
        return BleOperatePlanReplyExchangeModel(
            baseModel: baseModel?.toInnerModel(),
            operate: operate.int64,
            planType: planType.int64,
            actionType: actionType.int64,
            errorCode: errorCode.int64)
    }
}

/// app 交换运动数据暂停
@objcMembers
public class IDOAppPauseExchangeModel: NSObject {
    public var baseModel: IDOExchangeBaseModel
    /// 暂停时
    public var pauseHour: Int
    /// 暂停分
    public var pauseMinute: Int
    /// 暂停秒
    public var pauseSecond: Int

    public init(baseModel: IDOExchangeBaseModel) {
        self.baseModel = baseModel
        self.pauseHour = baseModel.hour
        self.pauseMinute = baseModel.minute
        self.pauseSecond = baseModel.second
    }

    fileprivate func toInnerModel() -> AppPauseExchangeModel {
        return AppPauseExchangeModel(
            baseModel: baseModel.toInnerModel(),
            pauseHour: pauseHour.int64,
            pauseMinute: pauseMinute.int64,
            pauseSecond: pauseSecond.int64)
    }
}

/// app 交换运动数据 ble回复
@objcMembers
public class IDOAppIngReplyExchangeModel: NSObject {
    public var baseModel: IDOExchangeBaseModel?

    /// 卡路里 单位大卡
    public var calories: Int

    /// 距离 单位0.01km
    public var distance: Int

    /// 0: 全部有效、1: 距离无效、 2: GPS信号弱
    public var status: Int

    /// 步数
    public var step: Int

    /// 当前心率
    public var currentHr: Int

    /// 心率间隔 单位s
    public var interval: Int

    /// 序列号
    public var hrSerial: Int

    /// 心率值数据
    public var hrJson: [Int]?

    public init(baseModel: IDOExchangeBaseModel? = nil, calories: Int, distance: Int, status: Int, step: Int, currentHr: Int, interval: Int, hrSerial: Int, hrJson: [Int]? = nil) {
        self.baseModel = baseModel
        self.calories = calories
        self.distance = distance
        self.status = status
        self.step = step
        self.currentHr = currentHr
        self.interval = interval
        self.hrSerial = hrSerial
        self.hrJson = hrJson
    }
}

// app v3 多运动数交换中获取1分钟心率数据
///
/// Generated class from Pigeon that represents data sent in messages.
@objcMembers
public class IDOAppHrDataExchangeModel: NSObject {
    public var baseModel: IDOExchangeBaseModel?
    /// 协议版本号
    public var version: Int
    /// 心率数据数组长度 最大60
    public var heartRateHistoryLen: Int
    /// 心率间隔 单位秒
    public var interval: Int
    /// 心率数据数组 存一分钟的心率数据, 1s存一个
    public var heartRates: [Int]?

    public init(baseModel: IDOExchangeBaseModel? = nil, version: Int, heartRateHistoryLen: Int, interval: Int, heartRates: [Int]? = nil) {
        self.baseModel = baseModel
        self.version = version
        self.heartRateHistoryLen = heartRateHistoryLen
        self.interval = interval
        self.heartRates = heartRates
    }
}

/// app v3 多运动数交换中获取gps数据
@objcMembers
public class IDOAppGpsDataExchangeModel: NSObject {
    /// 基础数据 日期、时间、运动类型
    public var baseModel: IDOExchangeBaseModel?
    /// 协议版本号
    public var version: Int
    /// 坐标点时间间隔 单位秒
    public var intervalSecond: Int
    /// 坐标点个数
    public var gpsCount: Int
    /// gps数据详情集合 [{'latitude':0,'longitude':0}]
    public var gpsData: [[String:Any]]?
    
    public init(baseModel: IDOExchangeBaseModel? = nil, version: Int, intervalSecond: Int, gpsCount: Int, gpsData: [[String:Any]]? = nil) {
        self.baseModel = baseModel
        self.version = version
        self.intervalSecond = intervalSecond
        self.gpsCount = gpsCount
        self.gpsData = gpsData
    }
}

/// app 发起运动结束 ble回复
@objcMembers
public class IDOAppEndReplyExchangeModel: NSObject {
    public var baseModel: IDOExchangeBaseModel?
    /// 0:成功; 1:设备结束失败
    public var errorCode: Int
    /// 卡路里，单位大卡
    public var calories: Int
    /// 距离（单位：米）
    public var distance: Int
    /// 步数 (单位:步)
    public var step: Int
    /// 平均心率
    public var avgHr: Int
    /// 最大心率
    public var maxHr: Int
    /// 脂肪燃烧时长 单位分钟
    public var burnFatMins: Int
    /// 心肺锻炼时长 单位分钟
    public var aerobicMins: Int
    /// 极限锻炼时长 单位分钟
    public var limitMins: Int

    init(baseModel: IDOExchangeBaseModel? = nil, errorCode: Int, calories: Int, distance: Int, step: Int, avgHr: Int, maxHr: Int, burnFatMins: Int, aerobicMins: Int, limitMins: Int) {
        self.baseModel = baseModel
        self.errorCode = errorCode
        self.calories = calories
        self.distance = distance
        self.step = step
        self.avgHr = avgHr
        self.maxHr = maxHr
        self.burnFatMins = burnFatMins
        self.aerobicMins = aerobicMins
        self.limitMins = limitMins
    }
}
