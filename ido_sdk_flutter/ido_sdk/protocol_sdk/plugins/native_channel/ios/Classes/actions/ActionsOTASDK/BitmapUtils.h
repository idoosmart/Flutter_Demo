//
//  BitmapUtils.h
//  ActionsUtils
//
//  Created by 林韦辰 on 2025/2/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BitmapUtils : NSObject

+ (NSInteger *)getZeroBitIndexMap:(uint8_t *)bitmap length:(NSInteger)length groupNum:(NSInteger)groupNum;

@end

NS_ASSUME_NONNULL_END
