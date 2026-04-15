//
//  PlacementSelectModel.m
//  DHSFit
//
//  Created by liwei qiao on 2023/8/12.
//

#import "PlacementSelectModel.h"
#import "FontSelectModel.h"
#import "CustomDialUtils.h"

@implementation PlacementSelectModel


- (UIImage *)composeImage
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(DIAL_WIDTH, DIAL_HEIGHT), NO, 1.0);
    [self.backgroundImage drawInRect:CGRectMake(0, 0, DIAL_WIDTH, DIAL_HEIGHT)];

    CGContextRef context = UIGraphicsGetCurrentContext();
        
    UIImage *weekImage = self.textImage;
    UIImage *weekReplaceImage = [CustomDialUtils replaceColorPix:self.color originalImage:weekImage];
    [weekReplaceImage drawInRect:CGRectMake(0, 0, DIAL_WIDTH, DIAL_HEIGHT)];
    
    
//    CGContextSetAllowsAntialiasing(context, YES);
//    CGContextSetShouldAntialias(context, YES);

    UIImage *combinedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return combinedImage;
}

- (UIImage *)composeImageZH
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(DIAL_WIDTH, DIAL_HEIGHT), NO, 1.0);
    
    // 绘制背景图像
    [self.backgroundImage drawInRect:CGRectMake(0, 0, DIAL_WIDTH, DIAL_HEIGHT)];
    
    // 获取当前上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 保存上下文状态
    CGContextSaveGState(context);
    
    // 设置混合模式以考虑透明度
    CGContextSetBlendMode(context, kCGBlendModeNormal); // 设置正常混合模式
    
    // 绘制文本图像并应用颜色替换
    UIImage *weekImage = self.textImage;
    weekImage = [CustomDialUtils replaceColorPix:self.color originalImage:weekImage];
    
    // 绘制文本图像
    [weekImage drawInRect:CGRectMake(0, 0, DIAL_WIDTH, DIAL_HEIGHT)];
    
    // 恢复上下文状态
    CGContextRestoreGState(context);
    
    // 完成图像合成
    UIImage *combinedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return combinedImage;
}







@end
