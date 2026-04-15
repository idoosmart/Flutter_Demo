package com.idosmart.model

import com.google.gson.Gson
import com.idosmart.pigeongen.api_data_exchange.*

/// app执行数据交换
sealed class IDOAppExecType {
    // app 开始发起运动
    data class appStart(val model: IDOAppStartExchangeModel) : IDOAppExecType()

    // app 发起运动结束
    data class appEnd(val model: IDOAppEndExchangeModel) : IDOAppExecType()

    // app 交换运动数据
    data class appIng(val model: IDOAppIngExchangeModel) : IDOAppExecType()

    // app 交换运动数据暂停
    data class appPause(val model: IDOAppPauseExchangeModel) : IDOAppExecType()

    // app 交换运动数据恢复
    data class appRestore(val model: IDOAppRestoreExchangeModel) : IDOAppExecType()

    // app v3交换运动数据
    data class appIngV3(val model: IDOAppIngV3ExchangeModel) : IDOAppExecType()

    // app 操作计划运动
    data class appOperatePlan(val model: IDOAppOperatePlanExchangeModel) : IDOAppExecType()
}

/// ble执行数据交换
sealed class IDOAppReplyType {
    // ble发起运动 ble执行数据交换 app回复

    /// ble设备发送交换运动数据开始 app回复
    data class bleStartReply(val model: IDOBleStartReplyExchangeModel) : IDOAppReplyType()

    /// ble设备交换运动数据过程中 app回复
    data class bleIngReply(val model: IDOBleIngReplyExchangeModel) : IDOAppReplyType()

    /// ble设备发送交换运动数据结束 app回复
    data class bleEndReply(val model: IDOBleEndReplyExchangeModel) : IDOAppReplyType()

    /// ble设备发送交换运动数据暂停 app回复
    data class blePauseReply(val model: IDOBlePauseReplyExchangeModel) : IDOAppReplyType()

    /// ble设备发送交换运动数据恢复 app回复
    data class bleRestoreReply(val model: IDOBleRestoreReplyExchangeModel) : IDOAppReplyType()

    /// ble设备操作运动计划 app回复
    data class bleOperatePlanReply(val model: IDOBleOperatePlanReplyExchangeModel) :
        IDOAppReplyType()

    // app发起运动 ble执行数据交换 app回复

    /// ble设备发送交换运动数据暂停 app回复
    data class appBlePauseReply(val model: IDOAppBlePauseReplyExchangeModel) : IDOAppReplyType()

    /// ble设备发送交换运动数据恢复 app回复
    data class appBleRestoreReply(val model: IDOAppBleRestoreReplyExchangeModel) : IDOAppReplyType()

    /// ble设备发送交换运动数据结束 app回复
    data class appBleEndReply(val model: IDOAppBleEndReplyExchangeModel) : IDOAppReplyType()
}

/// app监听ble
sealed class IDOBleExecType {

    /// ble发起运动 app监听ble

    /// ble设备发送交换运动数据开始
    data class bleStart(val model: IDOBleStartExchangeModel) : IDOBleExecType()

    /// ble设备交换运动数据过程中
    data class bleIng(val model: IDOBleIngExchangeModel) : IDOBleExecType()

    /// ble设备发送交换运动数据结束
    data class bleEnd(val model: IDOBleEndExchangeModel) : IDOBleExecType()

    /// ble设备发送交换运动数据暂停
    data class blePause(val model: IDOBlePauseExchangeModel) : IDOBleExecType()

    /// ble设备发送交换运动数据恢复
    data class bleRestore(val model: IDOBleRestoreExchangeModel) : IDOBleExecType()

    /// ble设备操作运动计划
    data class bleOperatePlan(val model: IDOBleOperatePlanExchangeModel) : IDOBleExecType()

    // app发起运动 ble操作响应

    /// ble设备发送交换运动数据暂停
    data class appBlePause(val model: IDOAppBlePauseExchangeModel) : IDOBleExecType()

    ///  ble设备发送交换运动数据恢复
    data class appBleRestore(val model: IDOAppBleRestoreExchangeModel) : IDOBleExecType()

    /// ble设备发送交换运动数据结束
    data class appBleEnd(val model: IDOAppBleEndExchangeModel) : IDOBleExecType()
}

/// app发起运动 ble响应回复
sealed class IDOBleReplyType {
    /// app 开始发起运动 ble回复
    data class appStartReply(val model: IDOAppStartReplyExchangeModel?) :
        IDOBleReplyType()

    /// app 发起运动结束 ble回复
    data class appEndReply(val model: IDOAppEndReplyExchangeModel?) :
        IDOBleReplyType()

    ///  app 交换运动数据 ble回复
    data class appIngReply(val model: IDOAppIngReplyExchangeModel?) :
        IDOBleReplyType()

    /// app 交换运动数据暂停 ble回复
    data class appPauseReply(val model: IDOAppPauseReplyExchangeModel?) :
        IDOBleReplyType()

    /// app 交换运动数据恢复 ble回复
    data class appRestoreReply(val model: IDOAppRestoreReplyExchangeModel?) :
        IDOBleReplyType()

    /// app v3交换运动数据 ble回复
    data class appIngV3Reply(val model: IDOAppIngV3ReplyExchangeModel?) :
        IDOBleReplyType()

    /// app 操作运动计划 ble回复
    data class appOperatePlanReply(val model: IDOAppOperatePlanReplyExchangeModel?) :
        IDOBleReplyType()

    /// app 获取v3多运动一次活动数据 ble回复
    data class appActivityDataReply(val model: IDOAppActivityDataV3ExchangeModel?) :
        IDOBleReplyType()

    /// app 获取v3多运动一次心率数据 ble回复
    data class appActivityHrReply(val model: IDOAppHrDataExchangeModel?) :
        IDOBleReplyType()

    /// app 获取v3多运动一次GPS数据 ble回复
    data class appActivityGpsReply(val model: IDOAppGpsDataExchangeModel?) :
        IDOBleReplyType()
}

/**
 * app 获取v3多运动数据
 * @param year: 年份
 * @param month: 月份
 * @param version: 协议版本号
 * @param hrInterval: 心率间隔 单位分钟
 * @param step: 步数
 * @param durations: 持续时间
 * @param calories: 卡路里
 * @param distance: 距离
 * @param burnFatMins: 脂肪燃烧的心率持续时间 单位分钟
 * @param aerobicMins: 有氧运动的持续时间 单位分钟
 * @param limitMins: 极限锻炼的持续时间 单位分钟
 * @param warmUp: 热身运动
 * @param fatBurning: 脂肪燃烧
 * @param aerobicExercise: 有氧训练
 * @param anaerobicExercise: 无氧训练
 * @param extremeExercise: 极限训练
 * @param warmUpTime: 热身运动的累计时长 单位秒
 * @param fatBurningTime: 脂肪燃烧的累计时长 单位秒
 * @param aerobicExerciseTime: 有氧运动的累计时长 单位秒
 * @param anaerobicExerciseTime: 无氧运动的累计时长 单位秒
 * @param extremeExerciseTime: 极限锻炼的累计时长 单位秒
 * @param avgSpeed: 平均速度 单位km/h
 * @param maxSpeed: 最快速度 单位km/h
 * @param avgStepStride: 平均步幅
 * @param maxStepStride: 最大步幅
 * @param kmSpeed: 平均公里配速
 * @param fastKmSpeed: 最快公里配速
 * @param avgStepFrequency: 平均步频
 * @param maxStepFrequency: 最大步频
 * @param avgHrValue: 平均心率
 * @param maxHrValue: 最大心率
 * @param recoverTime: 恢复时长 单位小时 app收到该数据之后，每过1小时需要自减1
 * @param vo2max: 最大摄氧量 单位 ml/kg/min
 * @param trainingEffect:  训练效果 范围： 1.0 - 5.0 （扩大10倍传输）
 * @param grade: 摄氧量等级 1：低等 2：业余 3：一般 4：平均 5：良好 6：优秀 7：专业
 * @param stepsFrequencyCount: 步频详情个数
 * @param miSpeedCount:  英里配速个数 最大100
 * @param realSpeedCount: 实时速度个数
 * @param paceSpeedCount: 实时配速个数
 * @param kmSpeedCount: 公里配速详情个数 最大100
 * @param actionDataCount: 本次动作训练个数
 * @param kmSpeeds: 每公里耗时秒数 配速集合
 * @param stepsFrequency: 步频集合 单位步/分钟
 * @param itemsMiSpeed: 英里配速数组
 * @param itemRealSpeed: 实时速度数组 单位km/h
 * @param paceSpeedItems: 实时配速数组
 * @param actionData: 动作完成内容
 *  - type : 动作类型  1快走；2慢跑; 3中速跑；4快跑
 *  - heart_con_value : 每个动作心率控制
 *  - time : 动作完成时间 单位秒
 *  - goal_time ：动作目标时间
 * @param baseModel: 基础数据 日期、时间、运动类型
 */
class IDOAppActivityDataV3ExchangeModel(
    year: Int?,
    month: Int?,
    hrInterval: Int?,
    step: Int?,
    durations: Int?,
    calories: Int?,
    distance: Int?,
    burnFatMins: Int?,
    aerobicMins: Int?,
    limitMins: Int?,
    warmUp: Int?,
    fatBurning: Int?,
    aerobicExercise: Int?,
    anaerobicExercise: Int?,
    extremeExercise: Int?,
    warmUpTime: Int?,
    fatBurningTime: Int?,
    aerobicExerciseTime: Int?,
    anaerobicExerciseTime: Int?,
    extremeExerciseTime: Int?,
    avgSpeed: Int?,
    maxSpeed: Int?,
    avgStepStride: Int?,
    maxStepStride: Int?,
    kmSpeed: Int?,
    fastKmSpeed: Int?,
    avgStepFrequency: Int?,
    maxStepFrequency: Int?,
    avgHrValue: Int?,
    axHrValue: Int?,
    recoverTime: Int?,
    vo2max: Int?,
    trainingEffect: Int?,
    grade: Int?,
    stepsFrequencyCount: Int?,
    miSpeedCount: Int?,
    realSpeedCount: Int?,
    paceSpeedCount: Int?,
    kmSpeedCount: Int?,
    actionDataCount: Int?,
    inClassCalories: Int?,
    completionRate: Int?,
    hrCompletionRate: Int?,
    kmSpeeds: List<Int?>?,
    stepsFrequency: List<Int?>?,
    itemsMiSpeed: List<Int?>?,
    paceSpeedItems: List<Int?>?,
    actionData: List<Map<String, Any>?>?,
    baseModel: IDOExchangeBaseModel?
) {
    
    var year: Int? = year

    
    var month: Int? = month

    
    private var version: Int? = 0

    
    var hrInterval: Int? = hrInterval

    
    var step: Int? = step

    
    var durations: Int? = durations

    
    var calories: Int? = calories

    
    var distance: Int? = distance

    
    var burnFatMins: Int? = burnFatMins

    
    var aerobicMins: Int? = aerobicMins

    
    var limitMins: Int? = limitMins

    
    var warmUp: Int? = warmUp

    
    var fatBurning: Int? = fatBurning

    
    var aerobicExercise: Int? = aerobicExercise

    
    var anaerobicExercise: Int? = anaerobicExercise

    
    var extremeExercise: Int? = extremeExercise

    
    var warmUpTime: Int? = warmUpTime

    
    var fatBurningTime: Int? = fatBurningTime

    
    var aerobicExerciseTime: Int? = aerobicExerciseTime

    
    var anaerobicExerciseTime: Int? = anaerobicExerciseTime

    
    var extremeExerciseTime: Int? = extremeExerciseTime

    
    var avgSpeed: Int? = avgSpeed

    
    var maxSpeed: Int? = maxSpeed

    
    var avgStepStride: Int? = avgStepStride

    
    var maxStepStride: Int? = maxStepStride

    
    var kmSpeed: Int? = kmSpeed

    
    var fastKmSpeed: Int? = fastKmSpeed

    
    var avgStepFrequency: Int? = avgStepFrequency

    
    var maxStepFrequency: Int? = maxStepFrequency

    
    var avgHrValue: Int? = avgHrValue

    
    var axHrValue: Int? = axHrValue

    
    var recoverTime: Int? = recoverTime

    
    var vo2max: Int? = vo2max

    
    var trainingEffect: Int? = trainingEffect

    
    var grade: Int? = grade

    
    var stepsFrequencyCount: Int? = stepsFrequencyCount

    
    var miSpeedCount: Int? = miSpeedCount

    
    var realSpeedCount: Int? = realSpeedCount

    
    var paceSpeedCount: Int? = paceSpeedCount

    
    var kmSpeedCount: Int? = kmSpeedCount

    
    var actionDataCount: Int? = actionDataCount

    
    var inClassCalories: Int? = inClassCalories

    
    var completionRate: Int? = completionRate

    
    var hrCompletionRate: Int? = hrCompletionRate

    
    var kmSpeeds: List<Int?>? = kmSpeeds

    
    var stepsFrequency: List<Int?>? = stepsFrequency

    
    var itemsMiSpeed: List<Int?>? = itemsMiSpeed

    
    var paceSpeedItems: List<Int?>? = paceSpeedItems

    
    var actionData: List<Map<String, Any>?>? = actionData

    
    var baseModel: IDOExchangeBaseModel? = baseModel
}

/**
 * app v3 多运动数交换中获取1分钟心率数据
 * @param version: 协议版本号
 * @param heartRateHistoryLen: 心率数据数组长度 最大60
 * @param interval: 心率间隔 单位秒
 * @param heartRates: 心率数据数组 存一分钟的心率数据, 1s存一个
 * @param baseModel: 基础数据 日期、时间、运动类型
 */
class IDOAppHrDataExchangeModel(
    heartRateHistoryLen: Int?,
    interval: Int?,
    heartRates: List<Int?>?,
    baseModel: IDOExchangeBaseModel?
) {
    
    private var version: Int? = 0

    
    var heartRateHistoryLen: Int? = heartRateHistoryLen

    
    var interval: Int? = interval

    
    var heartRates: List<Int?>? = heartRates

    
    var baseModel: IDOExchangeBaseModel? = baseModel
}

/**
 * app v3 多运动数交换中获取gps数据
 * @param version: 协议版本号
 * @param intervalSecond: 坐标点时间间隔 单位秒
 * @param gpsCount: 坐标点个数
 * @param gpsData: gps数据详情集合 [{'latitude':0,'longitude':0}]
 * @param baseModel: 基础数据 日期、时间、运动类型
 */
class IDOAppGpsDataExchangeModel(
    intervalSecond: Int?,
    gpsCount: Int?,
    gpsData: List<Map<Any, Any>?>?,
    baseModel: IDOExchangeBaseModel?
) {
    
    private var version: Int? = 0

    
    var intervalSecond: Int? = intervalSecond

    
    var gpsCount: Int? = gpsCount

    
    var gpsData: List<Map<Any, Any>?>? = gpsData

    
    var baseModel: IDOExchangeBaseModel? = baseModel
}

/**
 * V2数据交换模型
 * @param operate: 1:请求app打开gps  2：发起运动请求
 * @param targetValue: 目标数值
 * @param targetType: 运动目标类型
 *   - 0: 无目标， 1: 重复次数，单位：次，
 *   - 2: 距离,单位：米,  3: 卡路里, 单位：大卡,
 *   - 4: 时长,单位：分钟, 5:  步数, 单位：步
 * @param forceStart: 是否强制开始 0:不强制,1:强制
 * @param retCode: 错误码
 *   - 0:成功; 1:设备已经进入运动模式失败;
 *   - 2: 设备电量低失败; 3:手环正在充电 4:正在使用Alexa 5:通话中
 * @param calories: 卡路里 (单位:J)
 * @param distance:  距离 (单位:米)
 * @param durations: 持续时间 (单位:秒钟)
 * @param step: 步数 (单位:步)
 * @param avgHr: 平均心率
 * @param maxHr: 最大心率
 * @param curHr: 当前心率
 * @param hrSerial: 序列号
 * @param burnFatMins: 燃烧脂肪时长 (单位：分钟)
 * @param aerobicMins: 有氧时长 (单位：分钟)
 * @param limitMins: 极限时长 (单位：分钟)
 * @param isSave: 是否存储数据
 * @param status: 0:全部有效, 1:距离无效， 2: gps 信号弱
 * @param interval: 心率间隔
 * @param hrValues:  心率数据集合
 * @param baseModel: 基础数据 日期、时间、运动类型
 **/
class IDOExchangeV2Model(
    operate: Int?,
    targetValue: Int?,
    targetType: Int?,
    forceStart: Int?,
    retCode: Int?,
    calories: Int?,
    distance: Int?,
    durations: Int?,
    step: Int?,
    avgHr: Int?,
    maxHr: Int?,
    curHr: Int?,
    hrSerial: Int?,
    burnFatMins: Int?,
    aerobicMins: Int?,
    limitMins: Int?,
    isSave: Boolean?,
    status: Int?,
    interval: Int?,
    hrValues: List<Int?>?,
    baseModel: IDOExchangeBaseModel?
) {
    
    var operate: Int? = operate

    
    var targetValue: Int? = targetValue

    
    var targetType: Int? = targetType

    
    var forceStart: Int? = forceStart

    
    var retCode: Int? = retCode

    
    var calories: Int? = calories

    
    var distance: Int? = distance

    
    var durations: Int? = durations

    
    var step: Int? = step

    
    var avgHr: Int? = avgHr

    
    var maxHr: Int? = maxHr

    
    var curHr: Int? = curHr

    
    var hrSerial: Int? = hrSerial

    
    var burnFatMins: Int? = burnFatMins

    
    var aerobicMins: Int? = aerobicMins

    
    var limitMins: Int? = limitMins

    
    var isSave: Boolean? = isSave

    
    var status: Int? = status

    
    var interval: Int? = interval

    
    var hrValues: List<Int?>? = hrValues

    
    var baseModel: IDOExchangeBaseModel? = baseModel
}

/**
 * * V3数据交换模型
 *
 * @param year: 训练课程年份
 * @param month: 训练课程月份
 * @param planType: 计划类型
 *   - 1：跑步计划3km , 2：跑步计划5km ,
 *   - 3：跑步计划10km , 4：半程马拉松训练（二期）, 5：马拉松训练（二期）
 * @param actionType: 动作类型
 *   - 1:快走；2:慢跑；3:中速跑；4快跑；
 *   - 5:结束课程运动 （还要等待用户是否有自由运动）;
 *   - 6:课程结束后自由运动 （此字段当operate为5起作用）
 * @param version: 数据版本
 * @param operate: 1:请求app打开gps  2：发起运动请求
 * @param targetValue: 目标数值
 * @param targetType: 目标类型
 *   - 0: 无目标， 1: 重复次数，单位：次，
 *   - 2: 距离,单位：米,  3: 卡路里, 单位：大卡,
 *   - 4: 时长,单位：分钟, 5:  步数, 单位：步
 * @param forceStart: 是否强制开始 0:不强制,1:强制
 * @param retCode: 错误码
 *  - 0:成功; 1:设备已经进入运动模式失败;
 *  - 2: 设备电量低失败; 3:手环正在充电 4:正在使用Alexa 5:通话中
 * @param calories: 卡路里 (单位:J)
 * @param distance: 距离 (单位:米)
 * @param durations: 持续时间 (单位:秒钟)
 * @param step: I步数 (单位:步)
 * @param swimPosture: 0: 混合泳; 1: 自由泳; 2: 蛙泳; 3: 仰泳; 4: 蝶泳;
 * @param status: 手环返回的状态 开始:1,暂停:2, 结束:3,0:无效状态
 * @param signalFlag: 信号强弱  0: 表示信号弱， 1: 表示信号强
 * @param isSave: 是否存储数据
 * @param realTimeSpeed: app计算显示实时速度 单位km/h 100倍 15秒一个记录
 * @param realTimePace: app计算显示实时配速 单位 s
 * @param interval: 心率间隔
 * @param hrCount: 心率个数
 * @param burnFatMins: 燃烧脂肪时长 (单位：分钟)
 * @param aerobicMins: 有氧时长 (单位：分钟)
 * @param limitMins: 极限时长 (单位：分钟)
 * @param hrValues: 心率数据集合
 * @param warmUpSecond: 热身锻炼时长(秒钟)
 * @param anaeroicSecond: 无氧锻炼时长(秒钟)
 * @param fatBurnSecond: 燃脂锻炼时长(秒钟)
 * @param aerobicSecond: 有氧锻炼时长(秒钟)
 * @param limitSecond: 极限锻炼时长(秒钟)
 * @param avgHr: 平均心率
 * @param maxHr: 最大心率
 * @param curHr: 当前心率
 * @param warmUpValue: 热身运动值
 * @param fatBurnValue: 脂肪燃烧运动值
 * @param aerobicValue: 有氧运动值
 * @param limitValue: 极限运动值
 * @param anaerobicValue: 无氧运动值
 * @param avgSpeed: 平均速度 km/h
 * @param maxSpeed: 最大速度 km/h
 * @param avgStepFrequency: 平均步频
 * @param maxStepFrequency: 最大步频
 * @param avgStepStride: 平均步幅
 * @param maxStepStride: 最大步幅
 * @param kmSpeed: 平均公里配速
 * @param fastKmSpeed: 最快公里配速
 * @param kmSpeedCount: 公里配速个数
 * @param kmSpeeds: 公里配速集合
 * @param mileCount: 英里配速个数
 * @param mileSpeeds: 英里配速集合
 * @param stepsFrequencyCount: 步频个数
 * @param stepsFrequencys: 步频集合
 * @param trainingEffect: 训练效果；  单位：无   范围 1.0 ~ 5.0 （*10倍）
 * @param anaerobicTrainingEffect: 无氧训练效果；  单位：无   范围 1.0 ~ 5.0 （*10倍）
 * @param vo2Max: 最大摄氧量；  单位：毫升/公斤/分钟； 范围  0-80
 * @param actionDataCount: 本次动作训练个数
 * @param inClassCalories: 课程内运动热量  单位千卡
 * @param completionRate: 动作完成率 0—100
 * @param hrCompletionRate: 心率控制率 0—100
 * @param recoverTime: 恢复时长：单位小时(app收到该数据之后，每过一小时需要自减一)
 * @param avgWeekActivityTime: 上个月平均每周的运动时间 单位分钟
 * @param grade: 摄氧量等级  1:低等 2:业余 3:一般 4：平均 5：良好 6：优秀 7：专业
 * @param actionData: 动作完成内容
 *    - type : 动作类型  1快走；2慢跑; 3中速跑；4快跑
 *    - heart_con_value : 每个动作心率控制
 *    - time : 动作完成时间 单位秒
 *    - goal_time ：动作目标时间
 * @param trainingOffset: 训练的课程日期偏移 从0开始
 * @param countHour: 运动倒计时
 * @param countMinute: 运动倒计时分
 * @param countSecond: 运动倒计时秒
 * @param time: 动作目标时间  单位秒
 * @param lowHeart: 心率范围低值
 * @param heightHeart: 心率范围高值
 * @param paceSpeedCount: 实时配速个数
 * @param paceSpeeds: 实时配速数组  传过来的是s 每5s算一次
 * @param realSpeedCount: 实时速度个数
 * @param realSpeeds: 实时速度数组 传过来的是s 每5s算一次
 * @param baseModel: 基础数据 日期、时间、运动类型
 */
open class IDOExchangeV3Model(
    year: Int?,
    month: Int?,
    planType: Int?,
    actionType: Int?,
    operate: Int?,
    targetValue: Int?,
    targetType: Int?,
    forceStart: Int?,
    retCode: Int?,
    calories: Int?,
    distance: Int?,
    durations: Int?,
    step: Int?,
    swimPosture: Int?,
    status: Int?,
    signalFlag: Int?,
    isSave: Boolean?,
    realTimeSpeed: Int?,
    realTimePace: Int?,
    interval: Int?,
    hrCount: Int?,
    burnFatMins: Int?,
    aerobicMins: Int?,
    limitMins: Int?,
    hrValues: List<Int?>?,
    warmUpSecond: Int?,
    anaeroicSecond: Int?,
    fatBurnSecond: Int?,
    aerobicSecond: Int?,
    limitSecond: Int?,
    avgHr: Int?,
    maxHr: Int?,
    curHr: Int?,
    warmUpValue: Int?,
    fatBurnValue: Int?,
    aerobicValue: Int?,
    limitValue: Int?,
    anaerobicValue: Int?,
    avgSpeed: Int?,
    maxSpeed: Int?,
    avgStepFrequency: Int?,
    maxStepFrequency: Int?,
    avgStepStride: Int?,
    maxStepStride: Int?,
    kmSpeed: Int?,
    fastKmSpeed: Int?,
    kmSpeedCount: Int?,
    kmSpeeds: List<Int?>?,
    mileCount: Int?,
    mileSpeeds: List<Int?>?,
    stepsFrequencyCount: Int?,
    stepsFrequencys: List<Int?>?,
    trainingEffect: Int?,
    anaerobicTrainingEffect: Int?,
    vo2Max: Int?,
    actionDataCount: Int?,
    inClassCalories: Int?,
    completionRate: Int?,
    hrCompletionRate: Int?,
    recoverTime: Int?,
    avgWeekActivityTime: Int?,
    grade: Int?,
    actionData: List<Map<String, Any>?>?,
    trainingOffset: Int?,
    countHour: Int?,
    countMinute: Int?,
    countSecond: Int?,
    time: Int?,
    lowHeart: Int?,
    heightHeart: Int?,
    paceSpeedCount: Int?,
    paceSpeeds: List<Int?>?,
    realSpeedCount: Int?,
    realSpeeds: List<Int?>?,
    baseModel: IDOExchangeBaseModel?
) {
    
    var year: Int? = year

    
    var month: Int? = month

    
    var planType: Int? = planType

    
    var actionType: Int? = actionType

    
    private  var version: Int? = 0

    
    var operate: Int? = operate

    
    var targetValue: Int? = targetValue

    
    var targetType: Int? = targetType

    
    var forceStart: Int? = forceStart

    
    var retCode: Int? = retCode

    
    var calories: Int? = calories

    
    var distance: Int? = distance

    
    var durations: Int? = durations

    
    var step: Int? = step

    
    var swimPosture: Int? = swimPosture

    
    var status: Int? = status

    
    var signalFlag: Int? = signalFlag

    
    var isSave: Boolean? = isSave

    
    var realTimeSpeed: Int? = realTimeSpeed

    
    var realTimePace: Int? = realTimePace

    
    var interval: Int? = interval

    
    var hrCount: Int? = hrCount

    
    var burnFatMins: Int? = burnFatMins

    
    var aerobicMins: Int? = aerobicMins

    
    var limitMins: Int? = limitMins

    
    var hrValues: List<Int?>? = hrValues

    
    var warmUpSecond: Int? = warmUpSecond

    
    var anaeroicSecond: Int? = anaeroicSecond

    
    var fatBurnSecond: Int? = fatBurnSecond

    
    var aerobicSecond: Int? = aerobicSecond

    
    var limitSecond: Int? = limitSecond

    
    var avgHr: Int? = avgHr

    
    var maxHr: Int? = maxHr

    
    var curHr: Int? = curHr

    
    var warmUpValue: Int? = warmUpValue

    
    var fatBurnValue: Int? = fatBurnValue

    
    var aerobicValue: Int? = aerobicValue

    
    var limitValue: Int? = limitValue

    
    var anaerobicValue: Int? = anaerobicValue

    
    var avgSpeed: Int? = avgSpeed

    
    var maxSpeed: Int? = maxSpeed

    
    var avgStepFrequency: Int? = avgStepFrequency

    
    var maxStepFrequency: Int? = maxStepFrequency

    
    var avgStepStride: Int? = avgStepStride

    
    var maxStepStride: Int? = maxStepStride

    
    var kmSpeed: Int? = kmSpeed

    
    var fastKmSpeed: Int? = fastKmSpeed

    
    var kmSpeedCount: Int? = kmSpeedCount

    
    var kmSpeeds: List<Int?>? = kmSpeeds

    
    var mileCount: Int? = mileCount

    
    var mileSpeeds: List<Int?>? = mileSpeeds

    
    var stepsFrequencyCount: Int? = stepsFrequencyCount

    
    var stepsFrequencys: List<Int?>? = stepsFrequencys

    
    var trainingEffect: Int? = trainingEffect

    
    var anaerobicTrainingEffect: Int? = anaerobicTrainingEffect

    
    var vo2Max: Int? = vo2Max

    
    var actionDataCount: Int? = actionDataCount

    
    var inClassCalories: Int? = inClassCalories

    
    var completionRate: Int? = completionRate

    
    var hrCompletionRate: Int? = hrCompletionRate

    
    var recoverTime: Int? = recoverTime

    
    var avgWeekActivityTime: Int? = avgWeekActivityTime

    
    var grade: Int? = grade

    
    var actionData: List<Map<String, Any>?>? = actionData

    
    var trainingOffset: Int? = trainingOffset

    
    var countHour: Int? = countHour

    
    var countMinute: Int? = countMinute

    
    var countSecond: Int? = countSecond

    
    var time: Int? = time

    
    var lowHeart: Int? = lowHeart

    
    var heightHeart: Int? = heightHeart

    
    var paceSpeedCount: Int? = paceSpeedCount

    
    var paceSpeeds: List<Int?>? = paceSpeeds

    
    var realSpeedCount: Int? = realSpeedCount

    
    var realSpeeds: List<Int?>? = realSpeeds

    
    var baseModel: IDOExchangeBaseModel? = baseModel
}

/**
 * @param day: 日期
 * @param hour: 时
 * @param minute: 分钟
 * @param second: 秒钟
 * @param sportType: 运动类型
 */
open class IDOExchangeBaseModel(
    day: Int?, hour: Int?, minute: Int?, second: Int?, sportType: Int?
) {
    
    var day: Int? = day

    
    var hour: Int? = hour

    
    var minute: Int? = minute

    
    var second: Int? = second

    
    var sportType: Int? = sportType
}

/**
 * app 开始发起运动
 * @param targetType: 目标类型
 * @param targetValue: 目标值
 * @param forceStart: 是否强制开始 0:不强制,1:强制
 * @param vo2max: 最大摄氧量 单位 ml/kg/min
 * @param recoverTime: 恢复时长：单位小时
 * @param avgWeekActivityTime: 上个月平均每周的运动时间 单位分钟
 * @param baseModel: 基础数据 日期、时间、运动类型
 */
class IDOAppStartExchangeModel(
    targetType: Int? = 0,
    targetValue: Int? = 0,
    forceStart: Int? = 0,
    vo2max: Int? = 0,
    recoverTime: Int? = 0,
    avgWeekActivityTime: Int? = 0,
    baseModel: IDOExchangeBaseModel?
) {

    
    var targetType: Int? = targetType

    
    var targetValue: Int? = targetValue

    
    var forceStart: Int? = forceStart

    
    var vo2max: Int? = vo2max

    
    var recoverTime: Int? = recoverTime

    
    var avgWeekActivityTime: Int? = avgWeekActivityTime

    
    var baseModel: IDOExchangeBaseModel? = baseModel


    internal fun toInnerModel(): AppStartExchangeModel {
        val gosn = Gson()

        val json = gosn.toJson(this).toString()
        return gosn.fromJson(json, AppStartExchangeModel::class.java)
    }
}

/**
 * app 发起运动结束
 * Generated class from Pigeon that represents data sent in messages.
 * @param duration: 持续时长（单位：s）
 * @param calories: 卡路里，单位大卡
 * @param distance: 距离（单位：米）
 * @param isSave: 0:不保存，1:保存
 * @param baseModel: 基础数据 日期、时间、运动类型
 */
class IDOAppEndExchangeModel(
    duration: Int?, calories: Int?, distance: Int?, isSave: Int?, baseModel: IDOExchangeBaseModel?
) {

    
    var duration: Int? = duration

    
    var calories: Int? = calories

    
    var distance: Int? = distance

    
    var isSave: Int? = isSave

    
    var baseModel: IDOExchangeBaseModel? = baseModel

    internal fun toInnerModel(): AppEndExchangeModel {
        val gosn = Gson()

        val json = gosn.toJson(this).toString()
        return gosn.fromJson(json, AppEndExchangeModel::class.java)
    }
}

/**
 * app 交换运动数据
 * Generated class from Pigeon that represents data sent in messages.
 * @param duration: 持续时长 单位s
 * @param calories: 卡路里 单位大卡
 * @param distance: 距离 单位0.01km
 * @param status: 0: 全部有效、1: 距离无效、 2: GPS信号弱
 * @param baseModel: 基础数据 日期、时间、运动类型
 */
class IDOAppIngExchangeModel(
    duration: Int?, calories: Int?, distance: Int?, status: Int?, baseModel: IDOExchangeBaseModel?
) {

    
    var duration: Int? = duration

    
    var calories: Int? = calories

    
    var distance: Int? = distance

    
    var status: Int? = status

    
    var baseModel: IDOExchangeBaseModel? = baseModel

    internal fun toInnerModel(): AppIngExchangeModel {
        val gosn = Gson()

        val json = gosn.toJson(this).toString()
        return gosn.fromJson(json, AppIngExchangeModel::class.java)
    }
}

/**
 * app 交换运动数据暂停
 * @param baseModel: 基础数据 日期、时间、运动类型
 */
class IDOAppPauseExchangeModel(baseModel: IDOExchangeBaseModel?) {

    
    var pauseHour: Int? = baseModel?.hour

    
    var pauseMinute: Int? = baseModel?.minute

    
    var pauseSecond: Int? = baseModel?.second

    
    var baseModel: IDOExchangeBaseModel? = baseModel

    internal fun toInnerModel(): AppPauseExchangeModel {
        val gosn = Gson()

        val json = gosn.toJson(this).toString()

        val model = gosn.fromJson(json, AppPauseExchangeModel::class.java)
        return model
    }
}

/**
 * app 交换运动数据暂停
 * @param baseModel: 基础数据 日期、时间、运动类型
 */
class IDOAppRestoreExchangeModel(baseModel: IDOExchangeBaseModel?) {

    
    var baseModel: IDOExchangeBaseModel? = baseModel

    internal fun toInnerModel(): AppRestoreExchangeModel {
        val gosn = Gson()

        val json = gosn.toJson(this).toString()
        return gosn.fromJson(json, AppRestoreExchangeModel::class.java)
    }
}

/**
 * * app v3交换运动数据
 * @param version: 协议版本号
 * @param signal: 0: 表示信号弱 2: 表示信号强
 * @param distance: app 距离
 * @param speed: app计算显示实时配速，单位km/h，100倍
 * @param duration: 持续时间
 * @param calories: 卡路里
 * @param baseModel: 基础数据 日期、时间、运动类型
 */
class IDOAppIngV3ExchangeModel(
    signal: Int?,
    distance: Int?,
    speed: Int?,
    duration: Int?,
    calories: Int?,
    baseModel: IDOExchangeBaseModel?
) {

    
    private var version: Int? = 0

    
    var signal: Int? = signal

    
    var distance: Int? = distance

    
    var speed: Int? = speed

    
    var duration: Int? = duration

    
    var calories: Int? = calories

    
    var baseModel: IDOExchangeBaseModel? = baseModel

    internal fun toInnerModel(): AppIngV3ExchangeModel {
        val gosn = Gson()

        val json = gosn.toJson(this).toString()
        return gosn.fromJson(json, AppIngV3ExchangeModel::class.java)
    }
}

/**
 * * app 操作计划运动
 * @param operate: 1:开始运动，2：暂停运动, 3:恢复运动 ，4：结束运动, 5: 切换动作
 * @param trainingOffset: 训练的课程日期偏移 从0开始
 * @param planType: 计划类型
 * - 1：跑步计划3km，2：跑步计划5km，
 * - 3：跑步计划10km，4：半程马拉松训练 5：马拉松训练（二期）
 * @param baseModel: 基础数据 日期、时间、运动类型
 */
class IDOAppOperatePlanExchangeModel(
    operate: Int?, trainingOffset: Int?, planType: Int?, baseModel: IDOExchangeBaseModel?
) {

    
    var operate: Int? = operate

    
    var trainingOffset: Int? = trainingOffset

    
    var planType: Int? = planType

    
    var baseModel: IDOExchangeBaseModel? = baseModel

    internal fun toInnerModel(): AppOperatePlanExchangeModel {
        val gosn = Gson()

        val json = gosn.toJson(this).toString()
        return gosn.fromJson(json, AppOperatePlanExchangeModel::class.java)
    }
}

/// ble 操作计划运动
///
/// 1:开始运动，2：暂停运动, 3:恢复运动 ，4：结束运动, 5: 切换动作
/// operate: Int?
/// 计划类型：1：跑步计划3km，2：跑步计划5km，
/// 3：跑步计划10km，4：半程马拉松训练（二期，5：马拉松训练（二期）
/// planType: Int?
/// 动作类型  1:快走；2:慢跑；3:中速跑；4:快跑  ；
/// 5:结束课程运动 （还要等待用户是否有自由运动）；
/// 6:课程结束后自由运动 （此字段当operate为5起作用）
/// actionType: Int?
/// 0为成功，非0为失败
/// errorCode: Int?
/// 训练课程年份
/// trainingYear: Int?
/// 训练课程月份
/// trainingMonth: Int?
/// 训练课程日期
/// trainingDay: Int?
/// 动作目标时间  单位秒
/// time: Int?
/// 心率范围低值
/// lowHeart: Int?
/// 心率范围高值
/// heightHeart: Int?
class IDOBleOperatePlanExchangeModel(
    operate: Int?,
    planType: Int?,
    actionType: Int?,
    errorCode: Int?,
    trainingYear: Int?,
    trainingMonth: Int?,
    trainingDay: Int?,
    time: Int?,
    lowHeart: Int?,
    heightHeart: Int?,
    baseModel: IDOExchangeBaseModel?
) {
    
    var operate: Int? = operate

    
    var planType: Int? = planType

    
    var actionType: Int? = actionType

    
    var errorCode: Int? = errorCode

    
    var trainingYear: Int? = trainingYear

    
    var trainingMonth: Int? = trainingMonth

    
    var trainingDay: Int? = trainingDay

    
    var time: Int? = time

    
    var lowHeart: Int? = lowHeart

    
    var heightHeart: Int? = heightHeart

    
    var baseModel: IDOExchangeBaseModel? = baseModel

    internal fun toInnerModel(): BleOperatePlanExchangeModel {
        val gosn = Gson()

        val json = gosn.toJson(this).toString()
        return gosn.fromJson(json, BleOperatePlanExchangeModel::class.java)
    }
}

/**
 * ble发起的运动 ble设备发送交换运动数据开始 app回复
 *
 * @param operate: 1：请求app打开gps 2：发起运动请求
 * @param retCode: 0: 成功 非0: 失败
 * @param baseModel: 基础数据 日期、时间、运动类型
 */
class IDOBleStartReplyExchangeModel(
    operate: Int?, retCode: Int?, baseModel: IDOExchangeBaseModel?
) {

    
    var operate: Int? = operate

    
    var retCode: Int? = retCode

    
    var baseModel: IDOExchangeBaseModel? = baseModel

    internal fun toInnerModel(): BleStartReplyExchangeModel {
        val gosn = Gson()

        val json = gosn.toJson(this).toString()
        return gosn.fromJson(json, BleStartReplyExchangeModel::class.java)
    }
}

/**
 * ble发起的运动 ble设备交换运动数据过程中 app回复
 *
 * @param distance: 距离 单位：0.01km
 * @param baseModel: 基础数据 日期、时间、运动类型
 */
class IDOBleIngReplyExchangeModel(distance: Int?, baseModel: IDOExchangeBaseModel?) {

    
    var distance: Int? = distance

    
    var baseModel: IDOExchangeBaseModel? = baseModel

    internal fun toInnerModel(): BleIngReplyExchangeModel {
        val gosn = Gson()

        val json = gosn.toJson(this).toString()
        return gosn.fromJson(json, BleIngReplyExchangeModel::class.java)
    }
}

/**
 * ble发起的运动 ble设备发送交换运动数据结束 app回复
 *
 * @param retCode: 0: 成功 非0: 失败
 * @param baseModel: 基础数据 日期、时间、运动类型
 */
class IDOBleEndReplyExchangeModel(retCode: Int?, baseModel: IDOExchangeBaseModel?) {

    
    var retCode: Int? = retCode

    
    var baseModel: IDOExchangeBaseModel? = baseModel

    internal fun toInnerModel(): BleEndReplyExchangeModel {
        val gosn = Gson()

        val json = gosn.toJson(this).toString()
        return gosn.fromJson(json, BleEndReplyExchangeModel::class.java)
    }
}


/**
 * ble发起的运动 ble设备发送交换运动数据暂停 app回复
 *
 * @param retCode: 0: 成功 非0: 失败
 * @param baseModel: 基础数据 日期、时间、运动类型
 */
class IDOBlePauseReplyExchangeModel(retCode: Int?, baseModel: IDOExchangeBaseModel?) {

    
    var retCode: Int? = retCode

    
    var baseModel: IDOExchangeBaseModel? = baseModel

    internal fun toInnerModel(): BlePauseReplyExchangeModel {
        val gosn = Gson()

        val json = gosn.toJson(this).toString()
        return gosn.fromJson(json, BlePauseReplyExchangeModel::class.java)
    }
}

/**
 * ble发起的运动 ble设备发送交换运动数据恢复 app回复
 *
 * @param retCode: 0: 成功 非0: 失败
 * @param baseModel: 基础数据 日期、时间、运动类型
 */
class IDOBleRestoreReplyExchangeModel(retCode: Int?, baseModel: IDOExchangeBaseModel?) {

    
    var retCode: Int? = retCode

    
    var baseModel: IDOExchangeBaseModel? = baseModel

    internal fun toInnerModel(): BleRestoreReplyExchangeModel {
        val gosn = Gson()

        val json = gosn.toJson(this).toString()
        return gosn.fromJson(json, BleRestoreReplyExchangeModel::class.java)
    }
}

/**
 * ble 操作计划运动 app回复
 *
 *
 * @param operate: 1:开始运动，2：暂停运动, 3:恢复运动 ，4：结束运动, 5: 切换动作
 * @param planType: 计划类型
 * - 1：跑步计划3km，2：跑步计划5km，
 * - 3：跑步计划10km，4：半程马拉松训练 5：马拉松训练（二期）
 * @param actionType: 动作类型
 * - 1:快走；2:慢跑；3:中速跑；4:快跑 ；
 * - 5:结束课程运动 （还要等待用户是否有自由运动）；
 * - 6:课程结束后自由运动 （此字段当operate为5起作用）
 * @param errorCode: 0为成功，非0为失败
 * @param baseModel: 基础数据 日期、时间、运动类型
 */

class IDOBleOperatePlanReplyExchangeModel(
    operate: Int?,
    planType: Int?,
    actionType: Int?,
    errorCode: Int?,
    baseModel: IDOExchangeBaseModel?
) {
    
    var operate: Int? = operate

    
    var planType: Int? = planType

    
    var actionType: Int? = actionType

    
    var errorCode: Int? = errorCode

    
    var baseModel: IDOExchangeBaseModel? = baseModel

    internal fun toInnerModel(): BleOperatePlanReplyExchangeModel {
        val gosn = Gson()

        val json = gosn.toJson(this).toString()
        return gosn.fromJson(json, BleOperatePlanReplyExchangeModel::class.java)
    }
}

/**
 * app发起运动 ble设备发送交换运动数据暂停 app回复
 *
 * @param errCode: 0: 成功; 1: 没有进入运动模式失败
 * @param baseModel: 基础数据 日期、时间、运动类型
 */
class IDOAppBlePauseReplyExchangeModel(errCode: Int?, baseModel: IDOExchangeBaseModel?) {

    
    var errCode: Int? = errCode

    
    var baseModel: IDOExchangeBaseModel? = baseModel

    internal fun toInnerModel(): AppBlePauseReplyExchangeModel {
        val gosn = Gson()

        val json = gosn.toJson(this).toString()
        return gosn.fromJson(json, AppBlePauseReplyExchangeModel::class.java)
    }
}

/**
 * app发起运动 ble设备发送交换运动数据恢复 app回复
 *
 * @param errCode: 0: 成功; 1: 没有进入运动模式失败
 * @param baseModel: 基础数据 日期、时间、运动类型
 */
class IDOAppBleRestoreReplyExchangeModel(errCode: Int?, baseModel: IDOExchangeBaseModel?) {

    
    var errCode: Int? = errCode

    
    var baseModel: IDOExchangeBaseModel? = baseModel

    internal fun toInnerModel(): AppBleRestoreReplyExchangeModel {
        val gosn = Gson()

        val json = gosn.toJson(this).toString()
        return gosn.fromJson(json, AppBleRestoreReplyExchangeModel::class.java)
    }
}


/**
 * app发起运动 ble设备发送交换运动数据结束 app回复
 *
 * @param errCode: 0: 成功; 1: 没有进入运动模式失败
 * @param duration: 持续时长 单位s
 * @param calories: 卡路里 单位大卡
 * @param distance:  距离 单位0.01km
 * @param baseModel: 基础数据 日期、时间、运动类型
 */
class IDOAppBleEndReplyExchangeModel(
    errCode: Int?, duration: Int?, calories: Int?, distance: Int?, baseModel: IDOExchangeBaseModel?
) {

    
    var errCode: Int? = errCode

    
    var duration: Int? = duration

    
    var calories: Int? = calories

    
    var distance: Int? = distance

    
    var baseModel: IDOExchangeBaseModel? = baseModel


    internal fun toInnerModel(): AppBleEndReplyExchangeModel {
        val gosn = Gson()

        val json = gosn.toJson(this).toString()
        return gosn.fromJson(json, AppBleEndReplyExchangeModel::class.java)
    }
}

/**
 *  ble发起运动 ble设备发送交换运动数据开始
 *
 * @param operate: 1：请求app打开gps 2：发起运动请求
 * @param baseModel: 基础数据 日期、时间、运动类型
 */
class IDOBleStartExchangeModel(operate: Int?, baseModel: IDOExchangeBaseModel?) {

    
    var operate: Int? = operate

    
    var baseModel: IDOExchangeBaseModel? = baseModel

    internal fun toInnerModel(): BleStartExchangeModel {
        val gosn = Gson()

        val json = gosn.toJson(this).toString()
        return gosn.fromJson(json, BleStartExchangeModel::class.java)
    }
}

/**
 * ble发起的运动 ble设备交换运动数据过程中
 *
 * @param distance: 距离 单位：0.01km
 * @param baseModel: 基础数据 日期、时间、运动类型
 */
class IDOBleIngExchangeModel(distance: Int?, baseModel: IDOExchangeBaseModel?) {

    
    val distance: Int? = distance

    
    var baseModel: IDOExchangeBaseModel? = baseModel

    internal fun toInnerModel(): BleIngExchangeModel {
        val gosn = Gson()

        val json = gosn.toJson(this).toString()
        return gosn.fromJson(json, BleIngExchangeModel::class.java)
    }
}

/**
 * ble发起的运动 ble设备发送交换运动数据结束
 * @param baseModel: 基础数据 日期、时间、运动类型
 */
class IDOBleEndExchangeModel(baseModel: IDOExchangeBaseModel?) {

    
    var baseModel: IDOExchangeBaseModel? = baseModel

    internal fun toInnerModel(): BleEndExchangeModel {
        val gosn = Gson()

        val json = gosn.toJson(this).toString()
        return gosn.fromJson(json, BleEndExchangeModel::class.java)
    }
}

/**
 * ble发起的运动 ble设备发送交换运动数据暂停
 * @param baseModel: 基础数据 日期、时间、运动类型
 */
class IDOBlePauseExchangeModel(baseModel: IDOExchangeBaseModel?) {

    
    var baseModel: IDOExchangeBaseModel? = baseModel

    internal fun toInnerModel(): BlePauseExchangeModel {
        val gosn = Gson()

        val json = gosn.toJson(this).toString()
        return gosn.fromJson(json, BlePauseExchangeModel::class.java)
    }
}

/**
 * ble发起的运动 ble设备发送交换运动数据恢复
 * @param baseModel: 基础数据 日期、时间、运动类型
 */
class IDOBleRestoreExchangeModel(baseModel: IDOExchangeBaseModel?) {

    
    var baseModel: IDOExchangeBaseModel? = baseModel

    internal fun toInnerModel(): BleRestoreExchangeModel {
        val gosn = Gson()

        val json = gosn.toJson(this).toString()
        return gosn.fromJson(json, BleRestoreExchangeModel::class.java)
    }
}

/**
 * app发起运动 ble设备发送交换运动数据暂停
 * @param baseModel: 基础数据 日期、时间、运动类型
 */
class IDOAppBlePauseExchangeModel(baseModel: IDOExchangeBaseModel?) {

    
    var baseModel: IDOExchangeBaseModel? = baseModel

    internal fun toInnerModel(): AppBlePauseExchangeModel {
        val gosn = Gson()

        val json = gosn.toJson(this).toString()
        return gosn.fromJson(json, AppBlePauseExchangeModel::class.java)
    }
}

/**
 * app发起运动 ble设备发送交换运动数据恢复
 * @param baseModel: 基础数据 日期、时间、运动类型
 */

class IDOAppBleRestoreExchangeModel(baseModel: IDOExchangeBaseModel?) {

    
    var baseModel: IDOExchangeBaseModel? = baseModel

    internal fun toInnerModel(): AppBleRestoreExchangeModel {
        val gosn = Gson()

        val json = gosn.toJson(this).toString()
        return gosn.fromJson(json, AppBleRestoreExchangeModel::class.java)
    }
}

/**
 * app发起运动 ble设备发送交换运动数据结束
 * @param duration: 持续时长 单位s
 * @param calories: 卡路里 单位大卡
 * @param distance: 距离 单位0.01km
 * @param avgHr: 平均心率
 * @param maxHr: 最大心率
 * @param burnFatMins: 脂肪燃烧时长 单位分钟
 * @param aerobicMins: 心肺锻炼时长 单位分钟
 * @param limitMins: 极限锻炼时长 单位分钟
 * @param isSave: 0:不保存，1:保存
 * @param baseModel: 基础数据 日期、时间、运动类型
 */
class IDOAppBleEndExchangeModel(
    duration: Int?,
    calories: Int?,
    distance: Int?,
    avgHr: Int?,
    maxHr: Int?,
    burnFatMins: Int?,
    aerobicMins: Int?,
    limitMins: Int?,
    isSave: Int?,
    baseModel: IDOExchangeBaseModel?
) {

    
    var duration: Int? = duration

    
    var calories: Int? = calories

    
    var distance: Int? = distance

    
    var avgHr: Int? = avgHr

    
    var maxHr: Int? = maxHr

    
    var burnFatMins: Int? = burnFatMins

    
    var aerobicMins: Int? = aerobicMins

    
    var limitMins: Int? = limitMins

    
    var isSave: Int? = isSave

    
    var baseModel: IDOExchangeBaseModel? = baseModel

    internal fun toInnerModel(): AppBleEndExchangeModel {
        val gosn = Gson()

        val json = gosn.toJson(this).toString()
        return gosn.fromJson(json, AppBleEndExchangeModel::class.java)
    }
}

/**
 * app 开始发起运动 ble回复
 * @param retCode: 响应状态
 * - 0:成功; 1:设备已经进入运动模式失败;
 * - 2:设备电量低失败;3:手环正在充电
 * - 4:正在使用Alexa 5:通话中
 * @param baseModel: 基础数据 日期、时间、运动类型
 */
class IDOAppStartReplyExchangeModel(retCode: Int?, baseModel: IDOExchangeBaseModel?) {

    
    var retCode: Int? = retCode

    
    var baseModel: IDOExchangeBaseModel? = baseModel

    internal fun toInnerModel(): AppStartReplyExchangeModel {
        val gosn = Gson()

        val json = gosn.toJson(this).toString()
        return gosn.fromJson(json, AppStartReplyExchangeModel::class.java)
    }
}

/**
 * app 发起运动结束 ble回复
 * @param errorCode: 0:成功; 1:设备结束失败
 * @param calories: 卡路里，单位大卡
 * @param distance: 距离（单位：米）
 * @param step: 步数 (单位:步)
 * @param avgHr: 平均心率
 * @param maxHr: 最大心率
 * @param burnFatMins: 脂肪燃烧时长 单位分钟
 * @param aerobicMins: 心肺锻炼时长 单位分钟
 * @param limitMins: 极限锻炼时长 单位分钟
 * @param baseModel: 基础数据 日期、时间、运动类型
 */
class IDOAppEndReplyExchangeModel(
    errorCode: Int?,
    calories: Int?,
    distance: Int?,
    step: Int?,
    avgHr: Int?,
    maxHr: Int?,
    burnFatMins: Int?,
    aerobicMins: Int?,
    limitMins: Int?,
    baseModel: IDOExchangeBaseModel?
) {
    
    var errorCode: Int? = errorCode

    
    var calories: Int? = calories

    
    var distance: Int? = distance

    
    var step: Int? = step

    
    var avgHr: Int? = avgHr

    
    var maxHr: Int? = maxHr

    
    var burnFatMins: Int? = burnFatMins

    
    var aerobicMins: Int? = aerobicMins

    
    var limitMins: Int? = limitMins

    
    var baseModel: IDOExchangeBaseModel? = baseModel

    internal fun toInnerModel(): AppEndReplyExchangeModel {
        val gosn = Gson()

        val json = gosn.toJson(this).toString()
        return gosn.fromJson(json, AppEndReplyExchangeModel::class.java)
    }
}

/**
 * *app 交换运动数据 ble回复
 * @param calories: 卡路里 单位大卡
 * @param distance: 距离 单位0.01km
 * @param status: 0: 全部有效、1: 距离无效、 2: GPS信号弱
 * @param step:步数
 * @param currentHr: 当前心率
 * @param interval: 心率间隔 单位s
 * @param hrSerial: 序列号
 * @param hrJson: 心率值数据
 * @param baseModel: 基础数据 日期、时间、运动类型
 */
class IDOAppIngReplyExchangeModel(
    calories: Int?,
    distance: Int?,
    status: Int?,
    step: Int?,
    currentHr: Int?,
    interval: Int?,
    hrSerial: Int?,
    hrJson: List<Int>?,
    baseModel: IDOExchangeBaseModel?
) {

    
    var calories: Int? = calories

    
    var distance: Int? = distance

    
    var status: Int? = status

    
    var step: Int? = step

    
    var currentHr: Int? = currentHr

    
    var interval: Int? = hrSerial

    
    var hrSerial: Int? = hrSerial

    
    var hrJson: List<Int>? = hrJson

    
    var baseModel: IDOExchangeBaseModel? = baseModel

    internal fun toInnerModel(): AppIngReplyExchangeModel {
        val gosn = Gson()

        val json = gosn.toJson(this).toString()
        return gosn.fromJson(json, AppIngReplyExchangeModel::class.java)
    }
}

/**
 * app 交换运动数据暂停 ble回复
 *
 * @param errCode: 暂停错误码 0:成功 非0:失败
 * @param baseModel: 基础数据 日期、时间、运动类型
 */
class IDOAppPauseReplyExchangeModel(errCode: Int?, baseModel: IDOExchangeBaseModel?) {

    
    var errCode: Int? = errCode

    
    var baseModel: IDOExchangeBaseModel? = baseModel

    internal fun toInnerModel(): AppBlePauseReplyExchangeModel {
        val gosn = Gson()

        val json = gosn.toJson(this).toString()
        return gosn.fromJson(json, AppBlePauseReplyExchangeModel::class.java)
    }
}

/**
 * app 交换运动数据恢复 ble回复
 *
 * @param errCode: 恢复错误码 0:成功 非0:失败
 * @param baseModel: 基础数据 日期、时间、运动类型
 */
class IDOAppRestoreReplyExchangeModel(errCode: Int?, baseModel: IDOExchangeBaseModel?) {

    
    var errCode: Int? = errCode

    
    var baseModel: IDOExchangeBaseModel? = baseModel

    internal fun toInnerModel(): AppRestoreReplyExchangeModel {
        val gosn = Gson()

        val json = gosn.toJson(this).toString()
        return gosn.fromJson(json, AppRestoreReplyExchangeModel::class.java)
    }
}

/**
 * app v3交换运动数据 ble回复
 *
 * @param version: 协议版本号
 * @param heartRate: 心率数据
 * @param distance: 距离 单位根据单位设置的单位显示
 * @param duration: 持续时间 秒钟
 * @param realTimeCalories: 动态卡路里
 * @param realTimeSpeed: 实时速度，单位km/h，扩大100倍
 * @param kmSpeed: 实时公里配速 单位s/公里
 * @param steps: 步数
 * @param swimPosture: 主泳姿
 * @param status: 状态
 * - 0：无效 1：开始 2：手动暂停 3：结束 4：自动暂停
 * - 5秒使用滑动平均，第5秒使用1-5秒数据，第6秒使用2-6秒数据
 * @param realTimeSpeedPace: 实时的配速，单位秒
 * @param trainingEffect: 有氧训练效果等级  单位无  范围 0-50 扩大10倍传输
 * @param anaerobicTrainingEffect: 无氧运动训练效果等级 单位无  范围 0-50 扩大10倍传输
 * @param actionType: 动作类型
 * - 1快走
 * - 2慢跑
 * - 3中速跑
 * - 4快跑
 * - 5结束课程运动 （还要等待用户是否有自由运动）
 * - 6课程结束后自由运动（此字段当operate为5起作用）
 * @param countHour: 运动累积时间 时
 * @param countMinute: 运动累积时间 分
 * @param countSecond: 运动累积时间 秒
 */
class IDOAppIngV3ReplyExchangeModel(
    heartRate: Int?,
    distance: Int?,
    duration: Int?,
    realTimeCalories: Int?,
    realTimeSpeed: Int?,
    kmSpeed: Int?,
    steps: Int?,
    swimPosture: Int?,
    status: Int?,
    realTimeSpeedPace: Int?,
    trainingEffect: Int?,
    anaerobicTrainingEffect: Int?,
    actionType: Int?,
    countHour: Int?,
    countMinute: Int?,
    countSecond: Int?,
    baseModel: IDOExchangeBaseModel?
) {

    
    private var version: Int? = 0

    
    var heartRate: Int? = heartRate

    
    var distance: Int? = distance

    
    var duration: Int? = duration

    
    var realTimeCalories: Int? = realTimeCalories

    
    var realTimeSpeed: Int? = realTimeSpeed

    
    var kmSpeed: Int? = kmSpeed

    
    var steps: Int? = steps

    
    var swimPosture: Int? = swimPosture

    
    var status: Int? = status

    
    var realTimeSpeedPace: Int? = realTimeSpeedPace

    
    var trainingEffect: Int? = trainingEffect

    
    var anaerobicTrainingEffect: Int? = anaerobicTrainingEffect

    
    var actionType: Int? = actionType

    
    var countHour: Int? = countHour

    
    var countMinute: Int? = countMinute

    
    var countSecond: Int? = countSecond

    
    var baseModel: IDOExchangeBaseModel? = baseModel


    internal fun toInnerModel(): AppIngV3ReplyExchangeModel {
        val gosn = Gson()

        val json = gosn.toJson(this).toString()
        return gosn.fromJson(json, AppIngV3ReplyExchangeModel::class.java)
    }
}

/**
 * app 操作计划运动 ble回复
 * @param planType: 计划类型
 * -1：跑步计划3km，2：跑步计划5km，
 * -3：跑步计划10km，4：半程马拉松训练，5：马拉松训练（二期）
 * @param operate: 1:开始运动，2：暂停运动, 3:恢复运动 ，4：结束运动, 5: 切换动作
 * @param actionType: 动作类型
 * -1:快走；2:慢跑；3:中速跑；4:快跑；
 * -5:结束课程运动 （还要等待用户是否有自由运动）；
 * -6:课程结束后自由运动 （此字段当operate为5起作用）
 * @param errorCode: 0为成功，非0为失败
 */
class IDOAppOperatePlanReplyExchangeModel(
    planType: Int?,
    operate: Int?,
    actionType: Int?,
    errorCode: Int?,
    baseModel: IDOExchangeBaseModel?
) {

    
    var planType: Int? = planType

    
    var operate: Int? = operate

    
    var actionType: Int? = actionType

    
    var errorCode: Int? = errorCode

    
    var baseModel: IDOExchangeBaseModel? = baseModel

    internal fun toInnerModel(): AppOperatePlanReplyExchangeModel {
        val gosn = Gson()

        val json = gosn.toJson(this).toString()
        return gosn.fromJson(json, AppOperatePlanReplyExchangeModel::class.java)
    }
}
