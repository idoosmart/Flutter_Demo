//
//  FontSelectModel.h
//  CustomDial
//
//  Created by qiao liwei on 2023/8/14.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, FONT_TYPE) {
    FONT_TYPE_ONE = 109,//时间左上角
    FONT_TYPE_TWO,
    FONT_TYPE_THREE,
    FONT_TYPE_MAX
};

NS_ASSUME_NONNULL_BEGIN

@interface FontSelectModel : NSObject
@property (nonatomic, assign) bool isSelected;
@property (nonatomic, assign) FONT_TYPE font;
@property (nonatomic, assign) UInt32 color;

@end

NS_ASSUME_NONNULL_END
