package com.idosmart.model

import com.google.gson.*

class FunctionTableModel(
    reminderAncs: Boolean,
    reminderSnapchat: Boolean,
    reminderLine: Boolean,
    reminderOutlook: Boolean,
    reminderTelegram: Boolean,
    reminderViber: Boolean,
    reminderVkontakte: Boolean,
    reminderChatwork: Boolean,
    reminderSlack: Boolean,
    reminderTumblr: Boolean,
    reminderYahooMail: Boolean,
    reminderYahooPinterest: Boolean,
    reminderYoutube: Boolean,
    reminderGmail: Boolean,
    reminderKakaoTalk: Boolean,
    reminderOnlyGoogleGmail: Boolean,
    reminderOnlyOutlookEmail: Boolean,
    reminderOnlyYahooEmail: Boolean,
    reminderTiktok: Boolean,
    reminderRedbus: Boolean,
    reminderDailyhunt: Boolean,
    reminderHotstar: Boolean,
    reminderInshorts: Boolean,
    reminderPaytm: Boolean,
    reminderAmazon: Boolean,
    reminderFlipkart: Boolean,
    reminderNhnEmail: Boolean,
    reminderInstantEmail: Boolean,
    reminderZohoEmail: Boolean,
    reminderExchangeEmail: Boolean,
    reminder189Email: Boolean,
    reminderVeryFit: Boolean,
    reminderGeneral: Boolean,
    reminderOther: Boolean,
    reminderMattersRemind: Boolean,
    reminderMicrosoft: Boolean,
    reminderMissedCall: Boolean,
    reminderGetAllContact: Boolean,
    reminderWhatsappBusiness: Boolean,
    reminderEmail: Boolean,
    reminderFacebook: Boolean,
    reminderMessage: Boolean,
    reminderQq: Boolean,
    reminderTwitter: Boolean,
    reminderWeixin: Boolean,
    reminderCalendarGoogle: Boolean,
    reminderInstagram: Boolean,
    reminderLinkedIn: Boolean,
    reminderMessengre: Boolean,
    reminderSkype: Boolean,
    reminderCalendar: Boolean,
    reminderWhatsapp: Boolean,
    reminderAlarmClock: Boolean,
    reminderSinaWeibo: Boolean,
    reminderWeibo: Boolean,
    reminderCalling: Boolean,
    reminderCallContact: Boolean,
    reminderCallNum: Boolean,
    reminderPrime: Boolean,
    reminderNetflix: Boolean,
    reminderGpay: Boolean,
    reminderPhonpe: Boolean,
    reminderSwiggy: Boolean,
    reminderZomato: Boolean,
    reminderMakemytrip: Boolean,
    reminderJioTv: Boolean,
    reminderNiosefit: Boolean,
    reminderYtmusic: Boolean,
    reminderUber: Boolean,
    reminderOla: Boolean,
    reminderGoogleMeet: Boolean,
    reminderMormaiiSmartwatch: Boolean,
    reminderTechnosConnect: Boolean,
    reminderEnjoei: Boolean,
    reminderAliexpress: Boolean,
    reminderShopee: Boolean,
    reminderTeams: Boolean,
    reminder99Taxi: Boolean,
    reminderUberEats: Boolean,
    reminderLfood: Boolean,
    reminderRappi: Boolean,
    reminderMercadoLivre: Boolean,
    reminderMagalu: Boolean,
    reminderAmericanas: Boolean,
    reminderYahoo: Boolean,
    reminderMessageIcon: Boolean,
    reminderTaobao: Boolean,
    reminderDingding: Boolean,
    reminderAlipay: Boolean,
    reminderToutiao: Boolean,
    reminderDouyin: Boolean,
    reminderTmall: Boolean,
    reminderJd: Boolean,
    reminderPinduoduo: Boolean,
    reminderBaidu: Boolean,
    reminderMeituan: Boolean,
    reminderEleme: Boolean,
    sportWalk: Boolean,
    sportRun: Boolean,
    sportByBike: Boolean,
    sportOnFoot: Boolean,
    sportSwim: Boolean,
    sportMountainClimbing: Boolean,
    sportBadminton: Boolean,
    sportOther: Boolean,
    sportFitness: Boolean,
    sportSpinning: Boolean,
    sportEllipsoid: Boolean,
    sportTreadmill: Boolean,
    sportSitUp: Boolean,
    sportPushUp: Boolean,
    sportDumbbell: Boolean,
    sportWeightlifting: Boolean,
    sportBodybuildingExercise: Boolean,
    sportYoga: Boolean,
    sportRopeSkipping: Boolean,
    sportTableTennis: Boolean,
    sportBasketball: Boolean,
    sportFootballl: Boolean,
    sportVolleyball: Boolean,
    sportTennis: Boolean,
    sportGolf: Boolean,
    sportBaseball: Boolean,
    sportSkiing: Boolean,
    sportRollerSkating: Boolean,
    sportDance: Boolean,
    sportStrengthTraining: Boolean,
    sportCoreTraining: Boolean,
    sportTidyUpRelax: Boolean,
    sportTraditionalStrengthTraining: Boolean,
    sportOutdoorRun: Boolean,
    sportIndoorRun: Boolean,
    sportOutdoorCycle: Boolean,
    sportIndoorCycle: Boolean,
    sportOutdoorWalk: Boolean,
    sportIndoorWalk: Boolean,
    sportPoolSwim: Boolean,
    sportOpenWaterSwim: Boolean,
    sportElliptical: Boolean,
    sportRower: Boolean,
    sportHiit: Boolean,
    sportCricket: Boolean,
    sportPilates: Boolean,
    sportOutdoorFun: Boolean,
    sportOtherActivity: Boolean,
    sportZumba: Boolean,
    sportSurfing: Boolean,
    sportFootvolley: Boolean,
    sportStandWaterSkiing: Boolean,
    sportBattlingRope: Boolean,
    sportSkateboard: Boolean,
    sportNoticeStepper: Boolean,
    sportShowNum: Int,
    sportAerobicsBodybuildingExercise: Boolean,
    sportPullUp: Boolean,
    sportHighBar: Boolean,
    sportParallelBars: Boolean,
    sportTrailRunning: Boolean,
    sportPickleBall: Boolean,
    sportSnowboard: Boolean,
    sportCrossCountrySkiing: Boolean,
    getRealtimeData: Boolean,
    getLangLibraryV3: Boolean,
    getFindPhone: Boolean,
    getFindDevice: Boolean,
    getUpHandGestureEx: Boolean,
    getUpHandGesture: Boolean,
    getWeather: Boolean,
    getDownloadLanguage: Boolean,
    getFactoryReset: Boolean,
    getFlashLog: Boolean,
    getMultiActivityNoUseApp: Boolean,
    getMultiDial: Boolean,
    getMenuList: Boolean,
    getDoNotDisturbMain3: Boolean,
    getVoiceTransmission: Boolean,
    setDrinkWaterAddNotifyFlag: Boolean,
    setSpo2LowValueRemindAddNotifyFlag: Boolean,
    notSupportSmartHeartNotifyFlag: Boolean,
    getDeviceLogState: Boolean,
    getNewWatchList: Boolean,
    getNotifyIconAdaptive: Boolean,
    getPressureNotifyFlagMode: Boolean,
    getScientificSleep: Boolean,
    getSpo2NotifyFlag: Boolean,
    getV3Log: Boolean,
    getWatchID: Boolean,
    getDeviceName: Boolean,
    getBatteryLog: Boolean,
    getBatteryInfo: Boolean,
    getHeatLog: Boolean,
    getWalkReminderV3: Boolean,
    getSupportV3BleMusic: Boolean,
    getSupportGetBleBeepV3: Boolean,
    getVeryFitNotSupportPhotoWallpaperV3: Boolean,
    getSupportUpdateGps: Boolean,
    getUbloxModel: Boolean,
    getSupportGetBleMusicInfoVerV3: Boolean,
    getBtVersion: Boolean,
    getSportsTypeV3: Boolean,
    getActivitySwitch: Boolean,
    getNoticeIconInformation: Boolean,
    getSetMaxItemsNum: Boolean,
    getNotifyMsgV3: Boolean,
    getScreenBrightnessMain9: Boolean,
    getNotice128byte: Boolean,
    getNotice250byte: Boolean,
    getDeletableMenuListV2: Boolean,
    getSupportPairEachConnect: Boolean,
    getSupportGetMainSportGoalV3: Boolean,
    getBtAddrV2: Boolean,
    getSupportBpSetOrMeasurementV2: Boolean,
    getMenstrualAddNotifyFlagV3: Boolean,
    getSupportSetGetTimeGoalTypeV2: Boolean,
    getOxygenDataSupportGradeV3: Boolean,
    getSupportSyncActivityDataAltitudeInfo: Boolean,
    getBindCodeAuth: Boolean,
    getSpo2OffChangeV3: Boolean,
    getLevel5HrInterval: Boolean,
    getFiveHRInterval: Boolean,
    getBleAndBtVersion: Boolean,
    getSupportSetGetEmergencyContactV3: Boolean,
    getSupportSetRepeatWeekTypeOnScheduleReminderV3: Boolean,
    getSupportSetRepeatTypeOnScheduleReminderV3: Boolean,
    getSupportSetMenstrualReminderOnOff: Boolean,
    getVersionInfo: Boolean,
    getMtu: Boolean,
    getDeviceUpdateState: Boolean,
    getHeartRateModeV2: Boolean,
    getStepDataTypeV2: Boolean,
    getFastMsgDataV3: Boolean,
    getSupportCallingQuickReply: Boolean,
    getSupportDataTranGetNewErrorCodeV3: Boolean,
    getAutoActivityEndSwitchNotDisplay: Boolean,
    getAutoActivityPauseSwitchNotDisplay: Boolean,
    getV3AutoActivitySwitch: Boolean,
    getAutoActivitySwitchAddBicycle: Boolean,
    getAutoActivitySwitchAddSmartRope: Boolean,
    getAutoActivitySetGetUseNewStructExchange: Boolean,
    getSupportSetGetNoReminderOnWalkReminderV2: Boolean,
    getSupportGetSnInfo: Boolean,
    getScheduleReminderNotDisplayTitle: Boolean,
    getSupportV3LongCityName: Boolean,
    getSupportAddNightLevelV2: Boolean,
    getSupportDialFrameEncodeFormatArgb6666: Boolean,
    getSupportAppSendPhoneSystemInfo: Boolean,
    getDeviceControlFastModeAlone: Boolean,
    getSupportOnekeyDoubleContact: Boolean,
    getSupportSetVoiceAssistantStatus: Boolean,
    getSupportFlashLogSize: Boolean,
    supportDevReturnMeasuringValue: Boolean,
    getSupportGetUnit: Boolean,
    getSupportRyzeConnect: Boolean,
    getSupportLoopsFit: Boolean,
    getSupportTasSmart: Boolean,
    getNotSupportSetOvulation: Boolean,
    getSupportWalkGoalSteps: Boolean,
    getNotSupportDeleteAddSportSort: Boolean,
    getSupportSedentaryTensileHabitInfo: Boolean,
    getSupportSendGpsLongitudeAndLatitude: Boolean,
    getSupportGetV3DeviceBtConnectPhoneModel: Boolean,
    getSupportBloodPressureModelFileUpdate: Boolean,
    getSupportDisturbHaveRangRepeat: Boolean,
    getSupportCalendarReminder: Boolean,
    getWatchDailSetAddSize: Boolean,
    getSupportSyncOverHighLowHeartData: Boolean,
    getSupportPerMinuteOne: Boolean,
    getSupportAchievedRemindOnOff: Boolean,
    getSupportDrinkPlan: Boolean,
    getSupportMakeWatchDialDecodeJpg: Boolean,
    getSupportSleepPlan: Boolean,
    getSupportDeviceOperateAlgFile: Boolean,
    getSupportSportRecordShowConfig: Boolean,
    setNoticeMessageStateUseVersion0x20: Boolean,
    setScientificSleepSwitch: Boolean,
    setTemperatureSwitchHealth: Boolean,
    setHeartRateMonitor: Boolean,
    setNoReminderOnDrinkReminder: Boolean,
    setAgpsOffLine: Boolean,
    setAgpsOnLine: Boolean,
    setSetV3HeartInterval: Boolean,
    setWeatherCity: Boolean,
    setDoNotDisturb: Boolean,
    setCalorieGoal: Boolean,
    setMenstruation: Boolean,
    setPressureData: Boolean,
    setSpo2Data: Boolean,
    setSportModeSort: Boolean,
    setActivitySwitch: Boolean,
    setNightAutoBrightness: Boolean,
    setScreenBrightness5Level: Boolean,
    setWalkReminder: Boolean,
    setScreenBrightness3Level: Boolean,
    setHandWashReminder: Boolean,
    setLocalDial: Boolean,
    setNotSupportHrHighAlarm: Boolean,
    setNotSupportPhotoWallpaper: Boolean,
    setPressureHighReminder: Boolean,
    setWallpaperOnlyTimeColor: Boolean,
    setWallpaperDial: Boolean,
    setSupportBreathRate: Boolean,
    setSupportCalorieUnit: Boolean,
    setSupportSportPlan: Boolean,
    setSupportSwimPoolUnit: Boolean,
    setSupportV3Bp: Boolean,
    setV3GetSportSortField: Boolean,
    setWatchDialSort: Boolean,
    setGetCalorieDistanceGoal: Boolean,
    setMidHighTimeGoal: Boolean,
    setNewRetainData: Boolean,
    setScheduleReminder: Boolean,
    setSet100SportSort: Boolean,
    setSet20SportParamSort: Boolean,
    setSetMainUiSort: Boolean,
    setSetStressCalibration: Boolean,
    setSmartHeartRate: Boolean,
    setSpo2AllDayOnOff: Boolean,
    setSupportAppSendVoiceToBle: Boolean,
    setSupportCyclingUnit: Boolean,
    setSupportWalkRunUnit: Boolean,
    setWalkReminderTimeGoal: Boolean,
    setWatchCapacitySizeDisplay: Boolean,
    setWatchPhotoPositionMove: Boolean,
    setMenuListMain7: Boolean,
    setHistoryMenstrual: Boolean,
    supportHistoricalMenstruationExchange: Boolean,
    supportSetHistoricalMenstruationExchangeVersion21: Boolean,
    supportHistoricalMenstruationExchangeVersion31: Boolean,
    supportPhysiologicalRecord: Boolean,
    setMenstrualAddPregnancy: Boolean,
    setNotSurportCalling3SDelay: Boolean,
    setSetFitnessGuidance: Boolean,
    setSetNotificationStatus: Boolean,
    setSetUnreadAppReminder: Boolean,
    setSetV3Weather: Boolean,
    setSetV3WeatherSunrise: Boolean,
    setSetV3WorldTime: Boolean,
    setSyncContact: Boolean,
    setSyncV3ActivityAddParam: Boolean,
    setTransferMusicFile: Boolean,
    setWalkReminderAddNotify: Boolean,
    setSupportFahrenheit: Boolean,
    setGetAlarmSpecify: Boolean,
    setAirohaGpsChip: Boolean,
    setSupportSecondSportIcon: Boolean,
    setSportMediumIcon: Boolean,
    setWeatherSunTime: Boolean,
    setWeatherAirGrade: Boolean,
    setDrinkWaterReminder: Boolean,
    supportBatteryReminderSwitch: Boolean,
    supportPetInfo: Boolean,
    setRespirationRate: Boolean,
    setMaxBloodOxygen: Boolean,
    setBleControlMusic: Boolean,
    setMainPressure: Boolean,
    setNoDisturbAllDayOnOff: Boolean,
    setOnlyNoDisturbAllDayOnOff: Boolean,
    setOnlyNoDisturbSmartOnOff: Boolean,
    setTimeZoneFloat: Boolean,
    setTemperatureSwitchSupport: Boolean,
    setMsgAllSwitch: Boolean,
    setNotSupperCall3Delay: Boolean,
    setNoticeMissedCallV2: Boolean,
    setOverFindPhone: Boolean,
    getHealthSwitchStateSupportV3: Boolean,
    setSedentariness: Boolean,
    setScreenBrightness: Boolean,
    setSetPhoneVoice: Boolean,
    setSupportSetCallQuickReplyOnOff: Boolean,
    setSupportExchangeSetGpsCoordinates: Boolean,
    setSupportV3WeatherAddAtmosphericPressure: Boolean,
    setSupportSetV3WeatcherAddSnowDepth: Boolean,
    setSupportSetV3WeatcherAddSnowfall: Boolean,
    setSupportSetV3WeatcherSendStructVersion04: Boolean,
    setSendCalibrationThreshold: Boolean,
    getNotSupportAppSendRunPlan: Boolean,
    getSupportDisplayNapSleep: Boolean,
    getSupportGetSmartHeartRate: Boolean,
    getSupportGetPressureSwitchInfo: Boolean,
    getSupportECardOperate: Boolean,
    getSupportVoiceMemoOperate: Boolean,
    getSupportMorningEdition: Boolean,
    getSupportGetSpo2SwitchInfo: Boolean,
    getSupportSyncHealthHrUseVersionCompatible: Boolean,
    getSupportSetV3Add48HourWeatherData: Boolean,
    getNotSupportIndoorRunGetVo2max: Boolean,
    getSupportSetEcgReminder: Boolean,
    getSupportSyncEcg: Boolean,
    getSupportSetGameTimeReminder: Boolean,
    getSupportConfigDefaultMegApplicationList: Boolean,
    getSupportSetEciReminder: Boolean,
    setSupportNoiseSetNotifyFlag: Boolean,
    setSupportNoiseSetOverWarning: Boolean,
    setSupportSetVersionInformation: Boolean,
    setSupportControlMiniProgram: Boolean,
    getSupportSetWeatherHistoryFutureAqi: Boolean,
    setBrightScreenTime: Boolean,
    setHeartSetRateModeCustom: Boolean,
    supportProtocolV3MenuList: Boolean,
    languageCh: Boolean,
    languageCzech: Boolean,
    languageEnglish: Boolean,
    languageFrench: Boolean,
    languageGerman: Boolean,
    languageItalian: Boolean,
    languageJapanese: Boolean,
    languageSpanish: Boolean,
    languageArabic: Boolean,
    languageBurmese: Boolean,
    languageFilipino: Boolean,
    languageGreek: Boolean,
    languageThai: Boolean,
    languageTraditionalChinese: Boolean,
    languageVietnamese: Boolean,
    languageDutch: Boolean,
    languageHungarian: Boolean,
    languageLithuanian: Boolean,
    languagePolish: Boolean,
    languageRomanian: Boolean,
    languageRussian: Boolean,
    languageSlovenian: Boolean,
    languageUkrainian: Boolean,
    languageCroatian: Boolean,
    languageDanish: Boolean,
    languageHindi: Boolean,
    languageIndonesian: Boolean,
    languageKorean: Boolean,
    languagePortuguese: Boolean,
    languageSlovak: Boolean,
    languageTurkish: Boolean,
    languagePersia: Boolean,
    languageSweden: Boolean,
    languageNorwegian: Boolean,
    languageFinland: Boolean,
    languageBengali: Boolean,
    languageKhmer: Boolean,
    languageMalay: Boolean,
    languageBrazilianPortuguese: Boolean,
    languageHebrew: Boolean,
    languageSerbian: Boolean,
    languageBulgaria: Boolean,
    syncV3Hr: Boolean,
    syncV3Swim: Boolean,
    syncV3Spo2: Boolean,
    syncV3Pressure: Boolean,
    syncV3Activity: Boolean,
    syncV3Sleep: Boolean,
    syncV3PetSleep: Boolean,
    syncV3Sports: Boolean,
    syncV3Gps: Boolean,
    syncV3SyncAlarm: Boolean,
    syncV3BodyPower: Boolean,
    getSupportHrvV3: Boolean,
    getSupportPerBpV3: Boolean,
    syncV3Noise: Boolean,
    syncV3Temperature: Boolean,
    syncGps: Boolean,
    syncV3ActivityExchangeData: Boolean,
    syncHeartRate: Boolean,
    syncHeartRateMonitor: Boolean,
    syncSleepMonitor: Boolean,
    syncFastSync: Boolean,
    syncActivityTimeSync: Boolean,
    syncTimeLine: Boolean,
    syncNeedV2: Boolean,
    syncRealTimeV3: Boolean,
    syncExchangeDataReplyAddRealTimeSpeedPaceV3: Boolean,
    syncHealthSyncV3ActivityEndTimeUseUtcMode: Boolean,
    syncSupportSetFastModeWhenSyncConfig: Boolean,
    getSupportAppBaseInformation: Boolean,
    alarmCount: Int,
    alarmBrushTeeth: Boolean,
    alarmDating: Boolean,
    alarmDinner: Boolean,
    alarmMedicine: Boolean,
    alarmMeeting: Boolean,
    alarmParty: Boolean,
    alarmRest: Boolean,
    alarmSleep: Boolean,
    alarmSport: Boolean,
    alarmWakeUp: Boolean,
    supportSetAntilost: Boolean,
    supportSetWeatherDataV2: Boolean,
    supportSetOnetouchCalling: Boolean,
    supportOperateSetSportScreen: Boolean,
    supportOperateListStyle: Boolean,
    supportEmotionHealth: Boolean,
    supportV3SyncContactVersion20: Boolean,
    supportGetSosCallRecord: Boolean,
    alexaReminderAddSecV3: Boolean,
    alexaSetEasyOperateV3: Boolean,
    alexaSetGetAlexaAlarmV3: Boolean,
    alexaSetJumpSportUiV3: Boolean,
    alexaSetJumpUiV3: Boolean,
    alexaSetSetOnOffTypeV3: Boolean,
    alexaSetWeatherV3: Boolean,
    alexaTimeNewV3: Boolean,
    setAlexaControll100brightness: Boolean,
    alexaGetSupportGetAlexaDefaultLanguage: Boolean,
    alexaGetUIControllSports: Boolean,
    getLeftRightHandWearSettings: Boolean,
    supportSettingsDuringExercise: Boolean,
    supportHeightLengthUnit: Boolean,
    supportSportingRemindSetting: Boolean,
    supportSportGetAutoPauseEnd: Boolean,
    supportSetStrideLengthUnit: Boolean,
    supportSimpleHrZoneSetting: Boolean,
    notSupportSmartLowHeartReatRemind: Boolean,
    notSupportSmartHighHeartReatRemind: Boolean,
    notSupportPhotoPreviewControl: Boolean,
    supportGetUserInfo: Boolean,
    supportMissedCallMsgTypeUseFixed: Boolean,
    supportAppNotDisplayAlarmName: Boolean,
    supportSetSleepRemind: Boolean,
    supportBloodGlucose: Boolean,
    supportBloodGlucoseV01: Boolean,
    supportBikeLockManager: Boolean,
    supportAlgorithmRawDataCollect: Boolean,
    supportOfflineMapInformation: Boolean,
    supportHeartRateReserveZones: Boolean,
    supportHeartRateZonesHrMaxSet: Boolean,
    supportSyncMultiActivityNew: Boolean,
    supportContactFileUseFirmwareReturnSize: Boolean,
    supportDisplayCameraEntry: Boolean,
    supportOperateFamilyCareReminder3376: Boolean,
    supportProtocolV3MenstruationConfig3377: Boolean,
    supportOperateHabitFormation: Boolean,
    supportOperateHabitFormationV01: Boolean,
    supportOperateFamilySteps: Boolean,
    supportOperateSetGame: Boolean,
    supportOperateGestureControl: Boolean
) : IDOBaseModel {
    
    /// 智能通知
    var reminderAncs: Boolean = reminderAncs
    /// Snapchat
    var reminderSnapchat: Boolean = reminderSnapchat
    /// Line
    var reminderLine: Boolean = reminderLine
    /// Outlook
    var reminderOutlook: Boolean = reminderOutlook
    /// Telegram
    var reminderTelegram: Boolean = reminderTelegram
    /// Viber
    var reminderViber: Boolean = reminderViber
    /// Vkontakte
    var reminderVkontakte: Boolean = reminderVkontakte
    /// Chatwork;
    var reminderChatwork: Boolean = reminderChatwork
    /// Slack
    var reminderSlack: Boolean = reminderSlack
    /// Tumblr
    var reminderTumblr: Boolean = reminderTumblr
    /// YahooMail
    var reminderYahooMail: Boolean = reminderYahooMail
    /// YahooPinterest
    var reminderYahooPinterest: Boolean = reminderYahooPinterest
    /// Youtube
    var reminderYoutube: Boolean = reminderYoutube
    /// Gmail
    var reminderGmail: Boolean = reminderGmail
    /// KakaoTalk
    var reminderKakaoTalk: Boolean = reminderKakaoTalk
    /// Google gmail
    var reminderOnlyGoogleGmail: Boolean = reminderOnlyGoogleGmail
    /// Outlook email
    var reminderOnlyOutlookEmail: Boolean = reminderOnlyOutlookEmail
    /// Yahoo email
    var reminderOnlyYahooEmail: Boolean = reminderOnlyYahooEmail
    /// Tiktok
    var reminderTiktok: Boolean = reminderTiktok
    /// Redbus
    var reminderRedbus: Boolean = reminderRedbus
    /// Dailyhunt
    var reminderDailyhunt: Boolean = reminderDailyhunt
    /// Hotstar
    var reminderHotstar: Boolean = reminderHotstar
    /// Inshorts
    var reminderInshorts: Boolean = reminderInshorts
    /// Paytm
    var reminderPaytm: Boolean = reminderPaytm
    /// Amazon
    var reminderAmazon: Boolean = reminderAmazon
    /// Flipkart
    var reminderFlipkart: Boolean = reminderFlipkart
    /// Nhn email
    var reminderNhnEmail: Boolean = reminderNhnEmail
    /// Instant email
    var reminderInstantEmail: Boolean = reminderInstantEmail
    /// Zoho email
    var reminderZohoEmail: Boolean = reminderZohoEmail
    /// Exchange email
    var reminderExchangeEmail: Boolean = reminderExchangeEmail
    /// 189 email
    var reminder189Email: Boolean = reminder189Email
    /// Very fit
    var reminderVeryFit: Boolean = reminderVeryFit
    /// General
    var reminderGeneral: Boolean = reminderGeneral
    /// other
    var reminderOther: Boolean = reminderOther
    /// Matters
    var reminderMattersRemind: Boolean = reminderMattersRemind
    /// Microsoft
    var reminderMicrosoft: Boolean = reminderMicrosoft
    /// MissedCalls
    var reminderMissedCall: Boolean = reminderMissedCall
    /// 支持同步全部通讯录
    var reminderGetAllContact: Boolean = reminderGetAllContact
    /// WhatsappBusiness
    var reminderWhatsappBusiness: Boolean = reminderWhatsappBusiness
    /// Email
    var reminderEmail: Boolean = reminderEmail
    /// Facebook
    var reminderFacebook: Boolean = reminderFacebook
    /// Message
    var reminderMessage: Boolean = reminderMessage
    /// QQ
    var reminderQq: Boolean = reminderQq
    /// Twitter
    var reminderTwitter: Boolean = reminderTwitter
    /// Weixin
    var reminderWeixin: Boolean = reminderWeixin
    /// Calendar (Google日历）
    var reminderCalendarGoogle: Boolean = reminderCalendarGoogle
    /// Instagram
    var reminderInstagram: Boolean = reminderInstagram
    /// linkedIn
    var reminderLinkedIn: Boolean = reminderLinkedIn
    /// Messengre
    var reminderMessengre: Boolean = reminderMessengre
    /// Skype
    var reminderSkype: Boolean = reminderSkype
    /// Calendar
    var reminderCalendar: Boolean = reminderCalendar
    /// Whatsapp
    var reminderWhatsapp: Boolean = reminderWhatsapp
    /// Alarm clock
    var reminderAlarmClock: Boolean = reminderAlarmClock
    /// 新浪微博
    var reminderSinaWeibo: Boolean = reminderSinaWeibo
    /// 国内版微博
    var reminderWeibo: Boolean = reminderWeibo
    /// 来电提醒
    var reminderCalling: Boolean = reminderCalling
    /// 来电联系人
    var reminderCallContact: Boolean = reminderCallContact
    /// 来电号码
    var reminderCallNum: Boolean = reminderCallNum
    /// Prime
    var reminderPrime: Boolean = reminderPrime
    /// Netflix
    var reminderNetflix: Boolean = reminderNetflix
    /// Gpay
    var reminderGpay: Boolean = reminderGpay
    /// Phonpe
    var reminderPhonpe: Boolean = reminderPhonpe
    /// Swiggy
    var reminderSwiggy: Boolean = reminderSwiggy
    /// Zomato
    var reminderZomato: Boolean = reminderZomato
    /// Makemytrip
    var reminderMakemytrip: Boolean = reminderMakemytrip
    /// JioTv
    var reminderJioTv: Boolean = reminderJioTv
    /// Niosefit
    var reminderNiosefit: Boolean = reminderNiosefit
    /// YT music
    var reminderYtmusic: Boolean = reminderYtmusic
    /// Uber
    var reminderUber: Boolean = reminderUber
    /// Ola
    var reminderOla: Boolean = reminderOla
    /// Google meet
    var reminderGoogleMeet: Boolean = reminderGoogleMeet
    /// Mormaii Smartwatch
    var reminderMormaiiSmartwatch: Boolean = reminderMormaiiSmartwatch
    /// Technos connect
    var reminderTechnosConnect: Boolean = reminderTechnosConnect
    /// Enjoei
    var reminderEnjoei: Boolean = reminderEnjoei
    /// Aliexpress
    var reminderAliexpress: Boolean = reminderAliexpress
    /// Shopee
    var reminderShopee: Boolean = reminderShopee
    /// Teams
    var reminderTeams: Boolean = reminderTeams
    /// 99 taxi
    var reminder99Taxi: Boolean = reminder99Taxi
    /// Uber eats
    var reminderUberEats: Boolean = reminderUberEats
    /// Lfood
    var reminderLfood: Boolean = reminderLfood
    /// Rappi
    var reminderRappi: Boolean = reminderRappi
    /// Mercado livre
    var reminderMercadoLivre: Boolean = reminderMercadoLivre
    /// Magalu
    var reminderMagalu: Boolean = reminderMagalu
    /// Americanas
    var reminderAmericanas: Boolean = reminderAmericanas
    /// Yahoo
    var reminderYahoo: Boolean = reminderYahoo
    /// 消息图标和名字更新
    var reminderMessageIcon: Boolean = reminderMessageIcon
    /// 淘宝
    var reminderTaobao: Boolean = reminderTaobao
    /// 钉钉
    var reminderDingding: Boolean = reminderDingding
    /// 支付宝
    var reminderAlipay: Boolean = reminderAlipay
    /// 今日头条
    var reminderToutiao: Boolean = reminderToutiao
    /// 抖音
    var reminderDouyin: Boolean = reminderDouyin
    /// 天猫
    var reminderTmall: Boolean = reminderTmall
    /// 京东
    var reminderJd: Boolean = reminderJd
    /// 拼多多
    var reminderPinduoduo: Boolean = reminderPinduoduo
    /// 百度
    var reminderBaidu: Boolean = reminderBaidu
    /// 美团
    var reminderMeituan: Boolean = reminderMeituan
    /// 饿了么
    var reminderEleme: Boolean = reminderEleme
    /// v2 走路
    var sportWalk: Boolean = sportWalk
    /// v2 跑步
    var sportRun: Boolean = sportRun
    /// v2 骑行
    var sportByBike: Boolean = sportByBike
    /// v2 徒步
    var sportOnFoot: Boolean = sportOnFoot
    /// v2 游泳
    var sportSwim: Boolean = sportSwim
    /// v2 爬山
    var sportMountainClimbing: Boolean = sportMountainClimbing
    /// v2 羽毛球
    var sportBadminton: Boolean = sportBadminton
    /// v2 其他
    var sportOther: Boolean = sportOther
    /// v2 健身
    var sportFitness: Boolean = sportFitness
    /// v2 动感单车
    var sportSpinning: Boolean = sportSpinning
    /// v2 椭圆球
    var sportEllipsoid: Boolean = sportEllipsoid
    /// v2 跑步机
    var sportTreadmill: Boolean = sportTreadmill
    /// v2 仰卧起坐
    var sportSitUp: Boolean = sportSitUp
    /// v2 俯卧撑
    var sportPushUp: Boolean = sportPushUp
    /// v2 哑铃
    var sportDumbbell: Boolean = sportDumbbell
    /// v2 举重
    var sportWeightlifting: Boolean = sportWeightlifting
    /// v2 健身操
    var sportBodybuildingExercise: Boolean = sportBodybuildingExercise
    /// v2 瑜伽
    var sportYoga: Boolean = sportYoga
    /// v2 跳绳
    var sportRopeSkipping: Boolean = sportRopeSkipping
    /// v2 乒乓球
    var sportTableTennis: Boolean = sportTableTennis
    /// v2 篮球
    var sportBasketball: Boolean = sportBasketball
    /// v2 足球
    var sportFootballl: Boolean = sportFootballl
    /// v2 排球
    var sportVolleyball: Boolean = sportVolleyball
    /// v2 网球
    var sportTennis: Boolean = sportTennis
    /// v2 高尔夫
    var sportGolf: Boolean = sportGolf
    /// v2 棒球
    var sportBaseball: Boolean = sportBaseball
    /// v2 滑雪
    var sportSkiing: Boolean = sportSkiing
    /// v2 轮滑
    var sportRollerSkating: Boolean = sportRollerSkating
    /// v2 跳舞
    var sportDance: Boolean = sportDance
    /// v2 功能性训练
    var sportStrengthTraining: Boolean = sportStrengthTraining
    /// v2 核心训练
    var sportCoreTraining: Boolean = sportCoreTraining
    /// v2 整体放松
    var sportTidyUpRelax: Boolean = sportTidyUpRelax
    /// v2 传统的力量训练
    var sportTraditionalStrengthTraining: Boolean = sportTraditionalStrengthTraining
    /// v3 户外跑步
    var sportOutdoorRun: Boolean = sportOutdoorRun
    /// v3 室内跑步
    var sportIndoorRun: Boolean = sportIndoorRun
    /// v3 户外骑行
    var sportOutdoorCycle: Boolean = sportOutdoorCycle
    /// v3 室内骑行
    var sportIndoorCycle: Boolean = sportIndoorCycle
    /// v3 户外走路
    var sportOutdoorWalk: Boolean = sportOutdoorWalk
    /// v3 室内走路
    var sportIndoorWalk: Boolean = sportIndoorWalk
    /// v3 泳池游泳
    var sportPoolSwim: Boolean = sportPoolSwim
    /// v3 开放水域游泳
    var sportOpenWaterSwim: Boolean = sportOpenWaterSwim
    /// v3 椭圆机
    var sportElliptical: Boolean = sportElliptical
    /// v3 划船机
    var sportRower: Boolean = sportRower
    /// v3 高强度间歇训练法
    var sportHiit: Boolean = sportHiit
    /// v3 板球运动
    var sportCricket: Boolean = sportCricket
    /// v3 普拉提
    var sportPilates: Boolean = sportPilates
    /// v3 户外玩耍（定制 kr01）
    var sportOutdoorFun: Boolean = sportOutdoorFun
    /// v3 其他运动（定制 kr01）
    var sportOtherActivity: Boolean = sportOtherActivity
    /// v3 尊巴舞
    var sportZumba: Boolean = sportZumba
    /// v3 冲浪
    var sportSurfing: Boolean = sportSurfing
    /// v3 足排球
    var sportFootvolley: Boolean = sportFootvolley
    /// v3 站立滑水
    var sportStandWaterSkiing: Boolean = sportStandWaterSkiing
    /// v3 站绳
    var sportBattlingRope: Boolean = sportBattlingRope
    /// v3 滑板
    var sportSkateboard: Boolean = sportSkateboard
    /// v3 踏步机
    var sportNoticeStepper: Boolean = sportNoticeStepper
    /// 运动显示个数
    var sportShowNum: Int = sportShowNum
    /// 有氧健身操
    var sportAerobicsBodybuildingExercise: Boolean = sportAerobicsBodybuildingExercise
    /// 引体向上
    var sportPullUp: Boolean = sportPullUp
    /// 单杠
    var sportHighBar: Boolean = sportHighBar
    /// 双杠
    var sportParallelBars: Boolean = sportParallelBars
    /// 越野跑
    var sportTrailRunning: Boolean = sportTrailRunning
    /// 匹克球
    var sportPickleBall: Boolean = sportPickleBall
    /// 滑板
    var sportSnowboard: Boolean = sportSnowboard
    /// 越野滑板
    var sportCrossCountrySkiing: Boolean = sportCrossCountrySkiing
    /// 获取实时数据
    var getRealtimeData: Boolean = getRealtimeData
    /// 获取v3语言库
    var getLangLibraryV3: Boolean = getLangLibraryV3
    /// 查找手机
    var getFindPhone: Boolean = getFindPhone
    /// 查找设备
    var getFindDevice: Boolean = getFindDevice
    /// 抬腕亮屏数据获取
    var getUpHandGestureEx: Boolean = getUpHandGestureEx
    /// 抬腕亮屏
    var getUpHandGesture: Boolean = getUpHandGesture
    /// 天气预报
    var getWeather: Boolean = getWeather
    /// 可下载语言
    var getDownloadLanguage: Boolean = getDownloadLanguage
    /// 恢复出厂设置
    var getFactoryReset: Boolean = getFactoryReset
    /// Flash log
    var getFlashLog: Boolean = getFlashLog
    /// 多运动不能使用app
    var getMultiActivityNoUseApp: Boolean = getMultiActivityNoUseApp
    /// 多表盘
    var getMultiDial: Boolean = getMultiDial
    /// 获取菜单列表
    var getMenuList: Boolean = getMenuList
    /// 请勿打扰
    var getDoNotDisturbMain3: Boolean = getDoNotDisturbMain3
    /// 语音功能
    var getVoiceTransmission: Boolean = getVoiceTransmission
    /// 设置喝水开关通知类型
    var setDrinkWaterAddNotifyFlag: Boolean = setDrinkWaterAddNotifyFlag
    /// 血氧过低提醒通知提醒类型
    var setSpo2LowValueRemindAddNotifyFlag: Boolean = setSpo2LowValueRemindAddNotifyFlag
    /// 智能心率提醒通知提醒类型
    var notSupportSmartHeartNotifyFlag: Boolean = notSupportSmartHeartNotifyFlag
    /// 获取重启日志错误码和标志位
    var getDeviceLogState: Boolean = getDeviceLogState
    /// 支持获取表盘列表的接口
    var getNewWatchList: Boolean = getNewWatchList
    /// 消息提醒图标自适应
    var getNotifyIconAdaptive: Boolean = getNotifyIconAdaptive
    /// 压力开关增加通知类型和全天压力模式设置
    var getPressureNotifyFlagMode: Boolean = getPressureNotifyFlagMode
    /// 科学睡眠
    var getScientificSleep: Boolean = getScientificSleep
    /// 血氧开关增加通知类型
    var getSpo2NotifyFlag: Boolean = getSpo2NotifyFlag
    /// v3 收集log
    var getV3Log: Boolean = getV3Log
    /// 获取表盘ID
    var getWatchID: Boolean = getWatchID
    /// 获取设备名称
    var getDeviceName: Boolean = getDeviceName
    /// 获取电池日志
    var getBatteryLog: Boolean = getBatteryLog
    /// 获取电池信息
    var getBatteryInfo: Boolean = getBatteryInfo
    /// 获取过热日志
    var getHeatLog: Boolean = getHeatLog
    /// 获取走动提醒 v3
    var getWalkReminderV3: Boolean = getWalkReminderV3
    /// 获取支持蓝牙音乐 v3
    var getSupportV3BleMusic: Boolean = getSupportV3BleMusic
    /// 支持获取固件本地提示音文件信息
    var getSupportGetBleBeepV3: Boolean = getSupportGetBleBeepV3
    /// BIT1 k6项目不需要对应的壁纸表盘，veryFit默认的都是支持的，新加一个不支持的功能表，不需要的配置这个
    var getVeryFitNotSupportPhotoWallpaperV3: Boolean = getVeryFitNotSupportPhotoWallpaperV3
    /// 支持升级gps固件
    var getSupportUpdateGps: Boolean = getSupportUpdateGps
    /// 支持ublox模块
    var getUbloxModel: Boolean = getUbloxModel
    /// 支持获取固件歌曲名和文件夹指令下发和固件回复使用协议版本号0x10
    var getSupportGetBleMusicInfoVerV3: Boolean = getSupportGetBleMusicInfoVerV3
    /// 获得固件三级版本和BT的三级版本
    var getBtVersion: Boolean = getBtVersion
    /// V3的运动类型设置和获取
    var getSportsTypeV3: Boolean = getSportsTypeV3
    /// 支持运动模式识别开关获取
    var getActivitySwitch: Boolean = getActivitySwitch
    /// 支持动态消息图标更新
    var getNoticeIconInformation: Boolean = getNoticeIconInformation
    /// 支持获取固件支持app下发的详情的最大数量
    var getSetMaxItemsNum: Boolean = getSetMaxItemsNum
    /// v3 消息提醒
    var getNotifyMsgV3: Boolean = getNotifyMsgV3
    /// 获取屏幕亮度
    var getScreenBrightnessMain9: Boolean = getScreenBrightnessMain9
    /// 128个字节通知
    var getNotice128byte: Boolean = getNotice128byte
    /// 250个字节通知
    var getNotice250byte: Boolean = getNotice250byte
    /// 支持获取不可删除的快捷应用列表
    var getDeletableMenuListV2: Boolean = getDeletableMenuListV2
    /// 设置支持系统配对
    var getSupportPairEachConnect: Boolean = getSupportPairEachConnect
    /// 支持获取运动目标
    var getSupportGetMainSportGoalV3: Boolean = getSupportGetMainSportGoalV3
    /// 取bt蓝牙MAC地址
    var getBtAddrV2: Boolean = getBtAddrV2
    /// 血压校准与测量
    var getSupportBpSetOrMeasurementV2: Boolean = getSupportBpSetOrMeasurementV2
    /// 生理周期开关增加通知类型
    var getMenstrualAddNotifyFlagV3: Boolean = getMenstrualAddNotifyFlagV3
    /// 设置获取运动三环周目标
    var getSupportSetGetTimeGoalTypeV2: Boolean = getSupportSetGetTimeGoalTypeV2
    /// 多运动同步数据支持摄氧量等级数据
    var getOxygenDataSupportGradeV3: Boolean = getOxygenDataSupportGradeV3
    /// 多运动数据同步支持海拔高度数据
    var getSupportSyncActivityDataAltitudeInfo: Boolean = getSupportSyncActivityDataAltitudeInfo
    /// 绑定授权码
    var getBindCodeAuth: Boolean = getBindCodeAuth
    /// V3血氧数据 偏移按照分钟偏移
    var getSpo2OffChangeV3: Boolean = getSpo2OffChangeV3
    /// 5级心率区间
    var getLevel5HrInterval: Boolean = getLevel5HrInterval
    /// 5个心率区间
    var getFiveHRInterval: Boolean = getFiveHRInterval
    /// 获得固件三级版本和BT的3级版本
    var getBleAndBtVersion: Boolean = getBleAndBtVersion
    /// 紧急联系人
    var getSupportSetGetEmergencyContactV3: Boolean = getSupportSetGetEmergencyContactV3
    /// 重复提醒类型设置星期重复
    var getSupportSetRepeatWeekTypeOnScheduleReminderV3: Boolean = getSupportSetRepeatWeekTypeOnScheduleReminderV3
    /// 重复提醒类型设置
    var getSupportSetRepeatTypeOnScheduleReminderV3: Boolean = getSupportSetRepeatTypeOnScheduleReminderV3
    /// 经期开关
    var getSupportSetMenstrualReminderOnOff: Boolean = getSupportSetMenstrualReminderOnOff
    /// 版本信息
    var getVersionInfo: Boolean = getVersionInfo
    /// 获取MTU
    var getMtu: Boolean = getMtu
    /// 获取手环的升级状态
    var getDeviceUpdateState: Boolean = getDeviceUpdateState
    /// v2获取心率监测模式
    var getHeartRateModeV2: Boolean = getHeartRateModeV2
    /// 目标步数类型为周目标
    var getStepDataTypeV2: Boolean = getStepDataTypeV2
    /// 快速消息
    var getFastMsgDataV3: Boolean = getFastMsgDataV3
    /// 支持快速回复
    var getSupportCallingQuickReply: Boolean = getSupportCallingQuickReply
    /// 新错误码 v3
    var getSupportDataTranGetNewErrorCodeV3: Boolean = getSupportDataTranGetNewErrorCodeV3
    /// 运动自识别结束开关不展示，设置开关状态
    var getAutoActivityEndSwitchNotDisplay: Boolean = getAutoActivityEndSwitchNotDisplay
    /// 运动自识别暂停开关不展示，设置开关状态
    var getAutoActivityPauseSwitchNotDisplay: Boolean = getAutoActivityPauseSwitchNotDisplay
    /// 运动模式自动识别开关设置获取 新增类型椭圆机 划船机 游泳
    var getV3AutoActivitySwitch: Boolean = getV3AutoActivitySwitch
    /// 运动模式自动识别开关设置获取 新增类型骑行
    var getAutoActivitySwitchAddBicycle: Boolean = getAutoActivitySwitchAddBicycle
    /// 运动模式自动识别开关设置获取 新增类型智能跳绳
    var getAutoActivitySwitchAddSmartRope: Boolean = getAutoActivitySwitchAddSmartRope
    /// 运动自识别获取和设置指令使用新的版本与固件交互
    var getAutoActivitySetGetUseNewStructExchange: Boolean = getAutoActivitySetGetUseNewStructExchange
    /// 支持走动提醒设置/获取免提醒时间段
    var getSupportSetGetNoReminderOnWalkReminderV2: Boolean = getSupportSetGetNoReminderOnWalkReminderV2
    /// 支持获取sn信息
    var getSupportGetSnInfo: Boolean = getSupportGetSnInfo
    /// 日程提醒不显示标题
    var getScheduleReminderNotDisplayTitle: Boolean = getScheduleReminderNotDisplayTitle
    /// 城市名称
    var getSupportV3LongCityName: Boolean = getSupportV3LongCityName
    /// 亮度设置支持夜间亮度等级设置
    var getSupportAddNightLevelV2: Boolean = getSupportAddNightLevelV2
    /// 固件支持使用表盘框架使用argb6666编码格式
    var getSupportDialFrameEncodeFormatArgb6666: Boolean = getSupportDialFrameEncodeFormatArgb6666
    /// 固件支持app下发手机操作系统信息
    var getSupportAppSendPhoneSystemInfo: Boolean = getSupportAppSendPhoneSystemInfo
    /// 固件管理切换快/慢速模式，APP不下发设置链接参数(快慢速）
    var getDeviceControlFastModeAlone: Boolean = getDeviceControlFastModeAlone
    /// 设备支持一键双连，区分配对时APP展示引导页还是直接下发配对指令
    var getSupportOnekeyDoubleContact: Boolean = getSupportOnekeyDoubleContact
    /// 语音助手状态
    var getSupportSetVoiceAssistantStatus: Boolean = getSupportSetVoiceAssistantStatus
    /// 支持获取flash log size
    var getSupportFlashLogSize: Boolean = getSupportFlashLogSize
    /// 设备是否支持返回正在测量的值
    var supportDevReturnMeasuringValue: Boolean = supportDevReturnMeasuringValue
    /// 支持获取单位
    var getSupportGetUnit: Boolean = getSupportGetUnit
    /// 通知支持Ryze Connect
    var getSupportRyzeConnect: Boolean = getSupportRyzeConnect
    /// 通知支持LOOPS FIT
    var getSupportLoopsFit: Boolean = getSupportLoopsFit
    /// 通知支持TAS Smart
    var getSupportTasSmart: Boolean = getSupportTasSmart
    /// 女性经期不支持设置排卵日提醒
    var getNotSupportSetOvulation: Boolean = getNotSupportSetOvulation
    /// 固件支持每小时目标步数设置和获取
    var getSupportWalkGoalSteps: Boolean = getSupportWalkGoalSteps
    /// GTX03/05定制，hamaAPP，功能表开启后，运动列表不支持增删，支持排序
    var getNotSupportDeleteAddSportSort: Boolean = getNotSupportDeleteAddSportSort
    /// 支持获取用户习惯信息(打点信息)中久坐提醒特性
    var getSupportSedentaryTensileHabitInfo: Boolean = getSupportSedentaryTensileHabitInfo
    /// 支持固件快速定位，APP下发GPS权限及经纬度给固件
    var getSupportSendGpsLongitudeAndLatitude: Boolean = getSupportSendGpsLongitudeAndLatitude
    /// 支持设备bt连接的手机型号
    var getSupportGetV3DeviceBtConnectPhoneModel: Boolean = getSupportGetV3DeviceBtConnectPhoneModel
    /// 支持血压模型文件更新
    var getSupportBloodPressureModelFileUpdate: Boolean = getSupportBloodPressureModelFileUpdate
    /// 勿扰支持事件范围开关和重复
    var getSupportDisturbHaveRangRepeat: Boolean = getSupportDisturbHaveRangRepeat
    /// 日历提醒
    var getSupportCalendarReminder: Boolean = getSupportCalendarReminder
    /// 表盘传输需要对应的传输原始的没有压缩的大小给固件,增加字段watch_file_size
    var getWatchDailSetAddSize: Boolean = getWatchDailSetAddSize
    /// 支持同步过高过低时心率数据
    var getSupportSyncOverHighLowHeartData: Boolean = getSupportSyncOverHighLowHeartData
    /// 间隔一分钟同步新增（206设备）
    var getSupportPerMinuteOne: Boolean = getSupportPerMinuteOne
    /// 支持全天步数目标达成提醒开关
    var getSupportAchievedRemindOnOff: Boolean = getSupportAchievedRemindOnOff
    /// 支持喝水计划
    var getSupportDrinkPlan: Boolean = getSupportDrinkPlan
    /// 支持表盘包打包jpg图片
    var getSupportMakeWatchDialDecodeJpg: Boolean = getSupportMakeWatchDialDecodeJpg
    /// 支持睡眠计划
    var getSupportSleepPlan: Boolean = getSupportSleepPlan
    /// 支持获取设备算法文件
    var getSupportDeviceOperateAlgFile: Boolean = getSupportDeviceOperateAlgFile
    /// 支持获取运动记录的显示项配置
    var getSupportSportRecordShowConfig: Boolean = getSupportSportRecordShowConfig
    /// 设置获取消息应用状态使用version0x20版本下发
    var setNoticeMessageStateUseVersion0x20: Boolean = setNoticeMessageStateUseVersion0x20
    /// 科学睡眠开关
    var setScientificSleepSwitch: Boolean = setScientificSleepSwitch
    /// 设置夜间体温开关
    var setTemperatureSwitchHealth: Boolean = setTemperatureSwitchHealth
    /// 心率监测
    var setHeartRateMonitor: Boolean = setHeartRateMonitor
    /// 支持喝水提醒设置免提醒时间段
    var setNoReminderOnDrinkReminder: Boolean = setNoReminderOnDrinkReminder
    /// 默认是支持agps off升级
    var setAgpsOffLine: Boolean = setAgpsOffLine
    /// 默认是支持agps online升级
    var setAgpsOnLine: Boolean = setAgpsOnLine
    /// 设置v3心率的间隔
    var setSetV3HeartInterval: Boolean = setSetV3HeartInterval
    /// 天气城市
    var setWeatherCity: Boolean = setWeatherCity
    /// 防打扰
    var setDoNotDisturb: Boolean = setDoNotDisturb
    /// 卡路里目标
    var setCalorieGoal: Boolean = setCalorieGoal
    /// 女性生理周期
    var setMenstruation: Boolean = setMenstruation
    /// 压力数据
    var setPressureData: Boolean = setPressureData
    /// 血氧数据
    var setSpo2Data: Boolean = setSpo2Data
    /// 运动模式排序
    var setSportModeSort: Boolean = setSportModeSort
    /// 运动模式开关
    var setActivitySwitch: Boolean = setActivitySwitch
    /// 夜间自动亮度
    var setNightAutoBrightness: Boolean = setNightAutoBrightness
    /// 5级亮度调节
    var setScreenBrightness5Level: Boolean = setScreenBrightness5Level
    /// 走动提醒
    var setWalkReminder: Boolean = setWalkReminder
    /// 3级亮度调节 默认是5级别，手表app显示，手表不显示
    var setScreenBrightness3Level: Boolean = setScreenBrightness3Level
    /// 洗手提醒
    var setHandWashReminder: Boolean = setHandWashReminder
    /// app支持本地表盘改 云端表盘图片下载
    var setLocalDial: Boolean = setLocalDial
    /// V3的心率过高不支持 | 配置了这个，app的UI心率过高告警不显示，
    var setNotSupportHrHighAlarm: Boolean = setNotSupportHrHighAlarm
    /// BIT1 k6项目不需要对应的壁纸表盘，veryFit默认的都是支持的，
    var setNotSupportPhotoWallpaper: Boolean = setNotSupportPhotoWallpaper
    /// 压力过高提醒
    var setPressureHighReminder: Boolean = setPressureHighReminder
    /// 壁纸表盘颜色设置
    var setWallpaperOnlyTimeColor: Boolean = setWallpaperOnlyTimeColor
    /// 壁纸表盘设置
    var setWallpaperDial: Boolean = setWallpaperDial
    /// 呼吸训练
    var setSupportBreathRate: Boolean = setSupportBreathRate
    /// 设置单位的增加卡路里设置
    var setSupportCalorieUnit: Boolean = setSupportCalorieUnit
    /// 运动计划
    var setSupportSportPlan: Boolean = setSupportSportPlan
    /// 设置单位的增加泳池的单位设置
    var setSupportSwimPoolUnit: Boolean = setSupportSwimPoolUnit
    /// v3 bp
    var setSupportV3Bp: Boolean = setSupportV3Bp
    /// app端用V3的获取运动排序协议中的最大最少默认字段， |
    var setV3GetSportSortField: Boolean = setV3GetSportSortField
    /// 表盘排序
    var setWatchDialSort: Boolean = setWatchDialSort
    /// 运动三环目标获取
    var setGetCalorieDistanceGoal: Boolean = setGetCalorieDistanceGoal
    /// 设置目标增加中高运动时长
    var setMidHighTimeGoal: Boolean = setMidHighTimeGoal
    /// 固件支持解绑不清除设备上的数据
    var setNewRetainData: Boolean = setNewRetainData
    /// 日程提醒
    var setScheduleReminder: Boolean = setScheduleReminder
    /// 100种运动数据排序
    var setSet100SportSort: Boolean = setSet100SportSort
    /// 20种基础运动数据子参数排序
    var setSet20SportParamSort: Boolean = setSet20SportParamSort
    /// 主界面ui控件排列
    var setSetMainUiSort: Boolean = setSetMainUiSort
    /// 压力校准
    var setSetStressCalibration: Boolean = setSetStressCalibration
    /// 支持app设置智能心率
    var setSmartHeartRate: Boolean = setSmartHeartRate
    /// 支持app设置全天的血氧开关数据
    var setSpo2AllDayOnOff: Boolean = setSpo2AllDayOnOff
    /// 支持app下发压缩的sbc语言文件给ble
    var setSupportAppSendVoiceToBle: Boolean = setSupportAppSendVoiceToBle
    /// 设置单位的增加骑行的单位设置
    var setSupportCyclingUnit: Boolean = setSupportCyclingUnit
    /// 设置单位的增加步行跑步的单位设置
    var setSupportWalkRunUnit: Boolean = setSupportWalkRunUnit
    /// 设置走动提醒中的目标时间
    var setWalkReminderTimeGoal: Boolean = setWalkReminderTimeGoal
    /// 支持显示表盘容量
    var setWatchCapacitySizeDisplay: Boolean = setWatchCapacitySizeDisplay
    /// 支持壁纸表盘时间位置移动、控件图标颜色修改、控件功能选择
    var setWatchPhotoPositionMove: Boolean = setWatchPhotoPositionMove
    /// 菜单设置
    var setMenuListMain7: Boolean = setMenuListMain7
    /// v3经期的历史数据下发
    var setHistoryMenstrual: Boolean = setHistoryMenstrual
    /// 经期历史数据支持交互
    var supportHistoricalMenstruationExchange: Boolean = supportHistoricalMenstruationExchange
    /// v3经期历史数据支持交互、支持固件删除
    var supportSetHistoricalMenstruationExchangeVersion21: Boolean = supportSetHistoricalMenstruationExchangeVersion21
    /// v3经期历史数据支持交互、支持固件删除
    var supportHistoricalMenstruationExchangeVersion31: Boolean = supportHistoricalMenstruationExchangeVersion31
    /// v3女性生理日常记录设置
    var supportPhysiologicalRecord: Boolean = supportPhysiologicalRecord
    /// v2经期提醒设置 增加易孕期和结束时间
    var setMenstrualAddPregnancy: Boolean = setMenstrualAddPregnancy
    /// realme wear 定制需求 不支持显示来电"延时三秒"开关
    var setNotSurportCalling3SDelay: Boolean = setNotSurportCalling3SDelay
    /// 支持健身指导开关下发
    var setSetFitnessGuidance: Boolean = setSetFitnessGuidance
    /// 通知设置
    var setSetNotificationStatus: Boolean = setSetNotificationStatus
    /// 未读提醒
    var setSetUnreadAppReminder: Boolean = setSetUnreadAppReminder
    /// 支持V3天气
    var setSetV3Weather: Boolean = setSetV3Weather
    /// 支持天气推送增加日落日出时间
    var setSetV3WeatherSunrise: Boolean = setSetV3WeatherSunrise
    /// 支持世界时间设置
    var setSetV3WorldTime: Boolean = setSetV3WorldTime
    /// 支持联系人同步
    var setSyncContact: Boolean = setSyncContact
    /// 同步V3的多运动增加新的参数
    var setSyncV3ActivityAddParam: Boolean = setSyncV3ActivityAddParam
    /// 音乐名称设置
    var setTransferMusicFile: Boolean = setTransferMusicFile
    /// 走动提醒增加通知类型
    var setWalkReminderAddNotify: Boolean = setWalkReminderAddNotify
    /// 设置单位支持华氏度
    var setSupportFahrenheit: Boolean = setSupportFahrenheit
    /// 支持v3闹钟设置获取指定名称闹钟（KR01定制）
    var setGetAlarmSpecify: Boolean = setGetAlarmSpecify
    /// 支持airoha芯片采gps数据功能表
    var setAirohaGpsChip: Boolean = setAirohaGpsChip
    /// 支持第二套运动图标功能表    目前仅idw05支持
    var setSupportSecondSportIcon: Boolean = setSupportSecondSportIcon
    /// 100种运动需要的中图功能表
    var setSportMediumIcon: Boolean = setSportMediumIcon
    /// 支持天气推送增加日落日出时间
    var setWeatherSunTime: Boolean = setWeatherSunTime
    /// 支持V3天气 下发空气质量等级
    var setWeatherAirGrade: Boolean = setWeatherAirGrade
    /// 支持设置喝水提醒
    var setDrinkWaterReminder: Boolean = setDrinkWaterReminder
    /// 支持设备电量提醒开关
    var supportBatteryReminderSwitch: Boolean = supportBatteryReminderSwitch
    /// 支持宠物信息设置获取（SET:03 0A / GET:02 0A）
    var supportPetInfo: Boolean = supportPetInfo
    /// 呼吸率开关设置
    var setRespirationRate: Boolean = setRespirationRate
    /// 最大摄氧量
    var setMaxBloodOxygen: Boolean = setMaxBloodOxygen
    /// ble控制音乐
    var setBleControlMusic: Boolean = setBleControlMusic
    /// v3压力功能表
    var setMainPressure: Boolean = setMainPressure
    /// 勿扰模式设置获取新增全天勿扰开关和智能开关
    var setNoDisturbAllDayOnOff: Boolean = setNoDisturbAllDayOnOff
    /// 支持设置全天勿扰开关
    var setOnlyNoDisturbAllDayOnOff: Boolean = setOnlyNoDisturbAllDayOnOff
    /// 支持设置智能勿扰开关
    var setOnlyNoDisturbSmartOnOff: Boolean = setOnlyNoDisturbSmartOnOff
    /// 时区设定值为实际时区值的扩大100倍
    var setTimeZoneFloat: Boolean = setTimeZoneFloat
    /// 设定温度开关
    var setTemperatureSwitchSupport: Boolean = setTemperatureSwitchSupport
    /// 支持设置获取消息应用总开关字段
    var setMsgAllSwitch: Boolean = setMsgAllSwitch
    /// 不支持支持来电提醒页面的“延迟三秒”开关设置项显示
    var setNotSupperCall3Delay: Boolean = setNotSupperCall3Delay
    /// 支持来电已拒
    var setNoticeMissedCallV2: Boolean = setNoticeMissedCallV2
    /// 结束查找手机
    var setOverFindPhone: Boolean = setOverFindPhone
    /// 获取所有的健康监测开关
    var getHealthSwitchStateSupportV3: Boolean = getHealthSwitchStateSupportV3
    /// 久坐提醒
    var setSedentariness: Boolean = setSedentariness
    /// 设置屏幕亮度
    var setScreenBrightness: Boolean = setScreenBrightness
    /// 设置设备音乐音量
    var setSetPhoneVoice: Boolean = setSetPhoneVoice
    /// 设置快捷来电回复开关
    var setSupportSetCallQuickReplyOnOff: Boolean = setSupportSetCallQuickReplyOnOff
    /// 支持多运动交互中下发GPS坐标
    var setSupportExchangeSetGpsCoordinates: Boolean = setSupportExchangeSetGpsCoordinates
    /// 支持v3天气协议下发大气压强
    var setSupportV3WeatherAddAtmosphericPressure: Boolean = setSupportV3WeatherAddAtmosphericPressure
    /// 支持v3天气协议下发积雪厚度
    var setSupportSetV3WeatcherAddSnowDepth: Boolean = setSupportSetV3WeatcherAddSnowDepth
    /// 支持v3天气协议下发降雪量
    var setSupportSetV3WeatcherAddSnowfall: Boolean = setSupportSetV3WeatcherAddSnowfall
    /// 支持v3天气协议下发协议版本0x4版本
    var setSupportSetV3WeatcherSendStructVersion04: Boolean = setSupportSetV3WeatcherSendStructVersion04
    /// 支持设置压力校准阈
    var setSendCalibrationThreshold: Boolean = setSendCalibrationThreshold
    /// 支持屏蔽跑步计划入口
    var getNotSupportAppSendRunPlan: Boolean = getNotSupportAppSendRunPlan
    /// 支持APP展示零星小睡睡眠数据
    var getSupportDisplayNapSleep: Boolean = getSupportDisplayNapSleep
    /// 支持app获取智能心率
    var getSupportGetSmartHeartRate: Boolean = getSupportGetSmartHeartRate
    /// 支持app获取压力开关
    var getSupportGetPressureSwitchInfo: Boolean = getSupportGetPressureSwitchInfo
    /// 支持电子卡片功能
    var getSupportECardOperate: Boolean = getSupportECardOperate
    /// 支持语音备忘录功能
    var getSupportVoiceMemoOperate: Boolean = getSupportVoiceMemoOperate
    /// 支持晨报功能
    var getSupportMorningEdition: Boolean = getSupportMorningEdition
    /// 支持app获取血氧饱和度开关
    var getSupportGetSpo2SwitchInfo: Boolean = getSupportGetSpo2SwitchInfo
    /// 支持同步心率使用version字段兼容
    var getSupportSyncHealthHrUseVersionCompatible: Boolean = getSupportSyncHealthHrUseVersionCompatible
    /// v3天气设置增加下发48小时天气数据
    var getSupportSetV3Add48HourWeatherData: Boolean = getSupportSetV3Add48HourWeatherData
    /// 功能表开启后,室内跑步不支持获取最大摄氧量,app室内跑步不展示此数据
    var getNotSupportIndoorRunGetVo2max: Boolean = getNotSupportIndoorRunGetVo2max
    /// 支持app设置心电图测量提醒
    var getSupportSetEcgReminder: Boolean = getSupportSetEcgReminder
    /// 支持同步心电图(ecg)数据
    var getSupportSyncEcg: Boolean = getSupportSyncEcg
    /// 支持游戏时间设置
    var getSupportSetGameTimeReminder: Boolean = getSupportSetGameTimeReminder
    /// 支持配置默认的消息应用列表
    var getSupportConfigDefaultMegApplicationList: Boolean = getSupportConfigDefaultMegApplicationList
    /// 支持app设置eci
    var getSupportSetEciReminder: Boolean = getSupportSetEciReminder
    /// 环境音量支持设置通知类型
    var setSupportNoiseSetNotifyFlag: Boolean = setSupportNoiseSetNotifyFlag
    /// 环境音量支持设置过高提醒
    var setSupportNoiseSetOverWarning: Boolean = setSupportNoiseSetOverWarning
    /// 支持设置版本信息
    var setSupportSetVersionInformation: Boolean = setSupportSetVersionInformation
    /// 支持小程序操作
    var setSupportControlMiniProgram: Boolean = setSupportControlMiniProgram
    /// 支持下发未来和历史空气质量数据
    var getSupportSetWeatherHistoryFutureAqi: Boolean = getSupportSetWeatherHistoryFutureAqi
    /// 支持设置亮屏亮度时间
    var setBrightScreenTime: Boolean = setBrightScreenTime
    /// 支持设置心率过高过低提醒
    var setHeartSetRateModeCustom: Boolean = setHeartSetRateModeCustom
    /// 支持查询、设置 v3菜单列表
    var supportProtocolV3MenuList: Boolean = supportProtocolV3MenuList
    /// 中文
    var languageCh: Boolean = languageCh
    /// 捷克文
    var languageCzech: Boolean = languageCzech
    /// 英文
    var languageEnglish: Boolean = languageEnglish
    /// 法文
    var languageFrench: Boolean = languageFrench
    /// 德文
    var languageGerman: Boolean = languageGerman
    /// 意大利文
    var languageItalian: Boolean = languageItalian
    /// 日文
    var languageJapanese: Boolean = languageJapanese
    /// 西班牙文
    var languageSpanish: Boolean = languageSpanish
    /// 阿拉伯语
    var languageArabic: Boolean = languageArabic
    /// 缅甸语
    var languageBurmese: Boolean = languageBurmese
    /// 菲律宾语
    var languageFilipino: Boolean = languageFilipino
    /// 希腊语
    var languageGreek: Boolean = languageGreek
    /// 泰国语
    var languageThai: Boolean = languageThai
    /// 繁体中文
    var languageTraditionalChinese: Boolean = languageTraditionalChinese
    /// 越南语
    var languageVietnamese: Boolean = languageVietnamese
    /// 荷兰文
    var languageDutch: Boolean = languageDutch
    /// 匈牙利文
    var languageHungarian: Boolean = languageHungarian
    /// 立陶宛文
    var languageLithuanian: Boolean = languageLithuanian
    /// 波兰文
    var languagePolish: Boolean = languagePolish
    /// 罗马尼亚文
    var languageRomanian: Boolean = languageRomanian
    /// 俄罗斯文
    var languageRussian: Boolean = languageRussian
    /// 斯洛文尼亚文
    var languageSlovenian: Boolean = languageSlovenian
    /// 乌克兰文
    var languageUkrainian: Boolean = languageUkrainian
    /// 克罗地亚语
    var languageCroatian: Boolean = languageCroatian
    /// 丹麦语
    var languageDanish: Boolean = languageDanish
    /// 印地语
    var languageHindi: Boolean = languageHindi
    /// 印尼语
    var languageIndonesian: Boolean = languageIndonesian
    /// 韩语
    var languageKorean: Boolean = languageKorean
    /// 葡萄牙语
    var languagePortuguese: Boolean = languagePortuguese
    /// 斯洛伐克语
    var languageSlovak: Boolean = languageSlovak
    /// 土耳其
    var languageTurkish: Boolean = languageTurkish
    /// 波斯语
    var languagePersia: Boolean = languagePersia
    /// 瑞典语
    var languageSweden: Boolean = languageSweden
    /// 挪威语
    var languageNorwegian: Boolean = languageNorwegian
    /// 芬兰语
    var languageFinland: Boolean = languageFinland
    /// 孟加拉语
    var languageBengali: Boolean = languageBengali
    /// 高棉语
    var languageKhmer: Boolean = languageKhmer
    /// 马来语
    var languageMalay: Boolean = languageMalay
    /// 巴西葡语
    var languageBrazilianPortuguese: Boolean = languageBrazilianPortuguese
    /// 希伯来语
    var languageHebrew: Boolean = languageHebrew
    /// 塞尔维亚语
    var languageSerbian: Boolean = languageSerbian
    /// 保加利亚
    var languageBulgaria: Boolean = languageBulgaria
    /// v3 心率
    var syncV3Hr: Boolean = syncV3Hr
    /// v3 游泳
    var syncV3Swim: Boolean = syncV3Swim
    /// v3 血氧
    var syncV3Spo2: Boolean = syncV3Spo2
    /// v3 压力
    var syncV3Pressure: Boolean = syncV3Pressure
    /// v3 多运动
    var syncV3Activity: Boolean = syncV3Activity
    /// v3 睡眠
    var syncV3Sleep: Boolean = syncV3Sleep
    /// v3 宠物睡眠
    var syncV3PetSleep: Boolean = syncV3PetSleep
    /// v3 步数
    var syncV3Sports: Boolean = syncV3Sports
    /// v3 gps
    var syncV3Gps: Boolean = syncV3Gps
    /// v3 闹钟
    var syncV3SyncAlarm: Boolean = syncV3SyncAlarm
    /// v3 身体电量
    var syncV3BodyPower: Boolean = syncV3BodyPower
    /// 同步hrv
    var getSupportHrvV3: Boolean = getSupportHrvV3
    /// 同步血压
    var getSupportPerBpV3: Boolean = getSupportPerBpV3
    /// 同步噪音
    var syncV3Noise: Boolean = syncV3Noise
    /// 同步温度
    var syncV3Temperature: Boolean = syncV3Temperature
    /// gps
    var syncGps: Boolean = syncGps
    /// v3多运动同步数据交换
    var syncV3ActivityExchangeData: Boolean = syncV3ActivityExchangeData
    /// 心率功能
    var syncHeartRate: Boolean = syncHeartRate
    /// 心率监测
    var syncHeartRateMonitor: Boolean = syncHeartRateMonitor
    /// 睡眠检测
    var syncSleepMonitor: Boolean = syncSleepMonitor
    /// 快速同步
    var syncFastSync: Boolean = syncFastSync
    /// 获取时间同步
    var syncActivityTimeSync: Boolean = syncActivityTimeSync
    /// v2同步 时间线
    var syncTimeLine: Boolean = syncTimeLine
    /// 需要V2的同步
    var syncNeedV2: Boolean = syncNeedV2
    /// v3多运动同步支持实时速度显示
    var syncRealTimeV3: Boolean = syncRealTimeV3
    /// 数据交换增加实时的配速字段
    var syncExchangeDataReplyAddRealTimeSpeedPaceV3: Boolean = syncExchangeDataReplyAddRealTimeSpeedPaceV3
    /// 多运行结束时间使用UTC模式
    var syncHealthSyncV3ActivityEndTimeUseUtcMode: Boolean = syncHealthSyncV3ActivityEndTimeUseUtcMode
    /// 支持数据同步时开启快速模式
    var syncSupportSetFastModeWhenSyncConfig: Boolean = syncSupportSetFastModeWhenSyncConfig
    /// 支持获取app基本信息
    var getSupportAppBaseInformation: Boolean = getSupportAppBaseInformation
    /// 闹钟个数
    var alarmCount: Int = alarmCount
    /// 刷牙
    var alarmBrushTeeth: Boolean = alarmBrushTeeth
    /// 约会
    var alarmDating: Boolean = alarmDating
    /// 吃饭
    var alarmDinner: Boolean = alarmDinner
    /// 吃药
    var alarmMedicine: Boolean = alarmMedicine
    /// 会议
    var alarmMeeting: Boolean = alarmMeeting
    /// 聚会
    var alarmParty: Boolean = alarmParty
    /// 休息
    var alarmRest: Boolean = alarmRest
    /// 睡觉
    var alarmSleep: Boolean = alarmSleep
    /// 锻炼
    var alarmSport: Boolean = alarmSport
    /// 起床
    var alarmWakeUp: Boolean = alarmWakeUp
    /// 支持设置防丢
    var supportSetAntilost: Boolean = supportSetAntilost
    /// 支持设置v2天气数据
    var supportSetWeatherDataV2: Boolean = supportSetWeatherDataV2
    /// 支持设置一键呼叫
    var supportSetOnetouchCalling: Boolean = supportSetOnetouchCalling
    /// 支持设置运动中屏幕显示
    var supportOperateSetSportScreen: Boolean = supportOperateSetSportScreen
    /// 支持设置应用列表样式
    var supportOperateListStyle: Boolean = supportOperateListStyle
    /// 支持情绪健康
    var supportEmotionHealth: Boolean = supportEmotionHealth
    /// 支持v3同步通讯录版本20
    var supportV3SyncContactVersion20: Boolean = supportV3SyncContactVersion20
    /// 支持SOS通话记录查询
    var supportGetSosCallRecord: Boolean = supportGetSosCallRecord
    /// alexa 语音提醒增加对应的时钟传输字段
    var alexaReminderAddSecV3: Boolean = alexaReminderAddSecV3
    /// alexa 简单控制命令
    var alexaSetEasyOperateV3: Boolean = alexaSetEasyOperateV3
    /// alexa 语音闹钟获取设置命令使用
    var alexaSetGetAlexaAlarmV3: Boolean = alexaSetGetAlexaAlarmV3
    /// alexa 设置跳转运动界面
    var alexaSetJumpSportUiV3: Boolean = alexaSetJumpSportUiV3
    /// alexa 设置跳转ui界面
    var alexaSetJumpUiV3: Boolean = alexaSetJumpUiV3
    /// alexa app设置开关命令
    var alexaSetSetOnOffTypeV3: Boolean = alexaSetSetOnOffTypeV3
    /// alexa 语音支持设置天气
    var alexaSetWeatherV3: Boolean = alexaSetWeatherV3
    /// alexa 支持设置多个定时器
    var alexaTimeNewV3: Boolean = alexaTimeNewV3
    /// alexa 100级亮度控制
    var setAlexaControll100brightness: Boolean = setAlexaControll100brightness
    /// alexa 获取alexa默认语言
    var alexaGetSupportGetAlexaDefaultLanguage: Boolean = alexaGetSupportGetAlexaDefaultLanguage
    /// alexa跳转运动界面支持100种运动类型字段
    var alexaGetUIControllSports: Boolean = alexaGetUIControllSports
    /// 支持获取左右手佩戴设置
    var getLeftRightHandWearSettings: Boolean = getLeftRightHandWearSettings
    /// 支持支持运动中设置提示音
    var supportSettingsDuringExercise: Boolean = supportSettingsDuringExercise
    /// 支持身高单位设置(厘米/英寸)
    var supportHeightLengthUnit: Boolean = supportHeightLengthUnit
    /// 支持运动中提醒设置
    var supportSportingRemindSetting: Boolean = supportSportingRemindSetting
    /// 支持获取运动是否支持自动暂停结束
    var supportSportGetAutoPauseEnd: Boolean = supportSportGetAutoPauseEnd
    /// 支持步幅长度的单位设置(公制/英制)
    var supportSetStrideLengthUnit: Boolean = supportSetStrideLengthUnit
    /// 支持简单心率区间
    var supportSimpleHrZoneSetting: Boolean = supportSimpleHrZoneSetting
    /// 开启功能表则关闭智能心率过低提醒
    var notSupportSmartLowHeartReatRemind: Boolean = notSupportSmartLowHeartReatRemind
    /// 开启功能表则关闭智能心率过高提醒
    var notSupportSmartHighHeartReatRemind: Boolean = notSupportSmartHighHeartReatRemind
    /// 设备是否不支持拍照推流
    var notSupportPhotoPreviewControl: Boolean = notSupportPhotoPreviewControl
    /// 支持获取用户信息
    var supportGetUserInfo: Boolean = supportGetUserInfo
    /// 支持未接来电消息类型为485
    var supportMissedCallMsgTypeUseFixed: Boolean = supportMissedCallMsgTypeUseFixed
    /// 支持闹钟不显示闹钟名称
    var supportAppNotDisplayAlarmName: Boolean = supportAppNotDisplayAlarmName
    /// 支持设置睡眠提醒
    var supportSetSleepRemind: Boolean = supportSetSleepRemind
    /// 支持血糖
    var supportBloodGlucose: Boolean = supportBloodGlucose
    /// 支持血糖(v01)
    var supportBloodGlucoseV01: Boolean = supportBloodGlucoseV01
    /// 车锁管理
    var supportBikeLockManager: Boolean = supportBikeLockManager
    /// 支持算法数据的采集
    var supportAlgorithmRawDataCollect: Boolean = supportAlgorithmRawDataCollect
    /// 支持离线地图
    var supportOfflineMapInformation: Boolean = supportOfflineMapInformation
    /// 开启则⽀持储备⼼率区间,关闭默认⽀持的最⼤⼼率区间
    var supportHeartRateReserveZones: Boolean = supportHeartRateReserveZones
    /// 开启则⽀持⼼率区间⼼率最⼤值设置
    var supportHeartRateZonesHrMaxSet: Boolean = supportHeartRateZonesHrMaxSet
    /// 支持新的同步多运动数据（同步多运动/游泳/跑步课程/跑步计划/跑后拉伸数据）
    var supportSyncMultiActivityNew: Boolean = supportSyncMultiActivityNew
    /// 联系人存储支持使用固件返回大小
    var supportContactFileUseFirmwareReturnSize: Boolean = supportContactFileUseFirmwareReturnSize
    /// 控制APP是否显示相机入口
    var supportDisplayCameraEntry: Boolean = supportDisplayCameraEntry
    /// 支持家庭关心提醒设置
    var supportOperateFamilyCareReminder3376: Boolean = supportOperateFamilyCareReminder3376
    /// 支持设置获取经期配置，使用v3长包指令
    var supportProtocolV3MenstruationConfig3377: Boolean = supportProtocolV3MenstruationConfig3377
    /// 支持习惯养成设置
    var supportOperateHabitFormation: Boolean = supportOperateHabitFormation
    /// 支持版本v01习惯养成设置
    var supportOperateHabitFormationV01: Boolean = supportOperateHabitFormationV01
    /// 支持家庭步数下发
    var supportOperateFamilySteps: Boolean = supportOperateFamilySteps
    /// 支持游戏设置
    var supportOperateSetGame: Boolean = supportOperateSetGame
    /// 支持手势控制功能
    var supportOperateGestureControl: Boolean = supportOperateGestureControl

    
    override fun toJsonString(): String {
        return GsonBuilder().create().toJson(this).toString()
    }
    override fun toString(): String {
        return toJsonString();
    }

}
    
