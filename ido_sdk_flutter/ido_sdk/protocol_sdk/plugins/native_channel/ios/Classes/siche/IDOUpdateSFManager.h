//
//  IDOUpdateSFManager.h
//  IDOBlueUpdate
//
//  Created by chenhuili on 2023/11/22.
//  Copyright © 2023 何东阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sifli.g.h"

NS_ASSUME_NONNULL_BEGIN


@class IDOUpdateSFManager;

@protocol IDOUpdateSFManagerDelegate<NSObject>

@optional
/**
 * @brief 升级状态 | Upgrade status
 * @param state 状态值 | Status value
 * @param desc 状态值 | Status value
 */
- (void)updateManageState:(OTAUpdateState)state updateDesc:(NSString*)desc;

/**
 * @brief  升级过程的进度 | Progress of the upgrade process
 * @param progress 进度 (0 ~ 1) | Progress (0 ~ 1)
 * @param message 升级日志信息 | Upgrade log information
 */
- (void)updateManagerProgress:(float)progress
              message:(NSString *_Nullable)message;

- (void)logMessage:(NSString *)logMsg;

@end


@interface IDOUpdateSFManager : NSObject

/**
 设置代理 | Setting up the agent
 */
@property (nonatomic,weak,nullable) id <IDOUpdateSFManagerDelegate> delegate;

//这个SDK需要提前进行代理，不然在开始升级的时候，会出现蓝牙不可用的问题
//（ [SifliOTA][V1.2.18][SFOTAManager.swift bleCore(core:didUpdateState:)][290]蓝牙状态变化:BleCoreManagerState(rawValue: 5)
@property (nonatomic,assign) BOOL configDelegate;

/**
 * @brief 初始化管理中心对象 | Initialize the Upgrade Management Center object
 * @return IDOUpdateSFManager
 */
+ (__kindof IDOUpdateSFManager *_Nonnull)shareInstance;


//开始进行升级
- (void)startOTAWithFiles:(NSArray *)files deviceUUID:(NSString *)deviceUUID;

//开始进行升级 98
- (void)startOTAANorV2WithFiles:(NSArray *)files deviceUUID:(NSString *)deviceUUID;

/// 将png格式文件序列转为ezipBin类型。转换失败返回nil。V2.2
/// @param pngDatas png文件数据序列数组 （如果数组是多张图片，则会几张图片组合拼接成一张图片）
/// @param eColor 颜色字符串 color type as below: rgb565, rgb565A, rbg888, rgb888A
/// @param eType eizp类型 0 keep original alpha channel;1 no alpha chanel
/// @param binType bin类型 0 to support rotation; 1 for no rotation
/// @param boardType 主板芯片类型 @See SFBoardType 0:55x 1:56x  2:52x
/// @return ezip or apng result, nil for fail
+(nullable NSData *)siFliEBinFromPngSequence:(NSArray<NSData *> *)pngDatas
                               eColor:(NSString *)eColor
                                eType:(uint8_t)eType
                              binType:(uint8_t)binType
                                   boardType:(IDOSFBoardType)boardType;

- (void)stop;

@end

NS_ASSUME_NONNULL_END
