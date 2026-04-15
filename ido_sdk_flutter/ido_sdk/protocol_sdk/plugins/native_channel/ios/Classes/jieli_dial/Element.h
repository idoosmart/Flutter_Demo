//
//  Element.h
//  DHSFit
//
//  Created by liwei qiao on 2023/8/11.
//

#import <Foundation/Foundation.h>

#define PREVIEW_WIDTH 164
#define PREVIEW_HEIGHT 191

#define DIAL_WIDTH 240
#define DIAL_HEIGHT 284

NS_ASSUME_NONNULL_BEGIN

@interface Element : NSObject
@property (nonatomic, assign) int offset;
@property (nonatomic, assign) int index;
@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;
@property (nonatomic, assign) int x;
@property (nonatomic, assign) int y;
@property (nonatomic, assign) Byte imageCount;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) int hasAlpha;
@property (nonatomic, assign) Byte anchor;
@property (nonatomic, assign) Byte blackTransparent;
@property (nonatomic, assign) int compression;
@property (nonatomic, assign) Byte leftOffset;
@property (nonatomic, assign) int size;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, assign) int fontType;



@end

NS_ASSUME_NONNULL_END
