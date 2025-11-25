//
//  ImageConvertor.h
//  eZIPSDK
//
//  Created by Sifli on 2021/11/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, SFBoardType) {
    SFBoardType55X,
    SFBoardType56X,
    SFBoardType52X,
};

@interface ImageConvertor : NSObject


///// png格式文件转为ezipBin类型。转换失败返回nil。
///// @param pngData png文件数据
///// @param eColor 颜色字符串
///// @param eType eizp类型
///// @param binType bin类型
//+(nullable NSData *)EBinFromPNGData:(NSData *)pngData eColor:(NSString *)eColor eType:(uint8_t)eType binType:(uint8_t)binType;


/// png格式文件转为ezipBin类型。转换失败返回nil。V2.1
/// @param pngData png文件数据
/// @param eColor 颜色字符串 color type as below: rgb565, rgb565A, rbg888, rgb888A
/// @param eType eizp类型 0 keep original alpha channel;1 no alpha chanel
/// @param binType bin类型 0 to support rotation; 1 for no rotation
/// @param boardType 主板类型 @See SFBoardType 0:55x 1:56x  2:52x
/// @return ezip or apng result, nil for fail
+(nullable NSData *)EBinFromPNGData:(NSData *)pngData
                             eColor:(NSString *)eColor
                              eType:(uint8_t)eType
                            binType:(uint8_t)binType
                          boardType:(SFBoardType)boardType;


/// Nor 方案 将png格式文件序列转为ezipBin类型。转换失败返回nil。V2.2
/// @param pngDatas png文件数据序列
/// @param eColor 颜色字符串 color type as below: rgb565, rgb565A, rbg888, rgb888A
/// @param eType eizp类型 0 keep original alpha channel;1 no alpha chanel
/// @param binType bin类型 0 to support rotation; 1 for no rotation
/// @param boardType 主板类型 @See SFBoardType 0:55x 1:56x  2:52x
/// @return ezip or apng result, nil for fail
+(nullable NSData *)EBinFromPngSequence:(NSArray<NSData *> *)pngDatas
                               eColor:(NSString *)eColor
                                eType:(uint8_t)eType
                              binType:(uint8_t)binType
                            boardType:(SFBoardType)boardType;
@end

NS_ASSUME_NONNULL_END
