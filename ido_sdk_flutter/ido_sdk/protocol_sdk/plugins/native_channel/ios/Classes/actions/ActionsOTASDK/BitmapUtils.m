//
//  BitmapUtils.m
//  ActionsUtils
//
//  Created by 林韦辰 on 2025/2/20.
//

#import "BitmapUtils.h"

@implementation BitmapUtils

+ (NSInteger *)getZeroBitIndexMap:(uint8_t *)bitmap length:(NSInteger)length groupNum:(NSInteger)groupNum {
    NSInteger *array = malloc(sizeof(NSInteger) * groupNum);
    int count = 0;
    int index = 0;
    
    for (int i = 0; i < length; i ++) {
        uint8_t b = *(bitmap + i);
        for (int j = 0; j < groupNum; j++) {
            int offset = (index % groupNum);
            
            if ((b & (0x01 << offset)) == 0x00) {
                array[count] = index;
                count ++;
            }
            
            index ++;
        }
    }
    return array;
}

@end
