//
//  PlacementSelectModel.h
//  DHSFit
//
//  Created by liwei qiao on 2023/8/12.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PLACEMENT_TYPE) {
    PLACEMENT_LEFT_TOP = 100,//时间左上角
    PLACEMENT_CENTER_TOP,
    PLACEMENT_RIGHT_TOP,
    PLACEMENT_LEFT_CENTER,
    PLACEMENT_CENTER_CENTER,
    PLACEMENT_RIGHT_CENTER,
    PLACEMENT_LEFT_BOTTOM,
    PLACEMENT_CENTER_BOTTOM,
    PLACEMENT_RIGHT_BOTTOM,
    PLACEMENT_MAX
};

NS_ASSUME_NONNULL_BEGIN

@interface PlacementSelectModel : NSObject
//背景图
@property (nonatomic, strong) UIImage *backgroundImage;
//文字图
@property (nonatomic, strong) UIImage *textImage;
//是否选中
@property (nonatomic, assign) bool isSelected;
//文字布局
@property (nonatomic, assign) PLACEMENT_TYPE placement;
//颜色
@property (nonatomic, assign) UInt32 color;

/**
 * 根据所选的元素，重新画一张图片
 */
- (UIImage *)composeImage;


@end

NS_ASSUME_NONNULL_END
