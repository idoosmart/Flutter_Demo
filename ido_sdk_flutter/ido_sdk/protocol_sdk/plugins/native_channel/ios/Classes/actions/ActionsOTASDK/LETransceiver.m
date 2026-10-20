//
//  LETransceiver.m
//  ActsBluetoothSpeed
//
//  Created by inidhu on 2019/3/15.
//  Copyright © 2019 Actions. All rights reserved.
//

#import "LETransceiver.h"
#import <UIKit/UIKit.h>

static NSString * const kActionsOTAServiceUUID = @"e49a25f8-f69a-11e8-8eb2-f2801f1b9fd1";

@implementation LETransceiver {
    NSString *writeServiceUUID;
    NSString *writeCharacteristicUUID;
    NSString *indicateServiceUUID;
    NSString *indicateCharacteristicUUID;
    
    CBCharacteristicWriteType writeType;
    CBCentralManager *centralManager;
    
    CBPeripheral *connectedPeripheral;
    CBCharacteristic *characteristicWrite;
    CBCharacteristic *characteristicIndicate;
    
    NSTimer *connectTimer;
    /// 防止多个 service 特征发现回调重复通知连接成功
    BOOL hasNotifiedConnected;
}

- (id) init {
    self = [super init];

    writeType = CBCharacteristicWriteWithoutResponse;
    // 与 Sifli QBleCore 一样：尽早创建 Central，便于 start 前 bleState 已就绪
    centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];

    return self;
}

- (CBManagerState)bleState {
    return centralManager.state;
}

- (NSArray<CBPeripheral *> *)retrieveConnectedPeripherals {
    CBUUID *otaService = [CBUUID UUIDWithString:kActionsOTAServiceUUID];
    return [centralManager retrieveConnectedPeripheralsWithServices:@[otaService]];
}

- (CBPeripheral *)retrievePeripheralWithIdentifier:(NSString *)deviceUUID {
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:deviceUUID];
    if (uuid == nil) {
        return nil;
    }
    NSArray<CBPeripheral *> *known = [centralManager retrievePeripheralsWithIdentifiers:@[uuid]];
    return known.firstObject;
}

- (void)setUUIDs:(NSDictionary *) uuids {
    [self otaLog:@"setUUIDs"];
    NSArray *keys = [uuids allKeys];
    for (NSString *key in keys) {
        if ([key isEqualToString:KeyWriteServiceUUID]) {
            writeServiceUUID = [[uuids objectForKey:KeyWriteServiceUUID] uppercaseString];
        } else if ([key isEqualToString:KeyIndicateServiceUUID]) {
            indicateServiceUUID = [[uuids objectForKey:KeyIndicateServiceUUID] uppercaseString];
        } else if ([key isEqualToString:KeyWriteCharacteristicUUID]) {
            writeCharacteristicUUID = [[uuids objectForKey:KeyWriteCharacteristicUUID] uppercaseString];
        } else if ([key isEqualToString:KeyIndicateCharacteristicUUID]) {
            indicateCharacteristicUUID = [[uuids objectForKey:KeyIndicateCharacteristicUUID] uppercaseString];
        }
    }
}

- (void)scanStart {
    if (centralManager.state != CBManagerStatePoweredOn) {
        [self otaLog:@"scanStart skipped, ble state=%ld", (long)centralManager.state];
        return;
    }
    // 对齐 Sifli：withServicesFilter=false，便于 OTA 模式设备被发现
    NSDictionary *options = @{CBCentralManagerScanOptionAllowDuplicatesKey: @NO};
    [centralManager scanForPeripheralsWithServices:nil options:options];
}

- (void)scanStop {
    [centralManager stopScan];
}

- (void)connect:(CBPeripheral *)peripheral {
    [self scanStop];
    
    connectedPeripheral = peripheral;
    characteristicWrite = nil;
    characteristicIndicate = nil;
    hasNotifiedConnected = NO;
    
    if (peripheral.state == CBPeripheralStateConnected) {
        // 已连接则直接发现服务
        peripheral.delegate = self;
        [peripheral discoverServices:nil];
    } else {
        [centralManager connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES}];
    }
    
    if (connectTimer != nil) {
        [connectTimer invalidate];
        connectTimer = nil;
    }
    connectTimer = [NSTimer scheduledTimerWithTimeInterval:20.0
                                                    target:self
                                                  selector:@selector(connectTimeout:)
                                                  userInfo:peripheral
                                                   repeats:NO];
}

- (void)connectWithDeviceUUID:(NSString *)deviceUUID{
    // 兼容旧接口：优先已连接，再系统已知 identifier
    NSArray<CBPeripheral *> *connected = [self retrieveConnectedPeripherals];
    for (CBPeripheral *p in connected) {
        if ([deviceUUID.uppercaseString isEqualToString:p.identifier.UUIDString.uppercaseString]) {
            [self connect:p];
            return;
        }
    }
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:deviceUUID];
    if (uuid != nil) {
        NSArray<CBPeripheral *> *known = [centralManager retrievePeripheralsWithIdentifiers:@[uuid]];
        if (known.count > 0) {
            [self connect:known.firstObject];
        }
    }
}

- (void)disconnect:(CBPeripheral *)peripheral {
    if (![self isPeripheralConnected:peripheral]) {
        return;
    }
    
    [self otaLog:@"disconnect %@", peripheral.name];
    [centralManager cancelPeripheralConnection:peripheral];
}

- (BOOL) isPeripheralConnected:(CBPeripheral *) peripheral {
    if (peripheral.state == CBPeripheralStateConnected) {
        return YES;
    }
    return NO;
}

- (NSUInteger) getMtuForType:(CBCharacteristicWriteType) type {
    return [connectedPeripheral maximumWriteValueLengthForType:type];
}

- (void)write:(NSData *) data {
    if (characteristicWrite) {
        NSUInteger mtu = [self getMtuForType:CBCharacteristicWriteWithoutResponse];
        [self otaLog:@"writeData mtu: %ld, %@", mtu, data];
        for (NSUInteger index = 0; index < data.length; index += mtu) {
            NSUInteger len = (data.length - index) > mtu ? mtu : (data.length - index);
            NSData *value = [data subdataWithRange:NSMakeRange(index, len)];
            [connectedPeripheral writeValue:value forCharacteristic:characteristicWrite type:CBCharacteristicWriteWithoutResponse];
            [self otaLog:@"writeValue: %@", value];
        }
    }
}

- (void)write:(NSData *) data index:(int) i {
    if (characteristicWrite) {
        NSUInteger mtu = [self getMtuForType:CBCharacteristicWriteWithoutResponse];
        [self otaLog:@"i writeData mtu: %ld, %@", mtu, data];
        
        for (NSUInteger index = 0; index < data.length; index += mtu) {
            NSUInteger len = (data.length - index) > mtu ? mtu : (data.length - index);
            NSData *value = [data subdataWithRange:NSMakeRange(index, len)];
            if(i != 0 && i % 62 == 0) {
                NSData *value2 = [value subdataWithRange:NSMakeRange(0, 1)];
                NSData *value3 = [value subdataWithRange:NSMakeRange(1, value.length - 1)];
                [connectedPeripheral writeValue:value2 forCharacteristic:characteristicWrite type:CBCharacteristicWriteWithResponse];
                [connectedPeripheral writeValue:value3 forCharacteristic:characteristicWrite type:CBCharacteristicWriteWithoutResponse];
            } else {
                [connectedPeripheral writeValue:value forCharacteristic:characteristicWrite type:CBCharacteristicWriteWithoutResponse];
            }
            [self otaLog:@"writeValue: %@", value];
        }
    }
}

- (void)connectTimeout:(NSTimer *)timer {
    [self otaLog:@"connectTimeout"];
    CBPeripheral *peripheral = (CBPeripheral *)[timer userInfo];
    if (peripheral != nil) {
        [centralManager cancelPeripheralConnection:peripheral];
    }
    // 未真正连上时 cancel 不一定回调 didDisconnect，主动通知上层以便重连
    if (_connectionDelegate && [_connectionDelegate respondsToSelector:@selector(onDisconnectedPeripheral:)]) {
        [_connectionDelegate onDisconnectedPeripheral:peripheral];
    }
}


#pragma mark - Log

- (void)otaLog:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2) {
    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    if (_connectionDelegate && [_connectionDelegate respondsToSelector:@selector(onLog:)]) {
        [_connectionDelegate onLog:message];
    }
}

#pragma mark -- CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    [self otaLog:@"bleState=%ld", (long)central.state];
    
    if (_connectionDelegate && [_connectionDelegate respondsToSelector:@selector(onBleStateUpdate:)]) {
        [_connectionDelegate onBleStateUpdate:central.state];
    }
    
    // 对齐 Sifli QBleCore：蓝牙被关闭时主动通知断开
    if (central.state != CBManagerStatePoweredOn && connectedPeripheral != nil) {
        CBPeripheral *p = connectedPeripheral;
        connectedPeripheral = nil;
        characteristicWrite = nil;
        characteristicIndicate = nil;
        [self scanStop];
        if (connectTimer != nil) {
            [connectTimer invalidate];
            connectTimer = nil;
        }
        if (_connectionDelegate && [_connectionDelegate respondsToSelector:@selector(onDisconnectedPeripheral:)]) {
            [_connectionDelegate onDisconnectedPeripheral:p];
        }
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    if(_connectionDelegate && [_connectionDelegate respondsToSelector:@selector(onFoundPeripheral:advertisementData:)]) {
        [_connectionDelegate onFoundPeripheral:peripheral advertisementData:advertisementData];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    [self otaLog:@"didConnectPeripheral: %@", peripheral.name];
    
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    [self otaLog:@"didFailToConnectPeripheral: %@ error=%@", peripheral, error];
    connectedPeripheral = nil;
    characteristicWrite = nil;
    characteristicIndicate = nil;
    hasNotifiedConnected = NO;
    if (connectTimer != nil) {
        [connectTimer invalidate];
        connectTimer = nil;
    }
    if(_connectionDelegate && [_connectionDelegate respondsToSelector:@selector(onDisconnectedPeripheral:)]) {
        [_connectionDelegate onDisconnectedPeripheral:peripheral];
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    [self otaLog:@"didDisconnectPeripheral %@, error: %@",peripheral, error];
    connectedPeripheral = nil;
    characteristicWrite = nil;
    characteristicIndicate = nil;
    hasNotifiedConnected = NO;
    if(_connectionDelegate && [_connectionDelegate respondsToSelector:@selector(onDisconnectedPeripheral:)]) {
        [_connectionDelegate onDisconnectedPeripheral:peripheral];
    }
}

- (void)disconnect {
    [self scanStop];
    hasNotifiedConnected = NO;
    if (connectTimer != nil) {
        [connectTimer invalidate];
        connectTimer = nil;
    }
    if (connectedPeripheral) {
        [centralManager cancelPeripheralConnection:connectedPeripheral];
    }
}

#pragma mark -- CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    [self otaLog:@"didDiscoverServices: %@", peripheral.name];
    if (error) {
        [self otaLog:@"Error discovering service:%@", [error localizedDescription]];
        return;
    }
    
    for (CBService *service in peripheral.services) {
        [self otaLog:@"service: %@", service];
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    [self otaLog:@"didDiscoverCharacteristicsForService: %@, %@", peripheral.name, service.UUID.UUIDString];
    if (error) {
        [self otaLog:@"Error didDiscoverCharacteristicsForService:%@",[error localizedDescription]];
        return;
    }
    
    [self otaLog:@"UUID: %@, %@, %@", service.UUID.UUIDString, writeServiceUUID, indicateServiceUUID];
    if ([service.UUID.UUIDString isEqualToString:writeServiceUUID]) {
        for (CBCharacteristic *characteristic in service.characteristics) {
            [self otaLog:@"DiscoverCharacteristics: %@", characteristic.UUID];

            if ([characteristic.UUID.UUIDString isEqualToString:writeCharacteristicUUID])
                characteristicWrite = characteristic;
        }
    }
    
    if ([service.UUID.UUIDString isEqualToString:indicateServiceUUID]) {
        for (CBCharacteristic *characteristic in service.characteristics) {
            [self otaLog:@"DiscoverCharacteristics: %@", characteristic.UUID];
            
            if ([characteristic.UUID.UUIDString isEqualToString:indicateCharacteristicUUID]) {
                characteristicIndicate = characteristic;
                // 对齐 Sifli：订阅成功后再回调连接成功，避免握手包发了却收不到回复
                if (characteristic.isNotifying) {
                    [self notifyConnectedIfReady:peripheral];
                } else {
                    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                }
            }
        }
    }
}

- (void)notifyConnectedIfReady:(CBPeripheral *)peripheral {
    if (hasNotifiedConnected) {
        return;
    }
    if (!(characteristicWrite && characteristicIndicate && characteristicIndicate.isNotifying)) {
        return;
    }
    hasNotifiedConnected = YES;
    connectedPeripheral = peripheral;
    [connectTimer invalidate];
    connectTimer = nil;
    
    [self otaLog:@"GATT ready (write+indicate notifying)"];
    if(_connectionDelegate && [_connectionDelegate respondsToSelector:@selector(onConnectedPeripheral:)]) {
        [_connectionDelegate onConnectedPeripheral:peripheral];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        [self otaLog:@"notify state error: %@ %@", characteristic.UUID, error.localizedDescription];
        return;
    }
    if (characteristicIndicate && [characteristic.UUID.UUIDString isEqualToString:characteristicIndicate.UUID.UUIDString]) {
        [self otaLog:@"indicate notifying=%d", characteristic.isNotifying];
        if (characteristic.isNotifying) {
            [self notifyConnectedIfReady:peripheral];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(nullable NSError *)error {
    
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    if (error) {
        [self otaLog:@"%@,%@,Error didWriteValueForCharacteristic:%@",characteristic.UUID,[characteristic value], [error localizedDescription]];
        return;
    }
    
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        [self otaLog:@"Error didUpdateValueForCharacteristic:%@", [error localizedDescription]];
        return;
    }
    [self otaLog:@"didUpdateValueForCharacteristic: %@  %@", characteristic.UUID, characteristic.value];
    
    if (_dataDelegate && [_dataDelegate respondsToSelector:@selector(onDataReceive:)]) {
        [_dataDelegate onDataReceive:[characteristic value]];
    }
}

@end
