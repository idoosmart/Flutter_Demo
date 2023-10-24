/*
 * vbus_evt_app.h
 *
 *  Created on: 2016年1月8日
 *      Author: Administrator
 */

#ifndef VBUS_EVT_APP_H_
#define VBUS_EVT_APP_H_

//事件的方向
typedef enum
{
	VBUS_EVT_BASE_SET                = 0x2000,  //内部使用
	VBUS_EVT_BASE_GET                = 0x2100,
	VBUS_EVT_BASE_BLE_REPLY          = 0x2200,  //内部使用
	VBUS_EVT_BASE_NOTICE_APP         = 0x2300,  //通知
	VBUS_EVT_BASE_APP_SET            = 0x2400,	//设置
	VBUS_EVT_BASE_APP_GET            = 0x2500,	//获取
	VBUS_EVT_BASE_REQUEST            = 0x2600,	//C库请求
    VBUS_EVT_BASE_BLE_REPLY_TIMEOUT  = 0x2700,  //内部使用

} VBUS_EVT_BASE;

typedef enum
{
	VBUS_EVT_NONE,
	SET_BLE_EVT_CONNECT                              = 1,      //连接成功
	SET_BLE_EVT_DISCONNECT                           = 2,      //断开连接
	SYNC_EVT_ALRM_SYNC_COMPLETE                      = 3,      //闹钟同步完成
	SYNC_EVT_CONFIG_SYNC_COMPLETE                    = 4,      //配置同步完成
	SYNC_EVT_HEALTH_SYNC_COMPLETE                    = 5,      //健康数据同步完成
	SYNC_EVT_HEALTH_PROGRESS                         = 6,      //健康数据同步进度,进度在data (0-100) (uint32_t)data
	SYNC_EVT_ALARM_PROGRESS                          = 7,      //闹钟同步进度 struct protocol_set_alarm_progress_s
	SYNC_EVT_HEALTH_PROCESSING                       = 8,
	SYNC_EVT_ALARM_PROCESSING                        = 9,
    
	SYNC_EVT_CONFIG_PROCESSING                       = 10,
	SYNC_EVT_CONFIG_FAST_SYNC_COMPLETE               = 11,     //连接以后,快速同步完成
	SYNC_EVT_ACTIVITY_STOP_ONCE                      = 12,     //中间状态	重发控制
	SYNC_EVT_ACTIVITY_START_ONCE                     = 13,
	SYNC_EVT_ACTIVITY_PROCESSING                     = 14,     //同步活动项进度(0-100)
	SYNC_EVT_DATA_TRAN_PROCESSING                    = 15,     //文件传输的进度
	SYNC_EVT_DATA_TRAN_COMPLETE                      = 16,     //文件传输完成,注意错误值
	SYNC_EVT_GPS_PROCESSING                          = 17,     //gps同步进度
	SYNC_EVT_V3_HEALTH_COMPLETE                      = 18,     //v3健康数据同步完成
	SYNC_EVT_V3_HEALTH_PROCESSING                    = 19,     //v3健康数据同步进度

	SYNC_EVT_DATA_TRAN_PROCESSING_SPP                = 20,     //数据传输的进度  spp传输进度
	SYNC_EVT_DATA_TRAN_COMPLETE_SPP                  = 21,     //数据传输完成,注意错误值  spp传输进度完成
	SYNC_EVT_V3_HEALTH_EACH_TYPE_ITEMS_COMPLETE      = 22,     //v3健康数据同步单项数据完成通知 2022-7-26

	VBUS_EVT_APP_SET_ALARM                           = 100,    //设置闹钟
	VBUS_EVT_APP_SET_LONG_SIT                        = 101,	   //设置久坐 struct protocol_long_sit
	VBUS_EVT_APP_SET_LOST_FIND                       = 102,    //设置防丢 struct protocol_lost_find
	VBUS_EVT_APP_SET_FIND_PHONE                      = 103,    //设置寻找手机 struct protocol_find_phone
	VBUS_EVT_APP_SET_TIME                            = 104,	   //设置时间 struct protocol_set_time
	VBUS_EVT_APP_SET_SPORT_GOAL                      = 105,    //设置运动目标 struct protocol_set_sport_goal
	VBUS_EVT_APP_SET_SLEEP_GOAL                      = 106,    //设置睡眠目标
	VBUS_EVT_APP_SET_USER_INFO                       = 107,	   //设置用户信息 struct protocol_set_user_info
	VBUS_EVT_APP_SET_UINT                            = 108,	   //设置单位 struct protocol_set_unit
	VBUS_EVT_APP_SET_HAND                            = 109,	   //设置左右手 struct protocol_set_handle
    
	VBUS_EVT_APP_SET_APP_OS                          = 110,    //设置手机系统
	VBUS_EVT_APP_SET_NOTICE                          = 111,    //设置通知中心 struct protocol_set_notice
	VBUS_EVT_APP_SET_HEART_RATE_INTERVAL             = 112,    //设置心率区间 struct protocol_heart_rate_interval
	VBUS_EVT_APP_SET_HEART_RATE_MODE                 = 113,	   //设置心率模式 struct protocol_heart_rate_mode
	VBUS_EVT_APP_SET_UP_HAND_GESTURE                 = 114,	   //设置抬手亮屏 struct protocol_set_up_hand_gesture
	VBUS_EVT_APP_SET_DEFAULT_CONFIG                  = 115,	   //设置恢复模式
	VBUS_EVT_APP_SET_DO_NOT_DISTURB                  = 116,	   //设置勿扰模式 protocol_do_not_disturb
	VBUS_EVT_APP_SET_MUISC_ONOFF                     = 117,	   //设置音乐开关 struct protocol_music_onoff
	VBUS_EVT_APP_SET_DISPLAY_MODE                    = 118,	   //设置显示模式 struct protocol_display_mode
	VBUS_EVT_APP_SET_ONEKEY_SOS                      = 119,	   //设置一键呼叫 struct protocol_set_onekey_sos

	VBUS_EVT_APP_SET_HR_SENSOR_PARAM                 = 120,    //设置心率传感器参数 struct protocol_heart_rate_sensor_param
	VBUS_EVT_APP_SET_GSENSOR_PARAM                   = 121,	   //设置加速度传感器参数 struct protocol_gsensor_param
	VBUS_EVT_APP_SET_REAL_TIME_SENSOR_DATA           = 122,    //设置传感器实时数据 struct protocol_set_real_time_health_data_status
	VBUS_EVT_APP_SET_START_MOTOT                     = 123,	   //设置马达 struct protocol_set_start_motor
	VBUS_EVT_APP_SET_WATCH_DIAL                      = 124,	   //设置表盘struct protocol_set_watch_dial,struct protocol_set_watch_dial_reply
	VBUS_EVT_APP_SET_SHORTCUT                        = 125,	   //设置快捷方式 struct protocol_set_shortcut,struct protocol_set_shortcut_reply
	VBUS_EVT_APP_SET_BP_CAL                          = 126,	   //血压校准 struct protocol_set_bp_cal,struct protocol_set_bp_cal_reply
	VBUS_EVT_APP_SET_BP_MEASURE                      = 127,	   //血压测量struct protocol_control_bp_measure,struct protocol_control_bp_measure_reply
    VBUS_EVT_APP_SET_STRESS_CAL                      = 128,	   //压力校准protocol_set_stress_cal,struct protocol_set_stress_cal_reply
	VBUS_EVT_APP_SET_OVER_FING_PHONE                 = 129,	   //停止寻找手机 struct protocol_control_over_find_phone,struct protocol_control_over_find_phone

	VBUS_EVT_APP_SET_WEATHER_SWITCH                  = 150,    //设置天气开关	struct protocol_cmd,cmd1
	VBUS_EVT_APP_SET_SPORT_MODE_SELECT               = 151,	   //设置运动模式选择    protocol_sport_mode_select_bit或者 struct protocol_sport_mode_select
	VBUS_EVT_APP_SET_SLEEP_PERIOD                    = 152,	   //设置睡眠时间段 struct protocol_sleep_period
	VBUS_EVT_APP_WEATCHER_DATA                       = 153,    //设置天气数据  struct protocol_weatch_data
    VBUS_EVT_APP_SET_SCREEN_BRIGHTNESS               = 154,    //设置屏幕亮度 struct protocol_screen_brightness
	VBUS_EVT_APP_SET_CONFIG_GPS                      = 155,	   //设置gps信息 struct protocol_config_gps
	VBUS_EVT_APP_SET_CONTROL_GPS                     = 156,	   //控制gps struct protocol_control_gps ,struct protocol_control_gps_reply
    VBUS_EVT_APP_SET_CONN_PARAM                      = 157,    //控制连接参数 struct protocol_conn_param,struct protocol_conn_param_reply
	VBUS_EVT_APP_SET_HOT_START_PARAM                 = 158,	   //设置热启动参数 struct protocol_hot_start_param
	VBUS_EVT_APP_SET_MENSTRUATION                    = 159,	   //设置经期 struct protocol_set_menstrual
    
	VBUS_EVT_APP_SET_MENSTRUATION_REMIND             = 160,	   //设置经期提醒 struct protocol_set_menstrual_remind
	VBUS_EVT_APP_SET_CALORIE_DISTANCE_GOAL           = 161,	   //卡路里和距离目标 struct protocol_set_calorie_distance_goal 功能表calorie_goal/distance_goal
	VBUS_EVT_APP_SET_SPO2                            = 162,	   //设置血氧开关struct protocol_set_spo2, struct protocol_set_spo2_reply
	VBUS_EVT_APP_SET_PRESSURE                        = 163,	   //设置压力开关struct protocol_set_pressure
	VBUS_EVT_APP_SET_SPORT_MODE_SORT                 = 164,    //设置运动模式排序 struct protocol_sport_mode_sort
	VBUS_EVT_APP_SET_WALK_REMINDER                   = 165,	   //设置走动提醒	struct protocol_set_walk_reminder
	VBUS_EVT_APP_SET_BREATHE_TRAIN                   = 166,	   //呼吸训练	struct protocol_set_breathe_train
	VBUS_EVT_APP_SET_ACTIVITY_SWITCH			     = 167,    //运动模式识别开关设置 struct protocol_activity_switch
	VBUS_EVT_APP_SET_DRINK_WATER_REMINDER            = 168,    //设置喝水提醒 struct protocol_drink_water_reminder
    VBUS_EVT_APP_SET_IOT_BUTTON_NAME                 = 169,    //设置IOT按钮 struct protocol_iot_button_name
    
    VBUS_EVT_APP_BLE_TO_APP_IOT_COMMAND              = 170,    //IOT按钮命令 struct protocol_iot_command
    VBUS_EVT_APP_SET_MENU_LIST                       = 171,	   //设置菜单列表 struct protocol_set_menu_list
    VBUS_EVT_APP_SET_TAKE_PICTURE                    = 172,    //控制拍照  struct protocol_take_picture
    VBUS_EVT_APP_SET_CLEAR_OPERATIONS                = 173,    //删除日志 struct protocol_clear_operator; struct protocol_clear_operator_reply
	VBUS_EVT_APP_SET_BLE_VOICE                       = 174,    //手机音量下发给ble  struct protocol_set_device_voice,struct protocol_set_device_voice_reply
	VBUS_EVT_APP_SET_SET_HAND_WASHING_REMINDER       = 175,    //设置洗手提醒  struct protocol_set_hand_washing_reminder , struct protocol_set_base_reply
    VBUS_EVT_APP_SET_SET_DEVICES_NAME                = 176,    //设置设备名称 struct protocol_set_device_name,  struct protocol_set_device_name_reply
	VBUS_EVT_APP_SET_TAKING_MEDICINE_REMINDER        = 177,    //设置吃药提醒  struct protocol_taking_medicine_reminder, struct protocol_set_base_reply
	VBUS_EVT_APP_SET_ONCE_TEST_SPO2_PRESSURE         = 178,    //血氧压力测试一次 功能表once_test_spo2_pressure protocol_start_once_test_spo2_pressure protocol_start_once_test_spo2_pressure_reply
    VBUS_EVT_APP_SET_BLE_SCREEN_COLOR                = 179,    //手机设置屏幕颜色 不加功能表；  设置结构体：struct protocol_set_ble_screen_color  回复的结构体：struct protocol_set_base_reply
	
    VBUS_EVT_APP_SET_TO_SYNC_ALL_CONFIG              = 180,    //APP控制同步配置开关；控制是否需要设备重启的时候，so主动同步所有的数据  protocol_sync_config_set_reboot_auto_sync(bool) （无效）
	VBUS_EVT_APP_SET_BLE_SHARKING_GRADE              = 181,    //APP控制手表的震动强度  struct protocol_set_ble_sharking_grade ，  struct protocol_set_base_reply
	VBUS_EVT_APP_SET_HEART_RATE_MODE_SMART           = 182,    //APP智能心率模式设置  struct protocol_set_smart_heart_rate_mode,   struct protocol_set_smart_heart_rate_mode_reply
	VBUS_EVT_APP_SET_V3_NOISE                        = 183,    //环境音量的开关和阀值 struct protocol_set_v3_noise,  struct protocol_set_base_reply
    VBUS_EVT_APP_SET_SCIENTIFIC_SLEEP_SWITCH         = 184,    //设置科学睡眠开关 struct protocol_set_v3_scientific_sleep_switch, struct protocol_set_base_reply
	VBUS_EVT_APP_SET_TEMPERATURE_SWITCH              = 185,    //设置夜间体温开关 struct protocol_set_v3_temperature, struct protocol_set_base_reply
	VBUS_EVT_APP_SET_FITNESS_GUIDANCE                = 186,    //健身指导 struct protocol_set_fitness_guidance, struct protocol_set_base_reply
	VBUS_EVT_APP_SET_DATA_TRAN_CONFIGURE             = 187,    //文件传输配置传输 struct protocol_data_tran_configure_set struct protocol_data_com_reply
	VBUS_EVT_APP_SET_UNREAD_APP_REMINDER             = 188,    //未读信息红点提示开关   protocol_set_unread_app_reminder   protocol_set_base_reply
    
    VBUS_EVT_APP_SET_NOTIFICATION_STATUS             = 190,    //手机app通过这个命令开关，实现通知应用状态设置   struct protocol_set_notification_status    struct protocol_set_base_reply
	VBUS_EVT_APP_SET_RESPI_RATE_ON_OFF               = 191,    //手机app通过这个命令开关，设置呼吸率开关  struct protocol_set_respi_rate_on_off
    VBUS_EVT_APP_SET_BODY_POWER_ON_OFF               = 192,    //手机app通过这个命令开关，设置身体电量开关  struct protocol_set_body_power_on_off
    VBUS_EVT_APP_SET_VOICE_ASSISTANT_ON_OFF          = 193,    //手机app通过这个命令开关，设置手机语音助手开关  struct protocol_set_voice_assistant_on_off

	VBUS_EVT_APP_BIND_START                          = 200,    //绑定 struct protocol_start_bind,struct protocol_start_bind_reply
	VBUS_EVT_APP_BIND_REMOVE                         = 201,	   //解绑
	VBUS_EVT_APP_AUTH                                = 202,	   //开始授权 struct protocol_start_auth,struct protocol_start_auth_reply
	VBUS_EVT_APP_BIND_REFUSE                         = 203,	   //绑定拒绝
	VBUS_EVT_APP_SET_ENCRYPTED_AUTH                  = 204,    //发送计算好的授权数据     struct protocol_start_encrypted_auth,struct protocol_start_encrypted_auth_reply
    VBUS_EVT_APP_GET_ENCRYPTED_CODE                  = 205,    //获取授权数据 protocol_start_aut_code_reply
    
	VBUS_EVT_APP_APP_GET_MAC                         = 300,	   //获得mac struct protocol_device_mac
	VBUS_EVT_APP_GET_DEVICE_INFO                     = 301,	   //获得设备信息 struct protocol_device_info
    VBUS_EVT_APP_GET_FUNC_TABLE                      = 302,	   //(内部使用)
    VBUS_EVT_APP_GET_FUNC_TABLE_USER                 = 303,    //获取功能表 struct protocol_get_func_table
    VBUS_EVT_APP_GET_LIVE_DATA                       = 304,    //获得实时数据 struct protocol_get_live_data,struct protocol_get_live_data_reply
    VBUS_EVT_APP_GET_DEVICE_TIME                     = 305,    //获取设备时间 struct protocol_device_time
    VBUS_EVT_APP_GET_NOTICE_STATUS                   = 306,    //获取通知中心的状态 struct protocol_head head，struct protocol_set_notice
    VBUS_EVT_APP_GET_HR_SENSOR_PARAM                 = 307,	   //获取心率传感器参数 struct protocol_heart_rate_sensor_param
    VBUS_EVT_APP_GET_GSENSOR_PARAM                   = 308,	   //获取加速度传感器信息  struct protocol_gsensor_param
	VBUS_EVT_APP_GET_ACTIVITY_COUNT                  = 309,	   //获取同步时间轴来计算百分比 struct protocol_new_health_activity_count
    
	VBUS_EVT_APP_GET_HID_INFO                        = 310,	   //获取hid信息 返回struct protocol_get_hid_info_reply
	VBUS_EVT_APP_GET_FUNC_TABLE_EX                   = 311,	   //获取扩展功能表
	VBUS_EVT_APP_GET_GPS_INFO                        = 312,	   //获取GPS信息 struct protocol_get_gps_info
	VBUS_EVT_APP_GET_HOT_START_PARAM                 = 313,	   //获取热启动参数 struct protocol_hot_start_param
    VBUS_EVT_APP_GET_GPS_STATUS                      = 314,    //获取GPS状态  struct protocol_get_gps_status
    VBUS_EVT_APP_GET_VERSION_INFO                    = 315,    //获取版本信息 struct protocol_version_info
    VBUS_EVT_APP_GET_DO_NOT_DISTURB                  = 316,    //获取勿扰模式状态 struct protocol_do_not_disturb
    VBUS_EVT_APP_GET_MTU_INFO                        = 317,	   //获取mtu信息 struct protocol_get_mtu_info
    VBUS_EVT_APP_GET_DEFAULT_SPORT_TYPE              = 318,	   //获取默认的运动类型 struct protocol_get_default_sport_type
    VBUS_EVT_APP_GET_DOWN_LANGUAGE                   = 319,    //获取下载语言支持 protocol_get_down_language
    
    VBUS_EVT_APP_GET_ERROR_RECORD                    = 320,    //获取错误记录 struct protocol_get_error_record,struct protocol_get_error_record_reply
	VBUS_EVT_APP_GET_BATT_INFO                       = 321,	   //获取电池信息 struct protocol_device_batt_info
	VBUS_EVT_APP_GET_FLASH_BIN_INFO                  = 322,    //获取字库信息 struct protocol_flash_bin_info
	VBUS_EVT_APP_GET_MENU_LIST                       = 323,	   //获取设备支持的列表  struct protocol_get_menu_list
	VBUS_EVT_APP_GET_REALME_DEV_INFO                 = 324,    //获取realme项目的硬件信息 struct protocol_get_realme_dev_info_reply
	VBUS_EVT_APP_GET_SCREEN_BRIGHTNESS               = 325,    //获取屏幕亮度 struct protocol_head, protocol_get_screen_brightness_reply
    VBUS_EVT_APP_GET_UP_HAND_GESTURE                 = 326,    //获取抬腕数据 struct protocol_head, protocol_get_up_hand_gesture_reply
    VBUS_EVT_APP_GET_UPDATE_STATE                    = 327,    //获取设备升级状态 struct protocol_head, protocol_get_device_update_state
	VBUS_EVT_APP_GET_WATCH_ID                        = 328,    //获取表盘ID struct protocol_head, struct protocol_get_watch_id_reply
	VBUS_EVT_APP_GET_DEVICES_NAME                    = 329,    //获取手表名字  struct protocol_get_device_name_reply
    
	VBUS_EVT_APP_GET_DEVICES_LOG_STATE               = 330,    //获取设备的日志状态   struct protocol_get_device_log_state_reply
    VBUS_EVT_APP_GET_MAIN_SPORT_GOAL                 = 331,    //获取设置的卡路里/距离/中高运动时长 主界面  struct protocol_set_calorie_distance_goal
    VBUS_EVT_APP_GET_WALK_REMINDER                   = 332,    //获取走动提醒  struct protocol_set_walk_reminder
	VBUS_EVT_APP_GET_ALL_HEALTH_SWITCH_STATE         = 333,    //获取所有的健康监测开关  struct protocol_head head; struct protocol_get_health_switch_state_reply
	VBUS_EVT_APP_GET_DATA_TRAN_CONFIGURE             = 334,    //获取文件传输配置传输 struct protocol_data_tran_configure_get，  struct protocol_data_tran_configure_get_reply
	VBUS_EVT_APP_GET_ACTIVITY_SWITCH                 = 335,    //获取运动模式自动识别开关 struct protocol_head head;  struct protocol_get_activity_switch_reply
	VBUS_EVT_APP_GET_GET_FIRMWARE_BT_VERSION         = 336,    //获得固件三级版本和BT的3级版本  struct protocol_firmware_bt_version_info_reply
    VBUS_EVT_APP_GET_STRESS_VAL                      = 337,    //获取压力值 struct protocol_head,protocol_get_stress_val_reply
    VBUS_EVT_APP_GET_BP_ALG_VERSION                  = 338,    //获取血压算法三级版本号信息
    VBUS_EVT_APP_GET_SUPPORT_MAX_SET_ITEMS_NUM       = 339,    //获取固件支持的详情最大设置数量
    
    VBUS_EVT_APP_GET_UNDELETEABLE_MEUN_LIST          = 340,    //获取固件不可删除的快捷应用列表
    VBUS_EVT_APP_GET_SN_INFO                         = 341,    //获取sn信息
    
    VBUS_EVT_CHECK_REBOOT                            = 350,	   //检查重启状态,非协议,用于内部状态处理
	VBUS_EVT_APP_GET_UNREAD_APP_ONOFF                = 351,    //获取获取固件红点提示开关状态   struct protocol_head ,struct protocol_unread_app_reminder
	VBUS_EVT_APP_GET_SET_BT_NOTICE                   = 352,    //查询bt配对开关、连接、a2dp连接、hfp连接状态(仅支持带bt蓝牙的设备)   struct protocol_head ,struct protocol_set_bt_notice
	VBUS_EVT_APP_GET_CONTACT_REVICE_TIME             = 353,    //获取固件本地保存联系人文件修改时间  struct protocol_head ,
	VBUS_EVT_APP_GET_BT_NAME                         = 354,    //获取bt蓝牙名称   struct protocol_head , struct protocol_get_bt_name
	VBUS_EVT_APP_GET_CONTACT_REVICE_TIME_STOP_TIMER  = 355,    //处理关闭353定时器事件
	
    VBUS_EVT_APP_OTA_START                           = 400,	   //进入升级模式	struct protocol_ota_reply 里面包含电量标志
	VBUS_EVT_APP_OTA_DIRECT_START                    = 401,	   //直接进入升级模式(忽略电量)
	VBUS_EVT_APP_SYSTEM_OFF                          = 402,	   //进入关机模式
	VBUS_EVT_APP_REBOOT                              = 403,	   //重启设备
	VBUS_EVT_APP_CONTROL_DISCONNECT                  = 404,	   //控制断线 struct protocol_control_disconnect
    VBUS_EVT_APP_CLEAN_BOND_INFO                     = 405,	   //清除绑定信息
    VBUS_EVT_APP_SHUTDOWN                            = 406,    //关闭设备
    VBUS_EVT_APP_OTA_AUTH					         = 407,    //ota授权 struct protocol_ota_auth,  struct protocol_ota_auth_reply
    VBUS_EVT_APP_RESTORE_FAZCTORY                    = 408,    //恢复出厂设置 set_restore_factory_reply
	VBUS_EVT_APP_CLEAR_CACHE                         = 409,    //清除手环缓存  struct protocol_set_reply
    
    VBUS_EVT_APP_SET_NOTICE_CALL                     = 410,    //发送来电事件，android
    VBUS_EVT_APP_SET_NOTICE_MSG                      = 411,    //通知app
    VBUS_EVT_APP_SET_NOTICE_STOP_CALL                = 412,	   //结束来电
    VBUS_EVT_APP_SET_NOTICE_CALL_PROCESSING          = 413,    //处理中,内部事件
    VBUS_EVT_APP_SET_NOTICE_MSG_PROCESSING           = 414,
	VBUS_EVT_APP_SET_NOTICE_CALL_TIME                = 415,    //来电接通完成后下发通话时间给固件

	VBUS_EVT_APP_SET_NOTICE_MISSED_CALL              = 420,	   //未接来电
    VBUS_EVT_APP_GET_HEART_RATE_MODE                 = 421,	   //获取心率监测模式
    VBUS_EVT_APP_GET_STEP_GOAL                       = 422,    //获取全天步数目标

    //app控制手环
    VBUS_EVT_APP_APP_TO_BLE_MUSIC_START              = 500,    //控制音乐开始
    VBUS_EVT_APP_APP_TO_BLE_MUSIC_STOP               = 501,    //控制音乐停止
	VBUS_EVT_APP_APP_TO_BLE_PHOTO_START              = 502,    //控制开始拍照
	VBUS_EVT_APP_APP_TO_BLE_PHOTO_STOP               = 503,    //控制结束拍照
	VBUS_EVT_APP_APP_TO_BLE_FIND_DEVICE_START        = 504,    //寻找设备开始
	VBUS_EVT_APP_APP_TO_BLE_FIND_DEVICE_STOP         = 505,    //寻找设备结束
	VBUS_EVT_APP_APP_TO_BLE_OPEN_ANCS                = 506,    //控制打开ancs
	VBUS_EVT_APP_APP_TO_BLE_CLOSE_ANCS               = 507,    //控制关闭ancs

	VBUS_EVT_APP_APP_TO_BLE_NOTCIE_ICON_INFORMATIONG = 511,    //APP传输运动图标信息及状态通知固件     struct protocol_notice_icon_information
	VBUS_EVT_APP_APP_TO_BLE_NOTCIE_OPEN_BROADCAST    = 512,    //APP通知固件开启bt广播    struct protocol_head head;
	VBUS_EVT_APP_APP_TO_BLE_NOTCIE_DISABLE_FUNC      = 513,    //APP被禁用功能权限导致某些功能无法启用，同时需要告知固件改功能已被禁用     struct protocol_notice_disable_func

	//手环控制app
	VBUS_EVT_APP_BLE_TO_APP_EVT_BASE                 = 550,
	VBUS_EVT_APP_BLE_TO_APP_MUSIC_START              = 551,	   //开始
	VBUS_EVT_APP_BLE_TO_APP_MUSIC_PAUSE              = 552,	   //暂停
	VBUS_EVT_APP_BLE_TO_APP_MUSIC_STOP               = 553,	   //停止
	VBUS_EVT_APP_BLE_TO_APP_MUSIC_LAST               = 554,	   //上一首
	VBUS_EVT_APP_BLE_TO_APP_MUSIC_NEXT               = 555,	   //下一首
	VBUS_EVT_APP_BLE_TO_APP_PHOTO_SINGLE_SHOT        = 556,    //单拍
	VBUS_EVT_APP_BLE_TO_APP_PHOTO_BURST              = 557,	   //连拍
	VBUS_EVT_APP_BLE_TO_APP_VOLUME_UP                = 558,	   //音量+
	VBUS_EVT_APP_BLE_TO_APP_VOLUME_DOWN              = 559,	   //音量-
    
	VBUS_EVT_APP_BLE_TO_APP_OPEN_CAMERA              = 560,	   //打开相机
	VBUS_EVT_APP_BLE_TO_APP_CLOSE_CAMERA             = 561,	   //关闭相机
	VBUS_EVT_APP_BLE_TO_APP_PHONE_ANSWER             = 562,	   //接听电话
	VBUS_EVT_APP_BLE_TO_APP_PHONE_REJECT             = 563,    //拒接电话
	//VBUS_EVT_APP_BLE_TO_APP_PHONE_REJECT           = 564,	   //固件静音同步到手机静音
    VBUS_EVT_APP_BLE_TO_APP_VOLUME_PERCENTAGE        = 565,    //控制音乐百分比

	VBUS_EVT_APP_BLE_TO_APP_FIND_PHONE_START         = 570,    //寻找手机开始
	VBUS_EVT_APP_BLE_TO_APP_FIND_PHONE_STOP          = 571,	   //寻找手机结束
	VBUS_EVT_APP_BLE_TO_APP_ANTI_LOST_START          = 572,	   //防丢启动
	VBUS_EVT_APP_BLE_TO_APP_ANTI_LOST_STOP           = 573,	   //防丢结束
	VBUS_EVT_APP_BLE_TO_APP_ONEKEY_SOS_START         = 574,    //一键呼叫
	VBUS_EVT_APP_BLE_TO_APP_SENSOR_DATA_NOTICE       = 575,    //传感器数据通知 struct protocol_sensor_data_notice
	VBUS_EVT_APP_BLE_TO_APP_DEVICE_OPERATE           = 576,	   //设备操作  struct protocol_device_operate
	VBUS_EVT_APP_BLE_TO_APP_DATA_UPDATE              = 577,	   //手环数据更新,struct protocol_control_data_update
	VBUS_EVT_APP_BLE_TO_APP_REQUEST_CHECK_UPDATE     = 578,    //手环请求版本检查 ,struct protocol_ble_request_check_update_reply
	VBUS_EVT_APP_BLE_TO_APP_REQUEST_START_OTA        = 579,	   //手环请求ota struct protocol_ble_request_start_ota_reply

	VBUS_EVT_APP_BLE_TO_APP_FAST_MSG_UPDATA          = 580,    //快速短信回复 struct protocol_control_msg_notify(固件到app),struct protocol_control_msg_notify_reply（app回复）
	VBUS_EVT_APP_BLE_TO_APP_DEVICE_PHOTOGRAPH        = 581,    //系统相机控制的ui界面

	VBUS_EVT_APP_BLE_TO_APP_SPEAKER_VALUE            = 591,    //固件喇叭音量回复 struct protocol_control_speaker_value(固件到app),struct protocol_control_speaker_value_reply（app回复）
    
	//交换数据
    VBUS_EVT_APP_SWITCH_APP_START                    = 600,	   //APP发送交换数据开始 struct protocol_switch_app_start,struct protocol_switch_app_start_reply
	VBUS_EVT_APP_SWITCH_APP_START_REPLY,	                   //无效,使用VBUS_EVT_APP_SWITCH_APP_START上报app
	VBUS_EVT_APP_SWITCH_APP_ING                      = 602,	   //APP发送交换数据过程中 struct protocol_switch_app_ing,struct protocol_switch_app_ing_reply
	VBUS_EVT_APP_SWITCH_APP_ING_REPLY,		                   //无效,使用VBUS_EVT_APP_SWITCH_APP_ING上报app
	VBUS_EVT_APP_SWITCH_APP_END                      = 604,	   //APP发送交换数据结束 struct protocol_switch_app_end,struct protocol_switch_app_end_reply
	VBUS_EVT_APP_SWITCH_APP_END_REPLY,		                   //无效,使用VBUS_EVT_APP_SWITCH_APP_END上报app
	VBUS_EVT_APP_SWITCH_APP_PAUSE                    = 606,	   //APP发送交换数据暂停 struct protocol_switch_app_pause,struct protocol_switch_app_pause_reply
	VBUS_EVT_APP_SWITCH_APP_PAUSE_REPLY,	                   //无效,使用VBUS_EVT_APP_SWITCH_APP_PAUSE上报app
	VBUS_EVT_APP_SWITCH_APP_RESTORE                  = 608,	   //APP发送交换数据恢复 struct protocol_switch_app_restore,struct protocol_switch_app_restore_reply
	VBUS_EVT_APP_SWITCH_APP_RESTORE_REPLY,	                   //无效,使用VBUS_EVT_APP_SWITCH_APP_RESTORE上报app
    
	VBUS_EVT_APP_SWITCH_APP_BLE_PAUSE                = 610,	   //BLE设备通知app交换数据暂停 struct protocol_switch_app_ble_pause,struct protocol_switch_app_ble_pause_reply
	VBUS_EVT_APP_SWITCH_APP_BLE_PAUSE_REPLY,                   //无效,使用VBUS_EVT_APP_SWITCH_APP_BLE_PAUSE上报app
	VBUS_EVT_APP_SWITCH_APP_BLE_RESTORE              = 612,	   //BLE设备通知app交换数据恢复 struct protocol_switch_app_ble_restore,struct protocol_switch_app_ble_restore_reply
	VBUS_EVT_APP_SWITCH_APP_BLE_RESTORE_REPLY,                 //无效,使用VBUS_EVT_APP_SWITCH_APP_BLE_RESTORE上报app
	VBUS_EVT_APP_SWITCH_APP_BLE_END                  = 614,	   //BLE设备通知app交换数据结束 struct struct protocol_switch_app_ble_end,struct struct protocol_switch_app_ble_end_reply
	VBUS_EVT_APP_SWITCH_APP_BLE_END_REPLY,	                   //无效,使用VBUS_EVT_APP_SWITCH_APP_BLE_END上报app
	VBUS_EVT_APP_SWITCH_APP_BLE_TIME                 = 616,	   //APP发送交换运动开始时间 struct protocol_switch_app_time,struct protocol_switch_app_time_reply
	VBUS_EVT_APP_SWITCH_APP_BLE_TIME_REPLY,	                   //无效,使用VBUS_EVT_APP_SWITCH_APP_BLE_TIME上报app
	VBUS_EVT_APP_SWITCH_APP_GET_HR_INTERVAL          = 618,    //获取多运动5个心率值,struct protocol_switch_app_get_hr_interval,struct protocol_switch_app_get_hr_interval_reply

	VBUS_EVT_APP_SWITCH_BLE_START                    = 620,    //BLE设备发送交换数据开始 struct protocol_switch_ble_start,struct protocol_switch_ble_start_reply
	VBUS_EVT_APP_SWITCH_BLE_START_REPLY,                       //无效,使用VBUS_EVT_APP_SWITCH_BLE_START回应ble设备
	VBUS_EVT_APP_SWITCH_BLE_ING                      = 622,	   //BLE设备发送交换数据过程中 struct protocol_switch_ble_ing,struct protocol_switch_ble_ing_reply
	VBUS_EVT_APP_SWITCH_BLE_ING_REPLY,                         //无效,使用VBUS_EVT_APP_SWITCH_BLE_ING回应ble设备
	VBUS_EVT_APP_SWITCH_BLE_END                      = 624,	   //BLE设备发送交换数据结束 struct protocol_switch_ble_end,struct protocol_switch_ble_end_reply
	VBUS_EVT_APP_SWITCH_BLE_END_REPLY,                         //无效,使用VBUS_EVT_APP_SWITCH_BLE_END回应ble设备
	VBUS_EVT_APP_SWITCH_BLE_PAUSE                    = 626,	   //BLE设备发送交换数据暂停 struct protocol_switch_ble_pause,struct protocol_switch_ble_pause_reply
	VBUS_EVT_APP_SWITCH_BLE_PAUSE_REPLY,                       //无效,使用VBUS_EVT_APP_SWITCH_BLE_PAUSE回应ble设备
	VBUS_EVT_APP_SWITCH_BLE_RESTORE                  = 628,	   //BLE设备发送数据恢复struct protocol_switch_ble_restore,struct protocol_switch_ble_restore_reply
	VBUS_EVT_APP_SWITCH_BLE_RESTORE_REPLY,                     //无效,使用VBUS_EVT_APP_SWITCH_BLE_RESTORE回应ble设备

	//新的同步项
	VBUS_EVT_APP_ACTIVITY_SYNC_TIMEOUT                     = 650,   //活动项同步超时 预留
	VBUS_EVT_APP_ACTIVITY_SYNC_COMPLETE                    = 651,   //所有活动项目同步完成 预留
	VBUS_EVT_APP_ACTIVITY_SYNC_ONCE_COMPLETE_JSON_NOTEICE  = 652,   //V2多运动同步完成
	VBUS_EVT_APP_GPS_SYNC_COMPLETE                         = 653,   //V2GPS同步完成

	VBUS_EVT_APP_DATA_TRAN_COMPLETE                        = 700,   //数据传输完成 预留 使用独一注册回调结果
	VBUS_EVT_APP_DATA_TRAN_ERROR                           = 701,   //数据传输错误 预留 使用独一注册回调结果
	VBUS_EVT_APP_DATA_TRAN_PROCESSING                      = 702,   //数据传输进度 预留 使用独一注册回调结果

	VBUS_EVT_APP_PROTOCOL_TEST_CMD_1                       = 900,   //内部测试

	//ibecon
	VBUS_EVT_IBEACON_WRITE_HEAD                            = 1000,  //struct protocol_beacon_head_set
	VBUS_EVT_IBEACON_WRITE_HEAD_REPLY                      = 1001,  //struct protocol_beacon_retcode
	VBUS_EVT_IBEACON_WRITE_UUID                            = 1002,  //struct protocol_beacon_uuid_set
	VBUS_EVT_IBEACON_WRITE_UUID_REPLY                      = 1003,  //struct protocol_beacon_retcode
	VBUS_EVT_IBEACON_WRITE_PASSWORD                        = 1004,  //struct protocol_beacon_write_passwd
	VBUS_EVT_IBEACON_WRITE_PASSWORD_REPLY                  = 1005,  //struct protocol_beacon_retcode
	VBUS_EVT_IBEACON_GET_HEAD                              = 1006,
	VBUS_EVT_IBEACON_GET_HEAD_REPY                         = 1007,  //struct protocol_beacon_ret_head
	VBUS_EVT_IBEACON_GET_UUID                              = 1008,
	VBUS_EVT_IBEACON_GET_UUID_REPLY                        = 1009,  //struct protocol_beacon_ret_uuid
    
	VBUS_EVT_FUNC_ADD_ALARM                                = 5000,	//添加闹钟
	VBUS_EVT_FUNC_GET_LIB_VERSION                          = 5001,	//获取版本号
	VBUS_EVT_FUNC_START_SYNC_V3_HEALTH                     = 5002,  //v3同步开始命令
	VBUS_EVT_FUNC_STOP_SYNC_V3_HEALTH                      = 5003,  //v3同步结束指令
	VBUS_EVT_FUNC_GET_ANCS_APPID                           = 5004,	//获取APPID ios only
	VBUS_EVT_FUNC_SET_ANCS_PARAM                           = 5005,  //设置ancs  ios only
	VBUS_EVT_FUNC_GET_WATCH_FACE_LIST                      = 5006,  //获取表盘列表(v3)
	VBUS_EVT_FUNC_GET_SCREEN_IFNO                          = 5007,	//获取屏幕信息
	VBUS_EVT_FUNC_SET_WATCH_FACE_DATA                      = 5008,  //设置表盘(v3)
	VBUS_EVT_FUNC_MK_WATCH_FACE                            = 5009,	//制作表盘
	
    VBUS_EVT_FUNC_V3_SET_HR_MODE                           = 5010,  //设置心率模式
	VBUS_EVT_FUNC_V3_MUSIC_CONTROL                         = 5011,	//控制音乐
	VBUS_EVT_FUNC_V3_NOTICE_MESSAGE                        = 5012,  //通知消息提醒
    VBUS_EVT_FUNC_V3_SPORT_SORT                            = 5013,	//设置运动类型排序
    VBUS_EVT_FUNC_V3_GET_SPORT_TYPE                        = 5016,  //获取运动默认的类型
	VBUS_EVT_FUNC_V3_SET_ALARM                             = 5017,	//APP设置ble的闹钟
    VBUS_EVT_FUNC_V3_GET_ALARM                             = 5018,	//APP获取ble的闹钟
    VBUS_EVT_FUNC_V3_GET_HEAT_LOG                          = 5019,  //APP获取手环过热日志
    
    VBUS_EVT_FUNC_V3_SET_FAST_MSG                          = 5020,  //APP设置回复快速信息 struct protocol_set_fast_msg_reply
	VBUS_EVT_FUNC_V3_ACTIVITY_DATA_EXCHANGE                = 5021,	//多运动数据交互 protocol_v3_activity_exchange， struct sync_activity_exchange_reply
	VBUS_EVT_FUNC_V3_GET_ACTIVITY_DATA                     = 5022,	//多运动数据最后一次数据获取 struct protocol_get_activity_data_reply
	VBUS_EVT_FUNC_V3_GET_ACTIVITY_EXCHANGE_HEART_RATE_DATA = 5023,  //多运动数据数据交换中获取1分钟的心率数据  protocol_v3_base， struct sync_activity_exchange_hr_data_reply
    VBUS_EVT_FUNC_V3_GET_LANGUAGE_LIBRARY_DATA             = 5024,  //获取设备字库列表   protocol_v3_base， struct protocol_get_language_reply
	VBUS_EVT_FUNC_V3_SET_VOICE_REPLY_TXT                   = 5025,  //语音回复文本  struct protocol_v3_voice_reply_txt_message  struct protocol_set_reply
    VBUS_EVT_FUNC_V3_GET_HEAD_PACK                         = 5026,  //同步数据子项目同步头部数据上传上层  struct v3_head_data
	VBUS_EVT_FUNC_V3_GET_HEAD_ALL_PACK_DELAY               = 5027,  //同步数据总包个数和总延时上传上层  struct protocol_v3_all_date_dely
	VBUS_EVT_FUNC_V3_SET_VOICE_SET_ALARM                   = 5028,  //语音设置闹钟数据 struct protocol_v3_voice_alarm_set_data ;  struct protocol_set_reply
	VBUS_EVT_FUNC_V3_SET_VOICE_SET_REMINDER                = 5029,  //语音设置提醒 struct protocol_v3_voice_reminder_set_data； struct protocol_set_reply
	
    VBUS_EVT_FUNC_V3_GET_ACTIVITY_EXCHANGE_GPS_DATA        = 5030,  //多运动数据数据交换中获取一段时间的gps数据 struct sync_activity_exchange_GPS_data_reply
	VBUS_EVT_FUNC_V3_GET_V3_FUNCTION_TABLE                 = 5031,  //获取功能表 protocol_v3_function_table_get_function_table_table(); struct protocol_v3_function_table_data_decode_reply
	VBUS_EVT_FUNC_V3_ALEXA_SET_WEATHER                     = 5032,  //Alexa设置天气  struct protocol_v3_alexa_set_weather_set_data,struct protocol_set_reply
	VBUS_EVT_FUNC_V3_ALEXA_GTE_ALARM2                      = 5033,  //Alexa获取V3的闹钟   struct protocol_v3_base; struct protocol_v3_voice_alarm_set_data_add;
	VBUS_EVT_FUNC_V3_ALEXA_STE_ALARM2                      = 5034,  //Alexa设置V3的闹钟   struct protocol_v3_voice_alarm_set_data_add,  struct protocol_set_reply
	VBUS_EVT_FUNC_V3_GET_WATCH_LIST_NEW                    = 5035,  //获取表盘列表         struct protocol_v3_file_list_item
	VBUS_EVT_FUNC_V3_SET_WALLPAPER_DIAL_REPLY              = 5036,  //设置壁纸表盘 颜色和位置 struct protocol_v3_set_wallpaper_dial, struct protocol_v3_set_wallpaper_dial_reply
    VBUS_EVT_FUNC_V3_SET_100_SPORT_SORT                    = 5037,  //设置获取100种运动排序  struct protocol_v3_100_sport_mode_sort, struct protocol_v3_100_sport_mode_sort_reply
    VBUS_EVT_FUNC_V3_SCHEDULER_REMINDER                    = 5038,  //设置日程提醒  struct protocol_schedule_reminder, struct protocol_schedule_reminder_reply
    VBUS_EVT_FUNC_V3_MAIN_UI_SORT                          = 5039,  //设置主界面控件排序 struct protocol_v3_main_ui_sort_set, struct protocol_v3_main_ui_sort_set_reply
	
    VBUS_EVT_FUNC_V3_BASE_SPORT_PARAM_SORT                 = 5040,  //设置运动子项数据排列, struct protocol_v3_base_sport_param_sort_set, struct protocol_v3_base_sport_param_sort_set_reply
	VBUS_EVT_FUNC_V3_SET_LONG_CITY_NAME                    = 5041,  //设置运动城市名称 struct protocol_set_long_city_name, struct protocol_set_long_city_name_reply
    VBUS_EVT_TRAN_JSON_SET_NOTICE_MESSAGE_STATE            = 5042,  //设置单个应用的通知状态 struct protocol_v3_notice_message_state_set, struct protocol_v3_notice_message_state_set_reply
    VBUS_EVT_TRAN_JSON_GET_APP_PACK_NAME                   = 5043,  //APP获取ISO的回复的app的包名  null; struct protocol_get_app_pack_name_reply
	VBUS_EVT_TRAN_JSON_SYNC_CONTACT                        = 5044,  //同步协议蓝牙通话常用联系人 struct protocol_sync_contact, struct protocol_sync_contact_reply
	VBUS_EVT_FUNC_V3_SET_V3_WEATHER                        = 5045,  //下发V3天气协议 struct protocol_set_v3_weather, struct protocol_set_v3_weather_reply
	VBUS_EVT_FUNC_V3_SET_WORLD_TIME                        = 5046,  //下发V3世界时间 struct protocol_set_v3_world_time， struct protocol_set_v3_world_time_reply
	VBUS_EVT_FUNC_V3_SET_WALK_REMIND_TIMES                 = 5047,  //设置多个走动提醒的时间点  struct protocol_set_walk_remind_times， struct protocol_set_walk_remind_times_reply  ID206定制
	VBUS_EVT_FUNC_V3_GET_BLE_MUSIC_INFO                    = 5048,	//获取固件的歌曲名和文件夹  NULL; struct protocol_v3_get_ble_music_info_reply
	VBUS_EVT_FUNC_V3_OPERATE_BLE_MUSIC                     = 5049,	//操作歌曲或者文件夹 struct protocol_v3_operate_ble_music_reply; protocol_v3_operate_ble_music
	
    VBUS_EVT_JSON_VOICE_TO_BLE_STATE_CALL_BACK             = 5050,  //APP语音数据to ble 状态回调给上层的app 参考 VOICE_TO_BLE_STATE
	VBUS_EVT_FUNC_V3_NOTICE_MESSAGE_ADD_APP_NAME           = 5051,	//通知消息提醒(8国语言)
	VBUS_EVT_FUNC_V3_GET_HISTORICAL_MENSTRUATION           = 5052,  //经期的历史数据下发 struct protocol_v3_historical_menstruation, struct protocol_v3_historical_menstruation_reply
	VBUS_EVT_FUNC_V3_SET_WATCH_DIAL_SORT                   = 5053,  //设置表盘顺序 protocol_v3_watch_dial_sort_item,protocol_v3_watch_dial_sort
	VBUS_EVT_FUNC_V3_SEND_RUN_PLAN                         = 5054,  //APP下发跑步计划(运动计划) struct protocol_v3_sport_plan struct protocol_v3_sport_plan_reply
	VBUS_EVT_FUNC_V3_BLE_TO_APP_SPORT_CUTOVER              = 5055,  //设备通知app运动过程切换
    VBUS_EVT_FUNC_V3_APP_TO_BLE_SPORT_CUTOVER              = 5056,  //APP通知设备运动过程切换
//	VBUS_EVT_FUNC_V3_SPORT_PLAN_ACTIVITY_DATA_EXCHANGE     = 5057,  //运动计划中多运动数据交互,运动中的数据接收和发送 废弃
//  VBUS_EVT_FUNC_V3_SPORT_PLAN_GET_ACTIVITY_DATA          = 5058,  //运动计划中多运动数据交互最后一次多运动数据查询  废弃
	VBUS_EVT_FUNC_V3_GET_HABIT_INFORMATION                 = 5059,  //获取用户习惯信息
    VBUS_EVT_FUNC_V3_GET_ALGORITHM_VERSION                 = 5060,  //V3获取固件算法版本号信息 struct protocol_get_3_level_alg_version_reply

	VBUS_EVT_FUNC_V3_SET_HOT_START_PARAM                   = 5070,  //设置gps热启动参数 替代v2设置热启动参数 158事件
	VBUS_EVT_FUNC_V3_GET_BLE_BEEP                          = 5071,  //获取固件本地提示音文件信息
	VBUS_EVT_FUNC_V3_BP_CAL_CONTROL                        = 5072,  //V3血压校准控制 struct protocol_v3_bp_cal_control struct protocol_v3_bp_cal_control_reply
	VBUS_EVT_FUNC_V3_BP_CAL_COMPLETE                       = 5073,  //V3血压校准完成
    VBUS_EVT_FUNC_SMART_COMPETITOR_CONFIG_INFO             = 5080,  //智能陪跑配置信息

	VBUS_EVT_FUNC_MAKE_PHOTO                               = 5500,	//制作照片
	VBUS_EVT_FUNC_GPS_FILE                                 = 5501,	//制作gps文件
	VBUS_EVT_FUNC_SIMPLE_FILE_OPERATIONS                   = 5510,  //简单文件操作 struct protocol_simple_file_operations,struct protocol_simple_file_operations_reply
	VBUS_EVT_FUNC_FLASH_LOG_START                          = 5511,	//开始获取flash log
	VBUS_EVT_FUNC_FLASH_LOG_STOP                           = 5512,	//停止获取flash log
	VBUS_EVT_FUNC_FLASH_LOG_COMPLETE                       = 5513,  //flash log获取完成事件 预留 使用独一注册回调结果
	VBUS_EVT_FUNC_RESET_V3_HEALTH_SYNC_OFFSET              = 5514,	//重置V3 同步偏移
	VBUS_EVT_FUNC_GET_V3_BATTERY_LOG                       = 5515,	//获取电池日志 protocol_battery_log_start_get(void); struct protocol_battery_log_data
	VBUS_EVT_FUNC_MP3_TO_PCM                               = 5516,  //音频文件转换 mp3_to_pcm(char* mp3Path,char* pcmPath);
	VBUS_EVT_FUNC_PCM_TO_MP3                               = 5517,  //音频文件转换  将采样率转化为44.1khz   mp3_to_mp3(char* mp3Path,char* pcmPath);
	VBUS_EVT_FUNC_TRANS_ALL_CONTACT                        = 5518,  //APP下发蓝牙联系人数据给协议层
	VBUS_EVT_FUNC_FLASH_LOG_SCOND_CHIP_START               = 5519,	//开始获取第二块芯片flash log

	MP3_TO_MP3_PROCESSING                                  = 5530,  //MP3转换进度  注意错误值和回调值

	VBUS_EVT_FUNC_AUTOMATIC_START_SYNC_V3_HEALTH           = 5555,  //app每半个小时主动更新 开始同步V3数据，睡眠数据不返回  protocol_v3_health_automatic_client_async_start()
	VBUS_EVT_FUNC_PAUSE_SYNC_HEALTH                        = 5556,  //暂停同步V3数据  protocol_v3_health_client_sync_pause

	//ble to app: 然后app再回复
	VBUS_EVT_FUNC_V3_BLE_TO_APP_DAIL_CHANGE                = 5800,  //APP获取表盘颜色样式修改 struct vv3_ble_to_app_dail_change_ble_to_app， struct v3_ble_to_app_dail_change_app_to_ble

	//health json 传输
	VBUS_EVT_TRAN_JSON_HEALTH_SPORT 		               = 6000,	//运动数据
	VBUS_EVT_TRAN_JSON_HEALTH_SLEEP                        = 6001,	//睡眠数据
	VBUS_EVT_TRAN_JSON_HEALTH_HR                           = 6002,	//心率数据
	VBUS_EVT_TRAN_JSON_HEALTH_BP                           = 6003,	//血压数据
	VBUS_EVT_TRAN_JOSN_GPS                                 = 6004,	//GPS 数据

	//新增天气数据设置 hedongyang 2019-12-27
	VBUS_EVT_APP_WEATCHER_CITY_NAME                        = 6500,  //设置天气城市名称  struct protocol_weather_city_name
	VBUS_EVT_APP_WEATCHER_REAL_TIME_ONE                    = 6501,  //设置当天0~8时实时天气+温度  struct protocol_weather_real_time
	VBUS_EVT_APP_WEATCHER_REAL_TIME_TWO                    = 6502,  //设置当天9~16时实时天气+温度  struct protocol_weather_real_time
	VBUS_EVT_APP_WEATCHER_REAL_TIME_THREE                  = 6503,  //设置当天17~24时实时天气+温度  struct protocol_weather_real_time
    VBUS_EVT_APP_WEATCHER_SET_SUN_TIME                     = 6504,  //设置日出日落时间  struct protocol_weatcher_sun_time，struct protocol_weatch_sun_time_reply

	//v3健康数据
	VBUS_EVT_TRAN_JSON_V3_SYS_LOG                          = 7000,	//系统log数据
	VBUS_EVT_TRAN_JSON_V3_SPO2                             = 7001,	//血氧数据回调
	VBUS_EVT_TRAN_JSON_V3_PRESSURE		    	           = 7002,  //压力数据回调
	VBUS_EVT_TRAN_JSON_V3_HR					           = 7003,  //心率数据回调
	VBUS_EVT_TRAN_JSON_V3_ACTIVITY 		                   = 7004,  //多运动数据回调
	VBUS_EVT_TRAN_JSON_V3_GPS 					           = 7005,  //GPS运动数据回调
	VBUS_EVT_TRAN_JSON_V3_SWIMMING 				           = 7006,  //游泳数据回调
    VBUS_EVT_TRAN_JSON_V3_SLEEP                            = 7007,  //睡眠数据回调
    VBUS_EVT_TRAN_JSON_V3_SPORT                            = 7008,  //运动数据回调
	VBUS_EVT_TRAN_JSON_V3_NOISE                            = 7009,  //噪音数据回调
	VBUS_EVT_TRAN_JSON_V3_TEMPERATURE                      = 7010,	//温度数据回调
    
	VBUS_EVT_TRAN_JSON_V3_BP 		                       = 7011,  //血压数据回调
	VBUS_EVT_TRAN_JSON_V3_RESPIR_RATE 		               = 7012,  //呼吸率数据回调
	VBUS_EVT_TRAN_JSON_V3_BODY_POWER 		               = 7013,  //身体电量数据回调
	VBUS_EVT_TRAN_JSON_V3_HRV 				               = 7014,  //HRV数据回调
	VBUS_EVT_TRAN_JSON_V3_TEST_SYNC_PLAN_SPORT             = 7113,	//计划多运动模拟测试接口
    VBUS_EVT_TRAN_JSON_V3_RESPIR_RATE_INFO                 = 7114,	//呼吸率数据同步发送
    
	//voice file tran 音频传输
	VBUS_EVT_TRAN_JSON_VOICE_TRAN                                = 7500,
	VBUS_EVT_TRAN_JSON_VOICE_TRAN_SET_BLE_START                  = 7501,   //APP接受到開始數據，下發可以開始
	VBUS_EVT_TRAN_JSON_VOICE_TRAN_SET_BLE_END                    = 7502,   //APP接收到停止數據，下發停止
    VBUS_EVT_TRAN_JSON_VOICE_TRAN_STATE                          = 7503,   //APP状态回调
	VBUS_EVT_TRAN_JSON_VOICE_TRAN_OPUS_ENCODE_DATA               = 7504,   //APP每帧的回调数据
	VBUS_EVT_TRAN_JSON_VOICE_TRAN_LOST_DATA                      = 7505,   //丢数据的传输给app struct voice_file_tran_lost_data
	VBUS_EVT_TRAN_JSON_VOICE_TRAN_APP_SET_BLE_START_FACTORY_TEST = 7506,   //APP下发BLE开始命令 工厂测试
	VBUS_EVT_TRAN_JSON_VOICE_TRAN_APP_SET_BLE_END_FACTORY_TEST   = 7507,   //APP下发BLE结束命令 工厂测试
	VBUS_EVT_TRAN_JSON_VOICE_TRAN_EACH_PCM_DATA                  = 7508,   //传给app每帧的pcm数据
	VBUS_EVT_TRAN_JSON_VOICE_TRAN_APP_SET_BLE_END                = 7509,   //APP下发BLE结束命令 语音传输过程中

	VBUS_EVT_VOICE_SET_UI_CONTROLL_SPORTS                        = 7601,   //多运动界面   struct ui_controll_sports, struct protocol_set_base_reply
	VBUS_EVT_VOICE_SET_UI_CONTROLL_STOPWATCH                     = 7602,   //秒表  struct ui_controll_time_delay , struct protocol_set_base_reply
	VBUS_EVT_VOICE_SET_UI_CONTROLL_COUNT_DOWN                    = 7603,   //倒数计时 struct ui_controll_time_count_down, struct protocol_set_base_reply
	VBUS_EVT_VOICE_SET_UI_CONTROLL_HEALTH_DATA                   = 7604,   //健康数据 无效 使用VBUS_EVT_VOICE_SET_UI_CONTROLL_JUMP代替
	VBUS_EVT_VOICE_SET_UI_CONTROLL_HEART_RATE                    = 7605,   //心率    无效 使用VBUS_EVT_VOICE_SET_UI_CONTROLL_JUMP代替
	VBUS_EVT_VOICE_SET_UI_CONTROLL_PRESSURE                      = 7606,   //压力检测 无效 使用VBUS_EVT_VOICE_SET_UI_CONTROLL_JUMP代替
	VBUS_EVT_VOICE_SET_UI_CONTROLL_BREATHING_TRAINING            = 7607,   //呼吸训练 无效 使用VBUS_EVT_VOICE_SET_UI_CONTROLL_JUMP代替
	VBUS_EVT_VOICE_SET_UI_CONTROLL_SLEEP_RECORD                  = 7608,   //睡眠记录 无效 使用VBUS_EVT_VOICE_SET_UI_CONTROLL_JUMP代替
	VBUS_EVT_VOICE_SET_UI_CONTROLL_SPORT_RECORD                  = 7609,   //运动记录 无效 使用VBUS_EVT_VOICE_SET_UI_CONTROLL_JUMP代替
	
    VBUS_EVT_VOICE_SET_UI_CONTROLL_WEATHER                       = 7610,   //天气界面 无效 使用VBUS_EVT_VOICE_SET_UI_CONTROLL_JUMP代替
	VBUS_EVT_VOICE_SET_UI_CONTROLL_FIND_PHONE                    = 7611,   //寻找手机 无效 使用VBUS_EVT_VOICE_SET_UI_CONTROLL_JUMP代替
	VBUS_EVT_VOICE_SET_UI_CONTROLL_MUSIC_CONTROLL                = 7612,   //音乐控制界面 无效 使用VBUS_EVT_VOICE_SET_UI_CONTROLL_JUMP代替
	VBUS_EVT_VOICE_SET_UI_CONTROLL_REAL_TIME_HEART_RATE          = 7613,   //实时心率开关 无效 使用VBUS_EVT_VOICE_SET_UI_CONTROLL_JUMP代替
	VBUS_EVT_VOICE_SET_UI_CONTROLL_WRIST_BRIGHT_SCREEN           = 7614,   //抬腕亮屏界面 无效 使用VBUS_EVT_VOICE_SET_UI_CONTROLL_JUMP代替
	VBUS_EVT_VOICE_SET_UI_CONTROLL_BLACK_SCREEN                  = 7615,   //灭屏 无效 使用VBUS_EVT_VOICE_SET_UI_CONTROLL_JUMP代替
	VBUS_EVT_VOICE_SET_UI_CONTROLL_REBOOT                        = 7616,   //重启 无效 使用VBUS_EVT_VOICE_SET_UI_CONTROLL_JUMP代替
	VBUS_EVT_VOICE_SET_UI_CONTROLL_BRIGHT_SCREEN                 = 7617,   //屏幕亮度 无效 使用VBUS_EVT_VOICE_SET_UI_CONTROLL_JUMP代替
	VBUS_EVT_VOICE_SET_UI_CONTROLL_NOT_DISTURB                   = 7618,   //勿擾界面 无效 使用VBUS_EVT_VOICE_SET_UI_CONTROLL_JUMP代替
	VBUS_EVT_VOICE_SET_UI_CONTROLL_NOTIFY                        = 7619,   //消息界面 无效 使用VBUS_EVT_VOICE_SET_UI_CONTROLL_JUMP代替
    
	VBUS_EVT_VOICE_SET_UI_CONTROLL_ALARM                         = 7620,   //闹钟界面  struct voice_ui_controll_alarm ,  struct protocol_set_base_reply 无效 使用VBUS_EVT_VOICE_SET_UI_CONTROLL_JUMP代替
	VBUS_EVT_VOICE_SET_UI_CONTROLL_EASY_OPERATION                = 7621,   //Alexa简单的设置命令  struct protocol_set_alexa_operation, struct protocol_set_base_reply
	VBUS_EVT_VOICE_SET_UI_CONTROLL_JUMP                          = 7622,   //Alexa跳转ui界面 struct protocol_set_alexa_jump_ui, struct protocol_set_base_reply
    VBUS_EVT_VOICE_GET_ALEXA_DEFAULT_LANGUAGE                    = 7623,   //获取alexa的默认语言 struct protocol_head head; struct protocol_alexa_default_language
	VBUS_EVT_VOICE_SET_ON_OFF_TYPE                               = 7624,   //alexa app设置开关命令 struct protocol_alexa_set_on_off_type; struct protocol_set_base_reply

	VBUS_EVT_VOICE_BLE_GET_PHONE_LOGIN_STATE                     = 7630,   //蓝牙设备获取手机登录状态 protocol_voice_file_tran_get_state_reply; 功能表 ex_main7_voice_transmission
	VBUS_EVT_VOICE_PHONE_SET_RECOGNITION_STATE                   = 7631,   //手机设置识别后的状态  protocol_voice_file_tran_set_state,   protocol_set_base_reply; 功能表 ex_main7_voice_transmission
	VBUS_EVT_VOICE_PHONE_SET_ALEXA_NOTIFY_STATE                  = 7632,   //APP设置手表端alexa通知状态 struct protocol_set_ble_alexa_notify_state， struct protocol_set_base_reply
    VBUS_EVT_VOICE_TRAN_TO_BLE_START                             = 7633,   //APP to ble文本传输设置配置且请求传输,固件回复成功的话才能继续执行7634事件
	VBUS_EVT_VOICE_TRAN_TO_BLE_ON_GOING                          = 7634,   //APP to ble文本传输开始
	VBUS_EVT_VOICE_TRAN_TO_BLE_END                               = 7635,   //APP to ble文本传输结束
	VBUS_EVT_VOICE_TRAN_TO_BLE_ABNORMAL_END                      = 7636,   //APP to ble固件异常返回 文本传输结束

	VBUS_EVT_TRAN_STOP_SEND_DATA_BY_APP                          = 7900,   //APP传输数据过程中，模拟错误停止传输
	VBUS_EVT_DEVICES_TEST_TYPE                                   = 7901,   //固件测试
    
	VBUS_EVT_TRAN_STOP_SEND_DATA_BY_APP_SPP                      = 7950,   //APP传输数据过程中，模拟错误停止传输  spp蓝牙专用
    VBUS_EVT_APP_GET_MTU_LENGTH_SPP                              = 7951,   //获取固件spp mtu长度 新增 spp蓝牙专用

} VBUS_EVT_TYPE;

#endif /* VBUS_EVT_APP_H_ */

