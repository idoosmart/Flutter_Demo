//
//  IDOFuncTableInterface.swift
//  alexa_channel
//
//  Created by hc on 2023/11/2.
//

import Foundation

/// 功能表
@objc
public protocol IDOFuncTableInterface {
    /// 智能通知
    var reminderAncs: Bool { get }
    /// Snapchat
    var reminderSnapchat: Bool { get }
    /// Line
    var reminderLine: Bool { get }
    /// Outlook
    var reminderOutlook: Bool { get }
    /// Telegram
    var reminderTelegram: Bool { get }
    /// Viber
    var reminderViber: Bool { get }
    /// Vkontakte
    var reminderVkontakte: Bool { get }
    /// Chatwork;
    var reminderChatwork: Bool { get }
    /// Slack
    var reminderSlack: Bool { get }
    /// Tumblr
    var reminderTumblr: Bool { get }
    /// YahooMail
    var reminderYahooMail: Bool { get }
    /// YahooPinterest
    var reminderYahooPinterest: Bool { get }
    /// Youtube
    var reminderYoutube: Bool { get }
    /// Gmail
    var reminderGmail: Bool { get }
    /// KakaoTalk
    var reminderKakaoTalk: Bool { get }
    /// Google gmail
    var reminderOnlyGoogleGmail: Bool { get }
    /// Outlook email
    var reminderOnlyOutlookEmail: Bool { get }
    /// Yahoo email
    var reminderOnlyYahooEmail: Bool { get }
    /// Tiktok
    var reminderTiktok: Bool { get }
    /// Redbus
    var reminderRedbus: Bool { get }
    /// Dailyhunt
    var reminderDailyhunt: Bool { get }
    /// Hotstar
    var reminderHotstar: Bool { get }
    /// Inshorts
    var reminderInshorts: Bool { get }
    /// Paytm
    var reminderPaytm: Bool { get }
    /// Amazon
    var reminderAmazon: Bool { get }
    /// Flipkart
    var reminderFlipkart: Bool { get }
    /// Nhn email
    var reminderNhnEmail: Bool { get }
    /// Instant email
    var reminderInstantEmail: Bool { get }
    /// Zoho email
    var reminderZohoEmail: Bool { get }
    /// Exchange email
    var reminderExchangeEmail: Bool { get }
    /// 189 email
    var reminder189Email: Bool { get }
    /// Very fit
    var reminderVeryFit: Bool { get }
    /// General
    var reminderGeneral: Bool { get }
    /// other
    var reminderOther: Bool { get }
    /// Matters
    var reminderMattersRemind: Bool { get }
    /// Microsoft
    var reminderMicrosoft: Bool { get }
    /// MissedCalls
    var reminderMissedCall: Bool { get }
    /// 支持同步全部通讯录
    var reminderGetAllContact: Bool { get }
    /// WhatsappBusiness
    var reminderWhatsappBusiness: Bool { get }
    /// Email
    var reminderEmail: Bool { get }
    /// Facebook
    var reminderFacebook: Bool { get }
    /// Message
    var reminderMessage: Bool { get }
    /// QQ
    var reminderQq: Bool { get }
    /// Twitter
    var reminderTwitter: Bool { get }
    /// Weixin
    var reminderWeixin: Bool { get }
    /// Calendar (Google日历）
    var reminderCalendarGoogle: Bool { get }
    /// Instagram
    var reminderInstagram: Bool { get }
    /// linkedIn
    var reminderLinkedIn: Bool { get }
    /// Messengre
    var reminderMessengre: Bool { get }
    /// Skype
    var reminderSkype: Bool { get }
    /// Calendar
    var reminderCalendar: Bool { get }
    /// Whatsapp
    var reminderWhatsapp: Bool { get }
    /// Alarm clock
    var reminderAlarmClock: Bool { get }
    /// 新浪微博
    var reminderSinaWeibo: Bool { get }
    /// 国内版微博
    var reminderWeibo: Bool { get }
    /// 来电提醒
    var reminderCalling: Bool { get }
    /// 来电联系人
    var reminderCallContact: Bool { get }
    /// 来电号码
    var reminderCallNum: Bool { get }
    /// Prime
    var reminderPrime: Bool { get }
    /// Netflix
    var reminderNetflix: Bool { get }
    /// Gpay
    var reminderGpay: Bool { get }
    /// Phonpe
    var reminderPhonpe: Bool { get }
    /// Swiggy
    var reminderSwiggy: Bool { get }
    /// Zomato
    var reminderZomato: Bool { get }
    /// Makemytrip
    var reminderMakemytrip: Bool { get }
    /// JioTv
    var reminderJioTv: Bool { get }
    /// Niosefit
    var reminderNiosefit: Bool { get }
    /// YT music
    var reminderYtmusic: Bool { get }
    /// Uber
    var reminderUber: Bool { get }
    /// Ola
    var reminderOla: Bool { get }
    /// Google meet
    var reminderGoogleMeet: Bool { get }
    /// Mormaii Smartwatch
    var reminderMormaiiSmartwatch: Bool { get }
    /// Technos connect
    var reminderTechnosConnect: Bool { get }
    /// Enjoei
    var reminderEnjoei: Bool { get }
    /// Aliexpress
    var reminderAliexpress: Bool { get }
    /// Shopee
    var reminderShopee: Bool { get }
    /// Teams
    var reminderTeams: Bool { get }
    /// 99 taxi
    var reminder99Taxi: Bool { get }
    /// Uber eats
    var reminderUberEats: Bool { get }
    /// Lfood
    var reminderLfood: Bool { get }
    /// Rappi
    var reminderRappi: Bool { get }
    /// Mercado livre
    var reminderMercadoLivre: Bool { get }
    /// Magalu
    var reminderMagalu: Bool { get }
    /// Americanas
    var reminderAmericanas: Bool { get }
    /// Yahoo
    var reminderYahoo: Bool { get }
    /// 消息图标和名字更新
    var reminderMessageIcon: Bool { get }
    /// 淘宝
    var reminderTaobao: Bool { get }
    /// 钉钉
    var reminderDingding: Bool { get }
    /// 支付宝
    var reminderAlipay: Bool { get }
    /// 今日头条
    var reminderToutiao: Bool { get }
    /// 抖音
    var reminderDouyin: Bool { get }
    /// 天猫
    var reminderTmall: Bool { get }
    /// 京东
    var reminderJd: Bool { get }
    /// 拼多多
    var reminderPinduoduo: Bool { get }
    /// 百度
    var reminderBaidu: Bool { get }
    /// 美团
    var reminderMeituan: Bool { get }
    /// 饿了么
    var reminderEleme: Bool { get }
    /// v2 走路
    var sportWalk: Bool { get }
    /// v2 跑步
    var sportRun: Bool { get }
    /// v2 骑行
    var sportByBike: Bool { get }
    /// v2 徒步
    var sportOnFoot: Bool { get }
    /// v2 游泳
    var sportSwim: Bool { get }
    /// v2 爬山
    var sportMountainClimbing: Bool { get }
    /// v2 羽毛球
    var sportBadminton: Bool { get }
    /// v2 其他
    var sportOther: Bool { get }
    /// v2 健身
    var sportFitness: Bool { get }
    /// v2 动感单车
    var sportSpinning: Bool { get }
    /// v2 椭圆球
    var sportEllipsoid: Bool { get }
    /// v2 跑步机
    var sportTreadmill: Bool { get }
    /// v2 仰卧起坐
    var sportSitUp: Bool { get }
    /// v2 俯卧撑
    var sportPushUp: Bool { get }
    /// v2 哑铃
    var sportDumbbell: Bool { get }
    /// v2 举重
    var sportWeightlifting: Bool { get }
    /// v2 健身操
    var sportBodybuildingExercise: Bool { get }
    /// v2 瑜伽
    var sportYoga: Bool { get }
    /// v2 跳绳
    var sportRopeSkipping: Bool { get }
    /// v2 乒乓球
    var sportTableTennis: Bool { get }
    /// v2 篮球
    var sportBasketball: Bool { get }
    /// v2 足球
    var sportFootballl: Bool { get }
    /// v2 排球
    var sportVolleyball: Bool { get }
    /// v2 网球
    var sportTennis: Bool { get }
    /// v2 高尔夫
    var sportGolf: Bool { get }
    /// v2 棒球
    var sportBaseball: Bool { get }
    /// v2 滑雪
    var sportSkiing: Bool { get }
    /// v2 轮滑
    var sportRollerSkating: Bool { get }
    /// v2 跳舞
    var sportDance: Bool { get }
    /// v2 功能性训练
    var sportStrengthTraining: Bool { get }
    /// v2 核心训练
    var sportCoreTraining: Bool { get }
    /// v2 整体放松
    var sportTidyUpRelax: Bool { get }
    /// v2 传统的力量训练
    var sportTraditionalStrengthTraining: Bool { get }
    /// v3 户外跑步
    var sportOutdoorRun: Bool { get }
    /// v3 室内跑步
    var sportIndoorRun: Bool { get }
    /// v3 户外骑行
    var sportOutdoorCycle: Bool { get }
    /// v3 室内骑行
    var sportIndoorCycle: Bool { get }
    /// v3 户外走路
    var sportOutdoorWalk: Bool { get }
    /// v3 室内走路
    var sportIndoorWalk: Bool { get }
    /// v3 泳池游泳
    var sportPoolSwim: Bool { get }
    /// v3 开放水域游泳
    var sportOpenWaterSwim: Bool { get }
    /// v3 椭圆机
    var sportElliptical: Bool { get }
    /// v3 划船机
    var sportRower: Bool { get }
    /// v3 高强度间歇训练法
    var sportHiit: Bool { get }
    /// v3 板球运动
    var sportCricket: Bool { get }
    /// v3 普拉提
    var sportPilates: Bool { get }
    /// v3 户外玩耍（定制 kr01）
    var sportOutdoorFun: Bool { get }
    /// v3 其他运动（定制 kr01）
    var sportOtherActivity: Bool { get }
    /// v3 尊巴舞
    var sportZumba: Bool { get }
    /// v3 冲浪
    var sportSurfing: Bool { get }
    /// v3 足排球
    var sportFootvolley: Bool { get }
    /// v3 站立滑水
    var sportStandWaterSkiing: Bool { get }
    /// v3 站绳
    var sportBattlingRope: Bool { get }
    /// v3 滑板
    var sportSkateboard: Bool { get }
    /// v3 踏步机
    var sportNoticeStepper: Bool { get }
    /// 运动显示个数
    var sportShowNum: Int { get }
    /// 有氧健身操
    var sportAerobicsBodybuildingExercise: Bool { get }
    /// 引体向上
    var sportPullUp: Bool { get }
    /// 单杠
    var sportHighBar: Bool { get }
    /// 双杠
    var sportParallelBars: Bool { get }
    /// 越野跑
    var sportTrailRunning: Bool { get }
    /// 匹克球
    var sportPickleBall: Bool { get }
    /// 滑板
    var sportSnowboard: Bool { get }
    /// 越野滑板
    var sportCrossCountrySkiing: Bool { get }
    /// 获取实时数据
    var getRealtimeData: Bool { get }
    /// 获取v3语言库
    var getLangLibraryV3: Bool { get }
    /// 查找手机
    var getFindPhone: Bool { get }
    /// 查找设备
    var getFindDevice: Bool { get }
    /// 抬腕亮屏数据获取
    var getUpHandGestureEx: Bool { get }
    /// 抬腕亮屏
    var getUpHandGesture: Bool { get }
    /// 天气预报
    var getWeather: Bool { get }
    /// 可下载语言
    var getDownloadLanguage: Bool { get }
    /// 恢复出厂设置
    var getFactoryReset: Bool { get }
    /// Flash log
    var getFlashLog: Bool { get }
    /// 多运动不能使用app
    var getMultiActivityNoUseApp: Bool { get }
    /// 多表盘
    var getMultiDial: Bool { get }
    /// 获取菜单列表
    var getMenuList: Bool { get }
    /// 请勿打扰
    var getDoNotDisturbMain3: Bool { get }
    /// 语音功能
    var getVoiceTransmission: Bool { get }
    /// 设置喝水开关通知类型
    var setDrinkWaterAddNotifyFlag: Bool { get }
    /// 血氧过低提醒通知提醒类型
    var setSpo2LowValueRemindAddNotifyFlag: Bool { get }
    /// 智能心率提醒通知提醒类型
    var notSupportSmartHeartNotifyFlag: Bool { get }
    /// 获取重启日志错误码和标志位
    var getDeviceLogState: Bool { get }
    /// 支持获取表盘列表的接口
    var getNewWatchList: Bool { get }
    /// 消息提醒图标自适应
    var getNotifyIconAdaptive: Bool { get }
    /// 压力开关增加通知类型和全天压力模式设置
    var getPressureNotifyFlagMode: Bool { get }
    /// 科学睡眠
    var getScientificSleep: Bool { get }
    /// 血氧开关增加通知类型
    var getSpo2NotifyFlag: Bool { get }
    /// v3 收集log
    var getV3Log: Bool { get }
    /// 获取表盘ID
    var getWatchID: Bool { get }
    /// 获取设备名称
    var getDeviceName: Bool { get }
    /// 获取电池日志
    var getBatteryLog: Bool { get }
    /// 获取电池信息
    var getBatteryInfo: Bool { get }
    /// 获取过热日志
    var getHeatLog: Bool { get }
    /// 获取走动提醒 v3
    var getWalkReminderV3: Bool { get }
    /// 获取支持蓝牙音乐 v3
    var getSupportV3BleMusic: Bool { get }
    /// 支持获取固件本地提示音文件信息
    var getSupportGetBleBeepV3: Bool { get }
    /// BIT1 k6项目不需要对应的壁纸表盘，veryFit默认的都是支持的，新加一个不支持的功能表，不需要的配置这个
    var getVeryFitNotSupportPhotoWallpaperV3: Bool { get }
    /// 支持升级gps固件
    var getSupportUpdateGps: Bool { get }
    /// 支持ublox模块
    var getUbloxModel: Bool { get }
    /// 支持获取固件歌曲名和文件夹指令下发和固件回复使用协议版本号0x10
    var getSupportGetBleMusicInfoVerV3: Bool { get }
    /// 获得固件三级版本和BT的三级版本
    var getBtVersion: Bool { get }
    /// V3的运动类型设置和获取
    var getSportsTypeV3: Bool { get }
    /// 支持运动模式识别开关获取
    var getActivitySwitch: Bool { get }
    /// 支持动态消息图标更新
    var getNoticeIconInformation: Bool { get }
    /// 支持获取固件支持app下发的详情的最大数量
    var getSetMaxItemsNum: Bool { get }
    /// v3 消息提醒
    var getNotifyMsgV3: Bool { get }
    /// 获取屏幕亮度
    var getScreenBrightnessMain9: Bool { get }
    /// 128个字节通知
    var getNotice128byte: Bool { get }
    /// 250个字节通知
    var getNotice250byte: Bool { get }
    /// 支持获取不可删除的快捷应用列表
    var getDeletableMenuListV2: Bool { get }
    /// 设置支持系统配对
    var getSupportPairEachConnect: Bool { get }
    /// 支持获取运动目标
    var getSupportGetMainSportGoalV3: Bool { get }
    /// 取bt蓝牙MAC地址
    var getBtAddrV2: Bool { get }
    /// 血压校准与测量
    var getSupportBpSetOrMeasurementV2: Bool { get }
    /// 生理周期开关增加通知类型
    var getMenstrualAddNotifyFlagV3: Bool { get }
    /// 设置获取运动三环周目标
    var getSupportSetGetTimeGoalTypeV2: Bool { get }
    /// 多运动同步数据支持摄氧量等级数据
    var getOxygenDataSupportGradeV3: Bool { get }
    /// 多运动数据同步支持海拔高度数据
    var getSupportSyncActivityDataAltitudeInfo: Bool { get }
    /// 绑定授权码
    var getBindCodeAuth: Bool { get }
    /// V3血氧数据 偏移按照分钟偏移
    var getSpo2OffChangeV3: Bool { get }
    /// 5级心率区间
    var getLevel5HrInterval: Bool { get }
    /// 5个心率区间
    var getFiveHRInterval: Bool { get }
    /// 获得固件三级版本和BT的3级版本
    var getBleAndBtVersion: Bool { get }
    /// 紧急联系人
    var getSupportSetGetEmergencyContactV3: Bool { get }
    /// 重复提醒类型设置星期重复
    var getSupportSetRepeatWeekTypeOnScheduleReminderV3: Bool { get }
    /// 重复提醒类型设置
    var getSupportSetRepeatTypeOnScheduleReminderV3: Bool { get }
    /// 经期开关
    var getSupportSetMenstrualReminderOnOff: Bool { get }
    /// 版本信息
    var getVersionInfo: Bool { get }
    /// 获取MTU
    var getMtu: Bool { get }
    /// 获取手环的升级状态
    var getDeviceUpdateState: Bool { get }
    /// v2获取心率监测模式
    var getHeartRateModeV2: Bool { get }
    /// 目标步数类型为周目标
    var getStepDataTypeV2: Bool { get }
    /// 快速消息
    var getFastMsgDataV3: Bool { get }
    /// 支持快速回复
    var getSupportCallingQuickReply: Bool { get }
    /// 新错误码 v3
    var getSupportDataTranGetNewErrorCodeV3: Bool { get }
    /// 运动自识别结束开关不展示，设置开关状态
    var getAutoActivityEndSwitchNotDisplay: Bool { get }
    /// 运动自识别暂停开关不展示，设置开关状态
    var getAutoActivityPauseSwitchNotDisplay: Bool { get }
    /// 运动模式自动识别开关设置获取 新增类型椭圆机 划船机 游泳
    var getV3AutoActivitySwitch: Bool { get }
    /// 运动模式自动识别开关设置获取 新增类型骑行
    var getAutoActivitySwitchAddBicycle: Bool { get }
    /// 运动模式自动识别开关设置获取 新增类型智能跳绳
    var getAutoActivitySwitchAddSmartRope: Bool { get }
    /// 运动自识别获取和设置指令使用新的版本与固件交互
    var getAutoActivitySetGetUseNewStructExchange: Bool { get }
    /// 支持走动提醒设置/获取免提醒时间段
    var getSupportSetGetNoReminderOnWalkReminderV2: Bool { get }
    /// 支持获取sn信息
    var getSupportGetSnInfo: Bool { get }
    /// 日程提醒不显示标题
    var getScheduleReminderNotDisplayTitle: Bool { get }
    /// 城市名称
    var getSupportV3LongCityName: Bool { get }
    /// 亮度设置支持夜间亮度等级设置
    var getSupportAddNightLevelV2: Bool { get }
    /// 固件支持使用表盘框架使用argb6666编码格式
    var getSupportDialFrameEncodeFormatArgb6666: Bool { get }
    /// 固件支持app下发手机操作系统信息
    var getSupportAppSendPhoneSystemInfo: Bool { get }
    /// 固件管理切换快/慢速模式，APP不下发设置链接参数(快慢速）
    var getDeviceControlFastModeAlone: Bool { get }
    /// 设备支持一键双连，区分配对时APP展示引导页还是直接下发配对指令
    var getSupportOnekeyDoubleContact: Bool { get }
    /// 语音助手状态
    var getSupportSetVoiceAssistantStatus: Bool { get }
    /// 支持获取flash log size
    var getSupportFlashLogSize: Bool { get }
    /// 设备是否支持返回正在测量的值
    var supportDevReturnMeasuringValue: Bool { get }
    /// 支持获取单位
    var getSupportGetUnit: Bool { get }
    /// 通知支持Ryze Connect
    var getSupportRyzeConnect: Bool { get }
    /// 通知支持LOOPS FIT
    var getSupportLoopsFit: Bool { get }
    /// 通知支持TAS Smart
    var getSupportTasSmart: Bool { get }
    /// 女性经期不支持设置排卵日提醒
    var getNotSupportSetOvulation: Bool { get }
    /// 固件支持每小时目标步数设置和获取
    var getSupportWalkGoalSteps: Bool { get }
    /// GTX03/05定制，hamaAPP，功能表开启后，运动列表不支持增删，支持排序
    var getNotSupportDeleteAddSportSort: Bool { get }
    /// 支持获取用户习惯信息(打点信息)中久坐提醒特性
    var getSupportSedentaryTensileHabitInfo: Bool { get }
    /// 支持固件快速定位，APP下发GPS权限及经纬度给固件
    var getSupportSendGpsLongitudeAndLatitude: Bool { get }
    /// 支持设备bt连接的手机型号
    var getSupportGetV3DeviceBtConnectPhoneModel: Bool { get }
    /// 支持血压模型文件更新
    var getSupportBloodPressureModelFileUpdate: Bool { get }
    /// 勿扰支持事件范围开关和重复
    var getSupportDisturbHaveRangRepeat: Bool { get }
    /// 日历提醒
    var getSupportCalendarReminder: Bool { get }
    /// 表盘传输需要对应的传输原始的没有压缩的大小给固件,增加字段watch_file_size
    var getWatchDailSetAddSize: Bool { get }
    /// 支持同步过高过低时心率数据
    var getSupportSyncOverHighLowHeartData: Bool { get }
    /// 间隔一分钟同步新增（206设备）
    var getSupportPerMinuteOne: Bool { get }
    /// 支持全天步数目标达成提醒开关
    var getSupportAchievedRemindOnOff: Bool { get }
    /// 支持喝水计划
    var getSupportDrinkPlan: Bool { get }
    /// 支持表盘包打包jpg图片
    var getSupportMakeWatchDialDecodeJpg: Bool { get }
    /// 支持睡眠计划
    var getSupportSleepPlan: Bool { get }
    /// 支持获取设备算法文件
    var getSupportDeviceOperateAlgFile: Bool { get }
    /// 支持获取运动记录的显示项配置
    var getSupportSportRecordShowConfig: Bool { get }
    /// 设置获取消息应用状态使用version0x20版本下发
    var setNoticeMessageStateUseVersion0x20: Bool { get }
    /// 科学睡眠开关
    var setScientificSleepSwitch: Bool { get }
    /// 设置夜间体温开关
    var setTemperatureSwitchHealth: Bool { get }
    /// 心率监测
    var setHeartRateMonitor: Bool { get }
    /// 支持喝水提醒设置免提醒时间段
    var setNoReminderOnDrinkReminder: Bool { get }
    /// 默认是支持agps off升级
    var setAgpsOffLine: Bool { get }
    /// 默认是支持agps online升级
    var setAgpsOnLine: Bool { get }
    /// 设置v3心率的间隔
    var setSetV3HeartInterval: Bool { get }
    /// 天气城市
    var setWeatherCity: Bool { get }
    /// 防打扰
    var setDoNotDisturb: Bool { get }
    /// 卡路里目标
    var setCalorieGoal: Bool { get }
    /// 女性生理周期
    var setMenstruation: Bool { get }
    /// 压力数据
    var setPressureData: Bool { get }
    /// 血氧数据
    var setSpo2Data: Bool { get }
    /// 运动模式排序
    var setSportModeSort: Bool { get }
    /// 运动模式开关
    var setActivitySwitch: Bool { get }
    /// 夜间自动亮度
    var setNightAutoBrightness: Bool { get }
    /// 5级亮度调节
    var setScreenBrightness5Level: Bool { get }
    /// 走动提醒
    var setWalkReminder: Bool { get }
    /// 3级亮度调节 默认是5级别，手表app显示，手表不显示
    var setScreenBrightness3Level: Bool { get }
    /// 洗手提醒
    var setHandWashReminder: Bool { get }
    /// app支持本地表盘改 云端表盘图片下载
    var setLocalDial: Bool { get }
    /// V3的心率过高不支持 | 配置了这个，app的UI心率过高告警不显示，
    var setNotSupportHrHighAlarm: Bool { get }
    /// BIT1 k6项目不需要对应的壁纸表盘，veryFit默认的都是支持的，
    var setNotSupportPhotoWallpaper: Bool { get }
    /// 压力过高提醒
    var setPressureHighReminder: Bool { get }
    /// 壁纸表盘颜色设置
    var setWallpaperOnlyTimeColor: Bool { get }
    /// 壁纸表盘设置
    var setWallpaperDial: Bool { get }
    /// 呼吸训练
    var setSupportBreathRate: Bool { get }
    /// 设置单位的增加卡路里设置
    var setSupportCalorieUnit: Bool { get }
    /// 运动计划
    var setSupportSportPlan: Bool { get }
    /// 设置单位的增加泳池的单位设置
    var setSupportSwimPoolUnit: Bool { get }
    /// v3 bp
    var setSupportV3Bp: Bool { get }
    /// app端用V3的获取运动排序协议中的最大最少默认字段， |
    var setV3GetSportSortField: Bool { get }
    /// 表盘排序
    var setWatchDialSort: Bool { get }
    /// 运动三环目标获取
    var setGetCalorieDistanceGoal: Bool { get }
    /// 设置目标增加中高运动时长
    var setMidHighTimeGoal: Bool { get }
    /// 固件支持解绑不清除设备上的数据
    var setNewRetainData: Bool { get }
    /// 日程提醒
    var setScheduleReminder: Bool { get }
    /// 100种运动数据排序
    var setSet100SportSort: Bool { get }
    /// 20种基础运动数据子参数排序
    var setSet20SportParamSort: Bool { get }
    /// 主界面ui控件排列
    var setSetMainUiSort: Bool { get }
    /// 压力校准
    var setSetStressCalibration: Bool { get }
    /// 支持app设置智能心率
    var setSmartHeartRate: Bool { get }
    /// 支持app设置全天的血氧开关数据
    var setSpo2AllDayOnOff: Bool { get }
    /// 支持app下发压缩的sbc语言文件给ble
    var setSupportAppSendVoiceToBle: Bool { get }
    /// 设置单位的增加骑行的单位设置
    var setSupportCyclingUnit: Bool { get }
    /// 设置单位的增加步行跑步的单位设置
    var setSupportWalkRunUnit: Bool { get }
    /// 设置走动提醒中的目标时间
    var setWalkReminderTimeGoal: Bool { get }
    /// 支持显示表盘容量
    var setWatchCapacitySizeDisplay: Bool { get }
    /// 支持壁纸表盘时间位置移动、控件图标颜色修改、控件功能选择
    var setWatchPhotoPositionMove: Bool { get }
    /// 菜单设置
    var setMenuListMain7: Bool { get }
    /// v3经期的历史数据下发
    var setHistoryMenstrual: Bool { get }
    /// 经期历史数据支持交互
    var supportHistoricalMenstruationExchange: Bool { get }
    /// v3经期历史数据支持交互、支持固件删除
    var supportSetHistoricalMenstruationExchangeVersion21: Bool { get }
    /// v3经期历史数据支持交互、支持固件删除
    var supportHistoricalMenstruationExchangeVersion31: Bool { get }
    /// v3女性生理日常记录设置
    var supportPhysiologicalRecord: Bool { get }
    /// v2经期提醒设置 增加易孕期和结束时间
    var setMenstrualAddPregnancy: Bool { get }
    /// realme wear 定制需求 不支持显示来电"延时三秒"开关
    var setNotSurportCalling3SDelay: Bool { get }
    /// 支持健身指导开关下发
    var setSetFitnessGuidance: Bool { get }
    /// 通知设置
    var setSetNotificationStatus: Bool { get }
    /// 未读提醒
    var setSetUnreadAppReminder: Bool { get }
    /// 支持V3天气
    var setSetV3Weather: Bool { get }
    /// 支持天气推送增加日落日出时间
    var setSetV3WeatherSunrise: Bool { get }
    /// 支持世界时间设置
    var setSetV3WorldTime: Bool { get }
    /// 支持联系人同步
    var setSyncContact: Bool { get }
    /// 同步V3的多运动增加新的参数
    var setSyncV3ActivityAddParam: Bool { get }
    /// 音乐名称设置
    var setTransferMusicFile: Bool { get }
    /// 走动提醒增加通知类型
    var setWalkReminderAddNotify: Bool { get }
    /// 设置单位支持华氏度
    var setSupportFahrenheit: Bool { get }
    /// 支持v3闹钟设置获取指定名称闹钟（KR01定制）
    var setGetAlarmSpecify: Bool { get }
    /// 支持airoha芯片采gps数据功能表
    var setAirohaGpsChip: Bool { get }
    /// 支持第二套运动图标功能表    目前仅idw05支持
    var setSupportSecondSportIcon: Bool { get }
    /// 100种运动需要的中图功能表
    var setSportMediumIcon: Bool { get }
    /// 支持天气推送增加日落日出时间
    var setWeatherSunTime: Bool { get }
    /// 支持V3天气 下发空气质量等级
    var setWeatherAirGrade: Bool { get }
    /// 支持设置喝水提醒
    var setDrinkWaterReminder: Bool { get }
    /// 支持设备电量提醒开关
    var supportBatteryReminderSwitch: Bool { get }
    /// 支持宠物信息设置获取（SET:03 0A / GET:02 0A）
    var supportPetInfo: Bool { get }
    /// 呼吸率开关设置
    var setRespirationRate: Bool { get }
    /// 最大摄氧量
    var setMaxBloodOxygen: Bool { get }
    /// ble控制音乐
    var setBleControlMusic: Bool { get }
    /// v3压力功能表
    var setMainPressure: Bool { get }
    /// 勿扰模式设置获取新增全天勿扰开关和智能开关
    var setNoDisturbAllDayOnOff: Bool { get }
    /// 支持设置全天勿扰开关
    var setOnlyNoDisturbAllDayOnOff: Bool { get }
    /// 支持设置智能勿扰开关
    var setOnlyNoDisturbSmartOnOff: Bool { get }
    /// 时区设定值为实际时区值的扩大100倍
    var setTimeZoneFloat: Bool { get }
    /// 设定温度开关
    var setTemperatureSwitchSupport: Bool { get }
    /// 支持设置获取消息应用总开关字段
    var setMsgAllSwitch: Bool { get }
    /// 不支持支持来电提醒页面的“延迟三秒”开关设置项显示
    var setNotSupperCall3Delay: Bool { get }
    /// 支持来电已拒
    var setNoticeMissedCallV2: Bool { get }
    /// 结束查找手机
    var setOverFindPhone: Bool { get }
    /// 获取所有的健康监测开关
    var getHealthSwitchStateSupportV3: Bool { get }
    /// 久坐提醒
    var setSedentariness: Bool { get }
    /// 设置屏幕亮度
    var setScreenBrightness: Bool { get }
    /// 设置设备音乐音量
    var setSetPhoneVoice: Bool { get }
    /// 设置快捷来电回复开关
    var setSupportSetCallQuickReplyOnOff: Bool { get }
    /// 支持多运动交互中下发GPS坐标
    var setSupportExchangeSetGpsCoordinates: Bool { get }
    /// 支持v3天气协议下发大气压强
    var setSupportV3WeatherAddAtmosphericPressure: Bool { get }
    /// 支持v3天气协议下发积雪厚度
    var setSupportSetV3WeatcherAddSnowDepth: Bool { get }
    /// 支持v3天气协议下发降雪量
    var setSupportSetV3WeatcherAddSnowfall: Bool { get }
    /// 支持v3天气协议下发协议版本0x4版本
    var setSupportSetV3WeatcherSendStructVersion04: Bool { get }
    /// 支持设置压力校准阈
    var setSendCalibrationThreshold: Bool { get }
    /// 支持屏蔽跑步计划入口
    var getNotSupportAppSendRunPlan: Bool { get }
    /// 支持APP展示零星小睡睡眠数据
    var getSupportDisplayNapSleep: Bool { get }
    /// 支持app获取智能心率
    var getSupportGetSmartHeartRate: Bool { get }
    /// 支持app获取压力开关
    var getSupportGetPressureSwitchInfo: Bool { get }
    /// 支持电子卡片功能
    var getSupportECardOperate: Bool { get }
    /// 支持语音备忘录功能
    var getSupportVoiceMemoOperate: Bool { get }
    /// 支持晨报功能
    var getSupportMorningEdition: Bool { get }
    /// 支持app获取血氧饱和度开关
    var getSupportGetSpo2SwitchInfo: Bool { get }
    /// 支持同步心率使用version字段兼容
    var getSupportSyncHealthHrUseVersionCompatible: Bool { get }
    /// v3天气设置增加下发48小时天气数据
    var getSupportSetV3Add48HourWeatherData: Bool { get }
    /// 功能表开启后,室内跑步不支持获取最大摄氧量,app室内跑步不展示此数据
    var getNotSupportIndoorRunGetVo2max: Bool { get }
    /// 支持app设置心电图测量提醒
    var getSupportSetEcgReminder: Bool { get }
    /// 支持同步心电图(ecg)数据
    var getSupportSyncEcg: Bool { get }
    /// 支持游戏时间设置
    var getSupportSetGameTimeReminder: Bool { get }
    /// 支持配置默认的消息应用列表
    var getSupportConfigDefaultMegApplicationList: Bool { get }
    /// 支持app设置eci
    var getSupportSetEciReminder: Bool { get }
    /// 环境音量支持设置通知类型
    var setSupportNoiseSetNotifyFlag: Bool { get }
    /// 环境音量支持设置过高提醒
    var setSupportNoiseSetOverWarning: Bool { get }
    /// 支持设置版本信息
    var setSupportSetVersionInformation: Bool { get }
    /// 支持小程序操作
    var setSupportControlMiniProgram: Bool { get }
    /// 支持下发未来和历史空气质量数据
    var getSupportSetWeatherHistoryFutureAqi: Bool { get }
    /// 支持设置亮屏亮度时间
    var setBrightScreenTime: Bool { get }
    /// 支持设置心率过高过低提醒
    var setHeartSetRateModeCustom: Bool { get }
    /// 支持查询、设置 v3菜单列表
    var supportProtocolV3MenuList: Bool { get }
    /// 中文
    var languageCh: Bool { get }
    /// 捷克文
    var languageCzech: Bool { get }
    /// 英文
    var languageEnglish: Bool { get }
    /// 法文
    var languageFrench: Bool { get }
    /// 德文
    var languageGerman: Bool { get }
    /// 意大利文
    var languageItalian: Bool { get }
    /// 日文
    var languageJapanese: Bool { get }
    /// 西班牙文
    var languageSpanish: Bool { get }
    /// 阿拉伯语
    var languageArabic: Bool { get }
    /// 缅甸语
    var languageBurmese: Bool { get }
    /// 菲律宾语
    var languageFilipino: Bool { get }
    /// 希腊语
    var languageGreek: Bool { get }
    /// 泰国语
    var languageThai: Bool { get }
    /// 繁体中文
    var languageTraditionalChinese: Bool { get }
    /// 越南语
    var languageVietnamese: Bool { get }
    /// 荷兰文
    var languageDutch: Bool { get }
    /// 匈牙利文
    var languageHungarian: Bool { get }
    /// 立陶宛文
    var languageLithuanian: Bool { get }
    /// 波兰文
    var languagePolish: Bool { get }
    /// 罗马尼亚文
    var languageRomanian: Bool { get }
    /// 俄罗斯文
    var languageRussian: Bool { get }
    /// 斯洛文尼亚文
    var languageSlovenian: Bool { get }
    /// 乌克兰文
    var languageUkrainian: Bool { get }
    /// 克罗地亚语
    var languageCroatian: Bool { get }
    /// 丹麦语
    var languageDanish: Bool { get }
    /// 印地语
    var languageHindi: Bool { get }
    /// 印尼语
    var languageIndonesian: Bool { get }
    /// 韩语
    var languageKorean: Bool { get }
    /// 葡萄牙语
    var languagePortuguese: Bool { get }
    /// 斯洛伐克语
    var languageSlovak: Bool { get }
    /// 土耳其
    var languageTurkish: Bool { get }
    /// 波斯语
    var languagePersia: Bool { get }
    /// 瑞典语
    var languageSweden: Bool { get }
    /// 挪威语
    var languageNorwegian: Bool { get }
    /// 芬兰语
    var languageFinland: Bool { get }
    /// 孟加拉语
    var languageBengali: Bool { get }
    /// 高棉语
    var languageKhmer: Bool { get }
    /// 马来语
    var languageMalay: Bool { get }
    /// 巴西葡语
    var languageBrazilianPortuguese: Bool { get }
    /// 希伯来语
    var languageHebrew: Bool { get }
    /// 塞尔维亚语
    var languageSerbian: Bool { get }
    /// 保加利亚
    var languageBulgaria: Bool { get }
    /// v3 心率
    var syncV3Hr: Bool { get }
    /// v3 游泳
    var syncV3Swim: Bool { get }
    /// v3 血氧
    var syncV3Spo2: Bool { get }
    /// v3 压力
    var syncV3Pressure: Bool { get }
    /// v3 多运动
    var syncV3Activity: Bool { get }
    /// v3 睡眠
    var syncV3Sleep: Bool { get }
    /// v3 宠物睡眠
    var syncV3PetSleep: Bool { get }
    /// v3 步数
    var syncV3Sports: Bool { get }
    /// v3 gps
    var syncV3Gps: Bool { get }
    /// v3 闹钟
    var syncV3SyncAlarm: Bool { get }
    /// v3 身体电量
    var syncV3BodyPower: Bool { get }
    /// 同步hrv
    var getSupportHrvV3: Bool { get }
    /// 同步血压
    var getSupportPerBpV3: Bool { get }
    /// 同步噪音
    var syncV3Noise: Bool { get }
    /// 同步温度
    var syncV3Temperature: Bool { get }
    /// gps
    var syncGps: Bool { get }
    /// v3多运动同步数据交换
    var syncV3ActivityExchangeData: Bool { get }
    /// 心率功能
    var syncHeartRate: Bool { get }
    /// 心率监测
    var syncHeartRateMonitor: Bool { get }
    /// 睡眠检测
    var syncSleepMonitor: Bool { get }
    /// 快速同步
    var syncFastSync: Bool { get }
    /// 获取时间同步
    var syncActivityTimeSync: Bool { get }
    /// v2同步 时间线
    var syncTimeLine: Bool { get }
    /// 需要V2的同步
    var syncNeedV2: Bool { get }
    /// v3多运动同步支持实时速度显示
    var syncRealTimeV3: Bool { get }
    /// 数据交换增加实时的配速字段
    var syncExchangeDataReplyAddRealTimeSpeedPaceV3: Bool { get }
    /// 多运行结束时间使用UTC模式
    var syncHealthSyncV3ActivityEndTimeUseUtcMode: Bool { get }
    /// 支持数据同步时开启快速模式
    var syncSupportSetFastModeWhenSyncConfig: Bool { get }
    /// 支持获取app基本信息
    var getSupportAppBaseInformation: Bool { get }
    /// 闹钟个数
    var alarmCount: Int { get }
    /// 刷牙
    var alarmBrushTeeth: Bool { get }
    /// 约会
    var alarmDating: Bool { get }
    /// 吃饭
    var alarmDinner: Bool { get }
    /// 吃药
    var alarmMedicine: Bool { get }
    /// 会议
    var alarmMeeting: Bool { get }
    /// 聚会
    var alarmParty: Bool { get }
    /// 休息
    var alarmRest: Bool { get }
    /// 睡觉
    var alarmSleep: Bool { get }
    /// 锻炼
    var alarmSport: Bool { get }
    /// 起床
    var alarmWakeUp: Bool { get }
    /// 支持设置防丢
    var supportSetAntilost: Bool { get }
    /// 支持设置v2天气数据
    var supportSetWeatherDataV2: Bool { get }
    /// 支持设置一键呼叫
    var supportSetOnetouchCalling: Bool { get }
    /// 支持设置运动中屏幕显示
    var supportOperateSetSportScreen: Bool { get }
    /// 支持设置应用列表样式
    var supportOperateListStyle: Bool { get }
    /// 支持情绪健康
    var supportEmotionHealth: Bool { get }
    /// 支持v3同步通讯录版本20
    var supportV3SyncContactVersion20: Bool { get }
    /// 支持SOS通话记录查询
    var supportGetSosCallRecord: Bool { get }
    /// alexa 语音提醒增加对应的时钟传输字段
    var alexaReminderAddSecV3: Bool { get }
    /// alexa 简单控制命令
    var alexaSetEasyOperateV3: Bool { get }
    /// alexa 语音闹钟获取设置命令使用
    var alexaSetGetAlexaAlarmV3: Bool { get }
    /// alexa 设置跳转运动界面
    var alexaSetJumpSportUiV3: Bool { get }
    /// alexa 设置跳转ui界面
    var alexaSetJumpUiV3: Bool { get }
    /// alexa app设置开关命令
    var alexaSetSetOnOffTypeV3: Bool { get }
    /// alexa 语音支持设置天气
    var alexaSetWeatherV3: Bool { get }
    /// alexa 支持设置多个定时器
    var alexaTimeNewV3: Bool { get }
    /// alexa 100级亮度控制
    var setAlexaControll100brightness: Bool { get }
    /// alexa 获取alexa默认语言
    var alexaGetSupportGetAlexaDefaultLanguage: Bool { get }
    /// alexa跳转运动界面支持100种运动类型字段
    var alexaGetUIControllSports: Bool { get }
    /// 支持获取左右手佩戴设置
    var getLeftRightHandWearSettings: Bool { get }
    /// 支持支持运动中设置提示音
    var supportSettingsDuringExercise: Bool { get }
    /// 支持身高单位设置(厘米/英寸)
    var supportHeightLengthUnit: Bool { get }
    /// 支持运动中提醒设置
    var supportSportingRemindSetting: Bool { get }
    /// 支持获取运动是否支持自动暂停结束
    var supportSportGetAutoPauseEnd: Bool { get }
    /// 支持步幅长度的单位设置(公制/英制)
    var supportSetStrideLengthUnit: Bool { get }
    /// 支持简单心率区间
    var supportSimpleHrZoneSetting: Bool { get }
    /// 开启功能表则关闭智能心率过低提醒
    var notSupportSmartLowHeartReatRemind: Bool { get }
    /// 开启功能表则关闭智能心率过高提醒
    var notSupportSmartHighHeartReatRemind: Bool { get }
    /// 设备是否不支持拍照推流
    var notSupportPhotoPreviewControl: Bool { get }
    /// 支持获取用户信息
    var supportGetUserInfo: Bool { get }
    /// 支持未接来电消息类型为485
    var supportMissedCallMsgTypeUseFixed: Bool { get }
    /// 支持闹钟不显示闹钟名称
    var supportAppNotDisplayAlarmName: Bool { get }
    /// 支持设置睡眠提醒
    var supportSetSleepRemind: Bool { get }
    /// 支持血糖
    var supportBloodGlucose: Bool { get }
    /// 支持血糖(v01)
    var supportBloodGlucoseV01: Bool { get }
    /// 车锁管理
    var supportBikeLockManager: Bool { get }
    /// 支持算法数据的采集
    var supportAlgorithmRawDataCollect: Bool { get }
    /// 支持离线地图
    var supportOfflineMapInformation: Bool { get }
    /// 开启则⽀持储备⼼率区间,关闭默认⽀持的最⼤⼼率区间
    var supportHeartRateReserveZones: Bool { get }
    /// 开启则⽀持⼼率区间⼼率最⼤值设置
    var supportHeartRateZonesHrMaxSet: Bool { get }
    /// 支持新的同步多运动数据（同步多运动/游泳/跑步课程/跑步计划/跑后拉伸数据）
    var supportSyncMultiActivityNew: Bool { get }
    /// 联系人存储支持使用固件返回大小
    var supportContactFileUseFirmwareReturnSize: Bool { get }
    /// 控制APP是否显示相机入口
    var supportDisplayCameraEntry: Bool { get }
    /// 支持家庭关心提醒设置
    var supportOperateFamilyCareReminder3376: Bool { get }
    /// 支持设置获取经期配置，使用v3长包指令
    var supportProtocolV3MenstruationConfig3377: Bool { get }
    /// 支持习惯养成设置
    var supportOperateHabitFormation: Bool { get }
    /// 支持版本v01习惯养成设置
    var supportOperateHabitFormationV01: Bool { get }
    /// 支持家庭步数下发
    var supportOperateFamilySteps: Bool { get }
    /// 支持游戏设置
    var supportOperateSetGame: Bool { get }
    /// 支持手势控制功能
    var supportOperateGestureControl: Bool { get }

    func printProperties() -> String?
}
