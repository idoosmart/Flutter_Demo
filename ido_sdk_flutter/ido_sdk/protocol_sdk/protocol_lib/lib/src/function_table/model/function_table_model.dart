import 'package:json_annotation/json_annotation.dart';

part 'function_table_model.g.dart';

@JsonSerializable()
class FunctionTableModel {
  @JsonKey(name: 'Airoha_gps_chip')
  final bool? airohaGpsChip;
  final bool? BindAuth;
  final bool? BindCodeAuth;
  final bool? BloodPressure;
  final bool? FiveHRInterval;
  final bool? Gmail;
  final bool? HIDPhoto;
  final bool? HIIT;
  final bool? KakaoTalk;
  final bool? Line;
  final bool? Outlook;
  final bool? Snapchat;
  final bool? Telegram;
  @JsonKey(name: 'V2_support_get_heart_rate_mode')
  final bool? v2SupportGetHeartRateMode;
  @JsonKey(name: 'V2_support_get_switch_status_append')
  final bool? v2SupportGetSwitchStatusAppend;
  @JsonKey(name: 'V2_support_set_get_time_goal_type')
  final bool? v2SupportSetGetTimeGoalType;
  @JsonKey(name: 'V3_Veryfit_not_support_photo_wallpaper')
  final bool? v3VeryfitNotSupportPhotoWallpaper;
  @JsonKey(name: 'V3_alexa_reminder_add_sec')
  final bool? v3AlexaReminderAddSec;
  @JsonKey(name: 'V3_alexa_set_easy_operate')
  final bool? v3AlexaSetEasyOperate;
  @JsonKey(name: 'V3_alexa_set_get_alexa_alarm')
  final bool? v3AlexaSetGetAlexaAlarm;
  @JsonKey(name: 'V3_alexa_set_jump_sport_ui')
  final bool? v3AlexaSetJumpSportUi;
  @JsonKey(name: 'V3_alexa_set_jump_ui')
  final bool? v3AlexaSetJumpUi;
  @JsonKey(name: 'V3_alexa_set_set_on_off_type')
  final bool? v3AlexaSetSetOnOffType;
  @JsonKey(name: 'V3_alexa_set_weather')
  final bool? v3AlexaSetWeather;
  @JsonKey(name: 'V3_alexa_time_new')
  final bool? v3AlexaTimeNew;
  @JsonKey(name: 'V3_auto_activity_switch')
  final bool? v3AutoActivitySwitch;
  @JsonKey(name: 'V3_automatic_sync_v3_health_data')
  final bool? v3AutomaticSyncV3HealthData;
  @JsonKey(name: 'V3_dev_support_pair_each_connect')
  final bool? v3DevSupportPairEachConnect;
  @JsonKey(name: 'V3_drink_water_add_notify_flag')
  final bool? v3DrinkWaterAddNotifyFlag;
  @JsonKey(name: 'V3_get_battery_log')
  final bool? v3GetBatteryLog;
  @JsonKey(name: 'V3_get_calorie_distance_goal')
  final bool? v3GetCalorieDistanceGoal;
  @JsonKey(name: 'V3_get_dev_log_state')
  final bool? v3GetDevLogState;
  @JsonKey(name: 'V3_get_menu_list')
  final bool? v3GetMenuList;
  @JsonKey(name: 'V3_get_walk_reminder')
  final bool? v3GetWalkReminder;
  @JsonKey(name: 'V3_get_watch_list_new')
  final bool? v3GetWatchListNew;
  @JsonKey(name: 'V3_health_sync_noise')
  final bool? v3HealthSyncNoise;
  @JsonKey(name: 'V3_health_sync_temperature')
  final bool? v3HealthSyncTemperature;
  @JsonKey(name: 'V3_menstrual_add_notify_flag')
  final bool? v3MenstrualAddNotifyFlag;
  @JsonKey(name: 'V3_music_control_02_add_singer_name')
  final bool? v3MusicControl02AddSingerName;
  @JsonKey(name: 'V3_pressure_add_notify_flag_and_mode')
  final bool? v3PressureAddNotifyFlagAndMode;
  @JsonKey(name: 'V3_schedule_reminder')
  final bool? v3ScheduleReminder;
  @JsonKey(name: 'V3_set_100_sport_sort')
  final bool? v3Set100SportSort;
  @JsonKey(name: 'V3_set_20_base_sport_param_sort')
  final bool? v3Set20BaseSportParamSort;
  @JsonKey(name: 'V3_set_main_ui_sort')
  final bool? v3SetMainUiSort;
  @JsonKey(name: 'V3_set_mid_high_time_goal')
  final bool? v3SetMidHighTimeGoal;
  @JsonKey(name: 'V3_set_sharking_grade')
  final bool? v3SetSharkingGrade;
  @JsonKey(name: 'V3_set_walk_reminder_goal_time')
  final bool? v3SetWalkReminderGoalTime;
  @JsonKey(name: 'V3_set_wallpaper_dial')
  final bool? v3SetWallpaperDial;
  @JsonKey(name: 'V3_set_watch_dial_sort')
  final bool? v3SetWatchDialSort;
  @JsonKey(name: 'V3_spo2_add_notify_flag')
  final bool? v3Spo2AddNotifyFlag;
  @JsonKey(name: 'V3_support_189email')
  final bool? v3Support189email;
  @JsonKey(name: 'V3_support_99taxi')
  final bool? v3Support99taxi;
  @JsonKey(name: 'V3_support_Aliexpress')
  final bool? v3SupportAliexpress;
  @JsonKey(name: 'V3_support_Americanas')
  final bool? v3SupportAmericanas;
  @JsonKey(name: 'V3_support_Enjoei')
  final bool? v3SupportEnjoei;
  @JsonKey(name: 'V3_support_Exchangeemail')
  final bool? v3SupportExchangeemail;
  @JsonKey(name: 'V3_support_Google_meet')
  final bool? v3SupportGoogleMeet;
  @JsonKey(name: 'V3_support_Instantemail')
  final bool? v3SupportInstantemail;
  @JsonKey(name: 'V3_support_Magalu')
  final bool? v3SupportMagalu;
  @JsonKey(name: 'V3_support_Mercado_livre')
  final bool? v3SupportMercadoLivre;
  @JsonKey(name: 'V3_support_Mormaii_Smartwatch')
  final bool? v3SupportMormaiiSmartwatch;
  @JsonKey(name: 'V3_support_Motoemail')
  final bool? v3SupportMotoemail;
  @JsonKey(name: 'V3_support_Ola')
  final bool? v3SupportOla;
  @JsonKey(name: 'V3_support_Rappi')
  final bool? v3SupportRappi;
  @JsonKey(name: 'V3_support_Shopee')
  final bool? v3SupportShopee;
  @JsonKey(name: 'V3_support_Teams')
  final bool? v3SupportTeams;
  @JsonKey(name: 'V3_support_Technos_Connect')
  final bool? v3SupportTechnosConnect;
  @JsonKey(name: 'V3_support_Uber')
  final bool? v3SupportUber;
  @JsonKey(name: 'V3_support_Uber_Eats')
  final bool? v3SupportUberEats;
  @JsonKey(name: 'V3_support_WhatsApp_Business')
  final bool? v3SupportWhatsappBusiness;
  @JsonKey(name: 'V3_support_YTmusic')
  final bool? v3SupportYtmusic;
  @JsonKey(name: 'V3_support_Yahoo')
  final bool? v3SupportYahoo;
  @JsonKey(name: 'V3_support_alibaba_email')
  final bool? v3SupportAlibabaEmail;
  @JsonKey(name: 'V3_support_app_send_voice_to_ble')
  final bool? v3SupportAppSendVoiceToBle;
  @JsonKey(name: 'V3_support_asuseemail')
  final bool? v3SupportAsuseemail;
  @JsonKey(name: 'V3_support_blueemail')
  final bool? v3SupportBlueemail;
  @JsonKey(name: 'V3_support_bp_calibration')
  final bool? v3SupportBpCalibration;
  @JsonKey(name: 'V3_support_calendario')
  final bool? v3SupportCalendario;
  @JsonKey(name: 'V3_support_calorie_unit')
  final bool? v3SupportCalorieUnit;
  @JsonKey(name: 'V3_support_cycling_unit')
  final bool? v3SupportCyclingUnit;
  @JsonKey(name: 'V3_support_data_tran_continue')
  final bool? v3SupportDataTranContinue;
  @JsonKey(name: 'V3_support_dokidokemail')
  final bool? v3SupportDokidokemail;
  @JsonKey(name: 'V3_support_general')
  final bool? v3SupportGeneral;
  @JsonKey(name: 'V3_support_get_activity_switch')
  final bool? v3SupportGetActivitySwitch;
  @JsonKey(name: 'V3_support_get_alexa_default_language')
  final bool? v3SupportGetAlexaDefaultLanguage;
  @JsonKey(name: 'V3_support_get_health_switch_state')
  final bool? v3SupportGetHealthSwitchState;
  @JsonKey(name: 'V3_support_get_main_sport_goal')
  final bool? v3SupportGetMainSportGoal;
  @JsonKey(name: 'V3_support_googleGmail')
  final bool? v3SupportGooglegmail;
  @JsonKey(name: 'V3_support_hrv')
  final bool? v3SupportHrv;
  @JsonKey(name: 'V3_support_htcemail')
  final bool? v3SupportHtcemail;
  @JsonKey(name: 'V3_support_inboxemail')
  final bool? v3SupportInboxemail;
  @JsonKey(name: 'V3_support_lfood')
  final bool? v3SupportLfood;
  @JsonKey(name: 'V3_support_mailruemail')
  final bool? v3SupportMailruemail;
  @JsonKey(name: 'V3_support_matters_remind')
  final bool? v3SupportMattersRemind;
  @JsonKey(name: 'V3_support_microsoft')
  final bool? v3SupportMicrosoft;
  @JsonKey(name: 'V3_support_missed_calls')
  final bool? v3SupportMissedCalls;
  @JsonKey(name: 'V3_support_mobiemail')
  final bool? v3SupportMobiemail;
  @JsonKey(name: 'V3_support_myemail')
  final bool? v3SupportMyemail;
  @JsonKey(name: 'V3_support_neteasemail')
  final bool? v3SupportNeteasemail;
  @JsonKey(name: 'V3_support_nhnemail')
  final bool? v3SupportNhnemail;
  @JsonKey(name: 'V3_support_niosefit')
  final bool? v3SupportNiosefit;
  @JsonKey(name: 'V3_support_outlookemail')
  final bool? v3SupportOutlookemail;
  @JsonKey(name: 'V3_support_qqemail')
  final bool? v3SupportQqemail;
  @JsonKey(name: 'V3_support_scientific_sleep')
  final bool? v3SupportScientificSleep;
  @JsonKey(name: 'V3_support_set_scientific_sleep_switch')
  final bool? v3SupportSetScientificSleepSwitch;
  @JsonKey(name: 'V3_support_set_smart_heart_rate')
  final bool? v3SupportSetSmartHeartRate;
  @JsonKey(name: 'V3_support_set_spo2_all_day_on_off')
  final bool? v3SupportSetSpo2AllDayOnOff;
  @JsonKey(name: 'V3_support_set_spo2_low_value_remind')
  final bool? v3SupportSetSpo2LowValueRemind;
  @JsonKey(name: 'V3_support_set_temperature_switch')
  final bool? v3SupportSetTemperatureSwitch;
  @JsonKey(name: 'V3_support_set_v3_music_name')
  final bool? v3SupportSetV3MusicName;
  @JsonKey(name: 'V3_support_set_v3_notify_add_app_name')
  final bool? v3SupportSetV3NotifyAddAppName;
  @JsonKey(name: 'V3_support_set_v3_weather')
  final bool? v3SupportSetV3Weather;
  @JsonKey(name: 'V3_support_set_v3_world_time')
  final bool? v3SupportSetV3WorldTime;
  @JsonKey(name: 'V3_support_set_weather_sun_time')
  final bool? v3SupportSetWeatherSunTime;
  @JsonKey(name: 'V3_support_show_detection_time')
  final bool? v3SupportShowDetectionTime;
  @JsonKey(name: 'V3_support_swim_pool_unit')
  final bool? v3SupportSwimPoolUnit;
  @JsonKey(name: 'V3_support_swimming_data_exhibit')
  final bool? v3SupportSwimmingDataExhibit;
  @JsonKey(name: 'V3_support_sync_contact')
  final bool? v3SupportSyncContact;
  @JsonKey(name: 'V3_support_sync_over_high_low_heart_data')
  final bool? v3SupportSyncOverHighLowHeartData;
  @JsonKey(name: 'V3_support_trtfbluemail')
  final bool? v3SupportTrtfbluemail;
  @JsonKey(name: 'V3_support_v3_ble_music')
  final bool? v3SupportV3BleMusic;
  @JsonKey(name: 'V3_support_v3_exchange_data_reply_add_real_time_speed_pace')
  final bool? v3SupportV3ExchangeDataReplyAddRealTimeSpeedPace;
  @JsonKey(name: 'V3_support_v3_get_sport_sort_field')
  final bool? v3SupportV3GetSportSortField;
  @JsonKey(name: 'V3_support_v3_long_city_name')
  final bool? v3SupportV3LongCityName;
  @JsonKey(name: 'V3_support_v3_notify_icon_adaptive')
  final bool? v3SupportV3NotifyIconAdaptive;
  @JsonKey(name: 'V3_support_veryfit')
  final bool? v3SupportVeryfit;
  @JsonKey(name: 'V3_support_walking_running_unit')
  final bool? v3SupportWalkingRunningUnit;
  @JsonKey(name: 'V3_support_watch_capacity_size_display')
  final bool? v3SupportWatchCapacitySizeDisplay;
  @JsonKey(name: 'V3_support_watch_photo_position_move')
  final bool? v3SupportWatchPhotoPositionMove;
  @JsonKey(name: 'V3_support_wear_flag')
  final bool? v3SupportWearFlag;
  @JsonKey(name: 'V3_support_yahooemail')
  final bool? v3SupportYahooemail;
  @JsonKey(name: 'V3_support_zohoemail')
  final bool? v3SupportZohoemail;
  @JsonKey(name: 'V3_sync_v3_activity_add_param')
  final bool? v3SyncV3ActivityAddParam;
  @JsonKey(name: 'V3_v2_02_EB_firmware_bt_version_01_create')
  final bool? v3V202EbFirmwareBtVersion01Create;
  @JsonKey(name: 'V3_v2_menstrual_remind_02_add_pregnancy')
  final bool? v3V2MenstrualRemind02AddPregnancy;
  @JsonKey(name: 'V3_v3_33_3D_historical_menstruation_01_create')
  final bool? v3V3333dHistoricalMenstruation01Create;
  @JsonKey(name: 'V3_walk_reminder_add_notify_flag')
  final bool? v3WalkReminderAddNotifyFlag;
  @JsonKey(name: 'V3_watch_dail_set_add_size')
  final bool? v3WatchDailSetAddSize;
  final bool? VKontakte;
  final bool? Viber;
  final bool? WatchDial;
  @JsonKey(name: 'activity_switch')
  final bool? activitySwitch;
  @JsonKey(name: 'aerobics_bodybuilding_exercise')
  final bool? aerobicsBodybuildingExercise;
  @JsonKey(name: 'agps_offline')
  final bool? agpsOffline;
  @JsonKey(name: 'agps_online')
  final bool? agpsOnline;
  final bool? alarmBath;
  final bool? alarmBrushTeeth;
  final bool? alarmClock;
  final int? alarmCount;
  final bool? alarmCourse;
  final bool? alarmCustom;
  final bool? alarmDating;
  final bool? alarmDinner;
  final bool? alarmLearn;
  final bool? alarmMedicine;
  final bool? alarmMetting;
  final bool? alarmParty;
  final bool? alarmPlayTime;
  final bool? alarmRest;
  final bool? alarmSleep;
  final bool? alarmSport;
  final bool? alarmWakeUp;
  final bool? allAppNotice;
  final bool? ancs;
  final bool? antilost;
  @JsonKey(name: 'auto_activity_end_switch_not_display')
  final bool? autoActivityEndSwitchNotDisplay;
  @JsonKey(name: 'auto_activity_pause_switch_not_display')
  final bool? autoActivityPauseSwitchNotDisplay;
  @JsonKey(name: 'auto_activity_set_get_use_new_struct_exchange')
  final bool? autoActivitySetGetUseNewStructExchange;
  @JsonKey(name: 'auto_activity_switch_add_bicycle')
  final bool? autoActivitySwitchAddBicycle;
  @JsonKey(name: 'auto_activity_switch_add_smart_rope')
  final bool? autoActivitySwitchAddSmartRope;
  @JsonKey(name: 'battling_rope')
  final bool? battlingRope;
  @JsonKey(name: 'beach_tennis')
  final bool? beachTennis;
  final bool? bilateralAntiLost;
  final bool? bleControlMusic;
  final bool? bleControlTakePhoto;
  @JsonKey(name: 'breathe_train')
  final bool? breatheTrain;
  final bool? calendar;
  final bool? calling;
  final bool? callingContact;
  final bool? callingNum;
  @JsonKey(name: 'choose_other_ota_mode')
  final bool? chooseOtherOtaMode;
  final bool? cricket;
  @JsonKey(name: 'data_tran_over_wait_ble')
  final bool? dataTranOverWaitBle;
  final bool? defaultConfig;
  final bool? defaultSportType;
  final bool? deviceUpdate;
  @JsonKey(name: 'device_control_fast_mode_alone')
  final bool? deviceControlFastModeAlone;
  final bool? displayMode;
  @JsonKey(name: 'disturb_have_rang_repeat')
  final bool? disturbHaveRangRepeat;
  final bool? doNotDisturb;
  final bool? downloadLanguage;
  final bool? elliptical;
  final bool? exFuncTable;
  @JsonKey(name: 'ex_activity_time_sync')
  final bool? exActivityTimeSync;
  @JsonKey(name: 'ex_dh_new_app_notice')
  final bool? exDhNewAppNotice;
  @JsonKey(name: 'ex_gps')
  final bool? exGps;
  @JsonKey(name: 'ex_id107_l_dial')
  final bool? exId107LDial;
  @JsonKey(name: 'ex_lang1_danish')
  final bool? exLang1Danish;
  @JsonKey(name: 'ex_lang1_slovak')
  final bool? exLang1Slovak;
  @JsonKey(name: 'ex_lang2_croatian')
  final bool? exLang2Croatian;
  @JsonKey(name: 'ex_lang2_hindi')
  final bool? exLang2Hindi;
  @JsonKey(name: 'ex_lang2_indonesian')
  final bool? exLang2Indonesian;
  @JsonKey(name: 'ex_lang2_korean')
  final bool? exLang2Korean;
  @JsonKey(name: 'ex_lang2_portuguese')
  final bool? exLang2Portuguese;
  @JsonKey(name: 'ex_lang2_turkish')
  final bool? exLang2Turkish;
  @JsonKey(name: 'ex_lang3_arabic')
  final bool? exLang3Arabic;
  @JsonKey(name: 'ex_lang3_burmese')
  final bool? exLang3Burmese;
  @JsonKey(name: 'ex_lang3_filipino')
  final bool? exLang3Filipino;
  @JsonKey(name: 'ex_lang3_greek')
  final bool? exLang3Greek;
  @JsonKey(name: 'ex_lang3_sweden')
  final bool? exLang3Sweden;
  @JsonKey(name: 'ex_lang3_thai')
  final bool? exLang3Thai;
  @JsonKey(name: 'ex_lang3_traditional_chinese')
  final bool? exLang3TraditionalChinese;
  @JsonKey(name: 'ex_lang3_vietnamese')
  final bool? exLang3Vietnamese;
  @JsonKey(name: 'ex_lang_dutch')
  final bool? exLangDutch;
  @JsonKey(name: 'ex_lang_hungarian')
  final bool? exLangHungarian;
  @JsonKey(name: 'ex_lang_lithuanian')
  final bool? exLangLithuanian;
  @JsonKey(name: 'ex_lang_polish')
  final bool? exLangPolish;
  @JsonKey(name: 'ex_lang_romanian')
  final bool? exLangRomanian;
  @JsonKey(name: 'ex_lang_russian')
  final bool? exLangRussian;
  @JsonKey(name: 'ex_lang_slovenian')
  final bool? exLangSlovenian;
  @JsonKey(name: 'ex_lang_ukrainian')
  final bool? exLangUkrainian;
  @JsonKey(name: 'ex_main3_calorie_goal')
  final bool? exMain3CalorieGoal;
  @JsonKey(name: 'ex_main3_distance_goal')
  final bool? exMain3DistanceGoal;
  @JsonKey(name: 'ex_main3_get_do_not_disturb')
  final bool? exMain3GetDoNotDisturb;
  @JsonKey(name: 'ex_main3_menstruation')
  final bool? exMain3Menstruation;
  @JsonKey(name: 'ex_main3_v3_pressure')
  final bool? exMain3V3Pressure;
  @JsonKey(name: 'ex_main3_v3_spo2_data')
  final bool? exMain3V3Spo2Data;
  @JsonKey(name: 'ex_main4_drink_water_reminder')
  final bool? exMain4DrinkWaterReminder;
  @JsonKey(name: 'ex_main4_ios_auto_pair')
  final bool? exMain4IosAutoPair;
  @JsonKey(name: 'ex_main4_ios_no_disconnect_pair')
  final bool? exMain4IosNoDisconnectPair;
  @JsonKey(name: 'ex_main4_v3_activity_data')
  final bool? exMain4V3ActivityData;
  @JsonKey(name: 'ex_main4_v3_gps_data_data')
  final bool? exMain4V3GpsDataData;
  @JsonKey(name: 'ex_main4_v3_hr_data')
  final bool? exMain4V3HrData;
  @JsonKey(name: 'ex_main4_v3_swim')
  final bool? exMain4V3Swim;
  @JsonKey(name: 'ex_main7_charging_time')
  final bool? exMain7ChargingTime;
  @JsonKey(name: 'ex_main7_menu_list')
  final bool? exMain7MenuList;
  @JsonKey(name: 'ex_main7_photo_wallpaper')
  final bool? exMain7PhotoWallpaper;
  @JsonKey(name: 'ex_main7_utc_time_zone')
  final bool? exMain7UtcTimeZone;
  @JsonKey(name: 'ex_noitice_128byte')
  final bool? exNoitice128byte;
  @JsonKey(name: 'ex_notice_250byte')
  final bool? exNotice250byte;
  @JsonKey(name: 'ex_screen_brightness')
  final bool? exScreenBrightness;
  @JsonKey(name: 'ex_sleep_period')
  final bool? exSleepPeriod;
  @JsonKey(name: 'ex_table_main10_clear_ble_cache')
  final bool? exTableMain10ClearBleCache;
  @JsonKey(name: 'ex_table_main10_get_dev_name')
  final bool? exTableMain10GetDevName;
  @JsonKey(name: 'ex_table_main10_get_watch_id')
  final bool? exTableMain10GetWatchId;
  @JsonKey(name: 'ex_table_main10_set_hand_washing_reminder')
  final bool? exTableMain10SetHandWashingReminder;
  @JsonKey(name: 'ex_table_main10_set_phone_voice')
  final bool? exTableMain10SetPhoneVoice;
  @JsonKey(name: 'ex_table_main10_v3_get_lang_library')
  final bool? exTableMain10V3GetLangLibrary;
  @JsonKey(name: 'ex_table_main10_v3_notify_msg')
  final bool? exTableMain10V3NotifyMsg;
  @JsonKey(name: 'ex_table_main10_v3_voice_support_alexa')
  final bool? exTableMain10V3VoiceSupportAlexa;
  @JsonKey(name: 'ex_table_main11_alarm_other_is_no_label')
  final bool? exTableMain11AlarmOtherIsNoLabel;
  @JsonKey(name: 'ex_table_main11_not_support_heart_rate_high_alarm')
  final bool? exTableMain11NotSupportHeartRateHighAlarm;
  @JsonKey(name: 'ex_table_main11_not_support_v3_activity_gps_exchange')
  final bool? exTableMain11NotSupportV3ActivityGpsExchange;
  @JsonKey(name: 'ex_table_main11_pressure_high_threshold_reminder')
  final bool? exTableMain11PressureHighThresholdReminder;
  @JsonKey(name: 'ex_table_main11_support_cloud_dial')
  final bool? exTableMain11SupportCloudDial;
  @JsonKey(name: 'ex_table_main11_taking_medicine')
  final bool? exTableMain11TakingMedicine;
  @JsonKey(name: 'ex_table_main11_use_aes_encode')
  final bool? exTableMain11UseAesEncode;
  @JsonKey(name: 'ex_table_main7_choice_use')
  final bool? exTableMain7ChoiceUse;
  @JsonKey(name: 'ex_table_main7_heart_rate_interval')
  final bool? exTableMain7HeartRateInterval;
  @JsonKey(name: 'ex_table_main7_v3_sports_type')
  final bool? exTableMain7V3SportsType;
  @JsonKey(name: 'ex_table_main7_voice_transmission')
  final bool? exTableMain7VoiceTransmission;
  @JsonKey(name: 'ex_table_main8_encrypted_auth')
  final bool? exTableMain8EncryptedAuth;
  @JsonKey(name: 'ex_table_main8_screen_brightness_3_level')
  final bool? exTableMain8ScreenBrightness3Level;
  @JsonKey(name: 'ex_table_main8_ublox_model')
  final bool? exTableMain8UbloxModel;
  @JsonKey(name: 'ex_table_main8_v3_get_heat_log')
  final bool? exTableMain8V3GetHeatLog;
  @JsonKey(name: 'ex_table_main8_v3_sleep')
  final bool? exTableMain8V3Sleep;
  @JsonKey(name: 'ex_table_main8_v3_spo2_off_change')
  final bool? exTableMain8V3Spo2OffChange;
  @JsonKey(name: 'ex_table_main8_v3_sync_activity')
  final bool? exTableMain8V3SyncActivity;
  @JsonKey(name: 'ex_table_main8_v3_sync_alarm')
  final bool? exTableMain8V3SyncAlarm;
  @JsonKey(name: 'ex_table_main9_fast_msg_data')
  final bool? exTableMain9FastMsgData;
  @JsonKey(name: 'ex_table_main9_get_device_update_state')
  final bool? exTableMain9GetDeviceUpdateState;
  @JsonKey(name: 'ex_table_main9_get_screen_brightness')
  final bool? exTableMain9GetScreenBrightness;
  @JsonKey(name: 'ex_table_main9_get_up_hand_gesture')
  final bool? exTableMain9GetUpHandGesture;
  @JsonKey(name: 'ex_table_main9_is_watch')
  final bool? exTableMain9IsWatch;
  @JsonKey(name: 'ex_table_main9_restore_factory')
  final bool? exTableMain9RestoreFactory;
  @JsonKey(name: 'ex_table_main9_v3_activity_exchange_data')
  final bool? exTableMain9V3ActivityExchangeData;
  @JsonKey(name: 'ex_table_main9_v3_sports')
  final bool? exTableMain9V3Sports;
  @JsonKey(name: 'ex_v3_log')
  final bool? exV3Log;
  @JsonKey(name: 'factory_reset')
  final bool? factoryReset;
  final bool? fastSync;
  final bool? findDevice;
  final bool? findPhone;
  final bool? fineTImeControl;
  final bool? flashLog;
  final bool? flipScreen;
  final bool? footvolley;
  @JsonKey(name: 'health_sync_v3_activity_end_time_use_utc_mode')
  final bool? healthSyncV3ActivityEndTimeUseUtcMode;
  final bool? heartRate;
  final bool? heartRateMonitor;
  @JsonKey(name: 'heart_rate_off_by_default')
  final bool? heartRateOffByDefault;
  final bool? hidPhoto;
  @JsonKey(name: 'high_bar')
  final bool? highBar;
  @JsonKey(name: 'indoor_cycle')
  final bool? indoorCycle;
  @JsonKey(name: 'indoor_run')
  final bool? indoorRun;
  @JsonKey(name: 'indoor_walk')
  final bool? indoorWalk;
  final bool? instagram;
  @JsonKey(name: 'is_need_sync_v2')
  final bool? isNeedSyncV2;
  @JsonKey(name: 'lang_bengali')
  final bool? langBengali;
  @JsonKey(name: 'lang_brazilian_portuguese')
  final bool? langBrazilianPortuguese;
  @JsonKey(name: 'lang_ch')
  final bool? langCh;
  @JsonKey(name: 'lang_czech')
  final bool? langCzech;
  @JsonKey(name: 'lang_eng')
  final bool? langEng;
  @JsonKey(name: 'lang_finland')
  final bool? langFinland;
  @JsonKey(name: 'lang_french')
  final bool? langFrench;
  @JsonKey(name: 'lang_german')
  final bool? langGerman;
  @JsonKey(name: 'lang_hebrew')
  final bool? langHebrew;
  @JsonKey(name: 'lang_italian')
  final bool? langItalian;
  @JsonKey(name: 'lang_japanese')
  final bool? langJapanese;
  @JsonKey(name: 'lang_khmer')
  final bool? langKhmer;
  @JsonKey(name: 'lang_malay')
  final bool? langMalay;
  @JsonKey(name: 'lang_norwegian')
  final bool? langNorwegian;
  @JsonKey(name: 'lang_persia')
  final bool? langPersia;
  @JsonKey(name: 'lang_serbian')
  final bool? langSerbian;
  @JsonKey(name: 'lang_spanish')
  final bool? langSpanish;
  @JsonKey(name: 'level5_hr_interval')
  final bool? level5HrInterval;
  final bool? liftingWristBacklight;
  @JsonKey(name: 'linked_in')
  final bool? linkedIn;
  final bool? logIn;
  @JsonKey(name: 'long_mtu')
  final bool? longMtu;
  final bool? mediumToHighActiveDuration;
  final bool? messengre;
  @JsonKey(name: 'mountain_biking')
  final bool? mountainBiking;
  final bool? mountaineering;
  final bool? multiActivityNoUseApp;
  final bool? multiDial;
  @JsonKey(name: 'night_auto_brightness')
  final bool? nightAutoBrightness;
  final bool? noShowHRInterval;
  @JsonKey(name: 'noise_support_set_notify_flag')
  final bool? noiseSupportSetNotifyFlag;
  @JsonKey(name: 'noise_support_set_overwarning')
  final bool? noiseSupportSetOverwarning;
  @JsonKey(name: 'not_support_app_send_run_plan')
  final bool? notSupportAppSendRunPlan;
  @JsonKey(name: 'not_support_delete_add_sport_sort')
  final bool? notSupportDeleteAddSportSort;
  @JsonKey(name: 'not_support_indoor_run_get_vo2max')
  final bool? notSupportIndoorRunGetVo2max;
  @JsonKey(name: 'not_support_set_ovulation')
  final bool? notSupportSetOvulation;
  final bool? noticeEmail;
  final bool? noticeFacebook;
  final bool? noticeMessage;
  final bool? noticeQQ;
  final bool? noticeSinaWeibo;
  final bool? noticeTwitter;
  final bool? noticeWeixin;
  @JsonKey(name: 'notice_Amazon')
  final bool? noticeAmazon;
  @JsonKey(name: 'notice_Dailyhunt')
  final bool? noticeDailyhunt;
  @JsonKey(name: 'notice_Flipkart')
  final bool? noticeFlipkart;
  @JsonKey(name: 'notice_Gpay')
  final bool? noticeGpay;
  @JsonKey(name: 'notice_Hotstar')
  final bool? noticeHotstar;
  @JsonKey(name: 'notice_Inshorts')
  final bool? noticeInshorts;
  @JsonKey(name: 'notice_Jio_Tv')
  final bool? noticeJioTv;
  @JsonKey(name: 'notice_Make_My_Trip')
  final bool? noticeMakeMyTrip;
  @JsonKey(name: 'notice_Netflix')
  final bool? noticeNetflix;
  @JsonKey(name: 'notice_Paytm')
  final bool? noticePaytm;
  @JsonKey(name: 'notice_Phonpe')
  final bool? noticePhonpe;
  @JsonKey(name: 'notice_Prime')
  final bool? noticePrime;
  @JsonKey(name: 'notice_Redbus')
  final bool? noticeRedbus;
  @JsonKey(name: 'notice_Swiggy')
  final bool? noticeSwiggy;
  @JsonKey(name: 'notice_TikTok')
  final bool? noticeTiktok;
  @JsonKey(name: 'notice_Zomato')
  final bool? noticeZomato;
  @JsonKey(name: 'notice_chatwork')
  final bool? noticeChatwork;
  @JsonKey(name: 'notice_keep')
  final bool? noticeKeep;
  @JsonKey(name: 'notice_pinterest_yahoo')
  final bool? noticePinterestYahoo;
  @JsonKey(name: 'notice_slack')
  final bool? noticeSlack;
  @JsonKey(name: 'notice_stepper')
  final bool? noticeStepper;
  @JsonKey(name: 'notice_tumblr')
  final bool? noticeTumblr;
  @JsonKey(name: 'notice_yahoo_mail')
  final bool? noticeYahooMail;
  @JsonKey(name: 'notice_youtube')
  final bool? noticeYoutube;
  final bool? onetouchCalling;
  @JsonKey(name: 'open_water_swim')
  final bool? openWaterSwim;
  final bool? orienteering;
  final bool? other;
  @JsonKey(name: 'other_activity')
  final bool? otherActivity;
  @JsonKey(name: 'outdoor_cycle')
  final bool? outdoorCycle;
  @JsonKey(name: 'outdoor_fun')
  final bool? outdoorFun;
  @JsonKey(name: 'outdoor_run')
  final bool? outdoorRun;
  @JsonKey(name: 'outdoor_walk')
  final bool? outdoorWalk;
  final bool? parachuting;
  @JsonKey(name: 'parallel_bars')
  final bool? parallelBars;
  final bool? pickleball;
  final bool? pilates;
  @JsonKey(name: 'pool_swim')
  final bool? poolSwim;
  @JsonKey(name: 'protocol_v3_sport_record_show_config')
  final bool? protocolV3SportRecordShowConfig;
  @JsonKey(name: 'pull_up')
  final bool? pullUp;
  final bool? realtimeData;
  final bool? rower;
  @JsonKey(name: 'schedule_reminder_not_display_title')
  final bool? scheduleReminderNotDisplayTitle;
  @JsonKey(name: 'scientific_sleep_switch_off_by_default')
  final bool? scientificSleepSwitchOffByDefault;
  @JsonKey(name: 'screen_brightness_5_level')
  final bool? screenBrightness5Level;
  final bool? sedentariness;
  final bool? shortcut;
  final bool? singleSport;
  final bool? skype;
  final bool? sleepMonitor;
  @JsonKey(name: 'smart_rope')
  final bool? smartRope;
  @JsonKey(name: 'sport_mode_sort')
  final bool? sportModeSort;
  @JsonKey(name: 'sport_show_num')
  final int? sportShowNum;
  @JsonKey(name: 'sport_type0_badminton')
  final bool? sportType0Badminton;
  @JsonKey(name: 'sport_type0_by_bike')
  final bool? sportType0ByBike;
  @JsonKey(name: 'sport_type0_mountain_climbing')
  final bool? sportType0MountainClimbing;
  @JsonKey(name: 'sport_type0_on_foot')
  final bool? sportType0OnFoot;
  @JsonKey(name: 'sport_type0_other')
  final bool? sportType0Other;
  @JsonKey(name: 'sport_type0_run')
  final bool? sportType0Run;
  @JsonKey(name: 'sport_type0_swim')
  final bool? sportType0Swim;
  @JsonKey(name: 'sport_type0_walk')
  final bool? sportType0Walk;
  @JsonKey(name: 'sport_type1_dumbbell')
  final bool? sportType1Dumbbell;
  @JsonKey(name: 'sport_type1_ellipsoid')
  final bool? sportType1Ellipsoid;
  @JsonKey(name: 'sport_type1_fitness')
  final bool? sportType1Fitness;
  @JsonKey(name: 'sport_type1_push_up')
  final bool? sportType1PushUp;
  @JsonKey(name: 'sport_type1_sit_up')
  final bool? sportType1SitUp;
  @JsonKey(name: 'sport_type1_spinning')
  final bool? sportType1Spinning;
  @JsonKey(name: 'sport_type1_treadmill')
  final bool? sportType1Treadmill;
  @JsonKey(name: 'sport_type1_weightlifting')
  final bool? sportType1Weightlifting;
  @JsonKey(name: 'sport_type2_basketball')
  final bool? sportType2Basketball;
  @JsonKey(name: 'sport_type2_bodybuilding_exercise')
  final bool? sportType2BodybuildingExercise;
  @JsonKey(name: 'sport_type2_footballl')
  final bool? sportType2Footballl;
  @JsonKey(name: 'sport_type2_rope_skipping')
  final bool? sportType2RopeSkipping;
  @JsonKey(name: 'sport_type2_table_tennis')
  final bool? sportType2TableTennis;
  @JsonKey(name: 'sport_type2_tennis')
  final bool? sportType2Tennis;
  @JsonKey(name: 'sport_type2_volleyball')
  final bool? sportType2Volleyball;
  @JsonKey(name: 'sport_type2_yoga')
  final bool? sportType2Yoga;
  @JsonKey(name: 'sport_type3_baseball')
  final bool? sportType3Baseball;
  @JsonKey(name: 'sport_type3_core_training')
  final bool? sportType3CoreTraining;
  @JsonKey(name: 'sport_type3_dance')
  final bool? sportType3Dance;
  @JsonKey(name: 'sport_type3_golf')
  final bool? sportType3Golf;
  @JsonKey(name: 'sport_type3_roller_skating')
  final bool? sportType3RollerSkating;
  @JsonKey(name: 'sport_type3_skiing')
  final bool? sportType3Skiing;
  @JsonKey(name: 'sport_type3_strength_training')
  final bool? sportType3StrengthTraining;
  @JsonKey(name: 'sport_type3_tidy_up_relax')
  final bool? sportType3TidyUpRelax;
  @JsonKey(name: 'sport_type_traditional_strength_training')
  final bool? sportTypeTraditionalStrengthTraining;
  final bool? squat;
  @JsonKey(name: 'standing_water_skiing')
  final bool? standingWaterSkiing;
  final bool? staticHR;
  final bool? stepCalculation;
  @JsonKey(name: 'support_achieved_remind_on_off')
  final bool? supportAchievedRemindOnOff;
  @JsonKey(name: 'support_activity_exchange_set_gps_coordinates')
  final bool? supportActivityExchangeSetGpsCoordinates;
  @JsonKey(name: 'support_alipay')
  final bool? supportAlipay;
  @JsonKey(name: 'support_app_send_phone_system_info')
  final bool? supportAppSendPhoneSystemInfo;
  @JsonKey(name: 'support_baidu')
  final bool? supportBaidu;
  @JsonKey(name: 'support_barometric_altimeter')
  final bool? supportBarometricAltimeter;
  @JsonKey(name: 'support_ble_control_photograph')
  final bool? supportBleControlPhotograph;
  @JsonKey(name: 'support_ble_to_app_dail_change')
  final bool? supportBleToAppDailChange;
  @JsonKey(name: 'support_blood_pressure_model_file_update')
  final bool? supportBloodPressureModelFileUpdate;
  @JsonKey(name: 'support_calendar_reminder')
  final bool? supportCalendarReminder;
  @JsonKey(name: 'support_call_list')
  final bool? supportCallList;
  @JsonKey(name: 'support_calling_quick_reply')
  final bool? supportCallingQuickReply;
  @JsonKey(name: 'support_compass')
  final bool? supportCompass;
  @JsonKey(name: 'support_config_default_meg_application_list')
  final bool? supportConfigDefaultMegApplicationList;
  @JsonKey(name: 'support_control_mini_program')
  final bool? supportControlMiniProgram;
  @JsonKey(name: 'support_dial_frame_encode_format_argb6666')
  final bool? supportDialFrameEncodeFormatArgb6666;
  @JsonKey(name: 'support_dingtalk')
  final bool? supportDingtalk;
  @JsonKey(name: 'support_display_nap_sleep')
  final bool? supportDisplayNapSleep;
  @JsonKey(name: 'support_douyin')
  final bool? supportDouyin;
  @JsonKey(name: 'support_drink_plan')
  final bool? supportDrinkPlan;
  @JsonKey(name: 'support_e_card_operate')
  final bool? supportECardOperate;
  @JsonKey(name: 'support_eleme')
  final bool? supportEleme;
  @JsonKey(name: 'support_encrypted_code_resend_04_05')
  final bool? supportEncryptedCodeResend0405;
  @JsonKey(name: 'support_exchange_activity_get_altitude_rise_loss')
  final bool? supportExchangeActivityGetAltitudeRiseLoss;
  @JsonKey(name: 'support_exchange_activity_get_gps_status')
  final bool? supportExchangeActivityGetGpsStatus;
  @JsonKey(name: 'support_fahrenheit')
  final bool? supportFahrenheit;
  @JsonKey(name: 'support_fastrack_reflex_world')
  final bool? supportFastrackReflexWorld;
  @JsonKey(name: 'support_get_flash_log_size')
  final bool? supportGetFlashLogSize;
  @JsonKey(name: 'support_get_peripherals_info')
  final bool? supportGetPeripheralsInfo;
  @JsonKey(name: 'support_get_pressure_switch_info')
  final bool? supportGetPressureSwitchInfo;
  @JsonKey(name: 'support_get_protocol_v3_operate_alg_file')
  final bool? supportGetProtocolV3OperateAlgFile;
  @JsonKey(name: 'support_get_set_max_items_num')
  final bool? supportGetSetMaxItemsNum;
  @JsonKey(name: 'support_get_smart_heart_rate')
  final bool? supportGetSmartHeartRate;
  @JsonKey(name: 'support_get_sn_info')
  final bool? supportGetSnInfo;
  @JsonKey(name: 'support_get_spo2_switch_info')
  final bool? supportGetSpo2SwitchInfo;
  @JsonKey(name: 'support_get_unit')
  final bool? supportGetUnit;
  @JsonKey(name: 'support_get_v3_device_algorithm_version')
  final bool? supportGetV3DeviceAlgorithmVersion;
  @JsonKey(name: 'support_get_v3_device_bt_connect_phone_model')
  final bool? supportGetV3DeviceBtConnectPhoneModel;
  @JsonKey(name: 'support_get_walk_reminder')
  final bool? supportGetWalkReminder;
  @JsonKey(name: 'support_hama_fit_move')
  final bool? supportHamaFitMove;
  @JsonKey(name: 'support_jd')
  final bool? supportJd;
  @JsonKey(name: 'support_loops_fit')
  final bool? supportLoopsFit;
  @JsonKey(name: 'support_loudspeaker')
  final bool? supportLoudspeaker;
  @JsonKey(name: 'support_lvgl_dial_frame')
  final bool? supportLvglDialFrame;
  @JsonKey(name: 'support_make_watch_dial_deocde_jpg')
  final bool? supportMakeWatchDialDeocdeJpg;
  @JsonKey(name: 'support_meituan')
  final bool? supportMeituan;
  @JsonKey(name: 'support_morning_edition')
  final bool? supportMorningEdition;
  @JsonKey(name: 'support_onekey_double_contact')
  final bool? supportOnekeyDoubleContact;
  @JsonKey(name: 'support_over_find_phone')
  final bool? supportOverFindPhone;
  @JsonKey(name: 'support_per_minute_one')
  final bool? supportPerMinuteOne;
  @JsonKey(name: 'support_pinduoduo')
  final bool? supportPinduoduo;
  @JsonKey(name: 'support_recover_time_and_vo2max')
  final bool? supportRecoverTimeAndVo2max;
  @JsonKey(name: 'support_ryze_connect')
  final bool? supportRyzeConnect;
  @JsonKey(name: 'support_second_sport_icon')
  final bool? supportSecondSportIcon;
  @JsonKey(name: 'support_sedentary_tensile_habit_info')
  final bool? supportSedentaryTensileHabitInfo;
  @JsonKey(name: 'support_send_bind_device_table')
  final bool? supportSendBindDeviceTable;
  @JsonKey(name: 'support_send_encrypted_data_with_bind')
  final bool? supportSendEncryptedDataWithBind;
  @JsonKey(name: 'support_send_gps_longitude_and_latitude')
  final bool? supportSendGpsLongitudeAndLatitude;
  @JsonKey(name: 'support_send_original_size')
  final bool? supportSendOriginalSize;
  @JsonKey(name: 'support_send_scales_model_map_table')
  final bool? supportSendScalesModelMapTable;
  @JsonKey(name: 'support_set_call_quick_reply_on_off')
  final bool? supportSetCallQuickReplyOnOff;
  @JsonKey(name: 'support_set_ecg_reminder')
  final bool? supportSetEcgReminder;
  @JsonKey(name: 'support_set_eci_reminder')
  final bool? supportSetEciReminder;
  @JsonKey(name: 'support_set_fast_mode_when_sync_config')
  final bool? supportSetFastModeWhenSyncConfig;
  @JsonKey(name: 'support_set_fitness_guidance')
  final bool? supportSetFitnessGuidance;
  @JsonKey(name: 'support_set_game_time_reminder')
  final bool? supportSetGameTimeReminder;
  @JsonKey(name: 'support_set_historical_menstruation_use_version2')
  final bool? supportSetHistoricalMenstruationUseVersion2;
  @JsonKey(name: 'support_set_list_style')
  final bool? supportSetListStyle;
  @JsonKey(name: 'support_set_menstrual_reminder_on_off')
  final bool? supportSetMenstrualReminderOnOff;
  @JsonKey(name: 'support_set_menu_list_type_measure')
  final bool? supportSetMenuListTypeMeasure;
  @JsonKey(name: 'support_set_notice_message_state_use_version0x20')
  final bool? supportSetNoticeMessageStateUseVersion0x20;
  @JsonKey(name: 'support_set_peripherals_info')
  final bool? supportSetPeripheralsInfo;
  @JsonKey(name: 'support_set_screen_bright_interval')
  final bool? supportSetScreenBrightInterval;
  @JsonKey(name: 'support_set_v3_heart_interval')
  final bool? supportSetV3HeartInterval;
  @JsonKey(name: 'support_set_v3_weatcher_add_atmospheric_pressure')
  final bool? supportSetV3WeatcherAddAtmosphericPressure;
  @JsonKey(name: 'support_set_v3_weatcher_add_snow_depth')
  final bool? supportSetV3WeatcherAddSnowDepth;
  @JsonKey(name: 'support_set_v3_weatcher_add_snowfall')
  final bool? supportSetV3WeatcherAddSnowfall;
  @JsonKey(name: 'support_set_v3_weatcher_send_struct_version_04')
  final bool? supportSetV3WeatcherSendStructVersion04;
  @JsonKey(name: 'support_set_version_information')
  final bool? supportSetVersionInformation;
  @JsonKey(name: 'support_set_voice_assistant_status')
  final bool? supportSetVoiceAssistantStatus;
  @JsonKey(name: 'support_set_weather_history_future_aqi')
  final bool? supportSetWeatherHistoryFutureAqi;
  @JsonKey(name: 'support_six_axis_sensor')
  final bool? supportSixAxisSensor;
  @JsonKey(name: 'support_sleep_plan')
  final bool? supportSleepPlan;
  @JsonKey(name: 'support_smart_competitor')
  final bool? supportSmartCompetitor;
  @JsonKey(name: 'support_sync_activity_data_3d_distance_speed')
  final bool? supportSyncActivityData3dDistanceSpeed;
  @JsonKey(name: 'support_sync_activity_data_altitude_info')
  final bool? supportSyncActivityDataAltitudeInfo;
  @JsonKey(name: 'support_sync_activity_data_avg_slope')
  final bool? supportSyncActivityDataAvgSlope;
  @JsonKey(name: 'support_sync_activity_get_anaerobic_training_effect')
  final bool? supportSyncActivityGetAnaerobicTrainingEffect;
  @JsonKey(name: 'support_sync_activity_get_load')
  final bool? supportSyncActivityGetLoad;
  @JsonKey(name: 'support_sync_activity_get_real_time_oxygen_consumption')
  final bool? supportSyncActivityGetRealTimeOxygenConsumption;
  @JsonKey(name: 'support_sync_activity_get_real_time_physical_exertion')
  final bool? supportSyncActivityGetRealTimePhysicalExertion;
  @JsonKey(name: 'support_sync_activity_get_rope_info')
  final bool? supportSyncActivityGetRopeInfo;
  @JsonKey(name: 'support_sync_activity_get_running_power_info')
  final bool? supportSyncActivityGetRunningPowerInfo;
  @JsonKey(name: 'support_sync_activity_type_treadmills_show_step')
  final bool? supportSyncActivityTypeTreadmillsShowStep;
  @JsonKey(name: 'support_sync_ecg')
  final bool? supportSyncEcg;
  @JsonKey(name: 'support_sync_health_hr_use_version_compatible')
  final bool? supportSyncHealthHrUseVersionCompatible;
  @JsonKey(name: 'support_sync_health_swim_get_avg_frequency')
  final bool? supportSyncHealthSwimGetAvgFrequency;
  @JsonKey(name: 'support_sync_health_swim_get_avg_speed')
  final bool? supportSyncHealthSwimGetAvgSpeed;
  @JsonKey(name: 'support_taobao')
  final bool? supportTaobao;
  @JsonKey(name: 'support_tas_smart')
  final bool? supportTasSmart;
  @JsonKey(name: 'support_tmail')
  final bool? supportTmail;
  @JsonKey(name: 'support_toutiao')
  final bool? supportToutiao;
  @JsonKey(name: 'support_type_reset_device_bluetooth')
  final bool? supportTypeResetDeviceBluetooth;
  @JsonKey(name: 'support_update_gps')
  final bool? supportUpdateGps;
  @JsonKey(name: 'support_v2_disturb_all_day_switch')
  final bool? supportV2DisturbAllDaySwitch;
  @JsonKey(name: 'support_v2_disturb_smart_switch')
  final bool? supportV2DisturbSmartSwitch;
  @JsonKey(name: 'support_v2_get_deletable_meun_list')
  final bool? supportV2GetDeletableMeunList;
  @JsonKey(name: 'support_v2_set_show_music_info_switch')
  final bool? supportV2SetShowMusicInfoSwitch;
  @JsonKey(name: 'support_v3_sleep_health_sync_add_sleep_avg_hr')
  final bool? supportV3SleepHealthSyncAddSleepAvgHr;
  @JsonKey(name: 'support_v3_sleep_health_sync_add_sleep_avg_respir_rate')
  final bool? supportV3SleepHealthSyncAddSleepAvgRespirRate;
  @JsonKey(name: 'support_v3_sleep_health_sync_add_sleep_avg_spo2')
  final bool? supportV3SleepHealthSyncAddSleepAvgSpo2;
  @JsonKey(name: 'support_voice_memo_operate')
  final bool? supportVoiceMemoOperate;
  @JsonKey(name: 'support_walk_goal_steps')
  final bool? supportWalkGoalSteps;
  @JsonKey(name: 'support_warm_up_before_running')
  final bool? supportWarmUpBeforeRunning;
  @JsonKey(name: 'support_weibo')
  final bool? supportWeibo;
  @JsonKey(name: 'suppport_ping_ios')
  final bool? suppportPingIos;
  final bool? surfing;
  @JsonKey(name: 'surpport_new_retain_data')
  final bool? surpportNewRetainData;
  @JsonKey(name: 'sync_v3_health_sleep_data_type_not_limit')
  final bool? syncV3HealthSleepDataTypeNotLimit;
  final bool? timeLine;
  final bool? tipInfoContact;
  final bool? tipInfoContent;
  final bool? tipInfoNum;
  @JsonKey(name: 'trail_running')
  final bool? trailRunning;
  @JsonKey(name: 'ui_controll_sports')
  final bool? uiControllSports;
  final bool? unitSet;
  final bool? upHandGestrue;
  @JsonKey(name: 'v2_get_bt_addr')
  final bool? v2GetBtAddr;
  @JsonKey(name: 'v2_send_calibration_threshold')
  final bool? v2SendCalibrationThreshold;
  @JsonKey(name: 'v2_send_notice_call_time')
  final bool? v2SendNoticeCallTime;
  @JsonKey(name: 'v2_send_set_smart_heart_time')
  final bool? v2SendSetSmartHeartTime;
  @JsonKey(name: 'v2_set_alexa_operation_100brightness')
  final bool? v2SetAlexaOperation100brightness;
  @JsonKey(name: 'v2_set_notice_missed_call')
  final bool? v2SetNoticeMissedCall;
  @JsonKey(name: 'v2_set_notification_status')
  final bool? v2SetNotificationStatus;
  @JsonKey(name: 'v2_set_stress_calibration')
  final bool? v2SetStressCalibration;
  @JsonKey(name: 'v2_set_unread_app_reminder_03_EA')
  final bool? v2SetUnreadAppReminder03Ea;
  @JsonKey(name: 'v2_support_add_night_level')
  final bool? v2SupportAddNightLevel;
  @JsonKey(name: 'v2_support_adjust_night_turn_on_after_sunset')
  final bool? v2SupportAdjustNightTurnOnAfterSunset;
  @JsonKey(name: 'v2_support_disable_func')
  final bool? v2SupportDisableFunc;
  @JsonKey(name: 'v2_support_disturb_three_on_off')
  final bool? v2SupportDisturbThreeOnOff;
  @JsonKey(name: 'v2_support_get_all_contact')
  final bool? v2SupportGetAllContact;
  @JsonKey(name: 'v2_support_get_battery_mode')
  final bool? v2SupportGetBatteryMode;
  @JsonKey(name: 'v2_support_notice_icon_information')
  final bool? v2SupportNoticeIconInformation;
  @JsonKey(name: 'v2_support_set_bright_screen_time')
  final bool? v2SupportSetBrightScreenTime;
  @JsonKey(name: 'v2_support_set_get_msg_all_switch')
  final bool? v2SupportSetGetMsgAllSwitch;
  @JsonKey(name: 'v2_support_set_get_no_reminder_on_walk_reminder')
  final bool? v2SupportSetGetNoReminderOnWalkReminder;
  @JsonKey(name: 'v2_support_set_no_reminder_on_drink_reminder')
  final bool? v2SupportSetNoReminderOnDrinkReminder;
  @JsonKey(name: 'v2_support_set_step_data_type')
  final bool? v2SupportSetStepDataType;
  @JsonKey(name: 'v2_support_set_time_zone_float')
  final bool? v2SupportSetTimeZoneFloat;
  @JsonKey(name: 'v2_support_wallpaper_watch_face_only_time_color')
  final bool? v2SupportWallpaperWatchFaceOnlyTimeColor;
  @JsonKey(name: 'v2_surport_bp_set_or_measurement')
  final bool? v2SurportBpSetOrMeasurement;
  @JsonKey(name: 'v2_surport_calling_delay_three_seconds')
  final bool? v2SurportCallingDelayThreeSeconds;
  @JsonKey(name: 'v2_surport_tran_flash_telink_log')
  final bool? v2SurportTranFlashTelinkLog;
  @JsonKey(name: 'v2_v3_support_respiration_rate')
  final bool? v2V3SupportRespirationRate;
  @JsonKey(name: 'v3_body_power')
  final bool? v3BodyPower;
  @JsonKey(name: 'v3_fast_msg_data')
  final bool? v3FastMsgData;
  @JsonKey(name: 'v3_function_table_33_1a')
  final bool? v3FunctionTable331a;
  @JsonKey(name: 'v3_get_health_size_by_offset')
  final bool? v3GetHealthSizeByOffset;
  @JsonKey(name: 'v3_heart_set_rate_mode_custom')
  final bool? v3HeartSetRateModeCustom;
  @JsonKey(name: 'v3_oxygen_data_support_grade')
  final bool? v3OxygenDataSupportGrade;
  @JsonKey(name: 'v3_schedule_reminder_phase_two')
  final bool? v3ScheduleReminderPhaseTwo;
  @JsonKey(name: 'v3_set_get_alarm_specify_type')
  final bool? v3SetGetAlarmSpecifyType;
  @JsonKey(name: 'v3_skateboard')
  final bool? v3Skateboard;
  @JsonKey(name: 'v3_support_activity_sync_real_time')
  final bool? v3SupportActivitySyncRealTime;
  @JsonKey(name: 'v3_support_data_tran_get_new_error_code')
  final bool? v3SupportDataTranGetNewErrorCode;
  @JsonKey(name: 'v3_support_get_ble_beep')
  final bool? v3SupportGetBleBeep;
  @JsonKey(name: 'v3_support_get_ble_music_info_version_0x10')
  final bool? v3SupportGetBleMusicInfoVersion0x10;
  @JsonKey(name: 'v3_support_get_habit_data')
  final bool? v3SupportGetHabitData;
  @JsonKey(name: 'v3_support_get_watch_size')
  final bool? v3SupportGetWatchSize;
  @JsonKey(name: 'v3_support_per_bp')
  final bool? v3SupportPerBp;
  @JsonKey(name: 'v3_support_set_contact_version_0x10')
  final bool? v3SupportSetContactVersion0x10;
  @JsonKey(name: 'v3_support_set_get_emergency_connact')
  final bool? v3SupportSetGetEmergencyConnact;
  @JsonKey(name: 'v3_support_set_hot_start_param')
  final bool? v3SupportSetHotStartParam;
  @JsonKey(name: 'v3_support_set_repeat_type_on_schedule_reminder')
  final bool? v3SupportSetRepeatTypeOnScheduleReminder;
  @JsonKey(name: 'v3_support_set_repeat_week_type_on_schedule_reminder')
  final bool? v3SupportSetRepeatWeekTypeOnScheduleReminder;
  @JsonKey(name: 'v3_support_set_v3_add_48_hour_weather_data')
  final bool? v3SupportSetV3Add48HourWeatherData;
  @JsonKey(name: 'v3_support_set_v3_add_48_hour_weather_data_or_cityname')
  final bool? v3SupportSetV3Add48HourWeatherDataOrCityname;
  @JsonKey(name: 'v3_support_set_v3_weatcher_add_air_grade')
  final bool? v3SupportSetV3WeatcherAddAirGrade;
  @JsonKey(name: 'v3_support_set_v3_weatcher_add_sunrise')
  final bool? v3SupportSetV3WeatcherAddSunrise;
  @JsonKey(name: 'v3_support_sports_plan')
  final bool? v3SupportSportsPlan;
  @JsonKey(name: 'v3_surport_sport_medium_icon')
  final bool? v3SurportSportMediumIcon;
  final bool? versionInfo;
  @JsonKey(name: 'walk_reminder')
  final bool? walkReminder;
  final bool? weather;
  @JsonKey(name: 'weather_city')
  final bool? weatherCity;
  final bool? wechatSport;
  final bool? whatsapp;
  final bool? zumba;

  const FunctionTableModel({
    this.airohaGpsChip,
    this.BindAuth,
    this.BindCodeAuth,
    this.BloodPressure,
    this.FiveHRInterval,
    this.Gmail,
    this.HIDPhoto,
    this.HIIT,
    this.KakaoTalk,
    this.Line,
    this.Outlook,
    this.Snapchat,
    this.Telegram,
    this.v2SupportGetHeartRateMode,
    this.v2SupportGetSwitchStatusAppend,
    this.v2SupportSetGetTimeGoalType,
    this.v3VeryfitNotSupportPhotoWallpaper,
    this.v3AlexaReminderAddSec,
    this.v3AlexaSetEasyOperate,
    this.v3AlexaSetGetAlexaAlarm,
    this.v3AlexaSetJumpSportUi,
    this.v3AlexaSetJumpUi,
    this.v3AlexaSetSetOnOffType,
    this.v3AlexaSetWeather,
    this.v3AlexaTimeNew,
    this.v3AutoActivitySwitch,
    this.v3AutomaticSyncV3HealthData,
    this.v3DevSupportPairEachConnect,
    this.v3DrinkWaterAddNotifyFlag,
    this.v3GetBatteryLog,
    this.v3GetCalorieDistanceGoal,
    this.v3GetDevLogState,
    this.v3GetMenuList,
    this.v3GetWalkReminder,
    this.v3GetWatchListNew,
    this.v3HealthSyncNoise,
    this.v3HealthSyncTemperature,
    this.v3MenstrualAddNotifyFlag,
    this.v3MusicControl02AddSingerName,
    this.v3PressureAddNotifyFlagAndMode,
    this.v3ScheduleReminder,
    this.v3Set100SportSort,
    this.v3Set20BaseSportParamSort,
    this.v3SetMainUiSort,
    this.v3SetMidHighTimeGoal,
    this.v3SetSharkingGrade,
    this.v3SetWalkReminderGoalTime,
    this.v3SetWallpaperDial,
    this.v3SetWatchDialSort,
    this.v3Spo2AddNotifyFlag,
    this.v3Support189email,
    this.v3Support99taxi,
    this.v3SupportAliexpress,
    this.v3SupportAmericanas,
    this.v3SupportEnjoei,
    this.v3SupportExchangeemail,
    this.v3SupportGoogleMeet,
    this.v3SupportInstantemail,
    this.v3SupportMagalu,
    this.v3SupportMercadoLivre,
    this.v3SupportMormaiiSmartwatch,
    this.v3SupportMotoemail,
    this.v3SupportOla,
    this.v3SupportRappi,
    this.v3SupportShopee,
    this.v3SupportTeams,
    this.v3SupportTechnosConnect,
    this.v3SupportUber,
    this.v3SupportUberEats,
    this.v3SupportWhatsappBusiness,
    this.v3SupportYtmusic,
    this.v3SupportYahoo,
    this.v3SupportAlibabaEmail,
    this.v3SupportAppSendVoiceToBle,
    this.v3SupportAsuseemail,
    this.v3SupportBlueemail,
    this.v3SupportBpCalibration,
    this.v3SupportCalendario,
    this.v3SupportCalorieUnit,
    this.v3SupportCyclingUnit,
    this.v3SupportDataTranContinue,
    this.v3SupportDokidokemail,
    this.v3SupportGeneral,
    this.v3SupportGetActivitySwitch,
    this.v3SupportGetAlexaDefaultLanguage,
    this.v3SupportGetHealthSwitchState,
    this.v3SupportGetMainSportGoal,
    this.v3SupportGooglegmail,
    this.v3SupportHrv,
    this.v3SupportHtcemail,
    this.v3SupportInboxemail,
    this.v3SupportLfood,
    this.v3SupportMailruemail,
    this.v3SupportMattersRemind,
    this.v3SupportMicrosoft,
    this.v3SupportMissedCalls,
    this.v3SupportMobiemail,
    this.v3SupportMyemail,
    this.v3SupportNeteasemail,
    this.v3SupportNhnemail,
    this.v3SupportNiosefit,
    this.v3SupportOutlookemail,
    this.v3SupportQqemail,
    this.v3SupportScientificSleep,
    this.v3SupportSetScientificSleepSwitch,
    this.v3SupportSetSmartHeartRate,
    this.v3SupportSetSpo2AllDayOnOff,
    this.v3SupportSetSpo2LowValueRemind,
    this.v3SupportSetTemperatureSwitch,
    this.v3SupportSetV3MusicName,
    this.v3SupportSetV3NotifyAddAppName,
    this.v3SupportSetV3Weather,
    this.v3SupportSetV3WorldTime,
    this.v3SupportSetWeatherSunTime,
    this.v3SupportShowDetectionTime,
    this.v3SupportSwimPoolUnit,
    this.v3SupportSwimmingDataExhibit,
    this.v3SupportSyncContact,
    this.v3SupportSyncOverHighLowHeartData,
    this.v3SupportTrtfbluemail,
    this.v3SupportV3BleMusic,
    this.v3SupportV3ExchangeDataReplyAddRealTimeSpeedPace,
    this.v3SupportV3GetSportSortField,
    this.v3SupportV3LongCityName,
    this.v3SupportV3NotifyIconAdaptive,
    this.v3SupportVeryfit,
    this.v3SupportWalkingRunningUnit,
    this.v3SupportWatchCapacitySizeDisplay,
    this.v3SupportWatchPhotoPositionMove,
    this.v3SupportWearFlag,
    this.v3SupportYahooemail,
    this.v3SupportZohoemail,
    this.v3SyncV3ActivityAddParam,
    this.v3V202EbFirmwareBtVersion01Create,
    this.v3V2MenstrualRemind02AddPregnancy,
    this.v3V3333dHistoricalMenstruation01Create,
    this.v3WalkReminderAddNotifyFlag,
    this.v3WatchDailSetAddSize,
    this.VKontakte,
    this.Viber,
    this.WatchDial,
    this.activitySwitch,
    this.aerobicsBodybuildingExercise,
    this.agpsOffline,
    this.agpsOnline,
    this.alarmBath,
    this.alarmBrushTeeth,
    this.alarmClock,
    this.alarmCount,
    this.alarmCourse,
    this.alarmCustom,
    this.alarmDating,
    this.alarmDinner,
    this.alarmLearn,
    this.alarmMedicine,
    this.alarmMetting,
    this.alarmParty,
    this.alarmPlayTime,
    this.alarmRest,
    this.alarmSleep,
    this.alarmSport,
    this.alarmWakeUp,
    this.allAppNotice,
    this.ancs,
    this.antilost,
    this.autoActivityEndSwitchNotDisplay,
    this.autoActivityPauseSwitchNotDisplay,
    this.autoActivitySetGetUseNewStructExchange,
    this.autoActivitySwitchAddBicycle,
    this.autoActivitySwitchAddSmartRope,
    this.battlingRope,
    this.beachTennis,
    this.bilateralAntiLost,
    this.bleControlMusic,
    this.bleControlTakePhoto,
    this.breatheTrain,
    this.calendar,
    this.calling,
    this.callingContact,
    this.callingNum,
    this.chooseOtherOtaMode,
    this.cricket,
    this.dataTranOverWaitBle,
    this.defaultConfig,
    this.defaultSportType,
    this.deviceUpdate,
    this.deviceControlFastModeAlone,
    this.displayMode,
    this.disturbHaveRangRepeat,
    this.doNotDisturb,
    this.downloadLanguage,
    this.elliptical,
    this.exFuncTable,
    this.exActivityTimeSync,
    this.exDhNewAppNotice,
    this.exGps,
    this.exId107LDial,
    this.exLang1Danish,
    this.exLang1Slovak,
    this.exLang2Croatian,
    this.exLang2Hindi,
    this.exLang2Indonesian,
    this.exLang2Korean,
    this.exLang2Portuguese,
    this.exLang2Turkish,
    this.exLang3Arabic,
    this.exLang3Burmese,
    this.exLang3Filipino,
    this.exLang3Greek,
    this.exLang3Sweden,
    this.exLang3Thai,
    this.exLang3TraditionalChinese,
    this.exLang3Vietnamese,
    this.exLangDutch,
    this.exLangHungarian,
    this.exLangLithuanian,
    this.exLangPolish,
    this.exLangRomanian,
    this.exLangRussian,
    this.exLangSlovenian,
    this.exLangUkrainian,
    this.exMain3CalorieGoal,
    this.exMain3DistanceGoal,
    this.exMain3GetDoNotDisturb,
    this.exMain3Menstruation,
    this.exMain3V3Pressure,
    this.exMain3V3Spo2Data,
    this.exMain4DrinkWaterReminder,
    this.exMain4IosAutoPair,
    this.exMain4IosNoDisconnectPair,
    this.exMain4V3ActivityData,
    this.exMain4V3GpsDataData,
    this.exMain4V3HrData,
    this.exMain4V3Swim,
    this.exMain7ChargingTime,
    this.exMain7MenuList,
    this.exMain7PhotoWallpaper,
    this.exMain7UtcTimeZone,
    this.exNoitice128byte,
    this.exNotice250byte,
    this.exScreenBrightness,
    this.exSleepPeriod,
    this.exTableMain10ClearBleCache,
    this.exTableMain10GetDevName,
    this.exTableMain10GetWatchId,
    this.exTableMain10SetHandWashingReminder,
    this.exTableMain10SetPhoneVoice,
    this.exTableMain10V3GetLangLibrary,
    this.exTableMain10V3NotifyMsg,
    this.exTableMain10V3VoiceSupportAlexa,
    this.exTableMain11AlarmOtherIsNoLabel,
    this.exTableMain11NotSupportHeartRateHighAlarm,
    this.exTableMain11NotSupportV3ActivityGpsExchange,
    this.exTableMain11PressureHighThresholdReminder,
    this.exTableMain11SupportCloudDial,
    this.exTableMain11TakingMedicine,
    this.exTableMain11UseAesEncode,
    this.exTableMain7ChoiceUse,
    this.exTableMain7HeartRateInterval,
    this.exTableMain7V3SportsType,
    this.exTableMain7VoiceTransmission,
    this.exTableMain8EncryptedAuth,
    this.exTableMain8ScreenBrightness3Level,
    this.exTableMain8UbloxModel,
    this.exTableMain8V3GetHeatLog,
    this.exTableMain8V3Sleep,
    this.exTableMain8V3Spo2OffChange,
    this.exTableMain8V3SyncActivity,
    this.exTableMain8V3SyncAlarm,
    this.exTableMain9FastMsgData,
    this.exTableMain9GetDeviceUpdateState,
    this.exTableMain9GetScreenBrightness,
    this.exTableMain9GetUpHandGesture,
    this.exTableMain9IsWatch,
    this.exTableMain9RestoreFactory,
    this.exTableMain9V3ActivityExchangeData,
    this.exTableMain9V3Sports,
    this.exV3Log,
    this.factoryReset,
    this.fastSync,
    this.findDevice,
    this.findPhone,
    this.fineTImeControl,
    this.flashLog,
    this.flipScreen,
    this.footvolley,
    this.healthSyncV3ActivityEndTimeUseUtcMode,
    this.heartRate,
    this.heartRateMonitor,
    this.heartRateOffByDefault,
    this.hidPhoto,
    this.highBar,
    this.indoorCycle,
    this.indoorRun,
    this.indoorWalk,
    this.instagram,
    this.isNeedSyncV2,
    this.langBengali,
    this.langBrazilianPortuguese,
    this.langCh,
    this.langCzech,
    this.langEng,
    this.langFinland,
    this.langFrench,
    this.langGerman,
    this.langHebrew,
    this.langItalian,
    this.langJapanese,
    this.langKhmer,
    this.langMalay,
    this.langNorwegian,
    this.langPersia,
    this.langSerbian,
    this.langSpanish,
    this.level5HrInterval,
    this.liftingWristBacklight,
    this.linkedIn,
    this.logIn,
    this.longMtu,
    this.mediumToHighActiveDuration,
    this.messengre,
    this.mountainBiking,
    this.mountaineering,
    this.multiActivityNoUseApp,
    this.multiDial,
    this.nightAutoBrightness,
    this.noShowHRInterval,
    this.noiseSupportSetNotifyFlag,
    this.noiseSupportSetOverwarning,
    this.notSupportAppSendRunPlan,
    this.notSupportDeleteAddSportSort,
    this.notSupportIndoorRunGetVo2max,
    this.notSupportSetOvulation,
    this.noticeEmail,
    this.noticeFacebook,
    this.noticeMessage,
    this.noticeQQ,
    this.noticeSinaWeibo,
    this.noticeTwitter,
    this.noticeWeixin,
    this.noticeAmazon,
    this.noticeDailyhunt,
    this.noticeFlipkart,
    this.noticeGpay,
    this.noticeHotstar,
    this.noticeInshorts,
    this.noticeJioTv,
    this.noticeMakeMyTrip,
    this.noticeNetflix,
    this.noticePaytm,
    this.noticePhonpe,
    this.noticePrime,
    this.noticeRedbus,
    this.noticeSwiggy,
    this.noticeTiktok,
    this.noticeZomato,
    this.noticeChatwork,
    this.noticeKeep,
    this.noticePinterestYahoo,
    this.noticeSlack,
    this.noticeStepper,
    this.noticeTumblr,
    this.noticeYahooMail,
    this.noticeYoutube,
    this.onetouchCalling,
    this.openWaterSwim,
    this.orienteering,
    this.other,
    this.otherActivity,
    this.outdoorCycle,
    this.outdoorFun,
    this.outdoorRun,
    this.outdoorWalk,
    this.parachuting,
    this.parallelBars,
    this.pickleball,
    this.pilates,
    this.poolSwim,
    this.protocolV3SportRecordShowConfig,
    this.pullUp,
    this.realtimeData,
    this.rower,
    this.scheduleReminderNotDisplayTitle,
    this.scientificSleepSwitchOffByDefault,
    this.screenBrightness5Level,
    this.sedentariness,
    this.shortcut,
    this.singleSport,
    this.skype,
    this.sleepMonitor,
    this.smartRope,
    this.sportModeSort,
    this.sportShowNum,
    this.sportType0Badminton,
    this.sportType0ByBike,
    this.sportType0MountainClimbing,
    this.sportType0OnFoot,
    this.sportType0Other,
    this.sportType0Run,
    this.sportType0Swim,
    this.sportType0Walk,
    this.sportType1Dumbbell,
    this.sportType1Ellipsoid,
    this.sportType1Fitness,
    this.sportType1PushUp,
    this.sportType1SitUp,
    this.sportType1Spinning,
    this.sportType1Treadmill,
    this.sportType1Weightlifting,
    this.sportType2Basketball,
    this.sportType2BodybuildingExercise,
    this.sportType2Footballl,
    this.sportType2RopeSkipping,
    this.sportType2TableTennis,
    this.sportType2Tennis,
    this.sportType2Volleyball,
    this.sportType2Yoga,
    this.sportType3Baseball,
    this.sportType3CoreTraining,
    this.sportType3Dance,
    this.sportType3Golf,
    this.sportType3RollerSkating,
    this.sportType3Skiing,
    this.sportType3StrengthTraining,
    this.sportType3TidyUpRelax,
    this.sportTypeTraditionalStrengthTraining,
    this.squat,
    this.standingWaterSkiing,
    this.staticHR,
    this.stepCalculation,
    this.supportAchievedRemindOnOff,
    this.supportActivityExchangeSetGpsCoordinates,
    this.supportAlipay,
    this.supportAppSendPhoneSystemInfo,
    this.supportBaidu,
    this.supportBarometricAltimeter,
    this.supportBleControlPhotograph,
    this.supportBleToAppDailChange,
    this.supportBloodPressureModelFileUpdate,
    this.supportCalendarReminder,
    this.supportCallList,
    this.supportCallingQuickReply,
    this.supportCompass,
    this.supportConfigDefaultMegApplicationList,
    this.supportControlMiniProgram,
    this.supportDialFrameEncodeFormatArgb6666,
    this.supportDingtalk,
    this.supportDisplayNapSleep,
    this.supportDouyin,
    this.supportDrinkPlan,
    this.supportECardOperate,
    this.supportEleme,
    this.supportEncryptedCodeResend0405,
    this.supportExchangeActivityGetAltitudeRiseLoss,
    this.supportExchangeActivityGetGpsStatus,
    this.supportFahrenheit,
    this.supportFastrackReflexWorld,
    this.supportGetFlashLogSize,
    this.supportGetPeripheralsInfo,
    this.supportGetPressureSwitchInfo,
    this.supportGetProtocolV3OperateAlgFile,
    this.supportGetSetMaxItemsNum,
    this.supportGetSmartHeartRate,
    this.supportGetSnInfo,
    this.supportGetSpo2SwitchInfo,
    this.supportGetUnit,
    this.supportGetV3DeviceAlgorithmVersion,
    this.supportGetV3DeviceBtConnectPhoneModel,
    this.supportGetWalkReminder,
    this.supportHamaFitMove,
    this.supportJd,
    this.supportLoopsFit,
    this.supportLoudspeaker,
    this.supportLvglDialFrame,
    this.supportMakeWatchDialDeocdeJpg,
    this.supportMeituan,
    this.supportMorningEdition,
    this.supportOnekeyDoubleContact,
    this.supportOverFindPhone,
    this.supportPerMinuteOne,
    this.supportPinduoduo,
    this.supportRecoverTimeAndVo2max,
    this.supportRyzeConnect,
    this.supportSecondSportIcon,
    this.supportSedentaryTensileHabitInfo,
    this.supportSendBindDeviceTable,
    this.supportSendEncryptedDataWithBind,
    this.supportSendGpsLongitudeAndLatitude,
    this.supportSendOriginalSize,
    this.supportSendScalesModelMapTable,
    this.supportSetCallQuickReplyOnOff,
    this.supportSetEcgReminder,
    this.supportSetEciReminder,
    this.supportSetFastModeWhenSyncConfig,
    this.supportSetFitnessGuidance,
    this.supportSetGameTimeReminder,
    this.supportSetHistoricalMenstruationUseVersion2,
    this.supportSetListStyle,
    this.supportSetMenstrualReminderOnOff,
    this.supportSetMenuListTypeMeasure,
    this.supportSetNoticeMessageStateUseVersion0x20,
    this.supportSetPeripheralsInfo,
    this.supportSetScreenBrightInterval,
    this.supportSetV3HeartInterval,
    this.supportSetV3WeatcherAddAtmosphericPressure,
    this.supportSetV3WeatcherAddSnowDepth,
    this.supportSetV3WeatcherAddSnowfall,
    this.supportSetV3WeatcherSendStructVersion04,
    this.supportSetVersionInformation,
    this.supportSetVoiceAssistantStatus,
    this.supportSetWeatherHistoryFutureAqi,
    this.supportSixAxisSensor,
    this.supportSleepPlan,
    this.supportSmartCompetitor,
    this.supportSyncActivityData3dDistanceSpeed,
    this.supportSyncActivityDataAltitudeInfo,
    this.supportSyncActivityDataAvgSlope,
    this.supportSyncActivityGetAnaerobicTrainingEffect,
    this.supportSyncActivityGetLoad,
    this.supportSyncActivityGetRealTimeOxygenConsumption,
    this.supportSyncActivityGetRealTimePhysicalExertion,
    this.supportSyncActivityGetRopeInfo,
    this.supportSyncActivityGetRunningPowerInfo,
    this.supportSyncActivityTypeTreadmillsShowStep,
    this.supportSyncEcg,
    this.supportSyncHealthHrUseVersionCompatible,
    this.supportSyncHealthSwimGetAvgFrequency,
    this.supportSyncHealthSwimGetAvgSpeed,
    this.supportTaobao,
    this.supportTasSmart,
    this.supportTmail,
    this.supportToutiao,
    this.supportTypeResetDeviceBluetooth,
    this.supportUpdateGps,
    this.supportV2DisturbAllDaySwitch,
    this.supportV2DisturbSmartSwitch,
    this.supportV2GetDeletableMeunList,
    this.supportV2SetShowMusicInfoSwitch,
    this.supportV3SleepHealthSyncAddSleepAvgHr,
    this.supportV3SleepHealthSyncAddSleepAvgRespirRate,
    this.supportV3SleepHealthSyncAddSleepAvgSpo2,
    this.supportVoiceMemoOperate,
    this.supportWalkGoalSteps,
    this.supportWarmUpBeforeRunning,
    this.supportWeibo,
    this.suppportPingIos,
    this.surfing,
    this.surpportNewRetainData,
    this.syncV3HealthSleepDataTypeNotLimit,
    this.timeLine,
    this.tipInfoContact,
    this.tipInfoContent,
    this.tipInfoNum,
    this.trailRunning,
    this.uiControllSports,
    this.unitSet,
    this.upHandGestrue,
    this.v2GetBtAddr,
    this.v2SendCalibrationThreshold,
    this.v2SendNoticeCallTime,
    this.v2SendSetSmartHeartTime,
    this.v2SetAlexaOperation100brightness,
    this.v2SetNoticeMissedCall,
    this.v2SetNotificationStatus,
    this.v2SetStressCalibration,
    this.v2SetUnreadAppReminder03Ea,
    this.v2SupportAddNightLevel,
    this.v2SupportAdjustNightTurnOnAfterSunset,
    this.v2SupportDisableFunc,
    this.v2SupportDisturbThreeOnOff,
    this.v2SupportGetAllContact,
    this.v2SupportGetBatteryMode,
    this.v2SupportNoticeIconInformation,
    this.v2SupportSetBrightScreenTime,
    this.v2SupportSetGetMsgAllSwitch,
    this.v2SupportSetGetNoReminderOnWalkReminder,
    this.v2SupportSetNoReminderOnDrinkReminder,
    this.v2SupportSetStepDataType,
    this.v2SupportSetTimeZoneFloat,
    this.v2SupportWallpaperWatchFaceOnlyTimeColor,
    this.v2SurportBpSetOrMeasurement,
    this.v2SurportCallingDelayThreeSeconds,
    this.v2SurportTranFlashTelinkLog,
    this.v2V3SupportRespirationRate,
    this.v3BodyPower,
    this.v3FastMsgData,
    this.v3FunctionTable331a,
    this.v3GetHealthSizeByOffset,
    this.v3HeartSetRateModeCustom,
    this.v3OxygenDataSupportGrade,
    this.v3ScheduleReminderPhaseTwo,
    this.v3SetGetAlarmSpecifyType,
    this.v3Skateboard,
    this.v3SupportActivitySyncRealTime,
    this.v3SupportDataTranGetNewErrorCode,
    this.v3SupportGetBleBeep,
    this.v3SupportGetBleMusicInfoVersion0x10,
    this.v3SupportGetHabitData,
    this.v3SupportGetWatchSize,
    this.v3SupportPerBp,
    this.v3SupportSetContactVersion0x10,
    this.v3SupportSetGetEmergencyConnact,
    this.v3SupportSetHotStartParam,
    this.v3SupportSetRepeatTypeOnScheduleReminder,
    this.v3SupportSetRepeatWeekTypeOnScheduleReminder,
    this.v3SupportSetV3Add48HourWeatherData,
    this.v3SupportSetV3Add48HourWeatherDataOrCityname,
    this.v3SupportSetV3WeatcherAddAirGrade,
    this.v3SupportSetV3WeatcherAddSunrise,
    this.v3SupportSportsPlan,
    this.v3SurportSportMediumIcon,
    this.versionInfo,
    this.walkReminder,
    this.weather,
    this.weatherCity,
    this.wechatSport,
    this.whatsapp,
    this.zumba,
  });

  factory FunctionTableModel.fromJson(Map<String, dynamic> json) =>
      _$FunctionTableModelFromJson(json);

  Map<String, dynamic> toJson() => _$FunctionTableModelToJson(this);
}
