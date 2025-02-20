//
//  IDOUpdateSFManager.m
//  IDOBlueUpdate
//
//  Created by chenhuili on 2023/11/22.
//  Copyright © 2023 何东阳. All rights reserved.
//

#import "IDOUpdateSFManager.h"

#import <CoreBluetooth/CoreBluetooth.h>
#import <IDOUtils/eZIPSDKA.h>
#import <IDOUtils/SifliOtaSDKA-Swift.h>


@interface IDOUpdateSFManager ()<SFOTAManagerDelegate>

@property (nonatomic,strong) NSString *deviceUUID;

//当前升级进度
@property (nonatomic,assign) NSInteger currentProgress;

//是否处于升级中
@property (nonatomic,assign) BOOL updateOtaing;

@end

@implementation IDOUpdateSFManager

static IDOUpdateSFManager *_mgr = nil;

+ (IDOUpdateSFManager *)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _mgr = [[IDOUpdateSFManager alloc] init];
    });
    return _mgr;
}

- (instancetype)init{
    if(self = [super init]){
    }
    return self;
}

+ (instancetype)alloc{
    if (_mgr) {
        NSException *exception = [NSException exceptionWithName:@"重复创建IDOSifliOtaManager单例对象异常" reason:@"请使用[IDOSifliOtaManager shareInstance]的单例方法." userInfo:nil];
        [exception raise];
    }
    return [super alloc];
}

- (void)setConfigDelegate:(BOOL)configDelegate{
    _configDelegate = configDelegate;
    if(_configDelegate){
        [SFOTAManager share].delegate = self;
    }else{
        [SFOTAManager share].delegate = nil;
    }
}

//开始进行升级 99
- (void)startOTAWithFiles:(NSArray *)files deviceUUID:(NSString *)deviceUUID{
    if(![files isKindOfClass:[NSArray class]] || files.count == 0 || deviceUUID.length < 10){
        NSString *desc = [NSString stringWithFormat:@"传输过来的文件为空 或者 deviceUUID ： %@",deviceUUID];
        [self saveLog:desc];
        if(self.delegate && [self.delegate respondsToSelector:@selector(updateManageState:updateDesc:)]) {
            [self.delegate updateManageState:OTAUpdateStateNoFile updateDesc:desc];
        }
        
        return;
    }
    
    self.updateOtaing = YES;
    self.currentProgress = 0;
    self.deviceUUID = deviceUUID;
    NSURL *zipURL = nil;
    NSURL *ctrlURL = nil;
    
    NSMutableArray *imagefiles = [NSMutableArray array];
    for (NSString *file in files) {
        NSURL *url = [NSURL fileURLWithPath:file];
        if(!url){
            continue;
        }
        if([file hasSuffix:@".zip"]){
            zipURL = url;
        }else if ([file hasSuffix:@"ctrl_packet.bin"]){
            ctrlURL = url;
        }else if ([file hasSuffix:@"outER_IROM1.bin"]){
            SFNandImageFileInfo *info = [[SFNandImageFileInfo alloc]initWithPath:url imageID:NandImageIDHCPU];
            [imagefiles addObject:info];
        }else if ([file hasSuffix:@"outlcpu_flash.bin"]){
            SFNandImageFileInfo *info = [[SFNandImageFileInfo alloc]initWithPath:url imageID:NandImageIDLCPU];
            [imagefiles addObject:info];
        }else if ([file hasSuffix:@"outlcpu_rom_patch.bin"]){
            SFNandImageFileInfo *info = [[SFNandImageFileInfo alloc] initWithPath:url imageID:NandImageIDLCPU_PATCH];
            [imagefiles addObject:info];
        }else if ([file hasSuffix:@"outroot.bin"]){
            SFNandImageFileInfo *info = [[SFNandImageFileInfo alloc]initWithPath:url imageID:NandImageIDRES];
            [imagefiles addObject:info];
        }else if ([file hasSuffix:@"outdyn.bin"]){
            SFNandImageFileInfo *info = [[SFNandImageFileInfo alloc]initWithPath:url imageID:NandImageIDDYN];
            [imagefiles addObject:info];
        }
    }
    
    NSString *desc = [NSString stringWithFormat:@"开始进行Sifli升级zipURL:%@ \n ctrlURL:%@ \n files:%@ \n self.deviceUUID:%@",zipURL,ctrlURL,files,self.deviceUUID];
    if(self.delegate && [self.delegate respondsToSelector:@selector(updateManageState:updateDesc:)]) {
        [self.delegate updateManageState:OTAUpdateStateStarting updateDesc:desc];
    }
    
    
    if(![SFOTAManager share].delegate){
        [SFOTAManager share].delegate = self;
    }
    
    #ifdef DEBUG
    [SFOTALogManager share].logEnable = NO;
    [QBleLogManager share].openLog = NO;
    #endif
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[SFOTAManager share] startOTANandWithTargetDeviceIdentifier:self.deviceUUID
                                                        resourcePath:zipURL
                                                controlImageFilePath:ctrlURL
                                                      imageFileInfos:imagefiles
                                                           tryResume:YES
                                              imageResponseFrequnecy:4];
    });
}

//开始进行升级 98
- (void)startOTAANorV2WithFiles:(NSArray *)files deviceUUID:(NSString *)deviceUUID{
    if(![files isKindOfClass:[NSArray class]] || files.count == 0 || deviceUUID.length < 10){
        NSString *desc = [NSString stringWithFormat:@"传输过来的文件为空 或者 deviceUUID ： %@",deviceUUID];
        if(self.delegate && [self.delegate respondsToSelector:@selector(updateManageState:updateDesc:)]) {
            [self.delegate updateManageState:OTAUpdateStateNoFile updateDesc:desc];
        }
        
        return;
    }
    
    self.updateOtaing = YES;
    self.currentProgress = 0;
    self.deviceUUID = deviceUUID;
    NSURL *zipURL = nil;
    NSURL *ctrlURL = nil;
    
    NSMutableArray *imagefiles = [NSMutableArray array];
    for (NSString *file in files) {
        NSURL *url = [NSURL fileURLWithPath:file];
        if(!url){
            continue;
        }
        if([file hasSuffix:@".zip"]){
            continue;
        }else if ([file hasSuffix:@"ctrl_packet.bin"]){
            ctrlURL = url;
        }else if ([file hasSuffix:@"outER_IROM1.bin"] || [file hasSuffix:@"ER_IROM1.bin"]){
            SFNorImageFileInfo *info = [[SFNorImageFileInfo alloc]initWithPath:url imageID:NorImageIDHCPU];
            [imagefiles addObject:info];
        }else if ([file hasSuffix:@"outroot.bin"]){
            SFNorImageFileInfo *info = [[SFNorImageFileInfo alloc]initWithPath:url imageID:NorImageIDEX];
            [imagefiles addObject:info];
        }else if ([file hasSuffix:@"outER_IROM2.bin"]){
            SFNorImageFileInfo *info = [[SFNorImageFileInfo alloc]initWithPath:url imageID:NorImageIDRES];
            [imagefiles addObject:info];
        }else if ([file hasSuffix:@"outER_IROM3.bin"]){
            SFNorImageFileInfo *info = [[SFNorImageFileInfo alloc]initWithPath:url imageID:NorImageIDFONT_OR_MAX];
            [imagefiles addObject:info];
        }else if ([file hasSuffix:@"ota_manager.bin"]){
            SFNorImageFileInfo *info = [[SFNorImageFileInfo alloc]initWithPath:url imageID:NorImageIDOTA_MANAGER];
            [imagefiles addObject:info];
        }
    }
    
    NSString *desc = [NSString stringWithFormat:@"Sifli开始进行Sifli升级zipURL:%@ \n ctrlURL:%@ \n files:%@ \n self.deviceUUID:%@",zipURL,ctrlURL,files,self.deviceUUID];
    if(self.delegate && [self.delegate respondsToSelector:@selector(updateManageState:updateDesc:)]) {
        [self.delegate updateManageState:OTAUpdateStateStarting updateDesc:desc];
    }
    
    
    if(![SFOTAManager share].delegate){
        [SFOTAManager share].delegate = self;
    }
    
    #ifdef DEBUG
    [SFOTALogManager share].logEnable = NO;
    [QBleLogManager share].openLog = NO;
    #endif
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[SFOTAManager share] startOTANorV2WithTargetDeviceIdentifier:deviceUUID
                                                        controlImageFilePath:ctrlURL
                                                              imageFileInfos:imagefiles
                                                                   tryResume:YES
                                                           responseFrequency:20];
    });
    
}

#pragma mark - SFOTAManagerDelegate
/// 蓝牙状态改变回调。当state为poweredOn时才能启动升级，否则会启动失败。
/// state还可以通过manager的bleState属性来主动获取。
- (void)otaManagerWithManager:(SFOTAManager *)manager updateBleState:(enum BleCoreManagerState)state{
    NSString *desc = [NSString stringWithFormat:@"updateBleState:%ld self.updateOtaing:%d",state,self.updateOtaing];
    //[self saveLog:desc];
    if(self.delegate && [self.delegate respondsToSelector:@selector(updateManageState:updateDesc:)]) {
        [self.delegate updateManageState:OTAUpdateStateBleStateChange updateDesc:desc];
    }
    
    if(self.updateOtaing){
        self.updateOtaing = NO;
    }
}

/// 进度回调
/// \param manager 管理器
/// \param stage 当前所处的发送阶段
/// \param totalBytes 当前阶段总字节数
/// \param completedBytes 当前阶段已完成字节数
- (void)otaManagerWithManager:(SFOTAManager * _Nonnull)manager stage:(enum SFOTAProgressStage)stage totalBytes:(NSInteger)totalBytes completedBytes:(NSInteger)completedBytes{
    
    if(self.updateOtaing){
        CGFloat progress = totalBytes > 0 ? (completedBytes * 1.0 /  totalBytes) : 0;
        
        NSInteger proLovalue = progress * 100;
        NSString *desc = @"";
        if(completedBytes != self.currentProgress){
            if (proLovalue % 10 == 0  && progress > 0 && self.currentProgress != proLovalue){
                self.currentProgress = proLovalue;
//                NSString *desc = [NSString stringWithFormat:@"OTA: ----  Sifli stage:%ld  totalBytes:%ld  completedBytes:%ld  progress：%lf",stage,totalBytes,completedBytes,progress];
//                [self saveLog:desc];
            }
            if(self.delegate && [self.delegate respondsToSelector:@selector(updateManageState:updateDesc:)]) {
                [self.delegate updateManageState:OTAUpdateStateBleStateChange updateDesc:desc];
            }

            if(self.delegate && [self.delegate respondsToSelector:@selector(updateManagerProgress:message:)]) {
                [self.delegate updateManagerProgress:progress message:desc];
            }
        }
    }
}

/// OTA流程结束
/// \param manager 管理器
/// \param error nil-表示成功，否则表示失败
- (void)otaManagerWithManager:(SFOTAManager * _Nonnull)manager complete:(SFOTAError * _Nullable)error{
    if(self.updateOtaing || error){
        self.updateOtaing = NO;
        NSString *desc = [NSString stringWithFormat:@"complete errorType:%ld  errorDes:%@",error.errorType,error.errorDes];
        [self saveLog:desc];
        OTAUpdateState state = OTAUpdateStateCompleted;
        if (error) {
            state = OTAUpdateStateFail;
        }
        if(self.delegate && [self.delegate respondsToSelector:@selector(updateManageState:updateDesc:)]) {
            [self.delegate updateManageState:state updateDesc:desc];
        }
    }
}


#pragma mark - 通知
- (void)cancelSifliDelegate{
    [SFOTAManager share].delegate = nil;
}


/// 将png格式文件序列转为ezipBin类型。转换失败返回nil。V2.2
/// @param pngDatas png文件数据序列
/// @param eColor 颜色字符串 color type as below: rgb565, rgb565A, rbg888, rgb888A
/// @param eType eizp类型 0 keep original alpha channel;1 no alpha chanel
/// @param binType bin类型 0 to support rotation; 1 for no rotation
/// @param boardType 主板类型 @See SFBoardType 0:55x 1:56x  2:52x
/// @return ezip or apng result, nil for fail
+(nullable NSData *)siFliEBinFromPngSequence:(NSArray<NSData *> *)pngDatas
                                      eColor:(NSString *)eColor
                                       eType:(uint8_t)eType
                                     binType:(uint8_t)binType
                                   boardType:(IDOSFBoardType)boardType{
    SFBoardType sfBoardType;
    switch (boardType) {
        case IDOSFBoardTypeX52:
            sfBoardType = SFBoardType52X;
            break;
        case IDOSFBoardTypeX55:
            sfBoardType = SFBoardType55X;
            break;
        case IDOSFBoardTypeX56:
            sfBoardType = SFBoardType56X;
            break;
        default:
            break;
    }
    if (pngDatas.count == 1) {
        NSData*pngData = [pngDatas firstObject];
        NSData *result = [ImageConvertor EBinFromPNGData:pngData eColor:eColor eType:eType binType:binType boardType:sfBoardType];
        return result;
    }else{
        NSData *result = [ImageConvertor EBinFromPngSequence:pngDatas eColor:eColor eType:eType binType:binType boardType:sfBoardType];
        return result;
    }
}

- (void)saveLog:(NSString *)log{
    if(self.delegate && [self.delegate respondsToSelector:@selector(logMessage:)]) {
        [self.delegate logMessage:log];
    }
}

- (void)stop {
    [[SFOTAManager share] stop];
}

@end
