import Foundation

struct FunctionTableModel: Codable {
    /// 智能通知
    let reminderAncs: Bool
    /// Snapchat
    let reminderSnapchat: Bool
    /// Line
    let reminderLine: Bool
    /// Outlook
    let reminderOutlook: Bool
    /// Telegram
    let reminderTelegram: Bool
    /// Viber
    let reminderViber: Bool
    /// Vkontakte
    let reminderVkontakte: Bool
    /// Chatwork;
    let reminderChatwork: Bool
    /// Slack
    let reminderSlack: Bool
    /// Tumblr
    let reminderTumblr: Bool
    /// YahooMail
    let reminderYahooMail: Bool
    /// YahooPinterest
    let reminderYahooPinterest: Bool
    /// Youtube
    let reminderYoutube: Bool
    /// Gmail
    let reminderGmail: Bool
    /// KakaoTalk
    let reminderKakaoTalk: Bool
    /// Google gmail
    let reminderOnlyGoogleGmail: Bool
    /// Outlook email
    let reminderOnlyOutlookEmail: Bool
    /// Yahoo email
    let reminderOnlyYahooEmail: Bool
    /// Tiktok
    let reminderTiktok: Bool
    /// Redbus
    let reminderRedbus: Bool
    /// Dailyhunt
    let reminderDailyhunt: Bool
    /// Hotstar
    let reminderHotstar: Bool
    /// Inshorts
    let reminderInshorts: Bool
    /// Paytm
    let reminderPaytm: Bool
    /// Amazon
    let reminderAmazon: Bool
    /// Flipkart
    let reminderFlipkart: Bool
    /// Nhn email
    let reminderNhnEmail: Bool
    /// Instant email
    let reminderInstantEmail: Bool
    /// Zoho email
    let reminderZohoEmail: Bool
    /// Exchange email
    let reminderExchangeEmail: Bool
    /// 189 email
    let reminder189Email: Bool
    /// Very fit
    let reminderVeryFit: Bool
    /// General
    let reminderGeneral: Bool
    /// other
    let reminderOther: Bool
    /// Matters
    let reminderMattersRemind: Bool
    /// Microsoft
    let reminderMicrosoft: Bool
    /// MissedCalls
    let reminderMissedCall: Bool
    /// 支持同步全部通讯录
    let reminderGetAllContact: Bool
    /// WhatsappBusiness
    let reminderWhatsappBusiness: Bool
    /// Email
    let reminderEmail: Bool
    /// Facebook
    let reminderFacebook: Bool
    /// Message
    let reminderMessage: Bool
    /// QQ
    let reminderQq: Bool
    /// Twitter
    let reminderTwitter: Bool
    /// Weixin
    let reminderWeixin: Bool
    /// Calendar (Google日历）
    let reminderCalendarGoogle: Bool
    /// Instagram
    let reminderInstagram: Bool
    /// linkedIn
    let reminderLinkedIn: Bool
    /// Messengre
    let reminderMessengre: Bool
    /// Skype
    let reminderSkype: Bool
    /// Calendar
    let reminderCalendar: Bool
    /// Whatsapp
    let reminderWhatsapp: Bool
    /// Alarm clock
    let reminderAlarmClock: Bool
    /// 新浪微博
    let reminderSinaWeibo: Bool
    /// 国内版微博
    let reminderWeibo: Bool
    /// 来电提醒
    let reminderCalling: Bool
    /// 来电联系人
    let reminderCallContact: Bool
    /// 来电号码
    let reminderCallNum: Bool
    /// Prime
    let reminderPrime: Bool
    /// Netflix
    let reminderNetflix: Bool
    /// Gpay
    let reminderGpay: Bool
    /// Phonpe
    let reminderPhonpe: Bool
    /// Swiggy
    let reminderSwiggy: Bool
    /// Zomato
    let reminderZomato: Bool
    /// Makemytrip
    let reminderMakemytrip: Bool
    /// JioTv
    let reminderJioTv: Bool
    /// Niosefit
    let reminderNiosefit: Bool
    /// YT music
    let reminderYtmusic: Bool
    /// Uber
    let reminderUber: Bool
    /// Ola
    let reminderOla: Bool
    /// Google meet
    let reminderGoogleMeet: Bool
    /// Mormaii Smartwatch
    let reminderMormaiiSmartwatch: Bool
    /// Technos connect
    let reminderTechnosConnect: Bool
    /// Enjoei
    let reminderEnjoei: Bool
    /// Aliexpress
    let reminderAliexpress: Bool
    /// Shopee
    let reminderShopee: Bool
    /// Teams
    let reminderTeams: Bool
    /// 99 taxi
    let reminder99Taxi: Bool
    /// Uber eats
    let reminderUberEats: Bool
    /// Lfood
    let reminderLfood: Bool
    /// Rappi
    let reminderRappi: Bool
    /// Mercado livre
    let reminderMercadoLivre: Bool
    /// Magalu
    let reminderMagalu: Bool
    /// Americanas
    let reminderAmericanas: Bool
    /// Yahoo
    let reminderYahoo: Bool
    /// 消息图标和名字更新
    let reminderMessageIcon: Bool
    /// 淘宝
    let reminderTaobao: Bool
    /// 钉钉
    let reminderDingding: Bool
    /// 支付宝
    let reminderAlipay: Bool
    /// 今日头条
    let reminderToutiao: Bool
    /// 抖音
    let reminderDouyin: Bool
    /// 天猫
    let reminderTmall: Bool
    /// 京东
    let reminderJd: Bool
    /// 拼多多
    let reminderPinduoduo: Bool
    /// 百度
    let reminderBaidu: Bool
    /// 美团
    let reminderMeituan: Bool
    /// 饿了么
    let reminderEleme: Bool
    /// v2 走路
    let sportWalk: Bool
    /// v2 跑步
    let sportRun: Bool
    /// v2 骑行
    let sportByBike: Bool
    /// v2 徒步
    let sportOnFoot: Bool
    /// v2 游泳
    let sportSwim: Bool
    /// v2 爬山
    let sportMountainClimbing: Bool
    /// v2 羽毛球
    let sportBadminton: Bool
    /// v2 其他
    let sportOther: Bool
    /// v2 健身
    let sportFitness: Bool
    /// v2 动感单车
    let sportSpinning: Bool
    /// v2 椭圆球
    let sportEllipsoid: Bool
    /// v2 跑步机
    let sportTreadmill: Bool
    /// v2 仰卧起坐
    let sportSitUp: Bool
    /// v2 俯卧撑
    let sportPushUp: Bool
    /// v2 哑铃
    let sportDumbbell: Bool
    /// v2 举重
    let sportWeightlifting: Bool
    /// v2 健身操
    let sportBodybuildingExercise: Bool
    /// v2 瑜伽
    let sportYoga: Bool
    /// v2 跳绳
    let sportRopeSkipping: Bool
    /// v2 乒乓球
    let sportTableTennis: Bool
    /// v2 篮球
    let sportBasketball: Bool
    /// v2 足球
    let sportFootballl: Bool
    /// v2 排球
    let sportVolleyball: Bool
    /// v2 网球
    let sportTennis: Bool
    /// v2 高尔夫
    let sportGolf: Bool
    /// v2 棒球
    let sportBaseball: Bool
    /// v2 滑雪
    let sportSkiing: Bool
    /// v2 轮滑
    let sportRollerSkating: Bool
    /// v2 跳舞
    let sportDance: Bool
    /// v2 功能性训练
    let sportStrengthTraining: Bool
    /// v2 核心训练
    let sportCoreTraining: Bool
    /// v2 整体放松
    let sportTidyUpRelax: Bool
    /// v2 传统的力量训练
    let sportTraditionalStrengthTraining: Bool
    /// v3 户外跑步
    let sportOutdoorRun: Bool
    /// v3 室内跑步
    let sportIndoorRun: Bool
    /// v3 户外骑行
    let sportOutdoorCycle: Bool
    /// v3 室内骑行
    let sportIndoorCycle: Bool
    /// v3 户外走路
    let sportOutdoorWalk: Bool
    /// v3 室内走路
    let sportIndoorWalk: Bool
    /// v3 泳池游泳
    let sportPoolSwim: Bool
    /// v3 开放水域游泳
    let sportOpenWaterSwim: Bool
    /// v3 椭圆机
    let sportElliptical: Bool
    /// v3 划船机
    let sportRower: Bool
    /// v3 高强度间歇训练法
    let sportHiit: Bool
    /// v3 板球运动
    let sportCricket: Bool
    /// v3 普拉提
    let sportPilates: Bool
    /// v3 户外玩耍（定制 kr01）
    let sportOutdoorFun: Bool
    /// v3 其他运动（定制 kr01）
    let sportOtherActivity: Bool
    /// v3 尊巴舞
    let sportZumba: Bool
    /// v3 冲浪
    let sportSurfing: Bool
    /// v3 足排球
    let sportFootvolley: Bool
    /// v3 站立滑水
    let sportStandWaterSkiing: Bool
    /// v3 站绳
    let sportBattlingRope: Bool
    /// v3 滑板
    let sportSkateboard: Bool
    /// v3 踏步机
    let sportNoticeStepper: Bool
    /// 运动显示个数
    let sportShowNum: Int
    /// 有氧健身操
    let sportAerobicsBodybuildingExercise: Bool
    /// 引体向上
    let sportPullUp: Bool
    /// 单杠
    let sportHighBar: Bool
    /// 双杠
    let sportParallelBars: Bool
    /// 越野跑
    let sportTrailRunning: Bool
    /// 匹克球
    let sportPickleBall: Bool
    /// 滑板
    let sportSnowboard: Bool
    /// 越野滑板
    let sportCrossCountrySkiing: Bool
    /// 获取实时数据
    let getRealtimeData: Bool
    /// 获取v3语言库
    let getLangLibraryV3: Bool
    /// 查找手机
    let getFindPhone: Bool
    /// 查找设备
    let getFindDevice: Bool
    /// 抬腕亮屏数据获取
    let getUpHandGestureEx: Bool
    /// 抬腕亮屏
    let getUpHandGesture: Bool
    /// 天气预报
    let getWeather: Bool
    /// 可下载语言
    let getDownloadLanguage: Bool
    /// 恢复出厂设置
    let getFactoryReset: Bool
    /// Flash log
    let getFlashLog: Bool
    /// 多运动不能使用app
    let getMultiActivityNoUseApp: Bool
    /// 多表盘
    let getMultiDial: Bool
    /// 获取菜单列表
    let getMenuList: Bool
    /// 请勿打扰
    let getDoNotDisturbMain3: Bool
    /// 语音功能
    let getVoiceTransmission: Bool
    /// 设置喝水开关通知类型
    let setDrinkWaterAddNotifyFlag: Bool
    /// 血氧过低提醒通知提醒类型
    let setSpo2LowValueRemindAddNotifyFlag: Bool
    /// 智能心率提醒通知提醒类型
    let notSupportSmartHeartNotifyFlag: Bool
    /// 获取重启日志错误码和标志位
    let getDeviceLogState: Bool
    /// 支持获取表盘列表的接口
    let getNewWatchList: Bool
    /// 消息提醒图标自适应
    let getNotifyIconAdaptive: Bool
    /// 压力开关增加通知类型和全天压力模式设置
    let getPressureNotifyFlagMode: Bool
    /// 科学睡眠
    let getScientificSleep: Bool
    /// 血氧开关增加通知类型
    let getSpo2NotifyFlag: Bool
    /// v3 收集log
    let getV3Log: Bool
    /// 获取表盘ID
    let getWatchID: Bool
    /// 获取设备名称
    let getDeviceName: Bool
    /// 获取电池日志
    let getBatteryLog: Bool
    /// 获取电池信息
    let getBatteryInfo: Bool
    /// 获取过热日志
    let getHeatLog: Bool
    /// 获取走动提醒 v3
    let getWalkReminderV3: Bool
    /// 获取支持蓝牙音乐 v3
    let getSupportV3BleMusic: Bool
    /// 支持获取固件本地提示音文件信息
    let getSupportGetBleBeepV3: Bool
    /// BIT1 k6项目不需要对应的壁纸表盘，veryFit默认的都是支持的，新加一个不支持的功能表，不需要的配置这个
    let getVeryFitNotSupportPhotoWallpaperV3: Bool
    /// 支持升级gps固件
    let getSupportUpdateGps: Bool
    /// 支持ublox模块
    let getUbloxModel: Bool
    /// 支持获取固件歌曲名和文件夹指令下发和固件回复使用协议版本号0x10
    let getSupportGetBleMusicInfoVerV3: Bool
    /// 获得固件三级版本和BT的三级版本
    let getBtVersion: Bool
    /// V3的运动类型设置和获取
    let getSportsTypeV3: Bool
    /// 支持运动模式识别开关获取
    let getActivitySwitch: Bool
    /// 支持动态消息图标更新
    let getNoticeIconInformation: Bool
    /// 支持获取固件支持app下发的详情的最大数量
    let getSetMaxItemsNum: Bool
    /// v3 消息提醒
    let getNotifyMsgV3: Bool
    /// 获取屏幕亮度
    let getScreenBrightnessMain9: Bool
    /// 128个字节通知
    let getNotice128byte: Bool
    /// 250个字节通知
    let getNotice250byte: Bool
    /// 支持获取不可删除的快捷应用列表
    let getDeletableMenuListV2: Bool
    /// 设置支持系统配对
    let getSupportPairEachConnect: Bool
    /// 支持获取运动目标
    let getSupportGetMainSportGoalV3: Bool
    /// 取bt蓝牙MAC地址
    let getBtAddrV2: Bool
    /// 血压校准与测量
    let getSupportBpSetOrMeasurementV2: Bool
    /// 生理周期开关增加通知类型
    let getMenstrualAddNotifyFlagV3: Bool
    /// 设置获取运动三环周目标
    let getSupportSetGetTimeGoalTypeV2: Bool
    /// 多运动同步数据支持摄氧量等级数据
    let getOxygenDataSupportGradeV3: Bool
    /// 多运动数据同步支持海拔高度数据
    let getSupportSyncActivityDataAltitudeInfo: Bool
    /// 绑定授权码
    let getBindCodeAuth: Bool
    /// V3血氧数据 偏移按照分钟偏移
    let getSpo2OffChangeV3: Bool
    /// 5级心率区间
    let getLevel5HrInterval: Bool
    /// 5个心率区间
    let getFiveHRInterval: Bool
    /// 获得固件三级版本和BT的3级版本
    let getBleAndBtVersion: Bool
    /// 紧急联系人
    let getSupportSetGetEmergencyContactV3: Bool
    /// 重复提醒类型设置星期重复
    let getSupportSetRepeatWeekTypeOnScheduleReminderV3: Bool
    /// 重复提醒类型设置
    let getSupportSetRepeatTypeOnScheduleReminderV3: Bool
    /// 经期开关
    let getSupportSetMenstrualReminderOnOff: Bool
    /// 版本信息
    let getVersionInfo: Bool
    /// 获取MTU
    let getMtu: Bool
    /// 获取手环的升级状态
    let getDeviceUpdateState: Bool
    /// v2获取心率监测模式
    let getHeartRateModeV2: Bool
    /// 目标步数类型为周目标
    let getStepDataTypeV2: Bool
    /// 快速消息
    let getFastMsgDataV3: Bool
    /// 支持快速回复
    let getSupportCallingQuickReply: Bool
    /// 新错误码 v3
    let getSupportDataTranGetNewErrorCodeV3: Bool
    /// 运动自识别结束开关不展示，设置开关状态
    let getAutoActivityEndSwitchNotDisplay: Bool
    /// 运动自识别暂停开关不展示，设置开关状态
    let getAutoActivityPauseSwitchNotDisplay: Bool
    /// 运动模式自动识别开关设置获取 新增类型椭圆机 划船机 游泳
    let getV3AutoActivitySwitch: Bool
    /// 运动模式自动识别开关设置获取 新增类型骑行
    let getAutoActivitySwitchAddBicycle: Bool
    /// 运动模式自动识别开关设置获取 新增类型智能跳绳
    let getAutoActivitySwitchAddSmartRope: Bool
    /// 运动自识别获取和设置指令使用新的版本与固件交互
    let getAutoActivitySetGetUseNewStructExchange: Bool
    /// 支持走动提醒设置/获取免提醒时间段
    let getSupportSetGetNoReminderOnWalkReminderV2: Bool
    /// 支持获取sn信息
    let getSupportGetSnInfo: Bool
    /// 日程提醒不显示标题
    let getScheduleReminderNotDisplayTitle: Bool
    /// 城市名称
    let getSupportV3LongCityName: Bool
    /// 亮度设置支持夜间亮度等级设置
    let getSupportAddNightLevelV2: Bool
    /// 固件支持使用表盘框架使用argb6666编码格式
    let getSupportDialFrameEncodeFormatArgb6666: Bool
    /// 固件支持app下发手机操作系统信息
    let getSupportAppSendPhoneSystemInfo: Bool
    /// 固件管理切换快/慢速模式，APP不下发设置链接参数(快慢速）
    let getDeviceControlFastModeAlone: Bool
    /// 设备支持一键双连，区分配对时APP展示引导页还是直接下发配对指令
    let getSupportOnekeyDoubleContact: Bool
    /// 语音助手状态
    let getSupportSetVoiceAssistantStatus: Bool
    /// 支持获取flash log size
    let getSupportFlashLogSize: Bool
    /// 设备是否支持返回正在测量的值
    let supportDevReturnMeasuringValue: Bool
    /// 支持获取单位
    let getSupportGetUnit: Bool
    /// 通知支持Ryze Connect
    let getSupportRyzeConnect: Bool
    /// 通知支持LOOPS FIT
    let getSupportLoopsFit: Bool
    /// 通知支持TAS Smart
    let getSupportTasSmart: Bool
    /// 女性经期不支持设置排卵日提醒
    let getNotSupportSetOvulation: Bool
    /// 固件支持每小时目标步数设置和获取
    let getSupportWalkGoalSteps: Bool
    /// GTX03/05定制，hamaAPP，功能表开启后，运动列表不支持增删，支持排序
    let getNotSupportDeleteAddSportSort: Bool
    /// 支持获取用户习惯信息(打点信息)中久坐提醒特性
    let getSupportSedentaryTensileHabitInfo: Bool
    /// 支持固件快速定位，APP下发GPS权限及经纬度给固件
    let getSupportSendGpsLongitudeAndLatitude: Bool
    /// 支持设备bt连接的手机型号
    let getSupportGetV3DeviceBtConnectPhoneModel: Bool
    /// 支持血压模型文件更新
    let getSupportBloodPressureModelFileUpdate: Bool
    /// 勿扰支持事件范围开关和重复
    let getSupportDisturbHaveRangRepeat: Bool
    /// 日历提醒
    let getSupportCalendarReminder: Bool
    /// 表盘传输需要对应的传输原始的没有压缩的大小给固件,增加字段watch_file_size
    let getWatchDailSetAddSize: Bool
    /// 支持同步过高过低时心率数据
    let getSupportSyncOverHighLowHeartData: Bool
    /// 间隔一分钟同步新增（206设备）
    let getSupportPerMinuteOne: Bool
    /// 支持全天步数目标达成提醒开关
    let getSupportAchievedRemindOnOff: Bool
    /// 支持喝水计划
    let getSupportDrinkPlan: Bool
    /// 支持表盘包打包jpg图片
    let getSupportMakeWatchDialDecodeJpg: Bool
    /// 支持睡眠计划
    let getSupportSleepPlan: Bool
    /// 支持获取设备算法文件
    let getSupportDeviceOperateAlgFile: Bool
    /// 支持获取运动记录的显示项配置
    let getSupportSportRecordShowConfig: Bool
    /// 设置获取消息应用状态使用version0x20版本下发
    let setNoticeMessageStateUseVersion0x20: Bool
    /// 科学睡眠开关
    let setScientificSleepSwitch: Bool
    /// 设置夜间体温开关
    let setTemperatureSwitchHealth: Bool
    /// 心率监测
    let setHeartRateMonitor: Bool
    /// 支持喝水提醒设置免提醒时间段
    let setNoReminderOnDrinkReminder: Bool
    /// 默认是支持agps off升级
    let setAgpsOffLine: Bool
    /// 默认是支持agps online升级
    let setAgpsOnLine: Bool
    /// 设置v3心率的间隔
    let setSetV3HeartInterval: Bool
    /// 天气城市
    let setWeatherCity: Bool
    /// 防打扰
    let setDoNotDisturb: Bool
    /// 卡路里目标
    let setCalorieGoal: Bool
    /// 女性生理周期
    let setMenstruation: Bool
    /// 压力数据
    let setPressureData: Bool
    /// 血氧数据
    let setSpo2Data: Bool
    /// 运动模式排序
    let setSportModeSort: Bool
    /// 运动模式开关
    let setActivitySwitch: Bool
    /// 夜间自动亮度
    let setNightAutoBrightness: Bool
    /// 5级亮度调节
    let setScreenBrightness5Level: Bool
    /// 走动提醒
    let setWalkReminder: Bool
    /// 3级亮度调节 默认是5级别，手表app显示，手表不显示
    let setScreenBrightness3Level: Bool
    /// 洗手提醒
    let setHandWashReminder: Bool
    /// app支持本地表盘改 云端表盘图片下载
    let setLocalDial: Bool
    /// V3的心率过高不支持 | 配置了这个，app的UI心率过高告警不显示，
    let setNotSupportHrHighAlarm: Bool
    /// BIT1 k6项目不需要对应的壁纸表盘，veryFit默认的都是支持的，
    let setNotSupportPhotoWallpaper: Bool
    /// 压力过高提醒
    let setPressureHighReminder: Bool
    /// 壁纸表盘颜色设置
    let setWallpaperOnlyTimeColor: Bool
    /// 壁纸表盘设置
    let setWallpaperDial: Bool
    /// 呼吸训练
    let setSupportBreathRate: Bool
    /// 设置单位的增加卡路里设置
    let setSupportCalorieUnit: Bool
    /// 运动计划
    let setSupportSportPlan: Bool
    /// 设置单位的增加泳池的单位设置
    let setSupportSwimPoolUnit: Bool
    /// v3 bp
    let setSupportV3Bp: Bool
    /// app端用V3的获取运动排序协议中的最大最少默认字段， |
    let setV3GetSportSortField: Bool
    /// 表盘排序
    let setWatchDialSort: Bool
    /// 运动三环目标获取
    let setGetCalorieDistanceGoal: Bool
    /// 设置目标增加中高运动时长
    let setMidHighTimeGoal: Bool
    /// 固件支持解绑不清除设备上的数据
    let setNewRetainData: Bool
    /// 日程提醒
    let setScheduleReminder: Bool
    /// 100种运动数据排序
    let setSet100SportSort: Bool
    /// 20种基础运动数据子参数排序
    let setSet20SportParamSort: Bool
    /// 主界面ui控件排列
    let setSetMainUiSort: Bool
    /// 压力校准
    let setSetStressCalibration: Bool
    /// 支持app设置智能心率
    let setSmartHeartRate: Bool
    /// 支持app设置全天的血氧开关数据
    let setSpo2AllDayOnOff: Bool
    /// 支持app下发压缩的sbc语言文件给ble
    let setSupportAppSendVoiceToBle: Bool
    /// 设置单位的增加骑行的单位设置
    let setSupportCyclingUnit: Bool
    /// 设置单位的增加步行跑步的单位设置
    let setSupportWalkRunUnit: Bool
    /// 设置走动提醒中的目标时间
    let setWalkReminderTimeGoal: Bool
    /// 支持显示表盘容量
    let setWatchCapacitySizeDisplay: Bool
    /// 支持壁纸表盘时间位置移动、控件图标颜色修改、控件功能选择
    let setWatchPhotoPositionMove: Bool
    /// 菜单设置
    let setMenuListMain7: Bool
    /// v3经期的历史数据下发
    let setHistoryMenstrual: Bool
    /// 经期历史数据支持交互
    let supportHistoricalMenstruationExchange: Bool
    /// v3经期历史数据支持交互、支持固件删除
    let supportSetHistoricalMenstruationExchangeVersion21: Bool
    /// v3经期历史数据支持交互、支持固件删除
    let supportHistoricalMenstruationExchangeVersion31: Bool
    /// v3女性生理日常记录设置
    let supportPhysiologicalRecord: Bool
    /// v2经期提醒设置 增加易孕期和结束时间
    let setMenstrualAddPregnancy: Bool
    /// realme wear 定制需求 不支持显示来电"延时三秒"开关
    let setNotSurportCalling3SDelay: Bool
    /// 支持健身指导开关下发
    let setSetFitnessGuidance: Bool
    /// 通知设置
    let setSetNotificationStatus: Bool
    /// 未读提醒
    let setSetUnreadAppReminder: Bool
    /// 支持V3天气
    let setSetV3Weather: Bool
    /// 支持天气推送增加日落日出时间
    let setSetV3WeatherSunrise: Bool
    /// 支持世界时间设置
    let setSetV3WorldTime: Bool
    /// 支持联系人同步
    let setSyncContact: Bool
    /// 同步V3的多运动增加新的参数
    let setSyncV3ActivityAddParam: Bool
    /// 音乐名称设置
    let setTransferMusicFile: Bool
    /// 走动提醒增加通知类型
    let setWalkReminderAddNotify: Bool
    /// 设置单位支持华氏度
    let setSupportFahrenheit: Bool
    /// 支持v3闹钟设置获取指定名称闹钟（KR01定制）
    let setGetAlarmSpecify: Bool
    /// 支持airoha芯片采gps数据功能表
    let setAirohaGpsChip: Bool
    /// 支持第二套运动图标功能表    目前仅idw05支持
    let setSupportSecondSportIcon: Bool
    /// 100种运动需要的中图功能表
    let setSportMediumIcon: Bool
    /// 支持天气推送增加日落日出时间
    let setWeatherSunTime: Bool
    /// 支持V3天气 下发空气质量等级
    let setWeatherAirGrade: Bool
    /// 支持设置喝水提醒
    let setDrinkWaterReminder: Bool
    /// 支持设备电量提醒开关
    let supportBatteryReminderSwitch: Bool
    /// 支持宠物信息设置获取（SET:03 0A / GET:02 0A）
    let supportPetInfo: Bool
    /// 呼吸率开关设置
    let setRespirationRate: Bool
    /// 最大摄氧量
    let setMaxBloodOxygen: Bool
    /// ble控制音乐
    let setBleControlMusic: Bool
    /// v3压力功能表
    let setMainPressure: Bool
    /// 勿扰模式设置获取新增全天勿扰开关和智能开关
    let setNoDisturbAllDayOnOff: Bool
    /// 支持设置全天勿扰开关
    let setOnlyNoDisturbAllDayOnOff: Bool
    /// 支持设置智能勿扰开关
    let setOnlyNoDisturbSmartOnOff: Bool
    /// 时区设定值为实际时区值的扩大100倍
    let setTimeZoneFloat: Bool
    /// 设定温度开关
    let setTemperatureSwitchSupport: Bool
    /// 支持设置获取消息应用总开关字段
    let setMsgAllSwitch: Bool
    /// 不支持支持来电提醒页面的“延迟三秒”开关设置项显示
    let setNotSupperCall3Delay: Bool
    /// 支持来电已拒
    let setNoticeMissedCallV2: Bool
    /// 结束查找手机
    let setOverFindPhone: Bool
    /// 获取所有的健康监测开关
    let getHealthSwitchStateSupportV3: Bool
    /// 久坐提醒
    let setSedentariness: Bool
    /// 设置屏幕亮度
    let setScreenBrightness: Bool
    /// 设置设备音乐音量
    let setSetPhoneVoice: Bool
    /// 设置快捷来电回复开关
    let setSupportSetCallQuickReplyOnOff: Bool
    /// 支持多运动交互中下发GPS坐标
    let setSupportExchangeSetGpsCoordinates: Bool
    /// 支持v3天气协议下发大气压强
    let setSupportV3WeatherAddAtmosphericPressure: Bool
    /// 支持v3天气协议下发积雪厚度
    let setSupportSetV3WeatcherAddSnowDepth: Bool
    /// 支持v3天气协议下发降雪量
    let setSupportSetV3WeatcherAddSnowfall: Bool
    /// 支持v3天气协议下发协议版本0x4版本
    let setSupportSetV3WeatcherSendStructVersion04: Bool
    /// 支持设置压力校准阈
    let setSendCalibrationThreshold: Bool
    /// 支持屏蔽跑步计划入口
    let getNotSupportAppSendRunPlan: Bool
    /// 支持APP展示零星小睡睡眠数据
    let getSupportDisplayNapSleep: Bool
    /// 支持app获取智能心率
    let getSupportGetSmartHeartRate: Bool
    /// 支持app获取压力开关
    let getSupportGetPressureSwitchInfo: Bool
    /// 支持电子卡片功能
    let getSupportECardOperate: Bool
    /// 支持语音备忘录功能
    let getSupportVoiceMemoOperate: Bool
    /// 支持晨报功能
    let getSupportMorningEdition: Bool
    /// 支持app获取血氧饱和度开关
    let getSupportGetSpo2SwitchInfo: Bool
    /// 支持同步心率使用version字段兼容
    let getSupportSyncHealthHrUseVersionCompatible: Bool
    /// v3天气设置增加下发48小时天气数据
    let getSupportSetV3Add48HourWeatherData: Bool
    /// 功能表开启后,室内跑步不支持获取最大摄氧量,app室内跑步不展示此数据
    let getNotSupportIndoorRunGetVo2max: Bool
    /// 支持app设置心电图测量提醒
    let getSupportSetEcgReminder: Bool
    /// 支持同步心电图(ecg)数据
    let getSupportSyncEcg: Bool
    /// 支持游戏时间设置
    let getSupportSetGameTimeReminder: Bool
    /// 支持配置默认的消息应用列表
    let getSupportConfigDefaultMegApplicationList: Bool
    /// 支持app设置eci
    let getSupportSetEciReminder: Bool
    /// 环境音量支持设置通知类型
    let setSupportNoiseSetNotifyFlag: Bool
    /// 环境音量支持设置过高提醒
    let setSupportNoiseSetOverWarning: Bool
    /// 支持设置版本信息
    let setSupportSetVersionInformation: Bool
    /// 支持小程序操作
    let setSupportControlMiniProgram: Bool
    /// 支持下发未来和历史空气质量数据
    let getSupportSetWeatherHistoryFutureAqi: Bool
    /// 支持设置亮屏亮度时间
    let setBrightScreenTime: Bool
    /// 支持设置心率过高过低提醒
    let setHeartSetRateModeCustom: Bool
    /// 支持查询、设置 v3菜单列表
    let supportProtocolV3MenuList: Bool
    /// 中文
    let languageCh: Bool
    /// 捷克文
    let languageCzech: Bool
    /// 英文
    let languageEnglish: Bool
    /// 法文
    let languageFrench: Bool
    /// 德文
    let languageGerman: Bool
    /// 意大利文
    let languageItalian: Bool
    /// 日文
    let languageJapanese: Bool
    /// 西班牙文
    let languageSpanish: Bool
    /// 阿拉伯语
    let languageArabic: Bool
    /// 缅甸语
    let languageBurmese: Bool
    /// 菲律宾语
    let languageFilipino: Bool
    /// 希腊语
    let languageGreek: Bool
    /// 泰国语
    let languageThai: Bool
    /// 繁体中文
    let languageTraditionalChinese: Bool
    /// 越南语
    let languageVietnamese: Bool
    /// 荷兰文
    let languageDutch: Bool
    /// 匈牙利文
    let languageHungarian: Bool
    /// 立陶宛文
    let languageLithuanian: Bool
    /// 波兰文
    let languagePolish: Bool
    /// 罗马尼亚文
    let languageRomanian: Bool
    /// 俄罗斯文
    let languageRussian: Bool
    /// 斯洛文尼亚文
    let languageSlovenian: Bool
    /// 乌克兰文
    let languageUkrainian: Bool
    /// 克罗地亚语
    let languageCroatian: Bool
    /// 丹麦语
    let languageDanish: Bool
    /// 印地语
    let languageHindi: Bool
    /// 印尼语
    let languageIndonesian: Bool
    /// 韩语
    let languageKorean: Bool
    /// 葡萄牙语
    let languagePortuguese: Bool
    /// 斯洛伐克语
    let languageSlovak: Bool
    /// 土耳其
    let languageTurkish: Bool
    /// 波斯语
    let languagePersia: Bool
    /// 瑞典语
    let languageSweden: Bool
    /// 挪威语
    let languageNorwegian: Bool
    /// 芬兰语
    let languageFinland: Bool
    /// 孟加拉语
    let languageBengali: Bool
    /// 高棉语
    let languageKhmer: Bool
    /// 马来语
    let languageMalay: Bool
    /// 巴西葡语
    let languageBrazilianPortuguese: Bool
    /// 希伯来语
    let languageHebrew: Bool
    /// 塞尔维亚语
    let languageSerbian: Bool
    /// 保加利亚
    let languageBulgaria: Bool
    /// v3 心率
    let syncV3Hr: Bool
    /// v3 游泳
    let syncV3Swim: Bool
    /// v3 血氧
    let syncV3Spo2: Bool
    /// v3 压力
    let syncV3Pressure: Bool
    /// v3 多运动
    let syncV3Activity: Bool
    /// v3 睡眠
    let syncV3Sleep: Bool
    /// v3 宠物睡眠
    let syncV3PetSleep: Bool
    /// v3 步数
    let syncV3Sports: Bool
    /// v3 gps
    let syncV3Gps: Bool
    /// v3 闹钟
    let syncV3SyncAlarm: Bool
    /// v3 身体电量
    let syncV3BodyPower: Bool
    /// 同步hrv
    let getSupportHrvV3: Bool
    /// 同步血压
    let getSupportPerBpV3: Bool
    /// 同步噪音
    let syncV3Noise: Bool
    /// 同步温度
    let syncV3Temperature: Bool
    /// gps
    let syncGps: Bool
    /// v3多运动同步数据交换
    let syncV3ActivityExchangeData: Bool
    /// 心率功能
    let syncHeartRate: Bool
    /// 心率监测
    let syncHeartRateMonitor: Bool
    /// 睡眠检测
    let syncSleepMonitor: Bool
    /// 快速同步
    let syncFastSync: Bool
    /// 获取时间同步
    let syncActivityTimeSync: Bool
    /// v2同步 时间线
    let syncTimeLine: Bool
    /// 需要V2的同步
    let syncNeedV2: Bool
    /// v3多运动同步支持实时速度显示
    let syncRealTimeV3: Bool
    /// 数据交换增加实时的配速字段
    let syncExchangeDataReplyAddRealTimeSpeedPaceV3: Bool
    /// 多运行结束时间使用UTC模式
    let syncHealthSyncV3ActivityEndTimeUseUtcMode: Bool
    /// 支持数据同步时开启快速模式
    let syncSupportSetFastModeWhenSyncConfig: Bool
    /// 支持获取app基本信息
    let getSupportAppBaseInformation: Bool
    /// 闹钟个数
    let alarmCount: Int
    /// 刷牙
    let alarmBrushTeeth: Bool
    /// 约会
    let alarmDating: Bool
    /// 吃饭
    let alarmDinner: Bool
    /// 吃药
    let alarmMedicine: Bool
    /// 会议
    let alarmMeeting: Bool
    /// 聚会
    let alarmParty: Bool
    /// 休息
    let alarmRest: Bool
    /// 睡觉
    let alarmSleep: Bool
    /// 锻炼
    let alarmSport: Bool
    /// 起床
    let alarmWakeUp: Bool
    /// 支持设置防丢
    let supportSetAntilost: Bool
    /// 支持设置v2天气数据
    let supportSetWeatherDataV2: Bool
    /// 支持设置一键呼叫
    let supportSetOnetouchCalling: Bool
    /// 支持设置运动中屏幕显示
    let supportOperateSetSportScreen: Bool
    /// 支持设置应用列表样式
    let supportOperateListStyle: Bool
    /// 支持情绪健康
    let supportEmotionHealth: Bool
    /// 支持v3同步通讯录版本20
    let supportV3SyncContactVersion20: Bool
    /// 支持SOS通话记录查询
    let supportGetSosCallRecord: Bool
    /// alexa 语音提醒增加对应的时钟传输字段
    let alexaReminderAddSecV3: Bool
    /// alexa 简单控制命令
    let alexaSetEasyOperateV3: Bool
    /// alexa 语音闹钟获取设置命令使用
    let alexaSetGetAlexaAlarmV3: Bool
    /// alexa 设置跳转运动界面
    let alexaSetJumpSportUiV3: Bool
    /// alexa 设置跳转ui界面
    let alexaSetJumpUiV3: Bool
    /// alexa app设置开关命令
    let alexaSetSetOnOffTypeV3: Bool
    /// alexa 语音支持设置天气
    let alexaSetWeatherV3: Bool
    /// alexa 支持设置多个定时器
    let alexaTimeNewV3: Bool
    /// alexa 100级亮度控制
    let setAlexaControll100brightness: Bool
    /// alexa 获取alexa默认语言
    let alexaGetSupportGetAlexaDefaultLanguage: Bool
    /// alexa跳转运动界面支持100种运动类型字段
    let alexaGetUIControllSports: Bool
    /// 支持获取左右手佩戴设置
    let getLeftRightHandWearSettings: Bool
    /// 支持支持运动中设置提示音
    let supportSettingsDuringExercise: Bool
    /// 支持身高单位设置(厘米/英寸)
    let supportHeightLengthUnit: Bool
    /// 支持运动中提醒设置
    let supportSportingRemindSetting: Bool
    /// 支持获取运动是否支持自动暂停结束
    let supportSportGetAutoPauseEnd: Bool
    /// 支持步幅长度的单位设置(公制/英制)
    let supportSetStrideLengthUnit: Bool
    /// 支持简单心率区间
    let supportSimpleHrZoneSetting: Bool
    /// 开启功能表则关闭智能心率过低提醒
    let notSupportSmartLowHeartReatRemind: Bool
    /// 开启功能表则关闭智能心率过高提醒
    let notSupportSmartHighHeartReatRemind: Bool
    /// 设备是否不支持拍照推流
    let notSupportPhotoPreviewControl: Bool
    /// 支持获取用户信息
    let supportGetUserInfo: Bool
    /// 支持未接来电消息类型为485
    let supportMissedCallMsgTypeUseFixed: Bool
    /// 支持闹钟不显示闹钟名称
    let supportAppNotDisplayAlarmName: Bool
    /// 支持设置睡眠提醒
    let supportSetSleepRemind: Bool
    /// 支持血糖
    let supportBloodGlucose: Bool
    /// 支持血糖(v01)
    let supportBloodGlucoseV01: Bool
    /// 车锁管理
    let supportBikeLockManager: Bool
    /// 支持算法数据的采集
    let supportAlgorithmRawDataCollect: Bool
    /// 支持离线地图
    let supportOfflineMapInformation: Bool
    /// 开启则⽀持储备⼼率区间,关闭默认⽀持的最⼤⼼率区间
    let supportHeartRateReserveZones: Bool
    /// 开启则⽀持⼼率区间⼼率最⼤值设置
    let supportHeartRateZonesHrMaxSet: Bool
    /// 支持新的同步多运动数据（同步多运动/游泳/跑步课程/跑步计划/跑后拉伸数据）
    let supportSyncMultiActivityNew: Bool
    /// 联系人存储支持使用固件返回大小
    let supportContactFileUseFirmwareReturnSize: Bool
    /// 控制APP是否显示相机入口
    let supportDisplayCameraEntry: Bool
    /// 支持家庭关心提醒设置
    let supportOperateFamilyCareReminder3376: Bool
    /// 支持设置获取经期配置，使用v3长包指令
    let supportProtocolV3MenstruationConfig3377: Bool
    /// 支持习惯养成设置
    let supportOperateHabitFormation: Bool
    /// 支持版本v01习惯养成设置
    let supportOperateHabitFormationV01: Bool
    /// 支持家庭步数下发
    let supportOperateFamilySteps: Bool
    /// 支持游戏设置
    let supportOperateSetGame: Bool
    /// 支持手势控制功能
    let supportOperateGestureControl: Bool

    
    public init(
        reminderAncs: Bool,
        reminderSnapchat: Bool,
        reminderLine: Bool,
        reminderOutlook: Bool,
        reminderTelegram: Bool,
        reminderViber: Bool,
        reminderVkontakte: Bool,
        reminderChatwork: Bool,
        reminderSlack: Bool,
        reminderTumblr: Bool,
        reminderYahooMail: Bool,
        reminderYahooPinterest: Bool,
        reminderYoutube: Bool,
        reminderGmail: Bool,
        reminderKakaoTalk: Bool,
        reminderOnlyGoogleGmail: Bool,
        reminderOnlyOutlookEmail: Bool,
        reminderOnlyYahooEmail: Bool,
        reminderTiktok: Bool,
        reminderRedbus: Bool,
        reminderDailyhunt: Bool,
        reminderHotstar: Bool,
        reminderInshorts: Bool,
        reminderPaytm: Bool,
        reminderAmazon: Bool,
        reminderFlipkart: Bool,
        reminderNhnEmail: Bool,
        reminderInstantEmail: Bool,
        reminderZohoEmail: Bool,
        reminderExchangeEmail: Bool,
        reminder189Email: Bool,
        reminderVeryFit: Bool,
        reminderGeneral: Bool,
        reminderOther: Bool,
        reminderMattersRemind: Bool,
        reminderMicrosoft: Bool,
        reminderMissedCall: Bool,
        reminderGetAllContact: Bool,
        reminderWhatsappBusiness: Bool,
        reminderEmail: Bool,
        reminderFacebook: Bool,
        reminderMessage: Bool,
        reminderQq: Bool,
        reminderTwitter: Bool,
        reminderWeixin: Bool,
        reminderCalendarGoogle: Bool,
        reminderInstagram: Bool,
        reminderLinkedIn: Bool,
        reminderMessengre: Bool,
        reminderSkype: Bool,
        reminderCalendar: Bool,
        reminderWhatsapp: Bool,
        reminderAlarmClock: Bool,
        reminderSinaWeibo: Bool,
        reminderWeibo: Bool,
        reminderCalling: Bool,
        reminderCallContact: Bool,
        reminderCallNum: Bool,
        reminderPrime: Bool,
        reminderNetflix: Bool,
        reminderGpay: Bool,
        reminderPhonpe: Bool,
        reminderSwiggy: Bool,
        reminderZomato: Bool,
        reminderMakemytrip: Bool,
        reminderJioTv: Bool,
        reminderNiosefit: Bool,
        reminderYtmusic: Bool,
        reminderUber: Bool,
        reminderOla: Bool,
        reminderGoogleMeet: Bool,
        reminderMormaiiSmartwatch: Bool,
        reminderTechnosConnect: Bool,
        reminderEnjoei: Bool,
        reminderAliexpress: Bool,
        reminderShopee: Bool,
        reminderTeams: Bool,
        reminder99Taxi: Bool,
        reminderUberEats: Bool,
        reminderLfood: Bool,
        reminderRappi: Bool,
        reminderMercadoLivre: Bool,
        reminderMagalu: Bool,
        reminderAmericanas: Bool,
        reminderYahoo: Bool,
        reminderMessageIcon: Bool,
        reminderTaobao: Bool,
        reminderDingding: Bool,
        reminderAlipay: Bool,
        reminderToutiao: Bool,
        reminderDouyin: Bool,
        reminderTmall: Bool,
        reminderJd: Bool,
        reminderPinduoduo: Bool,
        reminderBaidu: Bool,
        reminderMeituan: Bool,
        reminderEleme: Bool,
        sportWalk: Bool,
        sportRun: Bool,
        sportByBike: Bool,
        sportOnFoot: Bool,
        sportSwim: Bool,
        sportMountainClimbing: Bool,
        sportBadminton: Bool,
        sportOther: Bool,
        sportFitness: Bool,
        sportSpinning: Bool,
        sportEllipsoid: Bool,
        sportTreadmill: Bool,
        sportSitUp: Bool,
        sportPushUp: Bool,
        sportDumbbell: Bool,
        sportWeightlifting: Bool,
        sportBodybuildingExercise: Bool,
        sportYoga: Bool,
        sportRopeSkipping: Bool,
        sportTableTennis: Bool,
        sportBasketball: Bool,
        sportFootballl: Bool,
        sportVolleyball: Bool,
        sportTennis: Bool,
        sportGolf: Bool,
        sportBaseball: Bool,
        sportSkiing: Bool,
        sportRollerSkating: Bool,
        sportDance: Bool,
        sportStrengthTraining: Bool,
        sportCoreTraining: Bool,
        sportTidyUpRelax: Bool,
        sportTraditionalStrengthTraining: Bool,
        sportOutdoorRun: Bool,
        sportIndoorRun: Bool,
        sportOutdoorCycle: Bool,
        sportIndoorCycle: Bool,
        sportOutdoorWalk: Bool,
        sportIndoorWalk: Bool,
        sportPoolSwim: Bool,
        sportOpenWaterSwim: Bool,
        sportElliptical: Bool,
        sportRower: Bool,
        sportHiit: Bool,
        sportCricket: Bool,
        sportPilates: Bool,
        sportOutdoorFun: Bool,
        sportOtherActivity: Bool,
        sportZumba: Bool,
        sportSurfing: Bool,
        sportFootvolley: Bool,
        sportStandWaterSkiing: Bool,
        sportBattlingRope: Bool,
        sportSkateboard: Bool,
        sportNoticeStepper: Bool,
        sportShowNum: Int,
        sportAerobicsBodybuildingExercise: Bool,
        sportPullUp: Bool,
        sportHighBar: Bool,
        sportParallelBars: Bool,
        sportTrailRunning: Bool,
        sportPickleBall: Bool,
        sportSnowboard: Bool,
        sportCrossCountrySkiing: Bool,
        getRealtimeData: Bool,
        getLangLibraryV3: Bool,
        getFindPhone: Bool,
        getFindDevice: Bool,
        getUpHandGestureEx: Bool,
        getUpHandGesture: Bool,
        getWeather: Bool,
        getDownloadLanguage: Bool,
        getFactoryReset: Bool,
        getFlashLog: Bool,
        getMultiActivityNoUseApp: Bool,
        getMultiDial: Bool,
        getMenuList: Bool,
        getDoNotDisturbMain3: Bool,
        getVoiceTransmission: Bool,
        setDrinkWaterAddNotifyFlag: Bool,
        setSpo2LowValueRemindAddNotifyFlag: Bool,
        notSupportSmartHeartNotifyFlag: Bool,
        getDeviceLogState: Bool,
        getNewWatchList: Bool,
        getNotifyIconAdaptive: Bool,
        getPressureNotifyFlagMode: Bool,
        getScientificSleep: Bool,
        getSpo2NotifyFlag: Bool,
        getV3Log: Bool,
        getWatchID: Bool,
        getDeviceName: Bool,
        getBatteryLog: Bool,
        getBatteryInfo: Bool,
        getHeatLog: Bool,
        getWalkReminderV3: Bool,
        getSupportV3BleMusic: Bool,
        getSupportGetBleBeepV3: Bool,
        getVeryFitNotSupportPhotoWallpaperV3: Bool,
        getSupportUpdateGps: Bool,
        getUbloxModel: Bool,
        getSupportGetBleMusicInfoVerV3: Bool,
        getBtVersion: Bool,
        getSportsTypeV3: Bool,
        getActivitySwitch: Bool,
        getNoticeIconInformation: Bool,
        getSetMaxItemsNum: Bool,
        getNotifyMsgV3: Bool,
        getScreenBrightnessMain9: Bool,
        getNotice128byte: Bool,
        getNotice250byte: Bool,
        getDeletableMenuListV2: Bool,
        getSupportPairEachConnect: Bool,
        getSupportGetMainSportGoalV3: Bool,
        getBtAddrV2: Bool,
        getSupportBpSetOrMeasurementV2: Bool,
        getMenstrualAddNotifyFlagV3: Bool,
        getSupportSetGetTimeGoalTypeV2: Bool,
        getOxygenDataSupportGradeV3: Bool,
        getSupportSyncActivityDataAltitudeInfo: Bool,
        getBindCodeAuth: Bool,
        getSpo2OffChangeV3: Bool,
        getLevel5HrInterval: Bool,
        getFiveHRInterval: Bool,
        getBleAndBtVersion: Bool,
        getSupportSetGetEmergencyContactV3: Bool,
        getSupportSetRepeatWeekTypeOnScheduleReminderV3: Bool,
        getSupportSetRepeatTypeOnScheduleReminderV3: Bool,
        getSupportSetMenstrualReminderOnOff: Bool,
        getVersionInfo: Bool,
        getMtu: Bool,
        getDeviceUpdateState: Bool,
        getHeartRateModeV2: Bool,
        getStepDataTypeV2: Bool,
        getFastMsgDataV3: Bool,
        getSupportCallingQuickReply: Bool,
        getSupportDataTranGetNewErrorCodeV3: Bool,
        getAutoActivityEndSwitchNotDisplay: Bool,
        getAutoActivityPauseSwitchNotDisplay: Bool,
        getV3AutoActivitySwitch: Bool,
        getAutoActivitySwitchAddBicycle: Bool,
        getAutoActivitySwitchAddSmartRope: Bool,
        getAutoActivitySetGetUseNewStructExchange: Bool,
        getSupportSetGetNoReminderOnWalkReminderV2: Bool,
        getSupportGetSnInfo: Bool,
        getScheduleReminderNotDisplayTitle: Bool,
        getSupportV3LongCityName: Bool,
        getSupportAddNightLevelV2: Bool,
        getSupportDialFrameEncodeFormatArgb6666: Bool,
        getSupportAppSendPhoneSystemInfo: Bool,
        getDeviceControlFastModeAlone: Bool,
        getSupportOnekeyDoubleContact: Bool,
        getSupportSetVoiceAssistantStatus: Bool,
        getSupportFlashLogSize: Bool,
        supportDevReturnMeasuringValue: Bool,
        getSupportGetUnit: Bool,
        getSupportRyzeConnect: Bool,
        getSupportLoopsFit: Bool,
        getSupportTasSmart: Bool,
        getNotSupportSetOvulation: Bool,
        getSupportWalkGoalSteps: Bool,
        getNotSupportDeleteAddSportSort: Bool,
        getSupportSedentaryTensileHabitInfo: Bool,
        getSupportSendGpsLongitudeAndLatitude: Bool,
        getSupportGetV3DeviceBtConnectPhoneModel: Bool,
        getSupportBloodPressureModelFileUpdate: Bool,
        getSupportDisturbHaveRangRepeat: Bool,
        getSupportCalendarReminder: Bool,
        getWatchDailSetAddSize: Bool,
        getSupportSyncOverHighLowHeartData: Bool,
        getSupportPerMinuteOne: Bool,
        getSupportAchievedRemindOnOff: Bool,
        getSupportDrinkPlan: Bool,
        getSupportMakeWatchDialDecodeJpg: Bool,
        getSupportSleepPlan: Bool,
        getSupportDeviceOperateAlgFile: Bool,
        getSupportSportRecordShowConfig: Bool,
        setNoticeMessageStateUseVersion0x20: Bool,
        setScientificSleepSwitch: Bool,
        setTemperatureSwitchHealth: Bool,
        setHeartRateMonitor: Bool,
        setNoReminderOnDrinkReminder: Bool,
        setAgpsOffLine: Bool,
        setAgpsOnLine: Bool,
        setSetV3HeartInterval: Bool,
        setWeatherCity: Bool,
        setDoNotDisturb: Bool,
        setCalorieGoal: Bool,
        setMenstruation: Bool,
        setPressureData: Bool,
        setSpo2Data: Bool,
        setSportModeSort: Bool,
        setActivitySwitch: Bool,
        setNightAutoBrightness: Bool,
        setScreenBrightness5Level: Bool,
        setWalkReminder: Bool,
        setScreenBrightness3Level: Bool,
        setHandWashReminder: Bool,
        setLocalDial: Bool,
        setNotSupportHrHighAlarm: Bool,
        setNotSupportPhotoWallpaper: Bool,
        setPressureHighReminder: Bool,
        setWallpaperOnlyTimeColor: Bool,
        setWallpaperDial: Bool,
        setSupportBreathRate: Bool,
        setSupportCalorieUnit: Bool,
        setSupportSportPlan: Bool,
        setSupportSwimPoolUnit: Bool,
        setSupportV3Bp: Bool,
        setV3GetSportSortField: Bool,
        setWatchDialSort: Bool,
        setGetCalorieDistanceGoal: Bool,
        setMidHighTimeGoal: Bool,
        setNewRetainData: Bool,
        setScheduleReminder: Bool,
        setSet100SportSort: Bool,
        setSet20SportParamSort: Bool,
        setSetMainUiSort: Bool,
        setSetStressCalibration: Bool,
        setSmartHeartRate: Bool,
        setSpo2AllDayOnOff: Bool,
        setSupportAppSendVoiceToBle: Bool,
        setSupportCyclingUnit: Bool,
        setSupportWalkRunUnit: Bool,
        setWalkReminderTimeGoal: Bool,
        setWatchCapacitySizeDisplay: Bool,
        setWatchPhotoPositionMove: Bool,
        setMenuListMain7: Bool,
        setHistoryMenstrual: Bool,
        supportHistoricalMenstruationExchange: Bool,
        supportSetHistoricalMenstruationExchangeVersion21: Bool,
        supportHistoricalMenstruationExchangeVersion31: Bool,
        supportPhysiologicalRecord: Bool,
        setMenstrualAddPregnancy: Bool,
        setNotSurportCalling3SDelay: Bool,
        setSetFitnessGuidance: Bool,
        setSetNotificationStatus: Bool,
        setSetUnreadAppReminder: Bool,
        setSetV3Weather: Bool,
        setSetV3WeatherSunrise: Bool,
        setSetV3WorldTime: Bool,
        setSyncContact: Bool,
        setSyncV3ActivityAddParam: Bool,
        setTransferMusicFile: Bool,
        setWalkReminderAddNotify: Bool,
        setSupportFahrenheit: Bool,
        setGetAlarmSpecify: Bool,
        setAirohaGpsChip: Bool,
        setSupportSecondSportIcon: Bool,
        setSportMediumIcon: Bool,
        setWeatherSunTime: Bool,
        setWeatherAirGrade: Bool,
        setDrinkWaterReminder: Bool,
        supportBatteryReminderSwitch: Bool,
        supportPetInfo: Bool,
        setRespirationRate: Bool,
        setMaxBloodOxygen: Bool,
        setBleControlMusic: Bool,
        setMainPressure: Bool,
        setNoDisturbAllDayOnOff: Bool,
        setOnlyNoDisturbAllDayOnOff: Bool,
        setOnlyNoDisturbSmartOnOff: Bool,
        setTimeZoneFloat: Bool,
        setTemperatureSwitchSupport: Bool,
        setMsgAllSwitch: Bool,
        setNotSupperCall3Delay: Bool,
        setNoticeMissedCallV2: Bool,
        setOverFindPhone: Bool,
        getHealthSwitchStateSupportV3: Bool,
        setSedentariness: Bool,
        setScreenBrightness: Bool,
        setSetPhoneVoice: Bool,
        setSupportSetCallQuickReplyOnOff: Bool,
        setSupportExchangeSetGpsCoordinates: Bool,
        setSupportV3WeatherAddAtmosphericPressure: Bool,
        setSupportSetV3WeatcherAddSnowDepth: Bool,
        setSupportSetV3WeatcherAddSnowfall: Bool,
        setSupportSetV3WeatcherSendStructVersion04: Bool,
        setSendCalibrationThreshold: Bool,
        getNotSupportAppSendRunPlan: Bool,
        getSupportDisplayNapSleep: Bool,
        getSupportGetSmartHeartRate: Bool,
        getSupportGetPressureSwitchInfo: Bool,
        getSupportECardOperate: Bool,
        getSupportVoiceMemoOperate: Bool,
        getSupportMorningEdition: Bool,
        getSupportGetSpo2SwitchInfo: Bool,
        getSupportSyncHealthHrUseVersionCompatible: Bool,
        getSupportSetV3Add48HourWeatherData: Bool,
        getNotSupportIndoorRunGetVo2max: Bool,
        getSupportSetEcgReminder: Bool,
        getSupportSyncEcg: Bool,
        getSupportSetGameTimeReminder: Bool,
        getSupportConfigDefaultMegApplicationList: Bool,
        getSupportSetEciReminder: Bool,
        setSupportNoiseSetNotifyFlag: Bool,
        setSupportNoiseSetOverWarning: Bool,
        setSupportSetVersionInformation: Bool,
        setSupportControlMiniProgram: Bool,
        getSupportSetWeatherHistoryFutureAqi: Bool,
        setBrightScreenTime: Bool,
        setHeartSetRateModeCustom: Bool,
        supportProtocolV3MenuList: Bool,
        languageCh: Bool,
        languageCzech: Bool,
        languageEnglish: Bool,
        languageFrench: Bool,
        languageGerman: Bool,
        languageItalian: Bool,
        languageJapanese: Bool,
        languageSpanish: Bool,
        languageArabic: Bool,
        languageBurmese: Bool,
        languageFilipino: Bool,
        languageGreek: Bool,
        languageThai: Bool,
        languageTraditionalChinese: Bool,
        languageVietnamese: Bool,
        languageDutch: Bool,
        languageHungarian: Bool,
        languageLithuanian: Bool,
        languagePolish: Bool,
        languageRomanian: Bool,
        languageRussian: Bool,
        languageSlovenian: Bool,
        languageUkrainian: Bool,
        languageCroatian: Bool,
        languageDanish: Bool,
        languageHindi: Bool,
        languageIndonesian: Bool,
        languageKorean: Bool,
        languagePortuguese: Bool,
        languageSlovak: Bool,
        languageTurkish: Bool,
        languagePersia: Bool,
        languageSweden: Bool,
        languageNorwegian: Bool,
        languageFinland: Bool,
        languageBengali: Bool,
        languageKhmer: Bool,
        languageMalay: Bool,
        languageBrazilianPortuguese: Bool,
        languageHebrew: Bool,
        languageSerbian: Bool,
        languageBulgaria: Bool,
        syncV3Hr: Bool,
        syncV3Swim: Bool,
        syncV3Spo2: Bool,
        syncV3Pressure: Bool,
        syncV3Activity: Bool,
        syncV3Sleep: Bool,
        syncV3PetSleep: Bool,
        syncV3Sports: Bool,
        syncV3Gps: Bool,
        syncV3SyncAlarm: Bool,
        syncV3BodyPower: Bool,
        getSupportHrvV3: Bool,
        getSupportPerBpV3: Bool,
        syncV3Noise: Bool,
        syncV3Temperature: Bool,
        syncGps: Bool,
        syncV3ActivityExchangeData: Bool,
        syncHeartRate: Bool,
        syncHeartRateMonitor: Bool,
        syncSleepMonitor: Bool,
        syncFastSync: Bool,
        syncActivityTimeSync: Bool,
        syncTimeLine: Bool,
        syncNeedV2: Bool,
        syncRealTimeV3: Bool,
        syncExchangeDataReplyAddRealTimeSpeedPaceV3: Bool,
        syncHealthSyncV3ActivityEndTimeUseUtcMode: Bool,
        syncSupportSetFastModeWhenSyncConfig: Bool,
        getSupportAppBaseInformation: Bool,
        alarmCount: Int,
        alarmBrushTeeth: Bool,
        alarmDating: Bool,
        alarmDinner: Bool,
        alarmMedicine: Bool,
        alarmMeeting: Bool,
        alarmParty: Bool,
        alarmRest: Bool,
        alarmSleep: Bool,
        alarmSport: Bool,
        alarmWakeUp: Bool,
        supportSetAntilost: Bool,
        supportSetWeatherDataV2: Bool,
        supportSetOnetouchCalling: Bool,
        supportOperateSetSportScreen: Bool,
        supportOperateListStyle: Bool,
        supportEmotionHealth: Bool,
        supportV3SyncContactVersion20: Bool,
        supportGetSosCallRecord: Bool,
        alexaReminderAddSecV3: Bool,
        alexaSetEasyOperateV3: Bool,
        alexaSetGetAlexaAlarmV3: Bool,
        alexaSetJumpSportUiV3: Bool,
        alexaSetJumpUiV3: Bool,
        alexaSetSetOnOffTypeV3: Bool,
        alexaSetWeatherV3: Bool,
        alexaTimeNewV3: Bool,
        setAlexaControll100brightness: Bool,
        alexaGetSupportGetAlexaDefaultLanguage: Bool,
        alexaGetUIControllSports: Bool,
        getLeftRightHandWearSettings: Bool,
        supportSettingsDuringExercise: Bool,
        supportHeightLengthUnit: Bool,
        supportSportingRemindSetting: Bool,
        supportSportGetAutoPauseEnd: Bool,
        supportSetStrideLengthUnit: Bool,
        supportSimpleHrZoneSetting: Bool,
        notSupportSmartLowHeartReatRemind: Bool,
        notSupportSmartHighHeartReatRemind: Bool,
        notSupportPhotoPreviewControl: Bool,
        supportGetUserInfo: Bool,
        supportMissedCallMsgTypeUseFixed: Bool,
        supportAppNotDisplayAlarmName: Bool,
        supportSetSleepRemind: Bool,
        supportBloodGlucose: Bool,
        supportBloodGlucoseV01: Bool,
        supportBikeLockManager: Bool,
        supportAlgorithmRawDataCollect: Bool,
        supportOfflineMapInformation: Bool,
        supportHeartRateReserveZones: Bool,
        supportHeartRateZonesHrMaxSet: Bool,
        supportSyncMultiActivityNew: Bool,
        supportContactFileUseFirmwareReturnSize: Bool,
        supportDisplayCameraEntry: Bool,
        supportOperateFamilyCareReminder3376: Bool,
        supportProtocolV3MenstruationConfig3377: Bool,
        supportOperateHabitFormation: Bool,
        supportOperateHabitFormationV01: Bool,
        supportOperateFamilySteps: Bool,
        supportOperateSetGame: Bool,
        supportOperateGestureControl: Bool
    ) {
        self.reminderAncs = reminderAncs
        self.reminderSnapchat = reminderSnapchat
        self.reminderLine = reminderLine
        self.reminderOutlook = reminderOutlook
        self.reminderTelegram = reminderTelegram
        self.reminderViber = reminderViber
        self.reminderVkontakte = reminderVkontakte
        self.reminderChatwork = reminderChatwork
        self.reminderSlack = reminderSlack
        self.reminderTumblr = reminderTumblr
        self.reminderYahooMail = reminderYahooMail
        self.reminderYahooPinterest = reminderYahooPinterest
        self.reminderYoutube = reminderYoutube
        self.reminderGmail = reminderGmail
        self.reminderKakaoTalk = reminderKakaoTalk
        self.reminderOnlyGoogleGmail = reminderOnlyGoogleGmail
        self.reminderOnlyOutlookEmail = reminderOnlyOutlookEmail
        self.reminderOnlyYahooEmail = reminderOnlyYahooEmail
        self.reminderTiktok = reminderTiktok
        self.reminderRedbus = reminderRedbus
        self.reminderDailyhunt = reminderDailyhunt
        self.reminderHotstar = reminderHotstar
        self.reminderInshorts = reminderInshorts
        self.reminderPaytm = reminderPaytm
        self.reminderAmazon = reminderAmazon
        self.reminderFlipkart = reminderFlipkart
        self.reminderNhnEmail = reminderNhnEmail
        self.reminderInstantEmail = reminderInstantEmail
        self.reminderZohoEmail = reminderZohoEmail
        self.reminderExchangeEmail = reminderExchangeEmail
        self.reminder189Email = reminder189Email
        self.reminderVeryFit = reminderVeryFit
        self.reminderGeneral = reminderGeneral
        self.reminderOther = reminderOther
        self.reminderMattersRemind = reminderMattersRemind
        self.reminderMicrosoft = reminderMicrosoft
        self.reminderMissedCall = reminderMissedCall
        self.reminderGetAllContact = reminderGetAllContact
        self.reminderWhatsappBusiness = reminderWhatsappBusiness
        self.reminderEmail = reminderEmail
        self.reminderFacebook = reminderFacebook
        self.reminderMessage = reminderMessage
        self.reminderQq = reminderQq
        self.reminderTwitter = reminderTwitter
        self.reminderWeixin = reminderWeixin
        self.reminderCalendarGoogle = reminderCalendarGoogle
        self.reminderInstagram = reminderInstagram
        self.reminderLinkedIn = reminderLinkedIn
        self.reminderMessengre = reminderMessengre
        self.reminderSkype = reminderSkype
        self.reminderCalendar = reminderCalendar
        self.reminderWhatsapp = reminderWhatsapp
        self.reminderAlarmClock = reminderAlarmClock
        self.reminderSinaWeibo = reminderSinaWeibo
        self.reminderWeibo = reminderWeibo
        self.reminderCalling = reminderCalling
        self.reminderCallContact = reminderCallContact
        self.reminderCallNum = reminderCallNum
        self.reminderPrime = reminderPrime
        self.reminderNetflix = reminderNetflix
        self.reminderGpay = reminderGpay
        self.reminderPhonpe = reminderPhonpe
        self.reminderSwiggy = reminderSwiggy
        self.reminderZomato = reminderZomato
        self.reminderMakemytrip = reminderMakemytrip
        self.reminderJioTv = reminderJioTv
        self.reminderNiosefit = reminderNiosefit
        self.reminderYtmusic = reminderYtmusic
        self.reminderUber = reminderUber
        self.reminderOla = reminderOla
        self.reminderGoogleMeet = reminderGoogleMeet
        self.reminderMormaiiSmartwatch = reminderMormaiiSmartwatch
        self.reminderTechnosConnect = reminderTechnosConnect
        self.reminderEnjoei = reminderEnjoei
        self.reminderAliexpress = reminderAliexpress
        self.reminderShopee = reminderShopee
        self.reminderTeams = reminderTeams
        self.reminder99Taxi = reminder99Taxi
        self.reminderUberEats = reminderUberEats
        self.reminderLfood = reminderLfood
        self.reminderRappi = reminderRappi
        self.reminderMercadoLivre = reminderMercadoLivre
        self.reminderMagalu = reminderMagalu
        self.reminderAmericanas = reminderAmericanas
        self.reminderYahoo = reminderYahoo
        self.reminderMessageIcon = reminderMessageIcon
        self.reminderTaobao = reminderTaobao
        self.reminderDingding = reminderDingding
        self.reminderAlipay = reminderAlipay
        self.reminderToutiao = reminderToutiao
        self.reminderDouyin = reminderDouyin
        self.reminderTmall = reminderTmall
        self.reminderJd = reminderJd
        self.reminderPinduoduo = reminderPinduoduo
        self.reminderBaidu = reminderBaidu
        self.reminderMeituan = reminderMeituan
        self.reminderEleme = reminderEleme
        self.sportWalk = sportWalk
        self.sportRun = sportRun
        self.sportByBike = sportByBike
        self.sportOnFoot = sportOnFoot
        self.sportSwim = sportSwim
        self.sportMountainClimbing = sportMountainClimbing
        self.sportBadminton = sportBadminton
        self.sportOther = sportOther
        self.sportFitness = sportFitness
        self.sportSpinning = sportSpinning
        self.sportEllipsoid = sportEllipsoid
        self.sportTreadmill = sportTreadmill
        self.sportSitUp = sportSitUp
        self.sportPushUp = sportPushUp
        self.sportDumbbell = sportDumbbell
        self.sportWeightlifting = sportWeightlifting
        self.sportBodybuildingExercise = sportBodybuildingExercise
        self.sportYoga = sportYoga
        self.sportRopeSkipping = sportRopeSkipping
        self.sportTableTennis = sportTableTennis
        self.sportBasketball = sportBasketball
        self.sportFootballl = sportFootballl
        self.sportVolleyball = sportVolleyball
        self.sportTennis = sportTennis
        self.sportGolf = sportGolf
        self.sportBaseball = sportBaseball
        self.sportSkiing = sportSkiing
        self.sportRollerSkating = sportRollerSkating
        self.sportDance = sportDance
        self.sportStrengthTraining = sportStrengthTraining
        self.sportCoreTraining = sportCoreTraining
        self.sportTidyUpRelax = sportTidyUpRelax
        self.sportTraditionalStrengthTraining = sportTraditionalStrengthTraining
        self.sportOutdoorRun = sportOutdoorRun
        self.sportIndoorRun = sportIndoorRun
        self.sportOutdoorCycle = sportOutdoorCycle
        self.sportIndoorCycle = sportIndoorCycle
        self.sportOutdoorWalk = sportOutdoorWalk
        self.sportIndoorWalk = sportIndoorWalk
        self.sportPoolSwim = sportPoolSwim
        self.sportOpenWaterSwim = sportOpenWaterSwim
        self.sportElliptical = sportElliptical
        self.sportRower = sportRower
        self.sportHiit = sportHiit
        self.sportCricket = sportCricket
        self.sportPilates = sportPilates
        self.sportOutdoorFun = sportOutdoorFun
        self.sportOtherActivity = sportOtherActivity
        self.sportZumba = sportZumba
        self.sportSurfing = sportSurfing
        self.sportFootvolley = sportFootvolley
        self.sportStandWaterSkiing = sportStandWaterSkiing
        self.sportBattlingRope = sportBattlingRope
        self.sportSkateboard = sportSkateboard
        self.sportNoticeStepper = sportNoticeStepper
        self.sportShowNum = sportShowNum
        self.sportAerobicsBodybuildingExercise = sportAerobicsBodybuildingExercise
        self.sportPullUp = sportPullUp
        self.sportHighBar = sportHighBar
        self.sportParallelBars = sportParallelBars
        self.sportTrailRunning = sportTrailRunning
        self.sportPickleBall = sportPickleBall
        self.sportSnowboard = sportSnowboard
        self.sportCrossCountrySkiing = sportCrossCountrySkiing
        self.getRealtimeData = getRealtimeData
        self.getLangLibraryV3 = getLangLibraryV3
        self.getFindPhone = getFindPhone
        self.getFindDevice = getFindDevice
        self.getUpHandGestureEx = getUpHandGestureEx
        self.getUpHandGesture = getUpHandGesture
        self.getWeather = getWeather
        self.getDownloadLanguage = getDownloadLanguage
        self.getFactoryReset = getFactoryReset
        self.getFlashLog = getFlashLog
        self.getMultiActivityNoUseApp = getMultiActivityNoUseApp
        self.getMultiDial = getMultiDial
        self.getMenuList = getMenuList
        self.getDoNotDisturbMain3 = getDoNotDisturbMain3
        self.getVoiceTransmission = getVoiceTransmission
        self.setDrinkWaterAddNotifyFlag = setDrinkWaterAddNotifyFlag
        self.setSpo2LowValueRemindAddNotifyFlag = setSpo2LowValueRemindAddNotifyFlag
        self.notSupportSmartHeartNotifyFlag = notSupportSmartHeartNotifyFlag
        self.getDeviceLogState = getDeviceLogState
        self.getNewWatchList = getNewWatchList
        self.getNotifyIconAdaptive = getNotifyIconAdaptive
        self.getPressureNotifyFlagMode = getPressureNotifyFlagMode
        self.getScientificSleep = getScientificSleep
        self.getSpo2NotifyFlag = getSpo2NotifyFlag
        self.getV3Log = getV3Log
        self.getWatchID = getWatchID
        self.getDeviceName = getDeviceName
        self.getBatteryLog = getBatteryLog
        self.getBatteryInfo = getBatteryInfo
        self.getHeatLog = getHeatLog
        self.getWalkReminderV3 = getWalkReminderV3
        self.getSupportV3BleMusic = getSupportV3BleMusic
        self.getSupportGetBleBeepV3 = getSupportGetBleBeepV3
        self.getVeryFitNotSupportPhotoWallpaperV3 = getVeryFitNotSupportPhotoWallpaperV3
        self.getSupportUpdateGps = getSupportUpdateGps
        self.getUbloxModel = getUbloxModel
        self.getSupportGetBleMusicInfoVerV3 = getSupportGetBleMusicInfoVerV3
        self.getBtVersion = getBtVersion
        self.getSportsTypeV3 = getSportsTypeV3
        self.getActivitySwitch = getActivitySwitch
        self.getNoticeIconInformation = getNoticeIconInformation
        self.getSetMaxItemsNum = getSetMaxItemsNum
        self.getNotifyMsgV3 = getNotifyMsgV3
        self.getScreenBrightnessMain9 = getScreenBrightnessMain9
        self.getNotice128byte = getNotice128byte
        self.getNotice250byte = getNotice250byte
        self.getDeletableMenuListV2 = getDeletableMenuListV2
        self.getSupportPairEachConnect = getSupportPairEachConnect
        self.getSupportGetMainSportGoalV3 = getSupportGetMainSportGoalV3
        self.getBtAddrV2 = getBtAddrV2
        self.getSupportBpSetOrMeasurementV2 = getSupportBpSetOrMeasurementV2
        self.getMenstrualAddNotifyFlagV3 = getMenstrualAddNotifyFlagV3
        self.getSupportSetGetTimeGoalTypeV2 = getSupportSetGetTimeGoalTypeV2
        self.getOxygenDataSupportGradeV3 = getOxygenDataSupportGradeV3
        self.getSupportSyncActivityDataAltitudeInfo = getSupportSyncActivityDataAltitudeInfo
        self.getBindCodeAuth = getBindCodeAuth
        self.getSpo2OffChangeV3 = getSpo2OffChangeV3
        self.getLevel5HrInterval = getLevel5HrInterval
        self.getFiveHRInterval = getFiveHRInterval
        self.getBleAndBtVersion = getBleAndBtVersion
        self.getSupportSetGetEmergencyContactV3 = getSupportSetGetEmergencyContactV3
        self.getSupportSetRepeatWeekTypeOnScheduleReminderV3 = getSupportSetRepeatWeekTypeOnScheduleReminderV3
        self.getSupportSetRepeatTypeOnScheduleReminderV3 = getSupportSetRepeatTypeOnScheduleReminderV3
        self.getSupportSetMenstrualReminderOnOff = getSupportSetMenstrualReminderOnOff
        self.getVersionInfo = getVersionInfo
        self.getMtu = getMtu
        self.getDeviceUpdateState = getDeviceUpdateState
        self.getHeartRateModeV2 = getHeartRateModeV2
        self.getStepDataTypeV2 = getStepDataTypeV2
        self.getFastMsgDataV3 = getFastMsgDataV3
        self.getSupportCallingQuickReply = getSupportCallingQuickReply
        self.getSupportDataTranGetNewErrorCodeV3 = getSupportDataTranGetNewErrorCodeV3
        self.getAutoActivityEndSwitchNotDisplay = getAutoActivityEndSwitchNotDisplay
        self.getAutoActivityPauseSwitchNotDisplay = getAutoActivityPauseSwitchNotDisplay
        self.getV3AutoActivitySwitch = getV3AutoActivitySwitch
        self.getAutoActivitySwitchAddBicycle = getAutoActivitySwitchAddBicycle
        self.getAutoActivitySwitchAddSmartRope = getAutoActivitySwitchAddSmartRope
        self.getAutoActivitySetGetUseNewStructExchange = getAutoActivitySetGetUseNewStructExchange
        self.getSupportSetGetNoReminderOnWalkReminderV2 = getSupportSetGetNoReminderOnWalkReminderV2
        self.getSupportGetSnInfo = getSupportGetSnInfo
        self.getScheduleReminderNotDisplayTitle = getScheduleReminderNotDisplayTitle
        self.getSupportV3LongCityName = getSupportV3LongCityName
        self.getSupportAddNightLevelV2 = getSupportAddNightLevelV2
        self.getSupportDialFrameEncodeFormatArgb6666 = getSupportDialFrameEncodeFormatArgb6666
        self.getSupportAppSendPhoneSystemInfo = getSupportAppSendPhoneSystemInfo
        self.getDeviceControlFastModeAlone = getDeviceControlFastModeAlone
        self.getSupportOnekeyDoubleContact = getSupportOnekeyDoubleContact
        self.getSupportSetVoiceAssistantStatus = getSupportSetVoiceAssistantStatus
        self.getSupportFlashLogSize = getSupportFlashLogSize
        self.supportDevReturnMeasuringValue = supportDevReturnMeasuringValue
        self.getSupportGetUnit = getSupportGetUnit
        self.getSupportRyzeConnect = getSupportRyzeConnect
        self.getSupportLoopsFit = getSupportLoopsFit
        self.getSupportTasSmart = getSupportTasSmart
        self.getNotSupportSetOvulation = getNotSupportSetOvulation
        self.getSupportWalkGoalSteps = getSupportWalkGoalSteps
        self.getNotSupportDeleteAddSportSort = getNotSupportDeleteAddSportSort
        self.getSupportSedentaryTensileHabitInfo = getSupportSedentaryTensileHabitInfo
        self.getSupportSendGpsLongitudeAndLatitude = getSupportSendGpsLongitudeAndLatitude
        self.getSupportGetV3DeviceBtConnectPhoneModel = getSupportGetV3DeviceBtConnectPhoneModel
        self.getSupportBloodPressureModelFileUpdate = getSupportBloodPressureModelFileUpdate
        self.getSupportDisturbHaveRangRepeat = getSupportDisturbHaveRangRepeat
        self.getSupportCalendarReminder = getSupportCalendarReminder
        self.getWatchDailSetAddSize = getWatchDailSetAddSize
        self.getSupportSyncOverHighLowHeartData = getSupportSyncOverHighLowHeartData
        self.getSupportPerMinuteOne = getSupportPerMinuteOne
        self.getSupportAchievedRemindOnOff = getSupportAchievedRemindOnOff
        self.getSupportDrinkPlan = getSupportDrinkPlan
        self.getSupportMakeWatchDialDecodeJpg = getSupportMakeWatchDialDecodeJpg
        self.getSupportSleepPlan = getSupportSleepPlan
        self.getSupportDeviceOperateAlgFile = getSupportDeviceOperateAlgFile
        self.getSupportSportRecordShowConfig = getSupportSportRecordShowConfig
        self.setNoticeMessageStateUseVersion0x20 = setNoticeMessageStateUseVersion0x20
        self.setScientificSleepSwitch = setScientificSleepSwitch
        self.setTemperatureSwitchHealth = setTemperatureSwitchHealth
        self.setHeartRateMonitor = setHeartRateMonitor
        self.setNoReminderOnDrinkReminder = setNoReminderOnDrinkReminder
        self.setAgpsOffLine = setAgpsOffLine
        self.setAgpsOnLine = setAgpsOnLine
        self.setSetV3HeartInterval = setSetV3HeartInterval
        self.setWeatherCity = setWeatherCity
        self.setDoNotDisturb = setDoNotDisturb
        self.setCalorieGoal = setCalorieGoal
        self.setMenstruation = setMenstruation
        self.setPressureData = setPressureData
        self.setSpo2Data = setSpo2Data
        self.setSportModeSort = setSportModeSort
        self.setActivitySwitch = setActivitySwitch
        self.setNightAutoBrightness = setNightAutoBrightness
        self.setScreenBrightness5Level = setScreenBrightness5Level
        self.setWalkReminder = setWalkReminder
        self.setScreenBrightness3Level = setScreenBrightness3Level
        self.setHandWashReminder = setHandWashReminder
        self.setLocalDial = setLocalDial
        self.setNotSupportHrHighAlarm = setNotSupportHrHighAlarm
        self.setNotSupportPhotoWallpaper = setNotSupportPhotoWallpaper
        self.setPressureHighReminder = setPressureHighReminder
        self.setWallpaperOnlyTimeColor = setWallpaperOnlyTimeColor
        self.setWallpaperDial = setWallpaperDial
        self.setSupportBreathRate = setSupportBreathRate
        self.setSupportCalorieUnit = setSupportCalorieUnit
        self.setSupportSportPlan = setSupportSportPlan
        self.setSupportSwimPoolUnit = setSupportSwimPoolUnit
        self.setSupportV3Bp = setSupportV3Bp
        self.setV3GetSportSortField = setV3GetSportSortField
        self.setWatchDialSort = setWatchDialSort
        self.setGetCalorieDistanceGoal = setGetCalorieDistanceGoal
        self.setMidHighTimeGoal = setMidHighTimeGoal
        self.setNewRetainData = setNewRetainData
        self.setScheduleReminder = setScheduleReminder
        self.setSet100SportSort = setSet100SportSort
        self.setSet20SportParamSort = setSet20SportParamSort
        self.setSetMainUiSort = setSetMainUiSort
        self.setSetStressCalibration = setSetStressCalibration
        self.setSmartHeartRate = setSmartHeartRate
        self.setSpo2AllDayOnOff = setSpo2AllDayOnOff
        self.setSupportAppSendVoiceToBle = setSupportAppSendVoiceToBle
        self.setSupportCyclingUnit = setSupportCyclingUnit
        self.setSupportWalkRunUnit = setSupportWalkRunUnit
        self.setWalkReminderTimeGoal = setWalkReminderTimeGoal
        self.setWatchCapacitySizeDisplay = setWatchCapacitySizeDisplay
        self.setWatchPhotoPositionMove = setWatchPhotoPositionMove
        self.setMenuListMain7 = setMenuListMain7
        self.setHistoryMenstrual = setHistoryMenstrual
        self.supportHistoricalMenstruationExchange = supportHistoricalMenstruationExchange
        self.supportSetHistoricalMenstruationExchangeVersion21 = supportSetHistoricalMenstruationExchangeVersion21
        self.supportHistoricalMenstruationExchangeVersion31 = supportHistoricalMenstruationExchangeVersion31
        self.supportPhysiologicalRecord = supportPhysiologicalRecord
        self.setMenstrualAddPregnancy = setMenstrualAddPregnancy
        self.setNotSurportCalling3SDelay = setNotSurportCalling3SDelay
        self.setSetFitnessGuidance = setSetFitnessGuidance
        self.setSetNotificationStatus = setSetNotificationStatus
        self.setSetUnreadAppReminder = setSetUnreadAppReminder
        self.setSetV3Weather = setSetV3Weather
        self.setSetV3WeatherSunrise = setSetV3WeatherSunrise
        self.setSetV3WorldTime = setSetV3WorldTime
        self.setSyncContact = setSyncContact
        self.setSyncV3ActivityAddParam = setSyncV3ActivityAddParam
        self.setTransferMusicFile = setTransferMusicFile
        self.setWalkReminderAddNotify = setWalkReminderAddNotify
        self.setSupportFahrenheit = setSupportFahrenheit
        self.setGetAlarmSpecify = setGetAlarmSpecify
        self.setAirohaGpsChip = setAirohaGpsChip
        self.setSupportSecondSportIcon = setSupportSecondSportIcon
        self.setSportMediumIcon = setSportMediumIcon
        self.setWeatherSunTime = setWeatherSunTime
        self.setWeatherAirGrade = setWeatherAirGrade
        self.setDrinkWaterReminder = setDrinkWaterReminder
        self.supportBatteryReminderSwitch = supportBatteryReminderSwitch
        self.supportPetInfo = supportPetInfo
        self.setRespirationRate = setRespirationRate
        self.setMaxBloodOxygen = setMaxBloodOxygen
        self.setBleControlMusic = setBleControlMusic
        self.setMainPressure = setMainPressure
        self.setNoDisturbAllDayOnOff = setNoDisturbAllDayOnOff
        self.setOnlyNoDisturbAllDayOnOff = setOnlyNoDisturbAllDayOnOff
        self.setOnlyNoDisturbSmartOnOff = setOnlyNoDisturbSmartOnOff
        self.setTimeZoneFloat = setTimeZoneFloat
        self.setTemperatureSwitchSupport = setTemperatureSwitchSupport
        self.setMsgAllSwitch = setMsgAllSwitch
        self.setNotSupperCall3Delay = setNotSupperCall3Delay
        self.setNoticeMissedCallV2 = setNoticeMissedCallV2
        self.setOverFindPhone = setOverFindPhone
        self.getHealthSwitchStateSupportV3 = getHealthSwitchStateSupportV3
        self.setSedentariness = setSedentariness
        self.setScreenBrightness = setScreenBrightness
        self.setSetPhoneVoice = setSetPhoneVoice
        self.setSupportSetCallQuickReplyOnOff = setSupportSetCallQuickReplyOnOff
        self.setSupportExchangeSetGpsCoordinates = setSupportExchangeSetGpsCoordinates
        self.setSupportV3WeatherAddAtmosphericPressure = setSupportV3WeatherAddAtmosphericPressure
        self.setSupportSetV3WeatcherAddSnowDepth = setSupportSetV3WeatcherAddSnowDepth
        self.setSupportSetV3WeatcherAddSnowfall = setSupportSetV3WeatcherAddSnowfall
        self.setSupportSetV3WeatcherSendStructVersion04 = setSupportSetV3WeatcherSendStructVersion04
        self.setSendCalibrationThreshold = setSendCalibrationThreshold
        self.getNotSupportAppSendRunPlan = getNotSupportAppSendRunPlan
        self.getSupportDisplayNapSleep = getSupportDisplayNapSleep
        self.getSupportGetSmartHeartRate = getSupportGetSmartHeartRate
        self.getSupportGetPressureSwitchInfo = getSupportGetPressureSwitchInfo
        self.getSupportECardOperate = getSupportECardOperate
        self.getSupportVoiceMemoOperate = getSupportVoiceMemoOperate
        self.getSupportMorningEdition = getSupportMorningEdition
        self.getSupportGetSpo2SwitchInfo = getSupportGetSpo2SwitchInfo
        self.getSupportSyncHealthHrUseVersionCompatible = getSupportSyncHealthHrUseVersionCompatible
        self.getSupportSetV3Add48HourWeatherData = getSupportSetV3Add48HourWeatherData
        self.getNotSupportIndoorRunGetVo2max = getNotSupportIndoorRunGetVo2max
        self.getSupportSetEcgReminder = getSupportSetEcgReminder
        self.getSupportSyncEcg = getSupportSyncEcg
        self.getSupportSetGameTimeReminder = getSupportSetGameTimeReminder
        self.getSupportConfigDefaultMegApplicationList = getSupportConfigDefaultMegApplicationList
        self.getSupportSetEciReminder = getSupportSetEciReminder
        self.setSupportNoiseSetNotifyFlag = setSupportNoiseSetNotifyFlag
        self.setSupportNoiseSetOverWarning = setSupportNoiseSetOverWarning
        self.setSupportSetVersionInformation = setSupportSetVersionInformation
        self.setSupportControlMiniProgram = setSupportControlMiniProgram
        self.getSupportSetWeatherHistoryFutureAqi = getSupportSetWeatherHistoryFutureAqi
        self.setBrightScreenTime = setBrightScreenTime
        self.setHeartSetRateModeCustom = setHeartSetRateModeCustom
        self.supportProtocolV3MenuList = supportProtocolV3MenuList
        self.languageCh = languageCh
        self.languageCzech = languageCzech
        self.languageEnglish = languageEnglish
        self.languageFrench = languageFrench
        self.languageGerman = languageGerman
        self.languageItalian = languageItalian
        self.languageJapanese = languageJapanese
        self.languageSpanish = languageSpanish
        self.languageArabic = languageArabic
        self.languageBurmese = languageBurmese
        self.languageFilipino = languageFilipino
        self.languageGreek = languageGreek
        self.languageThai = languageThai
        self.languageTraditionalChinese = languageTraditionalChinese
        self.languageVietnamese = languageVietnamese
        self.languageDutch = languageDutch
        self.languageHungarian = languageHungarian
        self.languageLithuanian = languageLithuanian
        self.languagePolish = languagePolish
        self.languageRomanian = languageRomanian
        self.languageRussian = languageRussian
        self.languageSlovenian = languageSlovenian
        self.languageUkrainian = languageUkrainian
        self.languageCroatian = languageCroatian
        self.languageDanish = languageDanish
        self.languageHindi = languageHindi
        self.languageIndonesian = languageIndonesian
        self.languageKorean = languageKorean
        self.languagePortuguese = languagePortuguese
        self.languageSlovak = languageSlovak
        self.languageTurkish = languageTurkish
        self.languagePersia = languagePersia
        self.languageSweden = languageSweden
        self.languageNorwegian = languageNorwegian
        self.languageFinland = languageFinland
        self.languageBengali = languageBengali
        self.languageKhmer = languageKhmer
        self.languageMalay = languageMalay
        self.languageBrazilianPortuguese = languageBrazilianPortuguese
        self.languageHebrew = languageHebrew
        self.languageSerbian = languageSerbian
        self.languageBulgaria = languageBulgaria
        self.syncV3Hr = syncV3Hr
        self.syncV3Swim = syncV3Swim
        self.syncV3Spo2 = syncV3Spo2
        self.syncV3Pressure = syncV3Pressure
        self.syncV3Activity = syncV3Activity
        self.syncV3Sleep = syncV3Sleep
        self.syncV3PetSleep = syncV3PetSleep
        self.syncV3Sports = syncV3Sports
        self.syncV3Gps = syncV3Gps
        self.syncV3SyncAlarm = syncV3SyncAlarm
        self.syncV3BodyPower = syncV3BodyPower
        self.getSupportHrvV3 = getSupportHrvV3
        self.getSupportPerBpV3 = getSupportPerBpV3
        self.syncV3Noise = syncV3Noise
        self.syncV3Temperature = syncV3Temperature
        self.syncGps = syncGps
        self.syncV3ActivityExchangeData = syncV3ActivityExchangeData
        self.syncHeartRate = syncHeartRate
        self.syncHeartRateMonitor = syncHeartRateMonitor
        self.syncSleepMonitor = syncSleepMonitor
        self.syncFastSync = syncFastSync
        self.syncActivityTimeSync = syncActivityTimeSync
        self.syncTimeLine = syncTimeLine
        self.syncNeedV2 = syncNeedV2
        self.syncRealTimeV3 = syncRealTimeV3
        self.syncExchangeDataReplyAddRealTimeSpeedPaceV3 = syncExchangeDataReplyAddRealTimeSpeedPaceV3
        self.syncHealthSyncV3ActivityEndTimeUseUtcMode = syncHealthSyncV3ActivityEndTimeUseUtcMode
        self.syncSupportSetFastModeWhenSyncConfig = syncSupportSetFastModeWhenSyncConfig
        self.getSupportAppBaseInformation = getSupportAppBaseInformation
        self.alarmCount = alarmCount
        self.alarmBrushTeeth = alarmBrushTeeth
        self.alarmDating = alarmDating
        self.alarmDinner = alarmDinner
        self.alarmMedicine = alarmMedicine
        self.alarmMeeting = alarmMeeting
        self.alarmParty = alarmParty
        self.alarmRest = alarmRest
        self.alarmSleep = alarmSleep
        self.alarmSport = alarmSport
        self.alarmWakeUp = alarmWakeUp
        self.supportSetAntilost = supportSetAntilost
        self.supportSetWeatherDataV2 = supportSetWeatherDataV2
        self.supportSetOnetouchCalling = supportSetOnetouchCalling
        self.supportOperateSetSportScreen = supportOperateSetSportScreen
        self.supportOperateListStyle = supportOperateListStyle
        self.supportEmotionHealth = supportEmotionHealth
        self.supportV3SyncContactVersion20 = supportV3SyncContactVersion20
        self.supportGetSosCallRecord = supportGetSosCallRecord
        self.alexaReminderAddSecV3 = alexaReminderAddSecV3
        self.alexaSetEasyOperateV3 = alexaSetEasyOperateV3
        self.alexaSetGetAlexaAlarmV3 = alexaSetGetAlexaAlarmV3
        self.alexaSetJumpSportUiV3 = alexaSetJumpSportUiV3
        self.alexaSetJumpUiV3 = alexaSetJumpUiV3
        self.alexaSetSetOnOffTypeV3 = alexaSetSetOnOffTypeV3
        self.alexaSetWeatherV3 = alexaSetWeatherV3
        self.alexaTimeNewV3 = alexaTimeNewV3
        self.setAlexaControll100brightness = setAlexaControll100brightness
        self.alexaGetSupportGetAlexaDefaultLanguage = alexaGetSupportGetAlexaDefaultLanguage
        self.alexaGetUIControllSports = alexaGetUIControllSports
        self.getLeftRightHandWearSettings = getLeftRightHandWearSettings
        self.supportSettingsDuringExercise = supportSettingsDuringExercise
        self.supportHeightLengthUnit = supportHeightLengthUnit
        self.supportSportingRemindSetting = supportSportingRemindSetting
        self.supportSportGetAutoPauseEnd = supportSportGetAutoPauseEnd
        self.supportSetStrideLengthUnit = supportSetStrideLengthUnit
        self.supportSimpleHrZoneSetting = supportSimpleHrZoneSetting
        self.notSupportSmartLowHeartReatRemind = notSupportSmartLowHeartReatRemind
        self.notSupportSmartHighHeartReatRemind = notSupportSmartHighHeartReatRemind
        self.notSupportPhotoPreviewControl = notSupportPhotoPreviewControl
        self.supportGetUserInfo = supportGetUserInfo
        self.supportMissedCallMsgTypeUseFixed = supportMissedCallMsgTypeUseFixed
        self.supportAppNotDisplayAlarmName = supportAppNotDisplayAlarmName
        self.supportSetSleepRemind = supportSetSleepRemind
        self.supportBloodGlucose = supportBloodGlucose
        self.supportBloodGlucoseV01 = supportBloodGlucoseV01
        self.supportBikeLockManager = supportBikeLockManager
        self.supportAlgorithmRawDataCollect = supportAlgorithmRawDataCollect
        self.supportOfflineMapInformation = supportOfflineMapInformation
        self.supportHeartRateReserveZones = supportHeartRateReserveZones
        self.supportHeartRateZonesHrMaxSet = supportHeartRateZonesHrMaxSet
        self.supportSyncMultiActivityNew = supportSyncMultiActivityNew
        self.supportContactFileUseFirmwareReturnSize = supportContactFileUseFirmwareReturnSize
        self.supportDisplayCameraEntry = supportDisplayCameraEntry
        self.supportOperateFamilyCareReminder3376 = supportOperateFamilyCareReminder3376
        self.supportProtocolV3MenstruationConfig3377 = supportProtocolV3MenstruationConfig3377
        self.supportOperateHabitFormation = supportOperateHabitFormation
        self.supportOperateHabitFormationV01 = supportOperateHabitFormationV01
        self.supportOperateFamilySteps = supportOperateFamilySteps
        self.supportOperateSetGame = supportOperateSetGame
        self.supportOperateGestureControl = supportOperateGestureControl
    }
    
    public func toJsonString() -> String? {
        if let jsonData = try? JSONEncoder().encode(self) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        }
        return nil
    }
}
