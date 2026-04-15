package com.idosmart.pigeon_implement

import com.idosmart.model.FunctionTableModel
import com.idosmart.protocol_sdk.FuncTableInterface

private val ft = FuncTableDelegateImpl.instance()

internal class IDOFuncTable : FuncTableInterface {

    private var funcTable: FunctionTableModel? = null

    constructor(funcTable: FunctionTableModel) {
        this.funcTable = funcTable
    }

    constructor() {}

    private fun funInfo(): FunctionTableModel? {
        return funcTable ?: ft.funcTableInfo
    }

    override fun toString(): String {
        return "IDOFuncTable(reminderAncs=$reminderAncs, reminderSnapchat=$reminderSnapchat, reminderLine=$reminderLine, reminderOutlook=$reminderOutlook, reminderTelegram=$reminderTelegram, reminderViber=$reminderViber, reminderVkontakte=$reminderVkontakte, reminderChatwork=$reminderChatwork, reminderSlack=$reminderSlack, reminderTumblr=$reminderTumblr, reminderYahooMail=$reminderYahooMail, reminderYahooPinterest=$reminderYahooPinterest, reminderYoutube=$reminderYoutube, reminderGmail=$reminderGmail, reminderKakaoTalk=$reminderKakaoTalk, reminderOnlyGoogleGmail=$reminderOnlyGoogleGmail, reminderOnlyOutlookEmail=$reminderOnlyOutlookEmail, reminderOnlyYahooEmail=$reminderOnlyYahooEmail, reminderTiktok=$reminderTiktok, reminderRedbus=$reminderRedbus, reminderDailyhunt=$reminderDailyhunt, reminderHotstar=$reminderHotstar, reminderInshorts=$reminderInshorts, reminderPaytm=$reminderPaytm, reminderAmazon=$reminderAmazon, reminderFlipkart=$reminderFlipkart, reminderNhnEmail=$reminderNhnEmail, reminderInstantEmail=$reminderInstantEmail, reminderZohoEmail=$reminderZohoEmail, reminderExchangeEmail=$reminderExchangeEmail, reminder189Email=$reminder189Email, reminderVeryFit=$reminderVeryFit, reminderGeneral=$reminderGeneral, reminderOther=$reminderOther, reminderMattersRemind=$reminderMattersRemind, reminderMicrosoft=$reminderMicrosoft, reminderMissedCall=$reminderMissedCall, reminderGetAllContact=$reminderGetAllContact, reminderWhatsappBusiness=$reminderWhatsappBusiness, reminderEmail=$reminderEmail, reminderFacebook=$reminderFacebook, reminderMessage=$reminderMessage, reminderQq=$reminderQq, reminderTwitter=$reminderTwitter, reminderWeixin=$reminderWeixin, reminderCalendarGoogle=$reminderCalendarGoogle, reminderInstagram=$reminderInstagram, reminderLinkedIn=$reminderLinkedIn, reminderMessengre=$reminderMessengre, reminderSkype=$reminderSkype, reminderCalendar=$reminderCalendar, reminderWhatsapp=$reminderWhatsapp, reminderAlarmClock=$reminderAlarmClock, reminderSinaWeibo=$reminderSinaWeibo, reminderWeibo=$reminderWeibo, reminderCalling=$reminderCalling, reminderCallContact=$reminderCallContact, reminderCallNum=$reminderCallNum, reminderPrime=$reminderPrime, reminderNetflix=$reminderNetflix, reminderGpay=$reminderGpay, reminderPhonpe=$reminderPhonpe, reminderSwiggy=$reminderSwiggy, reminderZomato=$reminderZomato, reminderMakemytrip=$reminderMakemytrip, reminderJioTv=$reminderJioTv, reminderNiosefit=$reminderNiosefit, reminderYtmusic=$reminderYtmusic, reminderUber=$reminderUber, reminderOla=$reminderOla, reminderGoogleMeet=$reminderGoogleMeet, reminderMormaiiSmartwatch=$reminderMormaiiSmartwatch, reminderTechnosConnect=$reminderTechnosConnect, reminderEnjoei=$reminderEnjoei, reminderAliexpress=$reminderAliexpress, reminderShopee=$reminderShopee, reminderTeams=$reminderTeams, reminder99Taxi=$reminder99Taxi, reminderUberEats=$reminderUberEats, reminderLfood=$reminderLfood, reminderRappi=$reminderRappi, reminderMercadoLivre=$reminderMercadoLivre, reminderMagalu=$reminderMagalu, reminderAmericanas=$reminderAmericanas, reminderYahoo=$reminderYahoo, reminderMessageIcon=$reminderMessageIcon, reminderTaobao=$reminderTaobao, reminderDingding=$reminderDingding, reminderAlipay=$reminderAlipay, reminderToutiao=$reminderToutiao, reminderDouyin=$reminderDouyin, reminderTmall=$reminderTmall, reminderJd=$reminderJd, reminderPinduoduo=$reminderPinduoduo, reminderBaidu=$reminderBaidu, reminderMeituan=$reminderMeituan, reminderEleme=$reminderEleme, sportWalk=$sportWalk, sportRun=$sportRun, sportByBike=$sportByBike, sportOnFoot=$sportOnFoot, sportSwim=$sportSwim, sportMountainClimbing=$sportMountainClimbing, sportBadminton=$sportBadminton, sportOther=$sportOther, sportFitness=$sportFitness, sportSpinning=$sportSpinning, sportEllipsoid=$sportEllipsoid, sportTreadmill=$sportTreadmill, sportSitUp=$sportSitUp, sportPushUp=$sportPushUp, sportDumbbell=$sportDumbbell, sportWeightlifting=$sportWeightlifting, sportBodybuildingExercise=$sportBodybuildingExercise, sportYoga=$sportYoga, sportRopeSkipping=$sportRopeSkipping, sportTableTennis=$sportTableTennis, sportBasketball=$sportBasketball, sportFootballl=$sportFootballl, sportVolleyball=$sportVolleyball, sportTennis=$sportTennis, sportGolf=$sportGolf, sportBaseball=$sportBaseball, sportSkiing=$sportSkiing, sportRollerSkating=$sportRollerSkating, sportDance=$sportDance, sportStrengthTraining=$sportStrengthTraining, sportCoreTraining=$sportCoreTraining, sportTidyUpRelax=$sportTidyUpRelax, sportTraditionalStrengthTraining=$sportTraditionalStrengthTraining, sportOutdoorRun=$sportOutdoorRun, sportIndoorRun=$sportIndoorRun, sportOutdoorCycle=$sportOutdoorCycle, sportIndoorCycle=$sportIndoorCycle, sportOutdoorWalk=$sportOutdoorWalk, sportIndoorWalk=$sportIndoorWalk, sportPoolSwim=$sportPoolSwim, sportOpenWaterSwim=$sportOpenWaterSwim, sportElliptical=$sportElliptical, sportRower=$sportRower, sportHiit=$sportHiit, sportCricket=$sportCricket, sportPilates=$sportPilates, sportOutdoorFun=$sportOutdoorFun, sportOtherActivity=$sportOtherActivity, sportZumba=$sportZumba, sportSurfing=$sportSurfing, sportFootvolley=$sportFootvolley, sportStandWaterSkiing=$sportStandWaterSkiing, sportBattlingRope=$sportBattlingRope, sportSkateboard=$sportSkateboard, sportNoticeStepper=$sportNoticeStepper, sportShowNum=$sportShowNum, sportAerobicsBodybuildingExercise=$sportAerobicsBodybuildingExercise, sportPullUp=$sportPullUp, sportHighBar=$sportHighBar, sportParallelBars=$sportParallelBars, sportTrailRunning=$sportTrailRunning, sportPickleBall=$sportPickleBall, sportSnowboard=$sportSnowboard, sportCrossCountrySkiing=$sportCrossCountrySkiing, getRealtimeData=$getRealtimeData, getLangLibraryV3=$getLangLibraryV3, getFindPhone=$getFindPhone, getFindDevice=$getFindDevice, getUpHandGestureEx=$getUpHandGestureEx, getUpHandGesture=$getUpHandGesture, getWeather=$getWeather, getDownloadLanguage=$getDownloadLanguage, getFactoryReset=$getFactoryReset, getFlashLog=$getFlashLog, getMultiActivityNoUseApp=$getMultiActivityNoUseApp, getMultiDial=$getMultiDial, getMenuList=$getMenuList, getDoNotDisturbMain3=$getDoNotDisturbMain3, getVoiceTransmission=$getVoiceTransmission, setDrinkWaterAddNotifyFlag=$setDrinkWaterAddNotifyFlag, setSpo2LowValueRemindAddNotifyFlag=$setSpo2LowValueRemindAddNotifyFlag, notSupportSmartHeartNotifyFlag=$notSupportSmartHeartNotifyFlag, getDeviceLogState=$getDeviceLogState, getNewWatchList=$getNewWatchList, getNotifyIconAdaptive=$getNotifyIconAdaptive, getPressureNotifyFlagMode=$getPressureNotifyFlagMode, getScientificSleep=$getScientificSleep, getSpo2NotifyFlag=$getSpo2NotifyFlag, getV3Log=$getV3Log, getWatchID=$getWatchID, getDeviceName=$getDeviceName, getBatteryLog=$getBatteryLog, getBatteryInfo=$getBatteryInfo, getHeatLog=$getHeatLog, getWalkReminderV3=$getWalkReminderV3, getSupportV3BleMusic=$getSupportV3BleMusic, getSupportGetBleBeepV3=$getSupportGetBleBeepV3, getVeryFitNotSupportPhotoWallpaperV3=$getVeryFitNotSupportPhotoWallpaperV3, getSupportUpdateGps=$getSupportUpdateGps, getUbloxModel=$getUbloxModel, getSupportGetBleMusicInfoVerV3=$getSupportGetBleMusicInfoVerV3, getBtVersion=$getBtVersion, getSportsTypeV3=$getSportsTypeV3, getActivitySwitch=$getActivitySwitch, getNoticeIconInformation=$getNoticeIconInformation, getSetMaxItemsNum=$getSetMaxItemsNum, getNotifyMsgV3=$getNotifyMsgV3, getScreenBrightnessMain9=$getScreenBrightnessMain9, getNotice128byte=$getNotice128byte, getNotice250byte=$getNotice250byte, getDeletableMenuListV2=$getDeletableMenuListV2, getSupportPairEachConnect=$getSupportPairEachConnect, getSupportGetMainSportGoalV3=$getSupportGetMainSportGoalV3, getBtAddrV2=$getBtAddrV2, getSupportBpSetOrMeasurementV2=$getSupportBpSetOrMeasurementV2, getMenstrualAddNotifyFlagV3=$getMenstrualAddNotifyFlagV3, getSupportSetGetTimeGoalTypeV2=$getSupportSetGetTimeGoalTypeV2, getOxygenDataSupportGradeV3=$getOxygenDataSupportGradeV3, getSupportSyncActivityDataAltitudeInfo=$getSupportSyncActivityDataAltitudeInfo, getBindCodeAuth=$getBindCodeAuth, getSpo2OffChangeV3=$getSpo2OffChangeV3, getLevel5HrInterval=$getLevel5HrInterval, getFiveHRInterval=$getFiveHRInterval, getBleAndBtVersion=$getBleAndBtVersion, getSupportSetGetEmergencyContactV3=$getSupportSetGetEmergencyContactV3, getSupportSetRepeatWeekTypeOnScheduleReminderV3=$getSupportSetRepeatWeekTypeOnScheduleReminderV3, getSupportSetRepeatTypeOnScheduleReminderV3=$getSupportSetRepeatTypeOnScheduleReminderV3, getSupportSetMenstrualReminderOnOff=$getSupportSetMenstrualReminderOnOff, getVersionInfo=$getVersionInfo, getMtu=$getMtu, getDeviceUpdateState=$getDeviceUpdateState, getHeartRateModeV2=$getHeartRateModeV2, getStepDataTypeV2=$getStepDataTypeV2, getFastMsgDataV3=$getFastMsgDataV3, getSupportCallingQuickReply=$getSupportCallingQuickReply, getSupportDataTranGetNewErrorCodeV3=$getSupportDataTranGetNewErrorCodeV3, getAutoActivityEndSwitchNotDisplay=$getAutoActivityEndSwitchNotDisplay, getAutoActivityPauseSwitchNotDisplay=$getAutoActivityPauseSwitchNotDisplay, getV3AutoActivitySwitch=$getV3AutoActivitySwitch, getAutoActivitySwitchAddBicycle=$getAutoActivitySwitchAddBicycle, getAutoActivitySwitchAddSmartRope=$getAutoActivitySwitchAddSmartRope, getAutoActivitySetGetUseNewStructExchange=$getAutoActivitySetGetUseNewStructExchange, getSupportSetGetNoReminderOnWalkReminderV2=$getSupportSetGetNoReminderOnWalkReminderV2, getSupportGetSnInfo=$getSupportGetSnInfo, getScheduleReminderNotDisplayTitle=$getScheduleReminderNotDisplayTitle, getSupportV3LongCityName=$getSupportV3LongCityName, getSupportAddNightLevelV2=$getSupportAddNightLevelV2, getSupportDialFrameEncodeFormatArgb6666=$getSupportDialFrameEncodeFormatArgb6666, getSupportAppSendPhoneSystemInfo=$getSupportAppSendPhoneSystemInfo, getDeviceControlFastModeAlone=$getDeviceControlFastModeAlone, getSupportOnekeyDoubleContact=$getSupportOnekeyDoubleContact, getSupportSetVoiceAssistantStatus=$getSupportSetVoiceAssistantStatus, getSupportFlashLogSize=$getSupportFlashLogSize, supportDevReturnMeasuringValue=$supportDevReturnMeasuringValue, getSupportGetUnit=$getSupportGetUnit, getSupportRyzeConnect=$getSupportRyzeConnect, getSupportLoopsFit=$getSupportLoopsFit, getSupportTasSmart=$getSupportTasSmart, getNotSupportSetOvulation=$getNotSupportSetOvulation, getSupportWalkGoalSteps=$getSupportWalkGoalSteps, getNotSupportDeleteAddSportSort=$getNotSupportDeleteAddSportSort, getSupportSedentaryTensileHabitInfo=$getSupportSedentaryTensileHabitInfo, getSupportSendGpsLongitudeAndLatitude=$getSupportSendGpsLongitudeAndLatitude, getSupportGetV3DeviceBtConnectPhoneModel=$getSupportGetV3DeviceBtConnectPhoneModel, getSupportBloodPressureModelFileUpdate=$getSupportBloodPressureModelFileUpdate, getSupportDisturbHaveRangRepeat=$getSupportDisturbHaveRangRepeat, getSupportCalendarReminder=$getSupportCalendarReminder, getWatchDailSetAddSize=$getWatchDailSetAddSize, getSupportSyncOverHighLowHeartData=$getSupportSyncOverHighLowHeartData, getSupportPerMinuteOne=$getSupportPerMinuteOne, getSupportAchievedRemindOnOff=$getSupportAchievedRemindOnOff, getSupportDrinkPlan=$getSupportDrinkPlan, getSupportMakeWatchDialDecodeJpg=$getSupportMakeWatchDialDecodeJpg, getSupportSleepPlan=$getSupportSleepPlan, getSupportDeviceOperateAlgFile=$getSupportDeviceOperateAlgFile, getSupportSportRecordShowConfig=$getSupportSportRecordShowConfig, setNoticeMessageStateUseVersion0x20=$setNoticeMessageStateUseVersion0x20, setScientificSleepSwitch=$setScientificSleepSwitch, setTemperatureSwitchHealth=$setTemperatureSwitchHealth, setHeartRateMonitor=$setHeartRateMonitor, setNoReminderOnDrinkReminder=$setNoReminderOnDrinkReminder, setAgpsOffLine=$setAgpsOffLine, setAgpsOnLine=$setAgpsOnLine, setSetV3HeartInterval=$setSetV3HeartInterval, setWeatherCity=$setWeatherCity, setDoNotDisturb=$setDoNotDisturb, setCalorieGoal=$setCalorieGoal, setMenstruation=$setMenstruation, setPressureData=$setPressureData, setSpo2Data=$setSpo2Data, setSportModeSort=$setSportModeSort, setActivitySwitch=$setActivitySwitch, setNightAutoBrightness=$setNightAutoBrightness, setScreenBrightness5Level=$setScreenBrightness5Level, setWalkReminder=$setWalkReminder, setScreenBrightness3Level=$setScreenBrightness3Level, setHandWashReminder=$setHandWashReminder, setLocalDial=$setLocalDial, setNotSupportHrHighAlarm=$setNotSupportHrHighAlarm, setNotSupportPhotoWallpaper=$setNotSupportPhotoWallpaper, setPressureHighReminder=$setPressureHighReminder, setWallpaperOnlyTimeColor=$setWallpaperOnlyTimeColor, setWallpaperDial=$setWallpaperDial, setSupportBreathRate=$setSupportBreathRate, setSupportCalorieUnit=$setSupportCalorieUnit, setSupportSportPlan=$setSupportSportPlan, setSupportSwimPoolUnit=$setSupportSwimPoolUnit, setSupportV3Bp=$setSupportV3Bp, setV3GetSportSortField=$setV3GetSportSortField, setWatchDialSort=$setWatchDialSort, setGetCalorieDistanceGoal=$setGetCalorieDistanceGoal, setMidHighTimeGoal=$setMidHighTimeGoal, setNewRetainData=$setNewRetainData, setScheduleReminder=$setScheduleReminder, setSet100SportSort=$setSet100SportSort, setSet20SportParamSort=$setSet20SportParamSort, setSetMainUiSort=$setSetMainUiSort, setSetStressCalibration=$setSetStressCalibration, setSmartHeartRate=$setSmartHeartRate, setSpo2AllDayOnOff=$setSpo2AllDayOnOff, setSupportAppSendVoiceToBle=$setSupportAppSendVoiceToBle, setSupportCyclingUnit=$setSupportCyclingUnit, setSupportWalkRunUnit=$setSupportWalkRunUnit, setWalkReminderTimeGoal=$setWalkReminderTimeGoal, setWatchCapacitySizeDisplay=$setWatchCapacitySizeDisplay, setWatchPhotoPositionMove=$setWatchPhotoPositionMove, setMenuListMain7=$setMenuListMain7, setHistoryMenstrual=$setHistoryMenstrual, supportHistoricalMenstruationExchange=$supportHistoricalMenstruationExchange, supportSetHistoricalMenstruationExchangeVersion21=$supportSetHistoricalMenstruationExchangeVersion21, supportHistoricalMenstruationExchangeVersion31=$supportHistoricalMenstruationExchangeVersion31, supportPhysiologicalRecord=$supportPhysiologicalRecord, setMenstrualAddPregnancy=$setMenstrualAddPregnancy, setNotSurportCalling3SDelay=$setNotSurportCalling3SDelay, setSetFitnessGuidance=$setSetFitnessGuidance, setSetNotificationStatus=$setSetNotificationStatus, setSetUnreadAppReminder=$setSetUnreadAppReminder, setSetV3Weather=$setSetV3Weather, setSetV3WeatherSunrise=$setSetV3WeatherSunrise, setSetV3WorldTime=$setSetV3WorldTime, setSyncContact=$setSyncContact, setSyncV3ActivityAddParam=$setSyncV3ActivityAddParam, setTransferMusicFile=$setTransferMusicFile, setWalkReminderAddNotify=$setWalkReminderAddNotify, setSupportFahrenheit=$setSupportFahrenheit, setGetAlarmSpecify=$setGetAlarmSpecify, setAirohaGpsChip=$setAirohaGpsChip, setSupportSecondSportIcon=$setSupportSecondSportIcon, setSportMediumIcon=$setSportMediumIcon, setWeatherSunTime=$setWeatherSunTime, setWeatherAirGrade=$setWeatherAirGrade, setDrinkWaterReminder=$setDrinkWaterReminder, supportBatteryReminderSwitch=$supportBatteryReminderSwitch, supportPetInfo=$supportPetInfo, setRespirationRate=$setRespirationRate, setMaxBloodOxygen=$setMaxBloodOxygen, setBleControlMusic=$setBleControlMusic, setMainPressure=$setMainPressure, setNoDisturbAllDayOnOff=$setNoDisturbAllDayOnOff, setOnlyNoDisturbAllDayOnOff=$setOnlyNoDisturbAllDayOnOff, setOnlyNoDisturbSmartOnOff=$setOnlyNoDisturbSmartOnOff, setTimeZoneFloat=$setTimeZoneFloat, setTemperatureSwitchSupport=$setTemperatureSwitchSupport, setMsgAllSwitch=$setMsgAllSwitch, setNotSupperCall3Delay=$setNotSupperCall3Delay, setNoticeMissedCallV2=$setNoticeMissedCallV2, setOverFindPhone=$setOverFindPhone, getHealthSwitchStateSupportV3=$getHealthSwitchStateSupportV3, setSedentariness=$setSedentariness, setScreenBrightness=$setScreenBrightness, setSetPhoneVoice=$setSetPhoneVoice, setSupportSetCallQuickReplyOnOff=$setSupportSetCallQuickReplyOnOff, setSupportExchangeSetGpsCoordinates=$setSupportExchangeSetGpsCoordinates, setSupportV3WeatherAddAtmosphericPressure=$setSupportV3WeatherAddAtmosphericPressure, setSupportSetV3WeatcherAddSnowDepth=$setSupportSetV3WeatcherAddSnowDepth, setSupportSetV3WeatcherAddSnowfall=$setSupportSetV3WeatcherAddSnowfall, setSupportSetV3WeatcherSendStructVersion04=$setSupportSetV3WeatcherSendStructVersion04, setSendCalibrationThreshold=$setSendCalibrationThreshold, getNotSupportAppSendRunPlan=$getNotSupportAppSendRunPlan, getSupportDisplayNapSleep=$getSupportDisplayNapSleep, getSupportGetSmartHeartRate=$getSupportGetSmartHeartRate, getSupportGetPressureSwitchInfo=$getSupportGetPressureSwitchInfo, getSupportECardOperate=$getSupportECardOperate, getSupportVoiceMemoOperate=$getSupportVoiceMemoOperate, getSupportMorningEdition=$getSupportMorningEdition, getSupportGetSpo2SwitchInfo=$getSupportGetSpo2SwitchInfo, getSupportSyncHealthHrUseVersionCompatible=$getSupportSyncHealthHrUseVersionCompatible, getSupportSetV3Add48HourWeatherData=$getSupportSetV3Add48HourWeatherData, getNotSupportIndoorRunGetVo2max=$getNotSupportIndoorRunGetVo2max, getSupportSetEcgReminder=$getSupportSetEcgReminder, getSupportSyncEcg=$getSupportSyncEcg, getSupportSetGameTimeReminder=$getSupportSetGameTimeReminder, getSupportConfigDefaultMegApplicationList=$getSupportConfigDefaultMegApplicationList, getSupportSetEciReminder=$getSupportSetEciReminder, setSupportNoiseSetNotifyFlag=$setSupportNoiseSetNotifyFlag, setSupportNoiseSetOverWarning=$setSupportNoiseSetOverWarning, setSupportSetVersionInformation=$setSupportSetVersionInformation, setSupportControlMiniProgram=$setSupportControlMiniProgram, getSupportSetWeatherHistoryFutureAqi=$getSupportSetWeatherHistoryFutureAqi, setBrightScreenTime=$setBrightScreenTime, setHeartSetRateModeCustom=$setHeartSetRateModeCustom, supportProtocolV3MenuList=$supportProtocolV3MenuList, languageCh=$languageCh, languageCzech=$languageCzech, languageEnglish=$languageEnglish, languageFrench=$languageFrench, languageGerman=$languageGerman, languageItalian=$languageItalian, languageJapanese=$languageJapanese, languageSpanish=$languageSpanish, languageArabic=$languageArabic, languageBurmese=$languageBurmese, languageFilipino=$languageFilipino, languageGreek=$languageGreek, languageThai=$languageThai, languageTraditionalChinese=$languageTraditionalChinese, languageVietnamese=$languageVietnamese, languageDutch=$languageDutch, languageHungarian=$languageHungarian, languageLithuanian=$languageLithuanian, languagePolish=$languagePolish, languageRomanian=$languageRomanian, languageRussian=$languageRussian, languageSlovenian=$languageSlovenian, languageUkrainian=$languageUkrainian, languageCroatian=$languageCroatian, languageDanish=$languageDanish, languageHindi=$languageHindi, languageIndonesian=$languageIndonesian, languageKorean=$languageKorean, languagePortuguese=$languagePortuguese, languageSlovak=$languageSlovak, languageTurkish=$languageTurkish, languagePersia=$languagePersia, languageSweden=$languageSweden, languageNorwegian=$languageNorwegian, languageFinland=$languageFinland, languageBengali=$languageBengali, languageKhmer=$languageKhmer, languageMalay=$languageMalay, languageBrazilianPortuguese=$languageBrazilianPortuguese, languageHebrew=$languageHebrew, languageSerbian=$languageSerbian, languageBulgaria=$languageBulgaria, syncV3Hr=$syncV3Hr, syncV3Swim=$syncV3Swim, syncV3Spo2=$syncV3Spo2, syncV3Pressure=$syncV3Pressure, syncV3Activity=$syncV3Activity, syncV3Sleep=$syncV3Sleep, syncV3PetSleep=$syncV3PetSleep, syncV3Sports=$syncV3Sports, syncV3Gps=$syncV3Gps, syncV3SyncAlarm=$syncV3SyncAlarm, syncV3BodyPower=$syncV3BodyPower, getSupportHrvV3=$getSupportHrvV3, getSupportPerBpV3=$getSupportPerBpV3, syncV3Noise=$syncV3Noise, syncV3Temperature=$syncV3Temperature, syncGps=$syncGps, syncV3ActivityExchangeData=$syncV3ActivityExchangeData, syncHeartRate=$syncHeartRate, syncHeartRateMonitor=$syncHeartRateMonitor, syncSleepMonitor=$syncSleepMonitor, syncFastSync=$syncFastSync, syncActivityTimeSync=$syncActivityTimeSync, syncTimeLine=$syncTimeLine, syncNeedV2=$syncNeedV2, syncRealTimeV3=$syncRealTimeV3, syncExchangeDataReplyAddRealTimeSpeedPaceV3=$syncExchangeDataReplyAddRealTimeSpeedPaceV3, syncHealthSyncV3ActivityEndTimeUseUtcMode=$syncHealthSyncV3ActivityEndTimeUseUtcMode, syncSupportSetFastModeWhenSyncConfig=$syncSupportSetFastModeWhenSyncConfig, getSupportAppBaseInformation=$getSupportAppBaseInformation, alarmCount=$alarmCount, alarmBrushTeeth=$alarmBrushTeeth, alarmDating=$alarmDating, alarmDinner=$alarmDinner, alarmMedicine=$alarmMedicine, alarmMeeting=$alarmMeeting, alarmParty=$alarmParty, alarmRest=$alarmRest, alarmSleep=$alarmSleep, alarmSport=$alarmSport, alarmWakeUp=$alarmWakeUp, supportSetAntilost=$supportSetAntilost, supportSetWeatherDataV2=$supportSetWeatherDataV2, supportSetOnetouchCalling=$supportSetOnetouchCalling, supportOperateSetSportScreen=$supportOperateSetSportScreen, supportOperateListStyle=$supportOperateListStyle, supportEmotionHealth=$supportEmotionHealth, supportV3SyncContactVersion20=$supportV3SyncContactVersion20, supportGetSosCallRecord=$supportGetSosCallRecord, alexaReminderAddSecV3=$alexaReminderAddSecV3, alexaSetEasyOperateV3=$alexaSetEasyOperateV3, alexaSetGetAlexaAlarmV3=$alexaSetGetAlexaAlarmV3, alexaSetJumpSportUiV3=$alexaSetJumpSportUiV3, alexaSetJumpUiV3=$alexaSetJumpUiV3, alexaSetSetOnOffTypeV3=$alexaSetSetOnOffTypeV3, alexaSetWeatherV3=$alexaSetWeatherV3, alexaTimeNewV3=$alexaTimeNewV3, setAlexaControll100brightness=$setAlexaControll100brightness, alexaGetSupportGetAlexaDefaultLanguage=$alexaGetSupportGetAlexaDefaultLanguage, alexaGetUIControllSports=$alexaGetUIControllSports, getLeftRightHandWearSettings=$getLeftRightHandWearSettings, supportSettingsDuringExercise=$supportSettingsDuringExercise, supportHeightLengthUnit=$supportHeightLengthUnit, supportSportingRemindSetting=$supportSportingRemindSetting, supportSportGetAutoPauseEnd=$supportSportGetAutoPauseEnd, supportSetStrideLengthUnit=$supportSetStrideLengthUnit, supportSimpleHrZoneSetting=$supportSimpleHrZoneSetting, notSupportSmartLowHeartReatRemind=$notSupportSmartLowHeartReatRemind, notSupportSmartHighHeartReatRemind=$notSupportSmartHighHeartReatRemind, notSupportPhotoPreviewControl=$notSupportPhotoPreviewControl, supportGetUserInfo=$supportGetUserInfo, supportMissedCallMsgTypeUseFixed=$supportMissedCallMsgTypeUseFixed, supportAppNotDisplayAlarmName=$supportAppNotDisplayAlarmName, supportSetSleepRemind=$supportSetSleepRemind, supportBloodGlucose=$supportBloodGlucose, supportBloodGlucoseV01=$supportBloodGlucoseV01, supportBikeLockManager=$supportBikeLockManager, supportAlgorithmRawDataCollect=$supportAlgorithmRawDataCollect, supportOfflineMapInformation=$supportOfflineMapInformation, supportHeartRateReserveZones=$supportHeartRateReserveZones, supportHeartRateZonesHrMaxSet=$supportHeartRateZonesHrMaxSet, supportSyncMultiActivityNew=$supportSyncMultiActivityNew, supportContactFileUseFirmwareReturnSize=$supportContactFileUseFirmwareReturnSize, supportDisplayCameraEntry=$supportDisplayCameraEntry, supportOperateFamilyCareReminder3376=$supportOperateFamilyCareReminder3376, supportProtocolV3MenstruationConfig3377=$supportProtocolV3MenstruationConfig3377, supportOperateHabitFormation=$supportOperateHabitFormation, supportOperateHabitFormationV01=$supportOperateHabitFormationV01, supportOperateFamilySteps=$supportOperateFamilySteps, supportOperateSetGame=$supportOperateSetGame, supportOperateGestureControl=$supportOperateGestureControl)"
    }

    override val reminderAncs: Boolean
        get() = funInfo()?.reminderAncs ?: false

    override val reminderSnapchat: Boolean
        get() = funInfo()?.reminderSnapchat ?: false

    override val reminderLine: Boolean
        get() = funInfo()?.reminderLine ?: false

    override val reminderOutlook: Boolean
        get() = funInfo()?.reminderOutlook ?: false

    override val reminderTelegram: Boolean
        get() = funInfo()?.reminderTelegram ?: false

    override val reminderViber: Boolean
        get() = funInfo()?.reminderViber ?: false

    override val reminderVkontakte: Boolean
        get() = funInfo()?.reminderVkontakte ?: false

    override val reminderChatwork: Boolean
        get() = funInfo()?.reminderChatwork ?: false

    override val reminderSlack: Boolean
        get() = funInfo()?.reminderSlack ?: false

    override val reminderTumblr: Boolean
        get() = funInfo()?.reminderTumblr ?: false

    override val reminderYahooMail: Boolean
        get() = funInfo()?.reminderYahooMail ?: false

    override val reminderYahooPinterest: Boolean
        get() = funInfo()?.reminderYahooPinterest ?: false

    override val reminderYoutube: Boolean
        get() = funInfo()?.reminderYoutube ?: false

    override val reminderGmail: Boolean
        get() = funInfo()?.reminderGmail ?: false

    override val reminderKakaoTalk: Boolean
        get() = funInfo()?.reminderKakaoTalk ?: false

    override val reminderOnlyGoogleGmail: Boolean
        get() = funInfo()?.reminderOnlyGoogleGmail ?: false

    override val reminderOnlyOutlookEmail: Boolean
        get() = funInfo()?.reminderOnlyOutlookEmail ?: false

    override val reminderOnlyYahooEmail: Boolean
        get() = funInfo()?.reminderOnlyYahooEmail ?: false

    override val reminderTiktok: Boolean
        get() = funInfo()?.reminderTiktok ?: false

    override val reminderRedbus: Boolean
        get() = funInfo()?.reminderRedbus ?: false

    override val reminderDailyhunt: Boolean
        get() = funInfo()?.reminderDailyhunt ?: false

    override val reminderHotstar: Boolean
        get() = funInfo()?.reminderHotstar ?: false

    override val reminderInshorts: Boolean
        get() = funInfo()?.reminderInshorts ?: false

    override val reminderPaytm: Boolean
        get() = funInfo()?.reminderPaytm ?: false

    override val reminderAmazon: Boolean
        get() = funInfo()?.reminderAmazon ?: false

    override val reminderFlipkart: Boolean
        get() = funInfo()?.reminderFlipkart ?: false

    override val reminderNhnEmail: Boolean
        get() = funInfo()?.reminderNhnEmail ?: false

    override val reminderInstantEmail: Boolean
        get() = funInfo()?.reminderInstantEmail ?: false

    override val reminderZohoEmail: Boolean
        get() = funInfo()?.reminderZohoEmail ?: false

    override val reminderExchangeEmail: Boolean
        get() = funInfo()?.reminderExchangeEmail ?: false

    override val reminder189Email: Boolean
        get() = funInfo()?.reminder189Email ?: false

    override val reminderVeryFit: Boolean
        get() = funInfo()?.reminderVeryFit ?: false

    override val reminderGeneral: Boolean
        get() = funInfo()?.reminderGeneral ?: false

    override val reminderOther: Boolean
        get() = funInfo()?.reminderOther ?: false

    override val reminderMattersRemind: Boolean
        get() = funInfo()?.reminderMattersRemind ?: false

    override val reminderMicrosoft: Boolean
        get() = funInfo()?.reminderMicrosoft ?: false

    override val reminderMissedCall: Boolean
        get() = funInfo()?.reminderMissedCall ?: false

    override val reminderGetAllContact: Boolean
        get() = funInfo()?.reminderGetAllContact ?: false

    override val reminderWhatsappBusiness: Boolean
        get() = funInfo()?.reminderWhatsappBusiness ?: false

    override val reminderEmail: Boolean
        get() = funInfo()?.reminderEmail ?: false

    override val reminderFacebook: Boolean
        get() = funInfo()?.reminderFacebook ?: false

    override val reminderMessage: Boolean
        get() = funInfo()?.reminderMessage ?: false

    override val reminderQq: Boolean
        get() = funInfo()?.reminderQq ?: false

    override val reminderTwitter: Boolean
        get() = funInfo()?.reminderTwitter ?: false

    override val reminderWeixin: Boolean
        get() = funInfo()?.reminderWeixin ?: false

    override val reminderCalendarGoogle: Boolean
        get() = funInfo()?.reminderCalendarGoogle ?: false

    override val reminderInstagram: Boolean
        get() = funInfo()?.reminderInstagram ?: false

    override val reminderLinkedIn: Boolean
        get() = funInfo()?.reminderLinkedIn ?: false

    override val reminderMessengre: Boolean
        get() = funInfo()?.reminderMessengre ?: false

    override val reminderSkype: Boolean
        get() = funInfo()?.reminderSkype ?: false

    override val reminderCalendar: Boolean
        get() = funInfo()?.reminderCalendar ?: false

    override val reminderWhatsapp: Boolean
        get() = funInfo()?.reminderWhatsapp ?: false

    override val reminderAlarmClock: Boolean
        get() = funInfo()?.reminderAlarmClock ?: false

    override val reminderSinaWeibo: Boolean
        get() = funInfo()?.reminderSinaWeibo ?: false

    override val reminderWeibo: Boolean
        get() = funInfo()?.reminderWeibo ?: false

    override val reminderCalling: Boolean
        get() = funInfo()?.reminderCalling ?: false

    override val reminderCallContact: Boolean
        get() = funInfo()?.reminderCallContact ?: false

    override val reminderCallNum: Boolean
        get() = funInfo()?.reminderCallNum ?: false

    override val reminderPrime: Boolean
        get() = funInfo()?.reminderPrime ?: false

    override val reminderNetflix: Boolean
        get() = funInfo()?.reminderNetflix ?: false

    override val reminderGpay: Boolean
        get() = funInfo()?.reminderGpay ?: false

    override val reminderPhonpe: Boolean
        get() = funInfo()?.reminderPhonpe ?: false

    override val reminderSwiggy: Boolean
        get() = funInfo()?.reminderSwiggy ?: false

    override val reminderZomato: Boolean
        get() = funInfo()?.reminderZomato ?: false

    override val reminderMakemytrip: Boolean
        get() = funInfo()?.reminderMakemytrip ?: false

    override val reminderJioTv: Boolean
        get() = funInfo()?.reminderJioTv ?: false

    override val reminderNiosefit: Boolean
        get() = funInfo()?.reminderNiosefit ?: false

    override val reminderYtmusic: Boolean
        get() = funInfo()?.reminderYtmusic ?: false

    override val reminderUber: Boolean
        get() = funInfo()?.reminderUber ?: false

    override val reminderOla: Boolean
        get() = funInfo()?.reminderOla ?: false

    override val reminderGoogleMeet: Boolean
        get() = funInfo()?.reminderGoogleMeet ?: false

    override val reminderMormaiiSmartwatch: Boolean
        get() = funInfo()?.reminderMormaiiSmartwatch ?: false

    override val reminderTechnosConnect: Boolean
        get() = funInfo()?.reminderTechnosConnect ?: false

    override val reminderEnjoei: Boolean
        get() = funInfo()?.reminderEnjoei ?: false

    override val reminderAliexpress: Boolean
        get() = funInfo()?.reminderAliexpress ?: false

    override val reminderShopee: Boolean
        get() = funInfo()?.reminderShopee ?: false

    override val reminderTeams: Boolean
        get() = funInfo()?.reminderTeams ?: false

    override val reminder99Taxi: Boolean
        get() = funInfo()?.reminder99Taxi ?: false

    override val reminderUberEats: Boolean
        get() = funInfo()?.reminderUberEats ?: false

    override val reminderLfood: Boolean
        get() = funInfo()?.reminderLfood ?: false

    override val reminderRappi: Boolean
        get() = funInfo()?.reminderRappi ?: false

    override val reminderMercadoLivre: Boolean
        get() = funInfo()?.reminderMercadoLivre ?: false

    override val reminderMagalu: Boolean
        get() = funInfo()?.reminderMagalu ?: false

    override val reminderAmericanas: Boolean
        get() = funInfo()?.reminderAmericanas ?: false

    override val reminderYahoo: Boolean
        get() = funInfo()?.reminderYahoo ?: false

    override val reminderMessageIcon: Boolean
        get() = funInfo()?.reminderMessageIcon ?: false

    override val reminderTaobao: Boolean
        get() = funInfo()?.reminderTaobao ?: false

    override val reminderDingding: Boolean
        get() = funInfo()?.reminderDingding ?: false

    override val reminderAlipay: Boolean
        get() = funInfo()?.reminderAlipay ?: false

    override val reminderToutiao: Boolean
        get() = funInfo()?.reminderToutiao ?: false

    override val reminderDouyin: Boolean
        get() = funInfo()?.reminderDouyin ?: false

    override val reminderTmall: Boolean
        get() = funInfo()?.reminderTmall ?: false

    override val reminderJd: Boolean
        get() = funInfo()?.reminderJd ?: false

    override val reminderPinduoduo: Boolean
        get() = funInfo()?.reminderPinduoduo ?: false

    override val reminderBaidu: Boolean
        get() = funInfo()?.reminderBaidu ?: false

    override val reminderMeituan: Boolean
        get() = funInfo()?.reminderMeituan ?: false

    override val reminderEleme: Boolean
        get() = funInfo()?.reminderEleme ?: false

    override val sportWalk: Boolean
        get() = funInfo()?.sportWalk ?: false

    override val sportRun: Boolean
        get() = funInfo()?.sportRun ?: false

    override val sportByBike: Boolean
        get() = funInfo()?.sportByBike ?: false

    override val sportOnFoot: Boolean
        get() = funInfo()?.sportOnFoot ?: false

    override val sportSwim: Boolean
        get() = funInfo()?.sportSwim ?: false

    override val sportMountainClimbing: Boolean
        get() = funInfo()?.sportMountainClimbing ?: false

    override val sportBadminton: Boolean
        get() = funInfo()?.sportBadminton ?: false

    override val sportOther: Boolean
        get() = funInfo()?.sportOther ?: false

    override val sportFitness: Boolean
        get() = funInfo()?.sportFitness ?: false

    override val sportSpinning: Boolean
        get() = funInfo()?.sportSpinning ?: false

    override val sportEllipsoid: Boolean
        get() = funInfo()?.sportEllipsoid ?: false

    override val sportTreadmill: Boolean
        get() = funInfo()?.sportTreadmill ?: false

    override val sportSitUp: Boolean
        get() = funInfo()?.sportSitUp ?: false

    override val sportPushUp: Boolean
        get() = funInfo()?.sportPushUp ?: false

    override val sportDumbbell: Boolean
        get() = funInfo()?.sportDumbbell ?: false

    override val sportWeightlifting: Boolean
        get() = funInfo()?.sportWeightlifting ?: false

    override val sportBodybuildingExercise: Boolean
        get() = funInfo()?.sportBodybuildingExercise ?: false

    override val sportYoga: Boolean
        get() = funInfo()?.sportYoga ?: false

    override val sportRopeSkipping: Boolean
        get() = funInfo()?.sportRopeSkipping ?: false

    override val sportTableTennis: Boolean
        get() = funInfo()?.sportTableTennis ?: false

    override val sportBasketball: Boolean
        get() = funInfo()?.sportBasketball ?: false

    override val sportFootballl: Boolean
        get() = funInfo()?.sportFootballl ?: false

    override val sportVolleyball: Boolean
        get() = funInfo()?.sportVolleyball ?: false

    override val sportTennis: Boolean
        get() = funInfo()?.sportTennis ?: false

    override val sportGolf: Boolean
        get() = funInfo()?.sportGolf ?: false

    override val sportBaseball: Boolean
        get() = funInfo()?.sportBaseball ?: false

    override val sportSkiing: Boolean
        get() = funInfo()?.sportSkiing ?: false

    override val sportRollerSkating: Boolean
        get() = funInfo()?.sportRollerSkating ?: false

    override val sportDance: Boolean
        get() = funInfo()?.sportDance ?: false

    override val sportStrengthTraining: Boolean
        get() = funInfo()?.sportStrengthTraining ?: false

    override val sportCoreTraining: Boolean
        get() = funInfo()?.sportCoreTraining ?: false

    override val sportTidyUpRelax: Boolean
        get() = funInfo()?.sportTidyUpRelax ?: false

    override val sportTraditionalStrengthTraining: Boolean
        get() = funInfo()?.sportTraditionalStrengthTraining ?: false

    override val sportOutdoorRun: Boolean
        get() = funInfo()?.sportOutdoorRun ?: false

    override val sportIndoorRun: Boolean
        get() = funInfo()?.sportIndoorRun ?: false

    override val sportOutdoorCycle: Boolean
        get() = funInfo()?.sportOutdoorCycle ?: false

    override val sportIndoorCycle: Boolean
        get() = funInfo()?.sportIndoorCycle ?: false

    override val sportOutdoorWalk: Boolean
        get() = funInfo()?.sportOutdoorWalk ?: false

    override val sportIndoorWalk: Boolean
        get() = funInfo()?.sportIndoorWalk ?: false

    override val sportPoolSwim: Boolean
        get() = funInfo()?.sportPoolSwim ?: false

    override val sportOpenWaterSwim: Boolean
        get() = funInfo()?.sportOpenWaterSwim ?: false

    override val sportElliptical: Boolean
        get() = funInfo()?.sportElliptical ?: false

    override val sportRower: Boolean
        get() = funInfo()?.sportRower ?: false

    override val sportHiit: Boolean
        get() = funInfo()?.sportHiit ?: false

    override val sportCricket: Boolean
        get() = funInfo()?.sportCricket ?: false

    override val sportPilates: Boolean
        get() = funInfo()?.sportPilates ?: false

    override val sportOutdoorFun: Boolean
        get() = funInfo()?.sportOutdoorFun ?: false

    override val sportOtherActivity: Boolean
        get() = funInfo()?.sportOtherActivity ?: false

    override val sportZumba: Boolean
        get() = funInfo()?.sportZumba ?: false

    override val sportSurfing: Boolean
        get() = funInfo()?.sportSurfing ?: false

    override val sportFootvolley: Boolean
        get() = funInfo()?.sportFootvolley ?: false

    override val sportStandWaterSkiing: Boolean
        get() = funInfo()?.sportStandWaterSkiing ?: false

    override val sportBattlingRope: Boolean
        get() = funInfo()?.sportBattlingRope ?: false

    override val sportSkateboard: Boolean
        get() = funInfo()?.sportSkateboard ?: false

    override val sportNoticeStepper: Boolean
        get() = funInfo()?.sportNoticeStepper ?: false

    override val sportShowNum: Int
        get() = funInfo()?.sportShowNum ?: 0

    override val sportAerobicsBodybuildingExercise: Boolean
        get() = funInfo()?.sportAerobicsBodybuildingExercise ?: false

    override val sportPullUp: Boolean
        get() = funInfo()?.sportPullUp ?: false

    override val sportHighBar: Boolean
        get() = funInfo()?.sportHighBar ?: false

    override val sportParallelBars: Boolean
        get() = funInfo()?.sportParallelBars ?: false

    override val sportTrailRunning: Boolean
        get() = funInfo()?.sportTrailRunning ?: false

    override val sportPickleBall: Boolean
        get() = funInfo()?.sportPickleBall ?: false

    override val sportSnowboard: Boolean
        get() = funInfo()?.sportSnowboard ?: false

    override val sportCrossCountrySkiing: Boolean
        get() = funInfo()?.sportCrossCountrySkiing ?: false

    override val getRealtimeData: Boolean
        get() = funInfo()?.getRealtimeData ?: false

    override val getLangLibraryV3: Boolean
        get() = funInfo()?.getLangLibraryV3 ?: false

    override val getFindPhone: Boolean
        get() = funInfo()?.getFindPhone ?: false

    override val getFindDevice: Boolean
        get() = funInfo()?.getFindDevice ?: false

    override val getUpHandGestureEx: Boolean
        get() = funInfo()?.getUpHandGestureEx ?: false

    override val getUpHandGesture: Boolean
        get() = funInfo()?.getUpHandGesture ?: false

    override val getWeather: Boolean
        get() = funInfo()?.getWeather ?: false

    override val getDownloadLanguage: Boolean
        get() = funInfo()?.getDownloadLanguage ?: false

    override val getFactoryReset: Boolean
        get() = funInfo()?.getFactoryReset ?: false

    override val getFlashLog: Boolean
        get() = funInfo()?.getFlashLog ?: false

    override val getMultiActivityNoUseApp: Boolean
        get() = funInfo()?.getMultiActivityNoUseApp ?: false

    override val getMultiDial: Boolean
        get() = funInfo()?.getMultiDial ?: false

    override val getMenuList: Boolean
        get() = funInfo()?.getMenuList ?: false

    override val getDoNotDisturbMain3: Boolean
        get() = funInfo()?.getDoNotDisturbMain3 ?: false

    override val getVoiceTransmission: Boolean
        get() = funInfo()?.getVoiceTransmission ?: false

    override val setDrinkWaterAddNotifyFlag: Boolean
        get() = funInfo()?.setDrinkWaterAddNotifyFlag ?: false

    override val setSpo2LowValueRemindAddNotifyFlag: Boolean
        get() = funInfo()?.setSpo2LowValueRemindAddNotifyFlag ?: false

    override val notSupportSmartHeartNotifyFlag: Boolean
        get() = funInfo()?.notSupportSmartHeartNotifyFlag ?: false

    override val getDeviceLogState: Boolean
        get() = funInfo()?.getDeviceLogState ?: false

    override val getNewWatchList: Boolean
        get() = funInfo()?.getNewWatchList ?: false

    override val getNotifyIconAdaptive: Boolean
        get() = funInfo()?.getNotifyIconAdaptive ?: false

    override val getPressureNotifyFlagMode: Boolean
        get() = funInfo()?.getPressureNotifyFlagMode ?: false

    override val getScientificSleep: Boolean
        get() = funInfo()?.getScientificSleep ?: false

    override val getSpo2NotifyFlag: Boolean
        get() = funInfo()?.getSpo2NotifyFlag ?: false

    override val getV3Log: Boolean
        get() = funInfo()?.getV3Log ?: false

    override val getWatchID: Boolean
        get() = funInfo()?.getWatchID ?: false

    override val getDeviceName: Boolean
        get() = funInfo()?.getDeviceName ?: false

    override val getBatteryLog: Boolean
        get() = funInfo()?.getBatteryLog ?: false

    override val getBatteryInfo: Boolean
        get() = funInfo()?.getBatteryInfo ?: false

    override val getHeatLog: Boolean
        get() = funInfo()?.getHeatLog ?: false

    override val getWalkReminderV3: Boolean
        get() = funInfo()?.getWalkReminderV3 ?: false

    override val getSupportV3BleMusic: Boolean
        get() = funInfo()?.getSupportV3BleMusic ?: false

    override val getSupportGetBleBeepV3: Boolean
        get() = funInfo()?.getSupportGetBleBeepV3 ?: false

    override val getVeryFitNotSupportPhotoWallpaperV3: Boolean
        get() = funInfo()?.getVeryFitNotSupportPhotoWallpaperV3 ?: false

    override val getSupportUpdateGps: Boolean
        get() = funInfo()?.getSupportUpdateGps ?: false

    override val getUbloxModel: Boolean
        get() = funInfo()?.getUbloxModel ?: false

    override val getSupportGetBleMusicInfoVerV3: Boolean
        get() = funInfo()?.getSupportGetBleMusicInfoVerV3 ?: false

    override val getBtVersion: Boolean
        get() = funInfo()?.getBtVersion ?: false

    override val getSportsTypeV3: Boolean
        get() = funInfo()?.getSportsTypeV3 ?: false

    override val getActivitySwitch: Boolean
        get() = funInfo()?.getActivitySwitch ?: false

    override val getNoticeIconInformation: Boolean
        get() = funInfo()?.getNoticeIconInformation ?: false

    override val getSetMaxItemsNum: Boolean
        get() = funInfo()?.getSetMaxItemsNum ?: false

    override val getNotifyMsgV3: Boolean
        get() = funInfo()?.getNotifyMsgV3 ?: false

    override val getScreenBrightnessMain9: Boolean
        get() = funInfo()?.getScreenBrightnessMain9 ?: false

    override val getNotice128byte: Boolean
        get() = funInfo()?.getNotice128byte ?: false

    override val getNotice250byte: Boolean
        get() = funInfo()?.getNotice250byte ?: false

    override val getDeletableMenuListV2: Boolean
        get() = funInfo()?.getDeletableMenuListV2 ?: false

    override val getSupportPairEachConnect: Boolean
        get() = funInfo()?.getSupportPairEachConnect ?: false

    override val getSupportGetMainSportGoalV3: Boolean
        get() = funInfo()?.getSupportGetMainSportGoalV3 ?: false

    override val getBtAddrV2: Boolean
        get() = funInfo()?.getBtAddrV2 ?: false

    override val getSupportBpSetOrMeasurementV2: Boolean
        get() = funInfo()?.getSupportBpSetOrMeasurementV2 ?: false

    override val getMenstrualAddNotifyFlagV3: Boolean
        get() = funInfo()?.getMenstrualAddNotifyFlagV3 ?: false

    override val getSupportSetGetTimeGoalTypeV2: Boolean
        get() = funInfo()?.getSupportSetGetTimeGoalTypeV2 ?: false

    override val getOxygenDataSupportGradeV3: Boolean
        get() = funInfo()?.getOxygenDataSupportGradeV3 ?: false

    override val getSupportSyncActivityDataAltitudeInfo: Boolean
        get() = funInfo()?.getSupportSyncActivityDataAltitudeInfo ?: false

    override val getBindCodeAuth: Boolean
        get() = funInfo()?.getBindCodeAuth ?: false

    override val getSpo2OffChangeV3: Boolean
        get() = funInfo()?.getSpo2OffChangeV3 ?: false

    override val getLevel5HrInterval: Boolean
        get() = funInfo()?.getLevel5HrInterval ?: false

    override val getFiveHRInterval: Boolean
        get() = funInfo()?.getFiveHRInterval ?: false

    override val getBleAndBtVersion: Boolean
        get() = funInfo()?.getBleAndBtVersion ?: false

    override val getSupportSetGetEmergencyContactV3: Boolean
        get() = funInfo()?.getSupportSetGetEmergencyContactV3 ?: false

    override val getSupportSetRepeatWeekTypeOnScheduleReminderV3: Boolean
        get() = funInfo()?.getSupportSetRepeatWeekTypeOnScheduleReminderV3 ?: false

    override val getSupportSetRepeatTypeOnScheduleReminderV3: Boolean
        get() = funInfo()?.getSupportSetRepeatTypeOnScheduleReminderV3 ?: false

    override val getSupportSetMenstrualReminderOnOff: Boolean
        get() = funInfo()?.getSupportSetMenstrualReminderOnOff ?: false

    override val getVersionInfo: Boolean
        get() = funInfo()?.getVersionInfo ?: false

    override val getMtu: Boolean
        get() = funInfo()?.getMtu ?: false

    override val getDeviceUpdateState: Boolean
        get() = funInfo()?.getDeviceUpdateState ?: false

    override val getHeartRateModeV2: Boolean
        get() = funInfo()?.getHeartRateModeV2 ?: false

    override val getStepDataTypeV2: Boolean
        get() = funInfo()?.getStepDataTypeV2 ?: false

    override val getFastMsgDataV3: Boolean
        get() = funInfo()?.getFastMsgDataV3 ?: false

    override val getSupportCallingQuickReply: Boolean
        get() = funInfo()?.getSupportCallingQuickReply ?: false

    override val getSupportDataTranGetNewErrorCodeV3: Boolean
        get() = funInfo()?.getSupportDataTranGetNewErrorCodeV3 ?: false

    override val getAutoActivityEndSwitchNotDisplay: Boolean
        get() = funInfo()?.getAutoActivityEndSwitchNotDisplay ?: false

    override val getAutoActivityPauseSwitchNotDisplay: Boolean
        get() = funInfo()?.getAutoActivityPauseSwitchNotDisplay ?: false

    override val getV3AutoActivitySwitch: Boolean
        get() = funInfo()?.getV3AutoActivitySwitch ?: false

    override val getAutoActivitySwitchAddBicycle: Boolean
        get() = funInfo()?.getAutoActivitySwitchAddBicycle ?: false

    override val getAutoActivitySwitchAddSmartRope: Boolean
        get() = funInfo()?.getAutoActivitySwitchAddSmartRope ?: false

    override val getAutoActivitySetGetUseNewStructExchange: Boolean
        get() = funInfo()?.getAutoActivitySetGetUseNewStructExchange ?: false

    override val getSupportSetGetNoReminderOnWalkReminderV2: Boolean
        get() = funInfo()?.getSupportSetGetNoReminderOnWalkReminderV2 ?: false

    override val getSupportGetSnInfo: Boolean
        get() = funInfo()?.getSupportGetSnInfo ?: false

    override val getScheduleReminderNotDisplayTitle: Boolean
        get() = funInfo()?.getScheduleReminderNotDisplayTitle ?: false

    override val getSupportV3LongCityName: Boolean
        get() = funInfo()?.getSupportV3LongCityName ?: false

    override val getSupportAddNightLevelV2: Boolean
        get() = funInfo()?.getSupportAddNightLevelV2 ?: false

    override val getSupportDialFrameEncodeFormatArgb6666: Boolean
        get() = funInfo()?.getSupportDialFrameEncodeFormatArgb6666 ?: false

    override val getSupportAppSendPhoneSystemInfo: Boolean
        get() = funInfo()?.getSupportAppSendPhoneSystemInfo ?: false

    override val getDeviceControlFastModeAlone: Boolean
        get() = funInfo()?.getDeviceControlFastModeAlone ?: false

    override val getSupportOnekeyDoubleContact: Boolean
        get() = funInfo()?.getSupportOnekeyDoubleContact ?: false

    override val getSupportSetVoiceAssistantStatus: Boolean
        get() = funInfo()?.getSupportSetVoiceAssistantStatus ?: false

    override val getSupportFlashLogSize: Boolean
        get() = funInfo()?.getSupportFlashLogSize ?: false

    override val supportDevReturnMeasuringValue: Boolean
        get() = funInfo()?.supportDevReturnMeasuringValue ?: false

    override val getSupportGetUnit: Boolean
        get() = funInfo()?.getSupportGetUnit ?: false

    override val getSupportRyzeConnect: Boolean
        get() = funInfo()?.getSupportRyzeConnect ?: false

    override val getSupportLoopsFit: Boolean
        get() = funInfo()?.getSupportLoopsFit ?: false

    override val getSupportTasSmart: Boolean
        get() = funInfo()?.getSupportTasSmart ?: false

    override val getNotSupportSetOvulation: Boolean
        get() = funInfo()?.getNotSupportSetOvulation ?: false

    override val getSupportWalkGoalSteps: Boolean
        get() = funInfo()?.getSupportWalkGoalSteps ?: false

    override val getNotSupportDeleteAddSportSort: Boolean
        get() = funInfo()?.getNotSupportDeleteAddSportSort ?: false

    override val getSupportSedentaryTensileHabitInfo: Boolean
        get() = funInfo()?.getSupportSedentaryTensileHabitInfo ?: false

    override val getSupportSendGpsLongitudeAndLatitude: Boolean
        get() = funInfo()?.getSupportSendGpsLongitudeAndLatitude ?: false

    override val getSupportGetV3DeviceBtConnectPhoneModel: Boolean
        get() = funInfo()?.getSupportGetV3DeviceBtConnectPhoneModel ?: false

    override val getSupportBloodPressureModelFileUpdate: Boolean
        get() = funInfo()?.getSupportBloodPressureModelFileUpdate ?: false

    override val getSupportDisturbHaveRangRepeat: Boolean
        get() = funInfo()?.getSupportDisturbHaveRangRepeat ?: false

    override val getSupportCalendarReminder: Boolean
        get() = funInfo()?.getSupportCalendarReminder ?: false

    override val getWatchDailSetAddSize: Boolean
        get() = funInfo()?.getWatchDailSetAddSize ?: false

    override val getSupportSyncOverHighLowHeartData: Boolean
        get() = funInfo()?.getSupportSyncOverHighLowHeartData ?: false

    override val getSupportPerMinuteOne: Boolean
        get() = funInfo()?.getSupportPerMinuteOne ?: false

    override val getSupportAchievedRemindOnOff: Boolean
        get() = funInfo()?.getSupportAchievedRemindOnOff ?: false

    override val getSupportDrinkPlan: Boolean
        get() = funInfo()?.getSupportDrinkPlan ?: false

    override val getSupportMakeWatchDialDecodeJpg: Boolean
        get() = funInfo()?.getSupportMakeWatchDialDecodeJpg ?: false

    override val getSupportSleepPlan: Boolean
        get() = funInfo()?.getSupportSleepPlan ?: false

    override val getSupportDeviceOperateAlgFile: Boolean
        get() = funInfo()?.getSupportDeviceOperateAlgFile ?: false

    override val getSupportSportRecordShowConfig: Boolean
        get() = funInfo()?.getSupportSportRecordShowConfig ?: false

    override val setNoticeMessageStateUseVersion0x20: Boolean
        get() = funInfo()?.setNoticeMessageStateUseVersion0x20 ?: false

    override val setScientificSleepSwitch: Boolean
        get() = funInfo()?.setScientificSleepSwitch ?: false

    override val setTemperatureSwitchHealth: Boolean
        get() = funInfo()?.setTemperatureSwitchHealth ?: false

    override val setHeartRateMonitor: Boolean
        get() = funInfo()?.setHeartRateMonitor ?: false

    override val setNoReminderOnDrinkReminder: Boolean
        get() = funInfo()?.setNoReminderOnDrinkReminder ?: false

    override val setAgpsOffLine: Boolean
        get() = funInfo()?.setAgpsOffLine ?: false

    override val setAgpsOnLine: Boolean
        get() = funInfo()?.setAgpsOnLine ?: false

    override val setSetV3HeartInterval: Boolean
        get() = funInfo()?.setSetV3HeartInterval ?: false

    override val setWeatherCity: Boolean
        get() = funInfo()?.setWeatherCity ?: false

    override val setDoNotDisturb: Boolean
        get() = funInfo()?.setDoNotDisturb ?: false

    override val setCalorieGoal: Boolean
        get() = funInfo()?.setCalorieGoal ?: false

    override val setMenstruation: Boolean
        get() = funInfo()?.setMenstruation ?: false

    override val setPressureData: Boolean
        get() = funInfo()?.setPressureData ?: false

    override val setSpo2Data: Boolean
        get() = funInfo()?.setSpo2Data ?: false

    override val setSportModeSort: Boolean
        get() = funInfo()?.setSportModeSort ?: false

    override val setActivitySwitch: Boolean
        get() = funInfo()?.setActivitySwitch ?: false

    override val setNightAutoBrightness: Boolean
        get() = funInfo()?.setNightAutoBrightness ?: false

    override val setScreenBrightness5Level: Boolean
        get() = funInfo()?.setScreenBrightness5Level ?: false

    override val setWalkReminder: Boolean
        get() = funInfo()?.setWalkReminder ?: false

    override val setScreenBrightness3Level: Boolean
        get() = funInfo()?.setScreenBrightness3Level ?: false

    override val setHandWashReminder: Boolean
        get() = funInfo()?.setHandWashReminder ?: false

    override val setLocalDial: Boolean
        get() = funInfo()?.setLocalDial ?: false

    override val setNotSupportHrHighAlarm: Boolean
        get() = funInfo()?.setNotSupportHrHighAlarm ?: false

    override val setNotSupportPhotoWallpaper: Boolean
        get() = funInfo()?.setNotSupportPhotoWallpaper ?: false

    override val setPressureHighReminder: Boolean
        get() = funInfo()?.setPressureHighReminder ?: false

    override val setWallpaperOnlyTimeColor: Boolean
        get() = funInfo()?.setWallpaperOnlyTimeColor ?: false

    override val setWallpaperDial: Boolean
        get() = funInfo()?.setWallpaperDial ?: false

    override val setSupportBreathRate: Boolean
        get() = funInfo()?.setSupportBreathRate ?: false

    override val setSupportCalorieUnit: Boolean
        get() = funInfo()?.setSupportCalorieUnit ?: false

    override val setSupportSportPlan: Boolean
        get() = funInfo()?.setSupportSportPlan ?: false

    override val setSupportSwimPoolUnit: Boolean
        get() = funInfo()?.setSupportSwimPoolUnit ?: false

    override val setSupportV3Bp: Boolean
        get() = funInfo()?.setSupportV3Bp ?: false

    override val setV3GetSportSortField: Boolean
        get() = funInfo()?.setV3GetSportSortField ?: false

    override val setWatchDialSort: Boolean
        get() = funInfo()?.setWatchDialSort ?: false

    override val setGetCalorieDistanceGoal: Boolean
        get() = funInfo()?.setGetCalorieDistanceGoal ?: false

    override val setMidHighTimeGoal: Boolean
        get() = funInfo()?.setMidHighTimeGoal ?: false

    override val setNewRetainData: Boolean
        get() = funInfo()?.setNewRetainData ?: false

    override val setScheduleReminder: Boolean
        get() = funInfo()?.setScheduleReminder ?: false

    override val setSet100SportSort: Boolean
        get() = funInfo()?.setSet100SportSort ?: false

    override val setSet20SportParamSort: Boolean
        get() = funInfo()?.setSet20SportParamSort ?: false

    override val setSetMainUiSort: Boolean
        get() = funInfo()?.setSetMainUiSort ?: false

    override val setSetStressCalibration: Boolean
        get() = funInfo()?.setSetStressCalibration ?: false

    override val setSmartHeartRate: Boolean
        get() = funInfo()?.setSmartHeartRate ?: false

    override val setSpo2AllDayOnOff: Boolean
        get() = funInfo()?.setSpo2AllDayOnOff ?: false

    override val setSupportAppSendVoiceToBle: Boolean
        get() = funInfo()?.setSupportAppSendVoiceToBle ?: false

    override val setSupportCyclingUnit: Boolean
        get() = funInfo()?.setSupportCyclingUnit ?: false

    override val setSupportWalkRunUnit: Boolean
        get() = funInfo()?.setSupportWalkRunUnit ?: false

    override val setWalkReminderTimeGoal: Boolean
        get() = funInfo()?.setWalkReminderTimeGoal ?: false

    override val setWatchCapacitySizeDisplay: Boolean
        get() = funInfo()?.setWatchCapacitySizeDisplay ?: false

    override val setWatchPhotoPositionMove: Boolean
        get() = funInfo()?.setWatchPhotoPositionMove ?: false

    override val setMenuListMain7: Boolean
        get() = funInfo()?.setMenuListMain7 ?: false

    override val setHistoryMenstrual: Boolean
        get() = funInfo()?.setHistoryMenstrual ?: false

    override val supportHistoricalMenstruationExchange: Boolean
        get() = funInfo()?.supportHistoricalMenstruationExchange ?: false

    override val supportSetHistoricalMenstruationExchangeVersion21: Boolean
        get() = funInfo()?.supportSetHistoricalMenstruationExchangeVersion21 ?: false

    override val supportHistoricalMenstruationExchangeVersion31: Boolean
        get() = funInfo()?.supportHistoricalMenstruationExchangeVersion31 ?: false

    override val supportPhysiologicalRecord: Boolean
        get() = funInfo()?.supportPhysiologicalRecord ?: false

    override val setMenstrualAddPregnancy: Boolean
        get() = funInfo()?.setMenstrualAddPregnancy ?: false

    override val setNotSurportCalling3SDelay: Boolean
        get() = funInfo()?.setNotSurportCalling3SDelay ?: false

    override val setSetFitnessGuidance: Boolean
        get() = funInfo()?.setSetFitnessGuidance ?: false

    override val setSetNotificationStatus: Boolean
        get() = funInfo()?.setSetNotificationStatus ?: false

    override val setSetUnreadAppReminder: Boolean
        get() = funInfo()?.setSetUnreadAppReminder ?: false

    override val setSetV3Weather: Boolean
        get() = funInfo()?.setSetV3Weather ?: false

    override val setSetV3WeatherSunrise: Boolean
        get() = funInfo()?.setSetV3WeatherSunrise ?: false

    override val setSetV3WorldTime: Boolean
        get() = funInfo()?.setSetV3WorldTime ?: false

    override val setSyncContact: Boolean
        get() = funInfo()?.setSyncContact ?: false

    override val setSyncV3ActivityAddParam: Boolean
        get() = funInfo()?.setSyncV3ActivityAddParam ?: false

    override val setTransferMusicFile: Boolean
        get() = funInfo()?.setTransferMusicFile ?: false

    override val setWalkReminderAddNotify: Boolean
        get() = funInfo()?.setWalkReminderAddNotify ?: false

    override val setSupportFahrenheit: Boolean
        get() = funInfo()?.setSupportFahrenheit ?: false

    override val setGetAlarmSpecify: Boolean
        get() = funInfo()?.setGetAlarmSpecify ?: false

    override val setAirohaGpsChip: Boolean
        get() = funInfo()?.setAirohaGpsChip ?: false

    override val setSupportSecondSportIcon: Boolean
        get() = funInfo()?.setSupportSecondSportIcon ?: false

    override val setSportMediumIcon: Boolean
        get() = funInfo()?.setSportMediumIcon ?: false

    override val setWeatherSunTime: Boolean
        get() = funInfo()?.setWeatherSunTime ?: false

    override val setWeatherAirGrade: Boolean
        get() = funInfo()?.setWeatherAirGrade ?: false

    override val setDrinkWaterReminder: Boolean
        get() = funInfo()?.setDrinkWaterReminder ?: false

    override val supportBatteryReminderSwitch: Boolean
        get() = funInfo()?.supportBatteryReminderSwitch ?: false

    override val supportPetInfo: Boolean
        get() = funInfo()?.supportPetInfo ?: false

    override val setRespirationRate: Boolean
        get() = funInfo()?.setRespirationRate ?: false

    override val setMaxBloodOxygen: Boolean
        get() = funInfo()?.setMaxBloodOxygen ?: false

    override val setBleControlMusic: Boolean
        get() = funInfo()?.setBleControlMusic ?: false

    override val setMainPressure: Boolean
        get() = funInfo()?.setMainPressure ?: false

    override val setNoDisturbAllDayOnOff: Boolean
        get() = funInfo()?.setNoDisturbAllDayOnOff ?: false

    override val setOnlyNoDisturbAllDayOnOff: Boolean
        get() = funInfo()?.setOnlyNoDisturbAllDayOnOff ?: false

    override val setOnlyNoDisturbSmartOnOff: Boolean
        get() = funInfo()?.setOnlyNoDisturbSmartOnOff ?: false

    override val setTimeZoneFloat: Boolean
        get() = funInfo()?.setTimeZoneFloat ?: false

    override val setTemperatureSwitchSupport: Boolean
        get() = funInfo()?.setTemperatureSwitchSupport ?: false

    override val setMsgAllSwitch: Boolean
        get() = funInfo()?.setMsgAllSwitch ?: false

    override val setNotSupperCall3Delay: Boolean
        get() = funInfo()?.setNotSupperCall3Delay ?: false

    override val setNoticeMissedCallV2: Boolean
        get() = funInfo()?.setNoticeMissedCallV2 ?: false

    override val setOverFindPhone: Boolean
        get() = funInfo()?.setOverFindPhone ?: false

    override val getHealthSwitchStateSupportV3: Boolean
        get() = funInfo()?.getHealthSwitchStateSupportV3 ?: false

    override val setSedentariness: Boolean
        get() = funInfo()?.setSedentariness ?: false

    override val setScreenBrightness: Boolean
        get() = funInfo()?.setScreenBrightness ?: false

    override val setSetPhoneVoice: Boolean
        get() = funInfo()?.setSetPhoneVoice ?: false

    override val setSupportSetCallQuickReplyOnOff: Boolean
        get() = funInfo()?.setSupportSetCallQuickReplyOnOff ?: false

    override val setSupportExchangeSetGpsCoordinates: Boolean
        get() = funInfo()?.setSupportExchangeSetGpsCoordinates ?: false

    override val setSupportV3WeatherAddAtmosphericPressure: Boolean
        get() = funInfo()?.setSupportV3WeatherAddAtmosphericPressure ?: false

    override val setSupportSetV3WeatcherAddSnowDepth: Boolean
        get() = funInfo()?.setSupportSetV3WeatcherAddSnowDepth ?: false

    override val setSupportSetV3WeatcherAddSnowfall: Boolean
        get() = funInfo()?.setSupportSetV3WeatcherAddSnowfall ?: false

    override val setSupportSetV3WeatcherSendStructVersion04: Boolean
        get() = funInfo()?.setSupportSetV3WeatcherSendStructVersion04 ?: false

    override val setSendCalibrationThreshold: Boolean
        get() = funInfo()?.setSendCalibrationThreshold ?: false

    override val getNotSupportAppSendRunPlan: Boolean
        get() = funInfo()?.getNotSupportAppSendRunPlan ?: false

    override val getSupportDisplayNapSleep: Boolean
        get() = funInfo()?.getSupportDisplayNapSleep ?: false

    override val getSupportGetSmartHeartRate: Boolean
        get() = funInfo()?.getSupportGetSmartHeartRate ?: false

    override val getSupportGetPressureSwitchInfo: Boolean
        get() = funInfo()?.getSupportGetPressureSwitchInfo ?: false

    override val getSupportECardOperate: Boolean
        get() = funInfo()?.getSupportECardOperate ?: false

    override val getSupportVoiceMemoOperate: Boolean
        get() = funInfo()?.getSupportVoiceMemoOperate ?: false

    override val getSupportMorningEdition: Boolean
        get() = funInfo()?.getSupportMorningEdition ?: false

    override val getSupportGetSpo2SwitchInfo: Boolean
        get() = funInfo()?.getSupportGetSpo2SwitchInfo ?: false

    override val getSupportSyncHealthHrUseVersionCompatible: Boolean
        get() = funInfo()?.getSupportSyncHealthHrUseVersionCompatible ?: false

    override val getSupportSetV3Add48HourWeatherData: Boolean
        get() = funInfo()?.getSupportSetV3Add48HourWeatherData ?: false

    override val getNotSupportIndoorRunGetVo2max: Boolean
        get() = funInfo()?.getNotSupportIndoorRunGetVo2max ?: false

    override val getSupportSetEcgReminder: Boolean
        get() = funInfo()?.getSupportSetEcgReminder ?: false

    override val getSupportSyncEcg: Boolean
        get() = funInfo()?.getSupportSyncEcg ?: false

    override val getSupportSetGameTimeReminder: Boolean
        get() = funInfo()?.getSupportSetGameTimeReminder ?: false

    override val getSupportConfigDefaultMegApplicationList: Boolean
        get() = funInfo()?.getSupportConfigDefaultMegApplicationList ?: false

    override val getSupportSetEciReminder: Boolean
        get() = funInfo()?.getSupportSetEciReminder ?: false

    override val setSupportNoiseSetNotifyFlag: Boolean
        get() = funInfo()?.setSupportNoiseSetNotifyFlag ?: false

    override val setSupportNoiseSetOverWarning: Boolean
        get() = funInfo()?.setSupportNoiseSetOverWarning ?: false

    override val setSupportSetVersionInformation: Boolean
        get() = funInfo()?.setSupportSetVersionInformation ?: false

    override val setSupportControlMiniProgram: Boolean
        get() = funInfo()?.setSupportControlMiniProgram ?: false

    override val getSupportSetWeatherHistoryFutureAqi: Boolean
        get() = funInfo()?.getSupportSetWeatherHistoryFutureAqi ?: false

    override val setBrightScreenTime: Boolean
        get() = funInfo()?.setBrightScreenTime ?: false

    override val setHeartSetRateModeCustom: Boolean
        get() = funInfo()?.setHeartSetRateModeCustom ?: false

    override val supportProtocolV3MenuList: Boolean
        get() = funInfo()?.supportProtocolV3MenuList ?: false

    override val languageCh: Boolean
        get() = funInfo()?.languageCh ?: false

    override val languageCzech: Boolean
        get() = funInfo()?.languageCzech ?: false

    override val languageEnglish: Boolean
        get() = funInfo()?.languageEnglish ?: false

    override val languageFrench: Boolean
        get() = funInfo()?.languageFrench ?: false

    override val languageGerman: Boolean
        get() = funInfo()?.languageGerman ?: false

    override val languageItalian: Boolean
        get() = funInfo()?.languageItalian ?: false

    override val languageJapanese: Boolean
        get() = funInfo()?.languageJapanese ?: false

    override val languageSpanish: Boolean
        get() = funInfo()?.languageSpanish ?: false

    override val languageArabic: Boolean
        get() = funInfo()?.languageArabic ?: false

    override val languageBurmese: Boolean
        get() = funInfo()?.languageBurmese ?: false

    override val languageFilipino: Boolean
        get() = funInfo()?.languageFilipino ?: false

    override val languageGreek: Boolean
        get() = funInfo()?.languageGreek ?: false

    override val languageThai: Boolean
        get() = funInfo()?.languageThai ?: false

    override val languageTraditionalChinese: Boolean
        get() = funInfo()?.languageTraditionalChinese ?: false

    override val languageVietnamese: Boolean
        get() = funInfo()?.languageVietnamese ?: false

    override val languageDutch: Boolean
        get() = funInfo()?.languageDutch ?: false

    override val languageHungarian: Boolean
        get() = funInfo()?.languageHungarian ?: false

    override val languageLithuanian: Boolean
        get() = funInfo()?.languageLithuanian ?: false

    override val languagePolish: Boolean
        get() = funInfo()?.languagePolish ?: false

    override val languageRomanian: Boolean
        get() = funInfo()?.languageRomanian ?: false

    override val languageRussian: Boolean
        get() = funInfo()?.languageRussian ?: false

    override val languageSlovenian: Boolean
        get() = funInfo()?.languageSlovenian ?: false

    override val languageUkrainian: Boolean
        get() = funInfo()?.languageUkrainian ?: false

    override val languageCroatian: Boolean
        get() = funInfo()?.languageCroatian ?: false

    override val languageDanish: Boolean
        get() = funInfo()?.languageDanish ?: false

    override val languageHindi: Boolean
        get() = funInfo()?.languageHindi ?: false

    override val languageIndonesian: Boolean
        get() = funInfo()?.languageIndonesian ?: false

    override val languageKorean: Boolean
        get() = funInfo()?.languageKorean ?: false

    override val languagePortuguese: Boolean
        get() = funInfo()?.languagePortuguese ?: false

    override val languageSlovak: Boolean
        get() = funInfo()?.languageSlovak ?: false

    override val languageTurkish: Boolean
        get() = funInfo()?.languageTurkish ?: false

    override val languagePersia: Boolean
        get() = funInfo()?.languagePersia ?: false

    override val languageSweden: Boolean
        get() = funInfo()?.languageSweden ?: false

    override val languageNorwegian: Boolean
        get() = funInfo()?.languageNorwegian ?: false

    override val languageFinland: Boolean
        get() = funInfo()?.languageFinland ?: false

    override val languageBengali: Boolean
        get() = funInfo()?.languageBengali ?: false

    override val languageKhmer: Boolean
        get() = funInfo()?.languageKhmer ?: false

    override val languageMalay: Boolean
        get() = funInfo()?.languageMalay ?: false

    override val languageBrazilianPortuguese: Boolean
        get() = funInfo()?.languageBrazilianPortuguese ?: false

    override val languageHebrew: Boolean
        get() = funInfo()?.languageHebrew ?: false

    override val languageSerbian: Boolean
        get() = funInfo()?.languageSerbian ?: false

    override val languageBulgaria: Boolean
        get() = funInfo()?.languageBulgaria ?: false

    override val syncV3Hr: Boolean
        get() = funInfo()?.syncV3Hr ?: false

    override val syncV3Swim: Boolean
        get() = funInfo()?.syncV3Swim ?: false

    override val syncV3Spo2: Boolean
        get() = funInfo()?.syncV3Spo2 ?: false

    override val syncV3Pressure: Boolean
        get() = funInfo()?.syncV3Pressure ?: false

    override val syncV3Activity: Boolean
        get() = funInfo()?.syncV3Activity ?: false

    override val syncV3Sleep: Boolean
        get() = funInfo()?.syncV3Sleep ?: false

    override val syncV3PetSleep: Boolean
        get() = funInfo()?.syncV3PetSleep ?: false

    override val syncV3Sports: Boolean
        get() = funInfo()?.syncV3Sports ?: false

    override val syncV3Gps: Boolean
        get() = funInfo()?.syncV3Gps ?: false

    override val syncV3SyncAlarm: Boolean
        get() = funInfo()?.syncV3SyncAlarm ?: false

    override val syncV3BodyPower: Boolean
        get() = funInfo()?.syncV3BodyPower ?: false

    override val getSupportHrvV3: Boolean
        get() = funInfo()?.getSupportHrvV3 ?: false

    override val getSupportPerBpV3: Boolean
        get() = funInfo()?.getSupportPerBpV3 ?: false

    override val syncV3Noise: Boolean
        get() = funInfo()?.syncV3Noise ?: false

    override val syncV3Temperature: Boolean
        get() = funInfo()?.syncV3Temperature ?: false

    override val syncGps: Boolean
        get() = funInfo()?.syncGps ?: false

    override val syncV3ActivityExchangeData: Boolean
        get() = funInfo()?.syncV3ActivityExchangeData ?: false

    override val syncHeartRate: Boolean
        get() = funInfo()?.syncHeartRate ?: false

    override val syncHeartRateMonitor: Boolean
        get() = funInfo()?.syncHeartRateMonitor ?: false

    override val syncSleepMonitor: Boolean
        get() = funInfo()?.syncSleepMonitor ?: false

    override val syncFastSync: Boolean
        get() = funInfo()?.syncFastSync ?: false

    override val syncActivityTimeSync: Boolean
        get() = funInfo()?.syncActivityTimeSync ?: false

    override val syncTimeLine: Boolean
        get() = funInfo()?.syncTimeLine ?: false

    override val syncNeedV2: Boolean
        get() = funInfo()?.syncNeedV2 ?: false

    override val syncRealTimeV3: Boolean
        get() = funInfo()?.syncRealTimeV3 ?: false

    override val syncExchangeDataReplyAddRealTimeSpeedPaceV3: Boolean
        get() = funInfo()?.syncExchangeDataReplyAddRealTimeSpeedPaceV3 ?: false

    override val syncHealthSyncV3ActivityEndTimeUseUtcMode: Boolean
        get() = funInfo()?.syncHealthSyncV3ActivityEndTimeUseUtcMode ?: false

    override val syncSupportSetFastModeWhenSyncConfig: Boolean
        get() = funInfo()?.syncSupportSetFastModeWhenSyncConfig ?: false

    override val getSupportAppBaseInformation: Boolean
        get() = funInfo()?.getSupportAppBaseInformation ?: false

    override val alarmCount: Int
        get() = funInfo()?.alarmCount ?: 0

    override val alarmBrushTeeth: Boolean
        get() = funInfo()?.alarmBrushTeeth ?: false

    override val alarmDating: Boolean
        get() = funInfo()?.alarmDating ?: false

    override val alarmDinner: Boolean
        get() = funInfo()?.alarmDinner ?: false

    override val alarmMedicine: Boolean
        get() = funInfo()?.alarmMedicine ?: false

    override val alarmMeeting: Boolean
        get() = funInfo()?.alarmMeeting ?: false

    override val alarmParty: Boolean
        get() = funInfo()?.alarmParty ?: false

    override val alarmRest: Boolean
        get() = funInfo()?.alarmRest ?: false

    override val alarmSleep: Boolean
        get() = funInfo()?.alarmSleep ?: false

    override val alarmSport: Boolean
        get() = funInfo()?.alarmSport ?: false

    override val alarmWakeUp: Boolean
        get() = funInfo()?.alarmWakeUp ?: false

    override val supportSetAntilost: Boolean
        get() = funInfo()?.supportSetAntilost ?: false

    override val supportSetWeatherDataV2: Boolean
        get() = funInfo()?.supportSetWeatherDataV2 ?: false

    override val supportSetOnetouchCalling: Boolean
        get() = funInfo()?.supportSetOnetouchCalling ?: false

    override val supportOperateSetSportScreen: Boolean
        get() = funInfo()?.supportOperateSetSportScreen ?: false

    override val supportOperateListStyle: Boolean
        get() = funInfo()?.supportOperateListStyle ?: false

    override val supportEmotionHealth: Boolean
        get() = funInfo()?.supportEmotionHealth ?: false

    override val supportV3SyncContactVersion20: Boolean
        get() = funInfo()?.supportV3SyncContactVersion20 ?: false

    override val supportGetSosCallRecord: Boolean
        get() = funInfo()?.supportGetSosCallRecord ?: false

    override val alexaReminderAddSecV3: Boolean
        get() = funInfo()?.alexaReminderAddSecV3 ?: false

    override val alexaSetEasyOperateV3: Boolean
        get() = funInfo()?.alexaSetEasyOperateV3 ?: false

    override val alexaSetGetAlexaAlarmV3: Boolean
        get() = funInfo()?.alexaSetGetAlexaAlarmV3 ?: false

    override val alexaSetJumpSportUiV3: Boolean
        get() = funInfo()?.alexaSetJumpSportUiV3 ?: false

    override val alexaSetJumpUiV3: Boolean
        get() = funInfo()?.alexaSetJumpUiV3 ?: false

    override val alexaSetSetOnOffTypeV3: Boolean
        get() = funInfo()?.alexaSetSetOnOffTypeV3 ?: false

    override val alexaSetWeatherV3: Boolean
        get() = funInfo()?.alexaSetWeatherV3 ?: false

    override val alexaTimeNewV3: Boolean
        get() = funInfo()?.alexaTimeNewV3 ?: false

    override val setAlexaControll100brightness: Boolean
        get() = funInfo()?.setAlexaControll100brightness ?: false

    override val alexaGetSupportGetAlexaDefaultLanguage: Boolean
        get() = funInfo()?.alexaGetSupportGetAlexaDefaultLanguage ?: false

    override val alexaGetUIControllSports: Boolean
        get() = funInfo()?.alexaGetUIControllSports ?: false

    override val getLeftRightHandWearSettings: Boolean
        get() = funInfo()?.getLeftRightHandWearSettings ?: false

    override val supportSettingsDuringExercise: Boolean
        get() = funInfo()?.supportSettingsDuringExercise ?: false

    override val supportHeightLengthUnit: Boolean
        get() = funInfo()?.supportHeightLengthUnit ?: false

    override val supportSportingRemindSetting: Boolean
        get() = funInfo()?.supportSportingRemindSetting ?: false

    override val supportSportGetAutoPauseEnd: Boolean
        get() = funInfo()?.supportSportGetAutoPauseEnd ?: false

    override val supportSetStrideLengthUnit: Boolean
        get() = funInfo()?.supportSetStrideLengthUnit ?: false

    override val supportSimpleHrZoneSetting: Boolean
        get() = funInfo()?.supportSimpleHrZoneSetting ?: false

    override val notSupportSmartLowHeartReatRemind: Boolean
        get() = funInfo()?.notSupportSmartLowHeartReatRemind ?: false

    override val notSupportSmartHighHeartReatRemind: Boolean
        get() = funInfo()?.notSupportSmartHighHeartReatRemind ?: false

    override val notSupportPhotoPreviewControl: Boolean
        get() = funInfo()?.notSupportPhotoPreviewControl ?: false

    override val supportGetUserInfo: Boolean
        get() = funInfo()?.supportGetUserInfo ?: false

    override val supportMissedCallMsgTypeUseFixed: Boolean
        get() = funInfo()?.supportMissedCallMsgTypeUseFixed ?: false

    override val supportAppNotDisplayAlarmName: Boolean
        get() = funInfo()?.supportAppNotDisplayAlarmName ?: false

    override val supportSetSleepRemind: Boolean
        get() = funInfo()?.supportSetSleepRemind ?: false

    override val supportBloodGlucose: Boolean
        get() = funInfo()?.supportBloodGlucose ?: false

    override val supportBloodGlucoseV01: Boolean
        get() = funInfo()?.supportBloodGlucoseV01 ?: false

    override val supportBikeLockManager: Boolean
        get() = funInfo()?.supportBikeLockManager ?: false

    override val supportAlgorithmRawDataCollect: Boolean
        get() = funInfo()?.supportAlgorithmRawDataCollect ?: false

    override val supportOfflineMapInformation: Boolean
        get() = funInfo()?.supportOfflineMapInformation ?: false

    override val supportHeartRateReserveZones: Boolean
        get() = funInfo()?.supportHeartRateReserveZones ?: false

    override val supportHeartRateZonesHrMaxSet: Boolean
        get() = funInfo()?.supportHeartRateZonesHrMaxSet ?: false

    override val supportSyncMultiActivityNew: Boolean
        get() = funInfo()?.supportSyncMultiActivityNew ?: false

    override val supportContactFileUseFirmwareReturnSize: Boolean
        get() = funInfo()?.supportContactFileUseFirmwareReturnSize ?: false

    override val supportDisplayCameraEntry: Boolean
        get() = funInfo()?.supportDisplayCameraEntry ?: false

    override val supportOperateFamilyCareReminder3376: Boolean
        get() = funInfo()?.supportOperateFamilyCareReminder3376 ?: false

    override val supportProtocolV3MenstruationConfig3377: Boolean
        get() = funInfo()?.supportProtocolV3MenstruationConfig3377 ?: false

    override val supportOperateHabitFormation: Boolean
        get() = funInfo()?.supportOperateHabitFormation ?: false

    override val supportOperateHabitFormationV01: Boolean
        get() = funInfo()?.supportOperateHabitFormationV01 ?: false

    override val supportOperateFamilySteps: Boolean
        get() = funInfo()?.supportOperateFamilySteps ?: false

    override val supportOperateSetGame: Boolean
        get() = funInfo()?.supportOperateSetGame ?: false

    override val supportOperateGestureControl: Boolean
        get() = funInfo()?.supportOperateGestureControl ?: false

}
