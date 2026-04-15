package com.idosmart.pigeon_implement

import com.google.gson.FieldNamingPolicy
import com.google.gson.FieldNamingStrategy
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.reflect.TypeToken
import com.idosmart.model.CustomFieldNamingStrategy
import com.idosmart.model.IDOActivitySwitchModel
import com.idosmart.model.IDOActivitySwitchParamModel
import com.idosmart.model.IDOAlarmModel
import com.idosmart.model.IDOAllHealthSwitchStateModel
import com.idosmart.model.IDOAppletControlModel
import com.idosmart.model.IDOAppletInfoModel
import com.idosmart.model.IDOBaseAdapterModel
import com.idosmart.model.IDOBaseModel
import com.idosmart.model.IDOBatteryInfoModel
import com.idosmart.model.IDOBatteryReminderSwitchReplyModel
import com.idosmart.model.IDOBatteryReminderSwitchModel
import com.idosmart.model.IDOBatteryReminderSwitchParamModel
import com.idosmart.model.IDOBleBeepModel
import com.idosmart.model.IDOBleVoiceParamModel
import com.idosmart.model.IDOBpAlgVersionModel
import com.idosmart.model.IDOBpCalControlModel
import com.idosmart.model.IDOBpCalibrationModel
import com.idosmart.model.IDOBpCalibrationParamModel
import com.idosmart.model.IDOBpMeasurementModel
import com.idosmart.model.IDOBpMeasurementParamModel
import com.idosmart.model.IDOMeasurementAction
import com.idosmart.model.IDOMeasurementModel
import com.idosmart.model.IDOMeasurementType
import com.idosmart.model.IDOBtNoticeModel
import com.idosmart.model.IDOCmdGetResponseModel
import com.idosmart.model.IDOContactReviseTimeModel
import com.idosmart.model.IDODateTimeParamModel
import com.idosmart.model.IDODefaultSportTypeModel
import com.idosmart.model.IDODeviceLogStateModel
import com.idosmart.model.IDODisplayModeParamModel
import com.idosmart.model.IDODownloadLanguageModel
import com.idosmart.model.IDODrinkWaterRemindModel
import com.idosmart.model.IDOErrorRecordModel
import com.idosmart.model.IDOFastMsgSettingModel
import com.idosmart.model.IDOFastMsgUpdateModel
import com.idosmart.model.IDOFastMsgUpdateParamModel
import com.idosmart.model.IDOFitnessGuidanceParamModel
import com.idosmart.model.IDOFlashBinInfoModel
import com.idosmart.model.IDOGpsControlModel
import com.idosmart.model.IDOGpsControlParamModel
import com.idosmart.model.IDOGpsHotStartParamModel
import com.idosmart.model.IDOGpsInfoModel
import com.idosmart.model.IDOGpsStatusModel
import com.idosmart.model.IDOHabitInfoModel
import com.idosmart.model.IDOHandWashingReminderParamModel
import com.idosmart.model.IDOHeartModeModel
import com.idosmart.model.IDOHeartModeParamModel
import com.idosmart.model.IDOHeartRateIntervalModel
import com.idosmart.model.IDOHeartRateModeModel
import com.idosmart.model.IDOHeartRateModeSmartModel
import com.idosmart.model.IDOHeartRateModeSmartParamModel
import com.idosmart.model.IDOHistoricalMenstruationParamModel
import com.idosmart.model.IDOHotStartParamModel
import com.idosmart.model.IDOLanguageLibraryModel
import com.idosmart.model.IDOLiveDataModel
import com.idosmart.model.IDOLongSitParamModel
import com.idosmart.model.IDOLostFindParamModel
import com.idosmart.model.IDOMainSportGoalModel
import com.idosmart.model.IDOMainUISortModel
import com.idosmart.model.IDOMainUISortParamModel
import com.idosmart.model.IDOMenstruationModel
import com.idosmart.model.IDOMenstruationRemindParamModel
import com.idosmart.model.IDOMenuListModel
import com.idosmart.model.IDOMenuListParamModel
import com.idosmart.model.IDOMtuInfoModel
import com.idosmart.model.IDOMusicControlParamModel
import com.idosmart.model.IDOMusicInfoModel
import com.idosmart.model.IDOMusicOnOffParamModel
import com.idosmart.model.IDOMusicOpearteParamModel
import com.idosmart.model.IDOMusicOperateModel
import com.idosmart.model.IDONotDisturbParamModel
import com.idosmart.model.IDONotDisturbStatusModel
import com.idosmart.model.IDONoticeMesaageParamModel
import com.idosmart.model.IDONoticeMessageParamModel
import com.idosmart.model.IDONoticeMessageStateModel
import com.idosmart.model.IDONoticeMessageStateParamModel
import com.idosmart.model.IDONotificationCenterModel
import com.idosmart.model.IDONotificationStatusParamModel
import com.idosmart.model.IDOPetInfoModel
import com.idosmart.model.IDOPetInfoParamModel
import com.idosmart.model.IDOPetInfoReplyModel
import com.idosmart.model.IDORunPlanParamModel
import com.idosmart.model.IDOSchedulerReminderModel
import com.idosmart.model.IDOSchedulerReminderParamModel
import com.idosmart.model.IDOScientificSleepSwitchParamModel
import com.idosmart.model.IDOScreenBrightnessModel
import com.idosmart.model.IDOSendRunPlanModel
import com.idosmart.model.IDOSetNoticeStatusModel
import com.idosmart.model.IDOShortcutParamModel
import com.idosmart.model.IDOSleepPeriodParamModel
import com.idosmart.model.IDOSpo2SwitchModel
import com.idosmart.model.IDOSpo2SwitchParamModel
import com.idosmart.model.IDOSport100SortModel
import com.idosmart.model.IDOSport100SortParamModel
import com.idosmart.model.IDOSportGoalParamModel
import com.idosmart.model.IDOSportModeSelectParamModel
import com.idosmart.model.IDOSportModeSortParamModel
import com.idosmart.model.IDOSportParamModel
import com.idosmart.model.IDOSportSortModel
import com.idosmart.model.IDOSportSortParamModel
import com.idosmart.model.IDOSppMtuModel
import com.idosmart.model.IDOStepGoalModel
import com.idosmart.model.IDOStressCalibrationModel
import com.idosmart.model.IDOStressCalibrationParamModel
import com.idosmart.model.IDOStressSwitchModel
import com.idosmart.model.IDOStressSwitchParamModel
import com.idosmart.model.IDOStressValModel
import com.idosmart.model.IDOSupportMaxSetItemsNumModel
import com.idosmart.model.IDOSyncContactModel
import com.idosmart.model.IDOSyncContactParamModel
import com.idosmart.model.IDOTakingMedicineReminderParamModel
import com.idosmart.model.IDOTemperatureSwitchParamModel
import com.idosmart.model.IDOUnerasableMeunListModel
import com.idosmart.model.IDOUnitModel
import com.idosmart.model.IDOUnitParamModel
import com.idosmart.model.IDOUpHandGestureModel
import com.idosmart.model.IDOUpHandGestureParamModel
import com.idosmart.model.IDOUpdateStatusModel
import com.idosmart.model.IDOUserInfoPramModel
import com.idosmart.model.IDOV3NoiseParamModel
import com.idosmart.model.IDOVersionInfoModel
import com.idosmart.model.IDOVoiceReplyParamModel
import com.idosmart.model.IDOWalkRemindModel
import com.idosmart.model.IDOWalkRemindTimesParamModel
import com.idosmart.model.IDOWallpaperDialReplyV3Model
import com.idosmart.model.IDOWallpaperDialReplyV3ParamModel
import com.idosmart.model.IDOWatchDialIdModel
import com.idosmart.model.IDOWatchDialInfoModel
import com.idosmart.model.IDOWatchDialParamModel
import com.idosmart.model.IDOWatchDialSortParamModel
import com.idosmart.model.IDOWatchFaceModel
import com.idosmart.model.IDOWatchFaceParamModel
import com.idosmart.model.IDOWatchListModel
import com.idosmart.model.IDOWatchListV2Model
import com.idosmart.model.IDOWeatherDataParamModel
import com.idosmart.model.IDOWeatherSunTimeParamModel
import com.idosmart.model.IDOWeatherV3ParamModel
import com.idosmart.model.IDOWorldTimeParamModel
import com.idosmart.model.toJsonString
import com.idosmart.pigeongen.api_cmd.CancelToken
import com.idosmart.pigeongen.api_cmd.Cmd
import com.idosmart.pigeongen.api_evt_type.ApiEvtType
import com.idosmart.protocol_channel.plugin
import com.idosmart.protocol_sdk.CmdProtocol
import com.idosmart.protocol_sdk.IDOCancellable
import java.lang.reflect.Field
import java.lang.reflect.Type
import java.util.Date
import com.idosmart.model.IDODefaultMessageConfigModel
import com.idosmart.model.IDODefaultMessageConfigParamModel
import com.idosmart.model.IDOAlgFileModel
import com.idosmart.model.IDOAlgorithmRawDataParam
import com.idosmart.model.IDOAlgorithmSensorSwitch
import com.idosmart.model.IDOAppInfoModel
import com.idosmart.model.IDOBloodGlucoseCurrentInfo
import com.idosmart.model.IDOBloodGlucoseHistoryDataInfo
import com.idosmart.model.IDOBloodGlucoseModel
import com.idosmart.model.IDOBloodGlucoseStatisticsInfo
import com.idosmart.model.IDOLeftRightWearModel
import com.idosmart.model.IDORawDataSensorConfigReply
import com.idosmart.model.IDOSettingsDuringExerciseModel
import com.idosmart.model.IDOSimpleHeartRateZoneSettingModel
import com.idosmart.model.IDOSportScreenInfoReplyModel
import com.idosmart.model.IDOSportScreenParamModel
import com.idosmart.model.IDOSportScreenSportItemModel
import com.idosmart.model.IDOSportingRemindSettingModel
import com.idosmart.model.IDOSportingRemindSettingParamModel
import com.idosmart.model.IDOSportingRemindSettingReplyModel
import com.idosmart.pigeongen.api_cmd.Response
import com.idosmart.protocol_channel.innerRunOnMainThread
import com.idosmart.protocol_sdk.IDOCmdPriority
import com.idosmart.model.IDOMenuListV3Model
import com.idosmart.model.IDOMenuListV3ParamModel
import com.idosmart.model.IDOEmotionHealthReminderParamModel
import com.idosmart.model.IDOEmotionHealthReminderReplyModel
import com.idosmart.model.IDOAppListStyleParamModel
import com.idosmart.model.IDOAppListStyleReplyModel
import com.idosmart.model.IDOBikeLockInfo
import com.idosmart.model.IDOBikeLockModel
import com.idosmart.model.IDOBikeLockReplyModel
import com.idosmart.model.IDOGestureControlModel
import com.idosmart.model.IDOBloodGlucoseDataInfoV1
import com.idosmart.model.IDOBloodGlucoseGetInfo
import com.idosmart.model.IDOBloodGlucoseInfoReplyV1
import com.idosmart.model.IDOBloodGlucoseSendInfo
import com.idosmart.model.IDOBloodGlucoseV1Model

private fun cmd(): Cmd? {
    return plugin.cmd()
}

internal fun ApiEvtType.cancelToken(): CancelToken {
    return CancelToken("${this.raw}_${Date().time}")
}

internal class CmdCancellable : IDOCancellable {

    private var _isCancelled = false
    private var _token: String? = null

    override var isCancelled: Boolean
        get() = _isCancelled
        set(value) {
            _isCancelled = value
        }

    constructor(token: String? = null) {
        _token = token
    }

    override fun cancel() {
        isCancelled = true
        _token?.let {
            cmd()?.cancelSend(CancelToken(_token)) {}
        }
    }
}

class IDOCmdSetResponseModel(isSuccess: Int) : IDOBaseModel {

    var isSuccess: Int = isSuccess

    override fun toJsonString(): String {
        val gosn = GsonBuilder().setFieldNamingStrategy(CustomFieldNamingStrategy()).create()
        return gosn.toJson(this).toString()
    }

    override fun toString(): String {
        return "IDOCmdSetResponseModel(isSuccess=$isSuccess)"
    }

}

class CmdError {
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
    var code: Int
    var message: String?

    constructor(code: Int = -2, message: String? = null) {
        this.code = code
        this.message = message
    }
}

class CmdResponse<T> {
    var res: T?
    var error: CmdError

    constructor(res: T? = null, error: CmdError = CmdError()) {
        this.res = res
        this.error = error
    }

    val isOK: Boolean
        get() = error.code == 0 &&
                when (res) {
                    is IDOCmdSetResponseModel -> (res as IDOCmdSetResponseModel).isSuccess == 1
                    null -> true
                    else -> false
                }
}

interface CmdProtocolParam {
    val evtType: ApiEvtType
    val json: String?
}

open class Cmds {

    ///获取SN信息 返回 sn
    class getSn : CmdProtocol<String>, CmdProtocolParam {
        override fun send(completion: (CmdResponse<String>) -> Unit): IDOCancellable {
            return Cmds.parseJson(this) { code, dic ->
                if (code == 0) {
                    val sn = (dic?.get("sn") as String?) ?: ""
                    val error = CmdError(code, null)
                    completion(CmdResponse(sn, error))
                } else {
                    val error = CmdError(code, null)
                    completion(CmdResponse(null, error))
                }
            }
        }

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETSNINFO
        override val json: String?
            get() = "{}"
    }

    /// 获取bt蓝牙名称
    class getBtName : CmdProtocol<String>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.GETBTNAME
        override val json: String?
            get() = "{}"

        override fun send(completion: (CmdResponse<String>) -> Unit): IDOCancellable {
            return Cmds.parseJson(this) { code, dic ->
                if (code == 0) {
                    val sn = (dic?.get("bt_name") as String?) ?: ""
                    val error = CmdError(code, null)
                    completion(CmdResponse(sn, error))
                } else {
                    val error = CmdError(code, null)
                    completion(CmdResponse(null, error))
                }
            }
        }
    }

    /// 获取通知中心开关
    /// Get notification center status event number
    class getNoticeStatus : CmdProtocol<IDOSetNoticeStatusModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.GETNOTICESTATUS
        override val json: String?
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOSetNoticeStatusModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }




    // 控制音乐开始
    // Control music start
    class musicStart : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.MUSICSTART
        override val json: String?
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }
    /// 控制音乐停止
    /// Control music stop
    class musicStop : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.MUSICSTOP
        override val json: String?
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    //设置屏幕亮度
    class setScreenBrightness : CmdProtocol<IDOScreenBrightnessModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.SETSCREENBRIGHTNESS
        override val json: String

        constructor(param: IDOScreenBrightnessModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOScreenBrightnessModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }

    }

    //设置经期
    class setMenstruation : CmdProtocol<IDOMenstruationModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.SETMENSTRUATION
        override val json: String

        constructor(param: IDOMenstruationModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOMenstruationModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }

    }


    //卡路里和距离目标
    class setCalorieDistanceGoal : CmdProtocol<IDOMainSportGoalModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.SETCALORIEDISTANCEGOAL
        override val json: String

        constructor(param: IDOMainSportGoalModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOMainSportGoalModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }

    }

    // 设置运动模式识别开关
    // Set the sports mode recognition switch
    class setActivitySwitch : CmdProtocol<IDOActivitySwitchParamModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.SETACTIVITYSWITCH
        override val json: String

        constructor(param: IDOActivitySwitchParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOActivitySwitchParamModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /// 设置设备电量提醒开关
    /// Set battery reminder switch event number
    class setBatteryReminderSwitch : CmdProtocol<IDOBatteryReminderSwitchReplyModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.SETBATTERYREMINDERSWITCH
        override val json: String

        constructor(param: IDOBatteryReminderSwitchParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOBatteryReminderSwitchReplyModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /// 设置宠物信息
    /// Set pet info event number
    class setPetInfo : CmdProtocol<IDOPetInfoReplyModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.SETPETINFO
        override val json: String

        constructor(param: IDOPetInfoParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOPetInfoReplyModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    //设置闹钟
    class setAlarmV3 : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.SETALARMV3
        override val json: String

        constructor(param: IDOAlarmModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    //设置用户信息
    class setUserInfo : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.SETUSERINFO
        override val json: String

        constructor(param: IDOUserInfoPramModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    //设置左右手
    class setHand : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETHAND
        override val json: String

        constructor(open: Boolean) {
            val onOff = if (open) 1 else 0
            this.json = Gson().toJson(mapOf("hand" to onOff))
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    //获取左右手设置
    class getLeftRightWearSettings : CmdProtocol<IDOLeftRightWearModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETLEFTRIGHTWEARSETTINGS
        override val json: String

        constructor() {
            this.json = "{}"
        }

        override fun send(completion: (CmdResponse<IDOLeftRightWearModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    //设置心率区间
    class setHeartRateInterval : CmdProtocol<IDOHeartRateIntervalModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.SETHEARTRATEINTERVAL
        override val json: String

        constructor(param: IDOHeartRateIntervalModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOHeartRateIntervalModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    //进入升级模式
    class otaStart : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.OTASTART
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    class reboot : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.REBOOT
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    class shutdown : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.SHUTDOWN
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    class factoryReset : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.FACTORYRESET
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    class findDeviceStart : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.FINDDEVICESTART
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    class findDeviceStop : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.FINDDEVICESTOP
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /// 设置通知中心
    /// Set Notification Center Event
    class setNoticeStatus : CmdProtocol<IDONotificationCenterModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.SETNOTIFICATIONCENTER
        override val json: String?

        constructor(param: IDOSetNoticeStatusModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDONotificationCenterModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /// 获得实时数据
    /// Get Real-time Data event number
    class getLiveData : CmdProtocol<IDOLiveDataModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.GETLIVEDATA
        override val json: String?

        constructor(flag: Int) {
            val gson = Gson()
            this.json = gson.toJson(mapOf("flag" to flag))
        }

        override fun send(completion: (CmdResponse<IDOLiveDataModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 获取错误记录
    class getErrorRecord : CmdProtocol<IDOErrorRecordModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETERRORRECORD
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOErrorRecordModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 获取HID信息
    /// Get HID Information event number
    class getHidInfo : CmdProtocol<Boolean>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETHIDINFO
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<Boolean>) -> Unit): IDOCancellable {
            return Cmds.parseJson(this) { code, dic ->
                if (code == 0) {
                    val start = ((dic?.get("is_start") as Int?) ?: 0) == 1
                    val error = CmdError(code, null)
                    completion(CmdResponse(start, error))
                } else {
                    val error = CmdError(code, null)
                    completion(CmdResponse(null, error))
                }
            }
        }
    }


    /// 获取gps信息
    /// Get GPS Information event number
    class getGpsInfo : CmdProtocol<IDOGpsInfoModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETGPSINFO
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOGpsInfoModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 获取版本信息
    /// Get version information event number
    class getVersionInfo : CmdProtocol<IDOVersionInfoModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETVERSIONINFO
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOVersionInfoModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 获取mtu信息
    /// Get MTU Information event number
    class getMtuInfo : CmdProtocol<IDOMtuInfoModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETMTUINFO
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOMtuInfoModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 获取所有的健康监测开关
    /// Get event number for all health monitoring switches
    class getAllHealthSwitchState : CmdProtocol<IDOAllHealthSwitchStateModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETALLHEALTHSWITCHSTATE
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOAllHealthSwitchStateModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 获取gps状态
    /// Get GPS Status event number
    class getGpsStatus : CmdProtocol<IDOGpsStatusModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETGPSSTATUS
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOGpsStatusModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 获取固件不可删除的快捷应用列表
    /// Get non-deletable menu list in firmware event number
    class getUnerasableMeunList : CmdProtocol<IDOUnerasableMeunListModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETUNERASABLEMEUNLIST
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOUnerasableMeunListModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 运动模式自动识别开关获取
    /// Get event number for activity switch
    class getActivitySwitch : CmdProtocol<IDOActivitySwitchModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETACTIVITYSWITCH
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOActivitySwitchModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 获取红点提醒开关
    /// Get unread app reminder switch event number
    class getUnreadAppReminder : CmdProtocol<IDOCmdGetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETUNREADAPPREMINDER
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOCmdGetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 获取字库信息
    /// Get Font Library Information event number
    class getFlashBinInfo : CmdProtocol<IDOFlashBinInfoModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETFLASHBININFO
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOFlashBinInfoModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 查询bt配对开关、连接、a2dp连接、hfp连接状态(仅支持带bt蓝牙的设备)
    /// Query BT pairing switch, connection, A2DP connection, HFP connection status (Only Supported on devices with BT Bluetooth) event number
    class getBtNotice : CmdProtocol<IDOBtNoticeModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETBTNOTICE
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOBtNoticeModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 获取抬腕数据
    /// Get wrist up gesture data event number
    class getUpHandGesture : CmdProtocol<IDOUpHandGestureModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETUPHANDGESTURE
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOUpHandGestureModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 获取表盘id
    /// Get watch ID event number
    class getWatchDialId : CmdProtocol<IDOWatchDialIdModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETWATCHDIALID
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOWatchDialIdModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /// 获取勿扰模式状态
    /// Get Do Not Disturb mode status event number
    class getNotDisturbStatus : CmdProtocol<IDONotDisturbStatusModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETNOTDISTURBSTATUS
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDONotDisturbStatusModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 获取设置的卡路里/距离/中高运动时长 主界面
    /// Get Set Calorie/Distance/Mid-High Sport Time Goal event number
    class getMainSportGoal : CmdProtocol<IDOMainSportGoalModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETMAINSPORTGOAL
        override val json: String

        constructor(timeGoalType: Int) {
            val gson = Gson()
            this.json = gson.toJson(mapOf("time_goal_type" to timeGoalType))
        }

        override fun send(completion: (CmdResponse<IDOMainSportGoalModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 获取血压算法三级版本号信息事件号
    /// Get blood pressure algorithm version information event number
    class getBpAlgVersion : CmdProtocol<IDOBpAlgVersionModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETBPALGVERSION
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOBpAlgVersionModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 获取屏幕亮度
    /// Get screen brightness event number
    class getScreenBrightness : CmdProtocol<IDOScreenBrightnessModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETSCREENBRIGHTNESS
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOScreenBrightnessModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 获取热启动参数
    /// Get Hot Start Parameters event number
    class getHotStartParam : CmdProtocol<IDOHotStartParamModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETHOTSTARTPARAM
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOHotStartParamModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 获取固件支持的详情最大设置数量
    /// Get maximum number of settings supported by firmware event number
    class getSupportMaxSetItemsNum : CmdProtocol<IDOSupportMaxSetItemsNumModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETSUPPORTMAXSETITEMSNUM
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOSupportMaxSetItemsNumModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 获取走动提醒
    /// Get walk reminder event number
    class getWalkRemind : CmdProtocol<IDOWalkRemindModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETWALKREMIND
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOWalkRemindModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 获取全天步数目标
    /// Get daily step goal event number
    class getStepGoal : CmdProtocol<IDOStepGoalModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETSTEPGOAL
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOStepGoalModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 获取手表名字
    /// Get device name event number
    class getDeviceName : CmdProtocol<String>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETDEVICENAME
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<String>) -> Unit): IDOCancellable {
            return Cmds.parseJson(this) { code, dic ->
                if (code == 0) {
                    val name = (dic?.get("dev_name") as String?) ?: ""
                    val error = CmdError(code, null)
                    completion(CmdResponse(name, error))
                } else {
                    val error = CmdError(code, null)
                    completion(CmdResponse(null, error))
                }
            }
        }
    }


    /// 获取固件本地保存联系人文件修改时间
    /// Get firmware local contact file modification time event number
    class getContactReviseTime : CmdProtocol<IDOContactReviseTimeModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETCONTACTREVISETIME
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOContactReviseTimeModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 获取设备升级状态
    /// Get device update status event number
    class getUpdateStatus : CmdProtocol<IDOUpdateStatusModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETUPDATESTATUS
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOUpdateStatusModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 获取压力值
    /// Get stress value event number
    class getStressVal : CmdProtocol<IDOStressValModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETSTRESSVAL
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOStressValModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 获取心率监测模式
    /// Get Heart Rate Monitoring Mode event number
    class getHeartRateMode : CmdProtocol<IDOHeartRateModeModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETHEARTRATEMODE
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOHeartRateModeModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 获取电池信息
    /// Get battery information event number
    class getBatteryInfo : CmdProtocol<IDOBatteryInfoModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETBATTERYINFO
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOBatteryInfoModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /// 获取设备电量提醒开关
    /// Get battery reminder switch event number
    class getBatteryReminderSwitch : CmdProtocol<IDOBatteryReminderSwitchModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETBATTERYREMINDERSWITCH
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOBatteryReminderSwitchModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /// 获取宠物信息
    /// Get pet info event number
    class getPetInfo : CmdProtocol<IDOPetInfoModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETPETINFO
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOPetInfoModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 获取设备的日志状态
    /// Get device log state event number
    class getDeviceLogState : CmdProtocol<IDODeviceLogStateModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETDEVICELOGSTATE
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDODeviceLogStateModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 手机音量下发给ble
    /// Set phone volume for device event number
    class setBleVoice : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETBLEVOICE
        override val json: String

        constructor(param: IDOBleVoiceParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 设置控制gps
    /// Control GPS event number
    class setGpsControl : CmdProtocol<IDOGpsControlModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETGPSCONTROL
        override val json: String

        constructor(param: IDOGpsControlParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOGpsControlModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 智能心率模式设置
    /// Set Smart Heart Rate Mode Event
    class setHeartRateModeSmart : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETHEARTRATEMODESMART
        override val json: String

        constructor(param: IDOHeartRateModeSmartParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 设置压力校准
    /// Set Stress Calibration Event Code
    class setStressCalibration : CmdProtocol<IDOStressCalibrationModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETSTRESSCALIBRATION
        override val json: String

        constructor(param: IDOStressCalibrationParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOStressCalibrationModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 设置洗手提醒
    /// Set Hand Washing Reminder Event
    class setHandWashingReminder : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETHANDWASHINGREMINDER
        override val json: String

        constructor(param: IDOHandWashingReminderParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 设置运动目标
    /// Set exercise goal event
    class setSportGoal : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETSPORTGOAL
        override val json: String

        constructor(param: IDOSportGoalParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 设置天气数据
    /// Set weather data event number
    class setWeatherData : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETWEATHERDATA
        override val json: String

        constructor(param: IDOWeatherDataParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 未读信息红点提示开关
    /// Unread message reminder switch event number
    class setUnreadAppReminder : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETUNREADAPPREMINDER
        override val json: String

        constructor(open: Boolean) {
            val onOff = if (open) 1 else 0
            val gson = Gson()
            this.json = gson.toJson(mapOf("on_off" to onOff))
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /// 手机app通过这个命令开关，实现通知应用状态设置
    /// Notification app status setting event
    class setNotificationStatus : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETNOTIFICATIONSTATUS
        override val json: String

        constructor(param: IDONotificationStatusParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /// 设置科学睡眠开关
    /// Scientific sleep switch setting event
    class setScientificSleepSwitch : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETSCIENTIFICSLEEPSWITCH
        override val json: String

        constructor(param: IDOScientificSleepSwitchParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 血压校准
    /// Blood pressure calibration event number
    class setBpCalibration : CmdProtocol<IDOBpCalibrationModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETBPCALIBRATION
        override val json: String

        constructor(param: IDOBpCalibrationParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOBpCalibrationModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 设置防丢
    /// Set Lost Find Event
    class setLostFind : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETLOSTFIND
        override val json: String

        constructor(param: IDOLostFindParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 设置表盘
    /// Set watch face event number
    class setWatchDial : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETWATCHDIAL
        override val json: String

        constructor(param: IDOWatchDialParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 设置天气开关
    /// Set weather switch event number
    class setWeatherSwitch : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETWEATHERSWITCH
        override val json: String

        constructor(open: Boolean) {
            val onOff = if (open) 1 else 0
            val gson = Gson()
            this.json = gson.toJson(mapOf("on_off" to onOff))
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 设置单位
    /// Set Unit event number
    class setUnit : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETUNIT
        override val json: String

        constructor(param: IDOUnitParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 设置寻找手机
    /// Set Find Phone
    class setFindPhone : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETFINDPHONE
        override val json: String

        constructor(open: Boolean) {
            val onOff = if (open) 1 else 0
            val gson = Gson()
            this.json = gson.toJson(mapOf("on_off" to onOff))
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 获取下载语言支持
    /// Get Download Language Support
    class getDownloadLanguage : CmdProtocol<IDODownloadLanguageModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETDOWNLANGUAGE
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDODownloadLanguageModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 设置停止寻找手机
    /// Stop Find Phone
    class setOverFindPhone : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETOVERFINDPHONE
        override val json: String
            get() {
                val gson = Gson()
                return gson.toJson(mapOf("states" to 1))
            }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 获取设备支持的列表
    /// Get Supported Menu List
    class getMenuList : CmdProtocol<IDOMenuListModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETMENULIST
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOMenuListModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 设置一键呼叫
    /// Set the one-touch calling event number
    class setOnekeySOS : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETONEKEYSOS
        override val json: String

        constructor(open: Boolean, phoneType: Int) {
            val onOff = if (open) 1 else 0
            this.json = Gson().toJson(mapOf("on_off" to onOff, "phone_type" to phoneType))
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 设置运动模式选择
    /// Set sport mode select event number
    class setSportModeSelect : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETSPORTMODESELECT
        override val json: String

        constructor(param: IDOSportModeSelectParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 设置运动模式排序
    /// Set Sport Mode Sorting
    class setSportModeSort : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETSPORTMODESORT
        override val json: String

        constructor(items: List<IDOSportModeSortParamModel>) {
            val jsonList = items.map { it.toJsonString() }.toList()
            this.json = Gson().toJson(mapOf(items to jsonList))
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 设置久坐
    /// Set Long Sit Event
    class setLongSit : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETLONGSIT
        override val json: String

        constructor(param: IDOLongSitParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 智能心率模式设置
    /// Set Smart Heart Rate Mode Event
    class setHeartRateMode : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETHEARTRATEMODESMART
        override val json: String

        constructor(param: IDOHeartRateModeSmartParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 设置身体电量开关
    /// Set body power switch event number
    class setBodyPowerTurn : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETBODYPOWERTURN
        override val json: String

        constructor(open: Boolean) {
            val onOff = if (open) 1 else 0
            this.json = Gson().toJson(mapOf("on_off" to onOff))
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 设置呼吸率开关
    /// Respiration rate switch setting event
    class setRRespiRateTurn : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETRRESPIRATETURN
        override val json: String

        constructor(open: Boolean) {
            val onOff = if (open) 1 else 0
            this.json = Gson().toJson(mapOf("on_off" to onOff))
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 环境音量的开关和阀值
    /// Set Environmental Noise Volume On/Off and Threshold Event
    class setV3Noise : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETV3NOISE
        override val json: String

        constructor(param: IDOV3NoiseParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 设置日出日落时间
    /// Set sunrise and sunset time event number
    class setWeatherSunTime : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETWEATHERSUNTIME
        override val json: String

        constructor(param: IDOWeatherSunTimeParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 设置快捷方式
    /// Set shortcut
    class setShortcut : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETSHORTCUT
        override val json: String

        constructor(param: IDOShortcutParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }





    /// 设置夜间体温开关
    /// Set Night-time Temperature Switch Event Code
    class setTemperatureSwitch : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETTEMPERATURESWITCH
        override val json: String

        constructor(param: IDOTemperatureSwitchParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 设置睡眠时间段
    /// Set sleep period event
    class setSleepPeriod : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETSLEEPPERIOD
        override val json: String

        constructor(param: IDOSleepPeriodParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 设置抬手亮屏
    /// Raise-to-wake gesture event number
    class setUpHandGesture : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETUPHANDGESTURE
        override val json: String

        constructor(param: IDOUpHandGestureParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 设置吃药提醒
    /// Set Taking Medicine Reminder Event Code
    class setTakingMedicineReminder : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETTAKINGMEDICINEREMINDER
        override val json: String

        constructor(param: IDOTakingMedicineReminderParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 设置血氧开关
    /// Set SpO2 switch event
    class setSpo2Switch : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETSPO2SWITCH
        override val json: String

        constructor(param: IDOSpo2SwitchParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 设置天气城市名称
    /// Set weather city name event number
    class setWeatherCityName : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETWEATHERCITYNAME
        override val json: String

        constructor(cityName: String) {
            this.json = Gson().toJson(mapOf("version" to 0, "city_name" to cityName))
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// app获取ble的闹钟
    /// Getting Alarms for V3APP Devices
    class getAlarm(val priority: IDOCmdPriority = IDOCmdPriority.NORMAL) : CmdProtocol<IDOAlarmModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETALARMV3
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOAlarmModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion, priority)
        }
    }


    /// 获取用户习惯信息
    /// Get User Habit Information in V3
    class getHabitInfo : CmdProtocol<IDOHabitInfoModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETHABITINFOV3
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOHabitInfoModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 健身指导
    /// Fitness Guidance Event
    class setFitnessGuidance : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETFITNESSGUIDANCE
        override val json: String

        constructor(param: IDOFitnessGuidanceParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 显示模式
    /// Display mode event number
    class setDisplayMode : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETDISPLAYMODE
        override val json: String

        constructor(param: IDODisplayModeParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 血压测量
    /// Blood pressure measurement event number
    class setBpMeasurement : CmdProtocol<IDOBpMeasurementModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETBPMEASUREMENT
        override val json: String

        constructor(param: IDOBpMeasurementParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOBpMeasurementModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /**
     * 一键测量
     */
    private class setSingleMeasurement : CmdProtocol<IDOMeasurementModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETBPMEASUREMENT
        override val json: String

        constructor(type: IDOMeasurementType, action: IDOMeasurementAction) {
            val map = mapOf(type.jsonKey to action.raw)
            this.json = Gson().toJson(map)
        }

        override fun send(completion: (CmdResponse<IDOMeasurementModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 音乐开关
    /// Set Music On/Off Event
    class setMusicOnOff : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETMUSICONOFF
        override val json: String

        constructor(param: IDOMusicOnOffParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// app下发跑步计划(运动计划)
    /// App issued running plan (exercise plan) event number
    class setSendRunPlan : CmdProtocol<IDOSendRunPlanModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETSENDRUNPLAN
        override val json: String

        constructor(param: IDORunPlanParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOSendRunPlanModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// v3 下发v3天气协议
    /// Send the v3 weather protocol event number under v3
    class setWeatherV3 : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETWEATHERV3
        override val json: String

        constructor(param: IDOWeatherV3ParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 获取固件的歌曲名和文件夹
    /// Get Firmware Song Names and Folders
    class getBleMusicInfo : CmdProtocol<IDOMusicInfoModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETBLEMUSICINFO
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOMusicInfoModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 控制音乐
    /// Music control event number
    class musicControl : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.MUSICCONTROL
        override val json: String

        constructor(param: IDOMusicControlParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 操作歌曲或者文件夹
    /// Operation for songs or folders event
    class setMusicOperate : CmdProtocol<IDOMusicOperateModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETMUSICOPERATE
        override val json: String

        constructor(param: IDOMusicOpearteParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOMusicOperateModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 通知消息提醒
    /// Notification message reminder event number
    class noticeMessageV3 : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.NOTICEMESSAGEV3
        override val json: String

        constructor(param: IDONoticeMessageParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 设置消息通知状态
    /// Setting Notification Status for a Single App
    class setNoticeMessageState : CmdProtocol<IDONoticeMessageStateModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETNOTICEMESSAGESTATE
        override val json: String

        constructor(param: IDONoticeMessageStateParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDONoticeMessageStateModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 动态消息通知
    /// V3 dynamic notification message event number
    class setNoticeAppName : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETNOTICEAPPNAME
        override val json: String

        constructor(param: IDONoticeMesaageParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 下发v3世界时间
    /// v3 set v3 world time
    class setWorldTimeV3 : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETWORLDTIMEV3
        override val json: String

        constructor(param: List<IDOWorldTimeParamModel>) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /// 设置日程提醒
    /// Schedule Reminder
    class setSchedulerReminder : CmdProtocol<IDOSchedulerReminderModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETSCHEDULERREMINDERV3
        override val json: String

        constructor(param: IDOSchedulerReminderParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOSchedulerReminderModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /// 获取屏幕信息
    /// Get Screen Information
    class getWatchDialInfo : CmdProtocol<IDOWatchDialInfoModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETWATCHDIALINFO
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOWatchDialInfoModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 血压校准控制
    /// Blood Pressure Calibration Control
    class setBpCalControlV3 : CmdProtocol<IDOBpCalControlModel>, CmdProtocolParam {


        override val evtType: ApiEvtType
            get() = ApiEvtType.SETBPCALCONTROLV3
        override val json: String

        //            get() = "{}"
        constructor(param: IDOBpCalControlModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOBpCalControlModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 设置表盘
    /// Set Watch Face
    class setWatchFaceData : CmdProtocol<IDOWatchFaceModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETWATCHFACEDATA
        override val json: String

        constructor(param: IDOWatchFaceParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOWatchFaceModel>) -> Unit): IDOCancellable {

            return Cmds.parseModel(this, completion)
        }
    }


    /// 同步常用联系人
    /// Synchronization Protocol Bluetooth Call Common Contacts
    class setSyncContact : CmdProtocol<IDOSyncContactModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETSYNCCONTACT
        override val json: String

        constructor(param: IDOSyncContactParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOSyncContactModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 获取表盘列表 v3
    /// Getting watch face list for V3 (New)
    class getWatchListV3 : CmdProtocol<IDOWatchListModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETWATCHLISTV3
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOWatchListModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /// 获取表盘列表 v2
    /// Get Watch Face List in V2
    class getWatchListV2 : CmdProtocol<IDOWatchListV2Model>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETWATCHFACELIST
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOWatchListV2Model>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 设置运动子项数据排列
    /// Set and Query Sports Sub-item Data Sorting
    class setSportParamSort : CmdProtocol<IDOSportSortModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETBASESPORTPARAMSORTV3
        override val json: String

        constructor(param: IDOSportSortParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOSportSortModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 新的100种运动排序
    /// Set and Query 100 Sports Sorting
    class setSport100Sort : CmdProtocol<IDOSport100SortModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SET100SPORTSORTV3
        override val json: String

        constructor(param: IDOSport100SortParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOSport100SortModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 设置主界面控件排序
    /// Setting and Query Sorting of Main UI Controls
    class setMainUISortV3 : CmdProtocol<IDOMainUISortModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETMAINUISORTV3
        override val json: String

        constructor(param: IDOMainUISortParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOMainUISortModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 经期的历史数据下发
    /// Menstrual historical data delivery event number
    class setHistoricalMenstruation : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETHISTORICALMENSTRUATION
        override val json: String

        constructor(param: IDOHistoricalMenstruationParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 获取语言库列表
    /// Get Language Library List
    class getLanguageLibrary : CmdProtocol<IDOLanguageLibraryModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETLANGUAGELIBRARYDATAV3
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOLanguageLibraryModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 获取固件本地提示音文件信息
    /// Getting firmware local beep file information for V3
    class getBleBeep : CmdProtocol<IDOBleBeepModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETBLEBEEPV3
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOBleBeepModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 设置运动城市名称
    /// V3 Setting the Name of a Sports City event number
    class setLongCityNameV3 : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETLONGCITYNAMEV3
        override val json: String

        constructor(cityName: String) {
            this.json = Gson().toJson(mapOf("version" to 0, "name" to cityName))
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /// V3设置心率模式
    /// Set Heart Rate Mode V3
    class setHeartMode : CmdProtocol<IDOHeartModeModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETHEARTMODE
        override val json: String

        constructor(param: IDOHeartModeParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOHeartModeModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /// 语音回复文本
    /// V3 voice reply text event number
    class setVoiceReplyText : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETVOICEREPLYTXTV3
        override val json: String

        constructor(param: IDOVoiceReplyParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 设置表盘顺序
    /// Set watch dial sort event
    class setWatchDialSort : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETWATCHDIALSORT
        override val json: String

        constructor(param: IDOWatchDialSortParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /// 设置多个走动提醒的时间点
    /// Set multiple walk reminder times event number
    class setWalkRemindTimes : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETWALKREMINDTIMES
        override val json: String

        constructor(param: IDOWalkRemindTimesParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /// 设置走动提醒
    /// Set multiple walk reminder
    class setWalkReminder : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETWALKREMIND
        override val json: String

        constructor(param: IDOWalkRemindModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /// 设置照片表盘
    /// Set wallpaper dial list event number
    class setWallpaperDialReply : CmdProtocol<IDOWallpaperDialReplyV3Model>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETWALLPAPERDIALREPLYV3
        override val json: String

        constructor(param: IDOWallpaperDialReplyV3ParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOWallpaperDialReplyV3Model>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    /// 设置时间, 不指定参数将使用当前时间
    /// Set the time. If no reference is specified, the current time will be used.
    class setDateTime : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETTIME
        override val json: String

        constructor(param: IDODateTimeParamModel? = null) {
            this.json = param?.toJsonString() ?: "{}"
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /// 获取BT连接手机型号
    /// Get BT connected mobile phone model
    class getBtConnectPhoneModel : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.GETBTCONNECTPHONEMODEL
        override val json: String?
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }




    //获取默认的运动类型
    class getDefaultSportType : CmdProtocol<IDODefaultSportTypeModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.GETDEFAULTSPORTTYPE
        override val json: String?
            get() = "{}"

        override fun send(completion: (CmdResponse<IDODefaultSportTypeModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    //设置喝水提醒
    class setDrinkWaterRemind : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.SETDRINKWATERREMIND
        override val json: String

        constructor(parm: IDODrinkWaterRemindModel) {
            this.json = parm.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }


    }

    //设置经期提醒
    class setMenstruationRemind : CmdProtocol<IDOMenstruationRemindParamModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.SETMENSTRUATIONREMIND
        override val json: String

        constructor(parm: IDOMenstruationRemindParamModel) {
            this.json = parm.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOMenstruationRemindParamModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    //设置压力开关
    class setStressSwitch : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.SETSTRESSSWITCH
        override val json: String

        constructor(parm: IDOStressSwitchParamModel) {
            this.json = parm.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    //设置语音助手开关
    class setVoiceAssistantOnOff : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.SETVOICEASSISTANTONOFF
        override val json: String

        constructor(open: Boolean) {
            val onOff = if (open) 1 else 0
            this.json = Gson().toJson(mapOf("on_off" to onOff))
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    //设置勿扰模式
    class setNotDisturb : CmdProtocol<IDONotDisturbParamModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.SETNOTDISTURB
        override val json: String

        constructor(parm: IDONotDisturbParamModel) {
            this.json = parm.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDONotDisturbParamModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    //设置菜单列表
    class setMenuList : CmdProtocol<IDOMenuListParamModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.SETMENULIST
        override val json: String

        constructor(parm: IDOMenuListParamModel) {
            this.json = parm.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOMenuListParamModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    //设置运动类型排序
    class setSportSortV3 : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.SETSPORTSORTV3
        override val json: String

        constructor(parm: IDOSportParamModel) {
            this.json = parm.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }


    //设置固件来电快捷回复开关
    class setCallQuickReplyOnOff : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.SETCALLQUICKREPLYONOFF
        override val json: String

        constructor(open: Boolean) {
            val onOff = if (open) 1 else 0
            this.json = Gson().toJson(mapOf("on_off" to onOff))
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    //获取运动默认的类型 V3
    class getSportTypeV3 : CmdProtocol<IDODefaultSportTypeModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.GETSPORTTYPEV3
        override val json: String?
            get() = "{}"
        override fun send(completion: (CmdResponse<IDODefaultSportTypeModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    // APP下发配对结果
    class sendBindResult : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.SENDBINDRESULT
        override val json: String

        constructor(isSuccess: Boolean) {
            val onOff = if (isSuccess) 0 else 1
            this.json = Gson().toJson(mapOf("bind_result" to onOff))
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }
    /// 开始拍照 (app -> ble)
    /// Start taking photos (app -> ble)
    class photoStart: CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.PHOTOSTART
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /// 结束拍照 (app -> ble)
    /// End photo taking (app -> ble)
    class photoStop: CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.PHOTOSTOP
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /// 快速短信回复
    /// Quick SMS Reply
    class setFastMsgUpdate : CmdProtocol<IDOFastMsgUpdateModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETFASTMSGUPDATE
        override val json: String

        constructor(parm: IDOFastMsgUpdateParamModel) {
            this.json = parm.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOFastMsgUpdateModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    //获取小程序信息（获取、启动、删除）
    class setAppletControl:CmdProtocol<IDOAppletInfoModel>,CmdProtocolParam{
        override val evtType: ApiEvtType
            get() = ApiEvtType.SETAPPLETCONTROL
        override val json: String
        constructor(parm: IDOAppletControlModel) {
            this.json = parm.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOAppletInfoModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }

    }


    /// app设置默认快速消息回复列表
    class setDefaultQuickMsgReplyList : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETFASTMSGV3
        override val json: String

        constructor(parm: IDOFastMsgSettingModel) {
            this.json = parm.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /// 获取单位
    /// Get Unit event number
    class getUnit: CmdProtocol<IDOUnitModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETUNIT
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOUnitModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /// 设置热启动参数
    /// Set hot boot parameters
    class setHotStartParam: CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETHOTSTARTPARAM
        override val json: String

        constructor(parm: IDOGpsHotStartParamModel) {
            this.json = parm.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /// 获取SPP mtu长度
    /// Get the mtu length of the SPP
    class getMtuLengthSPP: CmdProtocol<IDOSppMtuModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETMTULENGTHSPP
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOSppMtuModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /**
     * 获取智能心率模式
     * Get Smart Heart Rate Mode
     */
    class getSmartHeartRateMode: CmdProtocol<IDOHeartRateModeSmartModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETHEARTRATEMODESMART
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOHeartRateModeSmartModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /**
     * 获取血氧开关
     * Get blood oxygen switch
     */
    class getSpo2Switch: CmdProtocol<IDOSpo2SwitchModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETSPO2SWITCH
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOSpo2SwitchModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /**
     * 获取压力开关
     * Get the pressure switch
     */
    class getStressSwitch: CmdProtocol<IDOStressSwitchModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETSTRESSSWITCH
        override val json: String
            get() = "{}"

        override fun send(completion: (CmdResponse<IDOStressSwitchModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /**
     * 设置默认的消息应用列表
     * Set the default messaging app list
     */
    class setDefaultMsgList: CmdProtocol<IDODefaultMessageConfigModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.SETDEFAULTMSGLIST
        override val json: String
        constructor(parm: IDODefaultMessageConfigParamModel) {
            this.json = parm.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDODefaultMessageConfigModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /**
     * 获取固件算法文件信息（ACC/GPS）
     * Get firmware algorithm file information (ACC/GPS)
     */
    class getAlgFileInfo: CmdProtocol<IDOAlgFileModel>, CmdProtocolParam {

        override val evtType: ApiEvtType
            get() = ApiEvtType.GETALGFILE
        override val json: String
            get() = "{\"operate\":1,\"type\":0,\"version\":0}"

        override fun send(completion: (CmdResponse<IDOAlgFileModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    // 请求固件算法文件信息（ACC/GPS）
    // Request firmware algorithm file information (ACC/GPS)
    class rquestAlgFile: CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {
        // 1:ACC文件、2:GPS文件
        override val evtType: ApiEvtType
            get() = ApiEvtType.GETALGFILE
        override val json: String
        constructor(type: Int) {
            this.json = "{\"type\":${type},\"operate\":2,\"version\":0}"
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    // 内部使用
    private class innerGetSportScreenDetailInfo : CmdProtocol<IDOSportScreenInfoReplyModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.SETSPORTSCREEN
        override val json: String

        constructor(parm: List<IDOSportScreenSportItemModel>, operate: Int) {
            this.json = IDOSportScreenParamModel(operate, parm).toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOSportScreenInfoReplyModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }
    // 获取运动中屏幕显示详情信息
    class getSportScreenDetailInfo : CmdProtocol<IDOSportScreenInfoReplyModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.SETSPORTSCREEN
        override var json: String = "{}"

        private var param: List<IDOSportScreenSportItemModel>
        constructor(parm: List<IDOSportScreenSportItemModel>) {
            this.param = parm
        }

        override fun send(completion: (CmdResponse<IDOSportScreenInfoReplyModel>) -> Unit): IDOCancellable {
            val canceller = InnerCmdCanceller(false)
            val cancellerOpt2 = innerGetSportScreenDetailInfo(param, 2).send { itOpt2 ->
                if (itOpt2.error.code == 0 && itOpt2.res != null) {
                    val cancellerOpt3 = innerGetSportScreenDetailInfo(param, 3).send { itOpt3 ->
                        if (itOpt3.error.code == 0 && itOpt3.res != null) {
                            val itOpt2SportItems = itOpt2.res!!.sportItems
                            val itOpt3SportItems = itOpt3.res!!.sportItems
                            try {
                                if (!itOpt2SportItems.isNullOrEmpty() && !itOpt3SportItems.isNullOrEmpty() && itOpt3SportItems.size == itOpt2SportItems.size) {
                                    itOpt3.res!!.sportItems = itOpt3SportItems.map { it3 ->
                                        it3.supportDataTypes =
                                            itOpt2SportItems.find { it2 -> it2.sportType == it3.sportType }?.supportDataTypes ?: mutableListOf()
                                        it3.supportDataTypeNum = it3.supportDataTypes?.size ?: 0
                                        it3
                                    }
                                    itOpt3.res!!.specialDataItems = itOpt2.res!!.specialDataItems
                                    itOpt3.res!!.specialDataItemCount=itOpt2.res!!.specialDataItemCount
                                }
                            } catch (_: Exception) {
                            }
//                            itOpt2.res!!.sportNum = itOpt3.res!!.sportNum
//                            itOpt2.res!!.sportItems = itOpt3.res!!.sportItems
                            completion(CmdResponse(itOpt3.res, CmdError(0, "success")))
                        } else {
                            completion(CmdResponse(null, CmdError()))
                        }
                    }
                    canceller.cancellers.add(cancellerOpt3)
                }else {
                    completion(CmdResponse(null, CmdError()))
                }
            }
            canceller.cancellers.add(cancellerOpt2)
            return canceller
        }
    }

    // 获取运动中屏幕显示基础信息
    class getSportScreenBaseInfo : CmdProtocol<IDOSportScreenInfoReplyModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.SETSPORTSCREEN
        override val json: String

        constructor() {
            this.json = IDOSportScreenParamModel(1, null).toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOSportScreenInfoReplyModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    // 设置运动中屏幕显示
    class setSportScreen : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.SETSPORTSCREEN
        override val json: String

        constructor(parm: List<IDOSportScreenSportItemModel>) {
            this.json = IDOSportScreenParamModel(4, parm).toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    // 设置APP基本信息
    class setAppBaseInfo:CmdProtocol<IDOCmdSetResponseModel>,CmdProtocolParam{
        override val evtType: ApiEvtType
            get() = ApiEvtType.SETAPPBASEINFO
        override val json: String
        constructor(parm: IDOAppInfoModel) {
            this.json = parm.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }

    }

    //获取运动中通知提醒设置
    class getSettingsDuringExercise : CmdProtocol<IDOSettingsDuringExerciseModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.GETSETTINGSDURINGEXERCISE
        override val json: String

        constructor() {
            this.json = "{}"
        }

        override fun send(completion: (CmdResponse<IDOSettingsDuringExerciseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    //运动中通知提醒设置
    class setDuringExercise : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.SETDURINGEXERCISE
        override val json: String
        constructor(parm: IDOSettingsDuringExerciseModel) {
            this.json = parm.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    //获取简单心率区间设置
    class getSimpleHeartRateZone : CmdProtocol<IDOSimpleHeartRateZoneSettingModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.GETSIMPLEHEARTRATEZONE
        override val json: String

        constructor() {
            this.json = "{}"
        }

        override fun send(completion: (CmdResponse<IDOSimpleHeartRateZoneSettingModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    //简单心率区间设置
    class setSimpleHeartRateZone : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.SETSIMPLEHEARTRATEZONE
        override val json: String
        constructor(parm: IDOSimpleHeartRateZoneSettingModel) {
            this.json = parm.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    // 查询运动中提醒项
    class getSportingRemindSetting : CmdProtocol<IDOSportingRemindSettingReplyModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.SETSPORTINGREMINDSETTING

        override val json: String

        constructor(param: List<Int>) {
            this.json =
                IDOSportingRemindSettingParamModel(operate = IDOSportingRemindSettingParamModel.QUERY, sportTypes = param).toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOSportingRemindSettingReplyModel>) -> Unit): IDOCancellable {
            return parseModel(this, completion)
        }

    }

    // 设置运动中提醒项
    class setSportingRemindSetting : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.SETSPORTINGREMINDSETTING

        constructor(param: List<IDOSportingRemindSettingModel>) {
            this.json =
                IDOSportingRemindSettingParamModel(operate = IDOSportingRemindSettingParamModel.SET, settingItems = param).toJsonString()
        }

        override val json: String
        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return parseModel(this, completion)
        }

    }

    // 获取用户信息
    class getUserInfo : CmdProtocol<IDOUserInfoPramModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.GETUSERINFO

        override val json: String

        constructor() {
            this.json = "{}"
        }

        override fun send(completion: (CmdResponse<IDOUserInfoPramModel>) -> Unit): IDOCancellable {
            return parseModel(this, completion)
        }

    }

    /// 更新当前血糖数据
    class uploadBloodGlucoseCurrentData: CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.UPLOADBLOODGLUCOSE

        constructor(item: IDOBloodGlucoseCurrentInfo) {
            // operate - 1:当前血糖数据 2:血糖统计数据 3:血糖CGM历史数据
            this.json = IDOBloodGlucoseModel(1,  item, null, null).toJsonString()
        }

        override val json: String
        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return parseModel(this, completion)
        }
    }

    /// 更新血糖统计数据
    class uploadBloodGlucoseStatisticsData: CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.UPLOADBLOODGLUCOSE

        constructor(item: IDOBloodGlucoseStatisticsInfo) {
            // operate - 1:当前血糖数据 2:血糖统计数据 3:血糖CGM历史数据
            this.json =
                IDOBloodGlucoseModel(2,  null, item, null).toJsonString()
        }

        override val json: String
        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return parseModel(this, completion)
        }
    }

    /// 更新血糖CGM历史数据
    class uploadBloodGlucoseHistoryData: CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.UPLOADBLOODGLUCOSE

        constructor(item: IDOBloodGlucoseHistoryDataInfo) {
            // operate - 1:当前血糖数据 2:血糖统计数据 3:血糖CGM历史数据
            this.json =
                IDOBloodGlucoseModel(3,  null, null, item).toJsonString()
        }

        override val json: String
        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return parseModel(this, completion)
        }
    }

    /**
     * 开始算法原始数据采集
     */
    class startAlgorithmRawDataDAQ : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.ALGORITHMRAWDATA

        // 使用构造函数初始化 json 属性
        override val json: String

        init {
            // operate - 0x00为无效,0x01为开始采集,0x02为数据采集中,0x03为结束采集,0x04为设置开关,0x05为查询开关
            this.json = IDOAlgorithmRawDataParam(operate = 1, ppgSwitch = -1, accSwitch = -1).toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            // 假设 Cmds._parseModel 转换为 Kotlin 中的 parseModel 顶层函数或单例方法
            return Cmds.parseModel(this, completion)
        }
    }

    /**
     * 结束算法原始数据采集
     */
    class stopAlgorithmRawDataDAQ : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.ALGORITHMRAWDATA

        override val json: String

        init {
            // operate - 0x00为无效,0x01为开始采集,0x02为数据采集中,0x03为结束采集,0x04为设置开关,0x05为查询开关
            this.json = IDOAlgorithmRawDataParam(operate = 3, ppgSwitch = -1, accSwitch = -1).toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /**
     * 设置算法原始数据采集配置
     */
    class setAlgorithmRawDataSensorConfig : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.ALGORITHMRAWDATA

        override val json: String

        // 主构造函数接收参数
        constructor(ppg: IDOAlgorithmSensorSwitch, acc: IDOAlgorithmSensorSwitch) {
            // operate - 0x00为无效,0x01为开始采集,0x02为数据采集中,0x03为结束采集,0x04为设置开关,0x05为查询开关
            this.json = IDOAlgorithmRawDataParam(operate = 4, ppgSwitch = ppg.rawValue, accSwitch = acc.rawValue).toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /**
     * 查询算法原始数据采集配置
     */
    class getAlgorithmRawDataSensorConfig : CmdProtocol<IDORawDataSensorConfigReply>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.ALGORITHMRAWDATA

        override val json: String

        init {
            // operate - 0x00为无效,0x01为开始采集,0x02为数据采集中,0x03为结束采集,0x04为设置开关,0x05为查询开关
            this.json = IDOAlgorithmRawDataParam(operate = 5, ppgSwitch = -1, accSwitch = -1).toJsonString()!!
        }

        override fun send(completion: (CmdResponse<IDORawDataSensorConfigReply>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /**
     * 查询v3菜单列表
     * Get V3 menu list
     */
    class getMenuListV3 : CmdProtocol<IDOMenuListV3Model>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.SETV3MENULIST

        override val json: String

        init {
            this.json = IDOMenuListV3ParamModel(operate = 2).toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOMenuListV3Model>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /**
     * 设置v3菜单列表
     * Set V3 menu list
     */
    class setMenuListV3 : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.SETV3MENULIST

        override val json: String

        constructor(items: List<Int>) {
            this.json = IDOMenuListV3ParamModel(operate = 1, itemList = items).toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /**
     * 情绪健康提醒（设置/查询）
     * Emotion Health Reminder (Set/Query)
     */
    class emotionHealthReminder : CmdProtocol<IDOEmotionHealthReminderReplyModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.SETEMOTIONHEALTHREMINDER

        override val json: String

        constructor(param: IDOEmotionHealthReminderParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOEmotionHealthReminderReplyModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /**
     * 应用列表样式（设置/查询/删除）
     * Application list style (Set/Query/Delete)
     */
    class appListStyle : CmdProtocol<IDOAppListStyleReplyModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.SETAPPLICATIONLISTSTYLE

        override val json: String

        constructor(param: IDOAppListStyleParamModel) {
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOAppListStyleReplyModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    companion object {

        private fun jsonToMap(jsonString: String): Map<String, Any> {
            val gson = Gson()
            val type: Type = object : TypeToken<Map<String, Any>>() {}.type
            return gson.fromJson(jsonString, type)
        }

        private fun parseJson(
            param: CmdProtocolParam,
            priority: IDOCmdPriority = IDOCmdPriority.NORMAL,
            completion: (Int, Map<String, Any>?) -> Unit,
        ): IDOCancellable {
            val cancelToken = param.evtType.cancelToken()
            sendOnMainThread(param.evtType.raw, param.json, cancelToken, priority) {
                if (it.code?.toInt() == 0) {
                    val jsonStr = it.json
                    if (jsonStr != null) {
                        val map = jsonToMap(jsonStr)
                        completion(0, map)
                    } else {
                        completion(0, null)
                    }
                } else {
                    completion(it.code?.toInt() ?: -1, null)
                }
            }
            return CmdCancellable(cancelToken.token)
        }

        private inline fun <reified T : IDOBaseModel> parseModel(
            param: CmdProtocolParam,
            crossinline completion: (CmdResponse<T>) -> Unit,
            priority: IDOCmdPriority = IDOCmdPriority.NORMAL
        ): IDOCancellable {
            val cancelToken = param.evtType.cancelToken()
            //   Log.e("Cmds","参数：${param.json}")
            sendOnMainThread(param.evtType.raw, param.json, cancelToken, priority) {
                if (it.code?.toInt() == 0) {
                    val jsonStr = it.json
                    //Log.i("Cmds", "jsonSr = $jsonStr")
                    if (jsonStr != null) {
                        if (T::class.java == IDOCmdSetResponseModel::class.java) {
                            val map = jsonToMap(jsonStr)
                            val array = arrayOf(
                                "is_success",
                                "status_code",
                                "code",
                                "ret_code",
                                "err_code",
                                "error_code",
                                "status",
                                "state"
                            )
                            var value: Any? = null
                            for (key in array) {
                                if (map.get(key) != null) {
                                    value = map.get(key)
                                    break
                                }
                            }
                            if (value != null) {
                                if (value is Long) {
                                    val obj = IDOCmdSetResponseModel(value.toInt())
                                    completion(CmdResponse(obj as T, CmdError(0, "success")))
                                } else if (value is Double) {
                                    val obj = IDOCmdSetResponseModel(value.toInt())
                                    completion(CmdResponse(obj as T, CmdError(0, "success")))
                                } else if (value is Int) {
                                    val obj = IDOCmdSetResponseModel(value)
                                    completion(CmdResponse(obj as T, CmdError(0, "success")))
                                } else {
                                    val obj = IDOCmdSetResponseModel(0)
                                    completion(CmdResponse(obj as T, CmdError(0, "success")))
                                }
                            } else {
                                //val obj = IDOCmdSetResponseModel(1)
                                completion(CmdResponse(null, CmdError(0, "success")))
                            }
                        } else {
                            try {

                                var gson = GsonBuilder()
                                    .setFieldNamingStrategy(CamelCaseStrategy())
                                    .create()
                                var obj = gson.fromJson(jsonStr, T::class.java)
                                if (obj is IDOBaseAdapterModel<*>) {
                                    val gsonBuilder = GsonBuilder()
                                    obj.getDeSerializer()?.let { deSerializer ->
                                        gsonBuilder.registerTypeAdapter(T::class.java, deSerializer)
                                    }
                                    obj.getFieldNamingStrategy()?.let { strategy ->
                                        gsonBuilder.setFieldNamingStrategy(strategy)
                                    }
                                    gson = gsonBuilder.create()
                                    obj = gson.fromJson(jsonStr, T::class.java)
                                }else{
                                    var gson = GsonBuilder().create()
                                     obj = gson.fromJson(jsonStr, T::class.java)
                                }
                                completion(CmdResponse(obj, CmdError(0, "success")))
                            } catch (e: Exception) {
                                completion(
                                    CmdResponse(
                                        null,
                                        CmdError(-99, "json parse failed, check json format")
                                    )
                                )
                            }
                        }
                    } else {
                        completion(
                            CmdResponse(
                                null,
                                CmdError(0, "send success, return json string is null")
                            )
                        )
                    }
                } else {
                    completion(CmdResponse(null, CmdError(it.code?.toInt() ?: -2, "code is null")))
                }
            }
            return CmdCancellable(cancelToken.token)
        }

    }
    // -------------- 车锁管理 --------------

    /// 获取车锁列表
    class getBikeLockList : CmdProtocol<IDOBikeLockReplyModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.BIKELOCK
        override val json: String?

        constructor() {
            // 操作类型 1:设置 2:查询
            val param = IDOBikeLockModel(operate = 2)
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOBikeLockReplyModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /// 设置车锁列表
    class setBikeLockList : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.BIKELOCK
        override val json: String?

        constructor(items: List<IDOBikeLockInfo>) {
            // 操作类型 1:设置 2:查询
            val param = IDOBikeLockModel(operate = 1, items = items)
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    // ----------- 手势控制 (15.82) ------------

    /// 设置手势控制
    class setGestureControl : CmdProtocol<IDOCmdSetResponseModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.SETGESTURECONTROL
        override val json: String?

        constructor(model: IDOGestureControlModel) {
            model.operate = 1
            this.json = model.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOCmdSetResponseModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /// 获取手势控制
    class getGestureControl : CmdProtocol<IDOGestureControlModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.SETGESTURECONTROL
        override val json: String?

        constructor() {
            val param = IDOGestureControlModel(operate = 2)
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOGestureControlModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /// 获取手势控制支持配置项
    class getGestureControlSupportConfigs : CmdProtocol<IDOGestureControlModel>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.SETGESTURECONTROL
        override val json: String?

        constructor() {
            val param = IDOGestureControlModel(operate = 3)
            this.json = param.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOGestureControlModel>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    // -------------- 三诺app下发和获取V3血糖数据 --------------

    /// 设置血糖数据 (v01)
    class setBloodGlucoseDataV01 : CmdProtocol<IDOBloodGlucoseInfoReplyV1>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.UPLOADBLOODGLUCOSE
        override val json: String?

        constructor(param: IDOBloodGlucoseSendInfo) {
            // operate - 1:发送 2:获取 3:设备结束监测
            val model = IDOBloodGlucoseV1Model(operate = 1, sendInfo = param)
            this.json = model.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOBloodGlucoseInfoReplyV1>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /// 获取血糖数据（v01）
    class getBloodGlucoseDataV01 : CmdProtocol<IDOBloodGlucoseInfoReplyV1>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.UPLOADBLOODGLUCOSE
        override val json: String?

        constructor(localSerialNumber: Int) {
            // operate - 1:发送 2:获取 3:设备结束监测
            val getInfo = IDOBloodGlucoseGetInfo(localSerialNumber = localSerialNumber)
            val model = IDOBloodGlucoseV1Model(operate = 2, getInfo = getInfo)
            this.json = model.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOBloodGlucoseInfoReplyV1>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }

    /// 停止血糖监测（v01）
    class stopBloodGlucoseDataV01 : CmdProtocol<IDOBloodGlucoseInfoReplyV1>, CmdProtocolParam {
        override val evtType: ApiEvtType
            get() = ApiEvtType.UPLOADBLOODGLUCOSE
        override val json: String?

        constructor() {
            // operate - 1:发送 2:获取 3:设备结束监测
            val model = IDOBloodGlucoseV1Model(operate = 3)
            this.json = model.toJsonString()
        }

        override fun send(completion: (CmdResponse<IDOBloodGlucoseInfoReplyV1>) -> Unit): IDOCancellable {
            return Cmds.parseModel(this, completion)
        }
    }
}

private class CamelCaseStrategy : FieldNamingStrategy {
    override fun translateName(field: Field): String {
        //将驼峰转换为下划线，与json字符串匹配
        return FieldNamingPolicy.LOWER_CASE_WITH_UNDERSCORES.translateName(field)
    }
}

class AnyCmd<T>(private val fetchable: CmdProtocol<T>) : CmdProtocol<T> {
    override fun send(completion: (CmdResponse<T>) -> Unit): IDOCancellable {
        return fetchable.send(completion)
    }
}

// Cmd 类的扩展函数
private fun sendOnMainThread(evtTypeArg: Long, jsonArg: String?, cancelTokenArg: CancelToken?,
                             priority: IDOCmdPriority = IDOCmdPriority.NORMAL, callback: (Response) -> Unit) {
    innerRunOnMainThread {
        //println("isMainThread: ${Looper.myLooper() == Looper.getMainLooper()}")
        cmd()?.send(evtTypeArg, jsonArg, cancelTokenArg, priority.value.toLong() ,callback)
    }
}

/// 内部用于多组取消
internal class InnerCmdCanceller(override var isCancelled: Boolean) : IDOCancellable {
    var cancellers: MutableList<IDOCancellable> = mutableListOf()
    override fun cancel() {
        cancellers.forEach { canceller ->
            canceller.cancel()
        }
    }
}