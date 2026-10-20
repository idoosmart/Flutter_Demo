//
//  OtaManager.h
//  ActionsUtils
//
//  Created by 林韦辰 on 2025/2/17.
//

#import <Foundation/Foundation.h>
#import "OTAStatus.h"
#import "OtaUtils.h"
#import "ActVersion.h"
#import "ErrorCode.h"
#import "BitmapUtils.h"

#import "RemoteStatus.h"

#define FILE_HEAD_308       @"AOTA"
#define FILE_HEAD_238       @"ACTT"
#define FILE_HEAD_238_ELSE  @"EST0"

#define OTA_MODE            0

#define OTA_UNIT_DEFAULT    256
#define OTA_TIME_OUT        20.0

@protocol OtaDelegate <NSObject>

- (void)sendOtaData:(NSData *_Nonnull)data;
- (void)onOtaStatus:(NSInteger)state;
- (void)onOtaAudioDataReceived:(NSInteger)psn len:(NSInteger)len data:(NSData *_Nullable)data;
- (void)onOtaRemoteStatusReceived:(RemoteStatus *_Nonnull)status;
- (void)onOtaProgress:(NSInteger)progress total:(NSInteger)total;
- (void)onOtaError:(NSInteger)errCode errMsg:(NSString *_Nullable)errMsg;
- (void)onOtaWriteBytes:(NSInteger)count;

@optional
/// 日志（由上层统一处理控制台 / APP 回调）
- (void)onOtaLog:(NSString *)message;

@end

NS_ASSUME_NONNULL_BEGIN

@interface OtaManager : NSObject

@property (weak, nonatomic) id<OtaDelegate> delegate;

- (void)setOTAFile:(NSString *)url;
- (void)prepare;
- (NSString *)getOTAVersion;
- (void)upgrade;
- (void)cancel;

- (void)analysisData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
