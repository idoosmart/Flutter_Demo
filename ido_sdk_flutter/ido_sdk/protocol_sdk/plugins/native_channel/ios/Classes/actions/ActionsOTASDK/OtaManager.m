//
//  OtaManager.m
//  ActionsUtils
//
//  Created by 林韦辰 on 2025/2/17.
//

#import "OtaManager.h"

@implementation OtaManager {
    NSData *fileData;
    NSInteger fileDataLen;
    
    NSString *mFwVersion;
    NSData *mVRAM;
    
    BOOL mRemoteCrcSupport;
    BOOL mIsTranFinish;
    
    NSInteger mWaitTimeout;
    NSInteger mRestartTimeout;
    NSInteger mOtaUnit;
    NSInteger mInterval;
    NSInteger mAckEnable;
    NSInteger mWriteBytes;
    
    NSTimer *timer;
    
    bool mRunning;
    
    NSInteger curStatus;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        fileData = nil;
        fileDataLen = -1;
        mRemoteCrcSupport = NO;
        mIsTranFinish = NO;
        mOtaUnit = 0;
        mAckEnable = 0;
        mRunning = NO;
        curStatus = STATE_IDLE;
    }
    return self;
}

- (void)setOTAFile:(NSString *)url {
    [self otaLog:@"setOtaFIle:%@", url];
    NSError *error = nil;
    
//    NSURL *fileUrl = [self getFileURLInDocumentsDirectory:[url lastPathComponent]];
    
    fileData = [NSData dataWithContentsOfFile:url options:NSDataReadingMappedIfSafe error:&error];
    
    if (error) {
        [self otaLog:@"文件非法或不存在:%@", error.localizedDescription];
        [self onError:-1 errMsg:@"文件非法或不存在"];
    } else {
        fileDataLen = fileData.length;
    }
}

- (void)prepare {
    [self otaLog:@"manager prepare"];
    [self startPull];
    [self handShake];
}

- (NSString *)getOTAVersion {
    if (fileDataLen <= 0) {
        return nil;
    }
    
    if (fileDataLen > 4) {
        NSData *headData = [fileData subdataWithRange:NSMakeRange(0, 4)];
        NSString *head = [[NSString alloc] initWithData:headData encoding:NSUTF8StringEncoding];
        
        if ([head isEqualToString:FILE_HEAD_308]) {
            if (fileDataLen < 96) {
                return nil;
            }
            NSData *buffer1 = [fileData subdataWithRange:NSMakeRange(64, 32)];
            
            return [[NSString alloc] initWithData:buffer1 encoding:NSUTF8StringEncoding];
        } else if ([head isEqualToString:FILE_HEAD_238]) {
            NSString *version = [ActVersion getBinMsg:fileData];
            if (version != nil && version.length > 0 && ![version isEqualToString:ERROR_CODE]) {
                return version;
            }
        } else {
            if (fileData.length < 16) {
                return nil;
            }
            NSData *buf = [fileData subdataWithRange:NSMakeRange(12, 4)];
            return [[NSString alloc] initWithData:buf encoding:NSUTF8StringEncoding];
        }
    }
    return nil;
}

- (void)upgrade {
    if (fileData != nil && fileData.length != 0) {
        [self onProgress:0 total:fileData.length];
        
        [self requestRemoteParameters];
        
        [self startTimer];
        mWriteBytes = 0;
        mRunning = YES;
        
    } else {
        [self onError:PACKAGE_INVALID errMsg:MESSAGE_BIN_ERR];
    }
}

- (void)cancel {
    [self stopTimer];
    [self onStatus:STATE_IDLE];
    mRunning = NO;
}


#pragma mark - Log

- (void)otaLog:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2) {
    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    if (self.delegate && [self.delegate respondsToSelector:@selector(onOtaLog:)]) {
        [self.delegate onOtaLog:message];
    }
}

#pragma mark -- 私有函数

- (void)startPull {
    mRunning = YES;
    [self startTimer];
}

- (void)handShake {
    [self otaLog:@"handShake"];
    [self onStatus:STATE_PREPARING];
    
    BOOL success = [self readOTAHeader];
    if (!success) {
        [self onStatus:STATE_UNKNOWN];
        return;
    }
    
    [self checkRemoteStatus:mFwVersion mode:OTA_MODE];
}

- (BOOL)readOTAHeader {
    if (fileDataLen <= 0) {
        [self otaLog:@"fileDataLen == 0"];
        return NO;
    }
    
    if (fileDataLen > 4) {
        NSData *headData = [fileData subdataWithRange:NSMakeRange(0, 4)];
        NSString *head = [[NSString alloc] initWithData:headData encoding:NSUTF8StringEncoding];
        
        if ([head isEqualToString:FILE_HEAD_308]) {
            if (fileDataLen < 96) {
                return NO;
            }
            NSData *buffer1 = [fileData subdataWithRange:NSMakeRange(64, 32)];
            
            mFwVersion = [[NSString alloc] initWithData:buffer1 encoding:NSUTF8StringEncoding];
            
            return YES;
        } else if ([head isEqualToString:FILE_HEAD_238]) {
            mFwVersion = [ActVersion getBinMsg:fileData];
            if (mFwVersion != nil && mFwVersion.length > 0 && ![mFwVersion isEqualToString:ERROR_CODE]) {
                return YES;
            }
        } else {
            if (fileData.length < 16) {
                return NO;
            }
            NSData *buf = [fileData subdataWithRange:NSMakeRange(12, 4)];
            mFwVersion = [[NSString alloc] initWithData:buf encoding:NSUTF8StringEncoding];
            
            if (fileData.length < (56 + 16)) {
                return NO;
            }
            mVRAM = [fileData subdataWithRange:NSMakeRange(56, 16)];
            return YES;
        }
        
        [self otaLog:@"mFwVersion:%@", mFwVersion];
    }
    return NO;
}

- (void)checkRemoteStatus:(NSString *)fwVersion mode:(int)mode {
    NSMutableArray *tlvs = [NSMutableArray array];
    
    NSData *fwVersionByte = [fwVersion dataUsingEncoding:NSUTF8StringEncoding];
    NSData *tlv = [self assembleTLV:0x01 length:fwVersionByte.length value:fwVersionByte];
    [tlvs addObject:tlv];
    
    uint8_t valueSize[] = {0x00, 0x00};
    NSMutableData *valueSizeD = [NSMutableData data];
    [valueSizeD appendBytes:valueSize length:sizeof(valueSize)];
    tlv = [self assembleTLV:0x02 length:0x02 value:valueSizeD];
    [tlvs addObject:tlv];
    
    if (mVRAM == nil || mVRAM.length == 0) {
        uint8_t byte[16] = {0};
        mVRAM = [NSData dataWithBytes:byte length:16];
    }
    tlv = [self assembleTLV:0x03 length:mVRAM.length value:mVRAM];
    [tlvs addObject:tlv];
    
    uint8_t valueMode[] = {mode};
    NSData *valueModeByte = [NSData dataWithBytes:valueMode length:1];
    tlv = [self assembleTLV:0x04 length:0x01 value:valueModeByte];
    [tlvs addObject:tlv];
    
    uint8_t valueFeature[] = {0x01};
    NSData *valueFeatureByte = [NSData dataWithBytes:valueFeature length:1];
    tlv = [self assembleTLV:0x09 length:0x01 value:valueFeatureByte];
    [tlvs addObject:tlv];
    
    NSData *buffer = [self assembleCommand:0x09 commandID:0x01 subTLVs:tlvs];
    [self write:buffer];
}

- (NSData *)assembleTLV:(NSInteger)type length:(NSInteger)length value:(NSData *)value {
    NSMutableData *buffer = [[NSMutableData alloc] init];

    uint8_t typeB = type & 0xFF;
    
    uint8_t lengthB[2];
    for (int i = 0; i < 2; i++) {
        lengthB[i] = (length >> (8 * i)) & 0xFF;
    }
    
    [buffer appendBytes:&typeB length:1];
    [buffer appendBytes:lengthB length:2];
    if (value != nil && value.length > 0) {
        [buffer appendData:value];
    }
    
    return buffer;
}

- (NSData *)assembleCommand:(NSInteger)serverID commandID:(NSInteger)commandID subTLVs:(NSArray *)subTLVs {
    NSInteger subTLVslen = 0;
    if (subTLVs != nil && subTLVs.count > 0) {
        for (NSData *tlv in subTLVs) {
            subTLVslen += tlv.length;
        }
    }
    
    NSData *superTLV = [self assembleTLV:0x80 length:subTLVslen value:nil];
    
    NSMutableData *buffer = [[NSMutableData alloc] init];
    
    uint8_t serverIDB = serverID & 0xFF;
    uint8_t commandIDB = commandID & 0xFF;
    
    [buffer appendBytes:&serverIDB length:1];
    [buffer appendBytes:&commandIDB length:1];
    [buffer appendData:superTLV];
    
    if (subTLVs != nil && subTLVs.count > 0) {
        for (NSData *tlv in subTLVs) {
            [buffer appendData:tlv];
        }
    }
    
    return buffer;
}

- (void)notifyRemoteAppReady:(NSInteger)state {
    NSMutableArray *tlvs = [NSMutableArray array];
    
    uint8_t data = (uint8_t)state;
    NSData *value = [NSData dataWithBytes:&data length:1];

    NSData *tlv = [self assembleTLV:0x01 length:0x01 value:value];
    [tlvs addObject:tlv];
    
    NSData *buffer = [self assembleCommand:0x09 commandID:0x09 subTLVs:tlvs];
    [self write:buffer];
}

- (NSArray *)readFile:(NSData *)fileData offset:(NSInteger)offset length:(NSInteger)length bitmap:(uint8_t *)bitmap bitmapLen:(NSInteger)bitMapLen groupNum:(NSInteger)groupNum {
    
    NSInteger *pkgIdx = [BitmapUtils getZeroBitIndexMap:bitmap length:bitMapLen groupNum:groupNum];
    
    NSInteger dataLen = fileData.length;
    
    NSMutableArray *packages = [NSMutableArray array];
    
    for (int i = 0; i < groupNum; i++) {
        NSInteger odd = length - pkgIdx[i] * mOtaUnit;
        
        if (odd <= 0) {
            break;
        }
        
        NSInteger o = offset + pkgIdx[i] * mOtaUnit;
        [self otaLog:@"o:%ld", o];
        
        NSInteger len = odd > mOtaUnit ? mOtaUnit : odd;
        [self otaLog:@"len:%ld", len];
        
        if (dataLen - (o + len) < 0) {
            [self otaLog:@"dataLen: %ld, o:%ld ,len:%ld", dataLen, o, len];
            
            break;
        }
        
        if (dataLen - o < len) {
            len = dataLen - o;
        }
        
        [self otaLog:@"len2:%ld", len];
        
        NSData *pkg = [fileData subdataWithRange:NSMakeRange(o, len)];
        [packages addObject:pkg];
    }
    free(pkgIdx);
    return packages;
}

- (void)requestRemoteParameters {
    NSData *buffer = [self assembleCommand:0x09 commandID:0x02 subTLVs:nil];
    [self write:buffer];
}

- (NSURL *)getFileURLInDocumentsDirectory:(NSString *)fileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // 获取 Documents 目录的 URL
    NSURL *documentsDirectoryURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
    
    // 拼接文件路径
    return [documentsDirectoryURL URLByAppendingPathComponent:fileName];
}

#pragma mark -- 回调部分
- (void)write:(NSData *)data {
//    NSLog(@"write data");
    if (_delegate && [_delegate respondsToSelector:@selector(sendOtaData:)]) {
        [_delegate sendOtaData:data];
    }
}

- (void)onStatus:(NSInteger)state {
    if (curStatus == state) {
        return;
    }
    curStatus = state;
    if (_delegate && [_delegate respondsToSelector:@selector(onOtaStatus:)]) {
        [_delegate onOtaStatus:state];
    }
}
 
- (void)onAudioDataReceived:(NSInteger)psn len:(NSInteger)len data:(NSData *)data {
    if (_delegate && [_delegate respondsToSelector:@selector(onOtaAudioDataReceived:len:data:)]) {
        [_delegate onOtaAudioDataReceived:psn len:len data:data];
    }
}

- (void)onRemoteStatusReceived:(RemoteStatus *)status {
    if (_delegate && [_delegate respondsToSelector:@selector(onOtaRemoteStatusReceived:)]) {
        [_delegate onOtaRemoteStatusReceived:status];
    }
}

- (void)onProgress:(NSInteger)progress total:(NSInteger)total {
    if (_delegate && [_delegate respondsToSelector:@selector(onOtaProgress:total:)]) {
        [_delegate onOtaProgress:progress total:total];
    }
}

- (void)onError:(NSInteger)errCode errMsg:(NSString *)errMsg {
    if (errMsg == nil) {
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(onOtaError:errMsg:)]) {
        [_delegate onOtaError:errCode errMsg:errMsg];
    }
}

- (void)onWriteBytes:(NSInteger)count {
    if (_delegate && [_delegate respondsToSelector:@selector(onOtaWriteBytes:)]) {
        [_delegate onOtaWriteBytes:count];
    }
}

#pragma mark -- 数据解析
- (void)analysisData:(NSData *)data {
    if (!mRunning) {
        return;
    }
    
//    NSLog(@"data:%@", data);
    uint8_t *dataArray = (uint8_t *)[data bytes];
    NSInteger dataLen = [data length];
    
    int index = 0;
    
    int serviceID = *dataArray & 0xFF;
    if (serviceID != 0x09) {
        return;
    }
    index ++;
    
    int commandID = *(dataArray + index) & 0xFF;
    index ++;
    [self otaLog:@"service:%d, command:%d", serviceID, commandID];
    
    switch (commandID) {
        case 0x01: {
            index ++;
            int sublen1 = *(dataArray + index++) & 0xFF;
            int sublen2 = *(dataArray + index++) & 0xFF;
            int subTLVsLen = sublen1 + (sublen2 << 8);
            if (subTLVsLen < 7) {
                [self otaLog:@"01 < 7"];
                break;
            }
            
            if (*(dataArray + index) != 0x7F) {
                [self otaLog:@"*(dataArray + index) != 0x7F"];
                break;
            }
            
            index += 3;
            NSInteger errCode = [OtaUtils byteArrayToInt:dataArray offset:index];
            [self otaLog:@"errCode:%ld", errCode];
            index += 4;
            
            [self stopTimer];
            
            RemoteStatus *status = [[RemoteStatus alloc] init];
            [self otaLog:@"index:%d, subTLVSlen:%d", index, subTLVsLen];
            for (; index - 2 < subTLVsLen;) {
                int type = *(dataArray + index++) & 0xFF;
                int len = *(dataArray + index++) & 0xFF;
                len += (*(dataArray + index ++) << 8);
                [self otaLog:@"index:%d, type:%d, len:%d", index, type, len];
                
                switch (type) {
                    case 0x04: {
                        int battery = *(dataArray + index++) & 0xFF;
                        [self otaLog:@"battery:%d", battery];
                        [status setBatteryThreshold:[NSNumber numberWithInt:battery]];
                    }
                        break;
                        
                    case 0x05: {
                        uint8_t *ver = (uint8_t *)malloc(len);
                        memcpy(ver, dataArray + index, len);
                        NSString *versionName = [NSString stringWithUTF8String:(char *)ver];
                        [self otaLog:@"versionName:%@", versionName];
                        [status setVersionName:versionName];
                        index += len;
                        free(ver);
                    }
                        break;
                        
                    case 0x06: {
                        uint8_t *board = (uint8_t *)malloc(len);
                        memcpy(board, dataArray + index, len);
                        NSString *boardName = [NSString stringWithUTF8String:(char *)board];
                        [self otaLog:@"boardName:%@", boardName];
                        [status setBoardName:boardName];
                        index += len;
                        free(board);
                    }
                        break;
                        
                    case 0x07: {
                        uint8_t *hardware = (uint8_t *)malloc(len);
                        memcpy(hardware, dataArray + index, len);
                        NSString *hardwareRev = [NSString stringWithUTF8String:(char *)hardware];
                        [self otaLog:@"hardwareRev:%@", hardwareRev];
                        [status setHardwareRev:hardwareRev];
                        index += len;
                        free(hardware);
                    }
                        break;
                        
                    case 0x08: {
                        NSInteger versionCode = [OtaUtils byteArrayToInt:dataArray offset:index];
                        [self otaLog:@"versionCode:%ld", versionCode];
                        [status setVersionCode:[NSNumber numberWithInteger:versionCode]];
                        index += 4;
                    }
                        break;
                        
                    case 0x09: {
                        int featureSupport = *(dataArray + index++) & 0xFF;
                        [self otaLog:@"featureSupport:%d", featureSupport];
                        
                        [status setFeatureSupport:[NSNumber numberWithInt:featureSupport]];
                        
                        mRemoteCrcSupport = ((featureSupport & 0x01) == 0x01);
                    }
                        break;
                        
                    default:
                        index += len;
                        break;
                }
            }
            
            if (errCode == 100000) {
                [self onRemoteStatusReceived:status];
                [self onStatus:STATE_PREPARED];
                mIsTranFinish = NO;
            } else {
                if (errCode == 110000) {
                    [self onError:errCode errMsg:MESSAGE_BIN_ERR];
                } else {
                    [self onError:errCode errMsg:MESSAGE_UNKNOWN];
                }
            }
        }
            
            break;
            
        case 0x02: {
            index ++;
            int sublen1 = *(dataArray + index++) & 0xFF;
            int sublen2 = *(dataArray + index++) & 0xFF;
            int subTLVsLen = sublen1 + (sublen2 << 8);
            if (subTLVsLen < 24) {
                [self otaLog:@"02 < 24"];
                break;
            }
            index += 3;
            
            mWaitTimeout = [OtaUtils byteArrayToShort:dataArray offset:index];
            index += 2;
            
            index += 3;
            mRestartTimeout = [OtaUtils byteArrayToShort:dataArray offset:index];
            
            index += 2;
            
            index += 3;
            mOtaUnit = [OtaUtils byteArrayToShort:dataArray offset:index];
            
            index += 2;
            
            index += 3;
            mInterval = [OtaUtils byteArrayToShort:dataArray offset:index];
            
            index += 2;
            
            index += 3;
            mAckEnable = [OtaUtils byteArrayToShort:dataArray offset:index];
            index ++;
            
            [self stopTimer];
            [self notifyRemoteAppReady:1];
        }
            break;
            
        case 0x03: {
            [self otaLog:@"0903"];
            if (mOtaUnit == 0) {
                mOtaUnit = OTA_UNIT_DEFAULT;
            }
            [self onStatus:STATE_TRANSFERRING];
            
            index ++;
            int sublen1 = *(dataArray + index++) & 0xFF;
            int sublen2 = *(dataArray + index++) & 0xFF;
            int subTLVsLen = sublen1 + (sublen2 << 8);
            if (subTLVsLen < 14) {
                [self otaLog:@"03 < 14"];
                break;
            }
            [self otaLog:@"AckEnable:%ld", mAckEnable];
            if (mAckEnable == 1) {
                uint8_t *buffer = (uint8_t *)malloc((5 + subTLVsLen) * sizeof(uint8_t));
                
                buffer[0] = 0x09;
                buffer[1] = 0x03;
                buffer[2] = 0x80;
                buffer[3] = (uint8_t)subTLVsLen;
                buffer[4] = (uint8_t)(subTLVsLen >> 8);
                
                memcpy(buffer + 5, dataArray + 2, subTLVsLen);
                
                NSData *buf = [NSData dataWithBytes:buffer length:(5 + subTLVsLen)];
            
                [self write:buf];
                free(buffer);
            }

            index += 3;
            NSInteger offset = [OtaUtils byteArrayToInt:dataArray offset:index];
            index += 4;
            
            index += 3;
            NSInteger length = [OtaUtils byteArrayToInt:dataArray offset:index];
            index += 4;
            
            if (subTLVsLen > 17) {
                index ++;
                NSInteger len = [OtaUtils byteArrayToShort:dataArray offset:index];
                
                index += 2;
                [self otaLog:@"03 index:%d", index];
                if (subTLVsLen >= 17 + len) {
                    uint8_t *bitmap = (uint8_t *)malloc(len * sizeof(uint8_t));
                    
                    [self otaLog:@"dataLen:%ld, index:%d, len:%ld", dataLen, index, len];
                    
                    memcpy(bitmap, dataArray + index, len);
                    
                    NSInteger groupNum = length / mOtaUnit + 1;
                    
                    NSArray *frames = [self readFile:fileData offset:offset length:length bitmap:bitmap bitmapLen:len groupNum:groupNum];
                    
                    free(bitmap);
                    
                    if (frames == nil || frames.count == 0) {
                        [self otaLog:@"frames == nil"];
                        break;
                    }
                    
                    for (int i = 0; i < frames.count; i++) {
                        NSData *frameData = [frames objectAtIndex:i];
                        NSInteger contentLen = frameData.length;
                        
                        uint8_t *buffer;
                        NSInteger bufLen;
                        
                        if (mRemoteCrcSupport) {
                            buffer = (uint8_t *)malloc((10 + contentLen) * sizeof(uint8_t));
                            bufLen = 10 + contentLen;
                            
                            buffer[0] = 0x09;
                            buffer[1] = 0x0B;
                            buffer[2] = 0x80;
                            buffer[3] = (contentLen + 5);
                            buffer[4] = (contentLen + 5) >> 8;
                            buffer[5] = i % 256;
                            
                            NSInteger checksum = [OtaUtils crc32:[frames objectAtIndex:i]];
                            
                            buffer[6] = checksum;
                            buffer[7] = checksum >> 8;
                            buffer[8] = checksum >> 16;
                            buffer[9] = checksum >> 24;
                            
                            
                            memcpy(buffer + 10, [frameData bytes], contentLen);
                        } else {
                            buffer = (uint8_t *)malloc((6 + contentLen) * sizeof(uint8_t));
                            
                            bufLen = 6 + contentLen;
                            
                            buffer[0] = 0x09;
                            buffer[1] = 0x04;
                            buffer[2] = 0x80;
                            buffer[3] = (contentLen + 1);
                            buffer[4] = (contentLen + 1) >> 8;
                            buffer[5] = i % 256;
                            
                            memcpy(buffer + 6, [frameData bytes], contentLen);
                            
                        }
                        
                        NSData *buf = [NSData dataWithBytes:buffer length:bufLen];
                        
                        [self write:buf];
                        mWriteBytes += buf.length;
                        [self onWriteBytes:mWriteBytes];
                        free(buffer);
                    }
                    [self onProgress:offset + length total:fileData.length];
                }
            }
        }
            break;
            
        case 0x05: {
            index ++;
            int sublen1 = *(dataArray + index++) & 0xFF;
            int sublen2 = *(dataArray + index++) & 0xFF;
            int subTLVsLen = sublen1 + (sublen2 << 8);
            if (subTLVsLen < 14) {
                [self otaLog:@"05 < 14"];
                break;
            }
            index += 3;
            NSInteger pkgValidSize = [OtaUtils byteArrayToInt:dataArray offset:index];
            index += 4;
            
            index += 3;
            
            NSInteger receivedSize = [OtaUtils byteArrayToInt:dataArray offset:index];
            
            [self otaLog:@"receive 0905 pkgValidSize:%ld, receivedSize:%ld", pkgValidSize, receivedSize];
            
        }
            break;
            
        case 0x06: {
            index ++;
            int sublen1 = *(dataArray + index++) & 0xFF;
            int sublen2 = *(dataArray + index++) & 0xFF;
            int subTLVsLen = sublen1 + (sublen2 << 8);
            if (subTLVsLen < 4) {
                [self otaLog:@"06 < 4"];
                break;
            }
            index += 3;
            
            NSInteger valid = *(dataArray + index++) & 0xFF;
            
            NSData *buffer = [self assembleCommand:0x09 commandID:0x06 subTLVs:nil];
            [self write:buffer];
            
            
            
            
            if (valid == 1) {
                [self onStatus:STATE_TRANSFERRED];
                mIsTranFinish = YES;
            } else {
                [self onError:PACKAGE_INVALID errMsg:MESSAGE_PACKAGE_INVALID];
            }
        }
            break;
            
        case 0x07: {
            int sign = *(dataArray + index++);
            int sublen1 = *(dataArray + index++) & 0xFF;
            int sublen2 = *(dataArray + index++) & 0xFF;
            int subTLVsLen = sublen1 + (sublen2 << 8);
            if (subTLVsLen < 7) {
                [self otaLog:@"07 < 7"];
                break;
            }
            
            if (sign == 0x7F) {
                NSInteger errCode = [OtaUtils byteArrayToInt:dataArray offset:index];
                if (errCode != 100000) {
                    [self onError:errCode errMsg:MESSAGE_UNKNOWN];
                }
            }
        }
            break;
            
        case 0x7D: {
            int type = *(dataArray + index++) & 0xFF;
            int sublen1 = *(dataArray + index++) & 0xFF;
            int sublen2 = *(dataArray + index++) & 0xFF;
            
            NSInteger len = sublen1 + (sublen2 << 8);
        
            int psn = *(dataArray + index++) & 0xFF;
            
            type = *(dataArray + index++) & 0xFF;
            
            len = [OtaUtils byteArrayToShort:dataArray offset:index];
            index += 2;
            
            uint8_t *buf = (uint8_t *)malloc(len);
            
            memcmp(buf, dataArray + index, len);
            
            NSData *buffer = [NSData dataWithBytes:buf length:len];
            
            [self onAudioDataReceived:psn len:len data:buffer];
            free(buf);
        }
            break;
    }
    
}

#pragma mark -- 计时器
- (void)startTimer {
    timer = [NSTimer scheduledTimerWithTimeInterval:OTA_TIME_OUT target:self selector:@selector(pullThread) userInfo:nil repeats:YES];
}

- (void)stopTimer {
    if (timer != nil) {
        [timer invalidate];
        timer = nil;
    }
}

- (void)pullThread {
    
}

@end
