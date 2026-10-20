//
//  ActVersion.h
//  ActionsUtils
//
//  Created by 林韦辰 on 2025/2/19.
//

#import <Foundation/Foundation.h>
#import "OtaUtils.h"

#define HEAD_NAME               @"head_name"
#define BIN_SIZE                @"bin_size"
#define XML_SIZE                @"xml_size"
#define VERSION_CODE            @"version_code"
#define BOARD_NAME              @"board_name"

#define ERROR_CODE              @"-1"

NS_ASSUME_NONNULL_BEGIN

@interface ActVersion : NSObject

+ (NSString *)getBinMsg:(NSData *)fileData;

@end

NS_ASSUME_NONNULL_END
