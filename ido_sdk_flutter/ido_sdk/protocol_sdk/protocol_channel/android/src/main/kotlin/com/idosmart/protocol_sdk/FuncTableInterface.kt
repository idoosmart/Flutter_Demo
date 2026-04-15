package com.idosmart.protocol_sdk

interface FuncTableInterface {
    /// 智能通知
    val reminderAncs: Boolean
    /// Snapchat
    val reminderSnapchat: Boolean
    /// Line
    val reminderLine: Boolean
    /// Outlook
    val reminderOutlook: Boolean
    /// Telegram
    val reminderTelegram: Boolean
    /// Viber
    val reminderViber: Boolean
    /// Vkontakte
    val reminderVkontakte: Boolean
    /// Chatwork;
    val reminderChatwork: Boolean
    /// Slack
    val reminderSlack: Boolean
    /// Tumblr
    val reminderTumblr: Boolean
    /// YahooMail
    val reminderYahooMail: Boolean
    /// YahooPinterest
    val reminderYahooPinterest: Boolean
    /// Youtube
    val reminderYoutube: Boolean
    /// Gmail
    val reminderGmail: Boolean
    /// KakaoTalk
    val reminderKakaoTalk: Boolean
    /// Google gmail
    val reminderOnlyGoogleGmail: Boolean
    /// Outlook email
    val reminderOnlyOutlookEmail: Boolean
    /// Yahoo email
    val reminderOnlyYahooEmail: Boolean
    /// Tiktok
    val reminderTiktok: Boolean
    /// Redbus
    val reminderRedbus: Boolean
    /// Dailyhunt
    val reminderDailyhunt: Boolean
    /// Hotstar
    val reminderHotstar: Boolean
    /// Inshorts
    val reminderInshorts: Boolean
    /// Paytm
    val reminderPaytm: Boolean
    /// Amazon
    val reminderAmazon: Boolean
    /// Flipkart
    val reminderFlipkart: Boolean
    /// Nhn email
    val reminderNhnEmail: Boolean
    /// Instant email
    val reminderInstantEmail: Boolean
    /// Zoho email
    val reminderZohoEmail: Boolean
    /// Exchange email
    val reminderExchangeEmail: Boolean
    /// 189 email
    val reminder189Email: Boolean
    /// Very fit
    val reminderVeryFit: Boolean
    /// General
    val reminderGeneral: Boolean
    /// other
    val reminderOther: Boolean
    /// Matters
    val reminderMattersRemind: Boolean
    /// Microsoft
    val reminderMicrosoft: Boolean
    /// MissedCalls
    val reminderMissedCall: Boolean
    /// 支持同步全部通讯录
    val reminderGetAllContact: Boolean
    /// WhatsappBusiness
    val reminderWhatsappBusiness: Boolean
    /// Email
    val reminderEmail: Boolean
    /// Facebook
    val reminderFacebook: Boolean
    /// Message
    val reminderMessage: Boolean
    /// QQ
    val reminderQq: Boolean
    /// Twitter
    val reminderTwitter: Boolean
    /// Weixin
    val reminderWeixin: Boolean
    /// Calendar (Google日历）
    val reminderCalendarGoogle: Boolean
    /// Instagram
    val reminderInstagram: Boolean
    /// linkedIn
    val reminderLinkedIn: Boolean
    /// Messengre
    val reminderMessengre: Boolean
    /// Skype
    val reminderSkype: Boolean
    /// Calendar
    val reminderCalendar: Boolean
    /// Whatsapp
    val reminderWhatsapp: Boolean
    /// Alarm clock
    val reminderAlarmClock: Boolean
    /// 新浪微博
    val reminderSinaWeibo: Boolean
    /// 国内版微博
    val reminderWeibo: Boolean
    /// 来电提醒
    val reminderCalling: Boolean
    /// 来电联系人
    val reminderCallContact: Boolean
    /// 来电号码
    val reminderCallNum: Boolean
    /// Prime
    val reminderPrime: Boolean
    /// Netflix
    val reminderNetflix: Boolean
    /// Gpay
    val reminderGpay: Boolean
    /// Phonpe
    val reminderPhonpe: Boolean
    /// Swiggy
    val reminderSwiggy: Boolean
    /// Zomato
    val reminderZomato: Boolean
    /// Makemytrip
    val reminderMakemytrip: Boolean
    /// JioTv
    val reminderJioTv: Boolean
    /// Niosefit
    val reminderNiosefit: Boolean
    /// YT music
    val reminderYtmusic: Boolean
    /// Uber
    val reminderUber: Boolean
    /// Ola
    val reminderOla: Boolean
    /// Google meet
    val reminderGoogleMeet: Boolean
    /// Mormaii Smartwatch
    val reminderMormaiiSmartwatch: Boolean
    /// Technos connect
    val reminderTechnosConnect: Boolean
    /// Enjoei
    val reminderEnjoei: Boolean
    /// Aliexpress
    val reminderAliexpress: Boolean
    /// Shopee
    val reminderShopee: Boolean
    /// Teams
    val reminderTeams: Boolean
    /// 99 taxi
    val reminder99Taxi: Boolean
    /// Uber eats
    val reminderUberEats: Boolean
    /// Lfood
    val reminderLfood: Boolean
    /// Rappi
    val reminderRappi: Boolean
    /// Mercado livre
    val reminderMercadoLivre: Boolean
    /// Magalu
    val reminderMagalu: Boolean
    /// Americanas
    val reminderAmericanas: Boolean
    /// Yahoo
    val reminderYahoo: Boolean
    /// 消息图标和名字更新
    val reminderMessageIcon: Boolean
    /// 淘宝
    val reminderTaobao: Boolean
    /// 钉钉
    val reminderDingding: Boolean
    /// 支付宝
    val reminderAlipay: Boolean
    /// 今日头条
    val reminderToutiao: Boolean
    /// 抖音
    val reminderDouyin: Boolean
    /// 天猫
    val reminderTmall: Boolean
    /// 京东
    val reminderJd: Boolean
    /// 拼多多
    val reminderPinduoduo: Boolean
    /// 百度
    val reminderBaidu: Boolean
    /// 美团
    val reminderMeituan: Boolean
    /// 饿了么
    val reminderEleme: Boolean
    /// v2 走路
    val sportWalk: Boolean
    /// v2 跑步
    val sportRun: Boolean
    /// v2 骑行
    val sportByBike: Boolean
    /// v2 徒步
    val sportOnFoot: Boolean
    /// v2 游泳
    val sportSwim: Boolean
    /// v2 爬山
    val sportMountainClimbing: Boolean
    /// v2 羽毛球
    val sportBadminton: Boolean
    /// v2 其他
    val sportOther: Boolean
    /// v2 健身
    val sportFitness: Boolean
    /// v2 动感单车
    val sportSpinning: Boolean
    /// v2 椭圆球
    val sportEllipsoid: Boolean
    /// v2 跑步机
    val sportTreadmill: Boolean
    /// v2 仰卧起坐
    val sportSitUp: Boolean
    /// v2 俯卧撑
    val sportPushUp: Boolean
    /// v2 哑铃
    val sportDumbbell: Boolean
    /// v2 举重
    val sportWeightlifting: Boolean
    /// v2 健身操
    val sportBodybuildingExercise: Boolean
    /// v2 瑜伽
    val sportYoga: Boolean
    /// v2 跳绳
    val sportRopeSkipping: Boolean
    /// v2 乒乓球
    val sportTableTennis: Boolean
    /// v2 篮球
    val sportBasketball: Boolean
    /// v2 足球
    val sportFootballl: Boolean
    /// v2 排球
    val sportVolleyball: Boolean
    /// v2 网球
    val sportTennis: Boolean
    /// v2 高尔夫
    val sportGolf: Boolean
    /// v2 棒球
    val sportBaseball: Boolean
    /// v2 滑雪
    val sportSkiing: Boolean
    /// v2 轮滑
    val sportRollerSkating: Boolean
    /// v2 跳舞
    val sportDance: Boolean
    /// v2 功能性训练
    val sportStrengthTraining: Boolean
    /// v2 核心训练
    val sportCoreTraining: Boolean
    /// v2 整体放松
    val sportTidyUpRelax: Boolean
    /// v2 传统的力量训练
    val sportTraditionalStrengthTraining: Boolean
    /// v3 户外跑步
    val sportOutdoorRun: Boolean
    /// v3 室内跑步
    val sportIndoorRun: Boolean
    /// v3 户外骑行
    val sportOutdoorCycle: Boolean
    /// v3 室内骑行
    val sportIndoorCycle: Boolean
    /// v3 户外走路
    val sportOutdoorWalk: Boolean
    /// v3 室内走路
    val sportIndoorWalk: Boolean
    /// v3 泳池游泳
    val sportPoolSwim: Boolean
    /// v3 开放水域游泳
    val sportOpenWaterSwim: Boolean
    /// v3 椭圆机
    val sportElliptical: Boolean
    /// v3 划船机
    val sportRower: Boolean
    /// v3 高强度间歇训练法
    val sportHiit: Boolean
    /// v3 板球运动
    val sportCricket: Boolean
    /// v3 普拉提
    val sportPilates: Boolean
    /// v3 户外玩耍（定制 kr01）
    val sportOutdoorFun: Boolean
    /// v3 其他运动（定制 kr01）
    val sportOtherActivity: Boolean
    /// v3 尊巴舞
    val sportZumba: Boolean
    /// v3 冲浪
    val sportSurfing: Boolean
    /// v3 足排球
    val sportFootvolley: Boolean
    /// v3 站立滑水
    val sportStandWaterSkiing: Boolean
    /// v3 站绳
    val sportBattlingRope: Boolean
    /// v3 滑板
    val sportSkateboard: Boolean
    /// v3 踏步机
    val sportNoticeStepper: Boolean
    /// 运动显示个数
    val sportShowNum: Int
    /// 有氧健身操
    val sportAerobicsBodybuildingExercise: Boolean
    /// 引体向上
    val sportPullUp: Boolean
    /// 单杠
    val sportHighBar: Boolean
    /// 双杠
    val sportParallelBars: Boolean
    /// 越野跑
    val sportTrailRunning: Boolean
    /// 匹克球
    val sportPickleBall: Boolean
    /// 滑板
    val sportSnowboard: Boolean
    /// 越野滑板
    val sportCrossCountrySkiing: Boolean
    /// 获取实时数据
    val getRealtimeData: Boolean
    /// 获取v3语言库
    val getLangLibraryV3: Boolean
    /// 查找手机
    val getFindPhone: Boolean
    /// 查找设备
    val getFindDevice: Boolean
    /// 抬腕亮屏数据获取
    val getUpHandGestureEx: Boolean
    /// 抬腕亮屏
    val getUpHandGesture: Boolean
    /// 天气预报
    val getWeather: Boolean
    /// 可下载语言
    val getDownloadLanguage: Boolean
    /// 恢复出厂设置
    val getFactoryReset: Boolean
    /// Flash log
    val getFlashLog: Boolean
    /// 多运动不能使用app
    val getMultiActivityNoUseApp: Boolean
    /// 多表盘
    val getMultiDial: Boolean
    /// 获取菜单列表
    val getMenuList: Boolean
    /// 请勿打扰
    val getDoNotDisturbMain3: Boolean
    /// 语音功能
    val getVoiceTransmission: Boolean
    /// 设置喝水开关通知类型
    val setDrinkWaterAddNotifyFlag: Boolean
    /// 血氧过低提醒通知提醒类型
    val setSpo2LowValueRemindAddNotifyFlag: Boolean
    /// 智能心率提醒通知提醒类型
    val notSupportSmartHeartNotifyFlag: Boolean
    /// 获取重启日志错误码和标志位
    val getDeviceLogState: Boolean
    /// 支持获取表盘列表的接口
    val getNewWatchList: Boolean
    /// 消息提醒图标自适应
    val getNotifyIconAdaptive: Boolean
    /// 压力开关增加通知类型和全天压力模式设置
    val getPressureNotifyFlagMode: Boolean
    /// 科学睡眠
    val getScientificSleep: Boolean
    /// 血氧开关增加通知类型
    val getSpo2NotifyFlag: Boolean
    /// v3 收集log
    val getV3Log: Boolean
    /// 获取表盘ID
    val getWatchID: Boolean
    /// 获取设备名称
    val getDeviceName: Boolean
    /// 获取电池日志
    val getBatteryLog: Boolean
    /// 获取电池信息
    val getBatteryInfo: Boolean
    /// 获取过热日志
    val getHeatLog: Boolean
    /// 获取走动提醒 v3
    val getWalkReminderV3: Boolean
    /// 获取支持蓝牙音乐 v3
    val getSupportV3BleMusic: Boolean
    /// 支持获取固件本地提示音文件信息
    val getSupportGetBleBeepV3: Boolean
    /// BIT1 k6项目不需要对应的壁纸表盘，veryFit默认的都是支持的，新加一个不支持的功能表，不需要的配置这个
    val getVeryFitNotSupportPhotoWallpaperV3: Boolean
    /// 支持升级gps固件
    val getSupportUpdateGps: Boolean
    /// 支持ublox模块
    val getUbloxModel: Boolean
    /// 支持获取固件歌曲名和文件夹指令下发和固件回复使用协议版本号0x10
    val getSupportGetBleMusicInfoVerV3: Boolean
    /// 获得固件三级版本和BT的三级版本
    val getBtVersion: Boolean
    /// V3的运动类型设置和获取
    val getSportsTypeV3: Boolean
    /// 支持运动模式识别开关获取
    val getActivitySwitch: Boolean
    /// 支持动态消息图标更新
    val getNoticeIconInformation: Boolean
    /// 支持获取固件支持app下发的详情的最大数量
    val getSetMaxItemsNum: Boolean
    /// v3 消息提醒
    val getNotifyMsgV3: Boolean
    /// 获取屏幕亮度
    val getScreenBrightnessMain9: Boolean
    /// 128个字节通知
    val getNotice128byte: Boolean
    /// 250个字节通知
    val getNotice250byte: Boolean
    /// 支持获取不可删除的快捷应用列表
    val getDeletableMenuListV2: Boolean
    /// 设置支持系统配对
    val getSupportPairEachConnect: Boolean
    /// 支持获取运动目标
    val getSupportGetMainSportGoalV3: Boolean
    /// 取bt蓝牙MAC地址
    val getBtAddrV2: Boolean
    /// 血压校准与测量
    val getSupportBpSetOrMeasurementV2: Boolean
    /// 生理周期开关增加通知类型
    val getMenstrualAddNotifyFlagV3: Boolean
    /// 设置获取运动三环周目标
    val getSupportSetGetTimeGoalTypeV2: Boolean
    /// 多运动同步数据支持摄氧量等级数据
    val getOxygenDataSupportGradeV3: Boolean
    /// 多运动数据同步支持海拔高度数据
    val getSupportSyncActivityDataAltitudeInfo: Boolean
    /// 绑定授权码
    val getBindCodeAuth: Boolean
    /// V3血氧数据 偏移按照分钟偏移
    val getSpo2OffChangeV3: Boolean
    /// 5级心率区间
    val getLevel5HrInterval: Boolean
    /// 5个心率区间
    val getFiveHRInterval: Boolean
    /// 获得固件三级版本和BT的3级版本
    val getBleAndBtVersion: Boolean
    /// 紧急联系人
    val getSupportSetGetEmergencyContactV3: Boolean
    /// 重复提醒类型设置星期重复
    val getSupportSetRepeatWeekTypeOnScheduleReminderV3: Boolean
    /// 重复提醒类型设置
    val getSupportSetRepeatTypeOnScheduleReminderV3: Boolean
    /// 经期开关
    val getSupportSetMenstrualReminderOnOff: Boolean
    /// 版本信息
    val getVersionInfo: Boolean
    /// 获取MTU
    val getMtu: Boolean
    /// 获取手环的升级状态
    val getDeviceUpdateState: Boolean
    /// v2获取心率监测模式
    val getHeartRateModeV2: Boolean
    /// 目标步数类型为周目标
    val getStepDataTypeV2: Boolean
    /// 快速消息
    val getFastMsgDataV3: Boolean
    /// 支持快速回复
    val getSupportCallingQuickReply: Boolean
    /// 新错误码 v3
    val getSupportDataTranGetNewErrorCodeV3: Boolean
    /// 运动自识别结束开关不展示，设置开关状态
    val getAutoActivityEndSwitchNotDisplay: Boolean
    /// 运动自识别暂停开关不展示，设置开关状态
    val getAutoActivityPauseSwitchNotDisplay: Boolean
    /// 运动模式自动识别开关设置获取 新增类型椭圆机 划船机 游泳
    val getV3AutoActivitySwitch: Boolean
    /// 运动模式自动识别开关设置获取 新增类型骑行
    val getAutoActivitySwitchAddBicycle: Boolean
    /// 运动模式自动识别开关设置获取 新增类型智能跳绳
    val getAutoActivitySwitchAddSmartRope: Boolean
    /// 运动自识别获取和设置指令使用新的版本与固件交互
    val getAutoActivitySetGetUseNewStructExchange: Boolean
    /// 支持走动提醒设置/获取免提醒时间段
    val getSupportSetGetNoReminderOnWalkReminderV2: Boolean
    /// 支持获取sn信息
    val getSupportGetSnInfo: Boolean
    /// 日程提醒不显示标题
    val getScheduleReminderNotDisplayTitle: Boolean
    /// 城市名称
    val getSupportV3LongCityName: Boolean
    /// 亮度设置支持夜间亮度等级设置
    val getSupportAddNightLevelV2: Boolean
    /// 固件支持使用表盘框架使用argb6666编码格式
    val getSupportDialFrameEncodeFormatArgb6666: Boolean
    /// 固件支持app下发手机操作系统信息
    val getSupportAppSendPhoneSystemInfo: Boolean
    /// 固件管理切换快/慢速模式，APP不下发设置链接参数(快慢速）
    val getDeviceControlFastModeAlone: Boolean
    /// 设备支持一键双连，区分配对时APP展示引导页还是直接下发配对指令
    val getSupportOnekeyDoubleContact: Boolean
    /// 语音助手状态
    val getSupportSetVoiceAssistantStatus: Boolean
    /// 支持获取flash log size
    val getSupportFlashLogSize: Boolean
    /// 设备是否支持返回正在测量的值
    val supportDevReturnMeasuringValue: Boolean
    /// 支持获取单位
    val getSupportGetUnit: Boolean
    /// 通知支持Ryze Connect
    val getSupportRyzeConnect: Boolean
    /// 通知支持LOOPS FIT
    val getSupportLoopsFit: Boolean
    /// 通知支持TAS Smart
    val getSupportTasSmart: Boolean
    /// 女性经期不支持设置排卵日提醒
    val getNotSupportSetOvulation: Boolean
    /// 固件支持每小时目标步数设置和获取
    val getSupportWalkGoalSteps: Boolean
    /// GTX03/05定制，hamaAPP，功能表开启后，运动列表不支持增删，支持排序
    val getNotSupportDeleteAddSportSort: Boolean
    /// 支持获取用户习惯信息(打点信息)中久坐提醒特性
    val getSupportSedentaryTensileHabitInfo: Boolean
    /// 支持固件快速定位，APP下发GPS权限及经纬度给固件
    val getSupportSendGpsLongitudeAndLatitude: Boolean
    /// 支持设备bt连接的手机型号
    val getSupportGetV3DeviceBtConnectPhoneModel: Boolean
    /// 支持血压模型文件更新
    val getSupportBloodPressureModelFileUpdate: Boolean
    /// 勿扰支持事件范围开关和重复
    val getSupportDisturbHaveRangRepeat: Boolean
    /// 日历提醒
    val getSupportCalendarReminder: Boolean
    /// 表盘传输需要对应的传输原始的没有压缩的大小给固件,增加字段watch_file_size
    val getWatchDailSetAddSize: Boolean
    /// 支持同步过高过低时心率数据
    val getSupportSyncOverHighLowHeartData: Boolean
    /// 间隔一分钟同步新增（206设备）
    val getSupportPerMinuteOne: Boolean
    /// 支持全天步数目标达成提醒开关
    val getSupportAchievedRemindOnOff: Boolean
    /// 支持喝水计划
    val getSupportDrinkPlan: Boolean
    /// 支持表盘包打包jpg图片
    val getSupportMakeWatchDialDecodeJpg: Boolean
    /// 支持睡眠计划
    val getSupportSleepPlan: Boolean
    /// 支持获取设备算法文件
    val getSupportDeviceOperateAlgFile: Boolean
    /// 支持获取运动记录的显示项配置
    val getSupportSportRecordShowConfig: Boolean
    /// 设置获取消息应用状态使用version0x20版本下发
    val setNoticeMessageStateUseVersion0x20: Boolean
    /// 科学睡眠开关
    val setScientificSleepSwitch: Boolean
    /// 设置夜间体温开关
    val setTemperatureSwitchHealth: Boolean
    /// 心率监测
    val setHeartRateMonitor: Boolean
    /// 支持喝水提醒设置免提醒时间段
    val setNoReminderOnDrinkReminder: Boolean
    /// 默认是支持agps off升级
    val setAgpsOffLine: Boolean
    /// 默认是支持agps online升级
    val setAgpsOnLine: Boolean
    /// 设置v3心率的间隔
    val setSetV3HeartInterval: Boolean
    /// 天气城市
    val setWeatherCity: Boolean
    /// 防打扰
    val setDoNotDisturb: Boolean
    /// 卡路里目标
    val setCalorieGoal: Boolean
    /// 女性生理周期
    val setMenstruation: Boolean
    /// 压力数据
    val setPressureData: Boolean
    /// 血氧数据
    val setSpo2Data: Boolean
    /// 运动模式排序
    val setSportModeSort: Boolean
    /// 运动模式开关
    val setActivitySwitch: Boolean
    /// 夜间自动亮度
    val setNightAutoBrightness: Boolean
    /// 5级亮度调节
    val setScreenBrightness5Level: Boolean
    /// 走动提醒
    val setWalkReminder: Boolean
    /// 3级亮度调节 默认是5级别，手表app显示，手表不显示
    val setScreenBrightness3Level: Boolean
    /// 洗手提醒
    val setHandWashReminder: Boolean
    /// app支持本地表盘改 云端表盘图片下载
    val setLocalDial: Boolean
    /// V3的心率过高不支持 | 配置了这个，app的UI心率过高告警不显示，
    val setNotSupportHrHighAlarm: Boolean
    /// BIT1 k6项目不需要对应的壁纸表盘，veryFit默认的都是支持的，
    val setNotSupportPhotoWallpaper: Boolean
    /// 压力过高提醒
    val setPressureHighReminder: Boolean
    /// 壁纸表盘颜色设置
    val setWallpaperOnlyTimeColor: Boolean
    /// 壁纸表盘设置
    val setWallpaperDial: Boolean
    /// 呼吸训练
    val setSupportBreathRate: Boolean
    /// 设置单位的增加卡路里设置
    val setSupportCalorieUnit: Boolean
    /// 运动计划
    val setSupportSportPlan: Boolean
    /// 设置单位的增加泳池的单位设置
    val setSupportSwimPoolUnit: Boolean
    /// v3 bp
    val setSupportV3Bp: Boolean
    /// app端用V3的获取运动排序协议中的最大最少默认字段， |
    val setV3GetSportSortField: Boolean
    /// 表盘排序
    val setWatchDialSort: Boolean
    /// 运动三环目标获取
    val setGetCalorieDistanceGoal: Boolean
    /// 设置目标增加中高运动时长
    val setMidHighTimeGoal: Boolean
    /// 固件支持解绑不清除设备上的数据
    val setNewRetainData: Boolean
    /// 日程提醒
    val setScheduleReminder: Boolean
    /// 100种运动数据排序
    val setSet100SportSort: Boolean
    /// 20种基础运动数据子参数排序
    val setSet20SportParamSort: Boolean
    /// 主界面ui控件排列
    val setSetMainUiSort: Boolean
    /// 压力校准
    val setSetStressCalibration: Boolean
    /// 支持app设置智能心率
    val setSmartHeartRate: Boolean
    /// 支持app设置全天的血氧开关数据
    val setSpo2AllDayOnOff: Boolean
    /// 支持app下发压缩的sbc语言文件给ble
    val setSupportAppSendVoiceToBle: Boolean
    /// 设置单位的增加骑行的单位设置
    val setSupportCyclingUnit: Boolean
    /// 设置单位的增加步行跑步的单位设置
    val setSupportWalkRunUnit: Boolean
    /// 设置走动提醒中的目标时间
    val setWalkReminderTimeGoal: Boolean
    /// 支持显示表盘容量
    val setWatchCapacitySizeDisplay: Boolean
    /// 支持壁纸表盘时间位置移动、控件图标颜色修改、控件功能选择
    val setWatchPhotoPositionMove: Boolean
    /// 菜单设置
    val setMenuListMain7: Boolean
    /// v3经期的历史数据下发
    val setHistoryMenstrual: Boolean
    /// 经期历史数据支持交互
    val supportHistoricalMenstruationExchange: Boolean
    /// v3经期历史数据支持交互、支持固件删除
    val supportSetHistoricalMenstruationExchangeVersion21: Boolean
    /// v3经期历史数据支持交互、支持固件删除
    val supportHistoricalMenstruationExchangeVersion31: Boolean
    /// v3女性生理日常记录设置
    val supportPhysiologicalRecord: Boolean
    /// v2经期提醒设置 增加易孕期和结束时间
    val setMenstrualAddPregnancy: Boolean
    /// realme wear 定制需求 不支持显示来电"延时三秒"开关
    val setNotSurportCalling3SDelay: Boolean
    /// 支持健身指导开关下发
    val setSetFitnessGuidance: Boolean
    /// 通知设置
    val setSetNotificationStatus: Boolean
    /// 未读提醒
    val setSetUnreadAppReminder: Boolean
    /// 支持V3天气
    val setSetV3Weather: Boolean
    /// 支持天气推送增加日落日出时间
    val setSetV3WeatherSunrise: Boolean
    /// 支持世界时间设置
    val setSetV3WorldTime: Boolean
    /// 支持联系人同步
    val setSyncContact: Boolean
    /// 同步V3的多运动增加新的参数
    val setSyncV3ActivityAddParam: Boolean
    /// 音乐名称设置
    val setTransferMusicFile: Boolean
    /// 走动提醒增加通知类型
    val setWalkReminderAddNotify: Boolean
    /// 设置单位支持华氏度
    val setSupportFahrenheit: Boolean
    /// 支持v3闹钟设置获取指定名称闹钟（KR01定制）
    val setGetAlarmSpecify: Boolean
    /// 支持airoha芯片采gps数据功能表
    val setAirohaGpsChip: Boolean
    /// 支持第二套运动图标功能表    目前仅idw05支持
    val setSupportSecondSportIcon: Boolean
    /// 100种运动需要的中图功能表
    val setSportMediumIcon: Boolean
    /// 支持天气推送增加日落日出时间
    val setWeatherSunTime: Boolean
    /// 支持V3天气 下发空气质量等级
    val setWeatherAirGrade: Boolean
    /// 支持设置喝水提醒
    val setDrinkWaterReminder: Boolean
    /// 支持设备电量提醒开关
    val supportBatteryReminderSwitch: Boolean
    /// 支持宠物信息设置获取（SET:03 0A / GET:02 0A）
    val supportPetInfo: Boolean
    /// 呼吸率开关设置
    val setRespirationRate: Boolean
    /// 最大摄氧量
    val setMaxBloodOxygen: Boolean
    /// ble控制音乐
    val setBleControlMusic: Boolean
    /// v3压力功能表
    val setMainPressure: Boolean
    /// 勿扰模式设置获取新增全天勿扰开关和智能开关
    val setNoDisturbAllDayOnOff: Boolean
    /// 支持设置全天勿扰开关
    val setOnlyNoDisturbAllDayOnOff: Boolean
    /// 支持设置智能勿扰开关
    val setOnlyNoDisturbSmartOnOff: Boolean
    /// 时区设定值为实际时区值的扩大100倍
    val setTimeZoneFloat: Boolean
    /// 设定温度开关
    val setTemperatureSwitchSupport: Boolean
    /// 支持设置获取消息应用总开关字段
    val setMsgAllSwitch: Boolean
    /// 不支持支持来电提醒页面的“延迟三秒”开关设置项显示
    val setNotSupperCall3Delay: Boolean
    /// 支持来电已拒
    val setNoticeMissedCallV2: Boolean
    /// 结束查找手机
    val setOverFindPhone: Boolean
    /// 获取所有的健康监测开关
    val getHealthSwitchStateSupportV3: Boolean
    /// 久坐提醒
    val setSedentariness: Boolean
    /// 设置屏幕亮度
    val setScreenBrightness: Boolean
    /// 设置设备音乐音量
    val setSetPhoneVoice: Boolean
    /// 设置快捷来电回复开关
    val setSupportSetCallQuickReplyOnOff: Boolean
    /// 支持多运动交互中下发GPS坐标
    val setSupportExchangeSetGpsCoordinates: Boolean
    /// 支持v3天气协议下发大气压强
    val setSupportV3WeatherAddAtmosphericPressure: Boolean
    /// 支持v3天气协议下发积雪厚度
    val setSupportSetV3WeatcherAddSnowDepth: Boolean
    /// 支持v3天气协议下发降雪量
    val setSupportSetV3WeatcherAddSnowfall: Boolean
    /// 支持v3天气协议下发协议版本0x4版本
    val setSupportSetV3WeatcherSendStructVersion04: Boolean
    /// 支持设置压力校准阈
    val setSendCalibrationThreshold: Boolean
    /// 支持屏蔽跑步计划入口
    val getNotSupportAppSendRunPlan: Boolean
    /// 支持APP展示零星小睡睡眠数据
    val getSupportDisplayNapSleep: Boolean
    /// 支持app获取智能心率
    val getSupportGetSmartHeartRate: Boolean
    /// 支持app获取压力开关
    val getSupportGetPressureSwitchInfo: Boolean
    /// 支持电子卡片功能
    val getSupportECardOperate: Boolean
    /// 支持语音备忘录功能
    val getSupportVoiceMemoOperate: Boolean
    /// 支持晨报功能
    val getSupportMorningEdition: Boolean
    /// 支持app获取血氧饱和度开关
    val getSupportGetSpo2SwitchInfo: Boolean
    /// 支持同步心率使用version字段兼容
    val getSupportSyncHealthHrUseVersionCompatible: Boolean
    /// v3天气设置增加下发48小时天气数据
    val getSupportSetV3Add48HourWeatherData: Boolean
    /// 功能表开启后,室内跑步不支持获取最大摄氧量,app室内跑步不展示此数据
    val getNotSupportIndoorRunGetVo2max: Boolean
    /// 支持app设置心电图测量提醒
    val getSupportSetEcgReminder: Boolean
    /// 支持同步心电图(ecg)数据
    val getSupportSyncEcg: Boolean
    /// 支持游戏时间设置
    val getSupportSetGameTimeReminder: Boolean
    /// 支持配置默认的消息应用列表
    val getSupportConfigDefaultMegApplicationList: Boolean
    /// 支持app设置eci
    val getSupportSetEciReminder: Boolean
    /// 环境音量支持设置通知类型
    val setSupportNoiseSetNotifyFlag: Boolean
    /// 环境音量支持设置过高提醒
    val setSupportNoiseSetOverWarning: Boolean
    /// 支持设置版本信息
    val setSupportSetVersionInformation: Boolean
    /// 支持小程序操作
    val setSupportControlMiniProgram: Boolean
    /// 支持下发未来和历史空气质量数据
    val getSupportSetWeatherHistoryFutureAqi: Boolean
    /// 支持设置亮屏亮度时间
    val setBrightScreenTime: Boolean
    /// 支持设置心率过高过低提醒
    val setHeartSetRateModeCustom: Boolean
    /// 支持查询、设置 v3菜单列表
    val supportProtocolV3MenuList: Boolean
    /// 中文
    val languageCh: Boolean
    /// 捷克文
    val languageCzech: Boolean
    /// 英文
    val languageEnglish: Boolean
    /// 法文
    val languageFrench: Boolean
    /// 德文
    val languageGerman: Boolean
    /// 意大利文
    val languageItalian: Boolean
    /// 日文
    val languageJapanese: Boolean
    /// 西班牙文
    val languageSpanish: Boolean
    /// 阿拉伯语
    val languageArabic: Boolean
    /// 缅甸语
    val languageBurmese: Boolean
    /// 菲律宾语
    val languageFilipino: Boolean
    /// 希腊语
    val languageGreek: Boolean
    /// 泰国语
    val languageThai: Boolean
    /// 繁体中文
    val languageTraditionalChinese: Boolean
    /// 越南语
    val languageVietnamese: Boolean
    /// 荷兰文
    val languageDutch: Boolean
    /// 匈牙利文
    val languageHungarian: Boolean
    /// 立陶宛文
    val languageLithuanian: Boolean
    /// 波兰文
    val languagePolish: Boolean
    /// 罗马尼亚文
    val languageRomanian: Boolean
    /// 俄罗斯文
    val languageRussian: Boolean
    /// 斯洛文尼亚文
    val languageSlovenian: Boolean
    /// 乌克兰文
    val languageUkrainian: Boolean
    /// 克罗地亚语
    val languageCroatian: Boolean
    /// 丹麦语
    val languageDanish: Boolean
    /// 印地语
    val languageHindi: Boolean
    /// 印尼语
    val languageIndonesian: Boolean
    /// 韩语
    val languageKorean: Boolean
    /// 葡萄牙语
    val languagePortuguese: Boolean
    /// 斯洛伐克语
    val languageSlovak: Boolean
    /// 土耳其
    val languageTurkish: Boolean
    /// 波斯语
    val languagePersia: Boolean
    /// 瑞典语
    val languageSweden: Boolean
    /// 挪威语
    val languageNorwegian: Boolean
    /// 芬兰语
    val languageFinland: Boolean
    /// 孟加拉语
    val languageBengali: Boolean
    /// 高棉语
    val languageKhmer: Boolean
    /// 马来语
    val languageMalay: Boolean
    /// 巴西葡语
    val languageBrazilianPortuguese: Boolean
    /// 希伯来语
    val languageHebrew: Boolean
    /// 塞尔维亚语
    val languageSerbian: Boolean
    /// 保加利亚
    val languageBulgaria: Boolean
    /// v3 心率
    val syncV3Hr: Boolean
    /// v3 游泳
    val syncV3Swim: Boolean
    /// v3 血氧
    val syncV3Spo2: Boolean
    /// v3 压力
    val syncV3Pressure: Boolean
    /// v3 多运动
    val syncV3Activity: Boolean
    /// v3 睡眠
    val syncV3Sleep: Boolean
    /// v3 宠物睡眠
    val syncV3PetSleep: Boolean
    /// v3 步数
    val syncV3Sports: Boolean
    /// v3 gps
    val syncV3Gps: Boolean
    /// v3 闹钟
    val syncV3SyncAlarm: Boolean
    /// v3 身体电量
    val syncV3BodyPower: Boolean
    /// 同步hrv
    val getSupportHrvV3: Boolean
    /// 同步血压
    val getSupportPerBpV3: Boolean
    /// 同步噪音
    val syncV3Noise: Boolean
    /// 同步温度
    val syncV3Temperature: Boolean
    /// gps
    val syncGps: Boolean
    /// v3多运动同步数据交换
    val syncV3ActivityExchangeData: Boolean
    /// 心率功能
    val syncHeartRate: Boolean
    /// 心率监测
    val syncHeartRateMonitor: Boolean
    /// 睡眠检测
    val syncSleepMonitor: Boolean
    /// 快速同步
    val syncFastSync: Boolean
    /// 获取时间同步
    val syncActivityTimeSync: Boolean
    /// v2同步 时间线
    val syncTimeLine: Boolean
    /// 需要V2的同步
    val syncNeedV2: Boolean
    /// v3多运动同步支持实时速度显示
    val syncRealTimeV3: Boolean
    /// 数据交换增加实时的配速字段
    val syncExchangeDataReplyAddRealTimeSpeedPaceV3: Boolean
    /// 多运行结束时间使用UTC模式
    val syncHealthSyncV3ActivityEndTimeUseUtcMode: Boolean
    /// 支持数据同步时开启快速模式
    val syncSupportSetFastModeWhenSyncConfig: Boolean
    /// 支持获取app基本信息
    val getSupportAppBaseInformation: Boolean
    /// 闹钟个数
    val alarmCount: Int
    /// 刷牙
    val alarmBrushTeeth: Boolean
    /// 约会
    val alarmDating: Boolean
    /// 吃饭
    val alarmDinner: Boolean
    /// 吃药
    val alarmMedicine: Boolean
    /// 会议
    val alarmMeeting: Boolean
    /// 聚会
    val alarmParty: Boolean
    /// 休息
    val alarmRest: Boolean
    /// 睡觉
    val alarmSleep: Boolean
    /// 锻炼
    val alarmSport: Boolean
    /// 起床
    val alarmWakeUp: Boolean
    /// 支持设置防丢
    val supportSetAntilost: Boolean
    /// 支持设置v2天气数据
    val supportSetWeatherDataV2: Boolean
    /// 支持设置一键呼叫
    val supportSetOnetouchCalling: Boolean
    /// 支持设置运动中屏幕显示
    val supportOperateSetSportScreen: Boolean
    /// 支持设置应用列表样式
    val supportOperateListStyle: Boolean
    /// 支持情绪健康
    val supportEmotionHealth: Boolean
    /// 支持v3同步通讯录版本20
    val supportV3SyncContactVersion20: Boolean
    /// 支持SOS通话记录查询
    val supportGetSosCallRecord: Boolean
    /// alexa 语音提醒增加对应的时钟传输字段
    val alexaReminderAddSecV3: Boolean
    /// alexa 简单控制命令
    val alexaSetEasyOperateV3: Boolean
    /// alexa 语音闹钟获取设置命令使用
    val alexaSetGetAlexaAlarmV3: Boolean
    /// alexa 设置跳转运动界面
    val alexaSetJumpSportUiV3: Boolean
    /// alexa 设置跳转ui界面
    val alexaSetJumpUiV3: Boolean
    /// alexa app设置开关命令
    val alexaSetSetOnOffTypeV3: Boolean
    /// alexa 语音支持设置天气
    val alexaSetWeatherV3: Boolean
    /// alexa 支持设置多个定时器
    val alexaTimeNewV3: Boolean
    /// alexa 100级亮度控制
    val setAlexaControll100brightness: Boolean
    /// alexa 获取alexa默认语言
    val alexaGetSupportGetAlexaDefaultLanguage: Boolean
    /// alexa跳转运动界面支持100种运动类型字段
    val alexaGetUIControllSports: Boolean
    /// 支持获取左右手佩戴设置
    val getLeftRightHandWearSettings: Boolean
    /// 支持支持运动中设置提示音
    val supportSettingsDuringExercise: Boolean
    /// 支持身高单位设置(厘米/英寸)
    val supportHeightLengthUnit: Boolean
    /// 支持运动中提醒设置
    val supportSportingRemindSetting: Boolean
    /// 支持获取运动是否支持自动暂停结束
    val supportSportGetAutoPauseEnd: Boolean
    /// 支持步幅长度的单位设置(公制/英制)
    val supportSetStrideLengthUnit: Boolean
    /// 支持简单心率区间
    val supportSimpleHrZoneSetting: Boolean
    /// 开启功能表则关闭智能心率过低提醒
    val notSupportSmartLowHeartReatRemind: Boolean
    /// 开启功能表则关闭智能心率过高提醒
    val notSupportSmartHighHeartReatRemind: Boolean
    /// 设备是否不支持拍照推流
    val notSupportPhotoPreviewControl: Boolean
    /// 支持获取用户信息
    val supportGetUserInfo: Boolean
    /// 支持未接来电消息类型为485
    val supportMissedCallMsgTypeUseFixed: Boolean
    /// 支持闹钟不显示闹钟名称
    val supportAppNotDisplayAlarmName: Boolean
    /// 支持设置睡眠提醒
    val supportSetSleepRemind: Boolean
    /// 支持血糖
    val supportBloodGlucose: Boolean
    /// 支持血糖(v01)
    val supportBloodGlucoseV01: Boolean
    /// 车锁管理
    val supportBikeLockManager: Boolean
    /// 支持算法数据的采集
    val supportAlgorithmRawDataCollect: Boolean
    /// 支持离线地图
    val supportOfflineMapInformation: Boolean
    /// 开启则⽀持储备⼼率区间,关闭默认⽀持的最⼤⼼率区间
    val supportHeartRateReserveZones: Boolean
    /// 开启则⽀持⼼率区间⼼率最⼤值设置
    val supportHeartRateZonesHrMaxSet: Boolean
    /// 支持新的同步多运动数据（同步多运动/游泳/跑步课程/跑步计划/跑后拉伸数据）
    val supportSyncMultiActivityNew: Boolean
    /// 联系人存储支持使用固件返回大小
    val supportContactFileUseFirmwareReturnSize: Boolean
    /// 控制APP是否显示相机入口
    val supportDisplayCameraEntry: Boolean
    /// 支持家庭关心提醒设置
    val supportOperateFamilyCareReminder3376: Boolean
    /// 支持设置获取经期配置，使用v3长包指令
    val supportProtocolV3MenstruationConfig3377: Boolean
    /// 支持习惯养成设置
    val supportOperateHabitFormation: Boolean
    /// 支持版本v01习惯养成设置
    val supportOperateHabitFormationV01: Boolean
    /// 支持家庭步数下发
    val supportOperateFamilySteps: Boolean
    /// 支持游戏设置
    val supportOperateSetGame: Boolean
    /// 支持手势控制功能
    val supportOperateGestureControl: Boolean
}
