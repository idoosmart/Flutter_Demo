//
//  Global.h
//  ActionsUtils
//
//  Created by 林韦辰 on 2025/1/20.
//

#ifndef Global_h
#define Global_h

#import <UIKit/UIKit.h>

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define kMsgPeripheralFound         @"msgPeripheralFound"
#define kMsgPeripheralConnected     @"msgPeripheralConnected"
#define kMsgPeripheralDisconnected  @"msgPeripheralDisconnected"


// 日志功能部分
#define logCommandSubmit            @"log_command"
#define logCommandOthers            @"log_other_cmd"

#define logStatusDic                @"log_status_delegate"
#define logErrorDic                 @"log_err_delegate"
#define logMsgDic                   @"log_msg_delegate"
#define logByteMsgDic               @"log_byte_msg_delegate"
#define logRssi                     @"log_rssi_delegate"
#define logStop                     @"log_stop_delegaet"

// ota功能部分
#define otaStatusDic                @"ota_status_delegate"
#define otaAudioDataDic             @"ota_audio_delegate"
#define otaRemoteDic                @"ota_remote_delegate"
#define otaProgressDic              @"ota_progress_delegate"
#define otaErrorDic                 @"ota_error_delegate"
#define otaWriteByteDic             @"ota_write_byte_delegate"

// speed功能部分
#define speedDataWriteDic           @"speed_data_write"
#define speedDataReadDic            @"speed_data_read"

// wifi功能部分
#define wifiListDic                 @"wifi_list"
#define wifiListEndDic              @"wifi_end"
#define wifiConnectStatusDic        @"wifi_status"
#define wifiErrorDic                @"wifi_error"
#define wifiPswDic                  @"wifi_psw"

#endif /* Global_h */
