//
//  LETransceiver.h
//  ActsBluetoothSpeed
//
//  Created by inidhu on 2019/3/15.
//  Copyright © 2019 Actions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "Global.h"

NS_ASSUME_NONNULL_BEGIN

#define KeyWriteServiceUUID             @"kWriteServiceUUID"
#define KeyIndicateServiceUUID          @"kIndicateServiceUUID"
#define KeyWriteCharacteristicUUID      @"kWriteCharacteristicUUID"
#define KeyIndicateCharacteristicUUID   @"kIndicateCharacteristicUUID"




@protocol LEConnctionDelegate <NSObject>

@required
- (void)onFoundPeripheral:(CBPeripheral *) peripheral advertisementData:(NSDictionary *) advertisementData;

@optional
- (void)onConnectedPeripheral:(CBPeripheral *) peripheral;
- (void)onDisconnectedPeripheral:(CBPeripheral *) peripheral;
/// 系统蓝牙状态变化（对齐 Sifli QBleCore didUpdateState）
- (void)onBleStateUpdate:(CBManagerState)state;
/// 日志（由上层统一处理控制台 / APP 回调）
- (void)onLog:(NSString *)message;

@end

@protocol LEDataDelegate <NSObject>

@optional

- (void)onDataReceive:(NSData *) data;

@end

@interface LETransceiver : NSObject<CBPeripheralDelegate, CBCentralManagerDelegate>

@property (weak, nonatomic) id<LEConnctionDelegate> connectionDelegate;
@property (weak, nonatomic) id<LEDataDelegate> dataDelegate;

- (void)setUUIDs:(NSDictionary *) uuids;

/// 当前蓝牙状态（对齐 Sifli QBleCore.state）
- (CBManagerState)bleState;

/// 通过 OTA Service 取系统已连接外设（对齐 Sifli retrievePairedPeripherals）
- (NSArray<CBPeripheral *> *)retrieveConnectedPeripherals;

/// 按 identifier 取系统已知外设（客户 APP 断开后重连主路径）
- (nullable CBPeripheral *)retrievePeripheralWithIdentifier:(NSString *)deviceUUID;

- (void)scanStart;
- (void)scanStop;

- (void)connect:(CBPeripheral *)peripheral;
- (void)connectWithDeviceUUID:(NSString *)deviceUUID;
- (void)disconnect:(CBPeripheral *)peripheral;

- (void)write:(NSData *) data;
- (void)write:(NSData *) data index:(int) i;

- (void)disconnect;

- (NSUInteger) getMtuForType:(CBCharacteristicWriteType)type;

@end

NS_ASSUME_NONNULL_END
