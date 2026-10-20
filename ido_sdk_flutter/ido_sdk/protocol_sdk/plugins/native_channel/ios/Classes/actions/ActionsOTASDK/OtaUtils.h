//
//  LogUtils.h
//  ActionsUtils
//
//  Created by 林韦辰 on 2025/2/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OtaUtils : NSObject

+ (NSInteger)byteArrayToShort:(uint8_t *)data offset:(NSInteger)offset;

+ (long)byteToLong:(NSData *)data;

+ (NSInteger)byteArrayToInt:(uint8_t *)data offset:(NSInteger)offset;

+ (NSInteger)crc32:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
