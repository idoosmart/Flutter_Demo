part of '../../ido_protocol_lib.dart';

extension _CmdEvtTypeMapping on CmdEvtType {
  Map<String, String>? _cmdInfo() {
    return _cmdMap[this];
  }
}

final _cmdMap = {
  CmdEvtType.getMac: {"desc": "获取mac地址", "cmd": "02 04"},
  CmdEvtType.getDeviceInfo: {"desc": "获取设备信息", "cmd": "02 01"},
  CmdEvtType.getFuncTable: {"desc": "获取功能表", "cmd": "02 02"},
  CmdEvtType.getFuncTableEx: {"desc": "获取功能表 扩展", "cmd": "02 07"},
  CmdEvtType.getLiveData: {"desc": "获得实时数据", "cmd": "02 A0"},
  CmdEvtType.getNoticeStatus: {"desc": "获取通知中心的状态", "cmd": "02 10"},
  CmdEvtType.getHrSensorParam: {"desc": "获取心率传感器参数", "cmd": "02 20"},
  CmdEvtType.getGSensorParam: {"desc": "获取加速度传感器参数", "cmd": "02 21"},
  CmdEvtType.getActivityCount: {"desc": "获取同步时间轴来计算百分比", "cmd": "02 00"},
  CmdEvtType.getHidInfo: {"desc": "获取hid信息", "cmd": "02 00"},
  CmdEvtType.getGpsInfo: {"desc": "获取gps信息", "cmd": "02 A3"},
  CmdEvtType.getGpsStatus: {"desc": "获取gps状态", "cmd": "02 A5"},
  CmdEvtType.getHotStartParam: {"desc": "获取热启动参数", "cmd": "02 A4"},
  CmdEvtType.getVersionInfo: {"desc": "获取版本信息", "cmd": "02 11"},
  CmdEvtType.getMtuInfo: {"desc": "获取mtu信息", "cmd": "02 F0"},
  CmdEvtType.getNotDisturbStatus: {"desc": "获取勿扰模式状态", "cmd": "02 30"},
  CmdEvtType.getDefaultSportType: {"desc": "获取默认的运动类型", "cmd": "02 00"},
  CmdEvtType.getDownLanguage: {"desc": "获取下载语言支持", "cmd": "02 00"},
  CmdEvtType.getErrorRecord: {"desc": "获取错误记录", "cmd": "02 00"},
  CmdEvtType.getMainSportGoal: {
    "desc": "获取设置的卡路里/距离/中高运动时长 主界面",
    "cmd": "02 43"
  },
  CmdEvtType.getWalkRemind: {"desc": "获取走动提醒", "cmd": "02 47"},
  CmdEvtType.getBatteryInfo: {"desc": "获取电池信息", "cmd": "02 05"},
  CmdEvtType.getFlashBinInfo: {"desc": "获取字库信息", "cmd": "02 A7"},
  CmdEvtType.getMenuList: {"desc": "获取设备支持的列表", "cmd": "02 A8"},
  CmdEvtType.getRealmeDevInfo: {"desc": "获取realme项目的硬件信息", "cmd": "02 60"},
  CmdEvtType.getScreenBrightness: {"desc": "获取屏幕亮度", "cmd": "02 B0"},
  CmdEvtType.getUpHandGesture: {"desc": "获取抬腕数据", "cmd": "02 00"},
  CmdEvtType.getEncryptedCode: {"desc": "获取授权数据", "cmd": "02 00"},
  CmdEvtType.getUpdateStatus: {"desc": "获取设备升级状态", "cmd": "02 00"},
  CmdEvtType.getWatchDialId: {"desc": "获取表盘id", "cmd": "02 00"},
  CmdEvtType.getWatchDialInfo: {"desc": "获取屏幕信息", "cmd": "02 00"},
  CmdEvtType.getDeviceName: {"desc": "获取手表名字", "cmd": "02 00"},
  CmdEvtType.getDeviceLogState: {"desc": "获取设备的日志状态", "cmd": "02 00"},
  CmdEvtType.getAllHealthSwitchState: {"desc": "获取所有的健康监测开关", "cmd": "02 00"},
  CmdEvtType.getDataTranConfig: {"desc": "文件传输配置传输获取", "cmd": "02 00"},
  CmdEvtType.getActivitySwitch: {"desc": "运动模式自动识别开关获取", "cmd": "02 00"},
  CmdEvtType.getFirmwareBtVersion: {"desc": "获得固件三级版本和bt的3级版本", "cmd": "02 00"},
  CmdEvtType.getStressVal: {"desc": "获取压力值", "cmd": "02 00"},
  CmdEvtType.getHeartRateMode: {"desc": "获取心率监测模式", "cmd": "02 00"},
  CmdEvtType.getLibVersion: {"desc": "获取lib版本号", "cmd": "02 00"},
  CmdEvtType.getAppID: {"desc": "获取appid ios only", "cmd": "02 00"},
  CmdEvtType.getWatchFaceList: {"desc": "获取表盘列表", "cmd": "02 00"},
  CmdEvtType.getBtNotice: {
    "desc": "查询bt配对开关、连接、a2dp连接、hfp连接状态(仅支持带bt蓝牙的设备)",
    "cmd": "02 00"
  },
  CmdEvtType.getSportTypeV3: {"desc": "v3 获取运动默认的类型", "cmd": "02 00"},
  CmdEvtType.getAlarmV3: {"desc": "v3 app获取ble的闹钟", "cmd": "02 00"},
  CmdEvtType.getLanguageLibraryDataV3: {"desc": "v3 获取设备字库列表", "cmd": "02 00"},
  CmdEvtType.getWatchListV3: {"desc": "v3 获取表盘列表", "cmd": "02 00"},
  CmdEvtType.getAlexaAlarmV3: {"desc": "v3 alexa获取v3的闹钟", "cmd": "02 00"},
  CmdEvtType.getBleMusicInfo: {"desc": "获取固件的歌曲名和文件夹", "cmd": "02 00"},
  CmdEvtType.getHistoricalMenstruation: {"desc": "经期的历史数据下发", "cmd": "02 00"},
  CmdEvtType.getPackName: {"desc": "获取应用包名", "cmd": "02 00"},
  CmdEvtType.getBleBeepV3: {"desc": "v3获取固件本地提示音文件信息", "cmd": "02 00"},
  CmdEvtType.getSupportMaxSetItemsNum: {
    "desc": "获取固件支持的详情最大设置数量",
    "cmd": "02 00"
  },
  CmdEvtType.getUnerasableMeunList: {"desc": "获取固件不可删除的快捷应用列表", "cmd": "02 00"},
  CmdEvtType.getMtuLengthSPP: {
    "desc": "获取固件spp mtu长度   新增  spp蓝牙专用",
    "cmd": "02 00"
  },
  CmdEvtType.getUnreadAppReminder: {"desc": "获取红点提醒开关", "cmd": "02 00"},
  CmdEvtType.getContactReviseTime: {
    "desc": "获取固件本地保存联系人文件修改时间",
    "cmd": "02 00"
  },
  CmdEvtType.getFlashLogStart: {"desc": "开始获取flash log", "cmd": "02 00"},
  CmdEvtType.getBatteryLog: {"desc": "获取电池日志", "cmd": "02 00"},
  CmdEvtType.setSendRunPlan: {"desc": "app下发跑步计划(运动计划)", "cmd": "03 00"},
  CmdEvtType.setWatchDialSort: {"desc": "设置表盘顺序", "cmd": "03 12"},
  CmdEvtType.setWalkRemindTimes: {"desc": "设置多个走动提醒的时间点", "cmd": "03 00"},
  CmdEvtType.setWorldTimeV3: {"desc": "v3 下发v3世界时间", "cmd": "03 00"},
  CmdEvtType.setWeatherV3: {"desc": "v3 下发v3天气协议", "cmd": "03 00"},
  CmdEvtType.setNoticeMessageState: {"desc": "v3 设置消息通知状态", "cmd": "03 00"},
  CmdEvtType.setLongCityNameV3: {"desc": "v3 设置运动城市名称", "cmd": "03 00"},
  CmdEvtType.setBaseSportParamSortV3: {"desc": "v3 设置运动子项数据排列", "cmd": "03 00"},
  CmdEvtType.setMainUISortV3: {"desc": "v3 设置主界面控件排序", "cmd": "03 00"},
  CmdEvtType.setSchedulerReminderV3: {"desc": "v3 设置日程提醒", "cmd": "03 00"},
  CmdEvtType.set100SportSortV3: {"desc": "v3 新的100种运动排序", "cmd": "03 00"},
  CmdEvtType.setWallpaperDialReplyV3: {"desc": "v3 设置壁纸表盘列表", "cmd": "03 00"},
  CmdEvtType.setAlexaAlarmV3: {"desc": "v3 alexa设置v3的闹钟", "cmd": "03 00"},
  CmdEvtType.setVoiceAlarmReminderV3: {"desc": "v3 语音设置提醒", "cmd": "03 00"},
  CmdEvtType.setVoiceAlarmV3: {"desc": "v3 语音设置闹钟数据", "cmd": "03 00"},
  CmdEvtType.setVoiceReplyTxtV3: {"desc": "v3 语音回复文本", "cmd": "03 00"},
  CmdEvtType.setFastMsgV3: {"desc": "v3 app设置回复快速信息", "cmd": "03 00"},
  CmdEvtType.setSportSortV3: {"desc": "设置运动类型排序 v3协议", "cmd": "03 00"},
  CmdEvtType.setAlarmV3: {"desc": "v3 app设置ble的闹钟", "cmd": "03 00"},
  CmdEvtType.setWatchFaceData: {"desc": "设置表盘", "cmd": "03 00"},
  CmdEvtType.setMusicOperate: {"desc": "操作歌曲或者文件夹", "cmd": "03 00"},
  CmdEvtType.setFastMsgUpdate: {"desc": "快速短信回复", "cmd": "03 00"},
  CmdEvtType.setDataTranConfigure: {"desc": "文件传输配置传输", "cmd": "03 00"},
  CmdEvtType.setUnreadAppReminder: {
    "desc": "gt01_pro app新增需求 未读信息红点提示开关",
    "cmd": "03 00"
  },
  CmdEvtType.setNotificationStatus: {
    "desc": "手机app通过这个命令开关，实现通知应用状态设置",
    "cmd": "03 00"
  },
  CmdEvtType.setFitnessGuidance: {"desc": "健身指导", "cmd": "03 00"},
  CmdEvtType.setScientificSleepSwitch: {"desc": "设置科学睡眠开关", "cmd": "03 00"},
  CmdEvtType.setTemperatureSwitch: {"desc": "设置夜间体温开关", "cmd": "03 00"},
  CmdEvtType.setV3Noise: {"desc": "环境音量的开关和阀值", "cmd": "03 00"},
  CmdEvtType.setHeartRateModeSmart: {"desc": "智能心率模式设置", "cmd": "03 00"},
  CmdEvtType.setOnceTestSpo2Pressure: {"desc": "血氧压力测试一次", "cmd": "03 00"},
  CmdEvtType.setTakingMedicineReminder: {"desc": "血氧压力测试一次", "cmd": "03 00"},
  CmdEvtType.setDevicesName: {"desc": "设置设备名称", "cmd": "03 00"},
  CmdEvtType.setClearOperation: {"desc": "删除日志", "cmd": "03 00"},
  CmdEvtType.setBleVoice: {"desc": "手机音量下发给ble", "cmd": "03 00"},
  CmdEvtType.setBleScreenColor: {"desc": "手机设置屏幕颜色 不加功能表", "cmd": "03 00"},
  CmdEvtType.setBleSharkingGrade: {"desc": "app控制手表的震动强度", "cmd": "03 00"},
  CmdEvtType.setLongSit: {"desc": "设置久坐", "cmd": "03 20"},
  CmdEvtType.setLostFind: {"desc": "设置防丢", "cmd": "03 21"},
  CmdEvtType.setTime: {"desc": "设置时间", "cmd": "03 01"},
  CmdEvtType.setSportGoal: {"desc": "设置运动目标", "cmd": "03 03"},
  CmdEvtType.setSleepGoal: {"desc": "设置睡眠目标", "cmd": "03 04"},
  CmdEvtType.setUserInfo: {"desc": "设置用户信息", "cmd": "03 10"},
  CmdEvtType.setUnit: {"desc": "设置单位", "cmd": "03 11"},
  CmdEvtType.setHand: {"desc": "设置左右手", "cmd": "03 22"},
  CmdEvtType.setAppOS: {"desc": "设置app系统", "cmd": "03 23"},
  CmdEvtType.setNotificationCenter: {"desc": "设置通知中心", "cmd": "03 00"},
  CmdEvtType.setHeartRateInterval: {"desc": "设置心率区间", "cmd": "03 24"},
  CmdEvtType.setHeartRateMode: {"desc": "设置心率模式", "cmd": "03 00"},
  CmdEvtType.setDefaultConfig: {"desc": "恢复模式设置", "cmd": "03 00"},
  CmdEvtType.setBindStart: {"desc": "绑定", "cmd": "03 00"},
  CmdEvtType.setBindRemove: {"desc": "解绑", "cmd": "03 00"},
  CmdEvtType.setAuthCode: {"desc": "授权码绑定", "cmd": "03 00"},
  CmdEvtType.setEncryptedAuth: {"desc": "发送计算好的授权数据", "cmd": "03 00"},
  CmdEvtType.setUpHandGesture: {"desc": "抬手亮屏", "cmd": "03 00"},
  CmdEvtType.setScreenBrightness: {"desc": "设置屏幕亮度", "cmd": "03 00"},
  CmdEvtType.setFindPhone: {"desc": "设置寻找手机", "cmd": "03 00"},
  CmdEvtType.setNotDisturb: {"desc": "勿扰模式", "cmd": "03 00"},
  CmdEvtType.setMusicOnOff: {"desc": "音乐开关", "cmd": "03 00"},
  CmdEvtType.setDisplayMode: {"desc": "显示模式", "cmd": "03 00"},
  CmdEvtType.setHrSensorParam: {"desc": "设置心率传感器参数", "cmd": "03 00"},
  CmdEvtType.setGSensorParam: {"desc": "设置加速度传感器参数", "cmd": "03 00"},
  CmdEvtType.setRealTimeSensorData: {"desc": "设置传感器实时数据", "cmd": "03 00"},
  CmdEvtType.setStartMotor: {"desc": "设置马达", "cmd": "03 00"},
  CmdEvtType.setOnekeySOS: {"desc": "设置一键呼叫", "cmd": "03 00"},
  CmdEvtType.setWeatherSwitch: {"desc": "设置天气开关", "cmd": "03 00"},
  CmdEvtType.setSportModeSelect: {"desc": "设置运动模式选择", "cmd": "03 00"},
  CmdEvtType.setSleepPeriod: {"desc": "设置睡眠时间段", "cmd": "03 00"},
  CmdEvtType.setWeatherData: {"desc": "设置天气数据", "cmd": "03 00"},
  CmdEvtType.setWeatherCityName: {"desc": "设置天气城市名称", "cmd": "03 00"},
  CmdEvtType.setWeatherRealtimeOne: {"desc": "设置当天0~8时实时天气+温度", "cmd": "03 00"},
  CmdEvtType.setWeatherRealtimeTwo: {
    "desc": "设置当天9~16时实时天气+温度",
    "cmd": "03 00"
  },
  CmdEvtType.setWeatherRealtimeThree: {
    "desc": "设置当天17~24时实时天气+温度",
    "cmd": "03 00"
  },
  CmdEvtType.setWeatherSunTime: {"desc": "设置日出日落时间", "cmd": "03 00"},
  CmdEvtType.setDevicesTestType: {"desc": "固件测试", "cmd": "03 00"},
  CmdEvtType.setIoTButtonName: {"desc": "设置iot按钮", "cmd": "03 00"},
  CmdEvtType.setIoTCommand: {"desc": "IoT按钮命令", "cmd": "03 00"},
  CmdEvtType.setWatchDial: {"desc": "设置表盘", "cmd": "03 00"},
  CmdEvtType.setShortcut: {"desc": "设置快捷方式", "cmd": "03 13"},
  CmdEvtType.setBpCalibration: {"desc": "血压校准", "cmd": "03 14"},
  CmdEvtType.setBpMeasurement: {"desc": "血压测量", "cmd": "03 00"},
  CmdEvtType.setStressCalibration: {"desc": "压力校准", "cmd": "03 00"},
  CmdEvtType.setGpsConfig: {"desc": "设置gps信息", "cmd": "03 00"},
  CmdEvtType.setGpsControl: {"desc": "控制gps", "cmd": "03 00"},
  CmdEvtType.setConnParam: {"desc": "控制连接参数", "cmd": "03 00"},
  CmdEvtType.setHotStartParam: {"desc": "设置热启动参数", "cmd": "03 00"},
  CmdEvtType.setMenstruation: {"desc": "设置经期", "cmd": "03 00"},
  CmdEvtType.setMenstruationRemind: {"desc": "设置经期提醒", "cmd": "03 00"},
  CmdEvtType.setCalorieDistanceGoal: {"desc": "卡路里和距离目标", "cmd": "03 00"},
  CmdEvtType.setSpo2Switch: {"desc": "设置血氧开关", "cmd": "03 00"},
  CmdEvtType.setStressSwitch: {"desc": "设置压力开关", "cmd": "03 00"},
  CmdEvtType.setNoticeStopCall: {"desc": "结束来电", "cmd": "03 00"},
  CmdEvtType.setNoticeMissedCall: {"desc": "未接来电", "cmd": "03 00"},
  CmdEvtType.setNoticeCallTime: {"desc": "来电接通完成后下发通话时间给固件", "cmd": "03 00"},
  CmdEvtType.setSportModeSort: {"desc": "设置运动模式排序", "cmd": "03 00"},
  CmdEvtType.setWalkRemind: {"desc": "设置走动提醒", "cmd": "03 00"},
  CmdEvtType.setBreatheTrain: {"desc": "呼吸训练", "cmd": "03 00"},
  CmdEvtType.setActivitySwitch: {"desc": "运动开关设置", "cmd": "03 00"},
  CmdEvtType.setDrinkWaterRemind: {"desc": "设置喝水提醒", "cmd": "03 00"},
  CmdEvtType.setRequestCheckUpdate: {"desc": "手环请求版本检查", "cmd": "03 00"},
  CmdEvtType.setRequestStartOTA: {"desc": "手环请求ota", "cmd": "03 00"},
  CmdEvtType.setOverFindPhone: {"desc": "停止寻找手机", "cmd": "03 00"},
  CmdEvtType.setHandWashingReminder: {"desc": "设置洗手提醒", "cmd": "03 00"},
  CmdEvtType.setRRespiRateTurn: {"desc": "设置呼吸率开关", "cmd": "03 00"},
  CmdEvtType.setBodyPowerTurn: {"desc": "设置身体电量开关", "cmd": "03 00"},
  CmdEvtType.setAlexaWeather: {"desc": "v3 alexa设置天气", "cmd": "03 00"},
  CmdEvtType.setNoticeAppName: {"desc": "设置通知app名字", "cmd": "03 00"},
  CmdEvtType.setNoticeIconInformation: {
    "desc": "app传输运动图标信息及状态通知固件",
    "cmd": "03 00"
  },
  CmdEvtType.setSyncContact: {"desc": "同步常用联系人", "cmd": "03 00"},
  CmdEvtType.exchangeAppStart: {"desc": "app 发起运动", "cmd": "10 00"},
  CmdEvtType.exchangeAppEnd: {"desc": "app 发起结束", "cmd": "10 00"},
  CmdEvtType.exchangeAppPause: {"desc": "app 发起暂停", "cmd": "10 00"},
  CmdEvtType.exchangeAppRestore: {"desc": "app 发起恢复", "cmd": "10 00"},
  CmdEvtType.exchangeAppPlan: {"desc": "app 运动计划操作", "cmd": "10 00"},
  CmdEvtType.exchangeAppV2Ing: {"desc": "app 发起数据v2交换过程", "cmd": "10 00"},
  CmdEvtType.exchangeAppV3Ing: {"desc": "app 发起数据v3交换过程", "cmd": "10 00"},
  CmdEvtType.exchangeAppGetV3HrData: {"desc": "app 获取v3心率数据", "cmd": "10 00"},
  CmdEvtType.exchangeAppGetActivityData: {
    "desc": "app 获取v3运动数据",
    "cmd": "10 00"
  },
  CmdEvtType.exchangeAppStartBlePause: {
    "desc": "app发起运动 ble操作暂停",
    "cmd": "10 00"
  },
  CmdEvtType.exchangeAppStartBleRestore: {
    "desc": "app发起运动 ble操作恢复",
    "cmd": "10 00"
  },
  CmdEvtType.exchangeAppStartBleEnd: {
    "desc": "app发起运动 ble操作结束",
    "cmd": "10 00"
  },
  CmdEvtType.exchangeAppStartBlePauseReply: {
    "desc": "app发起运动 ble操作暂停 app回复",
    "cmd": "10 00"
  },
  CmdEvtType.exchangeAppStartBleRestoreReply: {
    "desc": "app发起运动 ble操作恢复 app回复",
    "cmd": "10 00"
  },
  CmdEvtType.exchangeAppStartBleEndReply: {
    "desc": "app发起运动 ble操作结束 app回复",
    "cmd": "10 00"
  },
  CmdEvtType.exchangeAppBleStart: {"desc": "ble发起运动 ble操作开始", "cmd": "10 00"},
  CmdEvtType.exchangeAppBlePause: {"desc": "ble发起运动 ble操作暂停", "cmd": "10 00"},
  CmdEvtType.exchangeAppBleRestore: {"desc": "ble发起运动 ble操作恢复", "cmd": "10 00"},
  CmdEvtType.exchangeAppBleIng: {"desc": "ble发起运动 ble操作交换过程", "cmd": "10 00"},
  CmdEvtType.exchangeAppBleEnd: {"desc": "ble发起运动 ble操作结束", "cmd": "10 00"},
  CmdEvtType.exchangeAppBleStartReply: {
    "desc": "ble发起运动 发起运动开始 app回复",
    "cmd": "10 00"
  },
  CmdEvtType.exchangeAppBleEndReply: {
    "desc": "ble发起运动 发起运动结束 app回复",
    "cmd": "10 00"
  },
  CmdEvtType.exchangeAppBlePauseReply: {
    "desc": "ble发起运动 发起运动暂停 app回复",
    "cmd": "10 00"
  },
  CmdEvtType.exchangeAppBleRestoreReply: {
    "desc": "ble发起运动 发起运动恢复 app回复",
    "cmd": "10 00"
  },
  CmdEvtType.exchangeAppBleIngReply: {
    "desc": "ble发起运动 发起运动过程 app回复",
    "cmd": "10 00"
  },
  CmdEvtType.exchangeAppBlePlan: {
    "desc": "ble发起运动 操作运动计划 app回复",
    "cmd": "10 00"
  },
  CmdEvtType.alexaVoiceBleGetPhoneLoginState: {
    "desc": "蓝牙设备获取手机登录状态",
    "cmd": "00 00"
  },
  CmdEvtType.funcSimpleFileOpt: {"desc": "简单文件操作", "cmd": "00 00"},
  CmdEvtType.setMenuList: {"desc": "设置菜单列表", "cmd": "00 00"},
  CmdEvtType.setTakePicture: {"desc": "控制拍照", "cmd": "00 00"},
  CmdEvtType.connected: {"desc": "连接成功", "cmd": "00 00"},
  CmdEvtType.disconnect: {"desc": "断开连接", "cmd": "00 00"},
  CmdEvtType.otaStart: {"desc": "进入升级模式", "cmd": "00 00"},
  CmdEvtType.otaAuth: {"desc": "ota 授权", "cmd": "00 00"},
  CmdEvtType.otaDirectStart: {"desc": "直接进入升级模式(忽略电量)", "cmd": "00 00"},
  CmdEvtType.systemOff: {"desc": "进入关机模式", "cmd": "00 00"},
  CmdEvtType.reboot: {"desc": "重启设备", "cmd": "00 00"},
  CmdEvtType.controlDisconnect: {"desc": "控制断线", "cmd": "00 00"},
  CmdEvtType.cleanBindInfo: {"desc": "清除绑定信息", "cmd": "00 00"},
  CmdEvtType.shutdown: {"desc": "关闭设备", "cmd": "00 00"},
  CmdEvtType.factoryReset: {"desc": "恢复出厂设置", "cmd": "00 00"},
  CmdEvtType.clearCache: {"desc": "清除手环缓存", "cmd": "00 00"},
  CmdEvtType.setAlarm: {"desc": "设置闹钟", "cmd": "0x00 02"},
  CmdEvtType.setAddAlarm: {"desc": "添加闹钟", "cmd": "00 00"},
  CmdEvtType.musicStart: {"desc": "开始 (app -> ble)", "cmd": "00 00"},
  CmdEvtType.musicStop: {"desc": "停止 (app -> ble)", "cmd": "00 00"},
  CmdEvtType.photoStart: {"desc": "开始拍照 (app -> ble)", "cmd": "00 00"},
  CmdEvtType.photoStop: {"desc": "结束拍照 (app -> ble)", "cmd": "00 00"},
  CmdEvtType.findDeviceStart: {"desc": "寻找设备 (app -> ble)", "cmd": "00 00"},
  CmdEvtType.findDeviceStop: {"desc": "结束寻找设备 (app -> ble)", "cmd": "00 00"},
  CmdEvtType.openAncs: {"desc": "打开 ancs", "cmd": "00 00"},
  CmdEvtType.setAlexaIndecator: {"desc": "APP设置alexa通知状态", "cmd": "00 00"},
  CmdEvtType.setRecognitionState: {"desc": "APP设置识别后的状态", "cmd": "00 00"},
  CmdEvtType.setVoiceControlUi: {"desc": "APP下发alexa控制命令", "cmd": "00 00"},
  CmdEvtType.setControllCountDown: {
    "desc": "APP下发alexa控制倒数计时",
    "cmd": "00 00"
  },
  CmdEvtType.setControllSports: {"desc": "APP下发alexa多运动界面", "cmd": "00 00"},
  CmdEvtType.setControllUIJump: {"desc": "APP下发alexa跳转ui界面", "cmd": "00 00"},
  CmdEvtType.setControllAlexaMusic: {
    "desc": "APP下发alexa音乐控制界面",
    "cmd": "00 00"
  },
  CmdEvtType.setControllAlexaOnOff: {
    "desc": "APP设置alexa开关命令",
    "cmd": "00 00"
  },
  CmdEvtType.setControllAlexaStopwatch: {
    "desc": "APP开始定时器功能",
    "cmd": "00 00"
  },
  CmdEvtType.setControllAlexaAlarm: {"desc": "语音控制跳转闹钟界面", "cmd": "00 00"},
  CmdEvtType.musicControl: {"desc": "控制音乐 v3协议", "cmd": "00 00"},
  CmdEvtType.noticeMessageV3: {"desc": "通知消息提醒 v3协议", "cmd": "00 00"},
  CmdEvtType.innerTestCmd1: {"desc": "内部测试", "cmd": "00 00"},
  CmdEvtType.getBtName: {"desc": "获取bt蓝牙名称", "cmd": "00 00"},
  CmdEvtType.getSnInfo: {"desc": "获取SN", "cmd": "00 00"},
  CmdEvtType.getBpAlgVersion: {"desc": "获取血压算法三级版本号信息事件号", "cmd": "00 00"},
  CmdEvtType.getStepGoal: {"desc": "获取全天步数目标", "cmd": "00 00"},
  CmdEvtType.getActivityExchangeGpsData: {
    "desc": "v3 多运动数据数据交换中获取一段时间的gps数据",
    "cmd": "00 00"
  },
  CmdEvtType.getHabitInfoV3: {"desc": "v3获取固件本地提示音文件信息", "cmd": "00 00"},
  CmdEvtType.setBpCalControlV3: {"desc": "v3血压校准控制", "cmd": "00 00"},
  CmdEvtType.setHotStartParamV3: {"desc": "v3设置gps热启动参数", "cmd": "00 00"},
  CmdEvtType.setHeartMode: {"desc": "设置心率模式", "cmd": "00 00"},
  CmdEvtType.setNoticeOpenBroadcastn: {
    "desc": "app通知固件开启bt广播",
    "cmd": "00 00"
  },
  CmdEvtType.setNoticeDisableFunc: {
    "desc": "app被禁用功能权限导致某些功能无法启用，同时需要告知固件改功能已被禁用",
    "cmd": "00 00"
  },
  CmdEvtType.closeAncs: {"desc": "关闭 ancs", "cmd": "00 00"},
};
