//
// Created by luoft on 8/18/22.
//

#ifndef IDO_PROTOCOL_PUBLIC_INTERFACE_H
#define IDO_PROTOCOL_PUBLIC_INTERFACE_H

#include "include_help.h"
#include "vbus_evt_app.h"

//回调处理函数,解析app下发的json后组合二进制上报给app
//@paran data二进制数据 length数据长度 type 0:BLE数据 1:SPP数据
typedef void (*protocol_data_send_handle)(const uint8_t *data,uint16_t length,uint8_t type);
//回调处理函数,响应原始数据给app //老的重启日志需要原始数据
typedef void (*protocol_data_response_handle)(const uint8_t *data,uint16_t length);
//回调处理函数,解析固件回复结果打包成json上报app
typedef void (*protocol_json_cb_handle)(char *json_str, VBUS_EVT_TYPE type, uint32_t error_code);
//回调处理函数,c库通知app事件
typedef void (*protocol_notice_cb_handle)(VBUS_EVT_BASE evt_base,VBUS_EVT_TYPE evt_type,uint32_t error,uint32_t val);
//回调处理函数,传输文件完成回调
typedef void (*data_tran_complete_cb_handle)(uint32_t error,uint32_t error_vale);
//回调处理函数,传输文件进度回调
typedef void (*data_tran_progress_cb_handle)(uint8_t rate);

//回调处理函数,音频采样率转换完成回调
//@param error_code 0:成功  1:失败,采样率已经是44.1kHZ不需要转换  2:失败,pcm转换失败  3:失败,读取文件失败
typedef void (*mp3tomp3_complete_cb_handle)(uint32_t error_code);

//回调处理函数,获取flash日志完成回调
//@param error_code 0:成功,8:断线异常,13:超时异常
typedef void (*protocol_flash_log_tran_complete_cb_handle)(uint32_t error_code);
//回调处理函数,获取电池日志信息完成回调
typedef void (*protocol_get_battery_log_info_complete_cb_handle)(char *json_str, uint32_t error_code);
//回调处理函数,获取过热日志信息完成回调
typedef void (*protocol_get_heat_log_info_complete_cb_handle)(char *json_str, uint32_t error_code);

//回调处理函数,同步v2活动数据进度回调
typedef void (*protocol_sync_activity_progress_cb_handle)(uint8_t progress);
//回调处理函数,同步v2活动数据完成回调
typedef void (*protocol_sync_activity_complete_cb_handle)(uint32_t error_code);
//回调处理函数,同步v2GPS数据进度回调
typedef void (*protocol_sync_gps_progress_cb_handle)(uint8_t progress);
//回调处理函数,同步v2GPS数据完成回调
typedef void (*protocol_sync_gps_complete_cb_handle)(uint32_t error_code);
//回调处理函数,同步v2健康数据进度回调
typedef void (*protocol_sync_health_progress_cb_handle)(uint8_t progress);
//回调处理函数,同步v2健康数据完成回调
typedef void (*protocol_sync_health_complete_cb_handle)(uint32_t error_code);

//回调处理函数,v3血压校准完成通知回调
typedef void (*protocol_bp_cal_complete_cb_handle)(uint32_t error_code);
//回调处理函数,同步v3健康数据进度回调
typedef void (*protocol_sync_v3_health_client_progress_cb_handle)(uint8_t progress);
//回调处理函数,同步v3健康数据完成回调
typedef void (*protocol_sync_v3_health_client_complete_cb_handle)(uint32_t error_code);//v3同步完成事件,注意错误值,SUCCESS为成功,其他为失败
//回调处理函数,同步v3健康数据项完成回调
typedef void (*protocol_sync_v3_health_client_one_notice_complete_cb_handle)(uint8_t type);

//回调处理函数,上报进度
typedef void (*protocol_report_progress_cb_handle)(uint8_t progress);
//回调处理函数,上报完成
typedef void (*protocol_report_complete_cb_handle)(uint32_t error_vale);
//回调处理函数,上报json
typedef void (*protocol_report_json_cb_handle)(char *json_str);

//回调处理函数,app上报传输语音文件状态
//status：
//VOICE_TO_BLE_STATE_IDLE         = 0, //空闲态
//VOICE_TO_BLE_STATE_START        = 1, //开始
//VOICE_TO_BLE_STATE_END          = 2, //停止状态 正常的停止的
//VOICE_TO_BLE_STATE_TIME_OUT     = 3, //超时
//VOICE_TO_BLE_STATE_DISCONNECT   = 4, //断线
typedef void (*protocol_report_voice_file_tran_status_cb_handle)(uint8_t status);

//回调处理函数,app执行传输的固件回复结果回调
//evt事件：VBUS_EVT_VOICE_TRAN_TO_BLE_START(7633)、VBUS_EVT_VOICE_TRAN_TO_BLE_ABNORMAL_END(7636)、VBUS_EVT_VOICE_TRAN_TO_BLE_END(7635)
//备注：使用voiceFileTranToBleSetParam方法 固件返回结果事件号对应VBUS_EVT_VOICE_TRAN_TO_BLE_START
//使用voiceFileTranToBleStop方法 固件返回结果事件号对应VBUS_EVT_VOICE_TRAN_TO_BLE_END
//VBUS_EVT_VOICE_TRAN_TO_BLE_ABNORMAL_END事件对应的是传输过程中,固件回应包携带的错误码上报
typedef void (*protocol_report_voice_file_tran_send_operate_reply_cb_handle)(int evt, uint8_t error_code);

//回调处理函数,ble上报传输语音文件状态
//status：
//VOICE_STATE_IDLE             = 0, //空闲态
//VOICE_STATE_START            = 1, //开始
//VOICE_STATE_END              = 2, //停止状态 正常的停止的
//VOICE_STATE_TIME_OUT         = 3, //超时
//VOICE_STATE_DISCONNECT       = 4, //断线
//VOICE_STATE_LOG              = 5, //登录状态
//VOICE_STATE_APP_START        = 6, //开始
//VOICE_APP_START_FAILED       = 7, //app发起开始失败
//VOICE_STATE_APP_END          = 8, //停止状态
//VOICE_APP_STOP_FAILED        = 9, //app发起结束失败
//VOICE_APP_END_RETURN_BACK    = 10,//ALEXA 按钮退出到主界面
//VOICE_BLE_CHANGE_ALEXA_ALARM = 11,//固件修改alexa设置的闹钟，需要重新获取alexa的闹钟数据
typedef void (*protocol_report_opus_voice_file_tran_status_cb_handle)(uint8_t status);

//回调处理函数,ble上报传输语音文件丢包率
//size_lost_package:丢包数 size_all_package:总包数
typedef void (*protocol_report_opus_voice_file_tran_lost_data_cb_handle)(uint32_t size_lost_package, uint32_t size_all_package);

//回调处理函数,opus数据上报
//data:pcm编码数据 data_len:数据大小
typedef void (*protocol_report_opus_voice_file_tran_data_cb_handle)(char * data, int data_len);

#ifdef __cplusplus
extern "C" {
#endif
// ------------------------------ 基础事件发送/接收 ------------------------------
/**
 * @brief:调用事件号发送内容给固件
 * @param array Json字符串, 编码可以选择utf8
 * @param len Json数据长度
 * @param evt_type 事件号
 * @param evt_base 事件方向,当jsonData是{}有效
 * {
 *  VBUS_EVT_BASE_SET = 0x2000,        //内部使用
 *	VBUS_EVT_BASE_GET = 0x2100,
 *	VBUS_EVT_BASE_BLE_REPLY = 0x2200,  //内部使用
 *	VBUS_EVT_BASE_NOTICE_APP = 0x2300, //通知
 *	VBUS_EVT_BASE_APP_SET = 0x2400,	   //设置
 *	VBUS_EVT_BASE_APP_GET = 0x2500,	   //获取
 *	VBUS_EVT_BASE_REQUEST = 0x2600	   //C库请求
 * }
 * @return:SUCCESS,成功
 */
extern int WriteJsonData(const char *array, int len, int evt_type, int evt_base);

/**
 * @brief:直接下发原始数据给固件
 * @param data 协议原始数据
 * @param length Json数据长度
 */
extern int WriteRawData(const uint8_t *data,uint16_t length);

/**
 * @brief:app接收到数据,通过这个函数转发到c库（用于转发收到后的命令）
 * @param rec_data 蓝牙接收到的二进制数据
 * @param len 数据长度
 * @param type 数据类型 0:ble 1:SPP
 * @return int SUCCESS(0) 成功
*/
extern int ReceiveDatafromBle(const char *rec_data,int len,uint8_t type);

/**
 * @brief: 蓝牙数据发送完成
 * @return:
 *   SUCCESS(0) : 成功
 */
extern int tranDataSendComplete(void);

/**
 * @brief:队列清除
 * @return:SUCCESS(0)成功
 * */
extern int ProtocolQueueClean(void);

/**
 * @brief:获取Clib版本信息
 * @param release_string clib版本号 三位表示release版本 四位表是develop版本
 * @return:SUCCESS(0)成功 ERROR_NULL(14)失败
 * */
extern int getClibVersion(char *release_string);

// ------------------------------ 初始化/设置获取基础事件 ------------------------------

/**
 * @brief 响应原始数据回调
 * @param func 蓝牙响应原始数据函数
 */
extern void responseRawData(protocol_data_response_handle func);

/**
 * @brief 初始化c库
 * @param func 蓝牙发送函数
 * @return int SUCCESS(0) 成功
 */
extern int callBackEnable(protocol_data_send_handle func);

/**
 * @brief 启用log
 * @param isPrintConsole 是否打印控制台 {0:不打开 1:打开}
 * @param isWriteFile 是否写文件 {0:不写文件 1:写文件}
 * @param filePath 文件路径,注意最路径后面要有一个斜杠
 * @return SUCCESS(0) 成功
 */
extern int EnableLog(bool isPrintConsole,bool isWriteFile,char* filePath);

/**
 * @brief 设置log保存天数
 * @param saveDay 保存日志天数 最少两天
 * @return SUCCESS(0) 成功
 */
extern int SetSaveLogDay(int saveDay);

/**
 * @brief:设置当前绑定状态
 * @param mode 模式
 * {
 *    PROTOCOL_MODE_UNBIND = 0, //没有绑定
 *    PROTOCOL_MODE_BIND   = 1, //已经绑定
 *    PROTOCOL_MODE_OTA    = 2  //升级模式
 * }
 * @return SUCCESS(0) 成功
 */
extern int SetMode(int mode);

/**
 * @brief:获取当前绑定状态
 * @return:
 * {
 *    PROTOCOL_MODE_UNBIND = 0, //没有绑定
 *    PROTOCOL_MODE_BIND   = 1, //已经绑定
 *    PROTOCOL_MODE_OTA    = 2  //升级模式
 * }
 */
extern int GetMode(void);

/**
 * @brief 设置持久化路径, 用于保存数据(分段同步), 初始化时调用即可，无顺序要求，最后不要加斜杠 /
 * @param filePath 持久化目录路径
 * @return SUCCESS(0) 成功
 */
extern int setFilePath(char *filePath);

/**
 * @brief 设置持久化路径, 用于保存功能表数据, 初始化时调用即可，无顺序要求，最后不要加斜杠 /
 * @param filePath 持久化目录路径
 * @return SUCCESS(0) 成功
 */
extern int setFunctionTableFilePath(char *filePath);

/**
 * @brief:设置运行环境 release / debug
 * @param mode 0:debug 1:relese
 * @return:
 *   SUCCESS(0) : 成功
 */
extern int setRunMode(int mode);

/**
 * @brief:设置流数据是否输出开关
 * @param iswrite 控制写入流数据开关公开 0不写入 1写入 默认不写入流数据
 * @return:
 *   SUCCESS(0) : 成功
 */
extern int setWriteStreamByte(bool iswrite);

 /**
  * @brief:启用或者关闭固件补丁(暂时不启用)
  * @param index 索引号
  * @param enable 使能
  * {enable    = 1, //使能
  *  disenable = 2  //不使能}
  * @return:
  *   SUCCESS(0) : 成功
  */
extern int SetPatch(int index,bool enable);

/**
 * @brief 获取同步配置状态
 * @return bool   0:空闲 1:忙碌, 正在同步
 */
extern bool GetSyncConfigStatus(void);

// ------------------------------ v2同步健康、同步GPS和多运动 ------------------------------
/**
 * @brief:开始v2同步健康数据
 * @return:
 *   SUCCESS(0) : 成功
 */
extern int StartSyncV2HealthData(void);

/**
 * @brief:停止v2同步健康数据
 * @return:
 *   SUCCESS(0) : 成功
 */
extern int StopSyncV2HealthData(void);

/**
 * @brief:设置v2同步健康数据偏移
 * @param type 数据类型
 * {
 *    type = 0,运动数据
 *    type = 1,睡眠数据,不支持
 *    type = 2,心率数据
 * }
 * @param value 偏移数值
 * @return:
 *   SUCCESS(0) : 成功
 */
extern int SetSyncV2HealthOffset(int type,int value);

/**
 * @brief:开始同步v2运动数据
 * @return:
 *   SUCCESS(0) : 成功
 */
extern int startSyncV2ActivityData(void);

/**
 * @brief:停止同步v2运动数据
 * @return:
 *   SUCCESS(0) : 成功
 */
extern int stopSyncV2ActivityData(void);

/**
 * @brief:获取v2同步运动状态
 * @return: 返回同步状态
 * {false:未开启同步 true:已开启同步}
 */
extern bool getSyncV2ActivityDataStatus(void);

/**
 * @brief 开始同步v2GPS数据
 * @return SUCCESS(0) 成功
 */
extern int startSyncV2GpsData(void);

/**
 * @brief 停止同步GPS数据
 * @return SUCCESS(0) : 成功
 */
extern int stopSyncV2GpsData(void);

/**
 * @brief 获取v2同步GPS状态
 * @return 返回同步状态
 * {false:未开启同步 true:已开启同步}
 */
extern bool getSyncV2GpsDataStatus(void);

// ------------------------------ v3同步健康 ------------------------------
/**
 * @brief 解绑清除v3缓存健康数据
 * @return SUCCESS(0) 成功
 */
extern int unBindClearV3HealthData(void);

/**
 * @brief 开始同步v3健康数据
 * @return SUCCESS(0)成功
 * */
extern int startSyncV3HealthData(void);

/**
 * @brief app每半个小时主动更新 开始同步V3数据，睡眠数据不返回
 * @return SUCCESS(0) 成功
 * */
extern int startAutomaticSyncV3HealthData(void);

/**
 * @brief 停止同步v3健康数据
 * @return SUCCESS(0)成功
 * */
extern int stopSyncV3HealthData(void);

/**
 * @brief:手动停止快速同步配置
 * @return int SUCCESS(0)成功
 * */
extern int ProtocolSyncConfigStop(void);

// ------------------------------ 数据传输接口 ------------------------------
/**
 * @brief 开始传输数据
 * @return
 *   SUCCESS(0) : 成功
 */
extern int tranDataStart(void);

/**
 * @brief 开始传输数据, 且设置续传次数
 * @param times 续传次数
 * @return
 *   SUCCESS(0) : 成功
 */
extern int tranDataStartWithTryTime(int times);

/**
 * @brief:停止传输数据(无效,使用tranDataManualStop)
 * @return
 *   SUCCESS:成功
 */
extern int tranDataStop(void);

/**
 * @brief:手动停止传输数据
 * @return:
 *   SUCCESS:成功
 */
extern int tranDataManualStop(void);

/**
 * @brief:获取传输状态
 * @return:
 * {true(1) : 传输已开启
 * false(0) : 传输未开启}
 */
extern bool tranDataisStart(void);

/**
 * @brief 配置文件传输数据 version_date:1.0.1.1后取消该方法，使用tranDataSetBuffByPath配置文件
 * @param data 文件的字节流
 * @param dataType 文件类型
 * @param dataLen 字节流大小
 * {0 无效
 * 1 分区表
 * 2 apgs文件
 * 3 gps固件}
 * @param fileName 文件名+后缀, 注:文件名可以是空但是后缀不能为空(排除掉某些固定名称的文件例如:EPO.DAT)
 * @param compressionType 压缩类型
 * {0 为不适用压缩
 * 1 为zlib压缩
 * 2 为fastlz压缩}
 * @param  oriSize 压缩前文件大小
 * {目前对表盘文件有效，表示没有压缩前的文件大小，即iwf文件大小}
 * 如果需要传递文件名 ，dataType需要使用0xff,如果是传递agps，两个分部填""和0就可以了
 * @return SUCCESS(0) 成功
 */
extern int tranDataSetBuff(char *data,int dataType,int dataLen,char *fileName,int compressionType,int oriSize);

/**
 * @brief 配置文件传输数据，输入文件路径由C库读取文件数据
 * @param dataType 文件类型
 * {0 无效
 * 1 分区表
 * 2 apgs文件
 * 3 gps固件}
 * @param srcPath 素材文件路径   最大4096字节
 * @param dstName 目标文件名+后缀, 注:文件名可以是空但是后缀不能为空(排除掉某些固定名称的文件例如:EPO.DAT) 最大256字节
 * @param compressionType 压缩类型
 * {0 为不适用压缩
 * 1 为zlib压缩
 * 2 为fastlz压缩}
 * @param  oriSize 压缩前文件大小
 * {目前对表盘文件有效，表示没有压缩前的文件大小，即iwf文件大小}
 * 如果需要传递文件名 ，dataType需要使用0xff,如果是传递agps，两个分部填""和0就可以了
 * @return SUCCESS(0) 成功
 */
extern int tranDataSetBuffByPath(int dataType,char *srcPath,char *dstName,int compressionType,int oriSize);

/**
 * @brief 设置PRN,接收num包通知一次, 用来调节速度和可靠性之间的平衡
 * @param num  app每发num包, 固件回应一次
 * @return:
 *   SUCCESS(0) : 成功
 */
extern int tranDataSetPRN(int num);

// ------------------------------ SPP文件传输功能 ------------------------------
/**
 * @brief 开始传输数据
 * @return
 *   SUCCESS(0) : 成功
 */
extern int sppTranDataStart(void);

/**
 * @brief 开始传输数据, 且设置续传次数
 * @param times 续传次数
 * @return
 *   SUCCESS(0) : 成功
 */
extern int sppTranDataStartWithTryTime(int times);

/**
 * @brief:停止spp传输数据(无效,使用sppTranDataManualStop)
 * @return
 *   SUCCESS:成功
 */
extern int sppTranDataStop(void);

/**
 * @brief:手动停止spp传输数据
 * @return:
 *   SUCCESS:成功
 */
extern int sppTranDataManualStop(void);

/**
 * @brief:获取传输状态
 * @return:
 * {true(1) : 传输已开启
 * false(0) : 传输未开启}
 */
extern bool sppTranDataisStart(void);

/**
 * @brief SPP设置文件传输Buff version_date:1.0.1.1后取消该方法，使用sppTranDataSetBuffByPath配置文件
 * @param data 文件的字节流
 * @param dataType 文件类型
 * @param dataLen 字节流大小
 * {0 无效
 * 1 分区表
 * 2 apgs文件
 * 3 gps固件}
 * @param fileName 文件名+后缀, 注:文件名可以是空但是后缀不能为空(排除掉某些固定名称的文件例如:EPO.DAT)
 * @param compressionType 压缩类型
 * {0 为不适用压缩
 * 1 为zlib压缩
 * 2 为fastlz压缩}
 * @param  oriSize 压缩前文件大小
 * {目前对表盘文件有效，表示没有压缩前的文件大小，即iwf文件大小}
 * 如果需要传递文件名 ，dataType需要使用0xff,如果是传递agps，两个分部填""和0就可以了
 * @return SUCCESS(0) 成功
 */
extern int sppTranDataSetBuff(char *data,int dataType,int dataLen,char *fileName,int compressionType,int oriSize);

/**
 * @brief SPP设置文件传输Buff，输入文件路径由C库读取文件数据
 * @param dataType 文件类型
 * {0 无效
 * 1 分区表
 * 2 apgs文件
 * 3 gps固件}
 * @param srcPath 素材文件路径   最大4096字节
 * @param dstName 目标文件名+后缀, 注:文件名可以是空但是后缀不能为空(排除掉某些固定名称的文件例如:EPO.DAT) 最大256字节
 * @param compressionType 压缩类型
 * {0 为不适用压缩
 * 1 为zlib压缩
 * 2 为fastlz压缩}
 * @param  oriSize 压缩前文件大小
 * {目前对表盘文件有效，表示没有压缩前的文件大小，即iwf文件大小}
 * 如果需要传递文件名 ，dataType需要使用0xff,如果是传递agps，两个分部填""和0就可以了
 * @return SUCCESS(0) 成功
 */
extern int sppTranDataSetBuffByPath(int dataType,char *srcPath,char *dstName,int compressionType,int oriSize);

/**
 * @brief 设置PRN,接收num包通知一次, 用来调节速度和可靠性之间的平衡
 * @param num  app每发num包, 固件回应一次
 * @return:
 *   SUCCESS(0) : 成功
 */
extern int sppTranDataSetPRN(int num);

//--------------------------- alexa语音文本传输 --------------------------------
/**
 * @brief: app设置语音文件传输配置
 * @param prn app控制ble接收几个包回复一次数据
 * @param voiceType 传输类型  0:无效 1:sbc 2:opus 3:mp3
 * @param fileLen 语音文件大小
 * @return:
 *   SUCCESS(0) : 成功
 */
extern int voiceFileTranToBleSetParam(int prn, int voiceType, int fileLen);

/**
 * @brief: app开始传输语音文件
 * @param filename 需要传输的语音文件完整路径 包括文件名
 * @return:
 *   SUCCESS(0) : 成功
 */
extern int voiceFileTranToBleStart(char *filename);

/**
 * @brief: app停止发送语音数据
 * @return:
 *   SUCCESS(0) : 成功
 */
extern int voiceFileTranToBleStop(void);

/**
 * @brief: app传输语音文件状态回调注册
 * @return:
 *   SUCCESS(0) : 成功
 */
extern int voiceFileTranToBleStateCbReg(protocol_report_voice_file_tran_status_cb_handle func);

/**
 * @brief: app传输语音文件操作固件回复结果回调注册
 * @return:
 *   SUCCESS(0) : 成功
 */
extern int voiceFileTranToBleSendOperateReplyCbReg(protocol_report_voice_file_tran_send_operate_reply_cb_handle func);

/**
 * @brief: 通知ble停止传输opus数据(语音数据)
 * @return:
 *   SUCCESS(0) : 成功
 */
extern int stopReceiveVoiceDataFromBle(void);

/**
 * @brief: 上报接收到的opus语音文件状态回调注册
 * @return:
 *   SUCCESS(0) : 成功
 */
extern int reportVoiceDataFromBleOpusStateCbReg(protocol_report_opus_voice_file_tran_status_cb_handle func);

/**
 * @brief: 上报接收的opus语音文件丢包率回调注册
 * @return:
 *   SUCCESS(0) : 成功
 */
extern int reportVoiceDataFromBleLostDataCbReg(protocol_report_opus_voice_file_tran_lost_data_cb_handle func);

/**
 * @brief: 上报接收opus语音文件每段pcm编码数据回调注册
 * @return:
 *   SUCCESS(0) : 成功
 */
extern int reportVoiceDataFromBleEachPcmDataCbReg(protocol_report_opus_voice_file_tran_data_cb_handle func);

/**
 * @brief:上报接收的opus上报语音文件数据回调注册
 * @return:
 *   SUCCESS(0) : 成功
 */
extern int reportVoiceDataFromBleDataCbReg(protocol_report_opus_voice_file_tran_data_cb_handle func);

/**
 * @brief:上报接收的opus上报每帧的语音文件数据回调注册
 * @return:
 *   SUCCESS(0) : 成功
 */
extern int reportVoiceDataFromBleEachEncodeDataCbReg(protocol_report_opus_voice_file_tran_data_cb_handle func);


// ------------------------------ GPS轨迹工具 ------------------------------
/**
 * @brief: gsp运动后优化轨迹,根据运动类型初始化速度阈值，若输入其他运动类型，会导致无运动轨迹
 * @param motion_type_in
 * 运动类型:
 * {
 * 1、户外走路 = 52, 走路 = 1, 徒步 = 4, 运动类型设为0
 * 2、户外跑步 = 48, 跑步 = 2, 运动类型设为1
 * 3、户外骑行 = 50, 骑行 = 3, 运动型性设为2
 *}
 * @return
 *  初始化参数,满足运动类型输出结果为1，否则为0
 */
extern int initType(int motion_type_in);

/**
 * @brief 初始化算法内部参数
 */
extern void initParameter(void);

/**
 * @brief gps数据实时处理入口,需要对输出的数据进行判断，若纬度为-180则为错误值，不应该输出 ，每次只会传进来一个坐标
 * @param data json字符串
 * @param len 字符串长度 不超过2MByte
 * json字符串内容:
 * android:
 * { lon,经度,数据类型double
 *   lat,纬度,数据类型double
 *   timestamp,时间戳,数据类型int
 *   accuracy,定位精度,数据类型double
 *   gpsaccuracystatus,定位等级，0 = 定位未知, 1 = 定位好, 2 = 定位差,数据类型int}
 *   ios:
 * { lon,经度,数据类型double
 *   lat,纬度,数据类型double
 *   timestamp,时间戳,数据类型int
 *   hor_accuracy,水平精度,数据类型double
 *   ver_accuracy,垂直精度,数据类型double
 * }
 * @return json字符串 内容与上面json字符串内容一致
 */
extern char *appGpsAlgProcessRealtime(char *data,int len);

/**
 * @brief 平滑数据，结果保存在数组lat和lon中
 * @param data json字符串
 * @param len 字符串长度
 * json字符串内容:
 * {lat,纬度数组,长度为len,数据类型double
 *  lon,经度数组,长度为len,数据类型double
 *  len,数据长度}
 * @return json字符串 内容与上面json字符串内容一致
 */
extern char *smoothData(char *data,int len);

// ------------------------------ 制作文件 ------------------------------
/**
 * @brief 图片压缩
 * @param fileName 输入图片路径(包含文件名及后缀)
 * @param endName 输出图片后缀名(.sport)
 * @param format 图片格式
 * @return:
 *   SUCCESS(0) : 成功
 *
 * format图片格式详情
 * {
 *  #define FONT_FORMAT_ALPHA_MASK		(1 << 7)
 *   #define FONT_FORMAT_SWAP_COLOR		(1 << 6)
 *
 *  #define FONT_FORMAT_NONE		0	//无效
 *  #define FONT_FORMAT_RGB111		1
 *  #define FONT_FORMAT_BGR111		(FONT_FORMAT_RGB111 | FONT_FORMAT_SWAP_COLOR)
 *  #define FONT_FORMAT_ARGB111		(FONT_FORMAT_RGB111 | FONT_FORMAT_ALPHA_MASK)
 *  #define FONT_FORMAT_ABGR111		(FONT_FORMAT_BGR111 | FONT_FORMAT_ALPHA_MASK)
 *
 *  #define FONT_FORMAT_RGB222		2
 *  #define FONT_FORMAT_BGR222		(FONT_FORMAT_RGB222 | FONT_FORMAT_SWAP_COLOR)
 *  #define FONT_FORMAT_ARGB222		(FONT_FORMAT_RGB222 | FONT_FORMAT_ALPHA_MASK)
 *  #define FONT_FORMAT_ABGR222		(FONT_FORMAT_BGR222 | FONT_FORMAT_ALPHA_MASK)
 *
 *  #define FONT_FORMAT_RGB565		5
 *  #define FONT_FORMAT_BGR565		(FONT_FORMAT_RGB565 | FONT_FORMAT_SWAP_COLOR)
 *  #define FONT_FORMAT_ARGB565		(FONT_FORMAT_RGB565 | FONT_FORMAT_ALPHA_MASK)
 *  #define FONT_FORMAT_ABGR565		(FONT_FORMAT_BGR565 | FONT_FORMAT_ALPHA_MASK)
 *
 *  #define FONT_FORMAT_RGB888		8
 *  #define FONT_FORAMT_BGR888		(FONT_FORMAT_RGB888 | FONT_FORMAT_SWAP_COLOR)
 *  #define FONT_FORMAT_ARGB888		(FONT_FORMAT_RGB888 | FONT_FORMAT_ALPHA_MASK)
 *  #define FONT_FORAMT_ABGR888		(FONT_FORAMT_BGR888 | FONT_FORMAT_ALPHA_MASK)
 *
 *  #define FONT_FORMAT_MONO1		100 //单色 1bit
 *  #define FONT_FORMAT_MONO2		101 //单色 2bit
 *  #define FONT_FORMAT_MONO4		102 //单色 4bit
 *  #define FONT_FORMAT_MONO8		103 //单色 8bit
 *  #define FONT_FORMAT_AUTO		0xff//自动模式,如果是8bit图片,采用4bit取模,或者采用rgb,或者rgba取模
 * }
 *
 */
extern int makeFileCompression(char *fileName, char *endName, int format);

/**
 * @brief 制作压缩多张运动图片
 * @param fileName 输入图片路径(包含文件名及后缀)
 * @param endName 输出图片后缀名(.sports)
 * @param format 图片格式
 * @param pic_num 图片个数
 * @return:
 *   SUCCESS(0) : 成功
 *
 * format图片格式详情
 * {
 *  #define FONT_FORMAT_ALPHA_MASK		(1 << 7)
 *   #define FONT_FORMAT_SWAP_COLOR		(1 << 6)
 *
 *  #define FONT_FORMAT_NONE		0	//无效
 *  #define FONT_FORMAT_RGB111		1
 *  #define FONT_FORMAT_BGR111		(FONT_FORMAT_RGB111 | FONT_FORMAT_SWAP_COLOR)
 *  #define FONT_FORMAT_ARGB111		(FONT_FORMAT_RGB111 | FONT_FORMAT_ALPHA_MASK)
 *  #define FONT_FORMAT_ABGR111		(FONT_FORMAT_BGR111 | FONT_FORMAT_ALPHA_MASK)
 *
 *  #define FONT_FORMAT_RGB222		2
 *  #define FONT_FORMAT_BGR222		(FONT_FORMAT_RGB222 | FONT_FORMAT_SWAP_COLOR)
 *  #define FONT_FORMAT_ARGB222		(FONT_FORMAT_RGB222 | FONT_FORMAT_ALPHA_MASK)
 *  #define FONT_FORMAT_ABGR222		(FONT_FORMAT_BGR222 | FONT_FORMAT_ALPHA_MASK)
 *
 *  #define FONT_FORMAT_RGB565		5
 *  #define FONT_FORMAT_BGR565		(FONT_FORMAT_RGB565 | FONT_FORMAT_SWAP_COLOR)
 *  #define FONT_FORMAT_ARGB565		(FONT_FORMAT_RGB565 | FONT_FORMAT_ALPHA_MASK)
 *  #define FONT_FORMAT_ABGR565		(FONT_FORMAT_BGR565 | FONT_FORMAT_ALPHA_MASK)
 *
 *  #define FONT_FORMAT_RGB888		8
 *  #define FONT_FORAMT_BGR888		(FONT_FORMAT_RGB888 | FONT_FORMAT_SWAP_COLOR)
 *  #define FONT_FORMAT_ARGB888		(FONT_FORMAT_RGB888 | FONT_FORMAT_ALPHA_MASK)
 *  #define FONT_FORAMT_ABGR888		(FONT_FORAMT_BGR888 | FONT_FORMAT_ALPHA_MASK)
 *
 *  #define FONT_FORMAT_MONO1		100 //单色 1bit
 *  #define FONT_FORMAT_MONO2		101 //单色 2bit
 *  #define FONT_FORMAT_MONO4		102 //单色 4bit
 *  #define FONT_FORMAT_MONO8		103 //单色 8bit
 *  #define FONT_FORMAT_AUTO		0xff//自动模式,如果是8bit图片,采用4bit取模,或者采用rgb,或者rgba取模
 * }
 *
 */
extern int makeSportFileCompression(char *fileName, char *endName, int format, int pic_num);

/**
 * @brief 制作(IWF)文件 根据表盘包获取到IWF文件且返回生成的iwf文件大小
 * @param file_path 素材路径
 * @param save_file_name 文件名
 * @param format 取模图片的格式
 * @return:{1失败,IWF文件大小 成功}
*/
extern int mkWatchDialFile(char *file_path,char *save_file_name,int format);

/**
 * @brief:制作表盘压缩文件(iwf.lz) 压缩文件会自动添加文件名.lz后缀
 * @param file_path 素材路径
 * @param save_file_name 文件名
 * @param format 取模图片的格式
 * {
 *  #define FONT_FORMAT_ALPHA_MASK		(1 << 7)
 *   #define FONT_FORMAT_SWAP_COLOR		(1 << 6)
 *
 *  #define FONT_FORMAT_NONE		0	//无效
 *  #define FONT_FORMAT_RGB111		1
 *  #define FONT_FORMAT_BGR111		(FONT_FORMAT_RGB111 | FONT_FORMAT_SWAP_COLOR)
 *  #define FONT_FORMAT_ARGB111		(FONT_FORMAT_RGB111 | FONT_FORMAT_ALPHA_MASK)
 *  #define FONT_FORMAT_ABGR111		(FONT_FORMAT_BGR111 | FONT_FORMAT_ALPHA_MASK)
 *
 *  #define FONT_FORMAT_RGB222		2
 *  #define FONT_FORMAT_BGR222		(FONT_FORMAT_RGB222 | FONT_FORMAT_SWAP_COLOR)
 *  #define FONT_FORMAT_ARGB222		(FONT_FORMAT_RGB222 | FONT_FORMAT_ALPHA_MASK)
 *  #define FONT_FORMAT_ABGR222		(FONT_FORMAT_BGR222 | FONT_FORMAT_ALPHA_MASK)
 *
 *  #define FONT_FORMAT_RGB565		5
 *  #define FONT_FORMAT_BGR565		(FONT_FORMAT_RGB565 | FONT_FORMAT_SWAP_COLOR)
 *  #define FONT_FORMAT_ARGB565		(FONT_FORMAT_RGB565 | FONT_FORMAT_ALPHA_MASK)
 *  #define FONT_FORMAT_ABGR565		(FONT_FORMAT_BGR565 | FONT_FORMAT_ALPHA_MASK)
 *
 *  #define FONT_FORMAT_RGB888		8
 *  #define FONT_FORAMT_BGR888		(FONT_FORMAT_RGB888 | FONT_FORMAT_SWAP_COLOR)
 *  #define FONT_FORMAT_ARGB888		(FONT_FORMAT_RGB888 | FONT_FORMAT_ALPHA_MASK)
 *  #define FONT_FORAMT_ABGR888		(FONT_FORAMT_BGR888 | FONT_FORMAT_ALPHA_MASK)
 *
 *  #define FONT_FORMAT_MONO1		100 //单色 1bit
 *  #define FONT_FORMAT_MONO2		101 //单色 2bit
 *  #define FONT_FORMAT_MONO4		102 //单色 4bit
 *  #define FONT_FORMAT_MONO8		103 //单色 8bit
 *  #define FONT_FORMAT_AUTO		0xff//自动模式,如果是8bit图片,采用4bit取模,或者采用rgb,或者rgba取模
 *  }
 * @param block_size 压缩块大小{1024,4096}
 * @return:SUCCESS(0)成功,ERROR_NULL(14)文件路径打开失败
 * */
extern int mkWatchDialFileCompression(char *file_path,char *save_file_name,uint8_t format,uint16_t block_size);

/**
 * @brief 制作(EPO.DAT)文件
 * @param file_path 素材路径
 * @param save_file_name 输出文件名,一般为EPO.DAT
 * @return SUCCESS(0),成功
 * */
extern int mkEpoFile(char *file_path,char *save_file_name);

/**
 * @brief 图片转换格式 png->bmp
 * @param inname 用于转换的png路径(包含文件名及后缀)
 * @param outname 转换完的bmp路径(包含文件名及后缀)
 * @param format 转换成bmp的文件格式
 * {8:RGB888, 5:ARGB555}
 * @return:
 *   SUCCESS(0) : 成功
 */
extern int Png2Bmp(char *inname,char *outname,int format);

/**
 * @brief PNG图片32/24位转16位
 * @param inname 用于转换的png路径(包含文件名及后缀)
 * @param outname 转换完的png路径(包含文件名及后缀)
 * @return:
 *   SUCCESS(0) : 成功
 */
extern int PngConvert16bit(char *inname,char *outname);

/**
 * @brief 制作壁纸图片文件
 * @param file_path 素材路径
 * @param save_file_path 输出文件名
 * @param format 预留
 * @return:
 *   SUCCESS(0) : 成功
 */
extern int mkPhotoFile(const char * file_path,const char * save_file_path,int format);

/**
 * @brief 制作联系人文件 v2_conta.ml
 * @param jsondata json数据
 * {
 *  当前文件保存的年 ：year , month , day , hour , minute , second
 *  联系人详情个数     ：contact_item_num
 *  联系人详情            ：items
 *  联系人详情姓名     ：name
 *  纤细人详情号码     ：phone
 * }
 * @return 成功：生成的联系人文件路径(持久化路径目录+v2_conta.ml) 失败：NULL / 字符串 file_is_null
 * */
extern char *mkConnactFile(const char * jsondata);

/**
 * @brief 制作思澈表盘文件,会在输入路径下生成(.watch)表盘文件
 * @param file_path 素材文件路径
 * @return 0成功 非0失败 -1: 没有控件 -2: json文件加载失败
 */
extern int mkSifliDialFile(const char *file_path);

/**
 * @brief 获取思澈表盘(.watch)文件占用空间大小，计算规则：
 * nor方案：对表盘所有文件以4096向上取整  -98平台对应的项目，IDW27,205G Pro,IDW28,IDS05，DR03等
 * nand方案：对表盘所有文件以2048向上取整 -99平台对应的项目，GTX12,GTX13,GTR1,TIT21
 * @param file_path .watch文件路径，包含文件名
 * @param platform 平台类型，目前有98(nor)，99(nand)平台
 * @return size 文件占用磁盘的实际大小，-1:失败，文件路径访问失败，-2:失败，申请内存失败，-3:失败，读取文件失败，-4:失败，输入平台类型不支持
 * */
extern int getSifliDialSize(const char *file_path,int platform);

/**
 * @brief 压缩png图片质量
 * @param inputFilePath   输入文件路径
 * @param outputFilePath 输出文件路径
 * @return int 成功 SUCCESS
 * */
extern int compressToPNG(const char *inputFilePath,const char *outputFilePath);

/**
 * @brief jpg转png
 * @param inputFilePath   输入文件路径
 * @param outputFilePath 输出文件路径
 * @return int 0 成功, 1 已经是png，其它失败
 * */
extern int jpgToPNG(const char *inputFilePath,const char *outputFilePath);

/**
 * @brief mp3音频文件采样率转换  将采样率转化为44.1khz
 * @param in_path   音频输入文件路径 目录及文件名、文件名后缀
 * @param out_path 音频输出文件路径 目录及文件名、文件名后缀
 * @param in_size   音频输入文件大小
 * @return:
 *   SUCCESS(0) : 成功
 */
extern int AudioSamplingRateConversion(const char * in_path,const char * out_path,int in_size);

/**
 * @brief pcm音频文件转换指定采样率
 * @param confi_path  采样率转换配置文件的路径包括文件名
 * @param output_dir_path 采样率转换后的目标文件夹路径
 * @return:
 *   SUCCESS(0) : 成功
 */
extern int PcmFileSamplingRateConversion(const char * confi_path,const char * output_dir_path);

/**
 * @brief 音频文件格式转换 mp3转pcm
 * @param in_path   音频输入文件路径 目录及文件名、文件名后缀(.mp3)
 * @param out_path 音频输出文件路径 目录及文件名、文件名后缀(.pcm)
 * @return:
 *   SUCCESS(0) : 成功
 */
extern int AudioFormatConversionMp32Pcm(const char * in_path,const char * out_path);

/**
 * @brief 音频文件格式转换 mp3转pcm进度注册函数
 * @return:
 *   SUCCESS(0) : 成功
 */
extern int AudioFormatConversionMp32PcmProgressReg(protocol_report_progress_cb_handle func);

/**
 * @brief 音频文件格式转换 mp3转pcm完成注册函数
 * @return:
 *   SUCCESS(0) : 成功
 */
extern int AudioFormatConversionMp32PcmCompleteReg(protocol_report_complete_cb_handle func);

/**
 * @brief 音频采样率转换完成回调注册
 * @param func 函数指针
 * @return SUCCESS(0)成功
 * */
extern int AudioSRConversionCompletCallbackReg(mp3tomp3_complete_cb_handle func);

/**
 * @brief 音频采样率转换进度回调注册
 * @param func 函数指针
 * @return SUCCESS(0)成功
 * */
extern int AudioSRConversionProgressCallbackReg(protocol_report_progress_cb_handle func);

/**
 * @brief 获取mp3音频采样率
 * @param in_path 输入带路径MP3文件名
 * @return int 输入MP3文件的采样率
 * */
extern int AduioGetMp3SamplingRate(const char * in_path);

// ------------------------------ 工具接口 ------------------------------
/**
 * @brief 制作功能表信息文件
 * @param path 输出文件路径(包含文件名及后缀)
 * @return:
 *   SUCCESS(0) : 成功
 */
extern int funcTableOutputOnJsonFile(char *path);

/**
 * @brief 模拟器回应数据解释，传入key`replyinfo`，输出对应的字节数据
 * @param json_data 素材JSON数据，对应事件号的`replyinfo`
 * @param json_data_len 素材JSON数据长度
 * @param evt 事件号
 * @return JSON字符串，转换后的字节数据用JSON格式返回
 */
extern char *simulatorRespondInfoExec(const char *json_data,int json_data_len,int evt);

/**
 * @brief 模拟器收到APP的字节数据，解释成对应的json内容输出
 * @param data 素材字节数据
 * @param data_len 字节数据长度
 * @return 输出json数据字符串
 */
extern char *simulatorReceiveBinary2Json(const char *data,int data_len);

/**
 * @brief 计算长包指令的校验码
 * @param data 素材字节数据
 * @param data_len 字节数据长度
 * @return 输出2个字节的CRC校验码
 */
extern uint16_t getCrc16(const char *data,int data_len);

/**
 * @brief 获取是否支持断点续传的功能表
 * @return 0不支持 1支持
 * */
extern int getIsSupportTranContinue(void);

// ------------------------------ v2闹钟同步 ------------------------------

///**
// * @brief 清除v2闹钟缓存
// * @return SUCCESS(0) 成功
// * */
//extern int ProtooclV2CleanAlarm(void);
//
///**
// * @brief 开启同步v2闹钟,50ms下发一个闹钟直至发完为止
// * @return {SUCCESS(0)成功, ERROR_INVALID_STATE(8)失败}
// * */
//extern int ProtocolV2SetAlarmESyncStart(void);
//
///**
// * @brief暂停同步v2闹钟
// * @return SUCCESS(0)成功
// * */
//extern int ProtocolV2SetAlarmSyncStop(void);

// ------------------------------ v2消息/来电提醒 ------------------------------
/**
 * @brief v2发送来电提醒以及来电电话号码和来电联系人(部分设备实现)
 * @param contactText 联系人名称
 * @param phoneNumber 号码
 * @return SUCCESS(0) 成功
 * */
extern int ProtocolV2SetCallEvt(char *contactText, char *phoneNumber);

/**
 * @brief v2发送信息提醒以及信息内容(部分设备实现)
 * @param type 信息类型
 * {
 * TYPE_SMS = 0x01
 * TYPE_EMAIL = 0x02
 * TYPE_WX = 0x03
 * TYPE_QQ = 0x04
 * TYPE_WEIBO = 0x05
 * TYPE_FACEBOOK = 0x06
 * TYPE_TWITTER = 0x07
 * TYPE_WHATSAPP = 0x08
 * TYPE_MESSENGER = 0x09
 * TYPE_INSTAGRAM = 0x0A
 * TYPE_LINKEDIN = 0x0B
 * TYPE_CALENDAR = 0x0C
 * TYPE_SKYPE = 0x0D
 * TYPE_ALARM = 0x0E
 * TYPE_VKONTAKTE = 0x10
 * TYPE_LINE = 0x11
 * TYPE_VIBER = 0x12
 * TYPE_KAKAO_TALK = 0x13
 * TYPE_GMAIL = 0x14
 * TYPE_OUTLOOK = 0x15
 * TYPE_SNAPCHAT = 0x16
 * TYPE_TELEGRAM = 0x17
 * TYPE_CHATWORK = 0x20
 * TYPE_SLACK = 0x21
 * TYPE_TUMBLR = 0x23
 * TYPE_YOUTUBE = 0x24
 * TYPE_PINTEREST_YAHOO = 0x25
 * TYPE_TIKTOK = 0x26
 * TYPE_REDBUS = 0X27
 * TYPE_DAILYHUNT= 0X28
 * TYPE_HOTSTAR = 0X29
 * TYPE_INSHORTS = 0X2A
 * TYPE_PAYTM = 0X2B
 * TYPE_AMAZON = 0X2C
 * TYPE_FLIPKART = 0X2D
 * TYPE_PRIME = 0X2E
 * TYPE_NETFLIX = 0X2F
 * TYPE_GPAY = 0X30
 * TYPE_PHONPE = 0X31
 * TYPE_SWIGGY = 0X32
 * TYPE_ZOMATO = 0X33
 * TYPE_MAKEMYTRIP = 0X34
 * TYPE_JIOTV = 0X35
 * TYPE_KEEP = 0X36
 * }
 * @param contactText 通知内容
 * @param phoneNumber 号码
 * @return:SUCCESS(0)成功
 * */
extern int ProtocolV2SetNoticeEvt(int type, char *contactText, char *phoneNumber, char *dataText);

/**
 * @brief v2发送来电提醒状态为来电已接, 告诉设备停止提醒用户(部分设备实现)
 * @return SUCCESS(0)成功
 * */
extern int ProtocolV2StopCallEvt(void);

/**
 * @brief v2发送来电提醒状态为来电已拒, 告诉设备停止提醒用户(部分设备实现)
 * @return SUCCESS(0)成功
 * */
extern int ProtocolV2MissedCallEvt(void);

/******************************** 日志接口 ********************************/

/**
 * @brief 获取flash日志开始
 * @param type 日志类型
 * {PROTOCOL_FLASH_LOG_TYPE_GENERAL   =  0,    //通用log
 * PROTOCOL_FLASH_LOG_TYPE_RESET             =  1,    //复位log
 * PROTOCOL_FLASH_LOG_TYPE_ALGORITHM   =   2,    //算法
 * PROTOCOL_FLASH_LOG_TYPE_HARDWARE    =   3,    //硬件
 * PROTOCOL_FLASH_LOG_TYPE_REBOOT         =   4,    //重启log}
 * @param file_name 文件路径 包括文件名及后缀
 * @return int SUCCESS(0)成功  ERROR_BUSY(17)日志正在获取
 * */
extern int ProtocolGetFlashLogStart(int type, const char *file_name);

/**
 * @brief 设置flash获取时间，单位秒，默认一分钟
 * @return int SUCCESS(0)成功
 * */
extern int ProtocolGetFlashLogSetTime(int time);

/**
 * @brief 获取flash日志停止
 * @return int SUCCESS(0)成功
 * */
extern int ProtocolGetFlashLogStop(void);

/**
 * @brief 获取电池日志信息
 * @return int SUCCESS(0)成功
 * */
extern int ProtocolGetBatteryLogInfo(void);

/**
 * @brief 获取过热日志信息
 * @return int SUCCESS(0)成功
 * */
extern int ProtocolGetHeatLogInfo(void);

/**
 * @brief:获取flashlog进度回调注册
 * @param func 函数指针
 * @return:SUCCESS(0)成功
 * */
extern uint32_t FlashLogTranProgressCallbackReg(protocol_report_progress_cb_handle func);

/**
 * @brief 获取flashlog完成回调注册
 * @param func 函数指针
 * @return SUCCESS(0)成功
 * */
extern uint32_t FlashLogTranCompletCallbackReg(protocol_flash_log_tran_complete_cb_handle func);

/**
 * @brief 获取电池日志完成回调注册
 * @param func 函数指针
 * @return SUCCESS(0)成功
 * */
extern uint32_t BatteryLogGetCompletCallbackReg(protocol_get_battery_log_info_complete_cb_handle func);

/**
 * @brief 获取过热日志完成回调注册
 * @param func 函数指针
 * @return SUCCESS(0)成功
 * */
extern uint32_t HeatLogGetCompletCallbackReg(protocol_get_heat_log_info_complete_cb_handle func);



/******************************** 注册函数接口 ********************************/
/**
 * @brief 解析完固件返回的二进制数据,打包成json数据回调给SDK
 * @return SUCCESS(0),成功
 * */
extern uint32_t JsonDataCallbackDataReg(protocol_json_cb_handle func);

/**
 * @brief 解析完固件返回的v3同步健康数据二进制数据,打包成json数据回调给SDK
 * @return SUCCESS(0),成功
 * */
extern uint32_t V3SyncHealthJsonDataCbReg(protocol_json_cb_handle func);

/**
 * @brief c库通知app事件回调注册
 * @return SUCCESS(0),成功
 * */
extern uint32_t ProtocolNoticeCallbackReg(protocol_notice_cb_handle func);

/**
 * @brief 文件传输完成事件回调注册
 * @param func 函数指针
 * @return SUCCESS(0)成功
 * */
extern uint32_t DataTranCompleteCallbackReg(data_tran_complete_cb_handle func);

/**
 * @brief 文件传输进度事件回调注册
 * @param func 函数指针
 * @return SUCCESS(0)成功
 * */
extern uint32_t DataTranProgressCallbackReg(data_tran_progress_cb_handle func);

/**
 * @brief:SPP文件传输完成事件回调注册
 * @param func 函数指针
 * @return:SUCCESS(0)成功
 * */
extern uint32_t SppDataTranCompleteCallbackReg(data_tran_complete_cb_handle func);

/**
 * @brief:SPP文件传输进度事件回调注册
 * @param func 函数指针
 * @return:SUCCESS(0)成功
 * */
extern uint32_t SppDataTranProgressCallbackReg(data_tran_progress_cb_handle func);

/**
 * @brief:设备传输文件到APP的传输完成事件回调注册
 * @param func 函数指针
 * @return:SUCCESS(0)成功
 * */
extern uint32_t Device2AppDataTranCompleteCallbackReg(protocol_report_complete_cb_handle func);

/**
 * @brief:设备传输文件到APP的传输进度事件回调注册
 * @param func 函数指针
 * @return:SUCCESS(0)成功
 * */
extern uint32_t Device2AppDataTranProgressCallbackReg(protocol_report_progress_cb_handle func);

/**
 * @brief:APP回复设备传输文件到APP的请求
 * @param error_code 0回复握手成功 非0失败，拒绝传输
 * @return:SUCCESS(0)成功
 * */
extern uint32_t Device2AppDataTranRequestReply(uint32_t error_code);

/**
 * @brief:APP主动停止设备传输文件到APP
 * @return:SUCCESS(0)成功
 * */
extern uint32_t Device2AppDataTranManualStop(void);

/**
 * @brief:设备传输文件到APP的传输请求事件回调注册
 * json字符串内容:
 * file_type 文件类型:
 * typedef enum{
 *   DATA_TRAN_FILE_TYPE_UNKNOWN,           //无效
 *   DATA_TRAN_FILE_TYPE_FW,                //固件升级文件
 *   DATA_TRAN_FILE_TYPE_FZBIN,             //图片资源升级
 *   DATA_TYPE_FILE_TYPE_BIN,               //字库升级
 *   DATA_TYPE_FILE_TYPE_LANG,              //语言包
 *   DATA_TYPE_FILE_TYPE_BT,                //BT文件
 *   DATA_TYPE_FILE_TYPE_IWF,               //云表盘文件
 *   DATA_TYPE_FILE_TYPE_WALLPAPER,         //本地壁纸文件
 *   DATA_TYPE_FILE_TYPE_ML,                //通讯录文件
 *   DATA_TYPE_FILE_TYPE_UBX,               //AGPS文件
 *   DATA_TYPE_FILE_TYPE_GPS,               //GPS文件
 *   DATA_TYPE_FILE_TYPE_MP3,               //MP3文件
 *   DATA_TYPE_FILE_TYPE_MESSAGE,           //消息图标
 *   DATA_TYPE_FILE_TYPE_SPORT,             //运动图片 单图
 *   DATA_TYPE_FILE_TYPE_MOVE_SPORTS,       //运动图片 多图
 *   DATA_TYPE_FILE_TYPE_EPO,               //EPO文件
 *   DATA_TYPE_FILE_TYPE_TONE,              //提示音
 *   DATA_TYPE_FILE_TYPE_BP_CALIBRATE,      //血压校准文件
 *   DATA_TYPE_FILE_TYPE_BP_ALGORITHM,      //血压模型算法文件
 *   DATA_TYPE_FILE_TYPE_VOICE = 0x13       //语音备忘录文件
 *  }TRAN_FILE_TYPE;
 * file_size 文件大小
 * file_compression_type 文件压缩类型 0不压缩
 * file_name 文件名称
 * file_path 文件路径
 *
 * @param func 函数指针
 * @return:SUCCESS(0)成功
 * 备注：收到回调后，10s没有使用该方法dev_2_app_tran_request_reply回复设备，会结束传输
 * */
extern uint32_t Device2AppDataTranRequestCallbackReg(protocol_report_json_cb_handle func);

/**
 * @brief v3血压校准完成事件回调注册
 * @param func 函数指针
 * @return SUCCESS(0)成功
 * */
extern uint32_t ProtocolV3BpCalCompleteCallbackReg(protocol_bp_cal_complete_cb_handle func);

/**
 * @brief 同步v3健康数据进度回调注册
 * @param func 函数指针
 * @return SUCCESS(0)成功
 * */
extern uint32_t SyncV3HealthDataProgressCallbackReg(protocol_sync_v3_health_client_progress_cb_handle func);

/**
 * @brief 同步v3健康数据完成事件回调注册
 * @param func 函数指针
 * @return SUCCESS(0)成功
 * */
extern uint32_t SyncV3HealthDataCompleteCallbackReg(protocol_sync_v3_health_client_complete_cb_handle func);

/**
 * @brief 同步v3健康数据项完成事件回调注册(指的是每一种类型的健康数据收集完成后都会通过回调上报SDK)
 * @param func 函数指针
 * @return SUCCESS(0)成功
 * */
extern uint32_t SyncV3HealthDataOneNoticeCompleteCbReg(protocol_sync_v3_health_client_one_notice_complete_cb_handle func);

/**
 * @brief:同步v3健康数据的自定义一项
 * @param data_type 数据同步类型
 * 1 同步血氧
 * 2 同步压力
 * 3 同步心率(v3)
 * 4 同步多运动数据(v3)
 * 5 同步GPS数据(v3)
 * 6 同步游泳数据
 * 7 同步眼动睡眠数据
 * 8 同步运动数据
 * 9 同步噪音数据
 * 10 同步温度数据
 * 12 同步血压数据
 * 14 同步呼吸频率数据
 * 15 同步身体电量数据
 * 16 同步HRV(心率变异性水平)数据
 *
 * @return:
 * SUCCESS(0)成功 非0失败
 * (ERROR_NOT_SUPPORTED(6) 不支持
 * ERROR_INVALID_STATE(8) 非法状态
 * )
 * */
extern uint32_t SyncV3HealthDataCustomResource(int data_type);

/**
 * @brief:查找输入的数据同步类型支不支持
 * @param data_type 数据同步类型
 * 1  同步血氧
 * 2  同步压力
 * 3  同步心率(v3)
 * 4  同步多运动数据(v3)
 * 5  同步GPS数据(v3)
 * 6  同步游泳数据
 * 7  同步眼动睡眠数据
 * 8  同步运动数据
 * 9  同步噪音数据
 * 10 同步温度数据
 * 12 同步血压数据
 * 14 同步呼吸频率数据
 * 15 同步身体电量数据
 * 16 同步HRV(心率变异性水平)数据
 *
 * @return:
 * true:支持 false:不支持
 * 方法实现前需获取功能表跟初始化c库
 */
extern bool IsSupportSyncHealthDataType(int data_type);

// ------------------------------ v2同步多运动、GPS数据进度回调注册 ------------------------------
/**
 * @brief 同步v2活动数据进度回调注册
 * @param func 函数指针
 * @return SUCCESS(0)成功
 * */
extern uint32_t SyncV2ActivityProgressCallbackReg(protocol_sync_activity_progress_cb_handle func);

/**
 * @brief 同步v2活动数据完成回调注册
 * @param func 函数指针
 * @return SUCCESS(0)成功 ERROR_TIMEOUT(13)超时 ERROR_INVALID_STATE(8) 异常
 * */
extern uint32_t SyncV2ActivityCompleteCallbackReg(protocol_sync_activity_complete_cb_handle func);

/**
 * @brief 同步v2Gps数据进度回调注册
 * @param func 函数指针
 * @return SUCCESS(0)成功
 * */
extern uint32_t SyncV2GpsProgressCallbackReg(protocol_sync_gps_progress_cb_handle func);

/**
 * @brief 同步v2Gps数据完成回调注册
 * @param func 函数指针
 * @return SUCCESS(0)成功 ERROR_TIMEOUT(13)超时 ERROR_INVALID_STATE(8) 异常
 * */
extern uint32_t SyncV2GpsCompleteCallbackReg(protocol_sync_gps_complete_cb_handle func);

/**
 * @brief 解析完固件返回的v2同步数据二进制数据,打包成json数据回调给SDK
 * @return SUCCESS(0),成功
 * */
extern uint32_t V2SyncDataJsonDataCbReg(protocol_json_cb_handle func);

/**
 * @brief 同步v2健康数据进度回调注册
 * @param func 函数指针
 * @return:SUCCESS(0)成功
 * */
extern uint32_t SyncV2HealthProgressCallbackReg(protocol_sync_health_progress_cb_handle func);

/**
 * @brief 同步v2健康数据完成回调注册
 * @param func 函数指针
 * @return:SUCCESS(0)成功
 * */
extern uint32_t SyncV2HealthCompleteCallbackReg(protocol_sync_health_complete_cb_handle func);



#ifdef __cplusplus
}
#endif


#endif //IDO_PROTOCOL_PUBLIC_INTERFACE_H
