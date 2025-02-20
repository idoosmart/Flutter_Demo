import 'dart:typed_data';
import 'dart:ffi' as ffi;

// ----------------------------------- 常用回调 -----------------------------------

/// 回调处理函数,解析app下发的json后组合二进制上报给app
///
/// data二进制数据 | length数据长度 | type 0:BLE数据 1:SPP数据
/// typedef void (*protocol_data_send_handle)(const uint8_t *data,uint16_t length,uint8_t type);
typedef CallbackWriteDataHandle = void Function(Uint8List, int, int);

/// 解析完固件返回的二进制数据,打包成json数据回调给SDK
///
/// typedef void (*protocol_json_cb_handle)(char *json_str, VBUS_EVT_TYPE type, uint32_t error_code);
typedef CallbackJsonDataTransferCbEvt = void Function(String, int, int);

// ----------------------------------- c库通知 -----------------------------------

/// 回调处理函数,c库通知app事件
///
/// typedef void (*protocol_notice_cb_handle)(VBUS_EVT_BASE evt_base,VBUS_EVT_TYPE evt_type,uint32_t error,uint32_t val);
typedef CallbackNoticeCbHandle = void Function(int, int, int, int);

// ----------------------------------- 文件传输 -----------------------------------

/// 回调处理函数,传输文件进度回调
///
/// typedef void (*data_tran_progress_cb_handle)(uint8_t rate);
typedef CallbackDataTranProgressCbHandle = void Function(int);

/// 回调处理函数,传输文件完成回调
///
/// typedef void (*data_tran_complete_cb_handle)(uint32_t error,uint32_t error_vale);
typedef CallbackDataTranCompleteCbHandle = void Function(int, int);

/// 回调处理函数, 设备->app 上报json
///
/// typedef void (*protocol_report_json_cb_handle)(char *json_str);
typedef CallbackDataTranToAppReportJsonCbHandle = void Function(String);

// ----------------------------------- V2同步 -----------------------------------

/// 回调处理函数,同步v2活动数据进度回调
///
/// typedef void (*protocol_sync_activity_progress_cb_handle)(uint8_t progress);
typedef CallbackSyncActivityProgressCbHandle = void Function(int);

/// 回调处理函数,同步v2GPS数据进度回调
///
/// typedef void (*protocol_sync_gps_progress_cb_handle)(uint8_t progress);
typedef CallbackSyncGpsProgressCbHandle = void Function(int);

/// 回调处理函数,同步v2活动数据完成回调
///
/// typedef void (*protocol_sync_activity_complete_cb_handle)(uint32_t error_code);
typedef CallbackSyncV2ActivityCompleteCbHandle = void Function(int);

/// 回调处理函数,同步v2GPS数据完成回调
///
/// typedef void (*protocol_sync_gps_complete_cb_handle)(uint32_t error_code);
typedef CallbackSyncV2GpsCompleteCbHandle = void Function(int);

///回调处理函数,同步v2健康数据进度回调
///
/// typedef void (*protocol_sync_health_progress_cb_handle)(uint8_t progress);
typedef CallbackSyncV2HealthProgressCbHandle = void Function(int);

/// 回调处理函数,同步v2健康数据完成回调
///
/// typedef void (*protocol_sync_health_complete_cb_handle)(uint32_t error_code);
typedef CallbackSyncV2HealthCompleteCbHandle = void Function(int);

// ----------------------------------- V3同步 -----------------------------------

/// 回调处理函数,v3血压校准完成通知回调
///
/// typedef void (*protocol_bp_cal_complete_cb_handle)(uint32_t error_code);
typedef CallbackBpCalCompleteCbHandle = void Function(int);

/// 回调处理函数,同步v3健康数据进度回调
///
/// typedef void (*protocol_sync_v3_health_client_progress_cb_handle)(uint8_t progress);
typedef CallbackSyncV3HealthClientProgressCbHandle = void Function(int);

/// 回调处理函数,同步v3健康数据完成回调
///
/// typedef void (*protocol_sync_v3_health_client_complete_cb_handle)(uint32_t error_code);
typedef CallbackSyncV3HealthClientCompleteCbHandle = void Function(int);

/// 回调处理函数,同步v3健康数据项完成回调
///
/// typedef void (*protocol_sync_v3_health_client_one_notice_complete_cb_handle)(uint8_t type);
typedef CallbackSyncV3HealthClientOneNoticeCompleteCbHandle = void Function(
    int);

// ----------------------------------- 日志 -----------------------------------

/// 回调处理函数,获取flash日志完成回调
///
/// typedef void (*protocol_flash_log_tran_complete_cb_handle)(uint32_t error_code)
typedef CallbackFlashLogTranCompleteCbHandle = void Function(int);

/// 回调处理函数,响应原始数据给app //老的重启日志需要原始数据
///
/// typedef void (*protocol_data_response_handle)(const uint8_t *data,uint16_t length);
typedef CallbackDataResponseHandle = void Function(Uint8List, int);

/// 回调处理函数,获取电池日志信息完成回调
///
/// typedef void (*protocol_get_battery_log_info_complete_cb_handle)(char *json_str, uint32_t error_code);
typedef CallbackBatteryLogInfoCompleteCbHandle = void Function(String, int);

/// 回调处理函数,获取过热日志信息完成回调
///
/// typedef void (*protocol_get_heat_log_info_complete_cb_handle)(char *json_str, uint32_t error_code);
typedef CallbackHeatLogInfoCompleteCbHandle = void Function(String, int);

/// 获取flashlog进度回调注册
///
/// extern uint32_t FlashLogTranProgressCallbackReg(protocol_report_progress_cb_handle func);
typedef CallbackFlashLogTranProgressCallbackReg = void Function(int);

// ----------------------------------- 定时器 -----------------------------------

/// 定时器超时回调
///
/// typedef void (*app_timer_timeout_evt)(void *data)
typedef HandleAppTimerTimeoutEvt = void Function(int);

/// 开始定时器
///
/// typedef uint32_t (*app_timer_start_st)(uint32_t timer_id,uint32_t ms,void *data);
typedef CallbackAppTimerStartSt = int Function(int, int, int);

/// 停止定时器
///
/// typedef uint32_t (*app_timer_stop_st)(uint32_t timer_id);
typedef CallbackAppTimerStopSt = int Function(int);

/// 创建定时器
///
/// typedef uint32_t (*app_timer_create_st)(uint32_t *timer_id,app_timer_timeout_evt func);
typedef CallbackAppTimerCreateSt = int Function(
    ffi.Pointer<ffi.Uint32>, HandleAppTimerTimeoutEvt);

// ----------------------------------- MP3 -----------------------------------

/// 回调处理函数,音频采样率转换完成回调
///
/// typedef void (*mp3tomp3_complete_cb_handle)(uint32_t error_code);
typedef CallbackMp3ToMp3CompleteCbHandle = void Function(int);

typedef CallbackAudioSRConversionProgressCbHandle = void Function(int);

// ----------------------------------- Alexa -----------------------------------

/// 回调处理函数,app上报传输语音文件状态
/// ```dart
/// status：
/// VOICE_TO_BLE_STATE_IDLE         = 0, //空闲态
/// VOICE_TO_BLE_STATE_START        = 1, //开始
/// VOICE_TO_BLE_STATE_END          = 2, //停止状态 正常的停止的
/// VOICE_TO_BLE_STATE_TIME_OUT     = 3, //超时
/// VOICE_TO_BLE_STATE_DISCONNECT   = 4, //断线
/// ```
/// typedef void (*protocol_report_voice_file_tran_status_cb_handle)(uint8_t status);
typedef CallbackReportVoiceFileTranStatusCbHandle = void Function(int status);

/// 回调处理函数,app执行传输的固件回复结果回调
/// ```dart
/// evt事件：
/// VBUS_EVT_VOICE_TRAN_TO_BLE_START(7633)、
/// VBUS_EVT_VOICE_TRAN_TO_BLE_ABNORMAL_END(7636)、
/// VBUS_EVT_VOICE_TRAN_TO_BLE_END(7635)
/// 备注：使用voiceFileTranToBleSetParam方法 固件返回结果事件号对应VBUS_EVT_VOICE_TRAN_TO_BLE_START
/// 使用voiceFileTranToBleStop方法 固件返回结果事件号对应VBUS_EVT_VOICE_TRAN_TO_BLE_END
/// VBUS_EVT_VOICE_TRAN_TO_BLE_ABNORMAL_END事件对应的是传输过程中,固件回应包携带的错误码上报
/// ```
/// typedef void (*protocol_report_voice_file_tran_send_operate_reply_cb_handle)(int evt, uint8_t error_code);
typedef CallbackReportVoiceFileTranSendOptReplyCbHandle = void Function(
    int event, int errorCode);

/// 回调处理函数,ble上报传输语音文件状态
/// ```dart
/// status：
/// VOICE_STATE_IDLE             = 0, //空闲态
/// VOICE_STATE_START            = 1, //开始
/// VOICE_STATE_END              = 2, //停止状态 正常的停止的
/// VOICE_STATE_TIME_OUT         = 3, //超时
/// VOICE_STATE_DISCONNECT       = 4, //断线
/// VOICE_STATE_LOG              = 5, //登录状态
/// VOICE_STATE_APP_START        = 6, //开始
/// VOICE_APP_START_FAILED       = 7, //app发起开始失败
/// VOICE_STATE_APP_END          = 8, //停止状态
/// VOICE_APP_STOP_FAILED        = 9, //app发起结束失败
/// VOICE_APP_END_RETURN_BACK    = 10,//ALEXA 按钮退出到主界面
/// VOICE_BLE_CHANGE_ALEXA_ALARM = 11,//固件修改alexa设置的闹钟，需要重新获取alexa的闹钟数据
/// ```
/// typedef void (*protocol_report_opus_voice_file_tran_status_cb_handle)(uint8_t status);
typedef CallbackReportOpusVoiceFileTranStatusCbHandle = void Function(
    int status);

/// 回调处理函数,ble上报传输语音文件丢包率
/// ```dart
/// size_lost_package:丢包数 size_all_package:总包数
/// typedef void (*protocol_report_opus_voice_file_tran_lost_data_cb_handle)(uint32_t size_lost_package, uint32_t size_all_package);
/// ```
typedef CallbackReportOpusVoiceFileTranLostDataCbHandle = void Function(
    int sizeLostPkg, int sizeAllPkg);

/// 回调处理函数,opus数据上报
/// ```dart
/// data:pcm编码数据 data_len:数据大小
/// typedef void (*protocol_report_opus_voice_file_tran_data_cb_handle)(char * data, int data_len);
/// ```
typedef CallbackReportOpusVoiceFileTranDataCbHandle = void Function(
    Uint8List data, int len);
