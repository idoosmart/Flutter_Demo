// ignore_for_file: constant_identifier_names

/// 事件
enum CmdEvtType {
  // ----------------------------------- 获取 -----------------------------------

  /// 获取mac地址
  getMac(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_app_get_mac),

  /// 获取设备信息
  getDeviceInfo(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_device_info),

  /// 获取功能表
  getFuncTable(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_func_table_user),

  /// 获取功能表 扩展
  getFuncTableEx(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_func_table_ex),

  /// 获取sn
  getSnInfo(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_sn_info),

  /// 获取单位
  getUnit(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_unit),

  /// 获取bt蓝牙名称
  getBtName(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_bt_name),

  /// 获得实时数据
  getLiveData(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_live_data),

  /// 获取通知中心的状态
  getNoticeStatus(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_notice_status),

  /// 获取心率传感器参数
  getHrSensorParam(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_hr_sensor_param),

  /// 获取加速度传感器参数
  getGSensorParam(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_gsensor_param),

  /// 获取同步时间轴来计算百分比
  getActivityCount(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_activity_count),

  /// 获取hid信息
  getHidInfo(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_hid_info),

  /// 获取gps信息
  getGpsInfo(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_gps_info),

  /// 获取gps状态
  getGpsStatus(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_gps_status),

  /// 获取热启动参数
  getHotStartParam(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_hot_start_param),

  /// 获取版本信息
  getVersionInfo(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_version_info),

  /// 获取mtu信息
  getMtuInfo(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_mtu_info),

  /// 获取勿扰模式状态
  getNotDisturbStatus(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_do_not_disturb),

  /// 获取默认的运动类型
  getDefaultSportType(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_default_sport_type),

  /// 获取下载语言支持
  getDownLanguage(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_down_language),

  /// 获取错误记录
  getErrorRecord(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_error_record),

  /// 获取设置的卡路里/距离/中高运动时长 主界面
  getMainSportGoal(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_main_sport_goal),

  /// 获取走动提醒
  getWalkRemind(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_walk_reminder),

  /// 获取电池信息
  getBatteryInfo(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_batt_info),

  /// 获取字库信息
  getFlashBinInfo(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_flash_bin_info),

  /// 获取设备支持的列表
  getMenuList(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_menu_list),

  /// 获取realme项目的硬件信息
  getRealmeDevInfo(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_realme_dev_info),

  /// 获取屏幕亮度
  getScreenBrightness(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_screen_brightness),

  /// 获取抬腕数据
  getUpHandGesture(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_up_hand_gesture),

  /// 获取授权数据
  getEncryptedCode(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_encrypted_code),

  /// APP下发配对结果
  sendBindResult(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_send_bind_result),

  /// 获取设备升级状态
  getUpdateStatus(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_update_state),

  /// 获取表盘id
  getWatchDialId(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_watch_id),

  /// 获取屏幕信息
  getWatchDialInfo(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.func_get_screen_ifno),

  /// 获取手表名字
  getDeviceName(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_devices_name),

  /// 获取设备的日志状态
  getDeviceLogState(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_devices_log_state),

  /// 获取所有的健康监测开关
  getAllHealthSwitchState(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_all_health_switch_state),

  /// 文件传输配置传输获取
  getDataTranConfig(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_data_tran_configure),

  /// 运动模式自动识别开关获取
  getActivitySwitch(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_activity_switch),

  /// 获得固件三级版本和bt的3级版本
  getFirmwareBtVersion(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_get_firmware_bt_version),

  /// 获取压力值
  getStressVal(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_stress_val),

  /// 获取血压算法三级版本号信息事件号
  getBpAlgVersion(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_bp_alg_version),

  /// 获取心率监测模式
  getHeartRateMode(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_heart_rate_mode),

  /// 获取全天步数目标
  getStepGoal(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_step_goal),

  /// 获取lib版本号
  getLibVersion(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.func_get_lib_version),

  /// 获取appid ios only
  getAppID(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.func_get_ancs_appid),

  /// 获取表盘列表
  getWatchFaceList(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.func_get_watch_face_list),

  /// 查询bt配对开关、连接、a2dp连接、hfp连接状态(仅支持带bt蓝牙的设备)
  getBtNotice(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_set_bt_notice),

  /// v3 获取运动默认的类型
  getSportTypeV3(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.func_v3_get_sport_type),

  /// v3 app获取ble的闹钟
  getAlarmV3(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.func_v3_get_alarm),

  /// v3 获取设备字库列表
  getLanguageLibraryDataV3(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.func_v3_get_language_library_data),

  /// v3 获取表盘列表
  getWatchListV3(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.func_v3_get_watch_list_new),

  /// v3 alexa获取v3的闹钟
  getAlexaAlarmV3(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.func_v3_alexa_gte_alarm2),

  /// v3 多运动数据数据交换中获取一段时间的gps数据
  getActivityExchangeGpsData(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.func_v3_get_activity_exchange_gps_data),

  /// 获取固件的歌曲名和文件夹
  getBleMusicInfo(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.func_v3_get_ble_music_info),

  /// 经期的历史数据下发
  getHistoricalMenstruation(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.func_v3_get_historical_menstruation),

  /// 获取应用包名
  getPackName(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.tran_json_get_app_pack_name
  ),

  /// v3获取固件本地提示音文件信息
  getBleBeepV3(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.func_v3_get_ble_beep
  ),

  /// v3获取固件本地提示音文件信息
  getHabitInfoV3(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.func_v3_get_habit_information
  ),

  /// 获取固件支持的详情最大设置数量
  getSupportMaxSetItemsNum(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_support_max_set_items_num
  ),

  /// 获取固件不可删除的快捷应用列表
  getUnerasableMeunList(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_undeleteable_meun_list
  ),

  /// 获取固件spp mtu长度   新增  spp蓝牙专用
  getMtuLengthSPP(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_mtu_length_spp
  ),

  /// 获取红点提醒开关
  getUnreadAppReminder(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_unread_app_onoff
  ),

  /// 获取固件本地保存联系人文件修改时间
  getContactReviseTime(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.app_get_contact_revice_time
  ),

  /// 开始获取flash log
  getFlashLogStart(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.func_flash_log_start
  ),

  /// 停止获取flash log
  getFlashLogStop(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.func_flash_log_stop
  ),

  /// 获取电池日志
  getBatteryLog(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.func_get_v3_battery_log
  ),

  /// 获取BT连接手机型号
  getBtConnectPhoneModel(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.func_v3_get_bt_connect_phone_model
  ),

  /// app智能心率模式获取
  getHeartRateModeSmart(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.vbus_evt_app_get_heart_rate_mode_smart
  ),


  /// 获取血氧开关
  getSpo2Switch(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.vbus_evt_app_get_spo2
  ),


  /// 获取压力开关
  getStressSwitch(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.vbus_evt_app_get_pressure
  ),

  /// 获取固件算法文件信息（ACC/GPS）
  getAlgFile(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.vbus_evt_func_v3_get_operate_alg_file
  ),

  /// 支持获取运动记录的显示项配置
  getSportRecordShowConfig(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.vbus_evt_func_v3_sport_record_show_config
  ),

// ----------------------------------- 设置 -----------------------------------

  /// app下发跑步计划(运动计划)
  setSendRunPlan(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.func_v3_send_run_plan),

  /// 设置表盘顺序
  setWatchDialSort(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.func_v3_set_watch_dial_sort),

  /// v3血压校准控制
  setBpCalControlV3(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.func_v3_bp_cal_control),

  /// 设置多个走动提醒的时间点
  setWalkRemindTimes(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.func_v3_set_walk_remind_times),

  /// v3 下发v3世界时间
  setWorldTimeV3(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.func_v3_set_world_time),

  /// v3设置gps热启动参数
  setHotStartParamV3(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.func_v3_set_hot_start_param),

  /// v3 下发v3天气协议
  setWeatherV3(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.func_v3_set_v3_weather),

  /// v3 设置消息通知状态
  setNoticeMessageState(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.tran_json_set_notice_message_state),

  /// v3 设置运动城市名称
  setLongCityNameV3(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.func_v3_set_long_city_name),

  /// v3 设置运动子项数据排列
  setBaseSportParamSortV3(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.func_v3_base_sport_param_sort),

  /// v3 设置主界面控件排序
  setMainUISortV3(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.func_v3_main_ui_sort),

  /// v3 设置日程提醒
  setSchedulerReminderV3(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.func_v3_scheduler_reminder),

  /// v3 新的100种运动排序
  set100SportSortV3(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.func_v3_set_100_sport_sort),

  /// v3 设置壁纸表盘列表
  setWallpaperDialReplyV3(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.func_v3_set_wallpaper_dial_reply),

  /// v3 alexa设置v3的闹钟
  setAlexaAlarmV3(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.func_v3_alexa_ste_alarm2),

  /// v3 语音设置提醒
  setVoiceAlarmReminderV3(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.func_v3_set_voice_set_reminder),

  /// v3 语音设置闹钟数据
  setVoiceAlarmV3(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.func_v3_set_voice_set_alarm),

  /// v3 语音回复文本
  setVoiceReplyTxtV3(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.func_v3_set_voice_reply_txt),

  /// v3 app设置回复快速信息
  setFastMsgV3(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.func_v3_set_fast_msg),

  /// 设置运动类型排序 v3协议
  setSportSortV3(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.func_v3_sport_sort),

  /// v3 app设置ble的闹钟
  setAlarmV3(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.func_v3_set_alarm),

  /// 设置表盘
  setWatchFaceData(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.func_set_watch_face_data),

  /// 操作歌曲或者文件夹
  setMusicOperate(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.func_v3_operate_ble_music),

  /// 快速短信回复
  setFastMsgUpdate(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_ble_to_app_fast_msg_updata),

  /// 文件传输配置传输
  setDataTranConfigure(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_data_tran_configure),

  /// gt01_pro app新增需求 未读信息红点提示开关
  setUnreadAppReminder(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_unread_app_reminder),

  /// 手机app通过这个命令开关，实现通知应用状态设置
  setNotificationStatus(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_notification_status),

  /// 健身指导
  setFitnessGuidance(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_fitness_guidance),

  /// 设置科学睡眠开关
  setScientificSleepSwitch(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_scientific_sleep_switch),

  /// 设置夜间体温开关
  setTemperatureSwitch(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_temperature_switch),

  /// 环境音量的开关和阀值
  setV3Noise(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_v3_noise),

  /// 设置心率模式 v3
  setHeartMode(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.func_v3_set_hr_mode),

  /// 智能心率模式设置
  setHeartRateModeSmart(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_heart_rate_mode_smart),

  /// 血氧压力测试一次
  setOnceTestSpo2Pressure(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_once_test_spo2_pressure),

  /// 设置吃药提醒
  setTakingMedicineReminder(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_taking_medicine_reminder),

  /// 设置设备名称
  setDevicesName(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_set_devices_name),

  /// 删除日志
  setClearOperation(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_clear_operations),

  /// 手机音量下发给ble
  setBleVoice(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_ble_voice),

  /// 手机设置屏幕颜色 不加功能表
  setBleScreenColor(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_ble_screen_color),

  /// app控制手表的震动强度
  setBleSharkingGrade(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_ble_sharking_grade),

  /// 设置久坐
  setLongSit(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_long_sit),

  /// 设置防丢
  setLostFind(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_lost_find),

  /// 设置时间
  setTime(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_time),

  /// 设置运动目标
  setSportGoal(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_sport_goal),

  /// 设置睡眠目标
  setSleepGoal(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_sleep_goal),

  /// 设置用户信息
  setUserInfo(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_user_info),

  /// 设置单位
  setUnit(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_unit),

  /// 设置左右手
  setHand(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_hand),

  /// 设置app系统
  setAppOS(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_app_os),

  /// 设置通知中心
  setNotificationCenter(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_notice),

  /// 设置心率区间
  setHeartRateInterval(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_heart_rate_interval),

  /// 设置心率模式
  setHeartRateMode(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_heart_rate_mode),

  /// 恢复模式设置
  setDefaultConfig(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_default_config),

  /// 绑定
  setBindStart(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_bind_start),

  /// 解绑
  setBindRemove(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_bind_remove),

  /// 授权码绑定
  setAuthCode(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_auth),

  /// 发送计算好的授权数据
  setEncryptedAuth(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_encrypted_auth),

  /// 抬手亮屏
  setUpHandGesture(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_up_hand_gesture),

  /// 设置屏幕亮度
  setScreenBrightness(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_screen_brightness),

  /// 设置寻找手机
  setFindPhone(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_find_phone),

  /// 勿扰模式
  setNotDisturb(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_do_not_disturb),

  /// 音乐开关
  setMusicOnOff(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_muisc_onoff),

  /// 显示模式
  setDisplayMode(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_display_mode),

  /// 设置心率传感器参数
  setHrSensorParam(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_hr_sensor_param),

  /// 设置加速度传感器参数
  setGSensorParam(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_gsensor_param),

  /// 设置传感器实时数据
  setRealTimeSensorData(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_real_time_sensor_data),

  /// 设置马达
  setStartMotor(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_start_motot),

  /// 设置一键呼叫
  setOnekeySOS(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_onekey_sos),

  /// 设置天气开关
  setWeatherSwitch(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_weather_switch),

  /// 设置运动模式选择
  setSportModeSelect(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_sport_mode_select),

  /// 设置睡眠时间段
  setSleepPeriod(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_sleep_period),

  /// 设置天气数据
  setWeatherData(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_weatcher_data),

  /// 设置天气城市名称
  setWeatherCityName(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_weatcher_city_name),

  /// 设置当天0~8时实时天气+温度
  setWeatherRealtimeOne(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_weatcher_real_time_one),

  /// 设置当天9~16时实时天气+温度
  setWeatherRealtimeTwo(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_weatcher_real_time_two),

  /// 设置当天17~24时实时天气+温度
  setWeatherRealtimeThree(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_weatcher_real_time_three),

  /// 设置日出日落时间
  setWeatherSunTime(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_weatcher_set_sun_time),

  /// 固件测试
  setDevicesTestType(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.devices_test_type),

  /// 设置iot按钮
  setIoTButtonName(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_iot_button_name),

  /// IoT按钮命令
  setIoTCommand(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_ble_to_app_iot_command),

  /// 设置表盘
  setWatchDial(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_watch_dial),

  /// 设置快捷方式
  setShortcut(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_shortcut),

  /// 血压校准
  setBpCalibration(
      evtBase: _VBusEvtBase.base_app_set, evtType: _VBusEvtType.app_set_bp_cal),

  /// 血压测量
  setBpMeasurement(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_bp_measure),

  /// 压力校准
  setStressCalibration(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_stress_cal),

  /// 设置gps信息
  setGpsConfig(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_config_gps),

  /// 控制gps
  ///
  /// ```dart
  /// operate: 1 控制 , 2 查询
  /// type: 0x01 开启log,0x02 关闭log,0x03 agps写入,0x04 agps 擦除,0x05 gps_fw 写入,
  /// 示例 {"operate": 1,"type": 2}
  /// ```
  setGpsControl(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_control_gps),

  /// 控制连接参数
  setConnParam(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_conn_param),

  /// 设置热启动参数
  setHotStartParam(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_hot_start_param),

  /// 设置经期
  setMenstruation(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_menstruation),

  /// 设置经期提醒
  setMenstruationRemind(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_menstruation_remind),

  /// 卡路里和距离目标
  setCalorieDistanceGoal(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_calorie_distance_goal),

  /// 设置血氧开关
  setSpo2Switch(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_spo2),

  /// 设置压力开关
  setStressSwitch(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_pressure),

  /// 结束来电
  setNoticeStopCall(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_notice_stop_call),

  /// 未接来电
  setNoticeMissedCall(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_notice_missed_call),

  /// 来电接通完成后下发通话时间给固件
  setNoticeCallTime(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_notice_call_time),

  /// 设置运动模式排序
  setSportModeSort(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_sport_mode_sort),

  /// 设置走动提醒
  setWalkRemind(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_walk_reminder),

  /// 呼吸训练
  setBreatheTrain(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_breathe_train),

  /// 运动开关设置
  setActivitySwitch(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_activity_switch),

  /// 设置喝水提醒
  setDrinkWaterRemind(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_drink_water_reminder),

  /// 手环请求版本检查
  setRequestCheckUpdate(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_ble_to_app_request_check_update),

  /// 手环请求ota
  setRequestStartOTA(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_ble_to_app_request_start_ota),

  /// 停止寻找手机
  setOverFindPhone(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_over_fing_phone),

  /// 设置洗手提醒
  setHandWashingReminder(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_set_hand_washing_reminder),

  /// 设置呼吸率开关
  setRRespiRateTurn(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_respi_rate_on_off),

  /// 设置身体电量开关
  setBodyPowerTurn(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_body_power_on_off),

  /// v3 alexa设置天气
  setAlexaWeather(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.func_v3_alexa_set_weather),

  /// V3动态消息通知
  setNoticeAppName(
    evtBase: _VBusEvtBase.base_app_set,
    evtType: _VBusEvtType.func_v3_notice_message_add_app_name
  ),

  /// app传输运动图标信息及状态通知固件
  setNoticeIconInformation(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_app_to_ble_notcie_icon_informationg
  ),

  /// app通知固件开启bt广播
  setNoticeOpenBroadcastn(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_app_to_ble_notcie_open_broadcast
  ),

  /// app被禁用功能权限导致某些功能无法启用，同时需要告知固件改功能已被禁用
  setNoticeDisableFunc(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_app_to_ble_notcie_disable_func
  ),

  /// 同步常用联系人
  setSyncContact(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.tran_json_sync_contact
  ),

  /// 日历提醒
  setCalendarReminder(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.vbus_evt_func_v3_calendear_reminder
  ),

  /// 电子卡片
  setEcardControl(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.vbus_evt_func_v3_ecard_control
  ),

  /// 语音备忘录
  setVoiceMemo(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.vbus_evt_func_v3_voice_memo
  ),

  /// 晨报
  setMorningEdition(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.vbus_evt_func_v3_morning_edition
  ),

  /// 设置默认的消息应用列表
  setDefaultMsgList(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.vbus_evt_func_v3_config_mes_list
  ),

  /// 设置紧急联系人（ECI）方式
  setECI(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.vbus_evt_func_v3_set_eci
  ),

  /// 手机app通过这个命令开关，设置固件版本信息
  setVersionInfo(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_version_information
  ),

  /// 发送小程序操作
  setAppletControl(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.vbus_evt_func_send_mini_program_control
  ),

  // ----------------------------------- 数据交换 -----------------------------------

  /// app 发起运动
  exchangeAppStart(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_switch_app_staert),

  /// app 发起结束
  exchangeAppEnd(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_switch_app_end),

  /// app 发起暂停
  exchangeAppPause(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_switch_app_pause),

  /// app 发起恢复
  exchangeAppRestore(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_switch_app_restore),

  /// app 运动计划操作
  exchangeAppPlan(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.func_v3_app_to_ble_sport_cutover),

  /// app 发起数据v2交换过程
  exchangeAppV2Ing(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_switch_app_ing),

  /// app 发起数据v3交换过程
  exchangeAppV3Ing(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.func_v3_activity_data_exchange),

  /// app 获取v3心率数据
  exchangeAppGetV3HrData(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.func_v3_get_activity_exchange_heart_rate_data),

  /// app 获取v3运动数据
  exchangeAppGetActivityData(
      evtBase: _VBusEvtBase.base_app_get,
      evtType: _VBusEvtType.func_v3_get_activity_data),

  /// app发起运动 ble操作暂停
  exchangeAppStartBlePause(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_switch_app_ble_pause),

  /// app发起运动 ble操作恢复
  exchangeAppStartBleRestore(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_switch_app_ble_restore),

  /// app发起运动 ble操作结束
  exchangeAppStartBleEnd(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_switch_app_ble_end),

  /// app发起运动 ble操作暂停 app回复
  exchangeAppStartBlePauseReply(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_switch_app_ble_pause),

  /// app发起运动 ble操作恢复 app回复
  exchangeAppStartBleRestoreReply(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_switch_app_ble_restore),

  /// app发起运动 ble操作结束 app回复
  exchangeAppStartBleEndReply(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_switch_app_ble_end),

  /// ble发起运动 ble操作开始
  exchangeAppBleStart(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_switch_ble_start),

  /// ble发起运动 ble操作暂停
  exchangeAppBlePause(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_switch_ble_pause),

  /// ble发起运动 ble操作恢复
  exchangeAppBleRestore(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_switch_ble_restore),

  /// ble发起运动 ble操作交换过程
  exchangeAppBleIng(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_switch_ble_ing),

  /// ble发起运动 ble操作结束
  exchangeAppBleEnd(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_switch_ble_end),

  /// ble发起运动 发起运动开始 app回复
  exchangeAppBleStartReply(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_switch_ble_start),

  /// ble发起运动 发起运动结束 app回复
  exchangeAppBleEndReply(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_switch_ble_end),

  /// ble发起运动 发起运动暂停 app回复
  exchangeAppBlePauseReply(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_switch_ble_pause),

  /// ble发起运动 发起运动恢复 app回复
  exchangeAppBleRestoreReply(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_switch_ble_restore),

  /// ble发起运动 发起运动过程 app回复
  exchangeAppBleIngReply(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_switch_ble_ing),

  /// ble发起运动 操作运动计划 app回复
  exchangeAppBlePlan(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.func_v3_ble_to_app_sport_cutover
  ),

  // ----------------------------------- Alexa -----------------------------------
  /// 蓝牙设备获取手机登录状态
  alexaVoiceBleGetPhoneLoginState(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.voice_ble_get_phone_login_state
  ),


  // ----------------------------------- 其他 -----------------------------------

  /// 简单文件操作
  funcSimpleFileOpt(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.func_simple_file_operations),

  /// 设置菜单列表
  setMenuList(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_menu_list),

  /// 控制拍照
  setTakePicture(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_take_picture),

  /// 连接成功
  connected(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.set_ble_evt_connect),

  /// 断开连接
  disconnect(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.set_ble_evt_disconnect),

  /// 进入升级模式
  otaStart(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_ota_start),

  /// ota 授权
  otaAuth(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_ota_auth),

  /// 直接进入升级模式(忽略电量)
  otaDirectStart(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_ota_direct_start),

  /// 进入关机模式
  systemOff(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_system_off),

  /// 重启设备
  reboot(evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_reboot),

  /// 控制断线
  controlDisconnect(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_control_disconnect),

  /// 清除绑定信息
  cleanBindInfo(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_clean_bond_info),

  /// 关闭设备
  shutdown(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_shutdown),

  /// 恢复出厂设置
  factoryReset(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_restore_fazctory),

  /// 清除手环缓存
  clearCache(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_clear_cache),

  /// 设置闹钟
  setAlarm(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_alarm),

  /// 设置闹钟
  setAddAlarm(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.func_add_alarm),

  /// 开始 (app -> ble)
  musicStart(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_app_to_ble_music_start),

  /// 停止 (app -> ble)
  musicStop(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_app_to_ble_music_stop),

  /// 开始拍照 (app -> ble)
  photoStart(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_app_to_ble_photo_start),

  /// 结束拍照 (app -> ble)
  photoStop(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_app_to_ble_photo_stop),

  /// 寻找设备 (app -> ble)
  findDeviceStart(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_app_to_ble_find_device_start),

  /// 结束寻找设备 (app -> ble)
  findDeviceStop(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_app_to_ble_find_device_stop),

  /// 打开 ancs
  openAncs(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_app_to_ble_open_ancs),

  /// 关闭 ancs
  closeAncs(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_app_to_ble_close_ancs),

  /// APP设置alexa通知状态
  setAlexaIndecator(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.voice_phone_set_alexa_notify_state),

  /// APP设置识别后的状态
  setRecognitionState(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.voice_phone_set_recognition_state),

  /// APP下发alexa控制命令
  setVoiceControlUi(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.voice_set_ui_controll_easy_operation),

  /// APP下发alexa控制倒数计时
  setControllCountDown(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.voice_set_ui_controll_count_down),

  /// APP下发alexa多运动界面
  setControllSports(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.voice_set_ui_controll_sports),

  /// APP下发alexa跳转ui界面
  setControllUIJump(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.voice_set_ui_controll_jump),

  /// APP下发alexa音乐控制界面
  setControllAlexaMusic(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.voice_set_ui_controll_music_controll),

  /// APP设置alexa开关命令
  setControllAlexaOnOff(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.voice_set_on_off_type),

  /// APP开始定时器功能
  setControllAlexaStopwatch(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.voice_set_ui_controll_stopwatch),

  /// 语音控制跳转闹钟界面
  setControllAlexaAlarm(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.voice_set_ui_controll_alarm),

  /// 控制音乐 v3协议
  musicControl(
  evtBase: _VBusEvtBase.base_app_set,
  evtType: _VBusEvtType.func_v3_music_control),

  /// 通知消息提醒 v3协议
  noticeMessageV3(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.func_v3_notice_message),

  /// 内部测试
  innerTestCmd1(
  evtBase: _VBusEvtBase.base_app_set,
  evtType: _VBusEvtType.app_protocol_test_cmd_1),

  /// 设置来电快捷回复开关
  setCallQuickReplyOnOff(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_call_quick_reply_on_off),

  /// 设置手机语音助手开关
  setVoiceAssistantOnOff(
      evtBase: _VBusEvtBase.base_app_set,
      evtType: _VBusEvtType.app_set_voice_assistant_on_off);

  const CmdEvtType({required this.evtBase, required this.evtType});

  final int evtBase;
  final int evtType;

  static CmdEvtType? fromRawValue(int rawValue)  {
    if (_cmdMap.isEmpty) {
      for (var e in CmdEvtType.values) {
          _cmdMap[e.evtType] = e;
      }
    }
    return _cmdMap[rawValue];
  }
}

final _cmdMap = <int,CmdEvtType>{};

/// 事件的方向
abstract class _VBusEvtBase {
  /// 内部使用
  static const int base_set = 8192;
  static const int base_get = 8448;

  /// 内部使用
  static const int base_ble_reply = 8704;

  /// 通知
  static const int base_notice_app = 8960;

  /// 设置
  static const int base_app_set = 9216;

  /// 获取
  static const int base_app_get = 9472;

  /// c库请求
  static const int base_request = 9728;
}

/// 事件类型
abstract class _VBusEvtType {
  static const int none = 0;

  /// 连接成功
  static const int set_ble_evt_connect = 1;

  /// 断开连接
  static const int set_ble_evt_disconnect = 2;

  /// 闹钟同步完成
  static const int sync_evt_alrm_sync_complete = 3;

  /// 配置同步完成
  static const int sync_evt_config_sync_complete = 4;

  /// 健康数据同步完成
  static const int sync_evt_health_sync_complete = 5;

  /// 健康数据同步进度,进度在data (0-100) (uint32_t)data
  static const int sync_evt_health_progress = 6;

  /// 闹钟同步进度 struct protocol_set_alarm_progress_s
  static const int sync_evt_alarm_progress = 7;

  /// 8
  static const int sync_evt_health_processing = 8;
  static const int sync_evt_alarm_processing = 9;

  /// 10
  static const int sync_evt_config_processing = 10;

  /// 连接以后,快速同步完成
  static const int sync_evt_config_fast_sync_complete = 11;

  /// 中间状态	重发控制
  static const int sync_evt_activity_stop_once = 12;
  static const int sync_evt_activity_start_once = 13;

  /// 同步活动项进度(0-100)
  static const int sync_evt_activity_processing = 14;

  /// 15 数据传输的进度
  static const int sync_evt_data_tran_processing = 15;

  /// 16数据传输完成,注意错误值
  static const int sync_evt_data_tran_complete = 16;

  /// gps 同步进度
  static const int sync_evt_gps_processing = 17;

  /// //v3 健康数据同步完成
  static const int sync_evt_v3_health_complete = 18;

  /// 19 v3 健康数据同步进度 血氧 和压力
  static const int sync_evt_v3_health_processing = 19;

  /// 20 数据传输的进度  spp传输进度
  static const int sync_evt_data_tran_processing_spp = 20;

  /// 21数据传输完成,注意错误值  spp传输进度完成
  static const int sync_evt_data_tran_complete_spp = 21;

  /// (22) v3健康数据同步单项数据完成通知 2022-7-26
  static const int sync_evt_v3_health_each_type_items_complete = 22;

  /// 设置闹钟
  static const int app_set_alarm = 100;

  /// 设置久坐 struct protocol_long_sit
  static const int app_set_long_sit = 101;

  /// 设置防丢 struct protocol_lost_find
  static const int app_set_lost_find = 102;

  /// 设置寻找手机 struct protocol_find_phone
  static const int app_set_find_phone = 103;

  /// 设置时间 struct protocol_set_time
  static const int app_set_time = 104;

  /// 设置运动目标 struct protocol_set_sport_goal
  static const int app_set_sport_goal = 105;

  /// 设置睡眠目标
  static const int app_set_sleep_goal = 106;

  /// 设置用户信息 struct protocol_set_user_info
  static const int app_set_user_info = 107;

  /// 设置单位 struct protocol_set_unit
  static const int app_set_unit = 108;

  /// 设置左右手 struct protocol_set_handle
  static const int app_set_hand = 109;

  /// 110
  static const int app_set_app_os = 110;

  /// 设置通知中心 struct protocol_set_notice
  static const int app_set_notice = 111;

  /// 设置心率区间 struct protocol_heart_rate_interval
  static const int app_set_heart_rate_interval = 112;

  /// 设置心率模式 struct protocol_heart_rate_mode
  static const int app_set_heart_rate_mode = 113;

  /// 抬手亮屏 struct protocol_set_up_hand_gesture
  static const int app_set_up_hand_gesture = 114;

  /// 恢复模式设置
  static const int app_set_default_config = 115;

  /// 勿扰模式 protocol_do_not_disturb
  static const int app_set_do_not_disturb = 116;

  /// 音乐开关 struct protocol_music_onoff
  static const int app_set_muisc_onoff = 117;

  /// 显示模式 struct protocol_display_mode
  static const int app_set_display_mode = 118;

  /// 设置一键呼叫 struct protocol_set_onekey_sos
  static const int app_set_onekey_sos = 119;

  /// 120 设置心率传感器参数 struct protocol_heart_rate_sensor_param
  static const int app_set_hr_sensor_param = 120;

  /// 设置加速度传感器参数 struct protocol_gsensor_param
  static const int app_set_gsensor_param = 121;

  /// 设置传感器实时数据 struct protocol_set_real_time_health_data_status
  static const int app_set_real_time_sensor_data = 122;

  /// 设置马达 struct protocol_set_start_motor
  static const int app_set_start_motot = 123;

  /// 设置表盘struct protocol_set_watch_dial,struct protocol_set_watch_dial_reply
  static const int app_set_watch_dial = 124;

  /// 设置快捷方式 struct protocol_set_shortcut,struct protocol_set_shortcut_reply
  static const int app_set_shortcut = 125;

  /// 126血压校准 struct protocol_set_bp_cal,struct protocol_set_bp_cal_reply
  static const int app_set_bp_cal = 126;

  /// 血压测量struct protocol_control_bp_measure,struct protocol_control_bp_measure_reply
  static const int app_set_bp_measure = 127;

  /// 压力校准protocol_set_stress_cal,struct protocol_set_stress_cal_reply
  static const int app_set_stress_cal = 128;

  /// 129 停止寻找手机 struct protocol_control_over_find_phone,struct protocol_control_over_find_phone
  static const int app_set_over_fing_phone = 129;

  /// 设置开关	struct protocol_cmd,cmd1
  static const int app_set_weather_switch = 150;

  /// 设置运动模式选择    protocol_sport_mode_select_bit或者 struct protocol_sport_mode_select
  static const int app_set_sport_mode_select = 151;

  /// 设置睡眠时间段 struct protocol_sleep_period
  static const int app_set_sleep_period = 152;

  /// （153）设置天气数据  struct protocol_weatch_data
  static const int app_weatcher_data = 153;

  /// （154）设置屏幕亮度 struct protocol_screen_brightness
  static const int app_set_screen_brightness = 154;

  /// 设置gps信息 struct protocol_config_gps
  static const int app_set_config_gps = 155;

  /// 控制gps struct protocol_control_gps ,struct protocol_control_gps_reply
  static const int app_set_control_gps = 156;

  /// 控制连接参数 struct protocol_conn_param,struct protocol_conn_param_reply
  static const int app_set_conn_param = 157;

  /// 设置热启动参数 struct protocol_hot_start_param
  static const int app_set_hot_start_param = 158;

  /// 设置经期 struct protocol_set_menstrual
  static const int app_set_menstruation = 159;

  /// （160）设置经期提醒 struct protocol_set_menstrual_remind
  static const int app_set_menstruation_remind = 160;

  /// 卡路里和距离目标 struct protocol_set_calorie_distance_goal 功能表calorie_goal/distance_goal
  static const int app_set_calorie_distance_goal = 161;

  /// 设置血氧开关struct protocol_set_spo2, struct protocol_set_spo2_reply
  static const int app_set_spo2 = 162;

  /// （163）设置压力开关struct protocol_set_pressure
  static const int app_set_pressure = 163;

  /// 设置运动模式排序 struct protocol_sport_mode_sort
  static const int app_set_sport_mode_sort = 164;

  /// （165）设置走动提醒	struct protocol_set_walk_reminder
  static const int app_set_walk_reminder = 165;

  /// 呼吸训练	struct protocol_set_breathe_train
  static const int app_set_breathe_train = 166;

  /// 运动开关设置 struct protocol_activity_switch
  static const int app_set_activity_switch = 167;

  /// 设置喝水提醒 struct protocol_drink_water_reminder
  static const int app_set_drink_water_reminder = 168;

  /// 设置iot按钮 struct protocol_iot_button_name
  static const int app_set_iot_button_name = 169;

  /// （170）iot按钮命令 struct protocol_iot_command
  static const int app_ble_to_app_iot_command = 170;

  /// 设置菜单列表 struct protocol_set_menu_list
  static const int app_set_menu_list = 171;

  /// 控制拍照  struct protocol_take_picture
  static const int app_set_take_picture = 172;

  /// 删除日志 struct protocol_clear_operator; struct protocol_clear_operator_reply
  static const int app_set_clear_operations = 173;

  /// 手机音量下发给ble  struct protocol_set_device_voice,struct protocol_set_device_voice_reply
  static const int app_set_ble_voice = 174;

  /// 设置洗手提醒  struct protocol_set_hand_washing_reminder , struct protocol_set_base_reply
  static const int app_set_set_hand_washing_reminder = 175;

  /// 设置设备名称 struct protocol_set_device_name,  struct protocol_set_device_name_reply
  static const int app_set_set_devices_name = 176;

  /// 设置吃药提醒  struct protocol_taking_medicine_reminder, struct protocol_set_base_reply
  static const int app_set_taking_medicine_reminder = 177;

  /// 血氧压力测试一次  功能表：once_test_spo2_pressure；  设置结构体：protocol_start_once_test_spo2_pressure； 获取结构体 protocol_start_once_test_spo2_pressure_reply
  static const int app_set_once_test_spo2_pressure = 178;

  /// 手机设置屏幕颜色 不加功能表；  设置结构体：struct protocol_set_ble_screen_color  回复的结构体：struct protocol_set_base_reply
  static const int app_set_ble_screen_color = 179;

  /// app控制同步配置开关；控制是否需要设备重启的时候，so主动同步所有的数据  protocol_sync_config_set_reboot_auto_sync(bool)
  static const int app_set_to_sync_all_config = 180;

  /// app控制手表的震动强度  struct protocol_set_ble_sharking_grade ，  struct protocol_set_base_reply
  static const int app_set_ble_sharking_grade = 181;

  /// app智能心率模式设置  struct protocol_set_smart_heart_rate_mode,   struct protocol_set_smart_heart_rate_mode_reply
  static const int app_set_heart_rate_mode_smart = 182;

  /// 环境音量的开关和阀值 struct protocol_set_v3_noise,  struct protocol_set_base_reply
  static const int app_set_v3_noise = 183;

  /// 设置科学睡眠开关 struct protocol_set_v3_scientific_sleep_switch, struct protocol_set_base_reply
  static const int app_set_scientific_sleep_switch = 184;

  /// 设置夜间体温开关 struct protocol_set_v3_temperature, struct protocol_set_base_reply
  static const int app_set_temperature_switch = 185;

  /// 健身指导 struct protocol_set_fitness_guidance, struct protocol_set_base_reply
  static const int app_set_fitness_guidance = 186;

  /// 文件传输配置传输 struct protocol_data_tran_configure_set struct protocol_data_com_reply
  static const int app_set_data_tran_configure = 187;

  /// gt01_pro app新增需求 未读信息红点提示开关   protocol_set_unread_app_reminder   protocol_set_base_reply
  static const int app_set_unread_app_reminder = 188;

  /// 手机app通过这个命令开关，实现通知应用状态设置   struct protocol_set_notification_status    struct protocol_set_base_reply
  static const int app_set_notification_status = 190;

  /// 手机app通过这个命令开关，设置呼吸率开关  struct protocol_set_respi_rate_on_off
  static const int app_set_respi_rate_on_off = 191;

  /// 手机app通过这个命令开关，设置身体电量开关  struct protocol_set_body_power_on_off
  static const int app_set_body_power_on_off = 192;

  /// 设置手机语音助手开关 struct protocol_set_voice_assistant_on_off
  static const int app_set_voice_assistant_on_off = 193;

  /// 设置来电快捷回复开关  struct protocol_set_call_quick_reply_on_off
  static const int app_set_call_quick_reply_on_off = 194;

  /// 手机app通过这个命令开关，设置固件版本信息
  static const int app_set_version_information = 195;

  /// 绑定	struct protocol_start_bind,struct protocol_start_bind_reply
  static const int app_bind_start = 200;

  /// 解绑
  static const int app_bind_remove = 201;

  /// 开始授权 struct protocol_start_auth,struct protocol_start_auth_reply
  static const int app_auth = 202;

  /// 绑定拒绝
  static const int app_bind_refuse = 203;

  /// 发送计算好的授权数据     struct protocol_start_encrypted_auth,struct protocol_start_encrypted_auth_reply
  static const int app_set_encrypted_auth = 204;

  /// 获取授权数据    04 06,protocol_start_aut_code_reply
  static const int app_get_encrypted_code = 205;

  /// APP下发配对结果   04 07,struct protocol_app_send_bind_resulte
  static const int app_send_bind_result = 206;

  /// 获得设备信息so临时保存
  static const int app_get_device_info_lin = 209;

  /// 获得设备信息 单独事件 不会组合一起下发获取bt名称指令 初次绑定时使用此事件去获取设备信息struct protocol_device_info
  static const intapp_get_device_info_only = 290;

  /// 获得mac struct protocol_device_mac
  static const int app_app_get_mac = 300;

  /// 获得设备信息 struct protocol_device_info
  static const int app_get_device_info = 301;

  /// (302)(内部使用)
  static const int app_get_func_table = 302;

  /// 获取功能表 struct protocol_get_func_table
  static const int app_get_func_table_user = 303;

  /// 获得实时数据 struct protocol_get_live_data,struct protocol_get_live_data_reply
  static const int app_get_live_data = 304;

  /// 获取设备时间 struct protocol_device_time
  static const int app_get_device_time = 305;

  /// 获取通知中心的状态 struct protocol_head head，struct protocol_set_notice
  static const int app_get_notice_status = 306;

  /// (307)获取心率传感器参数 struct protocol_heart_rate_sensor_param
  static const int app_get_hr_sensor_param = 307;

  /// 加速度传感器  struct protocol_gsensor_param
  static const int app_get_gsensor_param = 308;

  /// 获取同步时间轴来计算百分比 struct protocol_new_health_activity_count
  static const int app_get_activity_count = 309;

  /// (310)获取hid信息 返回struct protocol_get_hid_info_reply
  static const int app_get_hid_info = 310;

  /// 获取扩展功能表
  static const int app_get_func_table_ex = 311;

  /// 获取gps信息 struct protocol_get_gps_info
  static const int app_get_gps_info = 312;

  /// 获取热启动参数 struct protocol_hot_start_param
  static const int app_get_hot_start_param = 313;

  /// 获取gps状态  struct protocol_get_gps_status
  static const int app_get_gps_status = 314;

  /// (315)获取版本信息 struct protocol_version_info
  static const int app_get_version_info = 315;

  /// 获取勿扰模式状态 struct protocol_do_not_disturb
  static const int app_get_do_not_disturb = 316;

  /// 获取mtu信息 struct protocol_get_mtu_info
  static const int app_get_mtu_info = 317;

  /// 获取默认的运动类型 struct protocol_get_default_sport_type
  static const int app_get_default_sport_type = 318;

  /// 获取下载语言支持 protocol_get_down_language
  static const int app_get_down_language = 319;

  /// (320)获取错误记录 struct protocol_get_error_record,struct protocol_get_error_record_reply
  static const int app_get_error_record = 320;

  /// 获取电池信息 struct protocol_device_batt_info
  static const int app_get_batt_info = 321;

  /// 获取字库信息 struct protocol_flash_bin_info
  static const int app_get_flash_bin_info = 322;

  /// 获取设备支持的列表  struct protocol_get_menu_list
  static const int app_get_menu_list = 323;

  /// 获取realme项目的硬件信息 struct protocol_get_realme_dev_info_reply
  static const int app_get_realme_dev_info = 324;

  /// （325）获取屏幕亮度 struct protocol_head, protocol_get_screen_brightness_reply
  static const int app_get_screen_brightness = 325;

  /// （326）获取抬腕数据 struct protocol_head, protocol_get_up_hand_gesture_reply
  static const int app_get_up_hand_gesture = 326;

  /// （327）获取设备升级状态 struct protocol_head, protocol_get_device_update_state
  static const int app_get_update_state = 327;

  /// （328）获取表盘id struct protocol_head, struct protocol_get_watch_id_reply
  static const int app_get_watch_id = 328;

  /// ( 329 )获取手表名字  struct protocol_get_device_name_reply
  static const int app_get_devices_name = 329;

  /// ( 330 ) 获取设备的日志状态   struct protocol_get_device_log_state_reply
  static const int app_get_devices_log_state = 330;

  /// 获取设置的卡路里/距离/中高运动时长 主界面  struct protocol_set_calorie_distance_goal
  static const int app_get_main_sport_goal = 331;

  /// 获取走动提醒  struct protocol_set_walk_reminder
  static const int app_get_walk_reminder = 332;

  /// 获取所有的健康监测开关  struct protocol_head head; struct protocol_get_health_switch_state_reply
  static const int app_get_all_health_switch_state = 333;

  /// 文件传输配置传输获取 struct protocol_data_tran_configure_get，  struct protocol_data_tran_configure_get_reply
  static const int app_get_data_tran_configure = 334;

  /// 运动模式自动识别开关获取 struct protocol_head head;  struct protocol_get_activity_switch_reply
  static const int app_get_activity_switch = 335;

  /// 获得固件三级版本和bt的3级版本  struct protocol_firmware_bt_version_info_reply
  static const int app_get_get_firmware_bt_version = 336;

  /// 获取压力值 struct protocol_head,protocol_get_stress_val_reply
  static const int app_get_stress_val = 337;

  /// 获取血压算法三级版本号信息
  static const int app_get_bp_alg_version = 338;

  /// 获取固件支持的详情最大设置数量
  static const int app_get_support_max_set_items_num = 339;

  /// 获取固件不可删除的快捷应用列表
  static const int app_get_undeleteable_meun_list = 340;

  /// 获取sn
  static const int app_get_sn_info = 341;

  /// 获取单位
  static const int app_get_unit = 342;

  /// 检查重启状态,非协议,用于内部状态处理
  static const int check_reboot = 350;

  /// 获取获取固件红点提示开关状态   struct protocol_head ,struct protocol_unread_app_reminder
  static const int app_get_unread_app_onoff = 351;

  /// 查询bt配对开关、连接、a2dp连接、hfp连接状态(仅支持带bt蓝牙的设备)   struct protocol_head ,struct protocol_set_bt_notice
  static const int app_get_set_bt_notice = 352;

  /// 获取固件本地保存联系人文件修改时间  struct protocol_head ,
  static const int app_get_contact_revice_time = 353;

  /// 获取bt蓝牙名称   struct protocol_head , struct protocol_get_bt_name
  static const int app_get_bt_name = 354;

  /// 处理关闭353定时器事件
  static const int app_get_contact_revice_time_stop_timer = 355;

  /// 进入升级模式	; struct protocol_ota_reply 里面包含电量标志
  static const int app_ota_start = 400;

  /// 直接进入升级模式(忽略电量)
  static const int app_ota_direct_start = 401;

  /// 进入关机模式
  static const int app_system_off = 402;

  /// 重启设备
  static const int app_reboot = 403;

  /// 控制断线 struct protocol_control_disconnect
  static const int app_control_disconnect = 404;

  /// 清除绑定信息,
  static const int app_clean_bond_info = 405;

  /// 关闭设备
  static const int app_shutdown = 406;

  /// ota 授权 struct protocol_ota_auth,  struct protocol_ota_auth_reply
  static const int app_ota_auth = 407;

  /// 恢复出厂设置 set_restore_factory_reply
  static const int app_restore_fazctory = 408;

  /// 清除手环缓存  struct protocol_set_reply
  static const int app_clear_cache = 409;

  /// 发送来电事件，android
  static const int app_set_notice_call = 410;

  /// 通知app
  static const int app_set_notice_msg = 411;

  /// 结束来电
  static const int app_set_notice_stop_call = 412;

  /// 处理中,内部事件
  static const int app_set_notice_call_processing = 413;
  static const int app_set_notice_msg_processing = 414;

  /// 来电接通完成后下发通话时间给固件
  static const int app_set_notice_call_time = 415;

  /// 未接来电
  static const int app_set_notice_missed_call = 420;

  /// 获取心率监测模式
  static const int app_get_heart_rate_mode = 421;

  /// 获取全天步数目标
  static const int app_get_step_goal = 422;

  /// 开始
  static const int app_app_to_ble_music_start = 500;

  /// 停止
  static const int app_app_to_ble_music_stop = 501;

  /// 开始拍照
  static const int app_app_to_ble_photo_start = 502;

  /// 结束拍照
  static const int app_app_to_ble_photo_stop = 503;

  /// 寻找设备
  static const int app_app_to_ble_find_device_start = 504;

  /// 结束寻找设备
  static const int app_app_to_ble_find_device_stop = 505;

  static const int app_app_to_ble_open_ancs = 506;

  static const int app_app_to_ble_close_ancs = 507;

  /// app传输运动图标信息及状态通知固件     struct protocol_notice_icon_information
  static const int app_app_to_ble_notcie_icon_informationg = 511;

  /// app通知固件开启bt广播    struct protocol_head head;
  static const int app_app_to_ble_notcie_open_broadcast = 512;

  /// app被禁用功能权限导致某些功能无法启用，同时需要告知固件改功能已被禁用     struct protocol_notice_disable_func
  static const int app_app_to_ble_notcie_disable_func = 513;

  /// 手环控制app
  static const int app_ble_to_app_evt_base = 550;

  /// 开始
  static const int app_ble_to_app_music_start = 551;

  /// 暂停
  static const int app_ble_to_app_music_pause = 552;

  /// 停止
  static const int app_ble_to_app_music_stop = 553;

  /// 上一首
  static const int app_ble_to_app_music_last = 554;

  /// 下一首
  static const int app_ble_to_app_music_next = 555;

  /// 单拍
  static const int app_ble_to_app_photo_single_shot = 556;

  /// 连拍
  static const int app_ble_to_app_photo_burst = 557;

  /// 音量+
  static const int app_ble_to_app_volume_up = 558;

  /// 音量-
  static const int app_ble_to_app_volume_down = 559;

  /// 打开相机
  static const int app_ble_to_app_open_camera = 560;

  /// 关闭相机
  static const int app_ble_to_app_close_camera = 561;

  /// 接听电话
  static const int app_ble_to_app_phone_answer = 562;

  /// 拒接电话
  static const int app_ble_to_app_phone_reject = 563;

  /// 控制音乐百分比
  static const int app_ble_to_app_volume_percentage = 565;

  /// 寻找手机开始
  static const int app_ble_to_app_find_phone_start = 570;

  /// 寻找手机结束
  static const int app_ble_to_app_find_phone_stop = 571;

  /// 防丢启动
  static const int app_ble_to_app_anti_lost_start = 572;

  /// 防丢结束
  static const int app_ble_to_app_anti_lost_stop = 573;

  /// 一键
  static const int app_ble_to_app_onekey_sos_start = 574;

  /// 传感器数据通知 struct protocol_sensor_data_notice
  static const int app_ble_to_app_sensor_data_notice = 575;

  /// 设备操作  struct protocol_device_operate
  static const int app_ble_to_app_device_operate = 576;

  /// 手环数据更新,struct protocol_control_data_update
  static const int app_ble_to_app_data_update = 577;

  /// 手环请求版本检查 ,struct protocol_ble_request_check_update_reply
  static const int app_ble_to_app_request_check_update = 578;

  /// 手环请求ota struct protocol_ble_request_start_ota_reply
  static const int app_ble_to_app_request_start_ota = 579;

  /// 快速短信回复 struct protocol_control_msg_notify(固件到app),struct protocol_control_msg_notify_reply（app回复）
  static const int app_ble_to_app_fast_msg_updata = 580;

  /// 系统相机控制的ui界面
  static const int app_ble_to_app_device_photograph = 581;

  /// 固件喇叭音量回复 struct protocol_control_speaker_value(固件到app),struct protocol_control_speaker_value_reply（app回复）
  static const int app_ble_to_app_speaker_value = 591;

  /// app发送开始 struct protocol_switch_app_start
  static const int app_switch_app_staert = 600;

  /// app 开始应答	struct protocol_switch_app_start_reply
  static const int app_switch_app_start_reply = 601;

  /// 交换过程中	struct protocol_switch_app_ing
  static const int app_switch_app_ing = 602;

  /// 交换应答	struct protocol_switch_app_ing_reply
  static const int app_switch_app_ing_reply = 603;

  /// 结束		struct protocol_switch_app_end
  static const int app_switch_app_end = 604;

  /// struct protocol_switch_app_end_reply
  static const int app_switch_app_end_reply = 605;

  /// struct protocol_switch_app_pause
  static const int app_switch_app_pause = 606;

  /// struct protocol_switch_app_pause_reply
  static const int app_switch_app_pause_reply = 607;

  /// struct protocol_switch_app_restore
  static const int app_switch_app_restore = 608;

  /// struct protocol_switch_app_restore_reply
  static const int app_switch_app_restore_reply = 609;

  /// struct protocol_switch_app_ble_pause
  static const int app_switch_app_ble_pause = 610;

  /// struct protocol_switch_app_ble_pause_reply
  static const int app_switch_app_ble_pause_reply = 611;

  /// struct protocol_switch_app_ble_restore
  static const int app_switch_app_ble_restore = 612;

  /// struct protocol_switch_app_ble_restore_reply
  static const int app_switch_app_ble_restore_reply = 613;

  /// struct struct protocol_switch_app_ble_end
  static const int app_switch_app_ble_end = 614;

  /// struct struct protocol_switch_app_ble_end_reply
  static const int app_switch_app_ble_end_reply = 615;

  /// struct protocol_switch_app_time
  static const int app_switch_app_ble_time = 616;

  /// struct protocol_switch_app_time_reply
  static const int app_switch_app_ble_time_reply = 617;

  /// 获取多运动5个心率值,struct protocol_switch_app_get_hr_interval,struct protocol_switch_app_get_hr_interval_reply
  static const int app_switch_app_get_hr_interval = 618;

  /// ble 发送	struct protocol_switch_ble_start
  static const int app_switch_ble_start = 620;

  /// ble 发送应答	struct protocol_switch_ble_start_reply
  static const int app_switch_ble_start_reply = 621;

  /// 交换过程中	struct protocol_switch_ble_ing
  static const int app_switch_ble_ing = 622;

  /// struct protocol_switch_ble_ing_reply
  static const int app_switch_ble_ing_reply = 623;

  /// 结束	struct protocol_switch_ble_end
  static const int app_switch_ble_end = 624;
  static const int app_switch_ble_end_reply = 625;

  /// struct protocol_switch_ble_pause
  static const int app_switch_ble_pause = 626;

  /// struct protocol_switch_ble_pause_reply
  static const int app_switch_ble_pause_reply = 627;

  /// struct protocol_switch_ble_restore
  static const int app_switch_ble_restore = 628;

  /// struct protocol_switch_ble_restore_reply
  static const int app_switch_ble_restore_reply = 629;

  /// 活动项同步超时
  static const int app_activity_sync_timeout = 650;

  /// 所有活动项目同步完成
  static const int app_activity_sync_complete = 651;

  /// 单次数据同步完成通知,android 使用
  static const int app_activity_sync_once_complete_json_noteice = 652;

  /// gps同步完成
  static const int app_gps_sync_complete = 653;

  /// 数据传输完成
  static const int app_data_tran_complete = 700;

  /// 数据传输错误
  static const int app_data_tran_error = 701;

  /// 数据传输进度
  static const int app_data_tran_processing = 702;

  /// 内部测试
  static const int app_protocol_test_cmd_1 = 900;

  /// struct protocol_beacon_head_set
  static const int ibeacon_write_head = 1000;

  /// struct protocol_beacon_retcode
  static const int ibeacon_write_head_reply = 1001;

  /// struct protocol_beacon_uuid_set
  static const int ibeacon_write_uuid = 1002;

  /// struct protocol_beacon_retcode
  static const int ibeacon_write_uuid_reply = 1003;

  /// struct protocol_beacon_write_passwd
  static const int ibeacon_write_password = 1004;

  /// struct protocol_beacon_retcode
  static const int ibeacon_write_password_reply = 1005;
  static const int ibeacon_get_head = 1006;

  /// struct protocol_beacon_ret_head
  static const int ibeacon_get_head_repy = 1007;
  static const int ibeacon_get_uuid = 1008;

  /// struct protocol_beacon_ret_uuid
  static const int ibeacon_get_uuid_reply = 1009;

  /// 添加闹钟
  static const int func_add_alarm = 5000;

  /// 获取版本号
  static const int func_get_lib_version = 5001;

  /// v3同步开始命令
  static const int func_start_sync_v3_health = 5002;

  /// v3同步结束指令
  static const int func_stop_sync_v3_health = 5003;

  /// 获取appid ios only
  static const int func_get_ancs_appid = 5004;

  /// 设置ancs  ios only
  static const int func_set_ancs_param = 5005;

  /// 获取表盘列表,用于android,ios使用c接口
  static const int func_get_watch_face_list = 5006;

  /// 获取屏幕信息,用于android,ios使用c接口
  static const int func_get_screen_ifno = 5007;

  /// 设置表盘,用于android,ios使用c接口
  static const int func_set_watch_face_data = 5008;

  /// 制作表盘,用于android,ios使用c接口
  static const int func_mk_watch_face = 5009;

  /// 设置心率模式 v3协议
  static const int func_v3_set_hr_mode = 5010;

  /// 控制音乐 v3协议
  static const int func_v3_music_control = 5011;

  /// 通知消息提醒 v3协议
  static const int func_v3_notice_message = 5012;

  /// 设置运动类型排序 v3协议
  static const int func_v3_sport_sort = 5013;

  /// v3 获取运动默认的类型
  static const int func_v3_get_sport_type = 5016;

  /// v3 app设置ble的闹钟
  static const int func_v3_set_alarm = 5017;

  /// v3 app获取ble的闹钟
  static const int func_v3_get_alarm = 5018;

  /// v3 app获取手环过热日志
  static const int func_v3_get_heat_log = 5019;

  /// v3 app设置回复快速信息 struct protocol_set_fast_msg_reply
  static const int func_v3_set_fast_msg = 5020;

  /// v3 多运动数据交互 protocol_v3_activity_exchange， struct sync_activity_exchange_reply
  static const int func_v3_activity_data_exchange = 5021;

  /// v3 多运动数据最后一次数据获取 protocol_v3_base， struct protocol_get_activity_data_reply
  static const int func_v3_get_activity_data = 5022;

  /// v3 多运动数据数据交换中获取1分钟的心率数据  protocol_v3_base， struct sync_activity_exchange_hr_data_reply
  static const int func_v3_get_activity_exchange_heart_rate_data = 5023;

  /// v3 3获取设备字库列表   protocol_v3_base， struct protocol_get_language_reply
  static const int func_v3_get_language_library_data = 5024;

  /// v3 语音回复文本  struct protocol_v3_voice_reply_txt_message  struct protocol_set_reply
  static const int func_v3_set_voice_reply_txt = 5025;

  /// v3 同步数据子项目同步头部数据上传上层  struct v3_head_data
  static const int func_v3_get_head_pack = 5026;

  /// v3 同步数据总包个数和总延时上传上层  struct protocol_v3_all_date_dely
  static const int func_v3_get_head_all_pack_delay = 5027;

  /// v3 语音设置闹钟数据 struct protocol_v3_voice_alarm_set_data ;  struct protocol_set_reply
  static const int func_v3_set_voice_set_alarm = 5028;

  /// v3 语音设置提醒 struct protocol_v3_voice_reminder_set_data； struct protocol_set_reply
  static const int func_v3_set_voice_set_reminder = 5029;

  /// v3 多运动数据数据交换中获取一段时间的gps数据 struct sync_activity_exchange_gps_data_reply
  static const int func_v3_get_activity_exchange_gps_data = 5030;

  /// v3 获取功能表 protocol_v3_function_table_get_function_table_table(); struct protocol_v3_function_table_data_decode_reply
  static const int func_v3_get_v3_function_table = 5031;

  /// v3 alexa设置天气  struct protocol_v3_alexa_set_weather_set_data,struct protocol_set_reply
  static const int func_v3_alexa_set_weather = 5032;

  /// v3 alexa获取v3的闹钟   struct protocol_v3_base; struct protocol_v3_voice_alarm_set_data_add;
  static const int func_v3_alexa_gte_alarm2 = 5033;

  /// v3 alexa设置v3的闹钟   struct protocol_v3_voice_alarm_set_data_add,  struct protocol_set_reply
  static const int func_v3_alexa_ste_alarm2 = 5034;

  /// v3 获取表盘列表       ，struct protocol_v3_file_list_item
  static const int func_v3_get_watch_list_new = 5035;

  /// v3新的置表盘列表, struct protocol_v3_set_wallpaper_dial, struct protocol_v3_set_wallpaper_dial_reply
  static const int func_v3_set_wallpaper_dial_reply = 5036;

  /// v3新的100种运动排序,  struct protocol_v3_100_sport_mode_sort, struct protocol_v3_100_sport_mode_sort_reply
  static const int func_v3_set_100_sport_sort = 5037;

  /// v3 设置日程提醒, struct protocol_schedule_reminder, struct protocol_schedule_reminder_reply
  static const int func_v3_scheduler_reminder = 5038;

  /// v3 设置主界面控件排序, struct protocol_v3_main_ui_sort_set, struct protocol_v3_main_ui_sort_set_reply
  static const int func_v3_main_ui_sort = 5039;

  /// v3 设置运动子项数据排列, struct protocol_v3_base_sport_param_sort_set, struct protocol_v3_base_sport_param_sort_set_reply
  static const int func_v3_base_sport_param_sort = 5040;

  /// v3 设置运动城市名称 struct protocol_set_long_city_name, struct protocol_set_long_city_name_reply
  static const int func_v3_set_long_city_name = 5041;

  /// 设置单个应用的通知状态 struct protocol_v3_notice_message_state_set, struct protocol_v3_notice_message_state_set_reply
  static const int tran_json_set_notice_message_state = 5042;

  /// app获取iso的回复的app的包名  null; struct protocol_get_app_pack_name_reply
  static const int tran_json_get_app_pack_name = 5043;

  /// 同步协议蓝牙通话常用联系人 struct protocol_sync_contact, struct protocol_sync_contact_reply
  static const int tran_json_sync_contact = 5044;

  /// 下发v3天气协议 struct protocol_set_v3_weather, struct protocol_set_v3_weather_reply
  static const int func_v3_set_v3_weather = 5045;

  /// 下发v3世界时间 struct protocol_set_v3_world_time， struct protocol_set_v3_world_time_reply
  static const int func_v3_set_world_time = 5046;

  /// 设置多个走动提醒的时间点  struct protocol_set_walk_remind_times， struct protocol_set_walk_remind_times_reply  id206定制
  static const int func_v3_set_walk_remind_times = 5047;

  /// 获取固件的歌曲名和文件夹  null; struct protocol_v3_get_ble_music_info_reply
  static const int func_v3_get_ble_music_info = 5048;

  /// 操作歌曲或者文件夹 struct protocol_v3_operate_ble_music_reply; protocol_v3_operate_ble_music
  static const int func_v3_operate_ble_music = 5049;

  /// app 语音数据 to ble  状态回调 给上层的app   参考 voice_to_ble_state
  static const int json_voice_to_ble_state_call_back = 5050;

  /// 通知消息提醒 v3 增加8国语言
  static const int func_v3_notice_message_add_app_name = 5051;

  /// 经期的历史数据下发 struct protocol_v3_historical_menstruation, struct protocol_v3_historical_menstruation_reply
  static const int func_v3_get_historical_menstruation = 5052;

  /// 设置表盘顺序 protocol_v3_watch_dial_sort_item,protocol_v3_watch_dial_sort
  static const int func_v3_set_watch_dial_sort = 5053;

  /// app下发跑步计划(运动计划) struct protocol_v3_sport_plan struct protocol_v3_sport_plan_reply
  static const int func_v3_send_run_plan = 5054;

  /// 设备通知app运动过程切换
  static const int func_v3_ble_to_app_sport_cutover = 5055;

  /// app通知设备运动过程切换
  static const int func_v3_app_to_ble_sport_cutover = 5056;

  /// 运动计划中多运动数据交互,运动中的数据接收和发送
  static const int func_v3_sport_plan_activity_data_exchange = 5057;

  /// 运动计划中多运动数据交互最后一次多运动数据查询
  static const int func_v3_sport_plan_get_activity_data = 5058;

  /// 获取用户习惯信息
  static const int func_v3_get_habit_information = 5059;

  /// V3获取BT连接手机型号 struct protocol_v3_get_bt_connect_phone_model_reply
  static const int func_v3_get_bt_connect_phone_model = 5061;

  /// v3设置gps热启动参数 替代v2设置热启动参数 158事件
  static const int func_v3_set_hot_start_param = 5070;

  /// v3获取固件本地提示音文件信息
  static const int func_v3_get_ble_beep = 5071;

  /// v3血压校准控制 struct protocol_v3_bp_cal_control struct protocol_v3_bp_cal_control_reply
  static const int func_v3_bp_cal_control = 5072;

  /// v3血压校准完成
  static const int func_v3_bp_cal_complete = 5073;

  /// 制作照片
  static const int func_make_photo = 5500;

  /// 制作gps文件
  static const int func_gps_file = 5501;

  /// 简单文件操作 struct protocol_simple_file_operations,struct protocol_simple_file_operations_reply
  static const int func_simple_file_operations = 5510;

  /// 开始获取flash log
  static const int func_flash_log_start = 5511;

  /// 停止获取flash log
  static const int func_flash_log_stop = 5512;

  /// flash log获取完成事件
  static const int func_flash_log_complete = 5513;

  /// 重置v3 同步偏移
  static const int func_reset_v3_health_sync_offset = 5514;

  /// 获取电池日志 protocol_battery_log_start_get(void); struct protocol_battery_log_data
  static const int func_get_v3_battery_log = 5515;

  /// 音频文件转换 mp3_to_pcm(char* mp3path,char* pcmpath);
  static const int func_mp3_to_pcm = 5516;

  /// 音频文件转换  将采样率转化为44.1khz   mp3_to_mp3(char* mp3path,char* pcmpath);
  static const int func_pcm_to_mp3 = 5517;

  /// app下发蓝牙联系人数据给协议层
  static const int func_trans_all_contact = 5518;

  /// 开始获取第二块芯片flash log
  static const int func_flash_log_scond_chip_start = 5519;

  /// mp3转换进度  注意错误值和回调值
  static const int mp3_to_mp3_processing = 5530;

  /// app每半个小时主动更新 开始同步v3数据，睡眠数据不返回  protocol_v3_health_automatic_client_async_start()
  static const int func_automatic_start_sync_v3_health = 5555;

  /// 暂停同步v3数据  protocol_v3_health_client_sync_pause
  static const int func_pause_sync_health = 5556;

  /// app获取表盘颜色样式修改 struct vv3_ble_to_app_dail_change_ble_to_app， struct v3_ble_to_app_dail_change_app_to_ble
  static const int func_v3_ble_to_app_dail_change = 5800;

  /// 运动数据
  static const int tran_json_health_sport = 6000;

  /// 睡眠数据
  static const int tran_json_health_sleep = 6001;

  /// 心率数据
  static const int tran_json_health_hr = 6002;

  /// 血压数据
  static const int tran_json_health_bp = 6003;

  /// gps 数据
  static const int tran_josn_gps = 6004;

/// 设置天气城市名称  struct protocol_weather_city_name
  static const int app_weatcher_city_name = 6500;

  /// 设置当天0~8时实时天气+温度  struct protocol_weather_real_time
  static const int app_weatcher_real_time_one = 6501;

  /// 设置当天9~16时实时天气+温度  struct protocol_weather_real_time
  static const int app_weatcher_real_time_two = 6502;

  /// 设置当天17~24时实时天气+温度  struct protocol_weather_real_time
  static const int app_weatcher_real_time_three = 6503;

  /// 设置日出日落时间  struct protocol_weatcher_sun_time，struct protocol_weatch_sun_time_reply
  static const int app_weatcher_set_sun_time = 6504;

  /// 系统log数据
  static const int tran_json_v3_sys_log = 7000;

  /// 血氧数据回调
  static const int tran_json_v3_spo2 = 7001;

  /// 压力数据回调
  static const int tran_json_v3_pressure = 7002;

  /// 心率数据回调
  static const int tran_json_v3_hr = 7003;

  /// 多运动数据回调
  static const int tran_json_v3_activity = 7004;

  /// gps运动数据回调
  static const int tran_json_v3_gps = 7005;

  /// 游泳数据回调
  static const int tran_json_v3_swimming = 7006;

  /// 睡眠数据回调
  static const int tran_json_v3_sleep = 7007;

  /// 运动数据回调
  static const int tran_json_v3_sport = 7008;

  /// 噪音数据回调
  static const int tran_json_v3_noise = 7009;

  /// 温度数据回调
  static const int tran_json_v3_temperature = 7010;

  /// 血压数据回调
  static const int tran_json_v3_bp = 7011;

  /// 呼吸率数据回调
  static const int tran_json_v3_respir_rate = 7012;

  /// 身体电量数据回调
  static const int tran_json_v3_body_power = 7013;

  /// hrv数据回调
  static const int tran_json_v3_hrv = 7014;

  /// 计划多运动模拟测试接口
  static const int tran_json_v3_test_sync_plan_sport = 7113;

  /// 呼吸率数据同步发送
  static const int tran_json_v3_respir_rate_info = 7114;

  /// voice file tran 音频传输
  static const int tran_json_voice_tran = 7500;

  /// app接受到開始數據，下發可以開始
  static const int tran_json_voice_tran_set_ble_start = 7501;

  /// app接收到停止數據，下發停止
  static const int tran_json_voice_tran_set_ble_end = 7502;

  /// app 状态回调
  static const int tran_json_voice_tran_state = 7503;

  /// app 每帧的回调数据
  static const int tran_json_voice_tran_opus_encode_data = 7504;

  /// 丢数据的传输给app struct voice_file_tran_lost_data
  static const int tran_json_voice_tran_lost_data = 7505;

  /// app下发ble开始命令 工厂测试
  static const int tran_json_voice_tran_app_set_ble_start_factory_test = 7506;

  /// app下发ble结束命令 工厂测试
  static const int tran_json_voice_tran_app_set_ble_end_factory_test = 7507;

  /// 传给app每帧的pcm数据
  static const int tran_json_voice_tran_each_pcm_data = 7508;

  /// app下发ble结束命令 语音传输过程中
  static const int tran_json_voice_tran_app_set_ble_end = 7509;

  /// 多运动界面   struct ui_controll_sports, struct protocol_set_base_reply
  static const int voice_set_ui_controll_sports = 7601;

  /// 秒表  struct ui_controll_time_delay , struct protocol_set_base_reply
  static const int voice_set_ui_controll_stopwatch = 7602;

  /// 倒数计时 struct ui_controll_time_count_down, struct protocol_set_base_reply
  static const int voice_set_ui_controll_count_down = 7603;

  /// 健康数据
  static const int voice_set_ui_controll_health_data = 7604;

  /// 心率
  static const int voice_set_ui_controll_heart_rate = 7605;

  /// 压力检测
  static const int voice_set_ui_controll_pressure = 7606;

  /// 呼吸训练
  static const int voice_set_ui_controll_breathing_training = 7607;

  /// 睡眠记录
  static const int voice_set_ui_controll_sleep_record = 7608;

  /// 运动记录
  static const int voice_set_ui_controll_sport_record = 7609;

  /// 天气界面
  static const int voice_set_ui_controll_weather = 7610;

  /// 寻找手机
  static const int voice_set_ui_controll_find_phone = 7611;

  /// 音乐控制界面
  static const int voice_set_ui_controll_music_controll = 7612;

  /// 实时心率开关
  static const int voice_set_ui_controll_real_time_heart_rate = 7613;

  /// 抬腕亮屏界面
  static const int voice_set_ui_controll_wrist_bright_screen = 7614;

  /// 灭屏
  static const int voice_set_ui_controll_black_screen = 7615;

  /// 重启
  static const int voice_set_ui_controll_reboot = 7616;

  /// 屏幕亮度
  static const int voice_set_ui_controll_bright_screen = 7617;

  /// 勿擾界面
  static const int voice_set_ui_controll_not_disturb = 7618;

  /// 消息界面
  static const int voice_set_ui_controll_notify = 7619;

  /// 闹钟界面  struct voice_ui_controll_alarm ,  struct protocol_set_base_reply
  static const int voice_set_ui_controll_alarm = 7620;

  /// alexa简单的设置命令  struct protocol_set_alexa_operation, struct protocol_set_base_reply
  static const int voice_set_ui_controll_easy_operation = 7621;

  /// alexa跳转ui界面 struct protocol_set_alexa_jump_ui, struct protocol_set_base_reply
  static const int voice_set_ui_controll_jump = 7622;

  /// 获取alexa的默认语言 struct protocol_head head; struct protocol_alexa_default_language
  static const int voice_get_alexa_default_language = 7623;

  /// alexa app设置开关命令 struct protocol_alexa_set_on_off_type; struct protocol_set_base_reply
  static const int voice_set_on_off_type = 7624;

  /// 蓝牙设备获取手机登录状态 protocol_voice_file_tran_get_state_reply; 功能表 ex_main7_voice_transmission
  static const int voice_ble_get_phone_login_state = 7630;

  /// 手机设置识别后的状态  protocol_voice_file_tran_set_state,   protocol_set_base_reply; 功能表 ex_main7_voice_transmission
  static const int voice_phone_set_recognition_state = 7631;

  /// app设置手表端alexa通知状态 struct protocol_set_ble_alexa_notify_state， struct protocol_set_base_reply
  static const int voice_phone_set_alexa_notify_state = 7632;

  /// app to ble 文件传输开始
  static const int voice_tran_to_ble_start = 7633;

  /// app to ble 文件传输正在进行中
  static const int voice_tran_to_ble_on_going = 7634;

  /// app to ble 文件传输结束
  static const int voice_tran_to_ble_end = 7635;

  /// app to ble  固件异常返回 文件传输结束
  static const int voice_tran_to_ble_abnormal_end = 7636;

  /// app传输数据过程中，模拟错误停止传输
  static const int tran_stop_send_data_by_app = 7900;

  /// 固件测试
  static const int devices_test_type = 7901;

  /// app传输数据过程中，模拟错误停止传输  spp蓝牙专用
  static const int tran_stop_send_data_by_app_spp = 7950;

  /// 获取固件spp mtu长度   新增  spp蓝牙专用
  static const int app_get_mtu_length_spp = 7951;
  static const int flutter_reply = 8000;

  /// app智能心率模式获取
  static const int vbus_evt_app_get_heart_rate_mode_smart = 343;

  /// 获取血氧开关
  static const int vbus_evt_app_get_spo2 = 344;

  /// 获取压力开关
  static const int vbus_evt_app_get_pressure = 345;

  /// 日历提醒
  static const int vbus_evt_func_v3_calendear_reminder = 5088;

  /// 电子卡片
  static const int vbus_evt_func_v3_ecard_control = 5085;

  /// 语音备忘录
  static const int vbus_evt_func_v3_voice_memo = 5086;

  /// 晨报
  static const int vbus_evt_func_v3_morning_edition = 5087;

  /// 配置默认的消息应用列表
  static const int vbus_evt_func_v3_config_mes_list = 5089;

  /// 设置紧急联系人（ECI）方式
  static const int vbus_evt_func_v3_set_eci = 5090;

  /// 发送小程序操作
  static const int vbus_evt_func_send_mini_program_control = 5078;

  ///获取固件算法文件信息（ACC/GPS）
  static const int vbus_evt_func_v3_get_operate_alg_file = 5522;

  /// 支持获取运动记录的显示项配置
  static const int vbus_evt_func_v3_sport_record_show_config = 5523;

}
