//
//  CustomDialUtils.h
//  CustomDial
//
//  Created by qiao liwei on 2023/8/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BackgroundSelectModel.h"
#import "FontSelectModel.h"
#import "ColorSelectModel.h"
#import "PlacementSelectModel.h"
#import "Element.h"

typedef NS_ENUM(NSInteger, WatchfaceElementType) {
    Element_PREVIEW = 1,//
    Element_BACKGROUND = 0x02,
    Element_YEAR = 0x06,
    Element_MONTH = 0x07,
    Element_DAY = 0x08,
    Element_HOUR = 0x09,
    Element_MINUTE = 0x0a,
    Element_AM_PM = 0x0c,
    Element_ICON = 0x16,
    Element_WEEK = 0x0d,
    Element_Max
};

NS_ASSUME_NONNULL_BEGIN

@interface CustomDialUtils : NSObject

+ (UIColor *)colorWithHex:(UInt32)hexColor;

+ (UIImage *)scaleImage:(UIImage *)image
                toWidth:(NSInteger)widthSize
                 height:(NSInteger)heightSize;

//+ (NSMutableArray <PlacementSelectModel *>*)makePlacementData:(BackgroundSelectModel *)selectBg
//              font:(FontSelectModel *)selectFont
//             color:(ColorSelectModel *)selectColor;

+ (PlacementSelectModel *)makePlacementData:(BackgroundSelectModel *)selectBg
                                 font:(FontSelectModel *)selectFont
                                color:(ColorSelectModel *)selectColor
                              prewImagePath:(NSString *)prewImagePath;

+ (Element *)getPreviewDataBean:(UIImage *)bgImage
                      textImage:(UIImage *)textImage
                          color:(UInt32)color;

+ (UIImage *)replaceColorPix:(UInt32)hexColor originalImage:(UIImage *)src;

/// 生成N022B自定义表盘数据
/// @param bgImage 更改的背景图  尺寸和bin文件需要对应
/// @param textImage  显示时间等文字图  位置与placementType对应
/// @param setColor 更改的颜色值
/// @param binData 资源bin
+ (NSData *)getN022BCustomDialDataWithBGImage:(UIImage *)bgImage
                                    textImage:(UIImage *)textImage
                                  setColorHex:(UInt32)setColor
                                   srcBinData:(NSData *)binData;

/// 生成N022B自定义表盘数据
/// @param bgImagePath 更改的背景图  尺寸和bin文件需要对应
/// @param textImagePath  显示时间等文字图  位置与placementType对应
/// @param setColor 更改的颜色值
/// @param binFilePath 资源bin
/// @param savePath 保存路径  生成好的表盘文件路径
/// @return 制作好的表盘文件路径
+ ( NSString * _Nullable )getN022BCustomDialDataWithBGImagePath:(NSString *)bgImagePath
                                    textImagePath:(NSString *)textImagePath
                                      setColorHex:(UInt32)setColor
                                       srcBinPath:(NSString *)binFilePath 
                                       savePath:(NSString *)savePath;

@end

NS_ASSUME_NONNULL_END
