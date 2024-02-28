import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../private/logger/logger.dart';
import 'model/function_table_model.dart';
import '../type_define/event_type.dart';
import '../type_define/protocol_lib_type.dart';
import '../ido_protocol_lib.dart';
import '../private/local_storage/local_storage.dart';
import '../private/notification/notification.dart';

class BaseFunctionTable {
  // ------------------ 提醒 ------------------

  /// 智能通知
  bool get reminderAncs => ft?.ancs ?? false;

  /// Snapchat
  bool get reminderSnapchat => ft?.Snapchat ?? false;

  /// Line
  bool get reminderLine => ft?.Line ?? false;

  /// Outlook
  bool get reminderOutlook => ft?.Outlook ?? false;

  /// Telegram
  bool get reminderTelegram => ft?.Telegram ?? false;

  /// Viber
  bool get reminderViber => ft?.Viber ?? false;

  /// Vkontakte
  bool get reminderVkontakte => ft?.VKontakte ?? false;

  /// Chatwork;
  bool get reminderChatwork => ft?.noticeChatwork ?? false;

  /// Slack
  bool get reminderSlack => ft?.noticeSlack ?? false;

  /// Tumblr
  bool get reminderTumblr => ft?.noticeTumblr ?? false;

  /// YahooMail
  bool get reminderYahooMail => ft?.noticeYahooMail ?? false;

  /// YahooPinterest
  bool get reminderYahooPinterest => ft?.noticePinterestYahoo ?? false;

  /// Youtube
  bool get reminderYoutube => ft?.noticeYoutube ?? false;

  /// Gmail
  bool get reminderGmail => ft?.Gmail ?? false;

  /// KakaoTalk
  bool get reminderKakaoTalk => ft?.KakaoTalk ?? false;

  /// Google gmail
  bool get reminderOnlyGoogleGmail => ft?.v3SupportGooglegmail ?? false;

  /// Outlook email
  bool get reminderOnlyOutlookEmail => ft?.v3SupportOutlookemail ?? false;

  /// Yahoo email
  bool get reminderOnlyYahooEmail => ft?.v3SupportYahooemail ?? false;

  /// Tiktok
  bool get reminderTiktok => ft?.noticeTiktok ?? false;

  /// Redbus
  bool get reminderRedbus => ft?.noticeRedbus ?? false;

  /// Dailyhunt
  bool get reminderDailyhunt => ft?.noticeDailyhunt ?? false;

  /// Hotstar
  bool get reminderHotstar => ft?.noticeHotstar ?? false;

  /// Inshorts
  bool get reminderInshorts => ft?.noticeInshorts ?? false;

  /// Paytm
  bool get reminderPaytm => ft?.noticePaytm ?? false;

  /// Amazon
  bool get reminderAmazon => ft?.noticeAmazon ?? false;

  /// Flipkart
  bool get reminderFlipkart => ft?.noticeFlipkart ?? false;

  /// Nhn email
  bool get reminderNhnEmail => ft?.v3SupportNhnemail ?? false;

  /// Instant email
  bool get reminderInstantEmail => ft?.v3SupportInstantemail ?? false;

  /// Zoho email
  bool get reminderZohoEmail => ft?.v3SupportZohoemail ?? false;

  /// Exchange email
  bool get reminderExchangeEmail => ft?.v3SupportExchangeemail ?? false;

  /// 189 email
  bool get reminder189Email => ft?.v3Support189email ?? false;

  /// Very fit
  bool get reminderVeryFit => ft?.v3SupportVeryfit ?? false;

  /// General
  bool get reminderGeneral => ft?.v3SupportGeneral ?? false;

  /// Matters
  bool get reminderMattersRemind => ft?.v3SupportMattersRemind ?? false;

  /// Microsoft
  bool get reminderMicrosoft => ft?.v3SupportMicrosoft ?? false;

  /// MissedCalls
  bool get reminderMissedCall => ft?.v3SupportMissedCalls ?? false;

  /// 支持同步全部通讯录
  bool get reminderGetAllContact => ft?.v2SupportGetAllContact ?? false;

  /// WhatsappBusiness
  bool get reminderWhatsappBusiness => ft?.v3SupportWhatsappBusiness ?? false;

  /// Email
  bool get reminderEmail => ft?.noticeEmail ?? false;

  /// Facebook
  bool get reminderFacebook => ft?.noticeFacebook ?? false;

  /// Message
  bool get reminderMessage => ft?.noticeMessage ?? false;

  /// QQ
  bool get reminderQq => ft?.noticeQQ ?? false;

  /// Twitter
  bool get reminderTwitter => ft?.noticeTwitter ?? false;

  /// Weixin
  bool get reminderWeixin => ft?.noticeWeixin ?? false;

  /// Calendar (Google日历）
  bool get reminderCalendarGoogle => ft?.v3SupportCalendario ?? false;

  /// Instagram
  bool get reminderInstagram => ft?.instagram ?? false;

  /// linkedIn
  bool get reminderLinkedIn => ft?.linkedIn ?? false;

  /// Messengre
  bool get reminderMessengre => ft?.messengre ?? false;

  /// Skype
  bool get reminderSkype => ft?.skype ?? false;

  /// Calendar
  bool get reminderCalendar => ft?.calendar ?? false;

  /// Whatsapp
  bool get reminderWhatsapp => ft?.whatsapp ?? false;

  /// Alarm clock
  bool get reminderAlarmClock => ft?.alarmClock ?? false;

  /// 新浪微博
  bool get reminderSinaWeibo => ft?.noticeSinaWeibo ?? false;

  /// 来电提醒
  bool get reminderCalling => ft?.calling ?? false;

  /// 来电联系人
  bool get reminderCallContact => ft?.callingContact ?? false;

  /// 来电号码
  bool get reminderCallNum => ft?.callingNum ?? false;

  /// Prime
  bool get reminderPrime => ft?.noticePrime ?? false;

  /// Netflix
  bool get reminderNetflix => ft?.noticeNetflix ?? false;

  /// Gpay
  bool get reminderGpay => ft?.noticeGpay ?? false;

  /// Phonpe
  bool get reminderPhonpe => ft?.noticePhonpe ?? false;

  /// Swiggy
  bool get reminderSwiggy => ft?.noticeSwiggy ?? false;

  /// Zomato
  bool get reminderZomato => ft?.noticeZomato ?? false;

  /// Makemytrip
  bool get reminderMakemytrip => ft?.noticeMakeMyTrip ?? false;

  /// JioTv
  bool get reminderJioTv => ft?.noticeJioTv ?? false;

  /// Niosefit
  bool get reminderNiosefit => ft?.v3SupportNiosefit ?? false;

  /// YT music
  bool get reminderYtmusic => ft?.v3SupportYtmusic ?? false;

  /// Uber
  bool get reminderUber => ft?.v3SupportUber ?? false;

  /// Ola
  bool get reminderOla => ft?.v3SupportOla ?? false;

  /// Google meet
  bool get reminderGoogleMeet => ft?.v3SupportGoogleMeet ?? false;

  /// Mormaii Smartwatch
  bool get reminderMormaiiSmartwatch => ft?.v3SupportMormaiiSmartwatch ?? false;

  /// Technos connect
  bool get reminderTechnosConnect => ft?.v3SupportTechnosConnect ?? false;

  /// Enjoei
  bool get reminderEnjoei => ft?.v3SupportEnjoei ?? false;

  /// Aliexpress
  bool get reminderAliexpress => ft?.v3SupportAliexpress ?? false;

  /// Shopee
  bool get reminderShopee => ft?.v3SupportShopee ?? false;

  /// Teams
  bool get reminderTeams => ft?.v3SupportTeams ?? false;

  /// 99 taxi
  bool get reminder99Taxi => ft?.v3Support99taxi ?? false;

  /// Uber eats
  bool get reminderUberEats => ft?.v3SupportUberEats ?? false;

  /// Lfood
  bool get reminderLfood => ft?.v3SupportLfood ?? false;

  /// Rappi
  bool get reminderRappi => ft?.v3SupportRappi ?? false;

  /// Mercado livre
  bool get reminderMercadoLivre => ft?.v3SupportMercadoLivre ?? false;

  /// Magalu
  bool get reminderMagalu => ft?.v3SupportMagalu ?? false;

  /// Americanas
  bool get reminderAmericanas => ft?.v3SupportAmericanas ?? false;

  /// Yahoo
  bool get reminderYahoo => ft?.v3SupportYahoo ?? false;

  /// 消息图标和名字更新
  bool get reminderMessageIcon => ft?.v3SupportSetV3NotifyAddAppName ?? false;

  // ------------------ 运动 ------------------

  /// v2 走路
  bool get sportWalk => ft?.sportType0Walk ?? false;

  /// v2 跑步
  bool get sportRun => ft?.sportType0Run ?? false;

  /// v2 骑行
  bool get sportByBike => ft?.sportType0ByBike ?? false;

  /// v2 徒步
  bool get sportOnFoot => ft?.sportType0OnFoot ?? false;

  /// v2 游泳
  bool get sportSwim => ft?.sportType0Swim ?? false;

  /// v2 爬山
  bool get sportMountainClimbing => ft?.sportType0MountainClimbing ?? false;

  /// v2 羽毛球
  bool get sportBadminton => ft?.sportType0Badminton ?? false;

  /// v2 其他
  bool get sportOther => ft?.sportType0Other ?? false;

  /// v2 健身
  bool get sportFitness => ft?.sportType1Fitness ?? false;

  /// v2 动感单车
  bool get sportSpinning => ft?.sportType1Spinning ?? false;

  /// v2 椭圆球
  bool get sportEllipsoid => ft?.sportType1Ellipsoid ?? false;

  /// v2 跑步机
  bool get sportTreadmill => ft?.sportType1Treadmill ?? false;

  /// v2 仰卧起坐
  bool get sportSitUp => ft?.sportType1SitUp ?? false;

  /// v2 俯卧撑
  bool get sportPushUp => ft?.sportType1PushUp ?? false;

  /// v2 哑铃
  bool get sportDumbbell => ft?.sportType1Dumbbell ?? false;

  /// v2 举重
  bool get sportWeightlifting => ft?.sportType1Weightlifting ?? false;

  /// v2 健身操
  bool get sportBodybuildingExercise =>
      ft?.sportType2BodybuildingExercise ?? false;

  /// v2 瑜伽
  bool get sportYoga => ft?.sportType2Yoga ?? false;

  /// v2 跳绳
  bool get sportRopeSkipping => ft?.sportType2RopeSkipping ?? false;

  /// v2 乒乓球
  bool get sportTableTennis => ft?.sportType2TableTennis ?? false;

  /// v2 篮球
  bool get sportBasketball => ft?.sportType2Basketball ?? false;

  /// v2 足球
  bool get sportFootballl => ft?.sportType2Footballl ?? false;

  /// v2 排球
  bool get sportVolleyball => ft?.sportType2Volleyball ?? false;

  /// v2 网球
  bool get sportTennis => ft?.sportType2Tennis ?? false;

  /// v2 高尔夫
  bool get sportGolf => ft?.sportType3Golf ?? false;

  /// v2 棒球
  bool get sportBaseball => ft?.sportType3Baseball ?? false;

  /// v2 滑雪
  bool get sportSkiing => ft?.sportType3Skiing ?? false;

  /// v2 轮滑
  bool get sportRollerSkating => ft?.sportType3RollerSkating ?? false;

  /// v2 跳舞
  bool get sportDance => ft?.sportType3Dance ?? false;

  /// v2 功能性训练
  bool get sportStrengthTraining => ft?.sportType3StrengthTraining ?? false;

  /// v2 核心训练
  bool get sportCoreTraining => ft?.sportType3CoreTraining ?? false;

  /// v2 整体放松
  bool get sportTidyUpRelax => ft?.sportType3TidyUpRelax ?? false;

  /// v2 传统的力量训练
  bool get sportTraditionalStrengthTraining => ft?.sportTypeTraditionalStrengthTraining ?? false;

  /// v3 户外跑步
  bool get sportOutdoorRun => ft?.outdoorRun ?? false;

  /// v3 室内跑步
  bool get sportIndoorRun => ft?.indoorRun ?? false;

  /// v3 户外骑行
  bool get sportOutdoorCycle => ft?.outdoorCycle ?? false;

  /// v3 室内骑行
  bool get sportIndoorCycle => ft?.indoorCycle ?? false;

  /// v3 户外走路
  bool get sportOutdoorWalk => ft?.outdoorWalk ?? false;

  /// v3 室内走路
  bool get sportIndoorWalk => ft?.indoorWalk ?? false;

  /// v3 泳池游泳
  bool get sportPoolSwim => ft?.poolSwim ?? false;

  /// v3 开放水域游泳
  bool get sportOpenWaterSwim => ft?.openWaterSwim ?? false;

  /// v3 椭圆机
  bool get sportElliptical => ft?.elliptical ?? false;

  /// v3 划船机
  bool get sportRower => ft?.rower ?? false;

  /// v3 高强度间歇训练法
  bool get sportHiit => ft?.HIIT ?? false;

  /// v3 板球运动
  bool get sportCricket => ft?.cricket ?? false;

  /// v3 普拉提
  bool get sportPilates => ft?.pilates ?? false;

  /// v3 户外玩耍（定制 kr01）
  bool get sportOutdoorFun => ft?.outdoorFun ?? false;

  /// v3 其他运动（定制 kr01）
  bool get sportOtherActivity => ft?.otherActivity ?? false;

  /// v3 尊巴舞
  bool get sportZumba => ft?.zumba ?? false;

  /// v3 冲浪
  bool get sportSurfing => ft?.surfing ?? false;

  /// v3 足排球
  bool get sportFootvolley => ft?.footvolley ?? false;

  /// v3 站立滑水
  bool get sportStandWaterSkiing => ft?.standingWaterSkiing ?? false;

  /// v3 站绳
  bool get sportBattlingRope => ft?.battlingRope ?? false;

  /// v3 滑板
  bool get sportSkateboard => ft?.v3Skateboard ?? false;

  /// v3 踏步机
  bool get sportNoticeStepper => ft?.noticeStepper ?? false;

  /// 运动显示个数
  int get sportShowNum => ft?.sportShowNum ?? 0;

  /// 有氧健身操
  bool get sportAerobicsBodybuildingExercise => ft?.aerobicsBodybuildingExercise ?? false;

  /// 引体向上
  bool get sportPullUp => ft?.pullUp ?? false;

  /// 单杠
  bool get sportHighBar => ft?.highBar ?? false;

  /// 双杠
  bool get sportParallelBars => ft?.parallelBars ?? false;

  /// 越野跑
  bool get sportTrailRunning => ft?.trailRunning ?? false;

  ///匹克球
  bool get sportPickleBall => ft?.pickleball ?? false;

  // ------------------ 获取 ------------------

  /// 获取实时数据
  bool get getRealtimeData => ft?.realtimeData ?? false;

  /// 获取v3语言库
  bool get getLangLibraryV3 => ft?.exTableMain10V3GetLangLibrary ?? false;

  /// 查找手机
  bool get getFindPhone => ft?.findPhone ?? false;

  /// 查找设备
  bool get getFindDevice => ft?.findDevice ?? false;

  /// 抬腕亮屏数据获取
  bool get getUpHandGestureEx => ft?.exTableMain9GetUpHandGesture ?? false;

  /// 抬腕亮屏
  bool get getUpHandGesture => ft?.upHandGestrue ?? false;

  /// 天气预报
  bool get getWeather => ft?.weather ?? false;

  /// 可下载语言
  bool get getDownloadLanguage => ft?.downloadLanguage ?? false;

  /// 恢复出厂设置
  bool get getFactoryReset => ft?.factoryReset ?? false;

  /// Flash log
  bool get getFlashLog => ft?.flashLog ?? false;

  /// 多运动不能使用app
  bool get getMultiActivityNoUseApp => ft?.multiActivityNoUseApp ?? false;

  /// 多表盘
  bool get getMultiDial => ft?.multiDial ?? false;

  /// 获取菜单列表
  bool get getMenuList => ft?.v3GetMenuList ?? false;

  /// 请勿打扰
  bool get getDoNotDisturbMain3 => ft?.exMain3GetDoNotDisturb ?? false;

  /// 语音功能
  bool get getVoiceTransmission => ft?.exTableMain7VoiceTransmission ?? false;

  /// 设置喝水开关通知类型
  bool get setDrinkWaterAddNotifyFlag => ft?.v3DrinkWaterAddNotifyFlag ?? false;

  /// 获取重启日志错误码和标志位
  bool get getDeviceLogState => ft?.v3GetDevLogState ?? false;

  /// 支持获取表盘列表的接口
  bool get getNewWatchList => ft?.v3GetWatchListNew ?? false;

  /// 消息提醒图标自适应
  bool get getNotifyIconAdaptive => ft?.v3SupportV3NotifyIconAdaptive ?? false;

  /// 压力开关增加通知类型和全天压力模式设置
  bool get getPressureNotifyFlagMode => ft?.v3PressureAddNotifyFlagAndMode ?? false;

  /// 科学睡眠
  bool get getScientificSleep => ft?.v3SupportScientificSleep ?? false;

  /// 血氧开关增加通知类型
  bool get getSpo2NotifyFlag => ft?.v3Spo2AddNotifyFlag ?? false;

  /// v3 收集log
  bool get getV3Log => ft?.v3GetDevLogState ?? false;

  /// 获取表盘ID
  bool get getWatchID => ft?.exTableMain10GetWatchId ?? false;

  /// 获取设备名称
  bool get getDeviceName => ft?.exTableMain10GetDevName ?? false;

  /// 获取电池日志
  bool get getBatteryLog => ft?.v3GetBatteryLog ?? false;

  /// 获取电池信息
  bool get getBatteryInfo => ft?.v2SupportGetBatteryMode ?? false;

  /// 获取过热日志
  bool get getHeatLog => ft?.exTableMain8V3GetHeatLog ?? false;

  /// 获取走动提醒 v3
  bool get getWalkReminderV3 => ft?.v3GetWalkReminder ?? false;

  /// 获取支持蓝牙音乐 v3
  bool get getSupportV3BleMusic => ft?.v3SupportV3BleMusic ?? false;

  /// 支持获取固件本地提示音文件信息
  bool get getSupportGetBleBeepV3 => ft?.v3SupportGetBleBeep ?? false;

  /// BIT1 k6项目不需要对应的壁纸表盘，veryFit默认的都是支持的，新加一个不支持的功能表，不需要的配置这个
  bool get getVeryFitNotSupportPhotoWallpaperV3 => ft?.v3VeryfitNotSupportPhotoWallpaper ?? false;

  /// 支持升级gps固件
  bool get getSupportUpdateGps => ft?.supportUpdateGps ?? false;

  /// 支持ublox模块
  bool get getUbloxModel => ft?.exTableMain8UbloxModel ?? false;

  /// 支持获取固件歌曲名和文件夹指令下发和固件回复使用协议版本号0x10
  bool get getSupportGetBleMusicInfoVerV3 => ft?.v3SupportGetBleMusicInfoVersion0x10 ?? false;

  /// 获得固件三级版本和BT的三级版本
  bool get getBtVersion => ft?.v3V202EbFirmwareBtVersion01Create ?? false;

  /// V3的运动类型设置和获取
  bool get getSportsTypeV3 => ft?.exTableMain7V3SportsType ?? false;

  /// 支持运动模式识别开关获取
  bool get getActivitySwitch => ft?.v3SupportGetActivitySwitch ?? false;

  /// 支持动态消息图标更新
  bool get getNoticeIconInformation => ft?.v2SupportNoticeIconInformation ?? false;

  /// 支持获取固件支持app下发的详情的最大数量
  bool get getSetMaxItemsNum => ft?.supportGetSetMaxItemsNum ?? false;

  /// v3 消息提醒
  bool get getNotifyMsgV3 => ft?.exTableMain10V3NotifyMsg ?? false;

  /// 获取屏幕亮度
  bool get getScreenBrightnessMain9 => ft?.exTableMain9GetScreenBrightness ?? false;

  /// 128个字节通知
  bool get getNotice128byte => ft?.exNoitice128byte ?? false;

  /// 250个字节通知
  bool get getNotice250byte => ft?.exNotice250byte ?? false;

  /// 支持获取不可删除的快捷应用列表
  bool get getDeletableMenuListV2 => ft?.supportV2GetDeletableMeunList ?? false;

  /// 设置支持系统配对
  bool get getSupportPairEachConnect => ft?.v3DevSupportPairEachConnect ?? false;

  /// 支持获取运动目标
  bool get getSupportGetMainSportGoalV3 => ft?.v3SupportGetMainSportGoal ?? false;

  /// 取bt蓝牙MAC地址
  bool get getBtAddrV2 => ft?.v2GetBtAddr ?? false;

  /// 血压校准与测量
  bool get getSupportBpSetOrMeasurementV2 => ft?.v2SurportBpSetOrMeasurement ?? false;

  /// 生理周期开关增加通知类型
  bool get getMenstrualAddNotifyFlagV3 => ft?.v3MenstrualAddNotifyFlag ?? false;

  /// 设置获取运动三环周目标
  bool get getSupportSetGetTimeGoalTypeV2 => ft?.v2SupportSetGetTimeGoalType ?? false;

  /// 多运动同步数据支持摄氧量等级数据
  bool get getOxygenDataSupportGradeV3 => ft?.v3OxygenDataSupportGrade ?? false;

  /// 多运动数据同步支持海拔高度数据
  bool get getSupportSyncActivityDataAltitudeInfo => ft?.supportSyncActivityDataAltitudeInfo ?? false;

  /// 绑定授权码
  bool get getBindCodeAuth => ft?.BindCodeAuth ?? false;

  /// V3血氧数据 偏移按照分钟偏移
  bool get getSpo2OffChangeV3 => ft?.exTableMain8V3Spo2OffChange ?? false;

  /// 5级心率区间
  bool get getLevel5HrInterval => ft?.level5HrInterval ?? false;

  /// 5个心率区间
  bool get getFiveHRInterval => ft?.FiveHRInterval ?? false;

  /// 获得固件三级版本和BT的3级版本
  bool get getBleAndBtVersion => ft?.v3V202EbFirmwareBtVersion01Create ?? false;

  /// 紧急联系人
  bool get getSupportSetGetEmergencyContactV3 => ft?.v3SupportSetGetEmergencyConnact ?? false;

  /// 重复提醒类型设置星期重复
  bool get getSupportSetRepeatWeekTypeOnScheduleReminderV3 => ft?.v3SupportSetRepeatWeekTypeOnScheduleReminder ?? false;

  /// 重复提醒类型设置
  bool get getSupportSetRepeatTypeOnScheduleReminderV3 => ft?.v3SupportSetRepeatTypeOnScheduleReminder ?? false;

  /// 经期开关
  bool get getSupportSetMenstrualReminderOnOff => ft?.supportSetMenstrualReminderOnOff ?? false;

  /// 版本信息
  bool get getVersionInfo => ft?.versionInfo ?? false;

  /// 获取MTU
  bool get getMtu => ft?.longMtu ?? false;

  /// 获取手环的升级状态
  bool get getDeviceUpdateState => ft?.exTableMain9GetDeviceUpdateState ?? false;

  /// v2获取心率监测模式
  bool get getHeartRateModeV2 => ft?.v2SupportGetHeartRateMode ?? false;

  /// 目标步数类型为周目标
  bool get getStepDataTypeV2 => ft?.v2SupportSetStepDataType ?? false;

  /// 快速消息
  bool get getFastMsgDataV3 => ft?.v3FastMsgData ?? false;

  /// 支持快速回复
  bool get getSupportCallingQuickReply => ft?.supportCallingQuickReply ?? false;

  /// 新错误码 v3
  bool get getSupportDataTranGetNewErrorCodeV3 => ft?.v3SupportDataTranGetNewErrorCode ?? false;

  /// 运动自识别结束开关不展示，设置开关状态
  bool get getAutoActivityEndSwitchNotDisplay => ft?.autoActivityEndSwitchNotDisplay ?? false;

  /// 运动自识别暂停开关不展示，设置开关状态
  bool get getAutoActivityPauseSwitchNotDisplay => ft?.autoActivityPauseSwitchNotDisplay ?? false;

  /// 运动模式自动识别开关设置获取 新增类型椭圆机 划船机 游泳
  bool get getV3AutoActivitySwitch => ft?.v3AutoActivitySwitch ?? false;

  /// 运动模式自动识别开关设置获取 新增类型骑行
  bool get getAutoActivitySwitchAddBicycle => ft?.autoActivitySwitchAddBicycle ?? false;

  /// 运动模式自动识别开关设置获取 新增类型智能跳绳
  bool get getAutoActivitySwitchAddSmartRope => ft?.autoActivitySwitchAddSmartRope ?? false;

  /// 运动自识别获取和设置指令使用新的版本与固件交互
  bool get getAutoActivitySetGetUseNewStructExchange => ft?.autoActivitySetGetUseNewStructExchange ?? false;

  /// 支持走动提醒设置/获取免提醒时间段
  bool get getSupportSetGetNoReminderOnWalkReminderV2 => ft?.v2SupportSetGetNoReminderOnWalkReminder ?? false;

  /// 支持获取sn信息
  bool get getSupportGetSnInfo => ft?.supportGetSnInfo ?? false;

  /// 日程提醒不显示标题
  bool get getScheduleReminderNotDisplayTitle => ft?.scheduleReminderNotDisplayTitle ?? false;

  /// 城市名称
  bool get getSupportV3LongCityName => ft?.v3SupportV3LongCityName ?? false;

  /// 亮度设置支持夜间亮度等级设置
  bool get getSupportAddNightLevelV2 => ft?.v2SupportAddNightLevel ?? false;

  /// 固件支持使用表盘框架使用argb6666编码格式
  bool get getSupportDialFrameEncodeFormatArgb6666 => ft?.supportDialFrameEncodeFormatArgb6666 ?? false;

  /// 固件支持app下发手机操作系统信息
  bool get getSupportAppSendPhoneSystemInfo => ft?.supportAppSendPhoneSystemInfo ?? false;

  /// 固件管理切换快/慢速模式，APP不下发设置链接参数(快慢速）
  bool get getDeviceControlFastModeAlone => ft?.deviceControlFastModeAlone ?? false;

  /// 设备支持一键双连，区分配对时APP展示引导页还是直接下发配对指令
  bool get getSupportOnekeyDoubleContact => ft?.supportOnekeyDoubleContact ?? false;

  /// 语音助手状态
  bool get getSupportSetVoiceAssistantStatus => ft?.supportSetVoiceAssistantStatus ?? false;

  /// 支持获取flash log size
  bool get getSupportFlashLogSize => ft?.supportGetFlashLogSize ?? false;

  /// 支持获取单位
  bool get getSupportGetUnit => ft?.supportGetUnit ?? false;

  /// 通知支持Ryze Connect
  bool get getSupportRyzeConnect => ft?.supportRyzeConnect ?? false;

  /// 通知支持LOOPS FIT
  bool get getSupportLoopsFit => ft?.supportLoopsFit ?? false;

  /// 通知支持TAS Smart
  bool get getSupportTasSmart => ft?.supportTasSmart ?? false;

  /// 女性经期不支持设置排卵日提醒
  bool get getNotSupportSetOvulation => ft?.notSupportSetOvulation ?? false;

  /// 固件支持每小时目标步数设置和获取
  bool get getSupportWalkGoalSteps => ft?.supportWalkGoalSteps ?? false;

  /// GTX03/05定制，hamaAPP，功能表开启后，运动列表不支持增删，支持排序
  bool get getNotSupportDeleteAddSportSort => ft?.notSupportDeleteAddSportSort ?? false;

  /// 支持获取用户习惯信息(打点信息)中久坐提醒特性
  bool get getSupportSedentaryTensileHabitInfo => ft?.supportSedentaryTensileHabitInfo ?? false;

  /// 支持固件快速定位，APP下发GPS权限及经纬度给固件
  bool get getSupportSendGpsLongitudeAndLatitude => ft?.supportSendGpsLongitudeAndLatitude ?? false;

  /// 支持设备bt连接的手机型号
  bool get getSupportGetV3DeviceBtConnectPhoneModel => ft?.supportGetV3DeviceBtConnectPhoneModel ?? false;

  /// 支持血压模型文件更新
  bool get getSupportBloodPressureModelFileUpdate => ft?.supportBloodPressureModelFileUpdate ?? false;

  /// 勿扰支持事件范围开关和重复
  bool get getSupportDisturbHaveRangRepeat => ft?.disturbHaveRangRepeat ?? false;

  // ------------------ 设置 ------------------

  /// 设置获取消息应用状态使用version0x20版本下发
  bool get setNoticeMessageStateUseVersion0x20 => ft?.supportSetNoticeMessageStateUseVersion0x20 ?? false;

  /// 科学睡眠开关
  bool get setScientificSleepSwitch => ft?.v3SupportSetScientificSleepSwitch ?? false;

  /// 设置夜间体温开关
  bool get setTemperatureSwitchHealth => ft?.v3HealthSyncTemperature ?? false;

  /// 心率监测
  bool get setHeartRateMonitor => ft?.heartRateMonitor ?? false;

  /// 支持喝水提醒设置免提醒时间段
  bool get setNoReminderOnDrinkReminder => ft?.v2SupportSetNoReminderOnDrinkReminder ?? false;

  /// 默认是支持agps off升级
  bool get setAgpsOffLine => ft?.agpsOffline ?? false;

  /// 默认是支持agps online升级
  bool get setAgpsOnLine => ft?.agpsOnline ?? false;

  /// 设置v3心率的间隔
  bool get setSetV3HeartInterval => ft?.supportSetV3HeartInterval ?? false;

  /// 天气城市
  bool get setWeatherCity => ft?.weatherCity ?? false;

  /// 防打扰
  bool get setDoNotDisturb => ft?.doNotDisturb ?? false;

  /// 卡路里目标
  bool get setCalorieGoal => ft?.exMain3CalorieGoal ?? false;

  /// 女性生理周期
  bool get setMenstruation => ft?.exMain3Menstruation ?? false;

  /// 压力数据
  bool get setPressureData => ft?.exMain3V3Pressure ?? false;

  /// 血氧数据
  bool get setSpo2Data => ft?.exMain3V3Spo2Data ?? false;

  /// 运动模式排序
  bool get setSportModeSort => ft?.sportModeSort ?? false;

  /// 运动模式开关
  bool get setActivitySwitch => ft?.activitySwitch ?? false;

  /// 夜间自动亮度
  bool get setNightAutoBrightness => ft?.nightAutoBrightness ?? false;

  /// 5级亮度调节
  bool get setScreenBrightness5Level => ft?.screenBrightness5Level ?? false;

  /// 走动提醒
  bool get setWalkReminder => ft?.walkReminder ?? false;

  /// 3级亮度调节 默认是5级别，手表app显示，手表不显示
  bool get setScreenBrightness3Level => ft?.exTableMain8ScreenBrightness3Level ?? false;

  /// 洗手提醒
  bool get setHandWashReminder => ft?.exTableMain10SetHandWashingReminder ?? false;

  /// app支持本地表盘改 云端表盘图片下载
  bool get setLocalDial => ft?.exTableMain11SupportCloudDial ?? false;

  /// V3的心率过高不支持 | 配置了这个，app的UI心率过高告警不显示，
  /// 固件对应设置心率过高告警的不起作用
  bool get setNotSupportHrHighAlarm => ft?.exTableMain11NotSupportHeartRateHighAlarm ?? false;

  /// BIT1 k6项目不需要对应的壁纸表盘，veryFit默认的都是支持的，
  /// 新加一个不支持的功能表，不需要的配置这个
  bool get setNotSupportPhotoWallpaper => ft?.v3VeryfitNotSupportPhotoWallpaper ?? false;

  /// 压力过高提醒
  bool get setPressureHighReminder => ft?.exTableMain11PressureHighThresholdReminder ?? false;

  /// 壁纸表盘颜色设置
  bool get setWallpaperOnlyTimeColor => ft?.v2SupportWallpaperWatchFaceOnlyTimeColor ?? false;

  /// 壁纸表盘设置
  bool get setWallpaperDial => ft?.v3SetWallpaperDial ?? false;

  /// 呼吸训练
  bool get setSupportBreathRate => ft?.breatheTrain ?? false;

  /// 设置单位的增加卡路里设置
  bool get setSupportCalorieUnit => ft?.v3SupportCalorieUnit ?? false;

  /// 运动计划
  bool get setSupportSportPlan => ft?.v3SupportSportsPlan ?? false;

  /// 设置单位的增加泳池的单位设置
  bool get setSupportSwimPoolUnit => ft?.v3SupportSwimPoolUnit ?? false;

  /// v3 bp
  bool get setSupportV3Bp => ft?.v3SupportBpCalibration ?? false;

  /// app端用V3的获取运动排序协议中的最大最少默认字段， |
  /// gt01以前app都没有用到最大最少默认字段，
  /// 适配k6项目需要配置对应的数据字段，
  /// 添加功能表兼容
  bool get setV3GetSportSortField => ft?.v3SupportV3GetSportSortField ?? false;

  /// 表盘排序
  bool get setWatchDialSort => ft?.v3SetWatchDialSort ?? false;

  /// 运动三环目标获取
  bool get setGetCalorieDistanceGoal => ft?.v3GetCalorieDistanceGoal ?? false;

  /// 设置目标增加中高运动时长
  bool get setMidHighTimeGoal => ft?.v3SetMidHighTimeGoal ?? false;

  /// 固件支持解绑不清除设备上的数据
  bool get setNewRetainData => ft?.surpportNewRetainData ?? false;

  /// 日程提醒
  bool get setScheduleReminder => ft?.v3ScheduleReminder ?? false;

  /// 100种运动数据排序
  bool get setSet100SportSort => ft?.v3Set100SportSort ?? false;

  /// 20种基础运动数据子参数排序
  bool get setSet20SportParamSort => ft?.v3Set20BaseSportParamSort ?? false;

  /// 主界面ui控件排列
  bool get setSetMainUiSort => ft?.v3SetMainUiSort ?? false;

  /// 压力校准
  bool get setSetStressCalibration => ft?.v2SetStressCalibration ?? false;

  /// 支持app设置智能心率
  bool get setSmartHeartRate => ft?.v3SupportSetSmartHeartRate ?? false;

  /// 支持app设置全天的血氧开关数据
  bool get setSpo2AllDayOnOff => ft?.v3SupportSetSpo2AllDayOnOff ?? false;

  /// 支持app下发压缩的sbc语言文件给ble
  bool get setSupportAppSendVoiceToBle => ft?.v3SupportAppSendVoiceToBle ?? false;

  /// 设置单位的增加骑行的单位设置
  bool get setSupportCyclingUnit => ft?.v3SupportCyclingUnit ?? false;

  /// 设置单位的增加步行跑步的单位设置
  bool get setSupportWalkRunUnit => ft?.v3SupportWalkingRunningUnit ?? false;

  /// 设置走动提醒中的目标时间
  bool get setWalkReminderTimeGoal => ft?.v3SetWalkReminderGoalTime ?? false;

  /// 支持显示表盘容量
  bool get setWatchCapacitySizeDisplay => ft?.v3SupportWatchCapacitySizeDisplay ?? false;

  /// 支持壁纸表盘时间位置移动、控件图标颜色修改、控件功能选择
  bool get setWatchPhotoPositionMove => ft?.v3SupportWatchPhotoPositionMove ?? false;

  /// 菜单设置
  bool get setMenuListMain7 => ft?.exMain7MenuList ?? false;

  /// v3经期的历史数据下发
  bool get setHistoryMenstrual => ft?.v3V3333dHistoricalMenstruation01Create ?? false;

  /// v2经期提醒设置 增加易孕期和结束时间
  bool get setMenstrualAddPregnancy => ft?.v3V2MenstrualRemind02AddPregnancy ?? false;

  /// realme wear 定制需求 不支持显示来电"延时三秒"开关
  bool get setNotSurportCalling3SDelay => ft?.v2SurportCallingDelayThreeSeconds ?? false;

  /// 支持健身指导开关下发
  bool get setSetFitnessGuidance => ft?.supportSetFitnessGuidance ?? false;

  /// 通知设置
  bool get setSetNotificationStatus => ft?.v2SetNotificationStatus ?? false;

  /// 未读提醒
  bool get setSetUnreadAppReminder => ft?.v2SetUnreadAppReminder03Ea ?? false;

  /// 支持V3天气
  bool get setSetV3Weather => ft?.v3SupportSetV3Weather ?? false;

  /// 支持天气推送增加日落日出时间
  bool get setSetV3WeatherSunrise => ft?.v3SupportSetV3WeatcherAddSunrise ?? false;

  /// 支持世界时间设置
  bool get setSetV3WorldTime => ft?.v3SupportSetV3WorldTime ?? false;

  /// 支持联系人同步
  bool get setSyncContact => ft?.v3SupportSyncContact ?? false;

  /// 同步V3的多运动增加新的参数
  bool get setSyncV3ActivityAddParam => ft?.v3SyncV3ActivityAddParam ?? false;

  /// 音乐名称设置
  bool get setTransferMusicFile => ft?.v3SupportSetV3MusicName ?? false;

  /// 走动提醒增加通知类型
  bool get setWalkReminderAddNotify => ft?.v3WalkReminderAddNotifyFlag ?? false;

  /// 设置单位支持华氏度
  bool get setSupportFahrenheit => ft?.supportFahrenheit ?? false;

  /// 支持v3闹钟设置获取指定名称闹钟（KR01定制）
  bool get setGetAlarmSpecify => ft?.v3SetGetAlarmSpecifyType ?? false;

  /// 支持airoha芯片采gps数据功能表
  bool get setAirohaGpsChip => ft?.airohaGpsChip ?? false;

  /// 支持第二套运动图标功能表    目前仅idw05支持
  bool get setSupportSecondSportIcon => ft?.supportSecondSportIcon ?? false;

  /// 100种运动需要的中图功能表
  bool get setSportMediumIcon => ft?.v3SurportSportMediumIcon ?? false;

  /// 支持天气推送增加日落日出时间
  bool get setWeatherSunTime => ft?.v3SupportSetWeatherSunTime ?? false;

  /// 支持V3天气 下发空气质量等级
  bool get setWeatherAirGrade => ft?.v3SupportSetV3WeatcherAddAirGrade ?? false;

  /// 支持设置喝水提醒
  bool get setDrinkWaterReminder => ft?.exMain4DrinkWaterReminder ?? false;

  /// 呼吸率开关设置
  bool get setRespirationRate => ft?.v2V3SupportRespirationRate ?? false;

  /// 最大摄氧量
  bool get setMaxBloodOxygen => ft?.supportRecoverTimeAndVo2max ?? false;

  /// ble控制音乐
  bool get setBleControlMusic => ft?.bleControlMusic ?? false;

  /// v3压力功能表
  bool get setMainPressure => ft?.exMain3V3Pressure ?? false;

  /// 勿扰模式设置获取新增全天勿扰开关和智能开关
  bool get setNoDisturbAllDayOnOff => ft?.v2SupportDisturbThreeOnOff ?? false;

  /// 支持设置全天勿扰开关
  bool get setOnlyNoDisturbAllDayOnOff => ft?.supportV2DisturbAllDaySwitch ?? false;

  /// 支持设置智能勿扰开关
  bool get setOnlyNoDisturbSmartOnOff => ft?.supportV2DisturbSmartSwitch ?? false;

  /// 时区设定值为实际时区值的扩大100倍
  bool get setTimeZoneFloat => ft?.v2SupportSetTimeZoneFloat ?? false;

  /// 设定温度开关
  bool get setTemperatureSwitchSupport => ft?.v3SupportSetTemperatureSwitch ?? false;

  /// 支持设置获取消息应用总开关字段
  bool get setMsgAllSwitch => ft?.v2SupportSetGetMsgAllSwitch ?? false;

  /// 不支持支持来电提醒页面的“延迟三秒”开关设置项显示
  bool get setNotSupperCall3Delay => ft?.v2SurportCallingDelayThreeSeconds ?? false;

  /// 支持来电已拒
  bool get setNoticeMissedCallV2 => ft?.v2SetNoticeMissedCall ?? false;

  /// 结束查找手机
  bool get setOverFindPhone => ft?.supportOverFindPhone ?? false;

  /// 获取所有的健康监测开关
  bool get getHealthSwitchStateSupportV3 => ft?.v3SupportGetHealthSwitchState ?? false;

  /// 久坐提醒
  bool get setSedentariness => ft?.sedentariness ?? false;

  /// 设置屏幕亮度
  bool get setScreenBrightness => ft?.exScreenBrightness ?? false;

  /// 设置设备音乐音量
  bool get setSetPhoneVoice => ft?.exTableMain10SetPhoneVoice ?? false;

  /// 设置快捷来电回复开关
  bool get setSupportSetCallQuickReplyOnOff => ft?.supportSetCallQuickReplyOnOff ?? false;

  /// 支持多运动交互中下发GPS坐标
  bool get setSupportExchangeSetGpsCoordinates => ft?.supportActivityExchangeSetGpsCoordinates ?? false;

  /// 支持v3天气协议下发大气压强
  bool get setSupportV3WeatherAddAtmosphericPressure => ft?.supportSetV3WeatcherAddAtmosphericPressure ?? false;

  /// 支持v3天气协议下发积雪厚度
  bool get setSupportSetV3WeatcherAddSnowDepth => ft?.supportSetV3WeatcherAddSnowDepth ?? false;

  /// 支持v3天气协议下发降雪量
  bool get setSupportSetV3WeatcherAddSnowfall => ft?.supportSetV3WeatcherAddSnowfall ?? false;

  /// 支持v3天气协议下发协议版本0x4版本
  bool get setSupportSetV3WeatcherSendStructVersion04 => ft?.supportSetV3WeatcherSendStructVersion04 ?? false;

  /// 支持设置压力校准阈
  bool get setSendCalibrationThreshold => ft?.v2SendCalibrationThreshold ?? false;

  /// 支持屏蔽跑步计划入口
  bool get getNotSupportAppSendRunPlan => ft?.notSupportAppSendRunPlan ?? false;

  // ------------------ 语言 ------------------

  /// 中文
  bool get languageCh => ft?.langCh ?? false;

  /// 捷克文
  bool get languageCzech => ft?.langCzech ?? false;

  /// 英文
  bool get languageEnglish => ft?.langEng ?? false;

  /// 法文
  bool get languageFrench => ft?.langFrench ?? false;

  /// 德文
  bool get languageGerman => ft?.langGerman ?? false;

  /// 意大利文
  bool get languageItalian => ft?.langItalian ?? false;

  /// 日文
  bool get languageJapanese => ft?.langJapanese ?? false;

  /// 西班牙文
  bool get languageSpanish => ft?.langSpanish ?? false;

  /// 阿拉伯语
  bool get languageArabic => ft?.exLang3Arabic ?? false;

  /// 缅甸语
  bool get languageBurmese => ft?.exLang3Burmese ?? false;

  /// 菲律宾语
  bool get languageFilipino => ft?.exLang3Filipino ?? false;

  /// 希腊语
  bool get languageGreek => ft?.exLang3Greek ?? false;

  /// 泰国语
  bool get languageThai => ft?.exLang3Thai ?? false;

  /// 繁体中文
  bool get languageTraditionalChinese => ft?.exLang3TraditionalChinese ?? false;

  /// 越南语
  bool get languageVietnamese => ft?.exLang3Vietnamese ?? false;

  /// 荷兰文
  bool get languageDutch => ft?.exLangDutch ?? false;

  /// 匈牙利文
  bool get languageHungarian => ft?.exLangHungarian ?? false;

  /// 立陶宛文
  bool get languageLithuanian => ft?.exLangLithuanian ?? false;

  /// 波兰文
  bool get languagePolish => ft?.exLangPolish ?? false;

  /// 罗马尼亚文
  bool get languageRomanian => ft?.exLangRomanian ?? false;

  /// 俄罗斯文
  bool get languageRussian => ft?.exLangRussian ?? false;

  /// 斯洛文尼亚文
  bool get languageSlovenian => ft?.exLangSlovenian ?? false;

  /// 乌克兰文
  bool get languageUkrainian => ft?.exLangUkrainian ?? false;

  /// 克罗地亚语
  bool get languageCroatian => ft?.exLang2Croatian ?? false;

  /// 丹麦语
  bool get languageDanish => ft?.exLang1Danish ?? false;

  /// 印地语
  bool get languageHindi => ft?.exLang2Hindi ?? false;

  /// 印尼语
  bool get languageIndonesian => ft?.exLang2Indonesian ?? false;

  /// 韩语
  bool get languageKorean => ft?.exLang2Korean ?? false;

  /// 葡萄牙语
  bool get languagePortuguese => ft?.exLang2Portuguese ?? false;

  /// 斯洛伐克语
  bool get languageSlovak => ft?.exLang1Slovak ?? false;

  /// 土耳其
  bool get languageTurkish => ft?.exLang2Turkish ?? false;

  /// 波斯语
  bool get languagePersia => ft?.langPersia ?? false;

  /// 瑞典语
  bool get languageSweden => ft?.exLang3Sweden ?? false;

  /// 挪威语
  bool get languageNorwegian => ft?.langNorwegian ?? false;

  /// 芬兰语
  bool get languageFinland => ft?.langFinland ?? false;

  ///孟加拉语
  bool get languageBengali => ft?.langBengali ?? false;

  ///高棉语
  bool get languageKhmer => ft?.langKhmer ?? false;

  ///马来语
  bool get languageMalay => ft?.langMalay ?? false;

  ///巴西葡语
  bool get languageBrazilianPortuguese => ft?.langBrazilianPortuguese ?? false;
// ------------------ 同步 ------------------

  /// v3 心率
  bool get syncV3Hr => ft?.exMain4V3HrData ?? false;

  /// v3 游泳
  bool get syncV3Swim => ft?.exMain4V3Swim ?? false;

  /// v3 血氧
  bool get syncV3Spo2 => ft?.exMain3V3Spo2Data ?? false;

  /// v3 压力
  bool get syncV3Pressure => ft?.exMain3V3Pressure ?? false;

  /// v3 多运动
  bool get syncV3Activity => ft?.exMain4V3ActivityData ?? false;

  /// v3 睡眠
  bool get syncV3Sleep => ft?.exTableMain8V3Sleep ?? false;

  /// v3 步数
  bool get syncV3Sports => ft?.exTableMain9V3Sports ?? false;

  /// v3 gps
  bool get syncV3Gps => ft?.exMain4V3GpsDataData ?? false;

  /// v3 闹钟
  bool get syncV3SyncAlarm => ft?.exTableMain8V3SyncAlarm ?? false;

  /// v3 身体电量
  bool get syncV3BodyPower => ft?.v3BodyPower ?? false;

  /// 同步hrv
  bool get getSupportHrvV3 => ft?.v3SupportHrv ?? false;

  /// 同步血压
  bool get getSupportPerBpV3 => ft?.v3SupportPerBp ?? false;

  /// 同步噪音
  bool get syncV3Noise => ft?.v3HealthSyncNoise ?? false;

  /// 同步温度
  bool get syncV3Temperature => ft?.v3HealthSyncTemperature ?? false;

  /// gps
  bool get syncGps => ft?.exGps ?? false;

  /// v3多运动同步数据交换
  bool get syncV3ActivityExchangeData => ft?.exTableMain9V3ActivityExchangeData ?? false;

  /// 心率功能
  bool get syncHeartRate => ft?.heartRate ?? false;

  /// 心率监测
  bool get syncHeartRateMonitor => ft?.heartRateMonitor ?? false;

  /// 睡眠检测
  bool get syncSleepMonitor => ft?.sleepMonitor ?? false;

  /// 快速同步
  bool get syncFastSync => ft?.fastSync ?? false;

  /// 获取时间同步
  bool get syncActivityTimeSync => ft?.exActivityTimeSync ?? false;

  /// v2同步 时间线
  bool get syncTimeLine => ft?.timeLine ?? false;

  /// 需要V2的同步
  bool get syncNeedV2 => ft?.isNeedSyncV2 ?? false;

  /// v3多运动同步支持实时速度显示
  bool get syncRealTimeV3 => ft?.v3SupportActivitySyncRealTime ?? false;

  /// 数据交换增加实时的配速字段
  bool get syncExchangeDataReplyAddRealTimeSpeedPaceV3 => ft?.v3SupportV3ExchangeDataReplyAddRealTimeSpeedPace ?? false;

  /// 多运行结束时间使用UTC模式
  bool get syncHealthSyncV3ActivityEndTimeUseUtcMode => ft?.healthSyncV3ActivityEndTimeUseUtcMode ?? false;

  /// 支持数据同步时开启快速模式
  bool get syncSupportSetFastModeWhenSyncConfig => ft?.supportSetFastModeWhenSyncConfig ?? false;

// ------------------ 闹钟 ------------------

  /// 闹钟个数
  int get alarmCount => ft?.alarmCount ?? 0;

  /// 刷牙
  bool get alarmBrushTeeth => ft?.alarmBrushTeeth ?? false;

  /// 约会
  bool get alarmDating => ft?.alarmDating ?? false;

  /// 吃饭
  bool get alarmDinner => ft?.alarmDinner ?? false;

  /// 吃药
  bool get alarmMedicine => ft?.alarmMedicine ?? false;

  /// 会议
  bool get alarmMeeting => ft?.alarmMetting ?? false;

  /// 聚会
  bool get alarmParty => ft?.alarmParty ?? false;

  /// 休息
  bool get alarmRest => ft?.alarmRest ?? false;

  /// 睡觉
  bool get alarmSleep => ft?.alarmSleep ?? false;

  /// 锻炼
  bool get alarmSport => ft?.alarmSport ?? false;

  /// 起床
  bool get alarmWakeUp => ft?.alarmWakeUp ?? false;

  /// 支持设置防丢
  bool get supportSetAntilost => ft?.antilost ?? false;

  /// 支持设置v2天气数据
  bool get supportSetWeatherDataV2 => ft?.weather ?? false;

  /// 支持设置一键呼叫
  bool get supportSetOnetouchCalling => ft?.onetouchCalling ?? false;

  // ------------------ Alexa ------------------

  /// alexa 语音提醒增加对应的时钟传输字段
  bool get alexaReminderAddSecV3 => ft?.v3AlexaReminderAddSec ?? false;

  /// alexa 简单控制命令
  bool get alexaSetEasyOperateV3 => ft?.v3AlexaSetEasyOperate ?? false;

  /// alexa 语音闹钟获取设置命令使用
  bool get alexaSetGetAlexaAlarmV3 => ft?.v3AlexaSetGetAlexaAlarm ?? false;

  /// alexa 设置跳转运动界面
  bool get alexaSetJumpSportUiV3 => ft?.v3AlexaSetJumpSportUi ?? false;

  /// alexa 设置跳转ui界面
  bool get alexaSetJumpUiV3 => ft?.v3AlexaSetJumpUi ?? false;

  /// alexa app设置开关命令
  bool get alexaSetSetOnOffTypeV3 => ft?.v3AlexaSetSetOnOffType ?? false;

  /// alexa 语音支持设置天气
  bool get alexaSetWeatherV3 => ft?.v3AlexaSetWeather ?? false;

  /// alexa 支持设置多个定时器
  bool get alexaTimeNewV3 => ft?.v3AlexaTimeNew ?? false;

  /// alexa 100级亮度控制
  bool get setAlexaControll100brightness => ft?.v2SetAlexaOperation100brightness ?? false;

  /// alexa 获取alexa默认语言
  bool get alexaGetSupportGetAlexaDefaultLanguage => ft?.v3SupportGetAlexaDefaultLanguage ?? false;

  /// alexa跳转运动界面支持100种运动类型字段
  bool get alexaGetUIControllSports => ft?.uiControllSports ?? false;

  FunctionTableModel? _ftModel;

  /// 内部使用
  FunctionTableModel? get ft => _ftModel;

  /// 内部使用
  void initFunTableModel(FunctionTableModel model) {
    _ftModel = model;
  }
}

class IDOFunctionTable extends BaseFunctionTable {
  static final _instance = IDOFunctionTable._internal();

  factory IDOFunctionTable() => _instance;

  IDOFunctionTable._internal();

  late final _libMgr = IDOProtocolLibManager();

  late final _subjectFtChanged = StreamController<int>.broadcast();
  FunctionTableModel? _ft;

  @override
  FunctionTableModel? get ft => _ft;

  /// 刷新功能表（SDK内部使用）
  Future<IDOFunctionTable?> refreshFuncTable({bool forced = true}) async {
    if (!_libMgr.isConnected) {
      logger?.e('Unconnected calls are not supported');
      throw UnsupportedError('Unconnected calls are not supported');
    }

    // 泰凌微OTA不需要存储设备信息
    final notTelink = _libMgr.otaType != IDOOtaType.telink;
    forced = forced || !notTelink;

    _ft = await storage?.loadFunctionTableByDisk();
    _subjectFtChanged.add(0);
    //logger?.d('functionTable offline：${_ft?.toJson().toString()}');
    logger?.d('functionTable offline：${_ft?.toJson().values.length}');
    if (!forced) {
      return Future(() => this);
    }

    return _libMgr.send(evt: CmdEvtType.getFuncTable).map((event) {
      if (event.code == 0 && event.json != null) {
        //logger?.d('functionTable online：${event.json}');
        final map = jsonDecode(event.json!);
        _ft = FunctionTableModel.fromJson(map);
        _subjectFtChanged.add(0);
        logger?.d('functionTable online：${_ft?.toJson().values.length}');
        if (notTelink) {
          storage?.saveFunctionTableToDisk(_ft!);
        }
        statusNotification
            ?.add(IDOStatusNotification.functionTableUpdateCompleted);
        return this;
      }
      return null;
    }).first;
  }

  /// 清理数据 (SDK内部使用)
  void cleanDataOnMemory() {
    _ft = null;
    _subjectFtChanged.add(0);
  }

  /// 导出功能表 返回json文件绝对路径
  Future<String?> exportFuncTableFile() async {
    var dir = await storage?.pathRoot();
    if (dir != null && _ft != null) {
      final jsonFile = '$dir/func_table.json';
      final jsonStr = jsonEncode(_ft!.toJson());
      final file = await File(jsonFile).writeAsString(jsonStr);
      return Future(() => file.existsSync() ? jsonFile : null);
    }
    return Future(() => null);
  }

  /// 功能表变更  (SDK内部使用)
  StreamSubscription onFunctionTableChanged(void Function(int) func) {
    return _subjectFtChanged.stream.listen(func);
  }
}