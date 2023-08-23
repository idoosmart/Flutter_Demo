//
//  Transform.h
//  flutter_bluetooth
//
//  Created by lux on 2022/9/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Transform : NSObject

+ (float)calcDistByRssi:(int)rssi;

+ (NSString *)getPeripheralMacAddr:(id)data;
//                          deviceId:(int *)deviceId
//                        bltVersion:(int *)bltVersion
//                        deviceType:(int *)deviceType;

+ (void)listenBlueUpdateStateWithCharacteristic:(NSData *)characteristic;

@end

@interface IDOBlueUpdateStateModel : NSObject
/**
 0  无效 1 手环已经解绑 2 心率模式改变 3 血氧产生数据，发生改变
 4 压力产生数据，发生改变 5 Alexa识别过程中退出 6  固件发起恢复出厂设置，通知app弹框提醒
 7 app需要进入相机界面（TIT01定制）8 sos事件通知（205土耳其定制）
 9 alexa设置的闹钟，固件修改，需要发送对应的通知位给app，app收到后发送获取V3的闹钟命令
 */
@property (nonatomic,assign) NSInteger dataType;
/**
 1 闹钟已经修改 2 固件过热异常告警 4 亮屏参数有修改 8 抬腕参数有修改
 16  勿擾模式获取 32 手机音量的下发
 */
@property (nonatomic,assign) NSInteger notifyType;
/**
 每个消息对应一个ID
 */
@property (nonatomic,assign) NSInteger msgId;
/**
 0 无效 1 自定义短信1（正在开会，稍后联系）2 自定义短信2
 */
@property (nonatomic,assign) NSInteger msgNotice;
/**
 01 ACC  加速度 02 PPG  心率 03 TP   触摸 04 FLASH
 05 过热（PPG）06 气压 07 GPS 08 地磁
 */
@property (nonatomic,assign) NSInteger errorIndex;
@end

NS_ASSUME_NONNULL_END
