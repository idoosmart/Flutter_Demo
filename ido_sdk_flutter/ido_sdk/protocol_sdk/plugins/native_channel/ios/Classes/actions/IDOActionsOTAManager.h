//
//  IDOActionsOTAManager.h
//  IDOOTASDK
//
//  Actions OTA 封装（内部实现使用 ActionsOTASDK，不对外导出厂商头文件）。
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IDOActionsOTAManagerDelegate <NSObject>
- (void)actionsOTADidComplete;
- (void)actionsOTADidFailWithError:(NSError *)error;
- (void)actionsOTAProgressDidChange:(float)progress;
@optional
- (void)actionsOTADidUpdateBleState:(CBManagerState)state;
/// 日志（由 IDOOTAManager 统一处理控制台 / APP 回调）
- (void)actionsOTADidLog:(NSString *)message;
@end

@interface IDOActionsOTAManager : NSObject

@property (class, readonly, strong) IDOActionsOTAManager *share;
@property (nonatomic, weak, nullable) id<IDOActionsOTAManagerDelegate> delegate;
/// 搜索超时（秒），默认 20
@property (nonatomic, assign) NSInteger searchingTimeout;
@property (nonatomic, readonly) BOOL isBusy;
@property (nonatomic, readonly) CBManagerState bleState;

/// Start Actions OTA. Host app must disconnect its own BLE link before calling.
- (void)startOTAWithTargetDeviceIdentifier:(NSString *)targetDeviceIdentifier
                                  filePath:(NSString *)filePath;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
