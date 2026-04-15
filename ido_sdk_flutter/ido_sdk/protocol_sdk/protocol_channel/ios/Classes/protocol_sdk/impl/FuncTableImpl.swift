//
//  FuncTableImpl.swift
//  protocol_channel
//
//  Created by hc on 2023/7/24.
//

import Foundation

private var _delegate: FuncTableDelegateImpl {
    return FuncTableDelegateImpl.shared
}

class FuncTableImpl: IDOFuncTableInterface {
    
    // 优先映射该类属性，由构造方法传入，可选
    var funcTableInfo: FunctionTableModel?
    
    private var ft: FunctionTableModel? {
        return funcTableInfo ?? _delegate.funcTableInfo
    }
    
    init(funcTableInfo: FunctionTableModel? = nil) {
        self.funcTableInfo = funcTableInfo
    }
    
    func printProperties() -> String? {
        guard let obj = ft else { return nil }
        return obj.toJsonString()
    }
    var reminderAncs: Bool {
        return ft?.reminderAncs ?? false
    }

    var reminderSnapchat: Bool {
        return ft?.reminderSnapchat ?? false
    }

    var reminderLine: Bool {
        return ft?.reminderLine ?? false
    }

    var reminderOutlook: Bool {
        return ft?.reminderOutlook ?? false
    }

    var reminderTelegram: Bool {
        return ft?.reminderTelegram ?? false
    }

    var reminderViber: Bool {
        return ft?.reminderViber ?? false
    }

    var reminderVkontakte: Bool {
        return ft?.reminderVkontakte ?? false
    }

    var reminderChatwork: Bool {
        return ft?.reminderChatwork ?? false
    }

    var reminderSlack: Bool {
        return ft?.reminderSlack ?? false
    }

    var reminderTumblr: Bool {
        return ft?.reminderTumblr ?? false
    }

    var reminderYahooMail: Bool {
        return ft?.reminderYahooMail ?? false
    }

    var reminderYahooPinterest: Bool {
        return ft?.reminderYahooPinterest ?? false
    }

    var reminderYoutube: Bool {
        return ft?.reminderYoutube ?? false
    }

    var reminderGmail: Bool {
        return ft?.reminderGmail ?? false
    }

    var reminderKakaoTalk: Bool {
        return ft?.reminderKakaoTalk ?? false
    }

    var reminderOnlyGoogleGmail: Bool {
        return ft?.reminderOnlyGoogleGmail ?? false
    }

    var reminderOnlyOutlookEmail: Bool {
        return ft?.reminderOnlyOutlookEmail ?? false
    }

    var reminderOnlyYahooEmail: Bool {
        return ft?.reminderOnlyYahooEmail ?? false
    }

    var reminderTiktok: Bool {
        return ft?.reminderTiktok ?? false
    }

    var reminderRedbus: Bool {
        return ft?.reminderRedbus ?? false
    }

    var reminderDailyhunt: Bool {
        return ft?.reminderDailyhunt ?? false
    }

    var reminderHotstar: Bool {
        return ft?.reminderHotstar ?? false
    }

    var reminderInshorts: Bool {
        return ft?.reminderInshorts ?? false
    }

    var reminderPaytm: Bool {
        return ft?.reminderPaytm ?? false
    }

    var reminderAmazon: Bool {
        return ft?.reminderAmazon ?? false
    }

    var reminderFlipkart: Bool {
        return ft?.reminderFlipkart ?? false
    }

    var reminderNhnEmail: Bool {
        return ft?.reminderNhnEmail ?? false
    }

    var reminderInstantEmail: Bool {
        return ft?.reminderInstantEmail ?? false
    }

    var reminderZohoEmail: Bool {
        return ft?.reminderZohoEmail ?? false
    }

    var reminderExchangeEmail: Bool {
        return ft?.reminderExchangeEmail ?? false
    }

    var reminder189Email: Bool {
        return ft?.reminder189Email ?? false
    }

    var reminderVeryFit: Bool {
        return ft?.reminderVeryFit ?? false
    }

    var reminderGeneral: Bool {
        return ft?.reminderGeneral ?? false
    }

    var reminderOther: Bool {
        return ft?.reminderOther ?? false
    }

    var reminderMattersRemind: Bool {
        return ft?.reminderMattersRemind ?? false
    }

    var reminderMicrosoft: Bool {
        return ft?.reminderMicrosoft ?? false
    }

    var reminderMissedCall: Bool {
        return ft?.reminderMissedCall ?? false
    }

    var reminderGetAllContact: Bool {
        return ft?.reminderGetAllContact ?? false
    }

    var reminderWhatsappBusiness: Bool {
        return ft?.reminderWhatsappBusiness ?? false
    }

    var reminderEmail: Bool {
        return ft?.reminderEmail ?? false
    }

    var reminderFacebook: Bool {
        return ft?.reminderFacebook ?? false
    }

    var reminderMessage: Bool {
        return ft?.reminderMessage ?? false
    }

    var reminderQq: Bool {
        return ft?.reminderQq ?? false
    }

    var reminderTwitter: Bool {
        return ft?.reminderTwitter ?? false
    }

    var reminderWeixin: Bool {
        return ft?.reminderWeixin ?? false
    }

    var reminderCalendarGoogle: Bool {
        return ft?.reminderCalendarGoogle ?? false
    }

    var reminderInstagram: Bool {
        return ft?.reminderInstagram ?? false
    }

    var reminderLinkedIn: Bool {
        return ft?.reminderLinkedIn ?? false
    }

    var reminderMessengre: Bool {
        return ft?.reminderMessengre ?? false
    }

    var reminderSkype: Bool {
        return ft?.reminderSkype ?? false
    }

    var reminderCalendar: Bool {
        return ft?.reminderCalendar ?? false
    }

    var reminderWhatsapp: Bool {
        return ft?.reminderWhatsapp ?? false
    }

    var reminderAlarmClock: Bool {
        return ft?.reminderAlarmClock ?? false
    }

    var reminderSinaWeibo: Bool {
        return ft?.reminderSinaWeibo ?? false
    }

    var reminderWeibo: Bool {
        return ft?.reminderWeibo ?? false
    }

    var reminderCalling: Bool {
        return ft?.reminderCalling ?? false
    }

    var reminderCallContact: Bool {
        return ft?.reminderCallContact ?? false
    }

    var reminderCallNum: Bool {
        return ft?.reminderCallNum ?? false
    }

    var reminderPrime: Bool {
        return ft?.reminderPrime ?? false
    }

    var reminderNetflix: Bool {
        return ft?.reminderNetflix ?? false
    }

    var reminderGpay: Bool {
        return ft?.reminderGpay ?? false
    }

    var reminderPhonpe: Bool {
        return ft?.reminderPhonpe ?? false
    }

    var reminderSwiggy: Bool {
        return ft?.reminderSwiggy ?? false
    }

    var reminderZomato: Bool {
        return ft?.reminderZomato ?? false
    }

    var reminderMakemytrip: Bool {
        return ft?.reminderMakemytrip ?? false
    }

    var reminderJioTv: Bool {
        return ft?.reminderJioTv ?? false
    }

    var reminderNiosefit: Bool {
        return ft?.reminderNiosefit ?? false
    }

    var reminderYtmusic: Bool {
        return ft?.reminderYtmusic ?? false
    }

    var reminderUber: Bool {
        return ft?.reminderUber ?? false
    }

    var reminderOla: Bool {
        return ft?.reminderOla ?? false
    }

    var reminderGoogleMeet: Bool {
        return ft?.reminderGoogleMeet ?? false
    }

    var reminderMormaiiSmartwatch: Bool {
        return ft?.reminderMormaiiSmartwatch ?? false
    }

    var reminderTechnosConnect: Bool {
        return ft?.reminderTechnosConnect ?? false
    }

    var reminderEnjoei: Bool {
        return ft?.reminderEnjoei ?? false
    }

    var reminderAliexpress: Bool {
        return ft?.reminderAliexpress ?? false
    }

    var reminderShopee: Bool {
        return ft?.reminderShopee ?? false
    }

    var reminderTeams: Bool {
        return ft?.reminderTeams ?? false
    }

    var reminder99Taxi: Bool {
        return ft?.reminder99Taxi ?? false
    }

    var reminderUberEats: Bool {
        return ft?.reminderUberEats ?? false
    }

    var reminderLfood: Bool {
        return ft?.reminderLfood ?? false
    }

    var reminderRappi: Bool {
        return ft?.reminderRappi ?? false
    }

    var reminderMercadoLivre: Bool {
        return ft?.reminderMercadoLivre ?? false
    }

    var reminderMagalu: Bool {
        return ft?.reminderMagalu ?? false
    }

    var reminderAmericanas: Bool {
        return ft?.reminderAmericanas ?? false
    }

    var reminderYahoo: Bool {
        return ft?.reminderYahoo ?? false
    }

    var reminderMessageIcon: Bool {
        return ft?.reminderMessageIcon ?? false
    }

    var reminderTaobao: Bool {
        return ft?.reminderTaobao ?? false
    }

    var reminderDingding: Bool {
        return ft?.reminderDingding ?? false
    }

    var reminderAlipay: Bool {
        return ft?.reminderAlipay ?? false
    }

    var reminderToutiao: Bool {
        return ft?.reminderToutiao ?? false
    }

    var reminderDouyin: Bool {
        return ft?.reminderDouyin ?? false
    }

    var reminderTmall: Bool {
        return ft?.reminderTmall ?? false
    }

    var reminderJd: Bool {
        return ft?.reminderJd ?? false
    }

    var reminderPinduoduo: Bool {
        return ft?.reminderPinduoduo ?? false
    }

    var reminderBaidu: Bool {
        return ft?.reminderBaidu ?? false
    }

    var reminderMeituan: Bool {
        return ft?.reminderMeituan ?? false
    }

    var reminderEleme: Bool {
        return ft?.reminderEleme ?? false
    }

    var sportWalk: Bool {
        return ft?.sportWalk ?? false
    }

    var sportRun: Bool {
        return ft?.sportRun ?? false
    }

    var sportByBike: Bool {
        return ft?.sportByBike ?? false
    }

    var sportOnFoot: Bool {
        return ft?.sportOnFoot ?? false
    }

    var sportSwim: Bool {
        return ft?.sportSwim ?? false
    }

    var sportMountainClimbing: Bool {
        return ft?.sportMountainClimbing ?? false
    }

    var sportBadminton: Bool {
        return ft?.sportBadminton ?? false
    }

    var sportOther: Bool {
        return ft?.sportOther ?? false
    }

    var sportFitness: Bool {
        return ft?.sportFitness ?? false
    }

    var sportSpinning: Bool {
        return ft?.sportSpinning ?? false
    }

    var sportEllipsoid: Bool {
        return ft?.sportEllipsoid ?? false
    }

    var sportTreadmill: Bool {
        return ft?.sportTreadmill ?? false
    }

    var sportSitUp: Bool {
        return ft?.sportSitUp ?? false
    }

    var sportPushUp: Bool {
        return ft?.sportPushUp ?? false
    }

    var sportDumbbell: Bool {
        return ft?.sportDumbbell ?? false
    }

    var sportWeightlifting: Bool {
        return ft?.sportWeightlifting ?? false
    }

    var sportBodybuildingExercise: Bool {
        return ft?.sportBodybuildingExercise ?? false
    }

    var sportYoga: Bool {
        return ft?.sportYoga ?? false
    }

    var sportRopeSkipping: Bool {
        return ft?.sportRopeSkipping ?? false
    }

    var sportTableTennis: Bool {
        return ft?.sportTableTennis ?? false
    }

    var sportBasketball: Bool {
        return ft?.sportBasketball ?? false
    }

    var sportFootballl: Bool {
        return ft?.sportFootballl ?? false
    }

    var sportVolleyball: Bool {
        return ft?.sportVolleyball ?? false
    }

    var sportTennis: Bool {
        return ft?.sportTennis ?? false
    }

    var sportGolf: Bool {
        return ft?.sportGolf ?? false
    }

    var sportBaseball: Bool {
        return ft?.sportBaseball ?? false
    }

    var sportSkiing: Bool {
        return ft?.sportSkiing ?? false
    }

    var sportRollerSkating: Bool {
        return ft?.sportRollerSkating ?? false
    }

    var sportDance: Bool {
        return ft?.sportDance ?? false
    }

    var sportStrengthTraining: Bool {
        return ft?.sportStrengthTraining ?? false
    }

    var sportCoreTraining: Bool {
        return ft?.sportCoreTraining ?? false
    }

    var sportTidyUpRelax: Bool {
        return ft?.sportTidyUpRelax ?? false
    }

    var sportTraditionalStrengthTraining: Bool {
        return ft?.sportTraditionalStrengthTraining ?? false
    }

    var sportOutdoorRun: Bool {
        return ft?.sportOutdoorRun ?? false
    }

    var sportIndoorRun: Bool {
        return ft?.sportIndoorRun ?? false
    }

    var sportOutdoorCycle: Bool {
        return ft?.sportOutdoorCycle ?? false
    }

    var sportIndoorCycle: Bool {
        return ft?.sportIndoorCycle ?? false
    }

    var sportOutdoorWalk: Bool {
        return ft?.sportOutdoorWalk ?? false
    }

    var sportIndoorWalk: Bool {
        return ft?.sportIndoorWalk ?? false
    }

    var sportPoolSwim: Bool {
        return ft?.sportPoolSwim ?? false
    }

    var sportOpenWaterSwim: Bool {
        return ft?.sportOpenWaterSwim ?? false
    }

    var sportElliptical: Bool {
        return ft?.sportElliptical ?? false
    }

    var sportRower: Bool {
        return ft?.sportRower ?? false
    }

    var sportHiit: Bool {
        return ft?.sportHiit ?? false
    }

    var sportCricket: Bool {
        return ft?.sportCricket ?? false
    }

    var sportPilates: Bool {
        return ft?.sportPilates ?? false
    }

    var sportOutdoorFun: Bool {
        return ft?.sportOutdoorFun ?? false
    }

    var sportOtherActivity: Bool {
        return ft?.sportOtherActivity ?? false
    }

    var sportZumba: Bool {
        return ft?.sportZumba ?? false
    }

    var sportSurfing: Bool {
        return ft?.sportSurfing ?? false
    }

    var sportFootvolley: Bool {
        return ft?.sportFootvolley ?? false
    }

    var sportStandWaterSkiing: Bool {
        return ft?.sportStandWaterSkiing ?? false
    }

    var sportBattlingRope: Bool {
        return ft?.sportBattlingRope ?? false
    }

    var sportSkateboard: Bool {
        return ft?.sportSkateboard ?? false
    }

    var sportNoticeStepper: Bool {
        return ft?.sportNoticeStepper ?? false
    }

    var sportShowNum: Int {
        return ft?.sportShowNum ?? 0
    }

    var sportAerobicsBodybuildingExercise: Bool {
        return ft?.sportAerobicsBodybuildingExercise ?? false
    }

    var sportPullUp: Bool {
        return ft?.sportPullUp ?? false
    }

    var sportHighBar: Bool {
        return ft?.sportHighBar ?? false
    }

    var sportParallelBars: Bool {
        return ft?.sportParallelBars ?? false
    }

    var sportTrailRunning: Bool {
        return ft?.sportTrailRunning ?? false
    }

    var sportPickleBall: Bool {
        return ft?.sportPickleBall ?? false
    }

    var sportSnowboard: Bool {
        return ft?.sportSnowboard ?? false
    }

    var sportCrossCountrySkiing: Bool {
        return ft?.sportCrossCountrySkiing ?? false
    }

    var getRealtimeData: Bool {
        return ft?.getRealtimeData ?? false
    }

    var getLangLibraryV3: Bool {
        return ft?.getLangLibraryV3 ?? false
    }

    var getFindPhone: Bool {
        return ft?.getFindPhone ?? false
    }

    var getFindDevice: Bool {
        return ft?.getFindDevice ?? false
    }

    var getUpHandGestureEx: Bool {
        return ft?.getUpHandGestureEx ?? false
    }

    var getUpHandGesture: Bool {
        return ft?.getUpHandGesture ?? false
    }

    var getWeather: Bool {
        return ft?.getWeather ?? false
    }

    var getDownloadLanguage: Bool {
        return ft?.getDownloadLanguage ?? false
    }

    var getFactoryReset: Bool {
        return ft?.getFactoryReset ?? false
    }

    var getFlashLog: Bool {
        return ft?.getFlashLog ?? false
    }

    var getMultiActivityNoUseApp: Bool {
        return ft?.getMultiActivityNoUseApp ?? false
    }

    var getMultiDial: Bool {
        return ft?.getMultiDial ?? false
    }

    var getMenuList: Bool {
        return ft?.getMenuList ?? false
    }

    var getDoNotDisturbMain3: Bool {
        return ft?.getDoNotDisturbMain3 ?? false
    }

    var getVoiceTransmission: Bool {
        return ft?.getVoiceTransmission ?? false
    }

    var setDrinkWaterAddNotifyFlag: Bool {
        return ft?.setDrinkWaterAddNotifyFlag ?? false
    }

    var setSpo2LowValueRemindAddNotifyFlag: Bool {
        return ft?.setSpo2LowValueRemindAddNotifyFlag ?? false
    }

    var notSupportSmartHeartNotifyFlag: Bool {
        return ft?.notSupportSmartHeartNotifyFlag ?? false
    }

    var getDeviceLogState: Bool {
        return ft?.getDeviceLogState ?? false
    }

    var getNewWatchList: Bool {
        return ft?.getNewWatchList ?? false
    }

    var getNotifyIconAdaptive: Bool {
        return ft?.getNotifyIconAdaptive ?? false
    }

    var getPressureNotifyFlagMode: Bool {
        return ft?.getPressureNotifyFlagMode ?? false
    }

    var getScientificSleep: Bool {
        return ft?.getScientificSleep ?? false
    }

    var getSpo2NotifyFlag: Bool {
        return ft?.getSpo2NotifyFlag ?? false
    }

    var getV3Log: Bool {
        return ft?.getV3Log ?? false
    }

    var getWatchID: Bool {
        return ft?.getWatchID ?? false
    }

    var getDeviceName: Bool {
        return ft?.getDeviceName ?? false
    }

    var getBatteryLog: Bool {
        return ft?.getBatteryLog ?? false
    }

    var getBatteryInfo: Bool {
        return ft?.getBatteryInfo ?? false
    }

    var getHeatLog: Bool {
        return ft?.getHeatLog ?? false
    }

    var getWalkReminderV3: Bool {
        return ft?.getWalkReminderV3 ?? false
    }

    var getSupportV3BleMusic: Bool {
        return ft?.getSupportV3BleMusic ?? false
    }

    var getSupportGetBleBeepV3: Bool {
        return ft?.getSupportGetBleBeepV3 ?? false
    }

    var getVeryFitNotSupportPhotoWallpaperV3: Bool {
        return ft?.getVeryFitNotSupportPhotoWallpaperV3 ?? false
    }

    var getSupportUpdateGps: Bool {
        return ft?.getSupportUpdateGps ?? false
    }

    var getUbloxModel: Bool {
        return ft?.getUbloxModel ?? false
    }

    var getSupportGetBleMusicInfoVerV3: Bool {
        return ft?.getSupportGetBleMusicInfoVerV3 ?? false
    }

    var getBtVersion: Bool {
        return ft?.getBtVersion ?? false
    }

    var getSportsTypeV3: Bool {
        return ft?.getSportsTypeV3 ?? false
    }

    var getActivitySwitch: Bool {
        return ft?.getActivitySwitch ?? false
    }

    var getNoticeIconInformation: Bool {
        return ft?.getNoticeIconInformation ?? false
    }

    var getSetMaxItemsNum: Bool {
        return ft?.getSetMaxItemsNum ?? false
    }

    var getNotifyMsgV3: Bool {
        return ft?.getNotifyMsgV3 ?? false
    }

    var getScreenBrightnessMain9: Bool {
        return ft?.getScreenBrightnessMain9 ?? false
    }

    var getNotice128byte: Bool {
        return ft?.getNotice128byte ?? false
    }

    var getNotice250byte: Bool {
        return ft?.getNotice250byte ?? false
    }

    var getDeletableMenuListV2: Bool {
        return ft?.getDeletableMenuListV2 ?? false
    }

    var getSupportPairEachConnect: Bool {
        return ft?.getSupportPairEachConnect ?? false
    }

    var getSupportGetMainSportGoalV3: Bool {
        return ft?.getSupportGetMainSportGoalV3 ?? false
    }

    var getBtAddrV2: Bool {
        return ft?.getBtAddrV2 ?? false
    }

    var getSupportBpSetOrMeasurementV2: Bool {
        return ft?.getSupportBpSetOrMeasurementV2 ?? false
    }

    var getMenstrualAddNotifyFlagV3: Bool {
        return ft?.getMenstrualAddNotifyFlagV3 ?? false
    }

    var getSupportSetGetTimeGoalTypeV2: Bool {
        return ft?.getSupportSetGetTimeGoalTypeV2 ?? false
    }

    var getOxygenDataSupportGradeV3: Bool {
        return ft?.getOxygenDataSupportGradeV3 ?? false
    }

    var getSupportSyncActivityDataAltitudeInfo: Bool {
        return ft?.getSupportSyncActivityDataAltitudeInfo ?? false
    }

    var getBindCodeAuth: Bool {
        return ft?.getBindCodeAuth ?? false
    }

    var getSpo2OffChangeV3: Bool {
        return ft?.getSpo2OffChangeV3 ?? false
    }

    var getLevel5HrInterval: Bool {
        return ft?.getLevel5HrInterval ?? false
    }

    var getFiveHRInterval: Bool {
        return ft?.getFiveHRInterval ?? false
    }

    var getBleAndBtVersion: Bool {
        return ft?.getBleAndBtVersion ?? false
    }

    var getSupportSetGetEmergencyContactV3: Bool {
        return ft?.getSupportSetGetEmergencyContactV3 ?? false
    }

    var getSupportSetRepeatWeekTypeOnScheduleReminderV3: Bool {
        return ft?.getSupportSetRepeatWeekTypeOnScheduleReminderV3 ?? false
    }

    var getSupportSetRepeatTypeOnScheduleReminderV3: Bool {
        return ft?.getSupportSetRepeatTypeOnScheduleReminderV3 ?? false
    }

    var getSupportSetMenstrualReminderOnOff: Bool {
        return ft?.getSupportSetMenstrualReminderOnOff ?? false
    }

    var getVersionInfo: Bool {
        return ft?.getVersionInfo ?? false
    }

    var getMtu: Bool {
        return ft?.getMtu ?? false
    }

    var getDeviceUpdateState: Bool {
        return ft?.getDeviceUpdateState ?? false
    }

    var getHeartRateModeV2: Bool {
        return ft?.getHeartRateModeV2 ?? false
    }

    var getStepDataTypeV2: Bool {
        return ft?.getStepDataTypeV2 ?? false
    }

    var getFastMsgDataV3: Bool {
        return ft?.getFastMsgDataV3 ?? false
    }

    var getSupportCallingQuickReply: Bool {
        return ft?.getSupportCallingQuickReply ?? false
    }

    var getSupportDataTranGetNewErrorCodeV3: Bool {
        return ft?.getSupportDataTranGetNewErrorCodeV3 ?? false
    }

    var getAutoActivityEndSwitchNotDisplay: Bool {
        return ft?.getAutoActivityEndSwitchNotDisplay ?? false
    }

    var getAutoActivityPauseSwitchNotDisplay: Bool {
        return ft?.getAutoActivityPauseSwitchNotDisplay ?? false
    }

    var getV3AutoActivitySwitch: Bool {
        return ft?.getV3AutoActivitySwitch ?? false
    }

    var getAutoActivitySwitchAddBicycle: Bool {
        return ft?.getAutoActivitySwitchAddBicycle ?? false
    }

    var getAutoActivitySwitchAddSmartRope: Bool {
        return ft?.getAutoActivitySwitchAddSmartRope ?? false
    }

    var getAutoActivitySetGetUseNewStructExchange: Bool {
        return ft?.getAutoActivitySetGetUseNewStructExchange ?? false
    }

    var getSupportSetGetNoReminderOnWalkReminderV2: Bool {
        return ft?.getSupportSetGetNoReminderOnWalkReminderV2 ?? false
    }

    var getSupportGetSnInfo: Bool {
        return ft?.getSupportGetSnInfo ?? false
    }

    var getScheduleReminderNotDisplayTitle: Bool {
        return ft?.getScheduleReminderNotDisplayTitle ?? false
    }

    var getSupportV3LongCityName: Bool {
        return ft?.getSupportV3LongCityName ?? false
    }

    var getSupportAddNightLevelV2: Bool {
        return ft?.getSupportAddNightLevelV2 ?? false
    }

    var getSupportDialFrameEncodeFormatArgb6666: Bool {
        return ft?.getSupportDialFrameEncodeFormatArgb6666 ?? false
    }

    var getSupportAppSendPhoneSystemInfo: Bool {
        return ft?.getSupportAppSendPhoneSystemInfo ?? false
    }

    var getDeviceControlFastModeAlone: Bool {
        return ft?.getDeviceControlFastModeAlone ?? false
    }

    var getSupportOnekeyDoubleContact: Bool {
        return ft?.getSupportOnekeyDoubleContact ?? false
    }

    var getSupportSetVoiceAssistantStatus: Bool {
        return ft?.getSupportSetVoiceAssistantStatus ?? false
    }

    var getSupportFlashLogSize: Bool {
        return ft?.getSupportFlashLogSize ?? false
    }

    var supportDevReturnMeasuringValue: Bool {
        return ft?.supportDevReturnMeasuringValue ?? false
    }

    var getSupportGetUnit: Bool {
        return ft?.getSupportGetUnit ?? false
    }

    var getSupportRyzeConnect: Bool {
        return ft?.getSupportRyzeConnect ?? false
    }

    var getSupportLoopsFit: Bool {
        return ft?.getSupportLoopsFit ?? false
    }

    var getSupportTasSmart: Bool {
        return ft?.getSupportTasSmart ?? false
    }

    var getNotSupportSetOvulation: Bool {
        return ft?.getNotSupportSetOvulation ?? false
    }

    var getSupportWalkGoalSteps: Bool {
        return ft?.getSupportWalkGoalSteps ?? false
    }

    var getNotSupportDeleteAddSportSort: Bool {
        return ft?.getNotSupportDeleteAddSportSort ?? false
    }

    var getSupportSedentaryTensileHabitInfo: Bool {
        return ft?.getSupportSedentaryTensileHabitInfo ?? false
    }

    var getSupportSendGpsLongitudeAndLatitude: Bool {
        return ft?.getSupportSendGpsLongitudeAndLatitude ?? false
    }

    var getSupportGetV3DeviceBtConnectPhoneModel: Bool {
        return ft?.getSupportGetV3DeviceBtConnectPhoneModel ?? false
    }

    var getSupportBloodPressureModelFileUpdate: Bool {
        return ft?.getSupportBloodPressureModelFileUpdate ?? false
    }

    var getSupportDisturbHaveRangRepeat: Bool {
        return ft?.getSupportDisturbHaveRangRepeat ?? false
    }

    var getSupportCalendarReminder: Bool {
        return ft?.getSupportCalendarReminder ?? false
    }

    var getWatchDailSetAddSize: Bool {
        return ft?.getWatchDailSetAddSize ?? false
    }

    var getSupportSyncOverHighLowHeartData: Bool {
        return ft?.getSupportSyncOverHighLowHeartData ?? false
    }

    var getSupportPerMinuteOne: Bool {
        return ft?.getSupportPerMinuteOne ?? false
    }

    var getSupportAchievedRemindOnOff: Bool {
        return ft?.getSupportAchievedRemindOnOff ?? false
    }

    var getSupportDrinkPlan: Bool {
        return ft?.getSupportDrinkPlan ?? false
    }

    var getSupportMakeWatchDialDecodeJpg: Bool {
        return ft?.getSupportMakeWatchDialDecodeJpg ?? false
    }

    var getSupportSleepPlan: Bool {
        return ft?.getSupportSleepPlan ?? false
    }

    var getSupportDeviceOperateAlgFile: Bool {
        return ft?.getSupportDeviceOperateAlgFile ?? false
    }

    var getSupportSportRecordShowConfig: Bool {
        return ft?.getSupportSportRecordShowConfig ?? false
    }

    var setNoticeMessageStateUseVersion0x20: Bool {
        return ft?.setNoticeMessageStateUseVersion0x20 ?? false
    }

    var setScientificSleepSwitch: Bool {
        return ft?.setScientificSleepSwitch ?? false
    }

    var setTemperatureSwitchHealth: Bool {
        return ft?.setTemperatureSwitchHealth ?? false
    }

    var setHeartRateMonitor: Bool {
        return ft?.setHeartRateMonitor ?? false
    }

    var setNoReminderOnDrinkReminder: Bool {
        return ft?.setNoReminderOnDrinkReminder ?? false
    }

    var setAgpsOffLine: Bool {
        return ft?.setAgpsOffLine ?? false
    }

    var setAgpsOnLine: Bool {
        return ft?.setAgpsOnLine ?? false
    }

    var setSetV3HeartInterval: Bool {
        return ft?.setSetV3HeartInterval ?? false
    }

    var setWeatherCity: Bool {
        return ft?.setWeatherCity ?? false
    }

    var setDoNotDisturb: Bool {
        return ft?.setDoNotDisturb ?? false
    }

    var setCalorieGoal: Bool {
        return ft?.setCalorieGoal ?? false
    }

    var setMenstruation: Bool {
        return ft?.setMenstruation ?? false
    }

    var setPressureData: Bool {
        return ft?.setPressureData ?? false
    }

    var setSpo2Data: Bool {
        return ft?.setSpo2Data ?? false
    }

    var setSportModeSort: Bool {
        return ft?.setSportModeSort ?? false
    }

    var setActivitySwitch: Bool {
        return ft?.setActivitySwitch ?? false
    }

    var setNightAutoBrightness: Bool {
        return ft?.setNightAutoBrightness ?? false
    }

    var setScreenBrightness5Level: Bool {
        return ft?.setScreenBrightness5Level ?? false
    }

    var setWalkReminder: Bool {
        return ft?.setWalkReminder ?? false
    }

    var setScreenBrightness3Level: Bool {
        return ft?.setScreenBrightness3Level ?? false
    }

    var setHandWashReminder: Bool {
        return ft?.setHandWashReminder ?? false
    }

    var setLocalDial: Bool {
        return ft?.setLocalDial ?? false
    }

    var setNotSupportHrHighAlarm: Bool {
        return ft?.setNotSupportHrHighAlarm ?? false
    }

    var setNotSupportPhotoWallpaper: Bool {
        return ft?.setNotSupportPhotoWallpaper ?? false
    }

    var setPressureHighReminder: Bool {
        return ft?.setPressureHighReminder ?? false
    }

    var setWallpaperOnlyTimeColor: Bool {
        return ft?.setWallpaperOnlyTimeColor ?? false
    }

    var setWallpaperDial: Bool {
        return ft?.setWallpaperDial ?? false
    }

    var setSupportBreathRate: Bool {
        return ft?.setSupportBreathRate ?? false
    }

    var setSupportCalorieUnit: Bool {
        return ft?.setSupportCalorieUnit ?? false
    }

    var setSupportSportPlan: Bool {
        return ft?.setSupportSportPlan ?? false
    }

    var setSupportSwimPoolUnit: Bool {
        return ft?.setSupportSwimPoolUnit ?? false
    }

    var setSupportV3Bp: Bool {
        return ft?.setSupportV3Bp ?? false
    }

    var setV3GetSportSortField: Bool {
        return ft?.setV3GetSportSortField ?? false
    }

    var setWatchDialSort: Bool {
        return ft?.setWatchDialSort ?? false
    }

    var setGetCalorieDistanceGoal: Bool {
        return ft?.setGetCalorieDistanceGoal ?? false
    }

    var setMidHighTimeGoal: Bool {
        return ft?.setMidHighTimeGoal ?? false
    }

    var setNewRetainData: Bool {
        return ft?.setNewRetainData ?? false
    }

    var setScheduleReminder: Bool {
        return ft?.setScheduleReminder ?? false
    }

    var setSet100SportSort: Bool {
        return ft?.setSet100SportSort ?? false
    }

    var setSet20SportParamSort: Bool {
        return ft?.setSet20SportParamSort ?? false
    }

    var setSetMainUiSort: Bool {
        return ft?.setSetMainUiSort ?? false
    }

    var setSetStressCalibration: Bool {
        return ft?.setSetStressCalibration ?? false
    }

    var setSmartHeartRate: Bool {
        return ft?.setSmartHeartRate ?? false
    }

    var setSpo2AllDayOnOff: Bool {
        return ft?.setSpo2AllDayOnOff ?? false
    }

    var setSupportAppSendVoiceToBle: Bool {
        return ft?.setSupportAppSendVoiceToBle ?? false
    }

    var setSupportCyclingUnit: Bool {
        return ft?.setSupportCyclingUnit ?? false
    }

    var setSupportWalkRunUnit: Bool {
        return ft?.setSupportWalkRunUnit ?? false
    }

    var setWalkReminderTimeGoal: Bool {
        return ft?.setWalkReminderTimeGoal ?? false
    }

    var setWatchCapacitySizeDisplay: Bool {
        return ft?.setWatchCapacitySizeDisplay ?? false
    }

    var setWatchPhotoPositionMove: Bool {
        return ft?.setWatchPhotoPositionMove ?? false
    }

    var setMenuListMain7: Bool {
        return ft?.setMenuListMain7 ?? false
    }

    var setHistoryMenstrual: Bool {
        return ft?.setHistoryMenstrual ?? false
    }

    var supportHistoricalMenstruationExchange: Bool {
        return ft?.supportHistoricalMenstruationExchange ?? false
    }

    var supportSetHistoricalMenstruationExchangeVersion21: Bool {
        return ft?.supportSetHistoricalMenstruationExchangeVersion21 ?? false
    }

    var supportHistoricalMenstruationExchangeVersion31: Bool {
        return ft?.supportHistoricalMenstruationExchangeVersion31 ?? false
    }

    var supportPhysiologicalRecord: Bool {
        return ft?.supportPhysiologicalRecord ?? false
    }

    var setMenstrualAddPregnancy: Bool {
        return ft?.setMenstrualAddPregnancy ?? false
    }

    var setNotSurportCalling3SDelay: Bool {
        return ft?.setNotSurportCalling3SDelay ?? false
    }

    var setSetFitnessGuidance: Bool {
        return ft?.setSetFitnessGuidance ?? false
    }

    var setSetNotificationStatus: Bool {
        return ft?.setSetNotificationStatus ?? false
    }

    var setSetUnreadAppReminder: Bool {
        return ft?.setSetUnreadAppReminder ?? false
    }

    var setSetV3Weather: Bool {
        return ft?.setSetV3Weather ?? false
    }

    var setSetV3WeatherSunrise: Bool {
        return ft?.setSetV3WeatherSunrise ?? false
    }

    var setSetV3WorldTime: Bool {
        return ft?.setSetV3WorldTime ?? false
    }

    var setSyncContact: Bool {
        return ft?.setSyncContact ?? false
    }

    var setSyncV3ActivityAddParam: Bool {
        return ft?.setSyncV3ActivityAddParam ?? false
    }

    var setTransferMusicFile: Bool {
        return ft?.setTransferMusicFile ?? false
    }

    var setWalkReminderAddNotify: Bool {
        return ft?.setWalkReminderAddNotify ?? false
    }

    var setSupportFahrenheit: Bool {
        return ft?.setSupportFahrenheit ?? false
    }

    var setGetAlarmSpecify: Bool {
        return ft?.setGetAlarmSpecify ?? false
    }

    var setAirohaGpsChip: Bool {
        return ft?.setAirohaGpsChip ?? false
    }

    var setSupportSecondSportIcon: Bool {
        return ft?.setSupportSecondSportIcon ?? false
    }

    var setSportMediumIcon: Bool {
        return ft?.setSportMediumIcon ?? false
    }

    var setWeatherSunTime: Bool {
        return ft?.setWeatherSunTime ?? false
    }

    var setWeatherAirGrade: Bool {
        return ft?.setWeatherAirGrade ?? false
    }

    var setDrinkWaterReminder: Bool {
        return ft?.setDrinkWaterReminder ?? false
    }

    var supportBatteryReminderSwitch: Bool {
        return ft?.supportBatteryReminderSwitch ?? false
    }

    var supportPetInfo: Bool {
        return ft?.supportPetInfo ?? false
    }

    var setRespirationRate: Bool {
        return ft?.setRespirationRate ?? false
    }

    var setMaxBloodOxygen: Bool {
        return ft?.setMaxBloodOxygen ?? false
    }

    var setBleControlMusic: Bool {
        return ft?.setBleControlMusic ?? false
    }

    var setMainPressure: Bool {
        return ft?.setMainPressure ?? false
    }

    var setNoDisturbAllDayOnOff: Bool {
        return ft?.setNoDisturbAllDayOnOff ?? false
    }

    var setOnlyNoDisturbAllDayOnOff: Bool {
        return ft?.setOnlyNoDisturbAllDayOnOff ?? false
    }

    var setOnlyNoDisturbSmartOnOff: Bool {
        return ft?.setOnlyNoDisturbSmartOnOff ?? false
    }

    var setTimeZoneFloat: Bool {
        return ft?.setTimeZoneFloat ?? false
    }

    var setTemperatureSwitchSupport: Bool {
        return ft?.setTemperatureSwitchSupport ?? false
    }

    var setMsgAllSwitch: Bool {
        return ft?.setMsgAllSwitch ?? false
    }

    var setNotSupperCall3Delay: Bool {
        return ft?.setNotSupperCall3Delay ?? false
    }

    var setNoticeMissedCallV2: Bool {
        return ft?.setNoticeMissedCallV2 ?? false
    }

    var setOverFindPhone: Bool {
        return ft?.setOverFindPhone ?? false
    }

    var getHealthSwitchStateSupportV3: Bool {
        return ft?.getHealthSwitchStateSupportV3 ?? false
    }

    var setSedentariness: Bool {
        return ft?.setSedentariness ?? false
    }

    var setScreenBrightness: Bool {
        return ft?.setScreenBrightness ?? false
    }

    var setSetPhoneVoice: Bool {
        return ft?.setSetPhoneVoice ?? false
    }

    var setSupportSetCallQuickReplyOnOff: Bool {
        return ft?.setSupportSetCallQuickReplyOnOff ?? false
    }

    var setSupportExchangeSetGpsCoordinates: Bool {
        return ft?.setSupportExchangeSetGpsCoordinates ?? false
    }

    var setSupportV3WeatherAddAtmosphericPressure: Bool {
        return ft?.setSupportV3WeatherAddAtmosphericPressure ?? false
    }

    var setSupportSetV3WeatcherAddSnowDepth: Bool {
        return ft?.setSupportSetV3WeatcherAddSnowDepth ?? false
    }

    var setSupportSetV3WeatcherAddSnowfall: Bool {
        return ft?.setSupportSetV3WeatcherAddSnowfall ?? false
    }

    var setSupportSetV3WeatcherSendStructVersion04: Bool {
        return ft?.setSupportSetV3WeatcherSendStructVersion04 ?? false
    }

    var setSendCalibrationThreshold: Bool {
        return ft?.setSendCalibrationThreshold ?? false
    }

    var getNotSupportAppSendRunPlan: Bool {
        return ft?.getNotSupportAppSendRunPlan ?? false
    }

    var getSupportDisplayNapSleep: Bool {
        return ft?.getSupportDisplayNapSleep ?? false
    }

    var getSupportGetSmartHeartRate: Bool {
        return ft?.getSupportGetSmartHeartRate ?? false
    }

    var getSupportGetPressureSwitchInfo: Bool {
        return ft?.getSupportGetPressureSwitchInfo ?? false
    }

    var getSupportECardOperate: Bool {
        return ft?.getSupportECardOperate ?? false
    }

    var getSupportVoiceMemoOperate: Bool {
        return ft?.getSupportVoiceMemoOperate ?? false
    }

    var getSupportMorningEdition: Bool {
        return ft?.getSupportMorningEdition ?? false
    }

    var getSupportGetSpo2SwitchInfo: Bool {
        return ft?.getSupportGetSpo2SwitchInfo ?? false
    }

    var getSupportSyncHealthHrUseVersionCompatible: Bool {
        return ft?.getSupportSyncHealthHrUseVersionCompatible ?? false
    }

    var getSupportSetV3Add48HourWeatherData: Bool {
        return ft?.getSupportSetV3Add48HourWeatherData ?? false
    }

    var getNotSupportIndoorRunGetVo2max: Bool {
        return ft?.getNotSupportIndoorRunGetVo2max ?? false
    }

    var getSupportSetEcgReminder: Bool {
        return ft?.getSupportSetEcgReminder ?? false
    }

    var getSupportSyncEcg: Bool {
        return ft?.getSupportSyncEcg ?? false
    }

    var getSupportSetGameTimeReminder: Bool {
        return ft?.getSupportSetGameTimeReminder ?? false
    }

    var getSupportConfigDefaultMegApplicationList: Bool {
        return ft?.getSupportConfigDefaultMegApplicationList ?? false
    }

    var getSupportSetEciReminder: Bool {
        return ft?.getSupportSetEciReminder ?? false
    }

    var setSupportNoiseSetNotifyFlag: Bool {
        return ft?.setSupportNoiseSetNotifyFlag ?? false
    }

    var setSupportNoiseSetOverWarning: Bool {
        return ft?.setSupportNoiseSetOverWarning ?? false
    }

    var setSupportSetVersionInformation: Bool {
        return ft?.setSupportSetVersionInformation ?? false
    }

    var setSupportControlMiniProgram: Bool {
        return ft?.setSupportControlMiniProgram ?? false
    }

    var getSupportSetWeatherHistoryFutureAqi: Bool {
        return ft?.getSupportSetWeatherHistoryFutureAqi ?? false
    }

    var setBrightScreenTime: Bool {
        return ft?.setBrightScreenTime ?? false
    }

    var setHeartSetRateModeCustom: Bool {
        return ft?.setHeartSetRateModeCustom ?? false
    }

    var supportProtocolV3MenuList: Bool {
        return ft?.supportProtocolV3MenuList ?? false
    }

    var languageCh: Bool {
        return ft?.languageCh ?? false
    }

    var languageCzech: Bool {
        return ft?.languageCzech ?? false
    }

    var languageEnglish: Bool {
        return ft?.languageEnglish ?? false
    }

    var languageFrench: Bool {
        return ft?.languageFrench ?? false
    }

    var languageGerman: Bool {
        return ft?.languageGerman ?? false
    }

    var languageItalian: Bool {
        return ft?.languageItalian ?? false
    }

    var languageJapanese: Bool {
        return ft?.languageJapanese ?? false
    }

    var languageSpanish: Bool {
        return ft?.languageSpanish ?? false
    }

    var languageArabic: Bool {
        return ft?.languageArabic ?? false
    }

    var languageBurmese: Bool {
        return ft?.languageBurmese ?? false
    }

    var languageFilipino: Bool {
        return ft?.languageFilipino ?? false
    }

    var languageGreek: Bool {
        return ft?.languageGreek ?? false
    }

    var languageThai: Bool {
        return ft?.languageThai ?? false
    }

    var languageTraditionalChinese: Bool {
        return ft?.languageTraditionalChinese ?? false
    }

    var languageVietnamese: Bool {
        return ft?.languageVietnamese ?? false
    }

    var languageDutch: Bool {
        return ft?.languageDutch ?? false
    }

    var languageHungarian: Bool {
        return ft?.languageHungarian ?? false
    }

    var languageLithuanian: Bool {
        return ft?.languageLithuanian ?? false
    }

    var languagePolish: Bool {
        return ft?.languagePolish ?? false
    }

    var languageRomanian: Bool {
        return ft?.languageRomanian ?? false
    }

    var languageRussian: Bool {
        return ft?.languageRussian ?? false
    }

    var languageSlovenian: Bool {
        return ft?.languageSlovenian ?? false
    }

    var languageUkrainian: Bool {
        return ft?.languageUkrainian ?? false
    }

    var languageCroatian: Bool {
        return ft?.languageCroatian ?? false
    }

    var languageDanish: Bool {
        return ft?.languageDanish ?? false
    }

    var languageHindi: Bool {
        return ft?.languageHindi ?? false
    }

    var languageIndonesian: Bool {
        return ft?.languageIndonesian ?? false
    }

    var languageKorean: Bool {
        return ft?.languageKorean ?? false
    }

    var languagePortuguese: Bool {
        return ft?.languagePortuguese ?? false
    }

    var languageSlovak: Bool {
        return ft?.languageSlovak ?? false
    }

    var languageTurkish: Bool {
        return ft?.languageTurkish ?? false
    }

    var languagePersia: Bool {
        return ft?.languagePersia ?? false
    }

    var languageSweden: Bool {
        return ft?.languageSweden ?? false
    }

    var languageNorwegian: Bool {
        return ft?.languageNorwegian ?? false
    }

    var languageFinland: Bool {
        return ft?.languageFinland ?? false
    }

    var languageBengali: Bool {
        return ft?.languageBengali ?? false
    }

    var languageKhmer: Bool {
        return ft?.languageKhmer ?? false
    }

    var languageMalay: Bool {
        return ft?.languageMalay ?? false
    }

    var languageBrazilianPortuguese: Bool {
        return ft?.languageBrazilianPortuguese ?? false
    }

    var languageHebrew: Bool {
        return ft?.languageHebrew ?? false
    }

    var languageSerbian: Bool {
        return ft?.languageSerbian ?? false
    }

    var languageBulgaria: Bool {
        return ft?.languageBulgaria ?? false
    }

    var syncV3Hr: Bool {
        return ft?.syncV3Hr ?? false
    }

    var syncV3Swim: Bool {
        return ft?.syncV3Swim ?? false
    }

    var syncV3Spo2: Bool {
        return ft?.syncV3Spo2 ?? false
    }

    var syncV3Pressure: Bool {
        return ft?.syncV3Pressure ?? false
    }

    var syncV3Activity: Bool {
        return ft?.syncV3Activity ?? false
    }

    var syncV3Sleep: Bool {
        return ft?.syncV3Sleep ?? false
    }

    var syncV3PetSleep: Bool {
        return ft?.syncV3PetSleep ?? false
    }

    var syncV3Sports: Bool {
        return ft?.syncV3Sports ?? false
    }

    var syncV3Gps: Bool {
        return ft?.syncV3Gps ?? false
    }

    var syncV3SyncAlarm: Bool {
        return ft?.syncV3SyncAlarm ?? false
    }

    var syncV3BodyPower: Bool {
        return ft?.syncV3BodyPower ?? false
    }

    var getSupportHrvV3: Bool {
        return ft?.getSupportHrvV3 ?? false
    }

    var getSupportPerBpV3: Bool {
        return ft?.getSupportPerBpV3 ?? false
    }

    var syncV3Noise: Bool {
        return ft?.syncV3Noise ?? false
    }

    var syncV3Temperature: Bool {
        return ft?.syncV3Temperature ?? false
    }

    var syncGps: Bool {
        return ft?.syncGps ?? false
    }

    var syncV3ActivityExchangeData: Bool {
        return ft?.syncV3ActivityExchangeData ?? false
    }

    var syncHeartRate: Bool {
        return ft?.syncHeartRate ?? false
    }

    var syncHeartRateMonitor: Bool {
        return ft?.syncHeartRateMonitor ?? false
    }

    var syncSleepMonitor: Bool {
        return ft?.syncSleepMonitor ?? false
    }

    var syncFastSync: Bool {
        return ft?.syncFastSync ?? false
    }

    var syncActivityTimeSync: Bool {
        return ft?.syncActivityTimeSync ?? false
    }

    var syncTimeLine: Bool {
        return ft?.syncTimeLine ?? false
    }

    var syncNeedV2: Bool {
        return ft?.syncNeedV2 ?? false
    }

    var syncRealTimeV3: Bool {
        return ft?.syncRealTimeV3 ?? false
    }

    var syncExchangeDataReplyAddRealTimeSpeedPaceV3: Bool {
        return ft?.syncExchangeDataReplyAddRealTimeSpeedPaceV3 ?? false
    }

    var syncHealthSyncV3ActivityEndTimeUseUtcMode: Bool {
        return ft?.syncHealthSyncV3ActivityEndTimeUseUtcMode ?? false
    }

    var syncSupportSetFastModeWhenSyncConfig: Bool {
        return ft?.syncSupportSetFastModeWhenSyncConfig ?? false
    }

    var getSupportAppBaseInformation: Bool {
        return ft?.getSupportAppBaseInformation ?? false
    }

    var alarmCount: Int {
        return ft?.alarmCount ?? 0
    }

    var alarmBrushTeeth: Bool {
        return ft?.alarmBrushTeeth ?? false
    }

    var alarmDating: Bool {
        return ft?.alarmDating ?? false
    }

    var alarmDinner: Bool {
        return ft?.alarmDinner ?? false
    }

    var alarmMedicine: Bool {
        return ft?.alarmMedicine ?? false
    }

    var alarmMeeting: Bool {
        return ft?.alarmMeeting ?? false
    }

    var alarmParty: Bool {
        return ft?.alarmParty ?? false
    }

    var alarmRest: Bool {
        return ft?.alarmRest ?? false
    }

    var alarmSleep: Bool {
        return ft?.alarmSleep ?? false
    }

    var alarmSport: Bool {
        return ft?.alarmSport ?? false
    }

    var alarmWakeUp: Bool {
        return ft?.alarmWakeUp ?? false
    }

    var supportSetAntilost: Bool {
        return ft?.supportSetAntilost ?? false
    }

    var supportSetWeatherDataV2: Bool {
        return ft?.supportSetWeatherDataV2 ?? false
    }

    var supportSetOnetouchCalling: Bool {
        return ft?.supportSetOnetouchCalling ?? false
    }

    var supportOperateSetSportScreen: Bool {
        return ft?.supportOperateSetSportScreen ?? false
    }

    var supportOperateListStyle: Bool {
        return ft?.supportOperateListStyle ?? false
    }

    var supportEmotionHealth: Bool {
        return ft?.supportEmotionHealth ?? false
    }

    var supportV3SyncContactVersion20: Bool {
        return ft?.supportV3SyncContactVersion20 ?? false
    }

    var supportGetSosCallRecord: Bool {
        return ft?.supportGetSosCallRecord ?? false
    }

    var alexaReminderAddSecV3: Bool {
        return ft?.alexaReminderAddSecV3 ?? false
    }

    var alexaSetEasyOperateV3: Bool {
        return ft?.alexaSetEasyOperateV3 ?? false
    }

    var alexaSetGetAlexaAlarmV3: Bool {
        return ft?.alexaSetGetAlexaAlarmV3 ?? false
    }

    var alexaSetJumpSportUiV3: Bool {
        return ft?.alexaSetJumpSportUiV3 ?? false
    }

    var alexaSetJumpUiV3: Bool {
        return ft?.alexaSetJumpUiV3 ?? false
    }

    var alexaSetSetOnOffTypeV3: Bool {
        return ft?.alexaSetSetOnOffTypeV3 ?? false
    }

    var alexaSetWeatherV3: Bool {
        return ft?.alexaSetWeatherV3 ?? false
    }

    var alexaTimeNewV3: Bool {
        return ft?.alexaTimeNewV3 ?? false
    }

    var setAlexaControll100brightness: Bool {
        return ft?.setAlexaControll100brightness ?? false
    }

    var alexaGetSupportGetAlexaDefaultLanguage: Bool {
        return ft?.alexaGetSupportGetAlexaDefaultLanguage ?? false
    }

    var alexaGetUIControllSports: Bool {
        return ft?.alexaGetUIControllSports ?? false
    }

    var getLeftRightHandWearSettings: Bool {
        return ft?.getLeftRightHandWearSettings ?? false
    }

    var supportSettingsDuringExercise: Bool {
        return ft?.supportSettingsDuringExercise ?? false
    }

    var supportHeightLengthUnit: Bool {
        return ft?.supportHeightLengthUnit ?? false
    }

    var supportSportingRemindSetting: Bool {
        return ft?.supportSportingRemindSetting ?? false
    }

    var supportSportGetAutoPauseEnd: Bool {
        return ft?.supportSportGetAutoPauseEnd ?? false
    }

    var supportSetStrideLengthUnit: Bool {
        return ft?.supportSetStrideLengthUnit ?? false
    }

    var supportSimpleHrZoneSetting: Bool {
        return ft?.supportSimpleHrZoneSetting ?? false
    }

    var notSupportSmartLowHeartReatRemind: Bool {
        return ft?.notSupportSmartLowHeartReatRemind ?? false
    }

    var notSupportSmartHighHeartReatRemind: Bool {
        return ft?.notSupportSmartHighHeartReatRemind ?? false
    }

    var notSupportPhotoPreviewControl: Bool {
        return ft?.notSupportPhotoPreviewControl ?? false
    }

    var supportGetUserInfo: Bool {
        return ft?.supportGetUserInfo ?? false
    }

    var supportMissedCallMsgTypeUseFixed: Bool {
        return ft?.supportMissedCallMsgTypeUseFixed ?? false
    }

    var supportAppNotDisplayAlarmName: Bool {
        return ft?.supportAppNotDisplayAlarmName ?? false
    }

    var supportSetSleepRemind: Bool {
        return ft?.supportSetSleepRemind ?? false
    }

    var supportBloodGlucose: Bool {
        return ft?.supportBloodGlucose ?? false
    }

    var supportBloodGlucoseV01: Bool {
        return ft?.supportBloodGlucoseV01 ?? false
    }

    var supportBikeLockManager: Bool {
        return ft?.supportBikeLockManager ?? false
    }

    var supportAlgorithmRawDataCollect: Bool {
        return ft?.supportAlgorithmRawDataCollect ?? false
    }

    var supportOfflineMapInformation: Bool {
        return ft?.supportOfflineMapInformation ?? false
    }

    var supportHeartRateReserveZones: Bool {
        return ft?.supportHeartRateReserveZones ?? false
    }

    var supportHeartRateZonesHrMaxSet: Bool {
        return ft?.supportHeartRateZonesHrMaxSet ?? false
    }

    var supportSyncMultiActivityNew: Bool {
        return ft?.supportSyncMultiActivityNew ?? false
    }

    var supportContactFileUseFirmwareReturnSize: Bool {
        return ft?.supportContactFileUseFirmwareReturnSize ?? false
    }

    var supportDisplayCameraEntry: Bool {
        return ft?.supportDisplayCameraEntry ?? false
    }

    var supportOperateFamilyCareReminder3376: Bool {
        return ft?.supportOperateFamilyCareReminder3376 ?? false
    }

    var supportProtocolV3MenstruationConfig3377: Bool {
        return ft?.supportProtocolV3MenstruationConfig3377 ?? false
    }

    var supportOperateHabitFormation: Bool {
        return ft?.supportOperateHabitFormation ?? false
    }

    var supportOperateHabitFormationV01: Bool {
        return ft?.supportOperateHabitFormationV01 ?? false
    }

    var supportOperateFamilySteps: Bool {
        return ft?.supportOperateFamilySteps ?? false
    }

    var supportOperateSetGame: Bool {
        return ft?.supportOperateSetGame ?? false
    }

    var supportOperateGestureControl: Bool {
        return ft?.supportOperateGestureControl ?? false
    }

}
