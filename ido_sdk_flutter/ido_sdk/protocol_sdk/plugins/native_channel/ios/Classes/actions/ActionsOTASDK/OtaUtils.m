//
//  LogUtils.m
//  ActionsUtils
//
//  Created by 林韦辰 on 2025/2/18.
//

#import "OtaUtils.h"

@implementation OtaUtils

+ (long)byteToLong:(NSData *)data {
    const uint8_t *byteData = [data bytes];
    
    long l64 = 0;
    l64 = byteData[0] & 0xFF;
    l64 |= (byteData[1] & 0xFF) << 8;
    l64 |= (byteData[2] & 0xFF) << 16;
    l64 |= (byteData[3] & 0xFF) << 24;
    
    return l64;
}

+ (NSInteger)byteArrayToShort:(uint8_t *)data offset:(NSInteger)offset {
    NSInteger res = (*(data + offset) & 0xFF) |
                    ((*(data + offset + 1) & 0xFF) << 8 );
    return res;
}

+ (NSInteger)byteArrayToInt:(uint8_t *)data offset:(NSInteger)offset {
    NSInteger res = (*(data + offset) & 0xFF) |
                    ((*(data + offset + 1) & 0xFF) << 8) |
                    ((*(data + offset + 2) & 0xFF) << 16) |
                    ((*(data + offset + 3) & 0xFF) << 24);
    return res;
}

+ (NSInteger)crc32:(NSData *)data {
    NSInteger *table = malloc(sizeof(NSInteger) * 256);
    NSInteger crc = 0xffffffff;
    uint8_t *bytes = (uint8_t *)[data bytes];
    
    for (NSInteger i=0; i<256; i++) {
        table[i] = i;
        for (int j=0; j<8; j++) {
            if (table[i] & 1) {
                table[i] = (table[i] >>= 1) ^ 0xedb88320;
            } else {
                table[i] >>= 1;
            }
        }
    }
    
    for (int i=0; i<data.length; i++) {
        crc = (crc >> 8) ^ table[crc & 0xff ^ bytes[i]];
    }
    crc ^= 0xffffffff;
    
    free(table);
    return crc;
}

@end
