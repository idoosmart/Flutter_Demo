//
//  ExchangeDataDelegateImpl.swift
//  protocol_channel
//
//  Created by hedongyang on 2023/11/24.
//

import Foundation


@objc
public protocol IDOExchangeDataOCDelegate: NSObjectProtocol {
    
    /// ble发起运动 app监听ble
    /// - Parameter model: 监听ble执行数据实体
    /// ```
    /// 数据实体包括：
    /// ble设备发送交换运动数据开始 IDOBleStartExchangeModel
    /// ble设备交换运动数据过程中 IDOBleIngExchangeModel
    /// ble设备发送交换运动数据结束 IDOBleEndExchangeModel
    /// ble设备发送交换运动数据暂停 IDOBlePauseExchangeModel
    /// ble设备发送交换运动数据恢复 IDOBleRestoreExchangeModel
    /// ble设备操作运动计划 IDOBleOperatePlanExchangeModel
    /// app发起运动 app监听ble
    /// ble设备发送交换运动数据暂停 IDOAppBlePauseExchangeModel
    /// ble设备发送交换运动数据恢复 IDOAppBleRestoreExchangeModel
    /// ble设备发送交换运动数据结束 IDOAppBleEndExchangeModel
    /// ```
    func appListenBleExec(model: NSObject)

    /// app执行响应
    /// - Parameter model: 监听app执行Ble响应实体
    /// ```
    /// 响应实体包括：
    /// app 开始发起运动 ble回复 IDOAppStartReplyExchangeModel
    /// app 发起运动结束 ble回复 IDOAppEndReplyExchangeModel
    /// app 交换运动数据 ble回复 IDOAppIngReplyExchangeModel
    /// app 交换运动数据暂停 ble回复 IDOAppPauseReplyExchangeModel
    /// app 交换运动数据恢复 ble回复 IDOAppRestoreReplyExchangeModel
    /// app v3交换运动数据 ble回复 IDOAppIngV3ReplyExchangeModel
    /// app 操作运动计划 ble回复 IDOAppOperatePlanReplyExchangeModel
    /// app 获取v3多运动一次活动数据 ble回复 IDOAppActivityDataV3ExchangeModel
    /// app 获取v3多运动一次心率数据 ble回复 IDOAppHrDataExchangeModel
    /// app 获取v3多运动一次GPS数据 ble回复 IDOAppGpsDataExchangeModel
    /// ```
    func appListenAppExec(model: NSObject)

    /**
     * 交换v2数据
     * @param model 监听v2数据交换实体
     */
    func exchangeV2Data(model: IDOExchangeV2Model)

    /**
     * 交换v3数据
     * @param model 监听v3数据交换实体
     */
    func exchangeV3Data(model: IDOExchangeV3Model)
}


class ExchangeDataOCDelegateImpl: ApiExchangeDataDelegate {
    
    static let shared = ExchangeDataOCDelegateImpl()
    private init() {}
    
    var exchangeStatus: IDOExchangeStatus = IDOExchangeStatus.initial
    
    private var delegate: IDOExchangeDataOCDelegate?
    
    func addDelegate(api: IDOExchangeDataOCDelegate?) {
       delegate = api
    }
    
    func listenExchangeState(status: ApiExchangeStatus) throws {
        exchangeStatus = IDOExchangeStatus(rawValue: status.rawValue) ?? .initial
    }
    
    func listenBleResponse(response: Any) throws {
        if response is BleStartExchangeModel {
            // ble设备发送交换运动数据开始
            let o = response as! BleStartExchangeModel
            delegate?.appListenBleExec(model: o.toOuterModel())
        } else if response is BleIngExchangeModel {
            // ble设备交换运动数据过程中
            let o = response as! BleIngExchangeModel
            delegate?.appListenBleExec(model: o.toOuterModel())
        } else if response is BleEndExchangeModel {
            // ble设备发送交换运动数据结束
            let o = response as! BleEndExchangeModel
            delegate?.appListenBleExec(model: o.toOuterModel())
        } else if response is BlePauseExchangeModel {
            // ble设备发送交换运动数据暂停
            let o = response as! BlePauseExchangeModel
            delegate?.appListenBleExec(model: o.toOuterModel())
        } else if response is BleRestoreExchangeModel {
            // ble设备发送交换运动数据恢复
            let o = response as! BleRestoreExchangeModel
            delegate?.appListenBleExec(model: o.toOuterModel())
        } else if response is BleOperatePlanExchangeModel {
            // ble设备操作运动计划
            let o = response as! BleOperatePlanExchangeModel
            delegate?.appListenBleExec(model: o.toOuterModel())
        } else if response is AppBlePauseExchangeModel {
            // ble设备发送交换运动数据暂停
            let o = response as! AppBlePauseExchangeModel
            delegate?.appListenBleExec(model: o.toOuterModel())
        } else if response is AppBleRestoreExchangeModel {
            // ble设备发送交换运动数据恢复
            let o = response as! AppBleRestoreExchangeModel
            delegate?.appListenBleExec(model: o.toOuterModel())
        } else if response is AppBleEndExchangeModel {
            // ble设备发送交换运动数据结束
            let o = response as! AppBleEndExchangeModel
            delegate?.appListenBleExec(model: o.toOuterModel())
        }else if response is AppStartReplyExchangeModel {
            // app 开始发起运动 ble回复
            let o = response as! AppStartReplyExchangeModel
            delegate?.appListenAppExec(model: o.toOuterModel())
        } else if response is AppEndReplyExchangeModel {
            // app 发起运动结束 ble回复
            let o = response as! AppEndReplyExchangeModel
            delegate?.appListenAppExec(model: o.toOuterModel())
        } else if response is AppIngReplyExchangeModel {
            // app 交换运动数据 ble回复
            let o = response as! AppIngReplyExchangeModel
            delegate?.appListenAppExec(model: o.toOuterModel())
        } else if response is AppPauseReplyExchangeModel {
            // app 交换运动数据暂停 ble回复
            let o = response as! AppPauseReplyExchangeModel
            delegate?.appListenAppExec(model: o.toOuterModel())
        } else if response is AppRestoreReplyExchangeModel {
            // app 交换运动数据恢复 ble回复
            let o = response as! AppRestoreReplyExchangeModel
            delegate?.appListenAppExec(model: o.toOuterModel())
        } else if response is AppIngV3ReplyExchangeModel {
            // app v3交换运动数据 ble回复
            let o = response as! AppIngV3ReplyExchangeModel
            delegate?.appListenAppExec(model: o.toOuterModel())
        } else if response is AppOperatePlanReplyExchangeModel {
            // app 操作运动计划 ble回复
            let o = response as! AppOperatePlanReplyExchangeModel
            delegate?.appListenAppExec(model: o.toOuterModel())
        }else if response is ApiAppGpsDataExchangeModel {
            /// app 获取GPS数据 ble回复
            let o = response as! ApiAppGpsDataExchangeModel
            delegate?.appListenAppExec(model: o.toOuterModel())
        }else if response is AppActivityDataV3ExchangeModel {
            /// app 获取多运动数据 ble回复
            let o = response as! AppActivityDataV3ExchangeModel
            delegate?.appListenAppExec(model: o.toOuterModel())
        }else if response is ApiAppHrDataExchangeModel {
            /// app 获取心率数据 ble回复
            let o = response as! ApiAppHrDataExchangeModel
            delegate?.appListenAppExec(model: o.toOuterModel())
        }
    }
    
    func exchangeV2Data(model: ApiExchangeV2Model) throws {
        delegate?.exchangeV2Data(model: model.toOuterModel())
    }
    
    func exchangeV3Data(model: ApiExchangeV3Model) throws {
        delegate?.exchangeV3Data(model: model.toOuterModel())
    }
    
}

private extension ApiExchangeBaseModel {
    func toOuterModel() -> IDOExchangeBaseModel {
        return IDOExchangeBaseModel(day: day?.int ?? 0,
                                    hour: hour?.int ?? 0,
                                    minute: minute?.int ?? 0,
                                    second: second?.int ?? 0,
                                    sportType: sportType?.int ?? 0)
    }
}

private extension ApiExchangeV2Model {
    func toOuterModel() -> IDOExchangeV2Model {
        IDOExchangeV2Model(baseModel: baseModel?.toOuterModel(),
                           operate: operate?.int ?? 0,
                           targetValue: targetValue?.int ?? 0,
                           targetType: targetType?.int ?? 0,
                           forceStart: forceStart?.int ?? 0,
                           retCode: retCode?.int ?? 0,
                           calories: calories?.int ?? 0,
                           distance: distance?.int ?? 0,
                           durations: durations?.int ?? 0,
                           step: step?.int ?? 0,
                           avgHr: avgHr?.int ?? 0,
                           maxHr: maxHr?.int ?? 0,
                           curHr: curHr?.int ?? 0,
                           hrSerial: hrSerial?.int ?? 0,
                           burnFatMins: burnFatMins?.int ?? 0,
                           aerobicMins: aerobicMins?.int ?? 0,
                           limitMins: limitMins?.int ?? 0,
                           isSave: isSave ?? false,
                           status: status?.int ?? 0,
                           interval: interval?.int ?? 0,
                           hrValues: hrValues?.map { $0?.int ?? 0 })
    }
}


private extension ApiExchangeV3Model {
    func toOuterModel() -> IDOExchangeV3Model {
        return IDOExchangeV3Model(
            baseModel: baseModel?.toOuterModel(),
            year: year?.int ?? 0,
            month: month?.int ?? 0,
            planType: planType?.int ?? 0,
            actionType: actionType?.int ?? 0,
            version: version?.int ?? 0,
            operate: operate?.int ?? 0,
            targetValue: targetValue?.int ?? 0,
            targetType: targetType?.int ?? 0,
            forceStart: forceStart?.int ?? 0,
            retCode: retCode?.int ?? 0,
            calories: calories?.int ?? 0,
            distance: distance?.int ?? 0,
            durations: durations?.int ?? 0,
            step: step?.int ?? 0,
            swimPosture: swimPosture?.int ?? 0,
            status: status?.int ?? 0,
            signalFlag: signalFlag?.int ?? 0,
            isSave: isSave ?? false,
            realTimeSpeed: realTimeSpeed?.int ?? 0,
            realTimePace: realTimePace?.int ?? 0,
            interval: interval?.int ?? 0,
            hrCount: hrCount?.int ?? 0,
            burnFatMins: burnFatMins?.int ?? 0,
            aerobicMins: aerobicMins?.int ?? 0,
            limitMins: limitMins?.int ?? 0,
            hrValues: hrValues?.map { $0?.int ?? 0 },
            warmUpSecond: warmUpSecond?.int ?? 0,
            anaeroicSecond: anaeroicSecond?.int ?? 0,
            fatBurnSecond: fatBurnSecond?.int ?? 0,
            aerobicSecond: aerobicSecond?.int ?? 0,
            limitSecond: limitSecond?.int ?? 0,
            avgHr: avgHr?.int ?? 0,
            maxHr: maxHr?.int ?? 0,
            curHr: curHr?.int ?? 0,
            warmUpValue: warmUpValue?.int ?? 0,
            fatBurnValue: fatBurnValue?.int ?? 0,
            aerobicValue: aerobicValue?.int ?? 0,
            limitValue: limitValue?.int ?? 0,
            anaerobicValue: anaerobicValue?.int ?? 0,
            avgSpeed: avgSpeed?.int ?? 0,
            maxSpeed: maxSpeed?.int ?? 0,
            avgStepFrequency: avgStepFrequency?.int ?? 0,
            maxStepFrequency: maxStepFrequency?.int ?? 0,
            avgStepStride: avgStepStride?.int ?? 0,
            maxStepStride: maxStepStride?.int ?? 0,
            kmSpeed: kmSpeed?.int ?? 0,
            fastKmSpeed: fastKmSpeed?.int ?? 0,
            kmSpeedCount: kmSpeedCount?.int ?? 0,
            kmSpeeds: kmSpeeds?.map { $0?.int ?? 0 },
            mileCount: mileCount?.int ?? 0,
            mileSpeeds: mileSpeeds?.map { $0?.int ?? 0 },
            stepsFrequencyCount: stepsFrequencyCount?.int ?? 0,
            stepsFrequencys: stepsFrequencys?.map { $0?.int ?? 0 },
            trainingEffect: trainingEffect?.int ?? 0,
            anaerobicTrainingEffect: anaerobicTrainingEffect?.int ?? 0,
            vo2Max: vo2Max?.int ?? 0,
            actionDataCount: actionDataCount?.int ?? 0,
            inClassCalories: inClassCalories?.int ?? 0,
            completionRate: completionRate?.int ?? 0,
            hrCompletionRate: hrCompletionRate?.int ?? 0,
            recoverTime: recoverTime?.int ?? 0,
            avgWeekActivityTime: avgWeekActivityTime?.int ?? 0,
            grade: grade?.int ?? 0,
            actionData: actionData?.compactMap { $0 },
            trainingOffset: trainingOffset?.int ?? 0,
            countHour: countHour?.int ?? 0,
            countMinute: countMinute?.int ?? 0,
            countSecond: countSecond?.int ?? 0,
            time: time?.int ?? 0,
            lowHeart: lowHeart?.int ?? 0,
            heightHeart: heightHeart?.int ?? 0,
            paceSpeedCount: paceSpeedCount?.int ?? 0,
            paceSpeeds: paceSpeeds?.map { $0?.int ?? 0 },
            realSpeedCount: realSpeedCount?.int ?? 0,
            realSpeeds: realSpeeds?.map { $0?.int ?? 0 })
    }
}

private extension AppActivityDataV3ExchangeModel {
    func toOuterModel() -> IDOAppActivityDataV3ExchangeModel {
        return IDOAppActivityDataV3ExchangeModel(
            baseModel: baseModel?.toOuterModel(),
            year: year?.int ?? 0,
            month: month?.int ?? 0,
            version: version?.int ?? 0,
            hrInterval: hrInterval?.int ?? 0,
            step: step?.int ?? 0,
            durations: durations?.int ?? 0,
            calories: calories?.int ?? 0,
            distance: distance?.int ?? 0,
            burnFatMins: burnFatMins?.int ?? 0,
            aerobicMins: aerobicMins?.int ?? 0,
            limitMins: limitMins?.int ?? 0,
            warmUp: warmUp?.int ?? 0,
            fatBurning: fatBurning?.int ?? 0,
            aerobicExercise: aerobicExercise?.int ?? 0,
            anaerobicExercise: anaerobicExercise?.int ?? 0,
            extremeExercise: extremeExercise?.int ?? 0,
            warmUpTime: warmUpTime?.int ?? 0,
            fatBurningTime: fatBurningTime?.int ?? 0,
            aerobicExerciseTime: aerobicExerciseTime?.int ?? 0,
            anaerobicExerciseTime: anaerobicExerciseTime?.int ?? 0,
            extremeExerciseTime: extremeExerciseTime?.int ?? 0,
            avgSpeed: avgSpeed?.int ?? 0,
            maxSpeed: maxSpeed?.int ?? 0,
            avgStepStride: avgStepStride?.int ?? 0,
            maxStepStride: maxStepStride?.int ?? 0,
            kmSpeed: kmSpeed?.int ?? 0,
            fastKmSpeed: fastKmSpeed?.int ?? 0,
            avgStepFrequency: avgStepFrequency?.int ?? 0,
            maxStepFrequency: maxStepFrequency?.int ?? 0,
            avgHrValue: avgHrValue?.int ?? 0,
            maxHrValue: maxHrValue?.int ?? 0,
            recoverTime: recoverTime?.int ?? 0,
            vo2max: vo2max?.int ?? 0,
            trainingEffect: trainingEffect?.int ?? 0,
            grade: grade?.int ?? 0,
            stepsFrequencyCount: stepsFrequencyCount?.int ?? 0,
            miSpeedCount: miSpeedCount?.int ?? 0,
            realSpeedCount: realSpeedCount?.int ?? 0,
            paceSpeedCount: paceSpeedCount?.int ?? 0,
            kmSpeedCount: kmSpeedCount?.int ?? 0,
            actionDataCount: actionDataCount?.int ?? 0,
            inClassCalories: inClassCalories?.int ?? 0,
            completionRate: completionRate?.int ?? 0,
            hrCompletionRate: hrCompletionRate?.int ?? 0,
            kmSpeeds: kmSpeeds?.map { $0?.int ?? 0 },
            stepsFrequency: stepsFrequency?.map { $0?.int ?? 0 },
            itemsMiSpeed: itemsMiSpeed?.map { $0?.int ?? 0 },
            itemRealSpeed: itemRealSpeed?.map { $0?.int ?? 0 },
            paceSpeedItems: paceSpeedItems?.map { $0?.int ?? 0 },
            actionData: actionData?.compactMap { $0 })
    }
}

private extension ApiAppHrDataExchangeModel {
    func toOuterModel() -> IDOAppHrDataExchangeModel {
        return IDOAppHrDataExchangeModel(
            baseModel: baseModel?.toOuterModel(),
            version: version?.int ?? 0,
            heartRateHistoryLen: heartRateHistoryLen?.int ?? 0,
            interval: interval?.int ?? 0,
            heartRates: heartRates?.map { $0?.int ?? 0 })
    }
}

private extension ApiAppGpsDataExchangeModel {
    func toOuterModel() -> IDOAppGpsDataExchangeModel {
        return IDOAppGpsDataExchangeModel(
            baseModel: baseModel?.toOuterModel(),
            version: version?.int ?? 0,
            intervalSecond: intervalSecond?.int ?? 0,
            gpsCount: gpsCount?.int ?? 0,
            gpsData: gpsData?.compactMap { $0 }
        )
    }
}

private extension BleStartExchangeModel {
    func toOuterModel() -> IDOBleStartExchangeModel {
        return IDOBleStartExchangeModel(baseModel: baseModel?.toOuterModel(), operate: operate?.int ?? 0)
    }
}

private extension BleIngExchangeModel {
    func toOuterModel() -> IDOBleIngExchangeModel {
        return IDOBleIngExchangeModel(baseModel: baseModel?.toOuterModel(), distance: distance?.int ?? 0)
    }
}

private extension BleEndExchangeModel {
    func toOuterModel() -> IDOBleEndExchangeModel {
        return IDOBleEndExchangeModel(baseModel: baseModel?.toOuterModel())
    }
}

private extension BlePauseExchangeModel {
    func toOuterModel() -> IDOBlePauseExchangeModel {
        return IDOBlePauseExchangeModel(baseModel: baseModel?.toOuterModel())
    }
}

private extension BleRestoreExchangeModel {
    func toOuterModel() -> IDOBleRestoreExchangeModel {
        return IDOBleRestoreExchangeModel(baseModel: baseModel?.toOuterModel())
    }
}

private extension BleOperatePlanExchangeModel {
    func toOuterModel() -> IDOBleOperatePlanExchangeModel {
        return IDOBleOperatePlanExchangeModel(
            baseModel: baseModel?.toOuterModel(),
            operate: operate?.int ?? 0,
            planType: planType?.int ?? 0,
            actionType: actionType?.int ?? 0,
            errorCode: errorCode?.int ?? 0,
            trainingYear: trainingYear?.int ?? 0,
            trainingMonth: trainingMonth?.int ?? 0,
            trainingDay: trainingDay?.int ?? 0,
            time: time?.int ?? 0,
            lowHeart: lowHeart?.int ?? 0,
            heightHeart: heightHeart?.int ?? 0)
    }
}

private extension AppBlePauseExchangeModel {
    func toOuterModel() -> IDOBlePauseExchangeModel {
        return IDOBlePauseExchangeModel(baseModel: baseModel?.toOuterModel())
    }
}

private extension AppBleRestoreExchangeModel {
    func toOuterModel() -> IDOAppBleRestoreExchangeModel {
        return IDOAppBleRestoreExchangeModel(baseModel: baseModel?.toOuterModel())
    }
}

private extension AppBleEndExchangeModel {
    func toOuterModel() -> IDOAppBleEndExchangeModel {
        return IDOAppBleEndExchangeModel(
            duration: duration?.int ?? 0,
            calories: calories?.int ?? 0,
            distance: distance?.int ?? 0,
            avgHr: avgHr?.int ?? 0,
            maxHr: maxHr?.int ?? 0,
            burnFatMins: burnFatMins?.int ?? 0,
            aerobicMins: aerobicMins?.int ?? 0,
            limitMins: limitMins?.int ?? 0,
            isSave: isSave?.int ?? 0)
    }
}

private extension AppStartReplyExchangeModel {
    func toOuterModel() -> IDOAppStartReplyExchangeModel {
        return IDOAppStartReplyExchangeModel(baseModel: baseModel?.toOuterModel(), retCode: retCode?.int ?? 0)
    }
}

private extension AppEndReplyExchangeModel {
    func toOuterModel() -> IDOAppEndReplyExchangeModel {
        return IDOAppEndReplyExchangeModel(
            baseModel: baseModel?.toOuterModel(),
            errorCode: errorCode?.int ?? 0,
            calories: calories?.int ?? 0,
            distance: distance?.int ?? 0,
            step: step?.int ?? 0,
            avgHr: avgHr?.int ?? 0,
            maxHr: maxHr?.int ?? 0,
            burnFatMins: burnFatMins?.int ?? 0,
            aerobicMins: aerobicMins?.int ?? 0,
            limitMins: limitMins?.int ?? 0)
    }
}

private extension AppIngReplyExchangeModel {
    func toOuterModel() -> IDOAppIngReplyExchangeModel {
        return IDOAppIngReplyExchangeModel(
            baseModel: baseModel?.toOuterModel(),
            calories: calories?.int ?? 0,
            distance: distance?.int ?? 0,
            status: status?.int ?? 0,
            step: step?.int ?? 0,
            currentHr: currentHr?.int ?? 0,
            interval: interval?.int ?? 0,
            hrSerial: hrSerial?.int ?? 0,
            hrJson: hrJson?.map { $0?.int ?? 0 })
    }
}

private extension AppPauseReplyExchangeModel {
    func toOuterModel() -> IDOAppPauseReplyExchangeModel {
        return IDOAppPauseReplyExchangeModel(
            baseModel: baseModel?.toOuterModel(),
            errCode: errCode?.int ?? 0)
    }
}

private extension AppRestoreReplyExchangeModel {
    func toOuterModel() -> IDOAppRestoreReplyExchangeModel {
        return IDOAppRestoreReplyExchangeModel(
            baseModel: baseModel?.toOuterModel(),
            errCode: errCode?.int ?? 0)
    }
}

private extension AppIngV3ReplyExchangeModel {
    func toOuterModel() -> IDOAppIngV3ReplyExchangeModel {
        return IDOAppIngV3ReplyExchangeModel(
            baseModel: baseModel?.toOuterModel(),
            version: version?.int ?? 0,
            heartRate: heartRate?.int ?? 0,
            distance: distance?.int ?? 0,
            duration: duration?.int ?? 0,
            realTimeCalories: realTimeCalories?.int ?? 0,
            realTimeSpeed: realTimeSpeed?.int ?? 0,
            kmSpeed: kmSpeed?.int ?? 0,
            steps: steps?.int ?? 0,
            swimPosture: swimPosture?.int ?? 0,
            status: status?.int ?? 0,
            realTimeSpeedPace: realTimeSpeedPace?.int ?? 0,
            trainingEffect: trainingEffect?.int ?? 0,
            anaerobicTrainingEffect: anaerobicTrainingEffect?.int ?? 0,
            actionType: actionType?.int ?? 0,
            countHour: countHour?.int ?? 0,
            countMinute: countMinute?.int ?? 0,
            countSecond: countSecond?.int ?? 0)
    }
}

private extension AppOperatePlanReplyExchangeModel {
    func toOuterModel() -> IDOAppOperatePlanReplyExchangeModel {
        return IDOAppOperatePlanReplyExchangeModel(
            baseModel: baseModel?.toOuterModel(),
            planType: planType?.int ?? 0,
            operate: operate?.int ?? 0,
            actionType: actionType?.int ?? 0,
            errorCode: errorCode?.int ?? 0)
    }
}

// MARK: - 由于需要适配oc，以下swift无法直接适配，暂时屏蔽
// 由于需要适配oc，以下swift无法直接适配，暂时屏蔽
//public protocol IDOExchangeDataDelegate: NSObjectProtocol {
//    /**
//     * ble发起运动 app监听ble
//     * @param type 监听ble执行数据实体
//     */
//    func appListenBleExec(type: IDOBleExecType)
//
//    /**
//     * app执行响应
//     * @param type 监听app执行Ble响应实体
//     */
//    func appListenAppExec(type: IDOBleReplyType)
//
//    /**
//     * 交换v2数据
//     * @param model 监听v2数据交换实体
//     */
//    func exchangeV2Data(model: IDOExchangeV2Model)
//
//    /**
//     * 交换v3数据
//     * @param model 监听v3数据交换实体
//     */
//    func exchangeV3Data(model: IDOExchangeV3Model)
//}
//
//class ExchangeDataDelegateImpl: ApiExchangeDataDelegate {
//
//    static let shared = ExchangeDataDelegateImpl()
//    private init() {}
//
//    var exchangeStatus: IDOExchangeStatus = IDOExchangeStatus.initial
//
//    private var delegate: IDOExchangeDataDelegate?
//    private var delegateOC: IDOExchangeDataOCDelegate?
//
//    func addDelegate(api: IDOExchangeDataDelegate?) {
//       delegate = api
//    }
//
//    func addDelegateOC(api: IDOExchangeDataOCDelegate?) {
//       delegateOC = api
//    }
//
//    func listenExchangeState(status: ApiExchangeStatus) throws {
//        exchangeStatus = IDOExchangeStatus(rawValue: status.rawValue) ?? .initial
//    }
//
//    func listenBleResponse(response: Any) throws {
//        if response is BleStartExchangeModel {
//            // ble设备发送交换运动数据开始
//            let o = response as! BleStartExchangeModel
//            delegate?.appListenBleExec(type:.bleStart(o.toOuterModel()))
//        } else if response is BleIngExchangeModel {
//            // ble设备交换运动数据过程中
//            let o = response as! BleIngExchangeModel
//            delegate?.appListenBleExec(type:.bleIng(o.toOuterModel()))
//        } else if response is BleEndExchangeModel {
//            // ble设备发送交换运动数据结束
//            let o = response as! BleEndExchangeModel
//            delegate?.appListenBleExec(type:.bleEnd(o.toOuterModel()))
//        } else if response is BlePauseExchangeModel {
//            // ble设备发送交换运动数据暂停
//            let o = response as! BlePauseExchangeModel
//            delegate?.appListenBleExec(type:.blePause(o.toOuterModel()))
//        } else if response is BleRestoreExchangeModel {
//            // ble设备发送交换运动数据恢复
//            let o = response as! BleRestoreExchangeModel
//            delegate?.appListenBleExec(type:.bleRestore(o.toOuterModel()))
//        } else if response is BleOperatePlanExchangeModel {
//            // ble设备操作运动计划
//            let o = response as! BleOperatePlanExchangeModel
//            delegate?.appListenBleExec(type:.bleOperatePlan(o.toOuterModel()))
//        } else if response is AppBlePauseExchangeModel {
//            // ble设备发送交换运动数据暂停
//            let o = response as! AppBlePauseExchangeModel
//            delegate?.appListenBleExec(type:.blePause(o.toOuterModel()))
//        } else if response is AppBleRestoreExchangeModel {
//            // ble设备发送交换运动数据恢复
//            let o = response as! AppBleRestoreExchangeModel
//            delegate?.appListenBleExec(type:.appBleRestore(o.toOuterModel()))
//        } else if response is AppBleEndExchangeModel {
//            // ble设备发送交换运动数据结束
//            let o = response as! AppBleEndExchangeModel
//            delegate?.appListenBleExec(type:.appBleEnd(o.toOuterModel()))
//        }else if response is AppStartReplyExchangeModel {
//            // app 开始发起运动 ble回复
//            let o = response as! AppStartReplyExchangeModel
//            delegate?.appListenAppExec(type:.appStartReply(o.toOuterModel()))
//        } else if response is AppEndReplyExchangeModel {
//            // app 发起运动结束 ble回复
//            let o = response as! AppEndReplyExchangeModel
//            delegate?.appListenAppExec(type:.appEndReply(o.toOuterModel()))
//        } else if response is AppIngReplyExchangeModel {
//            // app 交换运动数据 ble回复
//            let o = response as! AppIngReplyExchangeModel
//            delegate?.appListenAppExec(type:.appIngReply(o.toOuterModel()))
//        } else if response is AppPauseReplyExchangeModel {
//            // app 交换运动数据暂停 ble回复
//            let o = response as! AppPauseReplyExchangeModel
//            delegate?.appListenAppExec(type:.appPauseReply(o.toOuterModel()))
//        } else if response is AppRestoreReplyExchangeModel {
//            // app 交换运动数据恢复 ble回复
//            let o = response as! AppRestoreReplyExchangeModel
//            delegate?.appListenAppExec(type:.appRestoreReply(o.toOuterModel()))
//        } else if response is AppIngV3ReplyExchangeModel {
//            // app v3交换运动数据 ble回复
//            let o = response as! AppIngV3ReplyExchangeModel
//            delegate?.appListenAppExec(type:.appIngV3Reply(o.toOuterModel()))
//        } else if response is AppOperatePlanReplyExchangeModel {
//            // app 操作运动计划 ble回复
//            let o = response as! AppOperatePlanReplyExchangeModel
//            delegate?.appListenAppExec(type:.appOperatePlanReply(o.toOuterModel()))
//        }else if response is ApiAppGpsDataExchangeModel {
//            /// app 获取GPS数据 ble回复
//            let o = response as! ApiAppGpsDataExchangeModel
//            delegate?.appListenAppExec(type:.appActivityGpsReply(o.toOuterModel()))
//        }else if response is AppActivityDataV3ExchangeModel {
//            /// app 获取多运动数据 ble回复
//            let o = response as! AppActivityDataV3ExchangeModel
//            delegate?.appListenAppExec(type:.appActivityDataReply(o.toOuterModel()))
//        }else if response is ApiAppHrDataExchangeModel {
//            /// app 获取心率数据 ble回复
//            let o = response as! ApiAppHrDataExchangeModel
//            delegate?.appListenAppExec(type:.appActivityHrReply(o.toOuterModel()))
//        }
//    }
//
//    func exchangeV2Data(model: ApiExchangeV2Model) throws {
//        delegate?.exchangeV2Data(model: model.toOuterModel())
//    }
//
//    func exchangeV3Data(model: ApiExchangeV3Model) throws {
//        delegate?.exchangeV3Data(model: model.toOuterModel())
//    }
//
//}
