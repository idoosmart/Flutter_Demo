//
//  BackgroundSelectModel.h
//  CustomDial
//
//  Created by qiao liwei on 2023/8/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BackgroundSelectModel : NSObject
@property (nonatomic, strong) UIImage *backgroundImage;
@property (nonatomic, assign) bool isSelected;

@end

NS_ASSUME_NONNULL_END
